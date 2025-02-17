page 33020325 "Pending Vacancy Post"
{
    CardPageID = "Vacancy Card for HR";
    Editable = false;
    PageType = List;
    SourceTable = Table33020327;
    SourceTableView = SORTING(Vacany No.)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(No),
                            Disapproved = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vacany No."; "Vacany No.")
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
                field("Additional Opening Date"; "Additional Opening Date")
                {
                }
                field(Remarks; Remarks)
                {
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
        area(processing)
        {
        }
    }
}

