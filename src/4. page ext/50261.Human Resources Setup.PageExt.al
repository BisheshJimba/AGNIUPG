pageextension 50261 pageextension50261 extends "Human Resources Setup"
{
    layout
    {
        addafter("Control 2")
        {
            field("HR Start From Month"; Rec."HR Start From Month")
            {
            }
        }
        addafter("Control 4")
        {
            field("Employee Dimension"; Rec."Employee Dimension")
            {
            }
            group(Training)
            {
                field("Training Request No."; Rec."Training Request No.")
                {
                }
            }
        }
    }
    actions
    {
        addafter("Action 20")
        {
            action("Leave Encash")
            {
                Enabled = false;
                Visible = false;

                trigger OnAction()
                var
                    PayrollManagement: Codeunit "33020503";
                begin
                    PayrollManagement.EncashLeave('', 1);
                end;
            }
        }
    }
}

