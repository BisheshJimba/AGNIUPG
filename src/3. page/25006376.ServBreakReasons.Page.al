page 25006376 "Serv. Break Reasons"
{
    Caption = 'Serv. Break Reasons';
    PageType = List;
    SourceTable = Table25006283;

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

