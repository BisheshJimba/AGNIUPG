page 33020574 "Dealer Invoices"
{
    CardPageID = "Dealer Invoice";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020433;
    SourceTableView = WHERE(Row Type=CONST(Document Header));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Profile"; "Document Profile")
                {
                }
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
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Registration No."; "Registration No.")
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
        }
    }

    actions
    {
    }
}

