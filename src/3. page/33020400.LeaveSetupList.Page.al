page 33020400 "Leave Setup List"
{
    CardPageID = "Leave Setup Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020345;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Leave Type Code"; "Leave Type Code")
                {
                }
                field(Description; Description)
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

