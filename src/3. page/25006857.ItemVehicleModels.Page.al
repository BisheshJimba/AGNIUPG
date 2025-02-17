page 25006857 "Item Vehicle Models"
{
    Caption = 'Item Vehicle Models';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006755;

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
                field("Make Code"; "Make Code")
                {
                }
                field("Model No."; "Model No.")
                {
                }
                field("External Code"; "External Code")
                {
                }
                field("Model Version"; "Model Version")
                {
                }
                field(Quantity; Quantity)
                {
                }
            }
        }
    }

    actions
    {
    }
}

