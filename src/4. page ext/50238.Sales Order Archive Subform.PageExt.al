pageextension 50238 pageextension50238 extends "Sales Order Archive Subform"
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
    //AGNI2017CU8 <<
    */
    //end;
}

