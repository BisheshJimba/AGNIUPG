pageextension 50152 pageextension50152 extends "Purchase Invoice Statistics"
{
    layout
    {
        addafter("Control 12")
        {
            field("TDS Amount"; TDSAmount)
            {
            }
        }
    }

    var
        PurchaseLineAmount: Integer;
        TDSPostingGroup: Record "33019849";
        TDSAmount: Decimal;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEARALL;

    IF "Currency Code" = '' THEN
    #4..14
          InvDiscAmount := InvDiscAmount + PurchInvLine."Inv. Discount Amount" / (1 + PurchInvLine."VAT %" / 100)
        ELSE
          InvDiscAmount := InvDiscAmount + PurchInvLine."Inv. Discount Amount";
        LineQty := LineQty + PurchInvLine.Quantity;
        TotalNetWeight := TotalNetWeight + (PurchInvLine.Quantity * PurchInvLine."Net Weight");
        TotalGrossWeight := TotalGrossWeight + (PurchInvLine.Quantity * PurchInvLine."Gross Weight");
    #21..51
    IF NOT Vend.GET("Pay-to Vendor No.") THEN
      CLEAR(Vend);
    Vend.CALCFIELDS("Balance (LCY)");

    PurchInvLine.CalcVATAmountLines(Rec,TempVATAmountLine);
    CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);
    CurrPage.SubForm.PAGE.InitGlobals("Currency Code",FALSE,FALSE,FALSE,FALSE,"VAT Base Discount %");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..17
        TDSAmount := TDSAmount +PurchInvLine."TDS Amount"; //TDS2.00
    #18..54
    //CalcTDSAmount("No.","TDS Posting Group"); //***SM 30 Dec 2013 to calc TDS Amount
    #56..58
    */
    //end;

    local procedure CalcTDSAmount(No: Code[20]; TdsPostingGrp: Code[20])
    begin
        TDSPostingGroup.RESET;
        TDSPostingGroup.SETRANGE(Code, TdsPostingGrp);
        IF TDSPostingGroup.FINDFIRST THEN BEGIN
            TDSAmount := (VendAmount * TDSPostingGroup."TDS%") / 100;
        END;
    end;
}

