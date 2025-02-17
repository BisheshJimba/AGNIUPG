page 25006222 "Service Plan Document Link"
{
    AutoSplitKey = true;
    Caption = 'Service Plan Document Link';
    DataCaptionFields = "Vehicle Serial No.";
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Table25006157;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Serv. Plan No."; "Serv. Plan No.")
                {
                }
                field("Plan Stage Recurrence"; "Plan Stage Recurrence")
                {
                    Visible = false;
                }
                field("Serv. Plan Stage Code"; "Serv. Plan Stage Code")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

