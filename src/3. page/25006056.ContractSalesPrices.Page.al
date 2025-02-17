page 25006056 "Contract Sales Prices"
{
    // 08.03.2010 EDMSB P2
    //   * Opened field Type

    Caption = 'Contract Sales Prices';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006031;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SalesCodeFilterCtrl; ContractFilter)
                {
                    Caption = 'Contract Filter';

                    trigger OnValidate()
                    begin
                        ContractFilterOnAfterValidate;
                    end;
                }
                field(ItemNoFilterCtrl; ItemNoFilter)
                {
                    Caption = 'Item No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "31";
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
                field(Type; Type)
                {
                }
                field(Code; Code)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Ordering Price Type Code"; "Ordering Price Type Code")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Price Includes VAT"; "Price Includes VAT")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    Visible = false;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                    Visible = false;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilterCtrlEDMS; CurrencyCodeFilter)
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
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Contract Type" := "Contract Type"::Contract;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        ContractFilter: Text[250];
        ItemNoFilter: Text[250];
        StartingDateFilter: Text[30];
        CurrencyCodeFilter: Text[250];

    [Scope('Internal')]
    procedure GetRecFilters()
    begin
        IF GETFILTERS <> '' THEN BEGIN
            ContractFilter := GETFILTER("Contract No.");
            ItemNoFilter := GETFILTER(Code);
            CurrencyCodeFilter := GETFILTER("Currency Code");
        END;

        EVALUATE(StartingDateFilter, GETFILTER("Starting Date"));
    end;

    [Scope('Internal')]
    procedure SetRecFilters()
    begin
        IF ContractFilter <> '' THEN
            SETFILTER("Contract No.", ContractFilter)
        ELSE
            SETRANGE("Contract No.");

        IF StartingDateFilter <> '' THEN
            SETFILTER("Starting Date", StartingDateFilter)
        ELSE
            SETRANGE("Starting Date");

        IF ItemNoFilter <> '' THEN BEGIN
            SETFILTER(Code, ItemNoFilter);
        END ELSE
            SETRANGE(Code);

        IF CurrencyCodeFilter <> '' THEN BEGIN
            SETFILTER("Currency Code", CurrencyCodeFilter);
        END ELSE
            SETRANGE("Currency Code");

        CurrPage.UPDATE(FALSE);
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

    local procedure ContractFilterOnAfterValidate()
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

