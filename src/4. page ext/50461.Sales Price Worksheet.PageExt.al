pageextension 50461 pageextension50461 extends "Sales Price Worksheet"
{
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * EDITABLE=FALSE set for fields "Unit Profit (Current)", "Unit Profit % (Current)"
    //   * VISIBLE=FALSE set for fields "Minimum Quantity", "Unit of Measure Code", "Location Code"
    // 
    // 14.04.2014 Elva Baltic P7 #X MMG7.00
    //   * Added Page Actions:
    //   - Suggest Sales Price From Prch.
    // 
    // 18.02.2014 Elva Baltic P15 #F085 MMG7.00
    //   * Added Page Actions:
    //   - Calculate Price Per Disc. Group
    Editable = "No.";
    Editable = false;
    Editable = false;
    layout
    {
        addafter("Control 37")
        {
            field(Type; Type)
            {
            }
        }
        addafter("Control 27")
        {
            field("Location Code"; "Location Code")
            {
                Visible = false;
            }
        }
        addafter("Control 8")
        {
            field("Unit Profit (Current)"; "Unit Profit (Current)")
            {
                Editable = false;
            }
            field("Unit Profit % (Current)"; "Unit Profit % (Current)")
            {
                Editable = false;
            }
        }
        addafter("Control 34")
        {
            field("Unit Profit (New)"; "Unit Profit (New)")
            {
            }
            field("Unit Profit % (New)"; "Unit Profit % (New)")
            {
            }
        }
        addafter("Control 29")
        {
            field("Ordering Price Type Code"; "Ordering Price Type Code")
            {
                Visible = true;
            }
            field("Unit Cost"; "Unit Cost")
            {
                Visible = true;
            }
        }
    }
    actions
    {
        addafter("Action 33")
        {
            action("Suggest Sales Price From Prch.")
            {
                Caption = 'Suggest Sales Price From Prch.';

                trigger OnAction()
                begin
                    REPORT.RUNMODAL(REPORT::"Suggest Sales Price From Prch.", TRUE, TRUE);
                end;
            }
        }
        addafter("Action 36")
        {
            separator()
            {
            }
            action("Suggest Nonstock Item on Wksh.")
            {
                Caption = 'Suggest Nonstock Item on Wksh.';
                Ellipsis = true;
                Image = NonStockItem;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    REPORT.RUNMODAL(REPORT::"Suggest Nonstock Item Price", TRUE, TRUE);
                end;
            }
            action("Suggest Nonstock Sales Price on Wksh.")
            {
                Caption = 'Suggest Nonstock Sales Price on Wksh.';
                Ellipsis = true;
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    REPORT.RUNMODAL(REPORT::"Suggest Nonstock Sales Price", TRUE, TRUE);
                end;
            }
            separator()
            {
            }
            action("Calculate Price From Cost")
            {
                Caption = 'Calculate Price From Cost';
                Ellipsis = true;
                Image = SuggestSalesPrice;
                Promoted = false;

                trigger OnAction()
                var
                    SalesPriceWorksheet: Record "7023";
                begin
                    SalesPriceWorksheet.RESET;
                    SalesPriceWorksheet.COPYFILTERS(Rec);
                    REPORT.RUNMODAL(REPORT::"Calc. Sales Price From Cost", TRUE, FALSE, SalesPriceWorksheet);
                end;
            }
        }
    }
}

