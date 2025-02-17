page 25006188 "Service Comment List EDMS"
{
    Caption = 'Service Comment List EDMS';
    DataCaptionFields = Type, "No.";
    Editable = false;
    PageType = List;
    SourceTable = Table25006148;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field(Date; Date)
                {
                }
                field(Comment; Comment)
                {
                }
            }
        }
    }

    actions
    {
    }
}

