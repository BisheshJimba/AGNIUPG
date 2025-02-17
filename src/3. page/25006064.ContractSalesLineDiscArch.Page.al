page 25006064 "Contract Sales Line Disc.Arch."
{
    AutoSplitKey = true;
    Caption = 'Contract Sales Line Discount Archive';
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Table25006046;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ContractFilterCtrl; ContractFilter)
                {
                    Caption = 'Contract Filter';

                    trigger OnValidate()
                    begin
                        ContractFilterOnAfterValidate;
                    end;
                }
                field(TypeFilterCtrl; TypeFilter)
                {
                    Caption = 'Type Filter';

                    trigger OnValidate()
                    begin
                        TypeFilterOnAfterValidate;
                    end;
                }
                field(NoFilterCtrl; NoFilter)
                {
                    Caption = 'No. Filter';

                    trigger OnValidate()
                    begin
                        NoFilterOnAfterValidate;
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
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Contract Expiration Date"; "Contract Expiration Date")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                    Visible = false;
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
        ContractFilter: Text[250];
        TypeFilter: Option "Item Category",Labor,"None";
        StartingDateFilter: Text[30];
        NoFilter: Text[250];

    [Scope('Internal')]
    procedure GetRecFilters()
    begin
        IF GETFILTER(Type) <> '' THEN
            TypeFilter := Type
        ELSE
            TypeFilter := TypeFilter::None;

        IF GETFILTERS <> '' THEN BEGIN
            ContractFilter := GETFILTER("Contract No.");
            NoFilter := GETFILTER("No.");
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

        IF TypeFilter <> TypeFilter::None THEN
            SETRANGE(Type, TypeFilter)
        ELSE
            SETRANGE(Type);

        IF NoFilter <> '' THEN
            SETFILTER("No.", NoFilter)
        ELSE
            SETRANGE("No.");

        IF StartingDateFilter <> '' THEN
            SETFILTER("Starting Date", StartingDateFilter)
        ELSE
            SETRANGE("Starting Date");

        CurrPage.UPDATE(FALSE);
    end;

    local procedure TypeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure ContractFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure NoFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;
}

