page 25006248 "Service Plan Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Service Plan Comment Sheet';
    PageType = List;
    SourceTable = Table25006173;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Date; Date)
                {
                }
                field(Comment; Comment)
                {
                }
                field("User ID"; "User ID")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Date := WORKDATE;
    end;
}

