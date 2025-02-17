page 25006157 "Service Lines - Groups"
{
    Caption = 'Service Lines - Groups';
    Editable = false;
    PageType = List;
    SourceTable = Table25006146;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Document Type"; "Document Type")
                {
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field(Group; Group)
                {
                }
                field("Group ID"; "Group ID")
                {
                    Visible = false;
                }
                field("Group Description"; "Group Description")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

