page 25006284 "Common Log Entries"
{
    PageType = List;
    SourceTable = Table25006190;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Date and Time"; "Date and Time")
                {
                }
                field("Processing Info"; "Processing Info")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Field No."; "Field No.")
                {
                }
                field("Field Name"; "Field Name")
                {
                }
                field("Old Value"; "Old Value")
                {
                }
                field("New Value"; "New Value")
                {
                }
                field("Primary Key"; "Primary Key")
                {
                    Visible = false;
                }
                field("Object Type"; "Object Type")
                {
                    Visible = false;
                }
                field("Object No."; "Object No.")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

