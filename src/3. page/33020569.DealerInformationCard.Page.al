page 33020569 "Dealer Information Card"
{
    PageType = Card;
    SourceTable = Table33020428;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Tenant ID"; "Tenant ID")
                {
                }
                field("Company Name"; "Company Name")
                {
                }
                field(Active; Active)
                {
                }
                field("Activation Date"; "Activation Date")
                {
                }
                field("Synchronize Master Data"; "Synchronize Master Data")
                {
                }
                field("Last Synchronization Date"; "Last Synchronization Date")
                {
                }
                field("Regional Manager Email"; "Regional Manager Email")
                {
                }
            }
            part(; 33020570)
            {
                SubPageLink = Customer No.=FIELD(Customer No.);
            }
        }
    }

    actions
    {
    }
}

