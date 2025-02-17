page 33020365 "Disapproved Training Requests"
{
    CardPageID = "Training Request Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020359;
    SourceTableView = WHERE(Rejected = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tr. Req. No."; "Tr. Req. No.")
                {
                }
                field(Department; Department)
                {
                }
                field("Training Code"; "Training Code")
                {
                }
                field("Training Topic"; "Training Topic")
                {
                }
                field("Training Objective"; "Training Objective")
                {
                }
                field("Duration (days)"; "Duration (days)")
                {
                }
                field(ODT; ODT)
                {
                }
                field("Requested By"; "Requested By")
                {
                }
                field("Requested Date"; "Requested Date")
                {
                }
                field(Rejected; Rejected)
                {
                }
                field("Rejected By"; "Rejected By")
                {
                }
                field("Rejected Date"; "Rejected Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

