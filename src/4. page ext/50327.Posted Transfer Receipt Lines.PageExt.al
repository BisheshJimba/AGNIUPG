pageextension 50327 pageextension50327 extends "Posted Transfer Receipt Lines"
{
    // 30.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Added fields:"Vehicle Status Code"
    layout
    {
        addafter("Control 12")
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
            field("Vehicle Status Code"; "Vehicle Status Code")
            {
                Visible = false;
            }
        }
    }
}

