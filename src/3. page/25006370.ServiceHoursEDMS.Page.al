page 25006370 "Service Hours EDMS"
{
    Caption = 'Service Hours';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006129;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Service Work Group Code"; "Service Work Group Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field(Day; Day)
                {
                }
                field("Starting Time"; "Starting Time")
                {
                }
                field("Ending Time"; "Ending Time")
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

