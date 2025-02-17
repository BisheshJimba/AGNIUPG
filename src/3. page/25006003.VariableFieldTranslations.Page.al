page 25006003 "Variable Field Translations"
{
    Caption = 'Variable Field Translations';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006003;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Language Code"; "Language Code")
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

