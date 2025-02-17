page 50004 "Customer Credit Limit"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Customer Credit Limit Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Accountability Center"; Rec."Accountability Center")
                {
                }
                field("Credit Limit (LCY)"; Rec."Credit Limit (LCY)")
                {
                }
                field(Reason; Rec.Reason)
                {
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Created Date"; Rec."Created Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

