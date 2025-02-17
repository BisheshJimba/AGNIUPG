pageextension 50428 pageextension50428 extends "Sales Return Order Arc Subform"
{
    Editable = IsVisible;

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
    //AGNI2017Cu8 <<
    */
    //end;
}

