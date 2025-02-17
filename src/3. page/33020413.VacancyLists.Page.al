page 33020413 "Vacancy Lists"
{
    CardPageID = "Vacancy Header Document";
    PageType = List;
    SourceTable = Table33020380;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vacancy No"; "Vacancy No")
                {
                }
                field("Vacancy Type"; "Vacancy Type")
                {
                }
                field("Posted Date"; "Posted Date")
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

