page 25006274 "Platform Templ. Tire Positions"
{
    Caption = 'Platform Templ. Tire Positions';
    PageType = List;
    SourceTable = Table25006185;

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
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

