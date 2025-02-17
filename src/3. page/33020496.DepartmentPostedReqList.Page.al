page 33020496 "Department Posted Req List"
{
    CardPageID = "HR Requisition Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020422;
    SourceTableView = WHERE(HOD Posted=CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No."; "Requisition No.")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field(Qualifications; Qualifications)
                {
                }
                field(Experiences; Experiences)
                {
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field("Supervisor Name"; "Supervisor Name")
                {
                }
                field("HR Posted By"; "HR Posted By")
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
    }
}

