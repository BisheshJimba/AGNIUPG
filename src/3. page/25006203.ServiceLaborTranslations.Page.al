page 25006203 "Service Labor Translations"
{
    Caption = 'Service Labor Translations';
    DataCaptionFields = "No.";
    PageType = List;
    SourceTable = Table25006127;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                    Visible = false;
                }
                field("Language Code"; "Language Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

