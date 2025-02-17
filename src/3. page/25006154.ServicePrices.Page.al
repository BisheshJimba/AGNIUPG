page 25006154 "Service Prices"
{
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Make Code"
    //   * Added field "Location Code"
    // 
    // 09.02.2010 EDMS P2
    //   * Opened field "Unit of Measure Code", "DMS Variable Field 25006800"

    Caption = 'Service Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006123;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SalesTypeFilter; SalesTypeFilter)
                {
                    Caption = 'Sales Type Filter';
                    OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,None';

                    trigger OnValidate()
                    begin
                        SalesTypeFilterOnAfterValidate;
                    end;
                }
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    Caption = 'Sales Code Filter';
                    Enabled = SalesCodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF SalesTypeFilter = SalesTypeFilter::"All Customers" THEN EXIT;

                        CASE SalesTypeFilter OF
                            SalesTypeFilter::Customer:
                                BEGIN
                                    CustList.LOOKUPMODE := TRUE;
                                    IF CustList.RUNMODAL = ACTION::LookupOK THEN
                                        Text := CustList.GetSelectionFilter
                                    ELSE
                                        EXIT(FALSE);
                                END;
                            SalesTypeFilter::"Customer Price Group":
                                BEGIN
                                    CustPriceGrList.LOOKUPMODE := TRUE;
                                    IF CustPriceGrList.RUNMODAL = ACTION::LookupOK THEN
                                        Text := CustPriceGrList.GetSelectionFilter
                                    ELSE
                                        EXIT(FALSE);
                                END;
                            SalesTypeFilter::Campaign:
                                BEGIN
                                    CampaignList.LOOKUPMODE := TRUE;
                                    IF CampaignList.RUNMODAL = ACTION::LookupOK THEN
                                        Text := CampaignList.GetSelectionFilter
                                    ELSE
                                        EXIT(FALSE);
                                END;
                        END;

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                    end;
                }
                field(TypeFilter; TypeFilter)
                {
                    Caption = 'Type Filter';
                    OptionCaption = 'Service Labor,Serv. Labor Pr. Group,External Service,None';

                    trigger OnValidate()
                    begin
                        TypeFilterOnAfterValidate;
                    end;
                }
                field(CodeFilterCtrl; CodeFilter)
                {
                    Caption = 'Code Filter';
                    Enabled = CodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LaborPriceGroup: Record "25006158";
                        ExtServ: Record "25006133";
                    begin
                        CASE Type OF
                            Type::Labor:
                                BEGIN
                                    LaborList.LOOKUPMODE := TRUE;
                                    IF LaborList.RUNMODAL = ACTION::LookupOK THEN
                                        Text := LaborList.GetSelectionFilter
                                    ELSE
                                        EXIT(FALSE);
                                END;
                            Type::"Labor Group":
                                BEGIN
                                    LaborPriceGroupList.LOOKUPMODE := TRUE;
                                    IF LaborPriceGroupList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                        LaborPriceGroupList.GETRECORD(LaborPriceGroup);
                                        Text := LaborPriceGroup."No."; //ItemFlowList.GetSelectionFilter
                                    END ELSE
                                        EXIT(FALSE);
                                END;
                            Type::"Ext.Serv.":
                                BEGIN
                                    ExtServList.LOOKUPMODE := TRUE;
                                    IF ExtServList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                        ExtServList.GETRECORD(ExtServ);
                                        Text := ExtServ."No.";
                                    END ELSE
                                        EXIT(FALSE)
                                END;
                        END;
                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        CodeFilterOnAfterValidate;
                    end;
                }
                field(StartingDateFilter; StartingDateFilter)
                {
                    Caption = 'Starting Date Filter';

                    trigger OnValidate()
                    begin
                        StartingDateFilterOnAfterValid;
                    end;
                }
            }
            repeater()
            {
                field("Sales Type"; "Sales Type")
                {
                    OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
                }
                field("Sales Code"; "Sales Code")
                {
                    Editable = SalesCodeEditable;
                }
                field(Type; Type)
                {
                }
                field(Code; Code)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("DMS Variable Field 25006800"; "Variable Field 25006800")
                {
                    Visible = DMSVariableField25006800Visibl;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field(Price; Price)
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Price Includes VAT"; "Price Includes VAT")
                {
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilterCtrl3; CurrencyCodeFilter)
                {
                    Caption = 'Currency Code Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrencyList.LOOKUPMODE := TRUE;
                        IF CurrencyList.RUNMODAL = ACTION::LookupOK THEN
                            Text := CurrencyList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeFilterOnAfterValid;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := TRUE;
        SalesCodeFilterCtrlEnable := TRUE;
        DMSVariableField25006800Visibl := TRUE;
        SalesCodeEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;

        //09.02.2010 EDMSB P2 >>
        fSetVariableFields;
        // 09.02.2010 EDMSB P2 <<
    end;

    var
        Cust: Record "18";
        CustPriceGr: Record "6";
        Campaign: Record "5071";
        Labor: Record "25006121";
        LaborGrp: Record "25006158";
        ExtServ: Record "25006133";
        CustList: Page "22";
        CustPriceGrList: Page "7";
        CampaignList: Page "5087";
        LaborList: Page "25006152";
        LaborPriceGroupList: Page "25006230";
        ExtServList: Page "25006174";
        CurrencyList: Page "5";
        SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        CurrencyCodeFilter: Text[250];
        Text000: Label 'All Customers';
        TypeFilter: Option Labor,"Labor Group","Ext.Serv.","None";
        [InDataSet]
        SalesCodeEditable: Boolean;
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;

    [Scope('Internal')]
    procedure GetRecFilters()
    var
        TmpCode: Text[250];
    begin
        IF GETFILTERS <> '' THEN BEGIN
            IF GETFILTER("Sales Type") <> '' THEN
                SalesTypeFilter := "Sales Type"
            ELSE
                SalesTypeFilter := SalesTypeFilter::None;

            IF GETFILTER(Type) <> '' THEN
                TypeFilter := Type
            ELSE
                TypeFilter := TypeFilter::None;

            SalesCodeFilter := GETFILTER("Sales Code");
            CodeFilter := GETFILTER(Code);
            CurrencyCodeFilter := GETFILTER("Currency Code");
            EVALUATE(StartingDateFilter, GETFILTER("Starting Date"));
        END;
    end;

    [Scope('Internal')]
    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := TRUE;
        CodeFilterCtrlEnable := TRUE;

        IF SalesTypeFilter <> SalesTypeFilter::None THEN
            SETRANGE("Sales Type", SalesTypeFilter)
        ELSE
            SETRANGE("Sales Type");

        IF SalesTypeFilter IN [SalesTypeFilter::"All Customers", SalesTypeFilter::None] THEN BEGIN
            SalesCodeFilterCtrlEnable := FALSE;
            SalesCodeFilter := '';
        END;

        IF SalesCodeFilter <> '' THEN
            SETFILTER("Sales Code", SalesCodeFilter)
        ELSE
            SETRANGE("Sales Code");

        IF StartingDateFilter <> '' THEN
            SETFILTER("Starting Date", StartingDateFilter)
        ELSE
            SETRANGE("Starting Date");

        IF TypeFilter <> TypeFilter::None THEN
            SETRANGE(Type, TypeFilter)
        ELSE
            SETRANGE(Type);

        IF TypeFilter = TypeFilter::None THEN BEGIN
            CodeFilterCtrlEnable := FALSE;
            CodeFilter := '';
        END;

        IF CodeFilter <> '' THEN
            SETFILTER(Code, CodeFilter)
        ELSE
            SETRANGE(Code);

        IF CurrencyCodeFilter <> '' THEN BEGIN
            SETFILTER("Currency Code", CurrencyCodeFilter);
        END ELSE
            SETRANGE("Currency Code");

        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "377";
        SourceTableName: Text[100];
        SalesSrcTableName: Text[100];
        Description: Text[250];
        ReturnText: Text[1000];
    begin
        GetRecFilters;
        SalesCodeEditable := "Sales Type" <> "Sales Type"::"All Customers";

        SourceTableName := '';
        CASE TypeFilter OF
            TypeFilter::Labor:
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 25006121);
                    Labor."No." := CodeFilter;
                END;
            TypeFilter::"Labor Group":
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 25006158);
                    LaborGrp."No." := CodeFilter;
                END;
            TypeFilter::"Ext.Serv.":
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 25006133);
                    ExtServ."No." := CodeFilter;
                END;
        END;

        SalesSrcTableName := '';
        CASE SalesTypeFilter OF
            SalesTypeFilter::Customer:
                BEGIN
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 18);
                    Cust."No." := SalesCodeFilter;
                    IF Cust.FIND THEN
                        Description := Cust.Name;
                END;
            SalesTypeFilter::"Customer Price Group":
                BEGIN
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 6);
                    CustPriceGr.Code := SalesCodeFilter;
                    IF CustPriceGr.FIND THEN
                        Description := CustPriceGr.Description;
                END;
            SalesTypeFilter::Campaign:
                BEGIN
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5071);
                    Campaign."No." := SalesCodeFilter;
                    IF Campaign.FIND THEN
                        Description := Campaign.Description;
                END;
            SalesTypeFilter::"All Customers":
                BEGIN
                    SalesSrcTableName := Text000;
                    Description := '';
                END;
        END;

        IF SalesSrcTableName = Text000 THEN BEGIN
            IF SalesSrcTableName <> '' THEN
                ReturnText := SalesSrcTableName;
            IF SourceTableName <> '' THEN
                ReturnText += ' ' + SourceTableName;
            IF CodeFilter <> '' THEN
                ReturnText += ' ' + CodeFilter;
        END ELSE BEGIN
            IF SalesSrcTableName <> '' THEN
                ReturnText := SalesSrcTableName;
            IF SalesCodeFilter <> '' THEN
                ReturnText += ' ' + SalesCodeFilter;
            IF Description <> '' THEN
                ReturnText += ' ' + Description;
            IF SourceTableName <> '' THEN
                ReturnText += ' ' + SourceTableName;
            IF CodeFilter <> '' THEN
                ReturnText += ' ' + CodeFilter;
        END;

        EXIT(ReturnText);
    end;

    [Scope('Internal')]
    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := IsVFActive(FIELDNO("Variable Field 25006800"));
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SalesCodeFilter := '';
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure CodeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure TypeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        CodeFilter := '';
        SetRecFilters;
    end;

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        SalesCodeEditable := "Sales Type" <> "Sales Type"::"All Customers"
    end;
}

