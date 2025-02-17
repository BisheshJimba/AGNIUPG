page 33020125 "VF FactBox"
{
    Caption = 'Loan Statistics';
    PageType = CardPart;
    SourceTable = Table33020062;

    layout
    {
        area(content)
        {
            field("No of Due Days"; "No of Due Days")
            {
            }
            field("Due Installment as of Today"; "Due Installment as of Today")
            {
            }
            field("EMI Maturity Date"; "EMI Maturity Date")
            {
            }
            field("Last Payment Date"; "Last Payment Date")
            {
            }
            field("Total Due as of Today"; "Total Due as of Today")
            {
            }
            field("Tenure in Months"; "Tenure in Months")
            {
            }
            field("Due Installments"; "Due Installments")
            {
            }
        }
    }

    actions
    {
    }

    var
        DaysToExpire: Integer;
}

