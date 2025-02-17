page 25006023 "Vehicle Types"
{
    Caption = 'Vehicle Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006023;

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

