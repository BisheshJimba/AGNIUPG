page 33020345 "Shortlisted List"
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
                      WHERE(Shortlisted = CONST(Yes));

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
                field("Shortlisted Date"; "Shortlisted Date")
                {
                }
                field("Add. Shortlisted Date"; "Add. Shortlisted Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Convet to Employee")
            {
                Caption = 'Convert To Employee';
            }
        }
    }
}

