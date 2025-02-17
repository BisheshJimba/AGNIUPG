page 25006275 "Platform Create Wizard"
{
    Caption = 'Platform Create Wizard';
    PageType = NavigatePage;
    SourceTable = Table25006183;

    layout
    {
        area(content)
        {
            group("Step 1")
            {
                field(Code; Code)
                {
                }
            }
            group("Step 2")
            {
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Back)
            {
                Caption = 'Back';
                InFooterBar = true;
                RunPageMode = Edit;
                Visible = true;
            }
            action(Next)
            {
                Caption = 'Next';
                InFooterBar = true;
            }
            action(Finish)
            {
                Caption = 'Finish';
                InFooterBar = true;
            }
        }
    }
}

