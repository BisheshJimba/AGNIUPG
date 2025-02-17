page 33020494 "Staff Requisition List"
{
    CardPageID = "HOD Staff Req Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020422;
    SourceTableView = WHERE(HOD Posted=CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Job Title Code"; "Job Title Code")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field("Branch Code"; "Branch Code")
                {
                }
                field("Supervisor Code"; "Supervisor Code")
                {
                }
                field(Segment; Segment)
                {
                }
                field("Date Required"; "Date Required")
                {
                }
                field("Nature of Manpower"; "Nature of Manpower")
                {
                }
                field("No. of Staff Required"; "No. of Staff Required")
                {
                }
                field("Duration (in months)"; "Duration (in months)")
                {
                }
                field("Brief Description of Duties"; "Brief Description of Duties")
                {
                }
                field(Qualifications; Qualifications)
                {
                }
                field(Experiences; Experiences)
                {
                }
                field("Skills and Qualities"; "Skills and Qualities")
                {
                }
                field(Requirement; Requirement)
                {
                }
                field("Staff Replaced"; "Staff Replaced")
                {
                }
                field("Staff Replaced Name"; "Staff Replaced Name")
                {
                }
                field("Reason for replacement"; "Reason for replacement")
                {
                }
            }
        }
    }

    actions
    {
    }
}

