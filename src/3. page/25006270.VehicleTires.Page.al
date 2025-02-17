page 25006270 "Vehicle Tires"
{
    Caption = 'Vehicle Tires';
    PageType = List;
    SourceTable = Table25006181;
    SourceTableView = WHERE(Open = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tire Code"; "Tire Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

