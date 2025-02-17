pageextension 50155 pageextension50155 extends "Purchase Order Statistics"
{
    layout
    {
        addafter("Total_General")
        {
            field("TDS Amount"; TotalPurchLine[1]."TDS Amount")
            {
                Editable = false;
            }
        }
    }

    var
        TDSAmount: Decimal;
        PurchLine: Record "39";
        PurchaseLineAmount: Decimal;
}

