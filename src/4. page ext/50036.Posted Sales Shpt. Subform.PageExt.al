pageextension 50036 pageextension50036 extends "Posted Sales Shpt. Subform"
{
    layout
    {
        addafter("Control 8")
        {
            field(ABC; Rec.ABC)
            {
            }
        }
        addafter("Control 18")
        {
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
            }
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
            }
        }
        addafter("Control 52")
        {
            field("Forward Accountability Center"; Rec."Forward Accountability Center")
            {
            }
            field("Forward Location Code"; Rec."Forward Location Code")
            {
            }
            field(CBM; Rec.CBM)
            {
            }
        }
    }

    var
        ABC: Integer;
        Item: Record "27";
}

