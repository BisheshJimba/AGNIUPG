page 25006894 "Service Booking Archives"
{
    Caption = 'Service Booking Archives';
    CardPageID = "Service Booking Archive";
    Editable = false;
    PageType = List;
    SourceTable = Table25006169;
    SourceTableView = WHERE(Document Type=CONST(Booking));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Version No."; "Version No.")
                {
                }
                field("Date Archived"; "Date Archived")
                {
                }
                field("Time Archived"; "Time Archived")
                {
                }
                field("Archived By"; "Archived By")
                {
                }
                field("Interaction Exist"; "Interaction Exist")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                }
                field("Phone No."; "Phone No.")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Service Advisor"; "Service Advisor")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Requested Delivery Date"; "Requested Delivery Date")
                {
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Visible = false;
                }
                field("Due Date"; "Due Date")
                {
                    Visible = false;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    Visible = false;
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
            group("Ver&sion")
            {
                Caption = 'Ver&sion';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 25006234;
                    RunPageLink = Type = CONST(Service Order),
                                  No.=FIELD(No.),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                }
            }
        }
    }
}

