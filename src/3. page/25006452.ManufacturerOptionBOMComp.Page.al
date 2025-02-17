page 25006452 "Manufacturer Option BOM Comp."
{
    AutoSplitKey = true;
    Caption = 'Manufacturer Option BOM Comp.';
    DataCaptionExpression = "Parent Option Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006371;

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
                field("Parent Option Code"; "Parent Option Code")
                {
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field(Type; Type)
                {
                }
                field("Option Code"; "Option Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Bill of Materials"; "Bill of Materials")
                {
                }
            }
        }
    }

    actions
    {
    }
}

