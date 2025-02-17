page 33020339 "Location Master List"
{
    CardPageID = "Location Master Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020337;

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
                field(Type; Type)
                {
                }
                field(Blocked; Blocked)
                {
                }
            }
        }
    }

    actions
    {
    }
}

