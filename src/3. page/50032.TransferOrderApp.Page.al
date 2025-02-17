page 50032 "Transfer Order (App)"
{
    PageType = Card;
    SourceTable = Table5740;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                }
                field("Transfer-to Name"; "Transfer-to Name")
                {
                }
                field("No. of Line Items"; "No. of Line Items")
                {
                }
                field("Total Qty. to Scan"; "Total Qty. to Scan")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SETRANGE("Picker ID", USERID);
    end;
}

