page 25006077 "Labor Sales Line Discounts"
{
    Caption = 'Labor Sales Line Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = Table25006057;

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
                    OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign,Contract,Assembly,Serv. Package,None';

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
                    var
                        CustList: Page "22";
                        CustDiscGrList: Page "512";
                        CampaignList: Page "5087";
                        ServicePackageList: Page "25006161";
                    begin
                        IF SalesTypeFilter = SalesTypeFilter::"All Customers" THEN
                            EXIT;

                        CASE SalesTypeFilter OF
                            SalesTypeFilter::Customer:
                                BEGIN
                                    CustList.LOOKUPMODE := TRUE;
                                    IF CustList.RUNMODAL = ACTION::LookupOK THEN
                                        Text := CustList.GetSelectionFilter
                                    ELSE
                                        EXIT(FALSE);
                                END;
                            SalesTypeFilter::"Customer Disc. Group":
                                BEGIN
                                    CustDiscGrList.LOOKUPMODE := TRUE;
                                    IF CustDiscGrList.RUNMODAL = ACTION::LookupOK THEN
                                        Text := CustDiscGrList.GetSelectionFilter
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
                            SalesTypeFilter::"Serv. Package":  //14.01.2014 EDMS P8
                                BEGIN
                                    ServicePackageList.LOOKUPMODE := TRUE;
                                    IF ServicePackageList.RUNMODAL = ACTION::LookupOK THEN
                                        Text := ServicePackageList.GetSelectionFilter
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
                field(StartingDateFilter; StartingDateFilter)
                {
                    Caption = 'Starting Date Filter';

                    trigger OnValidate()
                    var
                        ApplicationMgt: Codeunit "1";
                    begin
                        IF ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 THEN;
                        StartingDateFilterOnAfterValid;
                    end;
                }
                field(TypeFilter; TypeFilter)
                {
                    Caption = 'Type Filter';
                    OptionCaption = 'Labor,Labor Disceount Group,All,None';

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
                        LaborList: Page "25006152";
                        LaborGroupList: Page "25006078";
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
                            Type::"Labor Discount Group":
                                BEGIN
                                    LaborGroupList.LOOKUPMODE := TRUE;
                                    IF LaborGroupList.RUNMODAL = ACTION::LookupOK THEN
                                        Text := LaborGroupList.GetSelectionFilter
                                    ELSE
                                        EXIT(FALSE);
                                END;
                        END;

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        CodeFilterOnAfterValidate;
                    end;
                }
                field(SalesCodeFilterCtrl2; CurrencyCodeFilter)
                {
                    Caption = 'Currency Code Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CurrencyList: Page "5";
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
            repeater()
            {
                field("Sales Type"; "Sales Type")
                {
                }
                field("Sales Code"; "Sales Code")
                {
                    Editable = "Sales CodeEditable";
                }
                field(Type; Type)
                {
                }
                field(Code; Code)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Labor Group Code"; "Labor Group Code")
                {
                    Visible = false;
                }
                field("Labor Subgroup Code"; "Labor Subgroup Code")
                {
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        "Sales CodeEditable" := "Sales Type" <> "Sales Type"::"All Customers";
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := TRUE;
        SalesCodeFilterCtrlEnable := TRUE;
        "Sales CodeEditable" := TRUE;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        Cust: Record "18";
        CustDiscGr: Record "340";
        Campaign: Record "5071";
        ServiceLabor: Record "25006121";
        ServiceLaborGroup: Record "25006058";
        ServicePackage: Record "25006134";
        SalesTypeFilter: Option Customer,"Customer Disc. Group","All Customers",Campaign,Contract,Assembly,"Serv. Package","None";
        SalesCodeFilter: Text[250];
        TypeFilter: Option Labor,"Labor Disceount Group",All,"None";
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        Text000: Label 'All Customers';
        CurrencyCodeFilter: Text[250];
        [InDataSet]
        "Sales CodeEditable": Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;

    [Scope('Internal')]
    procedure GetRecFilters()
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

        IF TypeFilter <> TypeFilter::None THEN
            SETRANGE(Type, TypeFilter)
        ELSE
            SETRANGE(Type);

        IF TypeFilter = TypeFilter::None THEN BEGIN
            CodeFilterCtrlEnable := FALSE;
            CodeFilter := '';
        END;

        IF CodeFilter <> '' THEN BEGIN
            SETFILTER(Code, CodeFilter);
        END ELSE
            SETRANGE(Code);

        IF CurrencyCodeFilter <> '' THEN BEGIN
            SETFILTER("Currency Code", CurrencyCodeFilter);
        END ELSE
            SETRANGE("Currency Code");

        IF StartingDateFilter <> '' THEN
            SETFILTER("Starting Date", StartingDateFilter)
        ELSE
            SETRANGE("Starting Date");

        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "377";
        SourceTableName: Text[100];
        SalesSrcTableName: Text[100];
        Description: Text[250];
    begin
        GetRecFilters;
        "Sales CodeEditable" := "Sales Type" <> "Sales Type"::"All Customers";

        SourceTableName := '';
        CASE TypeFilter OF
            TypeFilter::Labor:
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 25006121);
                    ServiceLabor."No." := CodeFilter;
                END;
            TypeFilter::"Labor Disceount Group":
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 25006058);
                    ServiceLaborGroup.Code := CodeFilter;
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
            SalesTypeFilter::"Customer Disc. Group":
                BEGIN
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 340);
                    CustDiscGr.Code := SalesCodeFilter;
                    IF CustDiscGr.FIND THEN
                        Description := CustDiscGr.Description;
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
            SalesTypeFilter::"Serv. Package":  //14.01.2014 EDMS P8
                BEGIN
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 25006134);
                    ServicePackage."No." := SalesCodeFilter;
                    IF ServicePackage.FIND THEN
                        Description := ServicePackage.Description;
                END;
        END;

        IF SalesSrcTableName = Text000 THEN
            EXIT(STRSUBSTNO('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, CodeFilter));
        EXIT(STRSUBSTNO('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, CodeFilter));
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

    local procedure TypeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        CodeFilter := '';
        SetRecFilters;
    end;

    local procedure CodeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;
}

