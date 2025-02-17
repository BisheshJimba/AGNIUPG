page 25006803 "Item Markup Restrictions"
{
    Caption = 'Item Markup Restrictions';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006762;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Group Code"; "Group Code")
                {
                    Visible = false;
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Min. Markup %"; "Min. Markup %")
                {
                }
                field(Base; Base)
                {
                    OptionCaption = 'Unit Cost';
                }
            }
        }
    }

    actions
    {
    }
}

