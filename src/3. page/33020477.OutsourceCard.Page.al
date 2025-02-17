page 33020477 "Outsource Card"
{
    PageType = Card;
    SourceTable = Table33020412;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Outsource No."; "Outsource No.")
                {
                }
                field(Date; Date)
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
            }
            part(; 33020476)
            {
                SubPageLink = Outsource No.=FIELD(Outsource No.),
                              Date=FIELD(Date);
            }
        }
        area(factboxes)
        {
            systempart(;Notes)
            {
            }
        }
    }

    actions
    {
    }
}

