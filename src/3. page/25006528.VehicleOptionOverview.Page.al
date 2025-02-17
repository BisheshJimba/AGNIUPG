page 25006528 "Vehicle Option Overview"
{
    Caption = 'Vehicle Option Overview';
    Editable = false;
    PageType = List;
    SourceTable = Table25006388;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Option Type"; "Option Type")
                {
                }
                field("Option Subtype"; "Option Subtype")
                {
                }
                field("Option Code"; "Option Code")
                {
                }
                field(Description; Description)
                {
                }
                field(Standard; Standard)
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

