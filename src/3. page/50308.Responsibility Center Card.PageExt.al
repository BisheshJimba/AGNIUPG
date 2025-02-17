pageextension 50308 pageextension50308 extends "Responsibility Center Card"
{
    layout
    {
        addafter("Control 16")
        {
            field("Default Debit Note for Sales"; "Default Debit Note for Sales")
            {
            }
            field("Advance Booking Template"; "Advance Booking Template")
            {
            }
            field("Advance Booking Batch"; "Advance Booking Batch")
            {
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Payment Method Code"; "Payment Method Code")
                {
                    Visible = false;
                }
                field("Skip Credit Limit Check"; "Skip Credit Limit Check")
                {
                }
            }
        }
        addafter("Control 36")
        {
            field("Post Box No."; "Post Box No.")
            {
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Sales Quote Nos."; "Sales Quote Nos.")
                {
                }
                field("Sales Blanket Order Nos."; "Sales Blanket Order Nos.")
                {
                }
                field("Sales Order Nos."; "Sales Order Nos.")
                {
                }
                field("Sales Return Order Nos."; "Sales Return Order Nos.")
                {
                }
                field("Sales Invoice Nos."; "Sales Invoice Nos.")
                {
                }
                field("Sales Posted Invoice Nos."; "Sales Posted Invoice Nos.")
                {
                }
                field("Sales Credit Memo Nos."; "Sales Credit Memo Nos.")
                {
                }
                field("Sales Posted Credit Memo Nos."; "Sales Posted Credit Memo Nos.")
                {
                }
                field("Sales Posted Shipment Nos."; "Sales Posted Shipment Nos.")
                {
                }
                field("Sales Posted Prepmt. Inv. Nos."; "Sales Posted Prepmt. Inv. Nos.")
                {
                }
                field("Sales Ptd. Prept. Cr. M. Nos."; "Sales Ptd. Prept. Cr. M. Nos.")
                {
                }
                field("Sales Ptd. Return Receipt Nos."; "Sales Ptd. Return Receipt Nos.")
                {
                }
                field("Purch. Quote Nos."; "Purch. Quote Nos.")
                {
                }
                field("Purch. Blanket Order Nos."; "Purch. Blanket Order Nos.")
                {
                }
                field("Purch. Order Nos."; "Purch. Order Nos.")
                {
                }
                field("Purch. Return Order Nos."; "Purch. Return Order Nos.")
                {
                }
                field("Purch. Invoice Nos."; "Purch. Invoice Nos.")
                {
                }
                field("Purch. Posted Invoice Nos."; "Purch. Posted Invoice Nos.")
                {
                }
                field("Purch. Credit Memo Nos."; "Purch. Credit Memo Nos.")
                {
                }
                field("Purch. Posted Credit Memo Nos."; "Purch. Posted Credit Memo Nos.")
                {
                }
                field("Purch. Posted Receipt Nos."; "Purch. Posted Receipt Nos.")
                {
                }
                field("Purch. Posted Prept. Inv. Nos."; "Purch. Posted Prept. Inv. Nos.")
                {
                }
                field("Purch. Ptd. Prept. Cr. M. Nos."; "Purch. Ptd. Prept. Cr. M. Nos.")
                {
                }
                field("Purch. Ptd. Return Shpt. Nos."; "Purch. Ptd. Return Shpt. Nos.")
                {
                }
                field("Serv. Order Nos."; "Serv. Order Nos.")
                {
                }
                field("Serv. Invoice Nos."; "Serv. Invoice Nos.")
                {
                }
                field("Serv. Posted Invoice Nos."; "Serv. Posted Invoice Nos.")
                {
                }
                field("Serv. Credit Memo Nos."; "Serv. Credit Memo Nos.")
                {
                }
                field("Serv. Posted Credit Memo Nos."; "Serv. Posted Credit Memo Nos.")
                {
                }
                field("Trans. Order Nos."; "Trans. Order Nos.")
                {
                }
                field("Posted Transfer Shpt. Nos."; "Posted Transfer Shpt. Nos.")
                {
                }
                field("Posted Transfer Rcpt. Nos."; "Posted Transfer Rcpt. Nos.")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 30".

    }
}

