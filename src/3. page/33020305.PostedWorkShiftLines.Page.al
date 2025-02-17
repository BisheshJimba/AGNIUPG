page 33020305 "Posted Work Shift Lines"
{
    PageType = List;
    SourceTable = Table33020349;
    SourceTableView = WHERE(Post = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Changed Date"; "Changed Date")
                {
                }
                field("Shift Code"; "Shift Code")
                {
                }
                field(Shift; Shift)
                {
                }
                field("In Time"; "In Time")
                {
                }
                field("Out Time"; "Out Time")
                {
                }
                field("Lunch Start"; "Lunch Start")
                {
                }
                field("Lunch End"; "Lunch End")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Work Hours"; "Work Hours")
                {
                }
                field("Lunch Minutes"; "Lunch Minutes")
                {
                }
            }
        }
    }

    actions
    {
    }
}

