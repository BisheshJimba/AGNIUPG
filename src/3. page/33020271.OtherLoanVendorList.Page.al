page 33020271 "Other Loan Vendor List"
{
    CardPageID = "Vendor Card";
    Editable = false;
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
        SETRANGE("Vendor Type", "Vendor Type"::"Other Loan");
    end;
}

