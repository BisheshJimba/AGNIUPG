pageextension 50048 pageextension50048 extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Control 4")
        {
            field("Account Name"; Rec."Account Name")
            {
            }
        }
        addafter("Control 8")
        {
            field(ABC; Rec.ABC)
            {
            }
        }
        addafter("Control 64")
        {
            field("TDS Base Amount"; Rec."TDS Base Amount")
            {
            }
            field("TDS%"; Rec."TDS%")
            {
            }
            field("TDS Type"; Rec."TDS Type")
            {
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
            }
            field("TDS Group"; Rec."TDS Group")
            {
            }
        }
        addafter("Control 58")
        {
            field("External Serv. Tracking No."; Rec."External Serv. Tracking No.")
            {
                Visible = false;
            }
            field(VIN; Rec.VIN)
            {
                Visible = false;
            }
            field("VIN - COGS"; Rec."VIN - COGS")
            {
                Visible = false;
            }
            field("Vehicle Serial No."; Rec."Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Document Class"; Rec."Document Class")
            {
            }
            field("Document Subclass"; Rec."Document Subclass")
            {
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
            }
            field("Description 2"; Rec."Description 2")
            {
                Visible = false;
            }
            field("Tax Purchase Type"; Rec."Tax Purchase Type")
            {
            }
        }
    }
}

