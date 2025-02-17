page 33020439 "Emp Training acquired"
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
                    Caption = 'Duration (Days)';
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

