page 33020509 "Employee Loan Register"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020509;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field(Amount; Amount)
                {
                }
                field("G/L Entry No."; "G/L Entry No.")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("User ID"; "User ID")
                {
                }
            }
        }
    }

    actions
    {
    }
}

