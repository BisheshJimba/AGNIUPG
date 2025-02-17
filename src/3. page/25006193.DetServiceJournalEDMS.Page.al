page 25006193 "Det. Service Journal EDMS"
{
    Caption = 'Det. Service Journal EDMS';
    PageType = List;
    SourceTable = Table25006187;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Resource No."; "Resource No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

