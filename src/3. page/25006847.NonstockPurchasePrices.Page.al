page 25006847 "Nonstock Purchase Prices"
{
    Caption = 'Nonstock Item Purchase Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006751;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VendNoFilterCtrl; codVendNoFilter)
                {
                    Caption = 'Vendor No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        VendList.LOOKUPMODE := TRUE;
                        IF VendList.RUNMODAL = ACTION::LookupOK THEN
                            Text := VendList.GetSelectionFilter
                        ELSE
                            EXIT(FALSE);

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        codVendNoFilterOnAfterValidate;
                    end;
                }
                field(NonstockItemEntryNoFIlterCtrl; codNonstockItemEntryNoFilter)
                {
                    Caption = 'Nonstock Item Entry No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        NonstockItemList: Page "5726";
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
                        codNonstockItemEntryNoFilterOn;
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
                field("Vendor No."; "Vendor No.")
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
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
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

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        codVendNoFilter: Code[30];
        codNonstockItemEntryNoFilter: Code[30];
        txtStartingDateFilter: Text[30];
        recVend: Record "23";
        VendList: Page "27";

    [Scope('Internal')]
    procedure GetRecFilters()
    begin
        IF GETFILTERS <> '' THEN BEGIN
            codVendNoFilter := GETFILTER("Vendor No.");
            codNonstockItemEntryNoFilter := GETFILTER("Nonstock Item Entry No.");
            EVALUATE(txtStartingDateFilter, GETFILTER("Starting Date"));
        END;
    end;

    [Scope('Internal')]
    procedure SetRecFilters()
    begin
        IF codVendNoFilter <> '' THEN
            SETFILTER("Vendor No.", codVendNoFilter)
        ELSE
            SETRANGE("Vendor No.");

        IF txtStartingDateFilter <> '' THEN
            SETFILTER("Starting Date", txtStartingDateFilter)
        ELSE
            SETRANGE("Starting Date");

        IF codNonstockItemEntryNoFilter <> '' THEN BEGIN
            SETFILTER("Nonstock Item Entry No.", codNonstockItemEntryNoFilter);
        END ELSE
            SETRANGE("Nonstock Item Entry No.");

        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "377";
        SourceTableName: Text[100];
        Description: Text[250];
    begin
        GetRecFilters;

        IF codNonstockItemEntryNoFilter <> '' THEN
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 5718)
        ELSE
            SourceTableName := '';

        recVend."No." := codVendNoFilter;
        IF recVend.FIND THEN
            Description := recVend.Name;

        EXIT(STRSUBSTNO('%1 %2 %3 %4 ', codVendNoFilter, Description, SourceTableName, codNonstockItemEntryNoFilter));
    end;

    local procedure codVendNoFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure txtStartingDateFilterOnAfterVa()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure codNonstockItemEntryNoFilterOn()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;
}

