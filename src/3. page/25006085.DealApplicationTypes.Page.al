page 25006085 "Deal Application Types"
{
    Caption = 'Deal Application Types';
    PageType = List;
    SourceTable = Table25006055;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("System Type"; "System Type")
                {
                }
            }
        }
    }

    actions
    {
    }
}

