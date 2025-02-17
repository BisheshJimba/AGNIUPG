page 25006530 "Option Translations"
{
    Caption = 'Option Translations';
    DataCaptionFields = "Option Type", "Option Code";
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Table25006375;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Option Type"; "Option Type")
                {
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
                field("Option Subtype"; "Option Subtype")
                {
                }
                field("Option Code"; "Option Code")
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

