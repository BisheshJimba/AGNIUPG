page 25006230 "Service Labor Price Groups"
{
    Caption = 'Service Labor Price Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006158;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Serv. Labor Gr.")
            {
                Caption = 'Serv. Labor Gr.';
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = SalesPrices;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006154;
                    RunPageLink = Type = CONST(Labor Group),
                                  Code=FIELD(No.);
                }
            }
        }
    }
}

