page 25006366 "Serv. Workplace Resources List"
{
    Caption = 'Serv. Workplace Resources List';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006285;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Workplace Code"; "Workplace Code")
                {
                }
                field("Resource No."; "Resource No.")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

