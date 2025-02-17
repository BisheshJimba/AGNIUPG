page 33020401 "Manpower Total"
{
    Caption = 'Manpower Budget Variance';
    PageType = Document;
    SourceTable = Table33020376;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field(Description; Description)
                {
                }
            }
            part(BudgetMatrix; 33020402)
            {
                Caption = 'Budget Matrix';
                SubPageLink = Fiscal Year=FIELD(Fiscal Year);
            }
        }
    }

    actions
    {
    }
}

