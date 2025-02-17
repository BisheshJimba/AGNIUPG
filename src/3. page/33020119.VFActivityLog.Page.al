page 33020119 "VF Activity Log"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020077;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Loan No."; "Loan No.")
                {
                }
                field(Date; Date)
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Activity Type"; "Activity Type")
                {
                }
            }
        }
    }

    actions
    {
    }
}

