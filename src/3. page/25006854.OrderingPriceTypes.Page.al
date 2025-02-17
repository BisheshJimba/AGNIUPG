page 25006854 "Ordering Price Types"
{
    Caption = 'Ordering Price Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006763;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Inbound Time"; "Inbound Time")
                {
                }
                field("Outbound Time"; "Outbound Time")
                {
                }
            }
        }
    }

    actions
    {
    }
}

