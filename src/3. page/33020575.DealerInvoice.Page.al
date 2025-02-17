page 33020575 "Dealer Invoice"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Table33020433;
    SourceTableView = WHERE(Row Type=CONST(Document Header));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Dealer Code"; "Dealer Code")
                {
                }
                field("Dealer Name"; "Dealer Name")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Sell-to Customer Code"; "Sell-to Customer Code")
                {
                }
                field("Sell-To Customer Name"; "Sell-To Customer Name")
                {
                }
                field("Bill-to Customer Code"; "Bill-to Customer Code")
                {
                }
                field("Bill-to Customer Name"; "Bill-to Customer Name")
                {
                }
                field("Customer Address"; "Customer Address")
                {
                }
                field("Customer Phone No."; "Customer Phone No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Total Amount Incl. VAT"; "Total Amount Incl. VAT")
                {
                }
                field("Invoice Discount Amount"; "Invoice Discount Amount")
                {
                }
                field("HMI Coupon No."; "HMI Coupon No.")
                {
                }
                field("STC Coupon No."; "STC Coupon No.")
                {
                }
                field("Scratch Coupon No."; "Scratch Coupon No.")
                {
                }
                field("Scratch Coupon Disc. Amount"; "Scratch Coupon Disc. Amount")
                {
                }
            }
            part(; 33020576)
            {
                SubPageLink = Dealer Code=FIELD(Dealer Code),
                              Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.);
            }
        }
    }

    actions
    {
    }
}

