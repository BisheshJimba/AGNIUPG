page 50029 "Sales Order (App)"
{
    PageType = Card;
    SourceTable = Table36;
    SourceTableView = WHERE(Document Type=CONST(Order),
                            Document Profile=CONST(Spare Parts Trade));

    layout
    {
        area(content)
        {
            group()
            {
                field("Document Type"; "Document Type")
                {
                }
                field("No."; "No.")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Bill-to Name"; "Bill-to Name")
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

