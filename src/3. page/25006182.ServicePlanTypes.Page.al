page 25006182 "Service Plan Types"
{
    Caption = 'Service Plan Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006138;

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

