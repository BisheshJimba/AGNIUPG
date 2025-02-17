page 33019933 "Pending Job Card List"
{
    CardPageID = "Rejected Job Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33019894;
    SourceTableView = SORTING(Job Card No.)
                      ORDER(Ascending)
                      WHERE(Action = CONST(Pending));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Card No."; "Job Card No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(Month; Month)
                {
                }
                field("Battery Description"; "Battery Description")
                {
                }
                field("Job End Date"; "Job End Date")
                {
                }
            }
        }
        area(factboxes)
        {
            part(; 33019888)
            {
                SubPageLink = Job Card No.=FIELD(Job Card No.);
                    SubPageView = SORTING(Job Card No.);
            }
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}

