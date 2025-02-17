page 33020458 "HR Role Center"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(PartOneGroup)
            {
                Caption = 'PartOneGroup';
                part(; 33020459)
                {
                }
            }
            group()
            {
                systempart(; Outlook)
                {
                }
                systempart(; MyNotes)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
        }
        area(sections)
        {
            group(Reports)
            {
                Caption = 'Reports';
            }
        }
    }
}

