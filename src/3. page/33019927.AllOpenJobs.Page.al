page 33019927 "All Open Jobs"
{
    CardPageID = "Battery Job Header";
    Editable = false;
    PageType = List;
    SourceTable = Table33019894;
    SourceTableView = WHERE(Action = CONST(" "),
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
                field("Battery Part No."; "Battery Part No.")
                {
                }
                field("Battery Serial No."; "Battery Serial No.")
                {
                }
                field(MFG; MFG)
                {
                }
                field("OE/Trd"; "OE/Trd")
                {
                }
                field("Location Code"; "Location Code")
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

