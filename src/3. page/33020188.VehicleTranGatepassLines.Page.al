page 33020188 "Vehicle Tran. Gatepass Lines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table50005;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Type"; "Item Type")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Vehicle Chassis No."; "Vehicle Chassis No.")
                {
                }
                field("Vehicle Reg. No."; "Vehicle Reg. No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field(Quantity; Quantity)
                {
                }
            }
        }
    }

    actions
    {
    }
}

