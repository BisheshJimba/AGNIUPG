page 25006200 "Service Work Groups"
{
    Caption = 'Service Work Groups';
    PageType = List;
    SourceTable = Table25006151;

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

