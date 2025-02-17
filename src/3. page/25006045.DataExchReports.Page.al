page 25006045 "Data Exch. Reports"
{
    Caption = 'Data Exch. Reports';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006051;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Document Profile"; "Document Profile")
                {
                }
                field("Document Functional Type"; "Document Functional Type")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field(Sequence; Sequence)
                {
                }
                field("Report ID"; "Report ID")
                {
                }
                field("Report Name"; "Report Name")
                {
                }
                field("Take From Lines"; "Take From Lines")
                {
                }
            }
        }
    }

    actions
    {
    }
}

