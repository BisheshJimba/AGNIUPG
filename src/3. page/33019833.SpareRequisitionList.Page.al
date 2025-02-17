page 33019833 "Spare Requisition List"
{
    CardPageID = "Spare Requisition Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33019831;
    SourceTableView = SORTING(No.)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("No."; "No.")
                {
                }
                field("Date Archived"; "Date Archived")
                {
                }
                field("Time Archived"; "Time Archived")
                {
                }
                field("Archived By"; "Archived By")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field(Location; Location)
                {
                }
                field(Status; Status)
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
    }
}

