page 33020381 "Employee Requisition List"
{
    CardPageID = "Employee Requisition Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020365;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Entry Date"; "Entry Date")
                {
                }
                field(Department; Department)
                {
                }
                field(Designation; Designation)
                {
                }
                field("New Position"; "New Position")
                {
                }
                field("Replaced Person Name"; "Replaced Person Name")
                {
                }
                field(Reason; Reason)
                {
                }
                field("Reporting Status"; "Reporting Status")
                {
                }
                field("Job Description"; "Job Description")
                {
                }
                field("Experience Reqd."; "Experience Reqd.")
                {
                }
                field("Ideal Age"; "Ideal Age")
                {
                }
                field("Recruitment Date"; "Recruitment Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

