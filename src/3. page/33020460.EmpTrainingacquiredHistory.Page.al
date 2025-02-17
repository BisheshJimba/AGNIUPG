page 33020460 "Emp Training acquired History"
{
    Editable = true;
    PageType = List;
    SourceTable = Table33020400;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Training Topic"; "Training Topic")
                {
                }
                field("Training Code"; "Training Code")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Duration (Months)"; "Duration (Months)")
                {
                }
                field("Request No."; "Request No.")
                {
                    TableRelation = "Training Requests Header"."Tr. Req. No.";
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field("New Training"; "New Training")
                {
                }
                field("Completed Date"; "Completed Date")
                {
                }
                field(Completed; Completed)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        TrainingHeader: Record "33020359";
        TrainingLines: Record "33020360";
        "Training Topic": Text[30];
}

