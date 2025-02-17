page 25006273 "Platform Template Axles"
{
    Caption = 'Platform Template Axles';
    PageType = List;
    SourceTable = Table25006184;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Functions';
                field(Code; Code)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(PlatformListActionGroup)
            {
                Caption = 'Axle';
                action(OpenTirePositionListAction)
                {
                    Caption = 'Tire Positions';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006274;
                    RunPageLink = Template Code=FIELD(Template Code),
                                  Template Axle Code=FIELD(Code);
                    RunPageView = SORTING(Template Code,Template Axle Code,Code)
                                  ORDER(Ascending);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }
}

