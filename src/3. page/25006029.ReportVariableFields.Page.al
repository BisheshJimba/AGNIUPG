page 25006029 "Report Variable Fields"
{
    Caption = 'Report Variable Fields';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006015;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Report ID"; "Report ID")
                {
                }
                field("Field Position ID"; "Field Position ID")
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

