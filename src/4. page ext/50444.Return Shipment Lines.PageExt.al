pageextension 50444 pageextension50444 extends "Return Shipment Lines"
{
    layout
    {
        modify("Control 1900000007")
        {
            Visible = false;
        }
        addafter("Control 40")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field(VIN; VIN)
            {
                Visible = false;
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
        }
    }
}

