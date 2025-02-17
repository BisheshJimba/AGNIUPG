page 33020556 "Att. Journal Template List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020552;

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

