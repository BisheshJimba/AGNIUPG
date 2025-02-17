page 33019832 "Spare Requisition Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table33019831;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field(Location; Location)
                {
                }
                field("Archived By"; "Archived By")
                {
                }
                field("Date Archived"; "Date Archived")
                {
                }
                field("Time Archived"; "Time Archived")
                {
                }
            }
            part(; 33019831)
            {
                SubPageLink = Archive Header No.=FIELD(No.);
            }
        }
    }

    actions
    {
    }
}

