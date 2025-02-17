page 50072 "Posted Procurement Memos Sales"
{
    CardPageID = "Posted Procurement Memo Sales";
    Editable = false;
    PageType = List;
    SourceTable = Table130415;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Memo No."; "Memo No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(0);
        SETRANGE(Posted, TRUE);
        SETRANGE("Procurement Type", "Procurement Type"::Sales);
        FILTERGROUP(10);
    end;
}

