page 50035 "Item Journal Templates (App)"
{
    PageType = List;
    SourceTable = Table82;
    SourceTableView = WHERE(Page ID=FILTER(392),
                            Recurring=FILTER(No),
                            Type=FILTER(Phys. Inventory));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                }
                field(Description;Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

