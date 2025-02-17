pageextension 50070 pageextension50070 extends "Purchase Statistics"
{
    layout
    {
        addafter(InvDiscountAmount)
        {
            field(TotalPurchLine."TDS Amount";
                TotalPurchLine."TDS Amount")
            {
                Caption = 'TDS Amount';
                Editable = false;
            }
        }
    }

    var
        PurchLine: Record "39";
        PurchaseLineAmount: Decimal;
        TDSPostingGroup: Record "33019849";
        TDSAmount: Decimal;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CurrPage.CAPTION(STRSUBSTNO(Text000,"Document Type"));
    IF PrevNo = "No." THEN BEGIN
      GetVATSpecification;
    #4..11
    CLEAR(TotalPurchLineLCY);
    CLEAR(PurchPost);

    PurchPost.GetPurchLines(Rec,TempPurchLine,0);
    CLEAR(PurchPost);
    PurchPost.SumPurchLinesTemp(
    #18..33
    PurchLine.CalcVATAmountLines(0,Rec,TempPurchLine,TempVATAmountLine);
    TempVATAmountLine.MODIFYALL(Modified,FALSE);
    SetVATSpecification;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..14
    CalcTDSAmount("No.","TDS Posting Group"); //***SM 30 Dec 2013 to calc TDS Amount
    #15..36
    */
    //end;

    procedure CalcTDSAmount(No: Code[20]; TdsPostingGrp: Code[20])
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document No.", No);
        IF PurchLine.FINDFIRST THEN BEGIN
            REPEAT
                PurchaseLineAmount := PurchaseLineAmount + (PurchLine."Qty. to Invoice" * PurchLine."Direct Unit Cost");
            UNTIL PurchLine.NEXT = 0;
        END;

        TDSPostingGroup.RESET;
        TDSPostingGroup.SETRANGE(Code, TdsPostingGrp);
        IF TDSPostingGroup.FINDFIRST THEN BEGIN
            TDSAmount := (PurchaseLineAmount * TDSPostingGroup."TDS%") / 100;
        END;
    end;
}

