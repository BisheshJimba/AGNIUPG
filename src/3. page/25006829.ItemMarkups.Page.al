page 25006829 "Item Markups"
{
    // 17.02.05 AB

    Caption = 'Item Markups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006741;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Sales Type"; "Sales Type")
                {
                }
                field("Sales Code"; "Sales Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Markup %"; "Markup %")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field(Base; Base)
                {
                    Visible = false;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

