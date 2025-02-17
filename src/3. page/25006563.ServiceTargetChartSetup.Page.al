page 25006563 "Service Target Chart Setup"
{
    Caption = 'Service Target Chart Setup';
    PageType = Card;
    SourceTable = Table25006199;

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
                field("Service Advisor"; "Service Advisor")
                {
                }
                field(Resource; Resource)
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

