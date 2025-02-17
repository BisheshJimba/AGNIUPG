page 25006070 "Segment Sublines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table25006056;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Segment No."; "Segment No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Contact No."; "Contact No.")
                {
                    Visible = false;
                }
                field("SubLine No."; "SubLine No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Outlook)
            {
            }
        }
    }

    actions
    {
    }
}

