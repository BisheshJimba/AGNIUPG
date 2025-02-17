pageextension 50340 pageextension50340 extends "Sales Shipment Lines"
{
    layout
    {
        addafter("Control 45")
        {
            field("Vehicle Serial No."; Rec."Vehicle Serial No.")
            {
            }
            field("Vehicle Accounting Cycle No."; Rec."Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field(VIN; Rec.VIN)
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

