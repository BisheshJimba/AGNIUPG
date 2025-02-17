pageextension 50110 pageextension50110 extends "Item Journal Batches"
{
    // 25.06.2013 EDMS P8
    //   * Added field 'Location Code'
    layout
    {
        addafter("Control 6")
        {
            field("Location Code"; Rec."Location Code")
            {
            }
            field("User Id"; Rec."User Id")
            {
            }
        }
    }

    var
        Usetup: Record "91";


    //Unsupported feature: Code Insertion (VariableCollection) on "OnOpenPage".

    //trigger (Variable: Usetup)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ItemJnlMgt.OpenJnlBatch(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ItemJnlMgt.OpenJnlBatch(Rec);

    Usetup.GET(USERID);
    IF NOT Usetup."Allow All Templates" THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("User Id",Usetup."User ID");
      FILTERGROUP(0);
      END;
    */
    //end;
}

