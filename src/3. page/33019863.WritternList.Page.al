page 33019863 "Writtern List"
{
    CardPageID = "Application Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020330;
    SourceTableView = SORTING(No.)
                      ORDER(Ascending)
                      WHERE(Application No.=CONST(YES));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Mobile No."; "Mobile No.")
                {
                }
                field(Status; Status)
                {
                }
                field("Vacancy No."; "Vacancy No.")
                {
                }
                field("Interviewed Date"; "Interviewed Date")
                {
                }
                field("Add. Interviewed Date"; "Add. Interviewed Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

