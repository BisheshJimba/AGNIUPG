page 25006525 "Vehicle Opt. Ledger Entries"
{
    // 12.07.2004 EDMS P1
    //   * Created

    Caption = 'Vehicle Opt. Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = Table25006388;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field(Correction; Correction)
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
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
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
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
                field("User ID"; "User ID")
                {
                    Visible = false;
                }
                field(Open; Open)
                {
                }
                field("Closed by Entry No."; "Closed by Entry No.")
                {
                }
                field("Cost Amount (LCY)"; "Cost Amount (LCY)")
                {
                }
                field("Sales Price (LCY)"; "Sales Price (LCY)")
                {
                }
                field("Sales Discount %"; "Sales Discount %")
                {
                }
                field("Sales Discount Amount (LCY)"; "Sales Discount Amount (LCY)")
                {
                }
                field("Sales Amount (LCY)"; "Sales Amount (LCY)")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    frmNavigate.SetDoc("Posting Date", "Document No.");
                    frmNavigate.RUN;
                end;
            }
        }
    }

    var
        frmNavigate: Page "344";
}

