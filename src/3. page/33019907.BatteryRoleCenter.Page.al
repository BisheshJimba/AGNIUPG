page 33019907 "Battery Role Center"
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
                part(; 33019908)
                {
                }
                systempart(; Outlook)
                {
                }
            }
            group()
            {
                systempart(; MyNotes)
                {
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
            group("<Action1000000000>")
            {
                Caption = 'Sales Orders';
                action("Warranty Battery Sales Orders")
                {
                    Caption = 'Warranty Battery Sales Orders';
                    RunObject = Page 9305;
                    RunPageView = WHERE(Battery Document=CONST(Yes));
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                action("<Action1000000003>")
                {
                    Caption = 'Job Report';
                    Image = "Report";
                    RunObject = Page 50014;
                }
                action("<Action1000000004>")
                {
                    Caption = 'Claim Report';
                    Image = "Report";
                    RunObject = Page 50015;
                }
            }
        }
        area(processing)
        {
            separator(New)
            {
                Caption = 'New';
                IsHeader = true;
            }
            action("<Action1102159014>")
            {
                Caption = 'Job Card';
                RunObject = Page 33019885;
                RunPageMode = Create;
            }
            action(Battery)
            {
                Caption = 'Battery';
            }
        }
    }
}

