pageextension 50442 pageextension50442 extends "Posted Return Shipment Subform"
{
    Caption = 'Reason Code';
    layout
    {
        addafter("Control 8")
        {
            field(ABC; ABC)
            {
            }
        }
    }

    var
        ABC: Option;
}

