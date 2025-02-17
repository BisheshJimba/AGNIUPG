page 33020343 "Table Information List"
{
    PageType = List;
    SourceTable = Table2000000028;
    SourceTableView = SORTING(Company Name, Table No.)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table No."; "Table No.")
                {
                }
                field("Table Name"; "Table Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

