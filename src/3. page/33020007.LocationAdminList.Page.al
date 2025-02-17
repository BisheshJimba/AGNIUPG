page 33020007 "Location - Admin List"
{
    CardPageID = "Location - Admin Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33019986;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Contact; Contact)
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
            }
        }
    }

    actions
    {
    }
}

