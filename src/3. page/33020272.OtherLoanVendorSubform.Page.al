page 33020272 "Other Loan Vendor Subform"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table33020188;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Repayment Date"; "Repayment Date")
                {
                }
                field("Repayment Installment"; "Repayment Installment")
                {
                }
            }
        }
    }

    actions
    {
    }
}

