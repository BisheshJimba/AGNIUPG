page 25006500 "Apply Sales to Purchase Line"
{
    Caption = 'Apply Sales to Purchase Line';
    Editable = false;
    PageType = List;
    SourceTable = Table39;

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
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
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

