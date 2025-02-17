pageextension 50307 pageextension50307 extends "Location Card"
{
    // 21.05.2014 Elva Baltic P21 #F012 MMG7.00
    //   Added page action:
    //     <Page Default Dimensions>
    Editable = false;
    layout
    {
        addafter("Control 24")
        {
            field("Use As Service Location"; "Use As Service Location")
            {
            }
            field("Admin/Procurement"; "Admin/Procurement")
            {
            }
            field("Use As Store"; "Use As Store")
            {
            }
            field(WareHouse; WareHouse)
            {
            }
            field("Default Price Group"; "Default Price Group")
            {
            }
            field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
            {
            }
            field("Location Type"; "Location Type")
            {
            }
            field("Accountability Center"; "Accountability Center")
            {
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                group(Sales)
                {
                    Caption = 'Sales';
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
                }
                group(Service)
                {
                    Caption = 'Service';
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
                }
                group(Transfer)
                {
                    Caption = 'Transfer';
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
                group(Purchase)
                {
                    Caption = 'Purchase';
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
                }
            }
        }
        addafter("Control 55")
        {
            field("QR Mandatory"; "QR Mandatory")
            {
            }
            field("Check QR Excess Qty."; "Check QR Excess Qty.")
            {
            }
        }
    }
    actions
    {
        addafter("Action 101")
        {
            action(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page 540;
                RunPageLink = Table ID=CONST(14),
                              No.=FIELD(Code);
                ShortCutKey = 'Shift+Ctrl+D';
            }
        }
    }

    //Unsupported feature: Property Deletion (Enabled) on "Control56".

}

