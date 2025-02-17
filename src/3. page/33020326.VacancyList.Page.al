page 33020326 "Vacancy List"
{
    CardPageID = "Employee Requisition Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020327;

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
                field(Approved; Approved)
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field("Additional Approved Date"; "Additional Approved Date")
                {
                }
                field(Disapproved; Disapproved)
                {
                }
                field("Disapproved Date"; "Disapproved Date")
                {
                }
                field("Additional Disapproved Date"; "Additional Disapproved Date")
                {
                }
                field("Closing Date"; "Closing Date")
                {
                }
                field("Additional Closing Date"; "Additional Closing Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

