page 25006845 "Nonstock Sales Prices"
{
    // 13.08.2004 EDMS P1
    //  * Opened field "Location Code"

    Caption = 'Nonstock Item Sales Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = Table25006749;

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
                field(NonstockItemEntryNoFilterCtrl; txtNonstockItemEntryFilter)
                {
                    Caption = 'Nonstock Item Entry No Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        NonstockItemList: Page "5726";
                        recNonstockItem: Record "5718";
                    begin
                        NonstockItemList.LOOKUPMODE := TRUE;
                        IF NonstockItemList.RUNMODAL = ACTION::LookupOK THEN
                            Text := NonstockItemList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        txtNonstockItemEntryFilterOnAf;
                    end;
                }
                field(txtStartingDateFilter; txtStartingDateFilter)
                {
                    Caption = 'Starting Date Filter';

                    trigger OnValidate()
                    begin
                        txtStartingDateFilterOnAfterVa;
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
                }
                field("Nonstock Item Entry No."; "Nonstock Item Entry No.")
                {
                }
                field("Ordering Price Type Code"; "Ordering Price Type Code")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Document Profile"; "Document Profile")
                {
                    OptionCaption = ' ,Spare Parts Trade,,Service';
                    Visible = false;
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
            }
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilterCtrl2; txtCurrencyCodeFilter)
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
                        txtCurrencyCodeFilterOnAfterVa;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        SalesCodeFilterCtrlEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        txtNonstockItemEntryFilter: Text[250];
        txtStartingDateFilter: Text[30];
        txtCurrencyCodeFilter: Text[250];
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        CustList: Page "22";
        CustPriceGrList: Page "7";
        CampaignList: Page "5087";
        CurrencyList: Page "5";

    [Scope('Internal')]
    procedure GetRecFilters()
    begin
        IF GETFILTERS <> '' THEN BEGIN
            IF GETFILTER("Sales Type") <> '' THEN
                SalesTypeFilter := "Sales Type"
            ELSE
                SalesTypeFilter := SalesTypeFilter::None;

            SalesCodeFilter := GETFILTER("Sales Code");
            txtNonstockItemEntryFilter := GETFILTER("Nonstock Item Entry No.");
            txtCurrencyCodeFilter := GETFILTER("Currency Code");
        END;

        EVALUATE(txtStartingDateFilter, GETFILTER("Starting Date"));
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

        IF txtStartingDateFilter <> '' THEN
            SETFILTER("Starting Date", txtStartingDateFilter)
        ELSE
            SETRANGE("Starting Date");

        IF txtNonstockItemEntryFilter <> '' THEN BEGIN
            SETFILTER("Nonstock Item Entry No.", txtNonstockItemEntryFilter);
        END ELSE
            SETRANGE("Nonstock Item Entry No.");

        IF txtCurrencyCodeFilter <> '' THEN BEGIN
            SETFILTER("Currency Code", txtCurrencyCodeFilter);
        END ELSE
            SETRANGE("Currency Code");

        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure GetCaption(): Text[250]
    var
        recObjTransl: Record "377";
        txtSourceTableName: Text[100];
        txtDescription: Text[250];
    begin
        GetRecFilters;

        txtSourceTableName := '';
        IF txtNonstockItemEntryFilter <> '' THEN
            txtSourceTableName := recObjTransl.TranslateObject(recObjTransl."Object Type"::Table, 5718);

        EXIT(STRSUBSTNO('%1 %2', txtSourceTableName, txtNonstockItemEntryFilter));
    end;

    local procedure txtStartingDateFilterOnAfterVa()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure txtNonstockItemEntryFilterOnAf()
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

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure txtCurrencyCodeFilterOnAfterVa()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;
}

