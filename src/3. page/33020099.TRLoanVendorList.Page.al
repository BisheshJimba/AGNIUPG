page 33020099 "TR Loan Vendor List"
{
    CardPageID = "Vendor Card";
    PageType = List;
    SourceTable = Table23;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                    Visible = false;
                }
                field("Vendor Posting Group"; "Vendor Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    Visible = false;
                }
                field("Fin. Charge Terms Code"; "Fin. Charge Terms Code")
                {
                    Visible = false;
                }
                field("Search Name"; "Search Name")
                {
                }
                field(Blocked; Blocked)
                {
                    Visible = false;
                }
                field(Balance; Balance)
                {
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                }
                field("Net Change"; "Net Change")
                {
                }
                field("Net Change (LCY)"; "Net Change (LCY)")
                {
                }
                field("Purchases (LCY)"; "Purchases (LCY)")
                {
                }
                field("Inv. Discounts (LCY)"; "Inv. Discounts (LCY)")
                {
                }
                field("Pmt. Discounts (LCY)"; "Pmt. Discounts (LCY)")
                {
                }
                field("Balance Due"; "Balance Due")
                {
                }
                field("Balance Due (LCY)"; "Balance Due (LCY)")
                {
                }
                field("Sys LC No."; "Sys LC No.")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(; 9093)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = false;
            }
            part(; 9094)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = true;
            }
            part(; 9095)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = true;
            }
            part(; 9096)
            {
                SubPageLink = No.=FIELD(No.);
                    Visible = false;
            }
            systempart(; Links)
            {
                Visible = true;
            }
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(3);
        SETRANGE("Vendor Type", "Vendor Type"::"TR Loan");
    end;
}

