pageextension 50098 pageextension50098 extends "General Journal Template List"
{
    layout
    {
        addafter("Control 9")
        {
            field("User ID"; "User ID")
            {
            }
        }
    }

    var
        UserSetup: Record "91";
        FilterString: Text[250];


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //var
    //"filter": Text;
    //SysMgt: Codeunit "50000";
    //Usetup: Record "91";
    //begin
    /*
    //Added 29 May 2012 --- Surya - FIlter Journal Template to user
    UserSetup.RESET;
    UserSetup.SETRANGE("User ID",USERID);
    IF UserSetup.FINDFIRST THEN BEGIN
      IF UserSetup."Journal Template Filter" <> '' THEN BEGIN
        FilterString := UserSetup."Journal Template Filter";
        FILTERGROUP(2);
        SETFILTER(Name,FilterString);
        FILTERGROUP(0);
      END;
    END;

    Usetup.GET(USERID);
    IF NOT Usetup."Allow All Templates" THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("User ID",Usetup."User ID");
      FILTERGROUP(0);
      END;
    */
    //end;
}

