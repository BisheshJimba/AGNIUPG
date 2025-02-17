page 33019925 "Battery Role Center store"
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
                part(; 33019924)
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
            action("<Action1102159023>")
            {
                Caption = 'Warranty Battery Sales Orders';
                RunObject = Page 9305;
                RunPageView = WHERE(Battery Document=CONST(Yes));
            }
        }
        area(sections)
        {
            group(Store)
            {
                Caption = 'Store';
                Visible = false;
                action("<Action1102159021>")
                {
                    Caption = 'Pre Exide Claims';
                    RunObject = Page 33019912;
                    Visible = false;
                }
                action("Warranty Claims")
                {
                    Caption = 'Warranty Claims';
                    RunObject = Page 33019890;
                    Visible = false;
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
                Visible = false;
            }
            action(Battery)
            {
                Caption = 'Battery';
                Visible = false;
            }
        }
    }
}

