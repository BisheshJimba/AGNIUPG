page 25006491 "Manufacturer Option Conditions"
{
    AutoSplitKey = true;
    Caption = 'Manufacturer Option Conditions';
    DataCaptionExpression = "Option Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006374;

    layout
    {
        area(content)
        {
            repeater()
            {
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
                field("Option Type"; "Option Type")
                {
                }
                field("Option Code"; "Option Code")
                {
                }
                field("Option Description"; "Option Description")
                {
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Option External Code"; "Option External Code")
                {
                    Visible = false;
                }
                field("Condition Type"; "Condition Type")
                {
                }
                field("Condition Option Type"; "Condition Option Type")
                {
                }
                field("Condition Option Code"; "Condition Option Code")
                {
                }
                field("Condition Option Description"; "Condition Option Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

