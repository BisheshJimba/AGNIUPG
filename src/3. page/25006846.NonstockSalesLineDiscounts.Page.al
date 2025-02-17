page 25006846 "Nonstock Sales Line Discounts"
{
    Caption = 'Nonstock Item Sales Line Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = Table25006750;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                    var
                        ApplicationMgt: Codeunit "1";
                    begin
                        IF ApplicationMgt.MakeDateFilter(txtStartingDateFilter) = 0 THEN;
                        txtStartingDateFilterOnAfterVa;
                    end;
                }
                field(SalesCodeFilterCtrl; txtCurrencyCodeFilter)
                {
                    Caption = 'Currency Code Filter';
                    Enabled = SalesCodeFilterCtrlEnable;

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
                field("Line Discount %"; "Line Discount %")
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
        txtStartingDateFilter: Text[30];
        txtCurrencyCodeFilter: Text[250];
        recNonstockItem: Record "5718";
        txtNonstockItemEntryFilter: Text[250];
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        CurrencyList: Page "5";

    [Scope('Internal')]
    procedure GetRecFilters()
    begin
        IF GETFILTERS <> '' THEN BEGIN
            txtNonstockItemEntryFilter := GETFILTER("Nonstock Item Entry No.");
            txtCurrencyCodeFilter := GETFILTER("Currency Code");
            EVALUATE(txtStartingDateFilter, GETFILTER("Starting Date"));
        END;
    end;

    [Scope('Internal')]
    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := TRUE;


        IF txtCurrencyCodeFilter <> '' THEN BEGIN
            SETFILTER("Currency Code", txtCurrencyCodeFilter);
        END ELSE
            SETRANGE("Currency Code");

        IF txtNonstockItemEntryFilter <> '' THEN BEGIN
            SETFILTER("Nonstock Item Entry No.", txtNonstockItemEntryFilter);
        END ELSE
            SETRANGE("Nonstock Item Entry No.");


        IF txtStartingDateFilter <> '' THEN
            SETFILTER("Starting Date", txtStartingDateFilter)
        ELSE
            SETRANGE("Starting Date");

        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure GetCaption(): Text[250]
    var
        recObjTransl: Record "377";
        txtSourceTableName: Text[100];
        txtSalesSrcTableName: Text[100];
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

    local procedure txtCurrencyCodeFilterOnAfterVa()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure txtNonstockItemEntryFilterOnAf()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;
}

