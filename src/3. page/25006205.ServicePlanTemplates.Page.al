page 25006205 "Service Plan Templates"
{
    Caption = 'Service Plan Templates';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006140;

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
                field("Service Plan Type"; "Service Plan Type")
                {
                }
                field(Adjust; Adjust)
                {
                    Visible = false;
                }
                field(Recurring; Recurring)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1190010>")
            {
                Caption = 'Service Plan Template';
                action(Stages)
                {
                    Caption = 'Stages';
                    Image = Stages;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006218;
                    RunPageLink = Template Code=FIELD(Code);
                }
                action(Usage)
                {
                    Caption = 'Usage';
                    Image = History;
                    RunObject = Page 25006219;
                                    RunPageLink = Template Code=FIELD(Code);
                }
                action(Comments)
                {
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page 25006248;
                                    RunPageLink = Type=CONST(Plan Template),
                                  Plan No.=FIELD(Code);
                    RunPageView = SORTING(Type,Plan No.,Stage Code,Vehicle Serial No.,Line No.);
                }
            }
        }
    }
}

