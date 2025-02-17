pageextension 50436 pageextension50436 extends "Purchase Return Order Subform"
{
    Caption = 'Reason Code';
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        addafter("Control 20")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
            }
        }
        addafter("Control 310")
        {
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
                Visible = true;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                Visible = false;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                Visible = false;
            }
            field("VIN - COGS"; "VIN - COGS")
            {
            }
            field("TDS Group"; "TDS Group")
            {
            }
            field("TDS%"; "TDS%")
            {
            }
            field("TDS Type"; "TDS Type")
            {
            }
            field("TDS Amount"; "TDS Amount")
            {
            }
            field("Cost Type"; "Cost Type")
            {
            }
            field("TDS Base Amount"; "TDS Base Amount")
            {
            }
            field("Tax Purchase Type"; "Tax Purchase Type")
            {
            }
        }
    }


    //Unsupported feature: Code Modification on "PageShowReservation(PROCEDURE 9)".

    //procedure PageShowReservation();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    FIND;
    ShowReservation;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    FIND;
    ShowVehReservation;
    */
    //end;
}

