page 25006365 "Serv. Workplaces"
{
    Caption = 'Serv. Workplaces';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006284;

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
        area(navigation)
        {
            group(Workplace)
            {
                Caption = 'Workplace';
                action(Resources)
                {
                    Caption = 'Resources';
                    Image = Resource;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006366;
                    RunPageLink = Workplace Code=FIELD(Code);
                }
            }
        }
    }
}

