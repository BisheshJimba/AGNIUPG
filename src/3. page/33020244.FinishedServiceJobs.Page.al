page 33020244 "Finished Service Jobs"
{
    CardPageID = "Sales Invoice";
    Editable = false;
    PageType = List;
    SourceTable = Table36;
    SourceTableView = SORTING(Posting Date)
                      ORDER(Ascending)
                      WHERE(Document Profile=FILTER(Service));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date";"Posting Date")
                {
                }
                field("Document Type";"Document Type")
                {
                }
                field("No.";"No.")
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
                field("Responsibility Center";"Responsibility Center")
                {
                }
                field("Location Code";"Location Code")
                {
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                }
                field("Service Document No.";"Service Document No.")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field(VIN;VIN)
                {
                }
                field("Vehicle Regd. No.";"Vehicle Regd. No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

