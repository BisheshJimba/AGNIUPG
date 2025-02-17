page 25006049 "Contract Sales Line Discount"
{
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Set Visible FALSE to fields:
    //     "Starting Date"
    //     "Contract Expiration Date"
    //     "Vehicle Serial No."
    //     StartingDateFilter

    AutoSplitKey = true;
    Caption = 'Contract Sales Line Discount';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006017;

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
                    Visible = false;

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
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                    Visible = false;
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Contract Expiration Date"; "Contract Expiration Date")
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
                field("Product Group Code"; "Product Group Code")
                {
                    Visible = false;
                }
                field("Product Subgroup Code"; "Product Subgroup Code")
                {
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
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
        TypeFilter: Option "Item Category",Labor,"Labor Discount Group","None";
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

