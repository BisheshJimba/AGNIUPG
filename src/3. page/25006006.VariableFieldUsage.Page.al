page 25006006 "Variable Field Usage"
{
    Caption = 'Variable Field Usage';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006006;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Table No."; "Table No.")
                {
                }
                field("Field No."; "Field No.")
                {
                }
                field("Variable Field Group Code"; "Variable Field Group Code")
                {
                }
                field("Variable Field Code"; "Variable Field Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

