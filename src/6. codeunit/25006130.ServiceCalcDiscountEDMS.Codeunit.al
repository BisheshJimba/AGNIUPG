codeunit 25006130 "Service-Calc. Discount EDMS"
{
    TableNo = 25006146;

    trigger OnRun()
    begin
        ServLine.COPY(Rec);

        TempServHeader.GET(Rec."Document Type", Rec."Document No.");
        TemporaryHeader := FALSE;
        CalculateInvoiceDiscount(TempServHeader, TempServLine);

        Rec := ServLine;
    end;

    var
        Text000: Label 'Service Charge';
        TempServHeader: Record "25006145";
        ServLine: Record "25006146";
        TempServLine: Record "25006146";
        CustInvDisc: Record "19";
        CustPostingGr: Record "92";
        Currency: Record "4";
        InvDiscBase: Decimal;
        ChargeBase: Decimal;
        CurrencyDate: Date;
        TemporaryHeader: Boolean;

    local procedure CalculateInvoiceDiscount(var ServHeader: Record "25006145"; var ServLine2: Record "25006146")
    var
        TempVATAmountLine: Record "290" temporary;
        SalesSetup: Record "311";
        TempServiceChargeLine: Record "25006146" temporary;
    begin
        SalesSetup.GET;
        IF ServLine.RECORDLEVELLOCKING THEN
            ServLine.LOCKTABLE;
        ServHeader.TESTFIELD("Customer Posting Group");
        CustPostingGr.GET(ServHeader."Customer Posting Group");

        ServLine2.RESET;
        ServLine2.SETRANGE("Document Type", ServLine."Document Type");
        ServLine2.SETRANGE("Document No.", ServLine."Document No.");
        ServLine2.SETRANGE("System-Created Entry", TRUE);
        ServLine2.SETRANGE(Type, ServLine2.Type::"G/L Account");
        ServLine2.SETRANGE("No.", CustPostingGr."Service Charge Acc.");
        IF ServLine2.FINDSET(TRUE, FALSE) THEN
            REPEAT
                ServLine2.VALIDATE("Unit Price", 0);
                ServLine2.MODIFY;
                TempServiceChargeLine := ServLine2;
                TempServiceChargeLine.INSERT;
            UNTIL ServLine2.NEXT = 0;

        ServLine2.RESET;
        ServLine2.SETRANGE("Document Type", ServLine."Document Type");
        ServLine2.SETRANGE("Document No.", ServLine."Document No.");
        ServLine2.SETFILTER(Type, '<>0');
        IF ServLine2.FINDFIRST THEN;
        ServLine2.CalcVATAmountLines(0, ServHeader, ServLine2, TempVATAmountLine);
        InvDiscBase :=
          TempVATAmountLine.GetTotalInvDiscBaseAmount(
            ServHeader."Prices Including VAT", ServHeader."Currency Code");
        ChargeBase :=
          TempVATAmountLine.GetTotalLineAmount(
            ServHeader."Prices Including VAT", ServHeader."Currency Code");

        IF NOT TemporaryHeader THEN BEGIN
            IF NOT ServLine.RECORDLEVELLOCKING THEN
                ServLine2.LOCKTABLE(TRUE, TRUE);
            ServHeader.MODIFY;
        END;

        IF (ServLine."Document Type" IN [ServLine."Document Type"::Quote]) AND
           (ServHeader."Posting Date" = 0D)
        THEN
            CurrencyDate := WORKDATE
        ELSE
            CurrencyDate := ServHeader."Posting Date";

        CustInvDisc.GetRec(
          ServHeader."Invoice Disc. Code", ServHeader."Currency Code", CurrencyDate, ChargeBase);

        IF CustInvDisc."Service Charge" <> 0 THEN BEGIN
            CustPostingGr.TESTFIELD("Service Charge Acc.");
            IF ServHeader."Currency Code" = '' THEN
                Currency.InitRoundingPrecision
            ELSE
                Currency.GET(ServHeader."Currency Code");
            IF TemporaryHeader THEN
                ServLine2.SetServHeader(ServHeader);
            IF NOT TempServiceChargeLine.ISEMPTY THEN BEGIN
                TempServiceChargeLine.FINDLAST;
                ServLine2.GET(ServLine."Document Type", ServLine."Document No.", TempServiceChargeLine."Line No.");
                IF ServHeader."Prices Including VAT" THEN
                    ServLine2.VALIDATE(
                      "Unit Price",
                      ROUND(
                        (1 + ServLine2."VAT %" / 100) * CustInvDisc."Service Charge",
                        Currency."Unit-Amount Rounding Precision"))
                ELSE
                    ServLine2.VALIDATE("Unit Price", CustInvDisc."Service Charge");
                ServLine2.MODIFY;
            END ELSE BEGIN
                ServLine2.RESET;
                ServLine2.SETRANGE("Document Type", ServLine."Document Type");
                ServLine2.SETRANGE("Document No.", ServLine."Document No.");
                ServLine2.FINDLAST;
                ServLine2.INIT;
                IF TemporaryHeader THEN
                    ServLine2.SetServHeader(ServHeader);
                ServLine2."Line No." := ServLine2."Line No." + 10000;
                ServLine2."System-Created Entry" := TRUE;
                ServLine2.Type := ServLine2.Type::"G/L Account";
                ServLine2.VALIDATE("No.", CustPostingGr."Service Charge Acc.");
                ServLine2.Description := Text000;
                ServLine2.VALIDATE(Quantity, 1);
                IF ServHeader."Prices Including VAT" THEN
                    ServLine2.VALIDATE(
                      "Unit Price",
                      ROUND(
                        (1 + ServLine2."VAT %" / 100) * CustInvDisc."Service Charge",
                        Currency."Unit-Amount Rounding Precision"))
                ELSE
                    ServLine2.VALIDATE("Unit Price", CustInvDisc."Service Charge");
                ServLine2.INSERT;
            END;
            ServLine2.CalcVATAmountLines(0, ServHeader, ServLine2, TempVATAmountLine);
        END ELSE
            IF TempServiceChargeLine.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    ServLine2 := TempServiceChargeLine;
                    ServLine2.DELETE(TRUE);
                UNTIL TempServiceChargeLine.NEXT = 0;

        IF CustInvDiscRecExists(ServHeader."Invoice Disc. Code") THEN BEGIN
            IF InvDiscBase <> ChargeBase THEN
                CustInvDisc.GetRec(
                  ServHeader."Invoice Disc. Code", ServHeader."Currency Code", CurrencyDate, InvDiscBase);

            ServHeader."Invoice Discount Calculation" := ServHeader."Invoice Discount Calculation"::"%";
            ServHeader."Invoice Discount Value" := CustInvDisc."Discount %";
            IF NOT TemporaryHeader THEN
                ServHeader.MODIFY;

            TempVATAmountLine.SetInvoiceDiscountPercent(
              CustInvDisc."Discount %", ServHeader."Currency Code",
              ServHeader."Prices Including VAT", SalesSetup."Calc. Inv. Disc. per VAT ID",
              ServHeader."VAT Base Discount %");

            ServLine2.SetServHeader(ServHeader);
            ServLine2.UpdateVATOnLines(0, ServHeader, ServLine2, TempVATAmountLine);
        END;
    end;

    local procedure CustInvDiscRecExists(InvDiscCode: Code[20]): Boolean
    var
        CustInvDisc: Record "19";
    begin
        CustInvDisc.SETRANGE(Code, InvDiscCode);
        EXIT(CustInvDisc.FINDFIRST);
    end;

    [Scope('Internal')]
    procedure CalculateWithServHeader(var TempServHeader: Record "25006145"; var TempServLine: Record "25006146")
    var
        FilterServLine: Record "25006146";
    begin
        FilterServLine.COPY(TempServLine);
        ServLine := TempServLine;

        TemporaryHeader := TRUE;
        CalculateInvoiceDiscount(TempServHeader, TempServLine);

        TempServLine.COPY(FilterServLine);
    end;

    [Scope('Internal')]
    procedure CalculateIncDiscForHeader(var TempServHeader: Record "25006145")
    var
        SalesSetup: Record "311";
    begin
        SalesSetup.GET;
        IF NOT SalesSetup."Calc. Inv. Discount" THEN EXIT;
        ServLine."Document Type" := TempServHeader."Document Type";
        ServLine."Document No." := TempServHeader."No.";
        CalculateInvoiceDiscount(TempServHeader, TempServLine);
    end;
}

