page 25006282 "Platform Tire Positions subf"
{
    Caption = 'Platform Tire Positions subf';
    PageType = ListPart;
    SourceTable = Table25006185;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Template Code"; "Template Code")
                {
                }
                field("Template Axle Code"; "Template Axle Code")
                {
                }
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

