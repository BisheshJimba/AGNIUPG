page 33020346 "Selected List"
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
                      WHERE(Select = CONST(Yes));

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
                field(Email; Email)
                {
                }
                field(Status; Status)
                {
                }
                field("Vacancy No."; "Vacancy No.")
                {
                }
                field("SR Date"; "SR Date")
                {
                    Caption = '<Selected Date>';
                }
                field("Add. SR Date"; "Add. SR Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

