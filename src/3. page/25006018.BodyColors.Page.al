page 25006018 "Body Colors"
{
    Caption = 'Body Colors';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006032;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field("Make Code"; "Make Code")
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
    }
}

