page 25006823 "Product Subgroups"
{
    Caption = 'Product Subgroups';
    PageType = List;
    SourceTable = Table25006746;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Item Category Code"; "Item Category Code")
                {
                    Visible = false;
                }
                field("Product Group Code"; "Product Group Code")
                {
                    Visible = false;
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

