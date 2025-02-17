page 33020069 "Net Realization Value Setup"
{
    PageType = List;
    SourceTable = Table33020066;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Model Version"; "Model Version")
                {

                    trigger OnValidate()
                    begin
                        //CurrPage.UPDATE;
                    end;
                }
                field("Model Version No. 2"; "Model Version No. 2")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Market Price"; "Market Price")
                {
                    Visible = false;
                }
                field("Depreciation Rate"; "Depreciation Rate")
                {
                }
                field("System Sales Price"; "System Sales Price")
                {
                    Visible = false;
                }
                field("Commission Rate"; "Commission Rate")
                {
                }
            }
        }
    }

    actions
    {
    }
}

