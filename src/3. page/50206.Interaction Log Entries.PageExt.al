pageextension 50206 pageextension50206 extends "Interaction Log Entries"
{
    layout
    {
        modify("Control 7")
        {
            Visible = false;
        }
        modify("Control 9")
        {
            Visible = false;
        }
        addafter("Control 77")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
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
            field("Vehicle Registration No."; "Vehicle Registration No.")
            {
                Visible = false;
            }
            field(Remarks; Remarks)
            {
            }
            group()
            {
                field("Contact Name"; Rec."Contact Name")
                {
                    Caption = 'Contact Name';
                    DrillDown = false;
                }
                field("Contact Company Name"; Rec."Contact Company Name")
                {
                    DrillDown = false;
                }
                field("<Make Code 2>"; "Make Code")
                {
                }
                field("<VIN 2>"; VIN)
                {
                }
            }
        }
    }
}

