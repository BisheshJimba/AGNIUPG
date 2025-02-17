pageextension 50131 pageextension50131 extends "General Posting Setup"
{
    // 12.04.2013 EDMS P8
    //   * Added fields: "Service Prepayments Account", "Veh. Add. Expenses Account"
    layout
    {
        addafter("Control 6")
        {
            field("Service Prepayments Account"; Rec."Service Prepayments Account")
            {
            }
            field("Veh. Add. Expenses Account"; Rec."Veh. Add. Expenses Account")
            {
            }
            field("WIP Accured Cost Acc."; Rec."WIP Accured Cost Acc.")
            {
            }
            field("WIP Accured Sales Acc."; Rec."WIP Accured Sales Acc.")
            {
            }
            field("WIP Cost Adjustment Acc."; Rec."WIP Cost Adjustment Acc.")
            {
            }
            field("WIP Sales Adjusment Acc."; Rec."WIP Sales Adjusment Acc.")
            {
            }
        }
    }
}

