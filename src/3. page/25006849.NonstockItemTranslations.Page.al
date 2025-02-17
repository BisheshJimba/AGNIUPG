page 25006849 "Nonstock Item Translations"
{
    Caption = 'Nonstock Item Translations';
    DataCaptionFields = "Nonstock Item Entry No.";
    PageType = List;
    SourceTable = Table25006759;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Nonstock Item Entry No."; "Nonstock Item Entry No.")
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

