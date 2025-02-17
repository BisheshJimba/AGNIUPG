page 25006261 "Det. Serv. Ledger Entries EDMS"
{
    // 11.06.2015 EB.P30 #T041
    //   Added fields:
    //     "Finished Quantity (Hours)"
    //     "Unit Cost"
    //     "Cost Amount"

    Caption = 'Det. Serv. Ledger Entries EDMS';
    Editable = false;
    PageType = List;
    SourceTable = Table25006188;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Resource No."; "Resource No.")
                {
                }
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                }
                field("Service Ledger Entry No."; "Service Ledger Entry No.")
                {
                    Importance = Standard;
                    Visible = false;
                }
                field("Document Type"; "Document Type")
                {
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Finished Quantity (Hours)"; "Finished Quantity (Hours)")
                {
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
                field("Cost Amount"; "Cost Amount")
                {
                }
                field("Quantity (Hours)"; "Quantity (Hours)")
                {
                }
                field("Finished Qty. (Hours) Travel"; "Finished Qty. (Hours) Travel")
                {
                }
            }
        }
    }

    actions
    {
    }
}

