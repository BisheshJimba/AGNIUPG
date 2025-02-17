page 25006179 "Service Labor Skills"
{
    Caption = 'Service Labor Skills';
    PageType = List;
    SourceTable = Table25006161;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Labor Code"; "Labor Code")
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

