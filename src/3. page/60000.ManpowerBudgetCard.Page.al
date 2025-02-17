page 60000 "Manpower Budget Card"
{
    Caption = 'Manpower Budget';
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
            part(BudgetMatrix; 60001)
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

