page 33019890 "Exide Claim List"
{
    CardPageID = "Exide Claim Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Table33019886;
    SourceTableView = SORTING(Job Card No.)
                      WHERE(Issued = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Card No."; "Job Card No.")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field("Battery Part No."; "Battery Part No.")
                {
                }
            }
        }
        area(factboxes)
        {
            part(; 33019891)
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

