pageextension 50151 pageextension50151 extends "Item Journal"
{
    Editable = IsVisible;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".


        //Unsupported feature: Property Deletion (Visible) on "Control 63".


        //Unsupported feature: Property Deletion (Visible) on "Control 65".

        addfirst("Control 1")
        {
            field("Line No."; Rec."Line No.")
            {
            }
        }
        addafter("Control 2")
        {
            field("Lot No."; Rec."Lot No.")
            {
            }
        }
        addafter("Control 27")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
            }
            field(VIN; VIN)
            {
            }
            field("Make Code"; "Make Code")
            {
            }
            field("Model Code"; "Model Code")
            {
            }
            field("Model Version No."; "Model Version No.")
            {
            }
        }
        addafter("Control 8")
        {
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
            }
            field("Vehicle Registration No."; "Vehicle Registration No.")
            {
            }
        }
        addafter("Control 14")
        {
            field("Serial No."; Rec."Serial No.")
            {
            }
        }
        addafter("Control 61")
        {
            field("Invertor Serial No."; "Invertor Serial No.")
            {
                Visible = false;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 69".

    }

    var
        [InDataSet]
        ISVisible: Boolean;
        UserSetup: Record "91";


    //Unsupported feature: Code Insertion on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //begin
    /*
    UserSetup.GET(USERID);
    IF UserSetup."Can See Cost" THEN
      ISVisible :=TRUE
    ELSE
      ISVisible := FALSE;
    */
    //end;
}

