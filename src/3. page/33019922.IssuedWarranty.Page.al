page 33019922 "Issued Warranty"
{
    CardPageID = "Exide Claim Card GRN";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = Table33019886;

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
                field("Issue Part No."; "Issue Part No.")
                {
                }
                field("Issue No."; "Issue No.")
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

