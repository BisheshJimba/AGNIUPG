page 33020273 "Vehicle Sales List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table37;
    SourceTableView = SORTING(Document Type, Document No., Line No.)
                      ORDER(Ascending)
                      WHERE(Document Profile=FILTER(Vehicles Trade));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                }
                field("Document No.";"Document No.")
                {
                }
                field("No.";"No.")
                {
                }
                field("Location Code";"Location Code")
                {
                }
                field("Posting Group";"Posting Group")
                {
                }
                field(Description;Description)
                {
                }
                field(Quantity;Quantity)
                {
                }
                field("Unit Price";"Unit Price")
                {
                }
                field(Amount;Amount)
                {
                }
                field("Amount Including VAT";"Amount Including VAT")
                {
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                }
                field("Customer Price Group";"Customer Price Group")
                {
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                }
                field("Line Amount";"Line Amount")
                {
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Make Code";"Make Code")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field(VIN;VIN)
                {
                }
                field("Model Version No.";"Model Version No.")
                {
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                }
                field("Vehicle Status Code";"Vehicle Status Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

