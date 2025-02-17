page 25006043 "Data Exch. Reports-Selection"
{
    Caption = 'Data Exch. Reports-Selection';
    Editable = false;
    PageType = List;
    SourceTable = Table25006051;

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

