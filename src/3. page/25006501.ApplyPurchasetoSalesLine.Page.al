page 25006501 "Apply Purchase to Sales Line"
{
    Caption = 'Apply Purchase to Sales Line';
    Editable = false;
    PageType = List;
    SourceTable = Table37;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Vehicle Assembly ID"; "Vehicle Assembly ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

