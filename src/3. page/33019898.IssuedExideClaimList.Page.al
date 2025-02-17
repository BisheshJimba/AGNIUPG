page 33019898 "Issued Exide Claim List"
{
    CardPageID = "Issued Exide Claim Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019886;
    SourceTableView = SORTING(Job Card No.)
                      WHERE(Issued = CONST(Yes));

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
                field("Claim Date"; "Claim Date")
                {
                }
                field("Battery Part No."; "Battery Part No.")
                {
                }
                field("Issue Part No."; "Issue Part No.")
                {
                }
                field(Settled; Settled)
                {
                }
                field("Settled Date"; "Settled Date")
                {
                }
            }
        }
        area(factboxes)
        {
            part("Issued Exide Claim Detail"; 33019891)
            {
                Caption = 'Issued Exide Claim Detail';
                SubPageLink = Job Card No.=FIELD(Job Card No.);
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

