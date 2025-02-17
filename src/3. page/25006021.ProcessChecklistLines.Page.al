page 25006021 "Process Checklist Lines"
{
    Caption = 'Inventory Checklist Lines';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006028;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Process Checklist No."; "Process Checklist No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                }
                field("Type Code"; "Type Code")
                {
                }
                field("Type Description"; "Type Description")
                {
                }
                field(Value; Value)
                {
                }
                field("Value Description"; "Value Description")
                {
                }
            }
        }
    }

    actions
    {
    }
}

