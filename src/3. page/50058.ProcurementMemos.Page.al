page 50058 "Procurement Memos"
{
    CardPageID = "Procurement Memo";
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
                field("Document Date"; "Document Date")
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
        SETRANGE(Posted, FALSE);
        SETRANGE("Procurement Type", "Procurement Type"::Purchase);
        FILTERGROUP(2);
        //SETRANGE(Type,Type::Purchase);
    end;
}

