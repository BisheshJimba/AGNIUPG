page 33020019 "LC Amend - Vehicle Tracking"
{
    PageType = List;
    SourceTable = Table33020017;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("VC No."; "VC No.")
                {
                }
                field("Model Description"; "Model Description")
                {
                }
                field(Description; Description)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("No. of Vehicle"; "No. of Vehicle")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("No. of Vehicle Received"; "No. of Vehicle Received")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; MyNotes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
    }
}

