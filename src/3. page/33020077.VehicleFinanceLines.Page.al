page 33020077 "Vehicle Finance Lines"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020063;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line Cleared"; "Line Cleared")
                {
                }
                field("Installment No."; "Installment No.")
                {
                }
                field("EMI Mature Date"; "EMI Mature Date")
                {
                    ShowMandatory = true;
                }
                field("Calculated Principal"; "Calculated Principal")
                {
                }
                field("Calculated Interest"; "Calculated Interest")
                {
                }
                field("EMI Amount"; "EMI Amount")
                {
                }
                field(Balance; Balance)
                {
                }
                field("Prepayment Amount"; "Prepayment Amount")
                {
                }
                field("Remaining Principal Amount"; "Remaining Principal Amount")
                {
                }
                field("Principal Paid"; "Principal Paid")
                {
                }
                field("Interest Paid"; "Interest Paid")
                {
                }
                field("Calculated Penalty"; "Calculated Penalty")
                {
                }
                field("Penalty Paid"; "Penalty Paid")
                {
                }
                field("Delay by No. of Days"; "Delay by No. of Days")
                {
                    ShowMandatory = true;
                }
                field("Last Payment Date"; "Last Payment Date")
                {
                }
                field("Last Receipt No."; "Last Receipt No.")
                {
                }
                field(Rescheduled; Rescheduled)
                {
                }
                field("Wave Penalty"; "Wave Penalty")
                {
                }
                field("Loan Capitalized"; "Loan Capitalized")
                {
                    Editable = false;
                }
                field("Defer Principal"; "Defer Principal")
                {
                }
                field("Deferred Principal"; "Deferred Principal")
                {
                }
            }
        }
    }

    actions
    {
    }
}

