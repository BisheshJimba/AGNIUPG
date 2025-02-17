page 33019931 "Warranty List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33019894;
    SourceTableView = WHERE(Action = CONST(Replace));

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
                field("Battery Description"; "Battery Description")
                {
                }
                field("Warranty Percentage"; "Warranty Percentage")
                {
                }
                field(TotalClaimAmount; TotalClaimAmount)
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

