pageextension 50153 pageextension50153 extends "Purch. Credit Memo Statistics"
{

    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEARALL;

    IF "Currency Code" = '' THEN
    #4..51
    IF NOT Vend.GET("Pay-to Vendor No.") THEN
      CLEAR(Vend);
    Vend.CALCFIELDS("Balance (LCY)");

    PurchCrMemoLine.CalcVATAmountLines(Rec,TempVATAmountLine);
    CurrPage.SubForm.PAGE.SetTempVATAmountLine(TempVATAmountLine);
    CurrPage.SubForm.PAGE.InitGlobals("Currency Code",FALSE,FALSE,FALSE,FALSE,"VAT Base Discount %");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..54
    //CalcTDSAmount("No.","TDS Posting Group"); //***SM 30 Dec 2013 to calc TDS Amount
    #56..58
    */
    //end;
}

