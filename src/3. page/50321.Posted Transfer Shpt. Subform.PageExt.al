pageextension 50321 pageextension50321 extends "Posted Transfer Shpt. Subform"
{
    Editable = false;
    layout
    {
        addafter("Control 6")
        {
            field("Unit Price"; "Unit Price")
            {
            }
            field(Amount; Amount)
            {
            }
        }
        addafter("Control 14")
        {
            field("Reason Code"; "Reason Code")
            {
            }
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
            }
            field(CBM; CBM)
            {
            }
        }
    }
}

