page 25006178 "Resource Skills EDMS"
{
    Caption = 'Resource Skills';
    PageType = List;
    SourceTable = Table25006160;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Resource No."; "Resource No.")
                {
                    Visible = false;
                }
                field("Skill Code"; "Skill Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

