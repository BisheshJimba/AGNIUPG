page 25006186 "Technical Condition"
{
    AutoSplitKey = true;
    Caption = 'Technical Condition';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006147;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

