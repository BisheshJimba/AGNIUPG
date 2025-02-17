page 33020112 "Journal Setup Agile"
{
    PageType = List;
    SourceTable = Table33019874;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID"; "Table ID")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Gen. Journal Template Name"; "Gen. Journal Template Name")
                {
                }
                field("Gen. Journal Batch Name"; "Gen. Journal Batch Name")
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

