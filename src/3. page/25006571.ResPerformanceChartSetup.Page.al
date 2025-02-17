page 25006571 "Res. Performance Chart Setup"
{
    Caption = 'Resource Performance Chart Setup';
    PageType = Card;
    SourceTable = Table25006203;

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
                field("Chart Type"; "Chart Type")
                {
                }
                field(Location; Location)
                {
                }
                field("Service Person"; "Service Person")
                {
                }
                field("Resource No."; "Resource No.")
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

