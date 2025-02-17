page 33020463 "Assign Manager List"
{
    CardPageID = "Assign Manager Card";
    PageType = List;
    SourceTable = Table33020408;
    SourceTableView = WHERE(Assignment Posted=CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Assign No."; "Assign No.")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field(Designation; Designation)
                {
                }
                field("Assignment Posted"; "Assignment Posted")
                {
                }
                field("Assignment Date"; "Assignment Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

