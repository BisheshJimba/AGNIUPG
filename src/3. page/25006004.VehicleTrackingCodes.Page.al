page 25006004 "Vehicle Tracking Codes"
{
    Caption = 'Vehicle Tracking Codes';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006014;

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

