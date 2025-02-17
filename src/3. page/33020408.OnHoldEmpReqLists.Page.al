page 33020408 "On Hold Emp Req. Lists"
{
    CardPageID = "Emp Req Card HR";
    Editable = false;
    PageType = List;
    SourceTable = Table33020379;
    SourceTableView = WHERE(Status = CONST(On Hold));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmpReqNo; EmpReqNo)
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Position Name"; "Position Name")
                {
                }
                field("No. of Position"; "No. of Position")
                {
                }
                field("Posted Date"; "Posted Date")
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

