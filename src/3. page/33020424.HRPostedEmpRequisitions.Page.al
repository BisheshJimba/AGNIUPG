page 33020424 "HR Posted Emp Requisitions"
{
    CardPageID = "Emp Req Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020379;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmpReqNo; EmpReqNo)
                {
                    Editable = false;
                }
                field("Department Name"; "Department Name")
                {
                    Editable = false;
                }
                field("Position Name"; "Position Name")
                {
                }
                field("No. of Position"; "No. of Position")
                {
                    Editable = false;
                }
                field("Posted Date"; "Posted Date")
                {
                    Editable = false;
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

