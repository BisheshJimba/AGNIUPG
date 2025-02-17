page 25006240 "Posted Serv.R.Order Statistics"
{
    Caption = 'Posted Service Return Order Statistics';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SourceTable = Table25006154;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CustAmount +InvDiscAmount; CustAmount + InvDiscAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Amount';
                }
                field(InvDiscAmount; InvDiscAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Inv. Discount Amount';
                }
                field(CustAmount; CustAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total';
                }
                field(VATAmount; VATAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    CaptionClass = FORMAT(VATAmountText);
                    Caption = 'VAT Amount';
                }
                field(AmountInclVAT; AmountInclVAT)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                    Caption = 'Total Incl. VAT';
                }
                field(AmountLCY; AmountLCY)
                {
                    AutoFormatType = 1;
                    Caption = 'Sales (LCY)';
                }
            }
            part(Subform; 576)
            {
                Editable = false;
            }
            group(Customer)
            {
                Caption = 'Customer';
                field(Cust."Balance (LCY)";
                    Cust."Balance (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Balance (LCY)';
                }
                field(Cust."Credit Limit (LCY)";
                    Cust."Credit Limit (LCY)")
                {
                    AutoFormatType = 1;
                    Caption = 'Credit Limit (LCY)';
                }
                field(CreditLimitLCYExpendedPct; CreditLimitLCYExpendedPct)
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
        CostCalcMgt: Codeunit "5836";
        CustLedgEntry: Record "21";
    begin
        CLEARALL;

        IF "Currency Code" = '' THEN
            currency.InitRoundingPrecision
        ELSE
            currency.GET("Currency Code");

        ServOrderLine.SETRANGE("Document No.", "No.");
        IF ServOrderLine.FINDSET THEN
            REPEAT
                CustAmount := CustAmount + ServOrderLine.Amount;
                AmountInclVAT := AmountInclVAT + ServOrderLine."Amount Including VAT";
                IF "Prices Including VAT" THEN
                    InvDiscAmount := InvDiscAmount + ServOrderLine."Inv. Discount Amount" / (1 + ServOrderLine."VAT %" / 100)
                ELSE
                    InvDiscAmount := InvDiscAmount + ServOrderLine."Inv. Discount Amount";
                CostLCY := CostLCY + (ServOrderLine.Quantity * ServOrderLine."Unit Cost (LCY)");
                LineQty := LineQty + ServOrderLine.Quantity;
                IF ServOrderLine."VAT %" <> VATPercentage THEN
                    IF VATPercentage = 0 THEN
                        VATPercentage := ServOrderLine."VAT %"
                    ELSE
                        VATPercentage := -1;
                TotalAdjCostLCY := TotalAdjCostLCY + ServOrderLine."Unit Cost (LCY)";
            UNTIL ServOrderLine.NEXT = 0;
        VATAmount := AmountInclVAT - CustAmount;
        InvDiscAmount := ROUND(InvDiscAmount, currency."Amount Rounding Precision");

        IF VATPercentage <= 0 THEN
            VATAmountText := Text000
        ELSE
            VATAmountText := STRSUBSTNO(Text001, VATPercentage);

        IF "Currency Code" = '' THEN
            AmountLCY := CustAmount
        ELSE
            AmountLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WORKDATE, "Currency Code", CustAmount, "Currency Factor");

        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document No.", "No.");
        CustLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice);
        CustLedgEntry.SETRANGE("Customer No.", "Bill-to Customer No.");
        IF CustLedgEntry.FINDFIRST THEN
            AmountLCY := CustLedgEntry."Sales (LCY)";

        ProfitLCY := AmountLCY - CostLCY;
        IF AmountLCY <> 0 THEN
            ProfitPct := ROUND(100 * ProfitLCY / AmountLCY, 0.1);

        AdjProfitLCY := AmountLCY - TotalAdjCostLCY;
        IF AmountLCY <> 0 THEN
            AdjProfitPct := ROUND(100 * AdjProfitLCY / AmountLCY, 0.1);

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
                CreditLimitLCYExpendedPct := ROUND(Cust."Balance (LCY)" / Cust."Credit Limit (LCY)" * 10000, 1);
        END;

        ServOrderLine.CalcVATAmountLines(Rec, TempVATAmountLine);
        CurrPage.Subform.PAGE.SetTempVATAmountLine(TempVATAmountLine);
        CurrPage.Subform.PAGE.InitGlobals("Currency Code", FALSE, FALSE, FALSE, FALSE, 0);
    end;

    var
        Text000: Label 'VAT Amount';
        Text001: Label '%1% VAT';
        CurrExchRate: Record "330";
        ServOrderLine: Record "25006155";
        Cust: Record "18";
        TempVATAmountLine: Record "290" temporary;
        currency: Record "4";
        TotalAdjCostLCY: Decimal;
        CustAmount: Decimal;
        AmountInclVAT: Decimal;
        InvDiscAmount: Decimal;
        VATAmount: Decimal;
        CostLCY: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        LineQty: Decimal;
        AmountLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        VATPercentage: Decimal;
        VATAmountText: Text[30];
}

