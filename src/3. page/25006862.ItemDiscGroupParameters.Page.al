page 25006862 "Item Disc. Group Parameters"
{
    // 10.03.2015 EDMS P21 #T029
    //   Restructured

    Caption = 'Item Discount Group Parameter';
    PageType = List;
    SourceTable = Table25006760;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Item Discount Group Code"; "Item Discount Group Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field(Description; Description)
                {
                }
                field("Standard Discount %"; "Standard Discount %")
                {
                }
                field("Express Discount %"; "Express Discount %")
                {
                }
                field("Express Packing Cost %"; "Express Packing Cost %")
                {
                }
            }
        }
    }

    actions
    {
    }
}

