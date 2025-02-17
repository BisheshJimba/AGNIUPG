page 50076 "Posted Veh. Sales Memos"
{
    CardPageID = "Posted Veh. Sales Memo";
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
        SETRANGE("Procurement Type", "Procurement Type"::"Veh. Sales Memo");
        FILTERGROUP(10);
    end;
}

