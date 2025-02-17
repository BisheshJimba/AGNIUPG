page 33020107 "Service Scheme List"
{
    CardPageID = "Service Scheme Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33019873;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

