page 25006367 "Time Grids"
{
    PageType = List;
    SourceTable = Table25006278;

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
            group("<Action1101901007>")
            {
                Caption = 'Grid';
                action("Grid Items")
                {
                    Caption = 'Grid Items';
                    Image = ListPage;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006363;
                    RunPageLink = Grid Code=FIELD(Code);
                }
            }
        }
    }
}

