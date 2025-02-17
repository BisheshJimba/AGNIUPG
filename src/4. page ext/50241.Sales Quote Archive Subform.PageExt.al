pageextension 50241 pageextension50241 extends "Sales Quote Archive Subform"
{
    Editable = IsVisible;

    var
        IsVisible: Boolean;
        UserSetup: Record "91";


    //Unsupported feature: Code Insertion on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //begin
    /*
    //AGNI2017CU8 >>
    UserSetup.GET(USERID);
    IF UserSetup."Can See Cost" THEN
      IsVisible :=TRUE
    ELSE
      IsVisible := FALSE;
    //AGNI2017CU8 <<
    */
    //end;
}

