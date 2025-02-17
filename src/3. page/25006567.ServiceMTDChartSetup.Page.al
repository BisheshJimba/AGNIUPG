page 25006567 "Service MTD Chart Setup"
{
    PageType = Card;
    SourceTable = Table25006200;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Period Length"; "Period Length")
                {
                }
                field("Use Work Date as Base"; "Use Work Date as Base")
                {
                }
                field("Value to Calculate"; "Value to Calculate")
                {
                }
                field(Location; Location)
                {
                    Visible = false;
                }
                field("Service Advisor"; "Service Advisor")
                {
                    Visible = false;
                }
                field(Resource; Resource)
                {
                    Visible = false;
                }
                field("Group By"; "Group By")
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
        SETRANGE("User ID", USERID);
    end;
}

