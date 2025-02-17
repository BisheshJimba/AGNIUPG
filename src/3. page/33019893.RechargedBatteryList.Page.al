page 33019893 "Recharged Battery List"
{
    CardPageID = "Recharged Job Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019894;
    SourceTableView = WHERE(Action = CONST(Recharge));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Card No."; "Job Card No.")
                {
                }
                field("Battery Part No."; "Battery Part No.")
                {
                }
                field("Battery Serial No."; "Battery Serial No.")
                {
                }
                field("Job Start Date"; "Job Start Date")
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

