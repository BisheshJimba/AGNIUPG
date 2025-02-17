page 33020050 "Accountability Center Card"
{
    Caption = 'Accountability Center Card';
    PageType = Card;
    SourceTable = Table33019846;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(City; City)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field(Contact; Contact)
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Default Debit Note for Sales"; "Default Debit Note for Sales")
                {
                }
                field("Advance Booking Template"; "Advance Booking Template")
                {
                }
                field("Advance Booking Batch"; "Advance Booking Batch")
                {
                }
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
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No."; "Phone No.")
                {
                }
                field("Fax No."; "Fax No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field("Home Page"; "Home Page")
                {
                }
                field("Post Box No."; "Post Box No.")
                {
                }
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
                field("Serv. Quote Nos."; "Serv. Quote Nos.")
                {
                }
                field("Serv. Booking Nos."; "Serv. Booking Nos.")
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
                field("Serv. Posted Order Nos."; "Serv. Posted Order Nos.")
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
                field("Purch. Posted Prept. Inv. Nos."; "Purch. Posted Prept. Inv. Nos.")
                {
                }
                field("Purch. Ptd. Prept. Cr. M. Nos."; "Purch. Ptd. Prept. Cr. M. Nos.")
                {
                }
                field("Purch. Ptd. Return Shpt. Nos."; "Purch. Ptd. Return Shpt. Nos.")
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
                field("Sales Posted Debit Note Nos."; "Sales Posted Debit Note Nos.")
                {
                }
                field("Customer Complain Nos."; "Customer Complain Nos.")
                {
                }
                field("Membership Nos."; "Membership Nos.")
                {
                }
                field("Debit Note Nos."; "Debit Note Nos.")
                {
                }
                field("Credit Note Nos."; "Credit Note Nos.")
                {
                }
                field("Import Purch. Order Nos."; "Import Purch. Order Nos.")
                {
                }
                field("Import Purch. Invoice Nos."; "Import Purch. Invoice Nos.")
                {
                    Visible = true;
                }
                field("Import Purch. Ret. Order Nos."; "Import Purch. Ret. Order Nos.")
                {
                }
                field("Import Purch. Credit Memo Nos."; "Import Purch. Credit Memo Nos.")
                {
                    Visible = true;
                }
                field("Import Purch. Posted Rcpt Nos."; "Import Purch. Posted Rcpt Nos.")
                {
                }
                field("Import Purch. Posted Inv Nos."; "Import Purch. Posted Inv Nos.")
                {
                }
                field("Import Posted Purch. Ret. Nos."; "Import Posted Purch. Ret. Nos.")
                {
                }
                field("Import Purch. Posted Cr.Nos."; "Import Purch. Posted Cr.Nos.")
                {
                }
                field(Block; Block)
                {
                }
                field("CDIF Nos."; "CDIF Nos.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Resp. Ctr.")
            {
                Caption = '&Resp. Ctr.';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = Table ID=CONST(5714),
                                  No.=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }

    var
        Mail: Codeunit "397";
}

