page 33020554 "Attendance Journal Batches"
{
    PageType = List;
    SourceTable = Table33020553;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

