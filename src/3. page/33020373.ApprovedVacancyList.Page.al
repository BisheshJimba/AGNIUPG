page 33020373 "Approved Vacancy List"
{
    CardPageID = "Approved Vacancy Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020327;
    SourceTableView = SORTING(Vacany No.)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vacany No."; "Vacany No.")
                {
                }
                field("Vacancy Type"; "Vacancy Type")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field("Job Description"; "Job Description")
                {
                }
                field("Opening Date"; "Opening Date")
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field(Department; Department)
                {
                }
                field("Job Locaiton"; "Job Locaiton")
                {
                }
            }
        }
    }

    actions
    {
    }
}

