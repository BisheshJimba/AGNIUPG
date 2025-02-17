page 25006861 "Purch. Invoice Import Buffer"
{
    Caption = 'Purch. Invoice Import Buffer';
    PageType = List;
    SourceTable = Table25006756;

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("Document Type"; "Document Type")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Invoice Line No."; "Invoice Line No.")
                {
                }
                field("Company Code"; "Company Code")
                {
                }
                field("Supplier Code"; "Supplier Code")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Type of Invoice"; "Type of Invoice")
                {
                }
            }
        }
    }

    actions
    {
    }
}

