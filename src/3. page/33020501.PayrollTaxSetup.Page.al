page 33020501 "Payroll Tax Setup"
{
    PageType = Card;
    SourceTable = Table33020505;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                }
                field("Effective from"; "Effective from")
                {
                }
                field(Description; Description)
                {
                }
                field("Effective to"; "Effective to")
                {
                }
                field("Special Tax Exempt %"; "Special Tax Exempt %")
                {
                }
            }
            part(; 33020502)
            {
                SubPageLink = Code = FIELD(Code);
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
    }
}

