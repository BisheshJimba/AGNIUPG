page 33019818 "NCHL-NPI App. User Groups"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table33019816;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("User ID"; "User ID")
                {
                }
                field(Sequence; Sequence)
                {
                }
                field("New User ID"; "New User ID")
                {
                    Visible = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetControlProperty;
    end;

    trigger OnOpenPage()
    begin
        SetControlProperty;
    end;

    var
        UserSetup: Record "91";
        ApprovalVisible: Boolean;

    local procedure SetControlProperty()
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Approve NCHL-NPI User" THEN
            ApprovalVisible := FALSE
        ELSE
            ApprovalVisible := TRUE;
    end;
}

