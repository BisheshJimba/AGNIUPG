page 33019926 "Open Job Cards"
{
    CardPageID = "Job Card Document";
    Editable = false;
    PageType = List;
    SourceTable = Table33019884;

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
                field("Battery Serial No."; "Battery Serial No.")
                {
                }
                field(MFG; MFG)
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

