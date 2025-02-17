pageextension 50247 pageextension50247 extends "Purchase Lines"
{
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        addafter("Control 1004")
        {
            field("Vehicle Registration No."; "Vehicle Registration No.")
            {
                Visible = false;
            }
            field("Depreciation Book Code"; Rec."Depreciation Book Code")
            {
            }
            field("FA Posting Type"; Rec."FA Posting Type")
            {
            }
        }
    }
    actions
    {


        //Unsupported feature: Code Modification on "Action 32.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ShowReservationEntries(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        ShowVehReservationEntries(TRUE);
        */
        //end;
    }
}

