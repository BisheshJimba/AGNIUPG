page 33020042 "Gate Entry Comment List"
{
    Caption = 'Gate Entry Comment List';
    DataCaptionFields = "Gate Entry Type", "No.";
    Editable = false;
    PageType = List;
    SourceTable = Table33020042;

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

