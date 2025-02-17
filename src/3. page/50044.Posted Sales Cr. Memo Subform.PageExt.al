pageextension 50044 pageextension50044 extends "Posted Sales Cr. Memo Subform"
{
    Editable = IsVisible;
    layout
    {
        addafter("Control 2")
        {
            field(ABC; Rec.ABC)
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

