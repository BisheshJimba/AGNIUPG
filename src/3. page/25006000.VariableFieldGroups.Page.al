page 25006000 "Variable Field Groups"
{
    Caption = 'Variable Field Groups';
    PageType = List;
    SourceTable = Table25006030;

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
    }
}

