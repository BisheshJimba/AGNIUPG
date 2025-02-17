page 25006371 "Resource Calendar Changes"
{
    Caption = 'Resource Calendar Changes';
    PageType = List;
    SourceTable = Table25006279;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Resource Code"; "Resource Code")
                {
                }
                field(Date; Date)
                {
                }
                field(Description; Description)
                {
                }
                field("Change Type"; "Change Type")
                {
                }
                field("Starting Time"; "Starting Time")
                {
                }
                field("Ending Time"; "Ending Time")
                {
                }
            }
        }
    }

    actions
    {
    }
}

