pageextension 50148 pageextension50148 extends "Item Reclass. Journal"
{
    Editable = true;
    Editable = true;
    Editable = IsVisible;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        addafter("Control 61")
        {
            field(VIN; VIN)
            {
            }
        }
        addafter("Control 27")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
            }
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                Visible = false;
            }
        }
        moveafter("Control 8"; "Control 10")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 51".

    }

    var
        ISVisible: Boolean;
        UserSetup: Record "91";


    //Unsupported feature: Code Insertion on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //begin
    /*
    //AGNI2017CU8 >>
    UserSetup.GET(USERID);
    IF UserSetup."Can See Cost" THEN
      ISVisible :=TRUE
    ELSE
      ISVisible := FALSE;
    //AGNI2017CU8 <<
    */
    //end;
}

