page 33019887 "Job Card List"
{
    CardPageID = "Job Card Document";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Table33019884;
    SourceTableView = SORTING(Job Card No.)
                      WHERE(Exide Claim=CONST(No),
                            Action=CONST(" "));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Card No.";"Job Card No.")
                {
                }
                field("Customer Name";"Customer Name")
                {
                }
                field("Battery Serial No.";"Battery Serial No.")
                {
                }
                field(MFG;MFG)
                {
                }
            }
        }
        area(factboxes)
        {
            part(;33019888)
            {
                SubPageLink = Job Card No.=FIELD(Job Card No.);
                SubPageView = SORTING(Job Card No.);
            }
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
    }
}

