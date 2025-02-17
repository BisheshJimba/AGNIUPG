page 25006194 "Service Order Statistics EDMS"
{
    // 05.12.2012 EDMS P8
    //   * Fixed to have correct behavior in case of discount

    Caption = 'Service Order Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = Table25006145;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TotalServiceLine[1]."Line Discount Amount";TotalServiceLine[1]."Line Discount Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Line Discount Amount';
                    Editable = true;
                }
                field(TotalServiceLine[1]."Inv. Discount Amount";TotalServiceLine[1]."Inv. Discount Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';

                    trigger OnValidate()
                    begin
                        ActiveTab := ActiveTab::General;
                        UpdateInvDiscAmount(1);
                    end;
                }
                field(TotalAmount1[1];TotalAmount1[1])
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,FALSE);

                    trigger OnValidate()
                    begin
                        ActiveTab := ActiveTab::General;
                        UpdateTotalAmount(1);
                    end;
                }
                field(VATAmount[1];VATAmount[1])
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT (VATAmountText[1]);
                    Caption = 'VAT Amount';
                    Editable = false;
                }
                field(TotalAmount2[1];TotalAmount2[1])
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text001,TRUE);
                    Editable = false;

                    trigger OnValidate()
                    begin
                        TotalAmount21OnAfterValidate;
                    end;
                }
                field(TotalServiceLineLCY[1].Amount;TotalServiceLineLCY[1].Amount)
                {
                    AutoFormatType = 1;
                    Caption = 'Sales (LCY)';
                    Editable = false;
                }
                field(ProfitLCY[1];ProfitLCY[1])
                {
                    AutoFormatType = 1;
                    Caption = 'Original Profit (LCY)';
                    Editable = false;
                }
                field(AdjProfitLCY[1];AdjProfitLCY[1])
                {
                    AutoFormatType = 1;
                    Caption = 'Adjusted Profit (LCY)';
                    Editable = false;
                }
                field(ProfitPct[1];ProfitPct[1])
                {
                    Caption = 'Original Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field(AdjProfitPct[1];AdjProfitPct[1])
                {
                    Caption = 'Adjusted Profit %';
                    DecimalPlaces = 1:1;
                    Editable = false;
                }
                field(TotalServiceLine[1].Quantity;TotalServiceLine[1].Quantity)
                {
                    Caption = 'Quantity';
                    DecimalPlaces = 0:5;
                    Editable = false;
                }
                field(TotalServiceLineLCY[1]."Unit Cost (LCY)";TotalServiceLineLCY[1]."Unit Cost (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Original Cost (LCY)';
                    Editable = false;
                }
                field(TotalAdjCostLCY[1];TotalAdjCostLCY[1])
                {
                    AutoFormatType = 1;
                    Caption = 'Adjusted Cost (LCY)';
                    Editable = false;
                }
                field(TempVATAmountLine1.COUNT;TempVATAmountLine1.COUNT)
                {
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempVATAmountLine1,FALSE);
                        UpdateHeaderInfo(1, TempVATAmountLine1);
                    end;
                }
            }
            group(Prepayment)
            {
                Caption = 'Prepayment';
                field(PrepmtTotalAmount;PrepmtTotalAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text006,FALSE);

                    trigger OnValidate()
                    begin
                        ActiveTab := ActiveTab::Prepayment;
                        UpdatePrepmtAmount;
                    end;
                }
                field(PrepmtVATAmount;PrepmtVATAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT (PrepmtVATAmountText);
                    Caption = 'Prepayment Amount Invoiced';
                    Editable = false;
                }
                field(PrepmtTotalAmount2;PrepmtTotalAmount2)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text006,TRUE);
                    Editable = false;
                }
                field(TotalServiceLine[1]."Prepmt. Amt. Inv.";TotalServiceLine[1]."Prepmt. Amt. Inv.")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text007,FALSE);
                    Editable = false;
                }
                field(PrepmtInvPct;PrepmtInvPct)
                {
                    Caption = 'Invoiced % of Prepayment Amt.';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Invoiced % of Prepayment Amt.';
                }
                field(TotalServiceLine[1]."Prepmt Amt Deducted";TotalServiceLine[1]."Prepmt Amt Deducted")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text008,FALSE);
                    Editable = false;
                }
                field(PrepmtDeductedPct;PrepmtDeductedPct)
                {
                    Caption = 'Deducted % of Prepayment Amt. to Deduct';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Deducted % of Prepayment Amt. to Deduct';
                }
                field(TotalServiceLine[1]."Prepmt Amt to Deduct";TotalServiceLine[1]."Prepmt Amt to Deduct")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = GetCaptionClass(Text009,FALSE);
                    Editable = false;
                }
                field(TempVATAmountLine4.COUNT;TempVATAmountLine4.COUNT)
                {
                    Caption = 'No. of VAT Lines';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        VATLinesDrillDown(TempVATAmountLine4,TRUE);
                    end;
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field(Cust."Balance (LCY)";Cust."Balance (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Balance (LCY)';
                    Editable = false;
                }
                field(Cust."Credit Limit (LCY)";Cust."Credit Limit (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Credit Limit (LCY)';
                    Editable = false;
                }
                field(CreditLimitLCYExpendedPct;CreditLimitLCYExpendedPct)
                {
                    Caption = 'Expended % of Credit Limit (LCY)';
                    ExtendedDatatype = Ratio;
                    ToolTip = 'Expended % of Credit Limit (LCY)';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        ServiceLine: Record "25006146";
        TempServiceLine: Record "25006146" temporary;
        ServicePostPrepmt: Codeunit "25006608";
    begin
        CurrPage.CAPTION(STRSUBSTNO(Text000,"Document Type"));

        IF PrevNo = "No." THEN
          EXIT;
        PrevNo := "No.";
        FILTERGROUP(2);
        SETRANGE("No.",PrevNo);
        FILTERGROUP(0);

        CLEAR(ServiceLine);
        CLEAR(TotalServiceLine);
        CLEAR(TotalServiceLineLCY);

        FOR i := 1 TO 3 DO BEGIN
          TempServiceLine.DELETEALL;
          CLEAR(TempServiceLine);
          CLEAR(ServicePost);
          ServicePost.GetServiceLines(Rec,TempServiceLine,i - 1);
          CLEAR(ServicePost);
          CASE i OF
            1: ServiceLine.CalcVATAmountLines(0,Rec,TempServiceLine,TempVATAmountLine1);
            2: ServiceLine.CalcVATAmountLines(0,Rec,TempServiceLine,TempVATAmountLine2);
            3: ServiceLine.CalcVATAmountLines(0,Rec,TempServiceLine,TempVATAmountLine3);
            4: ServiceLine.CalcVATAmountLines(0,Rec,TempServiceLine,TempVATAmountLine4);
          END;

          ServicePost.SumServiceLinesTemp(
            Rec,TempServiceLine,i - 1,TotalServiceLine[i],TotalServiceLineLCY[i],
            VATAmount[i],VATAmountText[i],ProfitLCY[i],ProfitPct[i],TotalAdjCostLCY[i]);

          IF i = 3 THEN
            TotalAdjCostLCY[i] := TotalServiceLineLCY[i]."Unit Cost (LCY)";

          AdjProfitLCY[i] := TotalServiceLineLCY[i].Amount - TotalAdjCostLCY[i];
          IF TotalServiceLineLCY[i].Amount <> 0 THEN
            AdjProfitPct[i] := ROUND(AdjProfitLCY[i] / TotalServiceLineLCY[i].Amount * 100,0.1);

          IF "Prices Including VAT" THEN BEGIN
            TotalAmount2[i] := TotalServiceLine[i].Amount;
            TotalAmount1[i] := TotalAmount2[i] + VATAmount[i];
            TotalServiceLine[i]."Line Amount" := TotalAmount1[i] + TotalServiceLine[i]."Inv. Discount Amount";
          END ELSE BEGIN
            TotalAmount1[i] := TotalServiceLine[i].Amount;
            TotalAmount2[i] := TotalServiceLine[i]."Amount Including VAT";
          END;
        END;
        TempServiceLine.DELETEALL;
        CLEAR(TempServiceLine);
        ServicePostPrepmt.GetServiceLines(Rec,0,TempServiceLine);
        ServicePostPrepmt.SumPrepmt(
          Rec,TempServiceLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
        PrepmtInvPct :=
          Pct(TotalServiceLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
        PrepmtDeductedPct :=
          Pct(TotalServiceLine[1]."Prepmt Amt Deducted",TotalServiceLine[1]."Prepmt. Amt. Inv.");
        IF "Prices Including VAT" THEN BEGIN
          PrepmtTotalAmount2 := PrepmtTotalAmount;
          PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
        END ELSE
          PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;

        IF Cust.GET("Bill-to Customer No.") THEN
          Cust.CALCFIELDS("Balance (LCY)")
        ELSE
          CLEAR(Cust);

        CASE TRUE OF
          Cust."Credit Limit (LCY)" = 0:
            CreditLimitLCYExpendedPct := 0;
          Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" < 0:
            CreditLimitLCYExpendedPct := 0;
          Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" > 1:
            CreditLimitLCYExpendedPct := 10000;
          ELSE
            CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000,1);
        END;

        TempVATAmountLine1.MODIFYALL(Modified,FALSE);
        TempVATAmountLine2.MODIFYALL(Modified,FALSE);
        TempVATAmountLine3.MODIFYALL(Modified,FALSE);
        TempVATAmountLine4.MODIFYALL(Modified,FALSE);

        PrevTab := -1;

        //05.12.2012 EDMS P8 >>
        UpdateTotals;
        GetVATSpecification2(ActiveTab);
        //05.12.2012 EDMS P8 <<
    end;

    trigger OnOpenPage()
    begin
        ServiceSetup.GET;
        AllowInvDisc := NOT (SalesSetup."Calc. Inv. Discount" AND CustInvDiscRecExists("Invoice Disc. Code"));
        AllowVATDifference :=
          SalesSetup."Allow VAT Difference" AND
          NOT ("Document Type" IN ["Document Type"::Quote]);
        VATLinesFormIsEditable := AllowVATDifference OR AllowInvDisc;
        CurrPage.EDITABLE := VATLinesFormIsEditable;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        GetVATSpecification(PrevTab);
        IF TempVATAmountLine1.GetAnyLineModified OR TempVATAmountLine2.GetAnyLineModified THEN
          UpdateVATOnServiceLines;
        EXIT(TRUE);
    end;

    var
        Text000: Label 'Service %1 Statistics';
        Text001: Label 'Total';
        Text002: Label 'Amount';
        Text003: Label '%1 must not be 0.';
        Text004: Label '%1 must not be greater than %2.';
        Text005: Label 'You cannot change the invoice discount because there is a %1 record for %2 %3.';
        TotalServiceLine: array [3] of Record "25006146";
        TotalServiceLineLCY: array [3] of Record "25006146";
        Cust: Record "18";
        TempVATAmountLine1: Record "290" temporary;
        TempVATAmountLine2: Record "290" temporary;
        TempVATAmountLine3: Record "290" temporary;
        TempVATAmountLine4: Record "290" temporary;
        ServiceSetup: Record "25006120";
        SalesSetup: Record "311";
        ServicePost: Codeunit "25006101";
        TotalAmount1: array [3] of Decimal;
        TotalAmount2: array [3] of Decimal;
        VATAmount: array [3] of Decimal;
        PrepmtTotalAmount: Decimal;
        PrepmtVATAmount: Decimal;
        PrepmtTotalAmount2: Decimal;
        VATAmountText: array [3] of Text[30];
        PrepmtVATAmountText: Text[30];
        ProfitLCY: array [3] of Decimal;
        ProfitPct: array [3] of Decimal;
        AdjProfitLCY: array [3] of Decimal;
        AdjProfitPct: array [3] of Decimal;
        TotalAdjCostLCY: array [3] of Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        PrepmtInvPct: Decimal;
        PrepmtDeductedPct: Decimal;
        i: Integer;
        PrevNo: Code[20];
        ActiveTab: Option General,Invoicing,Shipping,Prepayment;
        PrevTab: Option General,Invoicing,Shipping,Prepayment;
        VATLinesFormIsEditable: Boolean;
        AllowInvDisc: Boolean;
        AllowVATDifference: Boolean;
        Text006: Label 'Prepmt. Amount';
        Text007: Label 'Prepmt. Amt. Invoiced';
        Text008: Label 'Prepmt. Amt. Deducted';
        Text009: Label 'Prepmt. Amt. to Deduct';

    local procedure UpdateHeaderInfo(IndexNo: Integer;var VATAmountLine: Record "290")
    var
        CurrExchRate: Record "330";
        UseDate: Date;
    begin
        TotalServiceLine[IndexNo]."Inv. Discount Amount" := VATAmountLine.GetTotalInvDiscAmount;
        TotalAmount1[IndexNo] :=
          TotalServiceLine[IndexNo]."Line Amount" - TotalServiceLine[IndexNo]."Inv. Discount Amount";
        VATAmount[IndexNo] := VATAmountLine.GetTotalVATAmount;
        IF "Prices Including VAT" THEN BEGIN
          TotalAmount1[IndexNo] := VATAmountLine.GetTotalAmountInclVAT;
          TotalAmount2[IndexNo] := TotalAmount1[IndexNo] - VATAmount[IndexNo];
          TotalServiceLine[IndexNo]."Line Amount" :=
            TotalAmount1[IndexNo] + TotalServiceLine[IndexNo]."Inv. Discount Amount";
        END ELSE
          TotalAmount2[IndexNo] := TotalAmount1[IndexNo] + VATAmount[IndexNo];

        IF "Prices Including VAT" THEN
          TotalServiceLineLCY[IndexNo].Amount := TotalAmount2[IndexNo]
        ELSE
          TotalServiceLineLCY[IndexNo].Amount := TotalAmount1[IndexNo];
        IF "Currency Code" <> '' THEN
          IF ("Document Type" IN ["Document Type"::Quote]) AND
             ("Posting Date" = 0D)
          THEN
            UseDate := WORKDATE
          ELSE
            UseDate := "Posting Date";

        TotalServiceLineLCY[IndexNo].Amount :=
          CurrExchRate.ExchangeAmtFCYToLCY(
            UseDate,"Currency Code",TotalServiceLineLCY[IndexNo].Amount,"Currency Factor");

        ProfitLCY[IndexNo] := TotalServiceLineLCY[IndexNo].Amount - TotalServiceLineLCY[IndexNo]."Unit Cost (LCY)";
        IF TotalServiceLineLCY[IndexNo].Amount = 0 THEN
          ProfitPct[IndexNo] := 0
        ELSE
          ProfitPct[IndexNo] := ROUND(100 * ProfitLCY[IndexNo] / TotalServiceLineLCY[IndexNo].Amount,0.01);

        AdjProfitLCY[IndexNo] := TotalServiceLineLCY[IndexNo].Amount - TotalAdjCostLCY[IndexNo];
        IF TotalServiceLineLCY[IndexNo].Amount = 0 THEN
          AdjProfitPct[IndexNo] := 0
        ELSE
          AdjProfitPct[IndexNo] := ROUND(100 * AdjProfitLCY[IndexNo] / TotalServiceLineLCY[IndexNo].Amount,0.01);
    end;

    local procedure GetVATSpecification(QtyType: Option General,Invoicing,Shipping)
    var
        VATLinesForm: Page "9401";
    begin
        CASE QtyType OF
          QtyType::General:
            BEGIN
              VATLinesForm.GetTempVATAmountLine(TempVATAmountLine1);
              UpdateHeaderInfo(1,TempVATAmountLine1);
            END;
          QtyType::Invoicing:
            BEGIN
              VATLinesForm.GetTempVATAmountLine(TempVATAmountLine2);
              UpdateHeaderInfo(2,TempVATAmountLine2);
            END;
          QtyType::Shipping:
            VATLinesForm.GetTempVATAmountLine(TempVATAmountLine3);
        END;
    end;

    local procedure UpdateTotalAmount(IndexNo: Integer)
    var
        SaveTotalAmount: Decimal;
    begin
        CheckAllowInvDisc;
        IF "Prices Including VAT" THEN BEGIN
          SaveTotalAmount := TotalAmount1[IndexNo];
          UpdateInvDiscAmount(IndexNo);
          TotalAmount1[IndexNo] := SaveTotalAmount;
        END;

        WITH TotalServiceLine[IndexNo] DO
          "Inv. Discount Amount" := "Line Amount" - TotalAmount1[IndexNo];
        UpdateInvDiscAmount(IndexNo);
    end;

    local procedure UpdateInvDiscAmount(ModifiedIndexNo: Integer)
    var
        VATLinesForm: Page "9401";
                          PartialInvoicing: Boolean;
                          MaxIndexNo: Integer;
                          IndexNo: array [2] of Integer;
                          i: Integer;
                          InvDiscBaseAmount: Decimal;
    begin
        CheckAllowInvDisc;
        IF NOT (ModifiedIndexNo IN [1,2]) THEN
          EXIT;

        IF ModifiedIndexNo = 1 THEN
          InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(FALSE,"Currency Code")
        ELSE
          InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");

        IF InvDiscBaseAmount = 0 THEN
          ERROR(Text003,TempVATAmountLine2.FIELDCAPTION("Inv. Disc. Base Amount"));

        IF TotalServiceLine[ModifiedIndexNo]."Inv. Discount Amount" / InvDiscBaseAmount > 1 THEN
          ERROR(
            Text004,
            TotalServiceLine[ModifiedIndexNo].FIELDCAPTION("Inv. Discount Amount"),
            TempVATAmountLine2.FIELDCAPTION("Inv. Disc. Base Amount"));

        PartialInvoicing := (TotalServiceLine[1]."Line Amount" <> TotalServiceLine[2]."Line Amount");

        IndexNo[1] := ModifiedIndexNo;
        IndexNo[2] := 3 - ModifiedIndexNo;
        IF (ModifiedIndexNo = 2) AND PartialInvoicing THEN
          MaxIndexNo := 1
        ELSE
          MaxIndexNo := 2;

        IF NOT PartialInvoicing THEN
          IF ModifiedIndexNo = 1 THEN
            TotalServiceLine[2]."Inv. Discount Amount" := TotalServiceLine[1]."Inv. Discount Amount"
          ELSE
            TotalServiceLine[1]."Inv. Discount Amount" := TotalServiceLine[2]."Inv. Discount Amount";

        FOR i := 1 TO MaxIndexNo DO BEGIN
          WITH TotalServiceLine[IndexNo[i]] DO BEGIN
            IF (i = 1) OR NOT PartialInvoicing THEN
              IF IndexNo[i] = 1 THEN BEGIN
                TempVATAmountLine1.SetInvoiceDiscountAmount(
                  "Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
              END ELSE BEGIN
                TempVATAmountLine2.SetInvoiceDiscountAmount(
                  "Inv. Discount Amount","Currency Code","Prices Including VAT","VAT Base Discount %");
              END;

            IF (i = 2) AND PartialInvoicing THEN
              IF IndexNo[i] = 1 THEN BEGIN
                InvDiscBaseAmount := TempVATAmountLine2.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");
                IF InvDiscBaseAmount = 0 THEN
                  TempVATAmountLine1.SetInvoiceDiscountPercent(
                    0,"Currency Code","Prices Including VAT",FALSE,"VAT Base Discount %")
                ELSE
                  TempVATAmountLine1.SetInvoiceDiscountPercent(
                    100 * TempVATAmountLine2.GetTotalInvDiscAmount / InvDiscBaseAmount,
                    "Currency Code","Prices Including VAT",FALSE,"VAT Base Discount %");
              END ELSE BEGIN
                InvDiscBaseAmount := TempVATAmountLine1.GetTotalInvDiscBaseAmount(FALSE,"Currency Code");
                IF InvDiscBaseAmount = 0 THEN
                  TempVATAmountLine2.SetInvoiceDiscountPercent(
                    0,"Currency Code","Prices Including VAT",FALSE,"VAT Base Discount %")
                ELSE
                  TempVATAmountLine2.SetInvoiceDiscountPercent(
                    100 * TempVATAmountLine1.GetTotalInvDiscAmount / InvDiscBaseAmount,
                    "Currency Code","Prices Including VAT",FALSE,"VAT Base Discount %");
              END;
          END;
        END;

        UpdateHeaderInfo(1,TempVATAmountLine1);
        UpdateHeaderInfo(2,TempVATAmountLine2);

        IF ModifiedIndexNo = 1 THEN
          VATLinesForm.SetTempVATAmountLine(TempVATAmountLine1)
        ELSE
          VATLinesForm.SetTempVATAmountLine(TempVATAmountLine2);

        "Invoice Discount Calculation" := "Invoice Discount Calculation"::Amount;
        "Invoice Discount Value" := TotalServiceLine[1]."Inv. Discount Amount";
        MODIFY;

        UpdateVATOnServiceLines;
    end;

    local procedure UpdatePrepmtAmount()
    var
        TempServLine: Record "25006146" temporary;
        ServicePostPrepmt: Codeunit "25006608";
    begin
        ServicePostPrepmt.UpdatePrepmtAmountOnServLines(Rec,PrepmtTotalAmount);
        ServicePostPrepmt.GetServiceLines(Rec,0,TempServLine);
        ServicePostPrepmt.SumPrepmt(
          Rec,TempServLine,TempVATAmountLine4,PrepmtTotalAmount,PrepmtVATAmount,PrepmtVATAmountText);
        PrepmtInvPct :=
          Pct(TotalServiceLine[1]."Prepmt. Amt. Inv.",PrepmtTotalAmount);
        PrepmtDeductedPct :=
          Pct(TotalServiceLine[1]."Prepmt Amt Deducted",TotalServiceLine[1]."Prepmt. Amt. Inv.");
        IF "Prices Including VAT" THEN BEGIN
          PrepmtTotalAmount2 := PrepmtTotalAmount;
          PrepmtTotalAmount := PrepmtTotalAmount + PrepmtVATAmount;
        END ELSE
          PrepmtTotalAmount2 := PrepmtTotalAmount + PrepmtVATAmount;
        MODIFY;
    end;

    local procedure GetCaptionClass(FieldCaption: Text[100];ReverseCaption: Boolean): Text[80]
    begin
        IF "Prices Including VAT" XOR ReverseCaption THEN
          EXIT('2,1,' + FieldCaption);
        EXIT('2,0,' + FieldCaption);
    end;

    local procedure UpdateVATOnServiceLines()
    var
        ServiceLine: Record "25006146";
    begin
        GetVATSpecification(ActiveTab);
        IF TempVATAmountLine1.GetAnyLineModified THEN
          ServiceLine.UpdateVATOnLines(0,Rec,ServiceLine,TempVATAmountLine1);
        IF TempVATAmountLine2.GetAnyLineModified THEN
          ServiceLine.UpdateVATOnLines(1,Rec,ServiceLine,TempVATAmountLine2);
        PrevNo := '';
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "19";
    begin
        CustInvDisc.SETRANGE(Code,InvDiscCode);
        EXIT(CustInvDisc.FINDSET);
    end;

    local procedure CheckAllowInvDisc()
    var
        CustInvDisc: Record "19";
    begin
        IF NOT AllowInvDisc THEN
          ERROR(
            Text005,
            CustInvDisc.TABLECAPTION,FIELDCAPTION("Invoice Disc. Code"),"Invoice Disc. Code");
    end;

    local procedure Pct(Numerator: Decimal;Denominator: Decimal): Decimal
    begin
        IF Denominator = 0 THEN
          EXIT(0);
        EXIT(ROUND(Numerator / Denominator * 10000,1));
    end;

    [Scope('Internal')]
    procedure VATLinesDrillDown(var VATLinesToDrillDown: Record "290";ThisTabAllowsVATEditing: Boolean)
    var
        VATLinesForm: Page "9401";
    begin
        CLEAR(VATLinesForm);
        VATLinesForm.SetTempVATAmountLine(VATLinesToDrillDown);
        VATLinesForm.InitGlobals(
          "Currency Code",AllowVATDifference,AllowVATDifference AND ThisTabAllowsVATEditing,
          "Prices Including VAT",AllowInvDisc,"VAT Base Discount %");
        VATLinesForm.RUNMODAL;
        VATLinesForm.GetTempVATAmountLine(VATLinesToDrillDown);
    end;

    local procedure TotalAmount21OnAfterValidate()
    begin
        WITH TotalServiceLine[1] DO BEGIN
          IF "Prices Including VAT" THEN
            "Inv. Discount Amount" := "Line Amount" - "Amount Including VAT"
          ELSE
            "Inv. Discount Amount" := "Line Amount" - Amount;
        END;
          UpdateInvDiscAmount(1);
    end;

    local procedure GetVATSpecification2(QtyType: Option General,Invoicing,Shipping)
    begin
        CASE QtyType OF
          QtyType::General:
            BEGIN
              UpdateHeaderInfo(1,TempVATAmountLine1);
            END;
          QtyType::Invoicing:
            BEGIN
              UpdateHeaderInfo(2,TempVATAmountLine2);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateTotals()
    begin
        TotalAmount1[1] := TotalServiceLine[1]."Line Amount" - TotalServiceLine[1]."Inv. Discount Amount";
    end;
}

