page 25006022 "Vehicle Change Log"
{
    Caption = 'Vehicle Change Log';
    DataCaptionFields = "Vehicle Serial No.";
    Editable = false;
    PageType = List;
    SourceTable = Table25006029;

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
                field("Change No."; "Change No.")
                {
                    Visible = false;
                }
                field("User ID"; "User ID")
                {
                    Visible = false;
                }
                field("Date of Change"; "Date of Change")
                {
                }
                field("Time of Change"; "Time of Change")
                {
                }
                field("Field No."; "Field No.")
                {
                }
                field("Field Description"; "Field Description")
                {
                }
                field("Old Value"; "Old Value")
                {
                }
                field("New Value"; "New Value")
                {
                }
                field("Type of Change"; "Type of Change")
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

