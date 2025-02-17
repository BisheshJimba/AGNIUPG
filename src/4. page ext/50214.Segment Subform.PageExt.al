pageextension 50214 pageextension50214 extends "Segment Subform"
{
    // 17.07.2013 EDMS P8
    //   * Added field "Vehicle Serial No."
    layout
    {
        addafter("Control 36")
        {
            field("Vehicle Serial No. -Not Used"; Rec."Vehicle Serial No. -Not Used")
            {
                Visible = false;
            }
        }
    }
    actions
    {
        addafter("Action 1902760704")
        {
            action("Sublines (Vehicles)")
            {
                Caption = 'Sublines (Vehicles)';

                trigger OnAction()
                begin
                    ShowContactVehicles;
                end;
            }
        }
    }
}

