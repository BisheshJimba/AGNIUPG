page 25006842 "Item Group Default Dimensions"
{
    Caption = 'Item Group Default Dimensions';
    PageType = List;
    SourceTable = Table25006769;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Product Group Code"; "Product Group Code")
                {
                }
                field("Product Subgroup Code"; "Product Subgroup Code")
                {
                }
                field("Dimension Code"; "Dimension Code")
                {
                }
                field("Dimension Value Code"; "Dimension Value Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

