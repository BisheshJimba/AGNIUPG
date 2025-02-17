page 25006543 "Model Version Sales Prices"
{
    // 13.08.2004 EDMS P1
    //  * Opened field "Location Code"

    Caption = 'Model Version Sales Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = Table7002;

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
                field(ItemNoFilterCtrl; ItemNoFilter)
                {
                    Caption = 'Item No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        ItemList.LOOKUPMODE := TRUE;
                        IF ItemList.RUNMODAL = ACTION::LookupOK THEN
                            Text := ItemList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        ItemNoFilterOnAfterValidate;
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
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Item No."; "Item No.")
                {
                    Caption = 'Model Version No.';
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Document Profile"; "Document Profile")
                {
                    OptionCaption = ' ,,Vehicles Trade';
                    Visible = false;
                }
                field("Dealer Discount Amount"; "Dealer Discount Amount")
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
                    Visible = false;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Visible = false;
                }
                field("Unit Price including VAT"; "Unit Price including VAT")
                {
                }
                field("VAT%"; "VAT%")
                {
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilterCtrl1; CurrencyCodeFilter)
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
        SalesCodeFilterCtrlEnable := TRUE;
        SalesCodeEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Unit of Measure Code" := '';
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        Cust: Record "18";
        CustPriceGr: Record "6";
        Campaign: Record "5071";
        Item: Record "27";
        ItemList: Page "31";
        CustList: Page "22";
        CustPriceGrList: Page "7";
        CampaignList: Page "5087";
        CurrencyList: Page "5";
        SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        ItemNoFilter: Text[250];
        StartingDateFilter: Text[30];
        CurrencyCodeFilter: Text[250];
        Text000: Label 'All Customers';
        [InDataSet]
        SalesCodeEditable: Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;

    [Scope('Internal')]
    procedure GetRecFilters()
    begin
        IF GETFILTERS <> '' THEN BEGIN
            IF GETFILTER("Sales Type") <> '' THEN
                SalesTypeFilter := "Sales Type"
            ELSE
                SalesTypeFilter := SalesTypeFilter::None;

            SalesCodeFilter := GETFILTER("Sales Code");
            ItemNoFilter := GETFILTER("Item No.");
            CurrencyCodeFilter := GETFILTER("Currency Code");
        END;

        EVALUATE(StartingDateFilter, GETFILTER("Starting Date"));
    end;

    [Scope('Internal')]
    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := TRUE;

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

        IF ItemNoFilter <> '' THEN BEGIN
            SETFILTER("Item No.", ItemNoFilter);
        END ELSE
            SETRANGE("Item No.");

        IF CurrencyCodeFilter <> '' THEN BEGIN
            SETFILTER("Currency Code", CurrencyCodeFilter);
        END ELSE
            SETRANGE("Currency Code");

        //SETRANGE("Document Profile","Document Profile"::"Vehicles Trade");

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
        SalesCodeEditable := "Sales Type" <> "Sales Type"::"All Customers";

        SourceTableName := '';
        IF ItemNoFilter <> '' THEN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 27);

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

        IF SalesSrcTableName = Text000 THEN
            EXIT(STRSUBSTNO('%1 %2 %3', SalesSrcTableName, SourceTableName, ItemNoFilter));
        EXIT(STRSUBSTNO('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, ItemNoFilter));
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

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
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

