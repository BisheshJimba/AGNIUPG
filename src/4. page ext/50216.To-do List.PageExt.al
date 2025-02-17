pageextension 50216 pageextension50216 extends "To-do List"
{
    layout
    {
        addafter("Control 14")
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
        }
        addafter("Control 58")
        {
            field("<Make Code 2>"; "Make Code")
            {
            }
            field("<VIN 2>"; VIN)
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 34".

    }
}

