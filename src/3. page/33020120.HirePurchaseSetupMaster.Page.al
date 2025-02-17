page 33020120 "Hire Purchase Setup Master"
{
    Caption = 'Hire Purchase Setup Master';
    PageType = List;
    SourceTable = Table33020080;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field(Code; Code)
                {
                }
                field(Sequence; Sequence)
                {
                }
                field("Skip Checking When Loan App."; "Skip Checking When Loan App.")
                {
                    Caption = 'Skip Checking When Loan Approval';
                }
            }
        }
    }

    actions
    {
    }
}

