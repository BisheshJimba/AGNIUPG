page 33020161 "Test Drive Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Table33020155;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Rating Factor"; "Rating Factor")
                {
                    Editable = false;
                }
                field("Rating Factor Description"; "Rating Factor Description")
                {
                    Editable = false;
                }
                field("Excellent (5)"; "Excellent (5)")
                {
                }
                field("V. Good (4)"; "V. Good (4)")
                {
                }
                field("Average (3)"; "Average (3)")
                {
                }
                field("Below Average (2)"; "Below Average (2)")
                {
                }
                field("Bad (1)"; "Bad (1)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

