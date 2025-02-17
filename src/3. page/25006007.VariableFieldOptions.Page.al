page 25006007 "Variable Field Options"
{
    Caption = 'Variable Field Options';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006007;

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
                field("Variable Field Code"; "Variable Field Code")
                {
                    Visible = false;
                }
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
    }
}

