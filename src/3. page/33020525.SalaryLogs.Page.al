page 33020525 "Salary Logs"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020519;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                    Visible = false;
                }
                field("Effective Date"; "Effective Date")
                {
                    Caption = 'Log Updated Date';
                }
                field(Level; Level)
                {
                }
                field(Grade; Grade)
                {
                }
                field("Basic with Grade"; "Basic with Grade")
                {
                }
                field("Increment Value"; "Increment Value")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
    }
}

