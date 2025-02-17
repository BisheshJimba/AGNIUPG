page 25006453 "Option Classes"
{
    Caption = 'Option Classes';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006373;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

