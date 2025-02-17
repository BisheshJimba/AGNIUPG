page 25006824 "Item Price Groups"
{
    Caption = 'Item Price Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006754;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field("Sales Type"; "Sales Type")
                {
                }
                field("Sales Code"; "Sales Code")
                {
                }
                field("Sales Price Factor"; "Sales Price Factor")
                {
                }
                field("Purchase Discount Percent"; "Purchase Discount Percent")
                {
                }
            }
        }
    }

    actions
    {
    }
}

