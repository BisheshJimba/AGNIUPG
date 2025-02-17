page 25006272 "Platform Templates"
{
    Caption = 'Platform Templates';
    PageType = List;
    SourceTable = Table25006183;

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
    }

    actions
    {
        area(navigation)
        {
            group(group)
            {
                Caption = '&Platform';
                action(Axles)
                {
                    Caption = 'Ax&les';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006273;
                    RunPageLink = Template Code=FIELD(Code);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            action(Platform)
            {
                Caption = 'Platform';
                Image = Template;
                RunObject = Page 25006272;
            }
        }
    }
}

