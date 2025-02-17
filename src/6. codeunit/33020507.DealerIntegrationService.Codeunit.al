codeunit 33020507 "Dealer Integration Service"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: Label '%1 is not allowed for the %2 web service.';
        Text002: Label '%1 is not initialized.';
        Text003: Label '%1 does not have a definition for the %2 field.';
        Text004: Label 'The service is not a Microsoft Dynamics NAV page service.\\%1';
        Text005: Label 'Field %1 does not exist for the %2 web service.';
        Text006: Label '%1 does not have lines.';
        Text007: Label 'Line';
        Text008: Label 'Unhandled type: %1.';
        Assembly: DotNet Assembly;
        ServiceType: DotNet Type;
        EntityType: DotNet Type;
        FilterType: DotNet Type;
        FieldsType: DotNet Type;
        LineType: DotNet Type;
        Entity: DotNet Object;
        Line: DotNet Object;
        Entities: DotNet Array;
        Filters: DotNet List_Of_T;
        Lines: DotNet List_Of_T;
        LinesProperty: DotNet PropertyInfo;
        Activator: DotNet Activator;
        _Read: DotNet MethodInfo;
        _ReadByRecId: DotNet MethodInfo;
        _ReadMultiple: DotNet MethodInfo;
        _IsUpdated: DotNet MethodInfo;
        _GetRecIdFromKey: DotNet MethodInfo;
        _Create: DotNet MethodInfo;
        _CreateMultiple: DotNet MethodInfo;
        _Update: DotNet MethodInfo;
        _UpdateMultiple: DotNet MethodInfo;
        _Delete: DotNet MethodInfo;
        ServiceUri: Text;
        Name: Text;
        AssertAllowedOperationName: Text;
        GetNull: Boolean;
        Cursor: Integer;
        _ExecuteGetData: DotNet MethodInfo;
        Path: Text;
        DealerIntegrationService: Codeunit "33020507";

    [Scope('Internal')]
    procedure CONNECT(Uri: Text)
    var
        WebRequest: DotNet WebRequest;
        RequestStream: DotNet Stream;
        ServiceDescription: DotNet ServiceDescription;
        ServiceDescriptionImporter: DotNet ServiceDescriptionImporter;
        ServiceDescriptionImportWarnings: DotNet ServiceDescriptionImportWarnings;
        CodeNamespace: DotNet CodeNamespace;
        CodeCompileUnit: DotNet CodeCompileUnit;
        CodeCompileUnitArray: DotNet Array;
        CodeGenerationOptions: DotNet CodeGeneratorOptions;
        CompilerParameters: DotNet CompilerParameters;
        CompilerResults: DotNet CompilerResults;
        StringWriter: DotNet StringWriter;
        CultureInfo: DotNet CultureInfo;
        CSharpCodeProvider: DotNet CSharpCodeProvider;
        AssemblyReferences: DotNet Array;
        String: DotNet String;
    begin
        ServiceUri := Uri;

        WebRequest := WebRequest.Create(ServiceUri);
        Authenticate(WebRequest);
        RequestStream := WebRequest.GetResponse().GetResponseStream();

        ServiceDescription := ServiceDescription.Read(RequestStream);
        ServiceDescriptionImporter := ServiceDescriptionImporter.ServiceDescriptionImporter();
        ServiceDescriptionImporter.AddServiceDescription(ServiceDescription, '', '');
        ServiceDescriptionImporter.ProtocolName := 'SOAP';
        ServiceDescriptionImporter.CodeGenerationOptions := 1; // GenerateProperties

        CodeNamespace := CodeNamespace.CodeNamespace();
        CodeCompileUnit := CodeCompileUnit.CodeCompileUnit();
        CodeCompileUnit.Namespaces.Add(CodeNamespace);

        ServiceDescriptionImportWarnings := ServiceDescriptionImporter.Import(CodeNamespace, CodeCompileUnit);
        IF ServiceDescriptionImportWarnings = 0 THEN BEGIN
            StringWriter := StringWriter.StringWriter(CultureInfo.CurrentCulture);
            CSharpCodeProvider := CSharpCodeProvider.CSharpCodeProvider();
            CSharpCodeProvider.GenerateCodeFromNamespace(CodeNamespace, StringWriter, CodeGenerationOptions.CodeGeneratorOptions);

            AssemblyReferences := AssemblyReferences.CreateInstance(GETDOTNETTYPE(String), 2);
            AssemblyReferences.SetValue('System.Web.Services.dll', 0);
            AssemblyReferences.SetValue('System.Xml.dll', 1);

            CompilerParameters := CompilerParameters.CompilerParameters(AssemblyReferences);
            CompilerParameters.GenerateExecutable := FALSE;
            CompilerParameters.GenerateInMemory := TRUE;
            CompilerParameters.TreatWarningsAsErrors := TRUE;
            CompilerParameters.WarningLevel := 4;

            CodeCompileUnitArray := CodeCompileUnitArray.CreateInstance(GETDOTNETTYPE(CodeCompileUnit), 1);
            CodeCompileUnitArray.SetValue(CodeCompileUnit, 0);

            CompilerResults := CSharpCodeProvider.CompileAssemblyFromDom(CompilerParameters, CodeCompileUnitArray);
            Assembly := CompilerResults.CompiledAssembly;

            DetectTypes(ServiceDescription.Services.Item(0).Name);

            RESET;
        END;
    end;

    local procedure DetectTypes(ServiceName: Text)
    var
        Types: DotNet Array;
        Type: DotNet Type;
        TypeName: DotNet String;
        PropertyInfo: DotNet PropertyInfo;
        Properties: DotNet Array;
        IsPageService: Boolean;
        i: Integer;
    begin
        CLEAR(LineType);
        CLEAR(ServiceType);
        CLEAR(FilterType);
        CLEAR(FieldsType);
        CLEAR(LinesProperty);

        Types := Assembly.ExportedTypes;
        IF Types.Length > 1 THEN BEGIN
            FOR i := 0 TO Types.Length - 1 DO BEGIN
                Type := Types.GetValue(i);
                TypeName := Type.Name;
                CASE TRUE OF
                    TypeName.EndsWith('_Line'):
                        LineType := Type;
                    TypeName.EndsWith('_Service'):
                        ServiceType := Type;
                    TypeName.EndsWith('_Filter'):
                        FilterType := Type;
                    TypeName.EndsWith('_Fields'):
                        FieldsType := Type;
                END;
            END;

            IF NOT ISNULL(ServiceType) THEN BEGIN
                TypeName := ServiceType.Name;
                Name := TypeName.Substring(0, TypeName.Length - 8);
                EntityType := Assembly.GetType(Name);

                IF HASLINES THEN BEGIN
                    Properties := EntityType.GetProperties;
                    FOR i := 0 TO Properties.Length - 1 DO BEGIN
                        PropertyInfo := Properties.GetValue(i);
                        Type := PropertyInfo.PropertyType;
                        IF Type.Name = LineType.Name + '[]' THEN
                            LinesProperty := PropertyInfo;
                    END;
                END;

                _Read := ServiceType.GetMethod('Read');
                _ReadByRecId := ServiceType.GetMethod('ReadByRecId');
                _ReadMultiple := ServiceType.GetMethod('ReadMultiple');
                _IsUpdated := ServiceType.GetMethod('IsUpdated');
                _GetRecIdFromKey := ServiceType.GetMethod('GetRecIdFromKey');
                _Create := ServiceType.GetMethod('Create');
                _CreateMultiple := ServiceType.GetMethod('CreateMultiple');
                _Update := ServiceType.GetMethod('Update');
                _UpdateMultiple := ServiceType.GetMethod('UpdateMultiple');
                _Delete := ServiceType.GetMethod('Delete');
                _ExecuteGetData := ServiceType.GetMethod('GetData');
                IF NOT (ISNULL(_Read) AND ISNULL(_ReadMultiple) AND ISNULL(_IsUpdated)) THEN
                    IsPageService := TRUE;
            END;
        END;

        IF NOT IsPageService THEN
          //ERROR(Text004,ServiceUri);
    end;

    [Scope('Internal')]
    procedure HASLINES(): Boolean
    begin
        EXIT(NOT ISNULL(LineType));
    end;

    [Scope('Internal')]
    procedure INSERTALLOWED(): Boolean
    begin
        AssertAllowedOperationName := 'Insert';
        EXIT(NOT ISNULL(_Create));
    end;

    [Scope('Internal')]
    procedure MODIFYALLOWED(): Boolean
    begin
        AssertAllowedOperationName := 'Modify';
        EXIT(NOT ISNULL(_Update));
    end;

    [Scope('Internal')]
    procedure DELETEALLOWED(): Boolean
    begin
        AssertAllowedOperationName := 'Delete';
        EXIT(NOT ISNULL(_Delete));
    end;

    local procedure AssertAllowed(Allowed: Boolean)
    begin
        IF NOT Allowed THEN
            ERROR(Text001, AssertAllowedOperationName, Name);
    end;

    local procedure AssertInitialized()
    begin
        IF ISNULL(Entity) THEN
            ERROR(Text002, Name);
    end;

    local procedure AssertHasLines()
    begin
        IF NOT HASLINES THEN
            ERROR(Text006, Name);
    end;

    local procedure AssertLineInitialized()
    begin
        IF ISNULL(Line) THEN
            ERROR(Text002, Text007);
    end;

    [Scope('Internal')]
    procedure INIT()
    var
        String: DotNet String;
    begin
        Entity := Activator.CreateInstance(EntityType);
        Lines := Lines.List;
        CLEAR(Entities);
        RESET;
    end;

    [Scope('Internal')]
    procedure NEWLINE()
    var
        LinesArray: DotNet Array;
        i: Integer;
    begin
        AssertHasLines;
        Line := Activator.CreateInstance(LineType);
        Lines.Add(Line);

        LinesArray := LinesArray.CreateInstance(LineType, Lines.Count);
        FOR i := 0 TO Lines.Count - 1 DO
            LinesArray.SetValue(Lines.Item(i), i);

        LinesProperty.SetValue(Entity, LinesArray);
    end;

    [Scope('Internal')]
    procedure CREATE()
    var
        Service: DotNet Object;
        "Object": DotNet Object;
        Parameters: DotNet Array;
    begin
        AssertAllowed(INSERTALLOWED);
        AssertInitialized;
        Parameters := Parameters.CreateInstance(GETDOTNETTYPE(Object), _Create.GetParameters().Length);
        Parameters.SetValue(Entity, Parameters.Length - 1);

        Service := Activator.CreateInstance(ServiceType);
        Authenticate(Service);

        _Create.Invoke(Service, Parameters);
        Entity := Parameters.GetValue(Parameters.Length - 1);
    end;

    [Scope('Internal')]
    procedure UPDATE()
    var
        Service: DotNet Object;
        "Object": DotNet Object;
        Parameters: DotNet Array;
    begin
        AssertAllowed(MODIFYALLOWED);
        AssertInitialized;

        Parameters := Parameters.CreateInstance(GETDOTNETTYPE(Object), _Create.GetParameters().Length);
        Parameters.SetValue(Entity, Parameters.Length - 1);

        Service := Activator.CreateInstance(ServiceType);
        Authenticate(Service);

        _Update.Invoke(Service, Parameters);
        Entity := Parameters.GetValue(Parameters.Length - 1);
    end;

    [Scope('Internal')]
    procedure UPDATEMULTIPLE()
    var
        Service: DotNet Object;
        "Object": DotNet Object;
        Parameters: DotNet Array;
    begin
        AssertAllowed(MODIFYALLOWED);
        AssertInitialized;

        Parameters := Parameters.CreateInstance(GETDOTNETTYPE(Object), _Create.GetParameters().Length);
        Parameters.SetValue(Entity, Parameters.Length - 1);

        Service := Activator.CreateInstance(ServiceType);
        Authenticate(Service);

        _Update.Invoke(Service, Parameters);
        Entity := Parameters.GetValue(Parameters.Length - 1);
    end;

    [Scope('Internal')]
    procedure DELETE()
    var
        Service: DotNet Object;
        "Object": DotNet Object;
        Parameters: DotNet Array;
        "Key": Text;
    begin
        AssertAllowed(DELETEALLOWED);
        AssertInitialized;

        Key := GETVALUE('Key');
        IF (Key = '') AND GetNull THEN
            READ;

        Parameters := Parameters.CreateInstance(GETDOTNETTYPE(Object), 1);
        Parameters.SetValue(GETVALUE('Key'), 0);

        Service := Activator.CreateInstance(ServiceType);
        Authenticate(Service);

        _Delete.Invoke(Service, Parameters);
    end;

    [Scope('Internal')]
    procedure READ()
    var
        Service: DotNet Object;
        "Object": DotNet Object;
        Parameters: DotNet Array;
        ParameterInfo: DotNet ParameterInfo;
        PropertyInfo: DotNet PropertyInfo;
        i: Integer;
    begin
        AssertInitialized;

        Parameters := Parameters.CreateInstance(GETDOTNETTYPE(Object), _Read.GetParameters().Length);
        FOR i := 0 TO Parameters.Length - 1 DO BEGIN
            ParameterInfo := _Read.GetParameters().GetValue(i);
            PropertyInfo := EntityType.GetProperty(ParameterInfo.Name);
            Parameters.SetValue(PropertyInfo.GetValue(Entity), i);
        END;

        Service := Activator.CreateInstance(ServiceType);
        Authenticate(Service);

        Entity := _Read.Invoke(Service, Parameters);
        CLEAR(Entities);
    end;

    [Scope('Internal')]
    procedure READMULTIPLE(): Boolean
    var
        Service: DotNet Object;
        "Object": DotNet Object;
        Parameters: DotNet Array;
        ParameterInfo: DotNet ParameterInfo;
        ReadFilters: DotNet Array;
        NullString: DotNet String;
        i: Integer;
    begin
        ReadFilters := ReadFilters.CreateInstance(FilterType, Filters.Count);
        FOR i := 0 TO Filters.Count - 1 DO
            ReadFilters.SetValue(Filters.Item(i), i);

        Parameters := Parameters.CreateInstance(GETDOTNETTYPE(Object), 3);
        Parameters.SetValue(ReadFilters, 0);
        Parameters.SetValue(NullString, 1);
        Parameters.SetValue(0, 2);

        Service := Activator.CreateInstance(ServiceType);
        Authenticate(Service);

        Entities := _ReadMultiple.Invoke(Service, Parameters);
        Cursor := 0;

        IF Entities.Length > 0 THEN BEGIN
            Cursor := 0;
            NEXT;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure RESET()
    begin
        Filters := Filters.List;
    end;

    [Scope('Internal')]
    procedure NEXT(): Integer
    begin
        IF Cursor < Entities.Length THEN BEGIN
            Entity := Entities.GetValue(Cursor);
            Cursor := Cursor + 1;
            EXIT(1);
        END ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure SETFILTER(FieldName: Text; Criteria: Text)
    var
        EnumValues: DotNet Array;
        "Filter": DotNet Object;
        "Field": DotNet Object;
        Enum: DotNet Enum;
        PropertyInfo: DotNet PropertyInfo;
        i: Integer;
        FieldExists: Boolean;
    begin
        EnumValues := Enum.GetValues(FieldsType);
        WHILE (i < EnumValues.Length) AND (NOT FieldExists) DO BEGIN
            IF FORMAT(EnumValues.GetValue(i)) = FieldName THEN
                FieldExists := TRUE;
            i := i + 1;
        END;
        IF NOT FieldExists THEN
            ERROR(Text005, FieldName, Name);
        Field := Enum.Parse(FieldsType, FieldName);

        Filter := Activator.CreateInstance(FilterType);
        PropertyInfo := FilterType.GetProperty('Field');
        PropertyInfo.SetValue(Filter, Field);
        PropertyInfo := FilterType.GetProperty('Criteria');
        PropertyInfo.SetValue(Filter, Criteria);
        Filters.Add(Filter);
    end;

    [Scope('Internal')]
    procedure SetObjectValue("Field": Text; Value: Variant; Target: DotNet Object)
    var
        PropertyInfo: DotNet PropertyInfo;
        Enum: DotNet Enum;
        "Object": DotNet Object;
        Type: DotNet Type;
        EnumValues: DotNet Array;
        ValueBool: Boolean;
        ValueInt: Integer;
        ValueText: Text;
        ValueDecimal: Decimal;
        ValueDateTime: DateTime;
        ValueDate: Date;
    begin
        Type := Target.GetType();
        PropertyInfo := Type.GetProperty(Field);
        IF ISNULL(PropertyInfo) THEN
            ERROR(Text003, Type.Name, Field);

        IF PropertyInfo.PropertyType.BaseType.FullName = 'System.Enum' THEN BEGIN
            IF Value.ISINTEGER THEN BEGIN
                ValueInt := Value;
                EnumValues := Enum.GetValues(PropertyInfo.PropertyType);
                ValueText := FORMAT(EnumValues.GetValue(ValueInt));
            END ELSE
                ValueText := Value;
            Object := Enum.Parse(PropertyInfo.PropertyType, ValueText);
            PropertyInfo.SetValue(Target, Object);
        END ELSE BEGIN
            CASE PropertyInfo.PropertyType.FullName OF
                'System.String':
                    BEGIN
                        ValueText := Value;
                        PropertyInfo.SetValue(Target, ValueText);
                    END;
                'System.Decimal':
                    BEGIN
                        ValueDecimal := Value;
                        PropertyInfo.SetValue(Target, ValueDecimal);
                    END;
                'System.DateTime':
                    BEGIN
                        ValueDateTime := Value;
                        PropertyInfo.SetValue(Target, ValueDateTime);
                    END;
                'System.Date':
                    BEGIN
                        ValueDate := Value;
                        PropertyInfo.SetValue(Target, ValueDate);
                    END;

                'System.Int32':
                    BEGIN
                        ValueInt := Value;
                        PropertyInfo.SetValue(Target, ValueInt);
                    END;
                'System.Boolean':
                    BEGIN
                        ValueBool := Value;
                        PropertyInfo.SetValue(Target, ValueBool);
                    END;
                ELSE
                    ERROR(Text008, PropertyInfo.PropertyType.FullName);
            END;
        END;

        PropertyInfo := Type.GetProperty(Field + 'Specified');
        IF NOT ISNULL(PropertyInfo) THEN
            PropertyInfo.SetValue(Target, TRUE);
    end;

    [Scope('Internal')]
    procedure GetObjectValue("Field": Text; Source: DotNet Object): Text
    var
        PropertyInfo: DotNet PropertyInfo;
        "Object": DotNet Object;
        Type: DotNet Type;
    begin
        GetNull := FALSE;
        Type := Source.GetType();

        PropertyInfo := Type.GetProperty(Field);
        IF ISNULL(PropertyInfo) THEN
            ERROR(Text003, Type.Name, Field);

        IF NOT ISNULL(Source) THEN BEGIN
            Object := PropertyInfo.GetValue(Source);
            IF NOT ISNULL(Object) THEN
                EXIT(Object.ToString());
        END;

        GetNull := TRUE;
        EXIT('');
    end;

    [Scope('Internal')]
    procedure SETVALUE("Field": Text; Value: Variant)
    begin
        SetObjectValue(Field, Value, Entity);
    end;

    [Scope('Internal')]
    procedure GETVALUE("Field": Text): Text
    var
        PropertyInfo: DotNet PropertyInfo;
        "Object": DotNet Object;
    begin
        EXIT(GetObjectValue(Field, Entity));
    end;

    [Scope('Internal')]
    procedure SETLINEVALUE("Field": Text; Value: Variant)
    begin
        SetObjectValue(Field, Value, Line);
    end;

    [Scope('Internal')]
    procedure GETLINEVALUE("Field": Text): Text
    begin
        EXIT(GetObjectValue(Field, Line));
    end;

    local procedure Authenticate(ServiceInstance: DotNet SoapHttpClientProtocol)
    var
        WebServicesSetup: Record "33020427";
        Client: DotNet WebRequest;
        Credential: DotNet NetworkCredential;
    begin
        IF WebServicesSetup.GET THEN
            ServiceInstance.Credentials := Credential.NetworkCredential(WebServicesSetup.Username, WebServicesSetup.Password)
        ELSE
            ServiceInstance.UseDefaultCredentials := TRUE;
    end;

    [Scope('Internal')]
    procedure ExecuteGetData()
    var
        Service: DotNet Object;
        "Object": DotNet Object;
        Parameters: DotNet Array;
    begin
        Parameters := Parameters.CreateInstance(GETDOTNETTYPE(Object), _ExecuteGetData.GetParameters().Length);
        Parameters.SetValue(Entity, Parameters.Length - 1);

        Service := Activator.CreateInstance(ServiceType);
        Authenticate(Service);

        _ExecuteGetData.Invoke(Service, Parameters);
        Entity := Parameters.GetValue(Parameters.Length - 1);
    end;

    [Scope('Internal')]
    procedure GetCustomerDetail(_Customer: Code[20]; DateFilter: Date)
    var
        Customer: Record "18";
    begin
        //DRI 1.0
        Customer.RESET;
        Customer.SETRANGE("No.", _Customer);
        Customer.SETRANGE("Date Filter", DateFilter);
        IF NOT Customer.FINDFIRST THEN
            EXIT;
        // Path := 'C:\Users\suman\Desktop\Amisha\test.pdf';
        Path := 'E:\CustDetTrial\Test.pdf';
        REPORT.SAVEASPDF(104, Path, Customer);
        //GetPdf;
    end;

    [Scope('Internal')]
    procedure GetPdf()
    var
        TempBlob: Record "99008535";
        txtBase64Code: Text;
        InStream: InStream;
        OutStream: OutStream;
    begin
        //DRI 1.0
        TempBlob.Blob.IMPORT(Path);
        TempBlob.Blob.CREATEINSTREAM(InStream);
        InStream.READTEXT(txtBase64Code);
        MESSAGE('%1', txtBase64Code);

        TempBlob.Blob.CREATEOUTSTREAM(OutStream);
        OutStream.WRITETEXT(txtBase64Code);
        // TempBlob.Blob.EXPORT('C:\Users\suman\Desktop\Amisha\OUTPUT\f.PDF');
        TempBlob.Blob.EXPORT('E:\CustDetTrial\f.PDF');
    end;

    [Scope('Internal')]
    procedure SynchronizeReport()
    var
        DealerSynchronization: Codeunit "33020509";
    begin
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerIntegrationService.CONNECT(GetURI()); //To connect to web service
                                                    //   DealerIntegrationService.GetCustomerDetail('C000002',071520D);
        DealerIntegrationService.GetCustomerDetail('C000004', 0D);
    end;

    [Scope('Internal')]
    procedure GetURI(): Text
    var
        URL: Text;
    begin
        URL := 'http://localhost:7038/NewDemo/WS/Agni%20Incorporated%20Pvt.%20Ltd./Codeunit/DealerIntegrationService';
        EXIT(URL);
    end;

    trigger Assembly::ModuleResolve(sender: Variant; e: DotNet ResolveEventArgs)
    begin
    end;
}

