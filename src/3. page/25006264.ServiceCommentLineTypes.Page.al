page 25006264 "Service Comment Line Types"
{
    Caption = 'Service Comment Line Types';
    PageType = List;
    SourceTable = Table25006189;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Print; Print)
                {
                }
            }
        }
    }

    actions
    {
    }
}

