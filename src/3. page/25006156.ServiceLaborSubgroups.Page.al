page 25006156 "Service Labor Subgroups"
{
    Caption = 'Service Labor Subgroups';
    DataCaptionFields = "Group Code";
    PageType = List;
    SourceTable = Table25006125;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field(Code; Code)
                {
                }
                field("Group Code"; "Group Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
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

