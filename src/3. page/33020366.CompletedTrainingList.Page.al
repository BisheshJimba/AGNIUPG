page 33020366 "Completed Training List"
{
    CardPageID = "Training Request Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020359;
    SourceTableView = WHERE(Completed = CONST(Yes));

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
                field(Approved; Approved)
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field(Completed; Completed)
                {
                }
                field("Completed Date"; "Completed Date")
                {
                }
                field("Very Good (%)"; "Very Good (%)")
                {
                }
                field("Good (%)"; "Good (%)")
                {
                }
                field("Not Good (%)"; "Not Good (%)")
                {
                }
                field("Very Useful (%)"; "Very Useful (%)")
                {
                }
                field("Useful (%)"; "Useful (%)")
                {
                }
                field("Not Useful (%)"; "Not Useful (%)")
                {
                }
            }
        }
    }

    actions
    {
    }
}

