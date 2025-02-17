page 33020541 "Items with Bin Contents"
{
    Editable = false;
    PageType = List;
    SourceTable = Table7302;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Inventory; Inventory)
                {
                }
                field("Item Description"; "Item Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

