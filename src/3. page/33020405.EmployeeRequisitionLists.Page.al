page 33020405 "Employee Requisition Lists"
{
    CardPageID = "Emp Req Form";
    Editable = false;
    PageType = List;
    SourceTable = Table33020379;
    SourceTableView = WHERE(Posted = CONST(No));

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
                field("Posted By"; "Posted By")
                {
                    Caption = 'Posted By';
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

