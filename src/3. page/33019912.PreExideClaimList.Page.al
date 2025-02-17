page 33019912 "Pre Exide Claim List"
{
    CardPageID = "Battery Job Header";
    PageType = List;
    SourceTable = Table33019894;
    SourceTableView = SORTING(Job Card No.)
                      ORDER(Ascending)
                      WHERE(Action = CONST(Replace),
                            Exide Claim=CONST(No));

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
                field("Battery Description"; "Battery Description")
                {
                }
                field(MFG; MFG)
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

