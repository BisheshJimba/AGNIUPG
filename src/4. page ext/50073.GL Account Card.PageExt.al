pageextension 50073 pageextension50073 extends "G/L Account Card"
{

    //Unsupported feature: Property Modification (ToolTipML) on ""G/L Account Card"(Page 17)".

    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1905532107".

        addafter("Control 12")
        {
            field("Document Class Mandatory"; Rec."Document Class Mandatory")
            {
            }
            field("Document Class"; Rec."Document Class")
            {
            }
        }
        addafter("Control 7")
        {
            field("Vehicle ID Mandatory"; Rec."Vehicle ID Mandatory")
            {
            }
            field("LC No Mandatory"; Rec."LC No Mandatory")
            {
            }
            field("Commercial Invoice Mandatory"; Rec."Commercial Invoice Mandatory")
            {
            }
            field("Is Insurance Charge"; Rec."Is Insurance Charge")
            {
            }
            field("Is Freight Charge"; Rec."Is Freight Charge")
            {
            }
        }
        addafter("Control 9")
        {
            field("Link to Register Type"; "Link to Register Type")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageView) on "Action 41".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 38".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 166".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 46".

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

