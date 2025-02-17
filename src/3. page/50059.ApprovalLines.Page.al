page 50059 "Approval Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table104199;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                }
                field("Sequence No."; "Sequence No.")
                {
                }
                field(Approved; Approved)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Type := Type::Memo;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::Memo;
    end;
}

