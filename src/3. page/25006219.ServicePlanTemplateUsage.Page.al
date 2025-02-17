page 25006219 "Service Plan Template Usage"
{
    Caption = 'Service Plan Template Usage';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006156;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Template Code"; "Template Code")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Status"; "Vehicle Status")
                {
                }
            }
        }
    }

    actions
    {
    }
}

