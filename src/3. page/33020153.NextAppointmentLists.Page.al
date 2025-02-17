page 33020153 "Next Appointment Lists"
{
    PageType = List;
    SourceTable = Table33020151;
    SourceTableView = ORDER(Ascending)
                      WHERE(Used For=CONST(NAppPln));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Date)
                {
                }
                field(Time; Time)
                {
                }
                field(Venue; Venue)
                {
                }
            }
        }
    }

    actions
    {
    }
}

