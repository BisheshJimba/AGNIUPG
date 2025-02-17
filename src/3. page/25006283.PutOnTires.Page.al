page 25006283 "Put On Tires"
{
    Caption = 'Put On Tires';
    Editable = false;
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
                field("Vehicle Axle Code"; "Vehicle Axle Code")
                {
                }
                field("Tire Position Code"; "Tire Position Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

