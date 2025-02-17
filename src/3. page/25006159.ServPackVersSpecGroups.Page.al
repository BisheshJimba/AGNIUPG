page 25006159 "Serv. Pack. Vers. Spec.-Groups"
{
    Caption = 'Serv. Pack. Vers. Spec.-Groups';
    PageType = List;
    SourceTable = Table25006136;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Package No."; "Package No.")
                {
                    Visible = false;
                }
                field("Version No."; "Version No.")
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
                    Visible = false;
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

