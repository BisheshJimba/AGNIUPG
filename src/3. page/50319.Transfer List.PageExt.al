pageextension 50319 pageextension50319 extends "Transfer List"
{
    layout
    {
        addafter("Control 1102601029")
        {
            field("Document Profile"; "Document Profile")
            {
                Visible = false;
            }
            field("Source Type"; "Source Type")
            {
                Visible = false;
            }
            field("Source Subtype"; "Source Subtype")
            {
                Visible = false;
            }
            field("Source No."; "Source No.")
            {
            }
            field("Vehicle Regd. No."; "Vehicle Regd. No.")
            {
            }
            field("Model Code"; "Model Code")
            {
            }
            field("Model Version No."; "Model Version No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601003".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601007".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601008".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601009".

    }


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
    /*
    {GetLocationWiseRecWithMProfile('1|2|3');
    MARKEDONLY(TRUE);
    }
    */
    //end;
}

