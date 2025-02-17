page 33020091 "In-Transit Sheet"
{
    Editable = false;
    PageType = List;
    SourceTable = Table5741;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("From Location Dimension 1 Code"; "From Location Dimension 1 Code")
                {
                }
                field("In-Transit Code"; "In-Transit Code")
                {
                }
                field("To Location Dimension 1 Code"; "To Location Dimension 1 Code")
                {
                }
                field("Qty. to Ship"; "Qty. to Ship")
                {
                }
                field("Quantity Shipped"; "Quantity Shipped")
                {
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                }
                field("Quantity Received"; "Quantity Received")
                {
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CALCFIELDS(VIN);
        SETFILTER(VIN, '<>%1', '');
    end;
}

