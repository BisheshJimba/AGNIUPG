page 33019840 "Fill Rate Calculation Card"
{

    layout
    {
        area(content)
        {
            part(Items; 33019839)
            {
                Caption = 'Items';
            }
            group("Fill Rate Calculation")
            {
                Caption = 'Fill Rate Calculation';
                field(ItemAnalysisMgt.GetOrderQty;
                    ItemAnalysisMgt.GetOrderQty)
                {
                    Caption = 'Total Ordered Qty.';
                }
                field(ItemAnalysisMgt.GetSupplyQty;
                    ItemAnalysisMgt.GetSupplyQty)
                {
                    Caption = 'Total Supplies Qty.';
                }
                field(FORMAT(ROUND(ItemAnalysisMgt.GetFillRate, 0.01, '>')) + '%'; FORMAT(ROUND(ItemAnalysisMgt.GetFillRate,0.01,'>')) + '%')
                {
                    Caption = 'Fill Rate';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Calculate Fill Rate")
            {
                Caption = 'Calculate Fill Rate';
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FillRateAnalysis.RUNMODAL;
                    ItemAnalysisMgt.CalculateFillRate;
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ItemAnalysisMgt.CalculateFillRate;
        CurrPage.UPDATE;
    end;

    var
        FillRateAnalysis: Report "33019834";
        ItemAnalysisMgt: Codeunit "33019833";
}

