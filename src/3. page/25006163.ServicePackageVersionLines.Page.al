page 25006163 "Service Package Version Lines"
{
    AutoSplitKey = true;
    Caption = 'Service Package Version Lines';
    PageType = Worksheet;
    SourceTable = Table25006136;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        NoAssistEdit;
                    end;
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Discount %"; "Discount %")
                {
                }
                field("Line Amount"; "Line Amount")
                {
                }
                field("Job Type"; "Job Type")
                {
                }
            }
        }
    }

    actions
    {
    }
}

