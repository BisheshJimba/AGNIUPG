pageextension 50335 pageextension50335 extends "Value Entries"
{
    Editable = ISVisible;
    Editable = ISVisible;
    Editable = ISVisible;
    Editable = ISVisible;
    Editable = ISVisible;
    Editable = ISVisible;
    Editable = ISVisible;
    Editable = ISVisible;
    Editable = ISVisible;
    Editable = ISVisible;
    layout
    {
        addafter("Control 12")
        {
            field("VIN (Item Charge)"; VIN)
            {
                Visible = false;
            }
        }
        addafter("Control 30")
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
            }
        }
        addafter("Control 1004")
        {
            field("Invertor Serial No."; Rec."Invertor Serial No.")
            {
                Visible = false;
            }
        }
    }

    var
        ISVisible: Boolean;
        UserSetup: Record "91";
        VIN: Code[20];
        ILE: Record "32";
        Vehicle: Record "25006005";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    //AGNI2017CU8 >>
    VIN := '';
    ILE.RESET;
    ILE.SETRANGE("Entry No.","Item Ledger Entry No.");
    IF ILE.FINDFIRST THEN BEGIN
      IF Vehicle.GET(ILE."Serial No.") THEN
        VIN := Vehicle.VIN;
    END;
    //AGNI2017CU8 <<
    */
    //end;


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

