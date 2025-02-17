page 25006020 "Proc. Checklist Template Lines"
{
    Caption = 'Questionary Template Subject Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006027;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Template Code"; "Template Code")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Type Code"; "Type Code")
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

