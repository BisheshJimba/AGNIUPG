page 25006019 "Document Reports"
{
    Caption = 'Document Reports';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006011;

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
                field("Custom Name"; "Custom Name")
                {
                }
                field("Customer Signature"; "Customer Signature")
                {
                }
                field("Employee Signature"; "Employee Signature")
                {
                }
            }
        }
    }

    actions
    {
    }
}

