page 25006024 "Document Reports-Selection"
{
    Caption = 'Document Reports - Selection';
    Editable = false;
    PageType = List;
    SourceTable = Table25006011;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Report ID"; "Report ID")
                {
                    Visible = false;
                }
                field(ShowReportName; ShowReportName)
                {
                    Caption = 'Report Name';
                }
            }
        }
    }

    actions
    {
    }
}

