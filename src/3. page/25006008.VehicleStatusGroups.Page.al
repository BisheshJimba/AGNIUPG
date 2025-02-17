page 25006008 "Vehicle Status Groups"
{
    Caption = 'Vehicle Status Groups';
    PageType = List;
    SourceTable = Table25006022;

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

