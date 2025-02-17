page 25006372 "Schedule Cell Config."
{
    Caption = 'Schedule Cell Config.';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006280;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Source Type"; "Source Type")
                {
                }
                field("Source Ref. No."; "Source Ref. No.")
                {
                }
                field(Sequence; Sequence)
                {
                }
                field(Prefix; Prefix)
                {
                }
            }
        }
    }

    actions
    {
    }
}

