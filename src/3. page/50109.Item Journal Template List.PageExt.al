pageextension 50109 pageextension50109 extends "Item Journal Template List"
{
    layout
    {
        addafter("Control 10")
        {
            field("User ID"; Rec."User ID")
            {
            }
        }
    }


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //var
    //Usetup: Record "91";
    //begin
    /*
    Usetup.GET(USERID);
    IF NOT Usetup."Allow All Templates" THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("User ID",Usetup."User ID");
      FILTERGROUP(0);
      END;
    */
    //end;
}

