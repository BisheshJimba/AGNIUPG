pageextension 50038 pageextension50038 extends "Posted Sales Invoice Subform"
{
    Editable = IsVisible;
    Editable = false;
    layout
    {
        addafter("Control 6")
        {
            field("Job Type"; Rec."Job Type")
            {
            }
        }
        addafter("Control 8")
        {
            field(ABC; Rec.ABC)
            {
            }
        }
        addafter("Control 70")
        {
            field("Package No."; Rec."Package No.")
            {
                Visible = false;
            }
            field(CBM; Rec.CBM)
            {
            }
        }
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

