page 25006061 "Vehicle Insurance Types"
{
    Caption = 'Vehicle Insurance Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006034;

    layout
    {
        area(content)
        {
            repeater()
            {
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

