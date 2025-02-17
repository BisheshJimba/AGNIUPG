pageextension 50215 pageextension50215 extends "Marketing Setup"
{
    layout
    {
        addafter("Control 8")
        {
            field("Valid Mobile Nos. Format"; Rec."Valid Mobile Nos. Format")
            {
            }
        }
        addafter("Control 1905767507")
        {
            group("To-do")
            {
                Caption = 'To-do';
                field("Workday Starting Time"; Rec."Workday Starting Time")
                {
                }
                field("Working Week Length"; Rec."Working Week Length")
                {
                }
                field("Move To-dos on Non-Working Day"; Rec."Move To-dos on Non-Working Day")
                {
                }
            }
        }
    }
}

