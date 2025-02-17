page 50005 "Reserved Inv. Posting Nos."
{
    Editable = false;
    PageType = List;
    SourceTable = Table36;
    SourceTableView = WHERE(Posting No.=FILTER(<>''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Document Type";"Document Type")
                {
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                }
                field("Bill-to Name";"Bill-to Name")
                {
                }
                field("Order Date";"Order Date")
                {
                }
                field("Posting Date";"Posting Date")
                {
                }
                field("Document Date";"Document Date")
                {
                }
                field("Location Code";"Location Code")
                {
                }
                field("Responsibility Center";"Responsibility Center")
                {
                }
                field("Posting No.";"Posting No.")
                {
                }
                field("Posting No. Series";"Posting No. Series")
                {
                }
                field("Assigned User ID";"Assigned User ID")
                {
                }
                field("Vehicle Regd. No.";"Vehicle Regd. No.")
                {
                }
                field("Service Document No.";"Service Document No.")
                {
                }
                field("Debit Note";"Debit Note")
                {
                }
            }
        }
    }

    actions
    {
    }
}

