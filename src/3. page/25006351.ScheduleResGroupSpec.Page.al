page 25006351 "Schedule Res. Group Spec."
{
    Caption = 'Schedule Res. Group Specification';
    DataCaptionFields = "Group Code";
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006275;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Group Code"; "Group Code")
                {
                    Visible = false;
                }
                field("Resource No."; "Resource No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Current; Current)
                {
                }
            }
        }
    }

    actions
    {
    }
}

