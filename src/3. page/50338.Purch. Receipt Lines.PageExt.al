pageextension 50338 pageextension50338 extends "Purch. Receipt Lines"
{
    layout
    {
        modify("Control 1900000007")
        {
            Visible = false;
        }
        addafter("Control 2")
        {
            field("Line No."; Rec."Line No.")
            {
            }
        }
        addafter("Control 6")
        {
            field(VIN; Rec.VIN)
            {
                Visible = false;
            }
        }
        addafter("Control 44")
        {
            field("Vehicle Serial No."; Rec."Vehicle Serial No.")
            {
            }
            field("Vehicle Accounting Cycle No."; Rec."Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field("Make Code"; Rec."Make Code")
            {
                Visible = false;
            }
            field("Model Code"; Rec."Model Code")
            {
                Visible = false;
            }
            field("Model Version No."; Rec."Model Version No.")
            {
                Visible = false;
            }
        }
    }
}

