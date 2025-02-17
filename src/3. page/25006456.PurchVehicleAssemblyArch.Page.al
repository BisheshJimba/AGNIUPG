page 25006456 "Purch. Vehicle Assembly Arch."
{
    AutoSplitKey = true;
    Caption = 'Purch. Vehicle Assembly Arch.';
    DataCaptionFields = "Assembly ID", "Line No.", Field30;
    PageType = List;
    SourceTable = Table25006384;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Assembly ID"; "Assembly ID")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Serial No."; "Serial No.")
                {
                    Visible = false;
                }
                field("Option Type"; "Option Type")
                {
                }
                field("Option Subtype"; "Option Subtype")
                {
                }
                field("Option Code"; "Option Code")
                {
                }
                field("External Code"; "External Code")
                {
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
                field(Standard; Standard)
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Sales Price"; "Sales Price")
                {
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Make Code" := recGlobPurchLine."Make Code";
        "Model Code" := recGlobPurchLine."Model Code";
        "Model Version No." := recGlobPurchLine."Model Version No.";
    end;

    var
        recGlobPurchLine: Record "5110";

    [Scope('Internal')]
    procedure fSetPurchLine(recPurchLine: Record "5110")
    begin
        recGlobPurchLine := recPurchLine;
    end;
}

