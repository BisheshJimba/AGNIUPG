pageextension 50052 pageextension50052 extends "Posted Purch. Cr. Memo Subform"
{
    layout
    {
        addafter("Control 8")
        {
            field(ABC; Rec.ABC)
            {
            }
        }
        addafter("Control 54")
        {
            field("Tax Purchase Type"; Rec."Tax Purchase Type")
            {
            }
        }
    }
}

