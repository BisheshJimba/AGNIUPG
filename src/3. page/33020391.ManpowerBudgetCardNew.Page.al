page 33020391 "Manpower Budget Card New"
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
            part(BudgetMatrix; 33020386)
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

