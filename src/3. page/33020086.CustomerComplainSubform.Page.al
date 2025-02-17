page 33020086 "Customer Complain Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table33019848;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Remarks/Complain/Suggestions"; "Remarks/Complain/Suggestions")
                {
                }
                field("Date of Entry"; "Date of Entry")
                {
                    Editable = false;
                }
                field("Job Card No."; "Job Card No.")
                {
                }
                field("Posted Job Card No."; "Posted Job Card No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

