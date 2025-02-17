page 50070 "Procurement Memos Sales"
{
    CardPageID = "Procurement Memo Sales";
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Procurement Type" := "Procurement Type"::Sales;
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(0);
        SETRANGE(Posted, FALSE);
        SETRANGE("Procurement Type", "Procurement Type"::Sales);
        FILTERGROUP(2);
        //SETRANGE(Type,Type::Purchase);
    end;
}

