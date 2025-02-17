page 25006759 "SIE Object Categories"
{
    Caption = 'SIE Object Categories';
    PageType = List;
    SourceTable = Table25006708;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action56>")
            {
                Caption = 'Category';
                action("<Action58>")
                {
                    Caption = 'Objects';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006756;
                    RunPageLink = SIE No.=FIELD(SIE No.),
                                  Category=FIELD(No.);
                    ShortCutKey = 'F7';
                }
            }
        }
    }
}

