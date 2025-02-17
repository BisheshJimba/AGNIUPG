page 25006808 "General Stockkeeping Unit List"
{
    Caption = 'General Stockkeeping Unit List';
    CardPageID = "General Stockkeeping Unit Card";
    Editable = false;
    PageType = List;
    SourceTable = Table25006731;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Replenishment System"; "Replenishment System")
                {
                }
                field(Description; Description)
                {
                }
                field("Reorder Point"; "Reorder Point")
                {
                    Visible = false;
                }
                field("Reorder Quantity"; "Reorder Quantity")
                {
                    Visible = false;
                }
                field("Maximum Inventory"; "Maximum Inventory")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

