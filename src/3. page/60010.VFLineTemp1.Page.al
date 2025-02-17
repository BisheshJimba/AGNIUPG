page 60010 "VF Line Temp1"
{
    PageType = List;
    SourceTable = Table33020063;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.")
                {
                }
                field("Installment No."; "Installment No.")
                {
                }
                field("EMI Mature Date"; "EMI Mature Date")
                {
                }
                field("EMI Amount"; "EMI Amount")
                {
                }
                field("Calculated Principal"; "Calculated Principal")
                {
                }
                field("Calculated Interest"; "Calculated Interest")
                {
                }
                field(Balance; Balance)
                {
                }
                part(VFPaymentLine; 60011)
                {
                }
            }
        }
    }

    actions
    {
    }
}

