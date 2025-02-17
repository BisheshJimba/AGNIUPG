page 50004 "Customer Credit Limit"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table50007;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field("Credit Limit (LCY)"; "Credit Limit (LCY)")
                {
                }
                field(Reason; Reason)
                {
                }
                field("Last Modified By"; "Last Modified By")
                {
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                }
                field("Created By"; "Created By")
                {
                }
                field("Created Date"; "Created Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

