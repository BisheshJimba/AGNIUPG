pageextension 50448 pageextension50448 extends "Return Receipt Lines"
{
    layout
    {
        addafter("Control 45")
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

