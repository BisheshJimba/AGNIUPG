page 50061 "Posted Procurement Memos"
{
    CardPageID = "Posted Procurement Memo";
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
                field("User ID"; "User ID")
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
        //FILTERGROUP(10); AASTHA UPG
        SETRANGE("Procurement Type", "Procurement Type"::Purchase);
        FILTERGROUP(10);
    end;
}

