pageextension 50323 pageextension50323 extends "Posted Transfer Rcpt. Subform"
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
            field(CBM; CBM)
            {
            }
        }
    }
}

