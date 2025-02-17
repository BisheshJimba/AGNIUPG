page 25006226 "Ext. Serv. Jnl. Template List"
{
    Caption = 'External Service Journal Template List';
    PageType = List;
    SourceTable = Table25006142;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
                field("Test Report ID"; "Test Report ID")
                {
                }
                field("Form ID"; "Form ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

