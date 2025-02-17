page 33020472 "Final Settlement List - ALL"
{
    CardPageID = "Final Due Settlement Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020409;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Emp Settlement No."; "Emp Settlement No.")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
                field("Date of Joining"; "Date of Joining")
                {
                }
                field("Date of Release"; "Date of Release")
                {
                }
                field(Address; Address)
                {
                }
                field(Posted; Posted)
                {
                }
            }
        }
    }

    actions
    {
    }
}

