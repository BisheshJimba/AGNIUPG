pageextension 50007 pageextension50007 extends "General Journal Templates"
{
    layout
    {
        addafter("Control 53")
        {
            field("User ID"; "User ID")
            {
            }
        }
    }


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //var
    //"filter": Text;
    //SysMgt: Codeunit "50000";
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

