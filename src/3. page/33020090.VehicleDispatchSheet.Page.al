page 33020090 "Vehicle Dispatch Sheet"
{
    Editable = false;
    PageType = List;
    SourceTable = Table39;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    Visible = false;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Posting Group"; "Posting Group")
                {
                    Visible = false;
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                    Visible = false;
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    Visible = false;
                }
                field("Outstanding Quantity"; "Outstanding Quantity")
                {
                    Visible = false;
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                    Visible = false;
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    Visible = false;
                }
                field("Quantity Received"; "Quantity Received")
                {
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Line Type"; "Line Type")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                }
                field("Model Version No."; "Model Version No.")
                {
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
        SETFILTER("Quantity Received", '0');
    end;
}

