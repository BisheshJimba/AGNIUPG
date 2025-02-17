codeunit 25006004 "Variable Field Management"
{
    // 04.03.2014 Elva Baltic P7 #R114 MMG7.00
    //   * New function GetVFCodeByCode added
    // 
    // 26.06.2013 EDMS P8
    //   * Fix


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Undefined Variable Field';

    [Scope('Internal')]
    procedure GetVFCaption(TableNo: Integer; FieldNo: Integer; LanguageCode: Code[10]): Text[30]
    var
        VFUsage: Record "25006006";
        VF: Record "25006002";
        VFTranslation: Record "25006003";
    begin
        IF VFUsage.GET(TableNo, FieldNo) THEN BEGIN
            IF VF.GET(VFUsage."Variable Field Code") THEN BEGIN
                IF NOT VF."Use Translations" THEN
                    EXIT(COPYSTR(VF.Caption, 1, 30));
                IF VFTranslation.GET(VF.Code, LanguageCode) THEN
                    EXIT(COPYSTR(VFTranslation.Description, 1, 30))
                ELSE
                    EXIT(COPYSTR(VF.Caption, 1, 30));
            END;
        END;

        EXIT(Text001);
    end;

    [Scope('Internal')]
    procedure IsVFActive(TableNo: Integer; FieldNo: Integer): Boolean
    var
        VFUsage: Record "25006006";
    begin
        VFUsage.RESET;
        IF VFUsage.GET(TableNo, FieldNo) THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure GetVFCaptionEx(TableNumber: Integer; FieldNumber: Integer; VFGroupCode: Code[10]): Text[80]
    var
        VFUsage: Record "25006006";
    begin
        VFUsage.RESET;
        VFUsage.SETRANGE("Table No.", TableNumber);
        VFUsage.SETRANGE("Field No.", FieldNumber);
        //SETRANGE("Variable Field Group Code",VFGroupCode);  //26.11.2012 EB P1 - SIE Hotfix
        IF VFUsage.FINDFIRST THEN
            EXIT(VFUsage."Variable Field Code") //26.11.2012 EB P1 - SIE Hotfix
        EXIT(Text001);  //26.06.2013 EDMS P8
    end;

    [Scope('Internal')]
    procedure IsVFActiveEx(TableNumber: Integer; FieldNumber: Integer; VFGroupCode: Code[10]): Boolean
    var
        VFUsage: Record "25006006";
    begin
        VFUsage.RESET;
        VFUsage.SETRANGE("Table No.", TableNumber);
        VFUsage.SETRANGE("Field No.", FieldNumber);
        //SETRANGE("Variable Field Group Code",VFGroupCode); //26.11.2012 EB P1 - SIE Hotfix
        EXIT(VFUsage.FINDFIRST)
        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure AssignFilterSPVerToVeh(var Vehicle: Record "25006005"; var ServicePackageVersionPar: Record "25006135")
    var
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        VFUsage1: Record "25006006";
        VFUsage2: Record "25006006";
        VariableField: Record "25006002";
        DocNoFieldRef: FieldRef;
        DocAmountFieldRef: FieldRef;
    begin
        // filter variable fields
        RecordRef2.OPEN(DATABASE::Vehicle);
        RecordRef2.GETTABLE(Vehicle);

        RecordRef1.OPEN(DATABASE::"Sales Header");
        DocNoFieldRef := RecordRef1.FIELD(3);
        DocAmountFieldRef := RecordRef1.FIELD(140);
        RecordRef1.CLOSE;

        RecordRef1.OPEN(DATABASE::"Service Package Version");

        VFUsage1.RESET;
        VFUsage1.SETRANGE("Table No.", DATABASE::"Service Package Version");
        IF VFUsage1.FINDFIRST THEN
            REPEAT
                VFUsage2.RESET;
                VFUsage2.SETCURRENTKEY("Variable Field Code");
                VFUsage2.SETRANGE("Table No.", DATABASE::Vehicle);
                VFUsage2.SETRANGE("Variable Field Code", VFUsage1."Variable Field Code");
                IF VFUsage2.FINDFIRST THEN BEGIN
                    VariableField.GET(VFUsage1."Variable Field Code");
                    IF VariableField."Use In Filtering" THEN BEGIN
                        FieldRef1 := RecordRef2.FIELD(VFUsage2."Field No.");
                        RecordRef1.SETVIEW(ServicePackageVersionPar.GETVIEW);
                        FieldRef2 := RecordRef1.FIELD(VFUsage1."Field No.");
                        IF FieldRef2.TYPE = DocNoFieldRef.TYPE THEN
                            FieldRef2.SETFILTER('''''|%1', FORMAT(FieldRef1.VALUE));
                        IF FieldRef2.TYPE = DocAmountFieldRef.TYPE THEN
                            FieldRef2.SETFILTER('0|%1', FORMAT(FieldRef1.VALUE));
                        ServicePackageVersionPar.SETVIEW(RecordRef1.GETVIEW);
                    END;
                END;
            UNTIL VFUsage1.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetVFCodeByCode(FieldCode: Code[10]): Integer
    var
        VFUsage: Record "25006006";
        VF: Record "25006002";
        VFTranslation: Record "25006003";
    begin
        IF VF.GET(FieldCode) THEN BEGIN
            VFUsage.RESET;
            VFUsage.SETRANGE("Variable Field Code", FieldCode);
            IF VFUsage.FINDFIRST THEN BEGIN
                EXIT(VFUsage."Field No.");
            END;
        END;
    end;
}

