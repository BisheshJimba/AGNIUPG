codeunit 50018 "Gen. Jnl.-Post Line Min"
{
    Permissions = TableData 17 = imd,
                  TableData 21 = imd,
                  TableData 25 = imd,
                  TableData 45 = imd,
                  TableData 112 = rim,
                  TableData 253 = rimd,
                  TableData 254 = imd,
                  TableData 271 = imd,
                  TableData 272 = imd,
                  TableData 379 = imd,
                  TableData 380 = imd,
                  TableData 1053 = rim,
                  TableData 5601 = rimd,
                  TableData 5617 = imd,
                  TableData 5625 = rimd,
                  TableData 25006005 = rim,
                  TableData 33019971 = rimd,
                  TableData 33019972 = rimd,
                  TableData 33020254 = r;
    TableNo = 81;

    trigger OnRun()
    begin

        //for vehicle finance >>
        PenaltyUpdated := FALSE;
        //--------------------<<

        GetGLSetup;
        RunWithCheck(Rec);
    end;

    var
        NeedsRoundingErr: Label '%1 needs to be rounded';
        PurchaseAlreadyExistsErr: Label 'Purchase %1 %2 already exists for this vendor.', Comment = '%1 = Document Type; %2 = Document No.';
        BankPaymentTypeMustNotBeFilledErr: Label 'Bank Payment Type must not be filled if Currency Code is different in Gen. Journal Line and Bank Account.';
        DocNoMustBeEnteredErr: Label 'Document No. must be entered when Bank Payment Type is %1.';
        CheckAlreadyExistsErr: Label 'Check %1 already exists for this Bank Account.';
        GLSetup: Record "98";
        GlobalGLEntry: Record "17";
        TempGLEntryBuf: Record "17" temporary;
        TempGLEntryVAT: Record "17" temporary;
        GLReg: Record "45";
        AddCurrency: Record "4";
        CurrExchRate: Record "330";
        VATEntry: Record "254";
        TaxDetail: Record "322";
        UnrealizedCustLedgEntry: Record "21";
        UnrealizedVendLedgEntry: Record "25";
        GLEntryVATEntryLink: Record "253";
        TempVATEntry: Record "254" temporary;
        GenJnlCheckLine: Codeunit "11";
        PaymentToleranceMgt: Codeunit "426";
        DeferralUtilities: Codeunit "1720";
        DeferralDocType: Option Purchase,Sales,"G/L";
        LastDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
        AddCurrencyCode: Code[10];
        GLSourceCode: Code[10];
        LastDocNo: Code[20];
        FiscalYearStartDate: Date;
        CurrencyDate: Date;
        LastDate: Date;
        BalanceCheckAmount: Decimal;
        BalanceCheckAmount2: Decimal;
        BalanceCheckAddCurrAmount: Decimal;
        BalanceCheckAddCurrAmount2: Decimal;
        CurrentBalance: Decimal;
        TotalAddCurrAmount: Decimal;
        TotalAmount: Decimal;
        UnrealizedRemainingAmountCust: Decimal;
        UnrealizedRemainingAmountVend: Decimal;
        AmountRoundingPrecision: Decimal;
        AddCurrGLEntryVATAmt: Decimal;
        CurrencyFactor: Decimal;
        FirstEntryNo: Integer;
        NextEntryNo: Integer;
        NextVATEntryNo: Integer;
        FirstNewVATEntryNo: Integer;
        NextTransactionNo: Integer;
        NextConnectionNo: Integer;
        NextCheckEntryNo: Integer;
        InsertedTempGLEntryVAT: Integer;
        GLEntryNo: Integer;
        UseCurrFactorOnly: Boolean;
        NonAddCurrCodeOccured: Boolean;
        FADimAlreadyChecked: Boolean;
        ResidualRoundingErr: Label 'Residual caused by rounding of %1';
        DimensionUsedErr: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5.', Comment = 'Comment';
        OverrideDimErr: Boolean;
        JobLine: Boolean;
        CheckUnrealizedCust: Boolean;
        CheckUnrealizedVend: Boolean;
        GLSetupRead: Boolean;
        InvalidPostingDateErr: Label '%1 is not within the range of posting dates for your company.', Comment = '%1=The date passed in for the posting date.';
        DescriptionMustNotBeBlankErr: Label 'When %1 is selected for %2, %3 must have a value.', Comment = '%1: Field Omit Default Descr. in Jnl., %2 G/L Account No, %3 Description';
        NoDeferralScheduleErr: Label 'You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.', Comment = '%1=The line number of the general ledger transaction, %2=The Deferral Template Code';
        ZeroDeferralAmtErr: Label 'Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.', Comment = '%1=The line number of the general ledger transaction, %2=The Deferral Template Code';
        IsGLRegInserted: Boolean;
        TDSAccount: Record "15";
        VFRec: Record "33020062";
        VFPaymentRec: Record "33020072";
        LineNo: Integer;
        PrincipalPaidTotal: Decimal;
        PenaltyUpdated: Boolean;
        "-----------------------CNY----": Integer;
        CheckEnt_G: Record "33019971";
        Customer_G: Record "18";
        Vendor_G: Record "23";
        FileLedgerEntry: Record "33019975";
        FileDetails: Record "33019974";
        EntryNo: Integer;
        DocumentType: Option " ","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Service Invoice","Service Credit Memo","Gen Jnl","Cash Rcpt Jnl","Payment Jnl","Recurring Gnl Jnl","LC Jnl",Others;
        TDSEntries: Record "33019850";
        TDSPostingGroup: Record "33019849";
        BeforePostDocNo: Code[20];
        PayrollGeneralSetup: Record "33020507";
        PayRevMgt: Codeunit "50008";
        PurchasesPayableSetup: Record "312";
        GenJnlPostLine: Codeunit "12";
        VendorName: Text[50];
        GLAccountNo: Code[20];
        GLAccountName: Text[50];
        GenLine: Record "81";
        SourceType: Option " ",Employee,Branch,Vendor,Customer,Party;
        GLEntryTDSEntryLink: Record "33019878";
        TDSEntryNo: Integer;
        DocumentClassError: Label 'Document Class is mandatory for the G/L account no. %1 %2 %3';
        CannotReverseErr: Label 'You cannot reverse the transaction, because it has already been reversed.';
        TDSDesc: Label 'System Created TDS Entry';
        VFSetup: Record "33020064";

    [Scope('Internal')]
    procedure GetGLReg(var NewGLReg: Record "45")
    begin
        NewGLReg := GLReg;
    end;

    [Scope('Internal')]
    procedure RunWithCheck(var GenJnlLine2: Record "81"): Integer
    var
        GenJnlLine: Record "81";
    begin
        GenJnlLine.COPY(GenJnlLine2);
        Code(GenJnlLine, TRUE);
        GenJnlLine2 := GenJnlLine;
        EXIT(GLEntryNo);
    end;

    [Scope('Internal')]
    procedure RunWithoutCheck(var GenJnlLine2: Record "81"): Integer
    var
        GenJnlLine: Record "81";
    begin
        GenJnlLine.COPY(GenJnlLine2);
        Code(GenJnlLine, FALSE);
        GenJnlLine2 := GenJnlLine;
        EXIT(GLEntryNo);
    end;

    local procedure "Code"(var GenJnlLine: Record "81"; CheckLine: Boolean)
    var
        Balancing: Boolean;
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        PurchInvHeader: Record "122";
        PurchInvLine: Record "123";
    begin
        GetGLSourceCode;
        IF GenJnlLine.EmptyLine THEN BEGIN
            InitLastDocDate(GenJnlLine);
            EXIT;
        END;

        IF CheckLine THEN BEGIN
            IF OverrideDimErr THEN
                GenJnlCheckLine.SetOverDimErr;
            GenJnlCheckLine.RunCheck(GenJnlLine);
        END;

        AmountRoundingPrecision := InitAmounts(GenJnlLine);

        //23.01.2013 EDMS P8 >>
        // update fields related to EDMS
        IF GenJnlLine."Vehicle Serial No." = '' THEN
            CASE GenJnlLine."Gen. Posting Type" OF
                GenJnlLine."Gen. Posting Type"::Purchase, GenJnlLine."Gen. Posting Type"::" ":
                    BEGIN
                        CASE GenJnlLine."Document Type" OF
                            GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::"Credit Memo":
                                IF PurchInvHeader.GET(GenJnlLine."Document No.") THEN BEGIN
                                    PurchInvLine.RESET;
                                    PurchInvLine.SETRANGE("Document No.", GenJnlLine."Document No.");
                                    IF PurchInvLine.COUNT = 1 THEN BEGIN
                                        PurchInvLine.FINDFIRST;
                                        GenJnlLine.VIN := PurchInvLine.VIN;
                                        GenJnlLine."Make Code" := PurchInvLine."Make Code";
                                        GenJnlLine."Model Code" := PurchInvLine."Model Code";
                                        GenJnlLine."Model Version No." := PurchInvLine."Model Version No.";
                                        GenJnlLine."Vehicle Serial No." := PurchInvLine."Vehicle Serial No.";
                                        GenJnlLine."Vehicle Accounting Cycle No." := PurchInvLine."Vehicle Accounting Cycle No.";
                                    END;
                                END;
                        END;
                    END;
                GenJnlLine."Gen. Posting Type"::Sale:
                    BEGIN
                        CASE GenJnlLine."Document Type" OF
                            GenJnlLine."Document Type"::Invoice:
                                IF SalesInvoiceHeader.GET(GenJnlLine."Document No.") THEN BEGIN
                                    IF (SalesInvoiceHeader."Document Profile" = SalesInvoiceHeader."Document Profile"::"Vehicles Trade") AND
                                        (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) THEN BEGIN
                                        SalesInvoiceLine.RESET;
                                        SalesInvoiceLine.SETRANGE("Document No.", GenJnlLine."Document No.");
                                        IF SalesInvoiceLine.COUNT = 1 THEN BEGIN
                                            SalesInvoiceLine.FINDFIRST;
                                            GenJnlLine.VIN := SalesInvoiceLine.VIN;
                                            GenJnlLine."Make Code" := SalesInvoiceLine."Make Code";
                                            GenJnlLine."Model Code" := SalesInvoiceLine."Model Code";
                                            GenJnlLine."Model Version No." := SalesInvoiceLine."Model Version No.";
                                            GenJnlLine."Vehicle Serial No." := SalesInvoiceLine."Vehicle Serial No.";
                                            GenJnlLine."Vehicle Accounting Cycle No." := SalesInvoiceLine."Vehicle Accounting Cycle No.";
                                        END;
                                    END ELSE BEGIN
                                        GenJnlLine.VIN := SalesInvoiceHeader.VIN;
                                        GenJnlLine."Make Code" := SalesInvoiceHeader."Make Code";
                                        GenJnlLine."Model Code" := SalesInvoiceHeader."Model Code";
                                        GenJnlLine."Model Version No." := SalesInvoiceHeader."Model Version No.";
                                        GenJnlLine."Vehicle Serial No." := SalesInvoiceHeader."Vehicle Serial No.";
                                        GenJnlLine."Vehicle Accounting Cycle No." := SalesInvoiceHeader."Vehicle Accounting Cycle No.";
                                    END;
                                END;
                            GenJnlLine."Document Type"::"Credit Memo":
                                IF SalesCrMemoHeader.GET(GenJnlLine."Document No.") THEN BEGIN
                                    IF (SalesCrMemoHeader."Document Profile" = SalesCrMemoHeader."Document Profile"::"Vehicles Trade") AND
                                        (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) THEN BEGIN
                                        SalesCrMemoLine.RESET;
                                        SalesCrMemoLine.SETRANGE("Document No.", GenJnlLine."Document No.");
                                        IF SalesCrMemoLine.COUNT = 1 THEN BEGIN
                                            SalesCrMemoLine.FINDFIRST;
                                            GenJnlLine.VIN := SalesCrMemoLine.VIN;
                                            GenJnlLine."Make Code" := SalesCrMemoLine."Make Code";
                                            GenJnlLine."Model Code" := SalesCrMemoLine."Model Code";
                                            GenJnlLine."Model Version No." := SalesCrMemoLine."Model Version No.";
                                            GenJnlLine."Vehicle Serial No." := SalesCrMemoLine."Vehicle Serial No.";
                                            GenJnlLine."Vehicle Accounting Cycle No." := SalesCrMemoLine."Vehicle Accounting Cycle No.";
                                        END;
                                    END ELSE BEGIN
                                        GenJnlLine.VIN := SalesCrMemoHeader.VIN;
                                        GenJnlLine."Make Code" := SalesCrMemoHeader."Make Code";
                                        GenJnlLine."Model Code" := SalesCrMemoHeader."Model Code";
                                        GenJnlLine."Model Version No." := SalesCrMemoHeader."Model Version No.";
                                        GenJnlLine."Vehicle Serial No." := SalesCrMemoHeader."Vehicle Serial No.";
                                        GenJnlLine."Vehicle Accounting Cycle No." := SalesCrMemoHeader."Vehicle Accounting Cycle No.";
                                    END;
                                END;
                        END;
                    END;
            END;
        //23.01.2013 EDMS P8 <<


        IF GenJnlLine."Bill-to/Pay-to No." = '' THEN
            CASE TRUE OF
                GenJnlLine."Account Type" IN [GenJnlLine."Account Type"::Customer, GenJnlLine."Account Type"::Vendor]:
                    GenJnlLine."Bill-to/Pay-to No." := GenJnlLine."Account No.";
                GenJnlLine."Bal. Account Type" IN [GenJnlLine."Bal. Account Type"::Customer, GenJnlLine."Bal. Account Type"::Vendor]:
                    GenJnlLine."Bill-to/Pay-to No." := GenJnlLine."Bal. Account No.";
            END;
        IF GenJnlLine."Document Date" = 0D THEN
            GenJnlLine."Document Date" := GenJnlLine."Posting Date";
        IF GenJnlLine."Due Date" = 0D THEN
            GenJnlLine."Due Date" := GenJnlLine."Posting Date";

        JobLine := (GenJnlLine."Job No." <> '');

        IF NextEntryNo = 0 THEN
            StartPosting(GenJnlLine)
        ELSE
            ContinuePosting(GenJnlLine);

        InsertTDS(GenJnlLine); //TDS2.00

        IF GenJnlLine."Account No." <> '' THEN BEGIN
            IF (GenJnlLine."Bal. Account No." <> '') AND
               (NOT GenJnlLine."System-Created Entry") AND
               (GenJnlLine."Account Type" IN
                [GenJnlLine."Account Type"::Customer,
                 GenJnlLine."Account Type"::Vendor,
                 GenJnlLine."Account Type"::"Fixed Asset"])
            THEN BEGIN
                CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJnlLine);
                Balancing := TRUE;
            END;

            PostGenJnlLine(GenJnlLine, Balancing);
        END;

        IF GenJnlLine."Bal. Account No." <> '' THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJnlLine);
            PostGenJnlLine(GenJnlLine, NOT Balancing);
        END;

        CheckPostUnrealizedVAT(GenJnlLine, TRUE);

        CreateDeferralScheduleFromGL(GenJnlLine, Balancing);

        FinishPosting;
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "81"; Balancing: Boolean)
    begin
        CASE GenJnlLine."Account Type" OF
            GenJnlLine."Account Type"::"G/L Account":
                PostGLAcc(GenJnlLine, Balancing);
            GenJnlLine."Account Type"::Customer:
                PostCust(GenJnlLine, Balancing);
            GenJnlLine."Account Type"::Vendor:
                PostVend(GenJnlLine, Balancing);
            GenJnlLine."Account Type"::"Bank Account":
                PostBankAcc(GenJnlLine, Balancing);
            GenJnlLine."Account Type"::"Fixed Asset":
                PostFixedAsset(GenJnlLine);
            GenJnlLine."Account Type"::"IC Partner":
                PostICPartner(GenJnlLine);
        END;
    end;

    local procedure InitAmounts(var GenJnlLine: Record "81"): Decimal
    var
        Currency: Record "4";
    begin
        IF GenJnlLine."Currency Code" = '' THEN BEGIN
            Currency.InitRoundingPrecision;
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GenJnlLine."VAT Amount (LCY)" := GenJnlLine."VAT Amount";
            GenJnlLine."VAT Base Amount (LCY)" := GenJnlLine."VAT Base Amount";
        END ELSE BEGIN
            Currency.GET(GenJnlLine."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
            IF NOT GenJnlLine."System-Created Entry" THEN BEGIN
                GenJnlLine."Source Currency Code" := GenJnlLine."Currency Code";
                GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                GenJnlLine."Source Curr. VAT Base Amount" := GenJnlLine."VAT Base Amount";
                GenJnlLine."Source Curr. VAT Amount" := GenJnlLine."VAT Amount";
            END;
        END;
        IF GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None THEN BEGIN
            IF GenJnlLine.Amount <> ROUND(GenJnlLine.Amount, Currency."Amount Rounding Precision") THEN
                GenJnlLine.FIELDERROR(
                  Amount,
                  STRSUBSTNO(NeedsRoundingErr, GenJnlLine.Amount));
            IF GenJnlLine."Amount (LCY)" <> ROUND(GenJnlLine."Amount (LCY)") THEN
                GenJnlLine.FIELDERROR(
                  "Amount (LCY)",
                  STRSUBSTNO(NeedsRoundingErr, GenJnlLine."Amount (LCY)"));
        END;
        EXIT(Currency."Amount Rounding Precision");
    end;

    local procedure InitLastDocDate(GenJnlLine: Record "81")
    begin
        LastDocType := GenJnlLine."Document Type";
        LastDocNo := GenJnlLine."Document No.";
        LastDate := GenJnlLine."Posting Date";
    end;

    local procedure InitVAT(var GenJnlLine: Record "81"; var GLEntry: Record "17"; var VATPostingSetup: Record "325")
    var
        LCYCurrency: Record "4";
        SalesTaxCalculate: Codeunit "398";
    begin
        LCYCurrency.InitRoundingPrecision;
        IF GenJnlLine."Gen. Posting Type" <> 0 THEN BEGIN // None
            VATPostingSetup.GET(GenJnlLine."VAT Bus. Posting Group", GenJnlLine."VAT Prod. Posting Group");
            GenJnlLine.TESTFIELD("VAT Calculation Type", VATPostingSetup."VAT Calculation Type");
            CASE GenJnlLine."VAT Posting" OF
                GenJnlLine."VAT Posting"::"Automatic VAT Entry":
                    BEGIN
                        GLEntry.CopyPostingGroupsFromGenJnlLine(GenJnlLine);
                        CASE GenJnlLine."VAT Calculation Type" OF
                            GenJnlLine."VAT Calculation Type"::"Normal VAT":
                                IF GenJnlLine."VAT Difference" <> 0 THEN BEGIN
                                    GLEntry.Amount := GenJnlLine."VAT Base Amount (LCY)";
                                    GLEntry."VAT Amount" := GenJnlLine."Amount (LCY)" - GLEntry.Amount;
                                    GLEntry."Additional-Currency Amount" := GenJnlLine."Source Curr. VAT Base Amount";
                                    IF GenJnlLine."Source Currency Code" = AddCurrencyCode THEN
                                        AddCurrGLEntryVATAmt := GenJnlLine."Source Curr. VAT Amount"
                                    ELSE
                                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                END ELSE BEGIN
                                    GLEntry."VAT Amount" :=
                                      ROUND(
                                        GenJnlLine."Amount (LCY)" * VATPostingSetup."VAT %" / (100 + VATPostingSetup."VAT %"),
                                        LCYCurrency."Amount Rounding Precision", LCYCurrency.VATRoundingDirection);
                                    GLEntry.Amount := GenJnlLine."Amount (LCY)" - GLEntry."VAT Amount";
                                    IF GenJnlLine."Source Currency Code" = AddCurrencyCode THEN
                                        AddCurrGLEntryVATAmt :=
                                          ROUND(
                                            GenJnlLine."Source Currency Amount" * VATPostingSetup."VAT %" / (100 + VATPostingSetup."VAT %"),
                                            AddCurrency."Amount Rounding Precision", AddCurrency.VATRoundingDirection)
                                    ELSE
                                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                    GLEntry."Additional-Currency Amount" := GenJnlLine."Source Currency Amount" - AddCurrGLEntryVATAmt;
                                END;
                            GenJnlLine."VAT Calculation Type"::"Reverse Charge VAT":
                                CASE GenJnlLine."Gen. Posting Type" OF
                                    GenJnlLine."Gen. Posting Type"::Purchase:
                                        IF GenJnlLine."VAT Difference" <> 0 THEN BEGIN
                                            GLEntry."VAT Amount" := GenJnlLine."VAT Amount (LCY)";
                                            IF GenJnlLine."Source Currency Code" = AddCurrencyCode THEN
                                                AddCurrGLEntryVATAmt := GenJnlLine."Source Curr. VAT Amount"
                                            ELSE
                                                AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                        END ELSE BEGIN
                                            GLEntry."VAT Amount" :=
                                              ROUND(
                                                GLEntry.Amount * VATPostingSetup."VAT %" / 100,
                                                LCYCurrency."Amount Rounding Precision", LCYCurrency.VATRoundingDirection);
                                            IF GenJnlLine."Source Currency Code" = AddCurrencyCode THEN
                                                AddCurrGLEntryVATAmt :=
                                                  ROUND(
                                                    GLEntry."Additional-Currency Amount" * VATPostingSetup."VAT %" / 100,
                                                    AddCurrency."Amount Rounding Precision", AddCurrency.VATRoundingDirection)
                                            ELSE
                                                AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                        END;
                                    GenJnlLine."Gen. Posting Type"::Sale:
                                        BEGIN
                                            GLEntry."VAT Amount" := 0;
                                            AddCurrGLEntryVATAmt := 0;
                                        END;
                                END;
                            GenJnlLine."VAT Calculation Type"::"Full VAT":
                                BEGIN
                                    CASE GenJnlLine."Gen. Posting Type" OF
                                        GenJnlLine."Gen. Posting Type"::Sale:
                                            BEGIN
                                                VATPostingSetup.TESTFIELD("Sales VAT Account");
                                                GenJnlLine.TESTFIELD("Account No.", VATPostingSetup."Sales VAT Account");
                                            END;
                                        GenJnlLine."Gen. Posting Type"::Purchase:
                                            BEGIN
                                                VATPostingSetup.TESTFIELD("Purchase VAT Account");
                                                GenJnlLine.TESTFIELD("Account No.", VATPostingSetup."Purchase VAT Account");
                                            END;
                                    END;
                                    GLEntry.Amount := 0;
                                    GLEntry."Additional-Currency Amount" := 0;
                                    GLEntry."VAT Amount" := GenJnlLine."Amount (LCY)";
                                    IF GenJnlLine."Source Currency Code" = AddCurrencyCode THEN
                                        AddCurrGLEntryVATAmt := GenJnlLine."Source Currency Amount"
                                    ELSE
                                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GenJnlLine."Amount (LCY)");
                                END;
                            GenJnlLine."VAT Calculation Type"::"Sales Tax":
                                BEGIN
                                    IF (GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Purchase) AND
                                       GenJnlLine."Use Tax"
                                    THEN BEGIN
                                        GLEntry."VAT Amount" :=
                                          ROUND(
                                            SalesTaxCalculate.CalculateTax(
                                              GenJnlLine."Tax Area Code", GenJnlLine."Tax Group Code", GenJnlLine."Tax Liable",
                                              GenJnlLine."Posting Date", GenJnlLine."Amount (LCY)", GenJnlLine.Quantity, 0));
                                        GLEntry.Amount := GenJnlLine."Amount (LCY)";
                                    END ELSE BEGIN
                                        GLEntry.Amount :=
                                          ROUND(
                                            SalesTaxCalculate.ReverseCalculateTax(
                                              GenJnlLine."Tax Area Code", GenJnlLine."Tax Group Code", GenJnlLine."Tax Liable",
                                              GenJnlLine."Posting Date", GenJnlLine."Amount (LCY)", GenJnlLine.Quantity, 0));
                                        GLEntry."VAT Amount" := GenJnlLine."Amount (LCY)" - GLEntry.Amount;
                                    END;
                                    GLEntry."Additional-Currency Amount" := GenJnlLine."Source Currency Amount";
                                    IF GenJnlLine."Source Currency Code" = AddCurrencyCode THEN
                                        AddCurrGLEntryVATAmt := GenJnlLine."Source Curr. VAT Amount"
                                    ELSE
                                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                END;
                        END;
                    END;
                GenJnlLine."VAT Posting"::"Manual VAT Entry":
                    IF GenJnlLine."Gen. Posting Type" <> GenJnlLine."Gen. Posting Type"::Settlement THEN BEGIN
                        GLEntry.CopyPostingGroupsFromGenJnlLine(GenJnlLine);
                        GLEntry."VAT Amount" := GenJnlLine."VAT Amount (LCY)";
                        IF GenJnlLine."Source Currency Code" = AddCurrencyCode THEN
                            AddCurrGLEntryVATAmt := GenJnlLine."Source Curr. VAT Amount"
                        ELSE
                            AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GenJnlLine."VAT Amount (LCY)");
                    END;
            END;
        END;
        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(GLEntry.Amount, GLEntry."Additional-Currency Amount", GLEntry."Additional-Currency Amount", TRUE, GenJnlLine);
    end;

    local procedure PostVAT(GenJnlLine: Record "81"; var GLEntry: Record "17"; VATPostingSetup: Record "325")
    var
        TaxDetail2: Record "322";
        SalesTaxCalculate: Codeunit "398";
        VATAmount: Decimal;
        VATAmount2: Decimal;
        VATBase: Decimal;
        VATBase2: Decimal;
        SrcCurrVATAmount: Decimal;
        SrcCurrVATBase: Decimal;
        SrcCurrSalesTaxBaseAmount: Decimal;
        RemSrcCurrVATAmount: Decimal;
        SalesTaxBaseAmount: Decimal;
        TaxDetailFound: Boolean;
    begin
        // Post VAT
        // VAT for VAT entry
        CASE GenJnlLine."VAT Calculation Type" OF
            GenJnlLine."VAT Calculation Type"::"Normal VAT",
            GenJnlLine."VAT Calculation Type"::"Reverse Charge VAT",
            GenJnlLine."VAT Calculation Type"::"Full VAT":
                BEGIN
                    IF GenJnlLine."VAT Posting" = GenJnlLine."VAT Posting"::"Automatic VAT Entry" THEN
                        GenJnlLine."VAT Base Amount (LCY)" := GLEntry.Amount;
                    IF GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Settlement THEN
                        AddCurrGLEntryVATAmt := GenJnlLine."Source Curr. VAT Amount";
                    InsertVAT(
                      GenJnlLine, VATPostingSetup,
                      GLEntry.Amount, GLEntry."VAT Amount", GenJnlLine."VAT Base Amount (LCY)", GenJnlLine."Source Currency Code",
                      GLEntry."Additional-Currency Amount", AddCurrGLEntryVATAmt, GenJnlLine."Source Curr. VAT Base Amount");
                    NextConnectionNo := NextConnectionNo + 1;
                END;
            GenJnlLine."VAT Calculation Type"::"Sales Tax":
                BEGIN
                    CASE GenJnlLine."VAT Posting" OF
                        GenJnlLine."VAT Posting"::"Automatic VAT Entry":
                            SalesTaxBaseAmount := GLEntry.Amount;
                        GenJnlLine."VAT Posting"::"Manual VAT Entry":
                            SalesTaxBaseAmount := GenJnlLine."VAT Base Amount (LCY)";
                    END;
                    IF (GenJnlLine."VAT Posting" = GenJnlLine."VAT Posting"::"Manual VAT Entry") AND
                       (GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Settlement)
                    THEN
                        InsertVAT(
                          GenJnlLine, VATPostingSetup,
                          GLEntry.Amount, GLEntry."VAT Amount", GenJnlLine."VAT Base Amount (LCY)", GenJnlLine."Source Currency Code",
                          GenJnlLine."Source Curr. VAT Base Amount", GenJnlLine."Source Curr. VAT Amount", GenJnlLine."Source Curr. VAT Base Amount")
                    ELSE BEGIN
                        CLEAR(SalesTaxCalculate);
                        SalesTaxCalculate.InitSalesTaxLines(
                          GenJnlLine."Tax Area Code", GenJnlLine."Tax Group Code", GenJnlLine."Tax Liable",
                          SalesTaxBaseAmount, GenJnlLine.Quantity, GenJnlLine."Posting Date", GLEntry."VAT Amount");
                        SrcCurrVATAmount := 0;
                        SrcCurrSalesTaxBaseAmount := CalcLCYToAddCurr(SalesTaxBaseAmount);
                        RemSrcCurrVATAmount := AddCurrGLEntryVATAmt;
                        TaxDetailFound := FALSE;
                        WHILE SalesTaxCalculate.GetSalesTaxLine(TaxDetail2, VATAmount, VATBase) DO BEGIN
                            RemSrcCurrVATAmount := RemSrcCurrVATAmount - SrcCurrVATAmount;
                            IF TaxDetailFound THEN
                                InsertVAT(
                                  GenJnlLine, VATPostingSetup,
                                  SalesTaxBaseAmount, VATAmount2, VATBase2, GenJnlLine."Source Currency Code",
                                  SrcCurrSalesTaxBaseAmount, SrcCurrVATAmount, SrcCurrVATBase);
                            TaxDetailFound := TRUE;
                            TaxDetail := TaxDetail2;
                            VATAmount2 := VATAmount;
                            VATBase2 := VATBase;
                            SrcCurrVATAmount := CalcLCYToAddCurr(VATAmount);
                            SrcCurrVATBase := CalcLCYToAddCurr(VATBase);
                        END;
                        IF TaxDetailFound THEN
                            InsertVAT(
                              GenJnlLine, VATPostingSetup,
                              SalesTaxBaseAmount, VATAmount2, VATBase2, GenJnlLine."Source Currency Code",
                              SrcCurrSalesTaxBaseAmount, RemSrcCurrVATAmount, SrcCurrVATBase);
                        InsertSummarizedVAT(GenJnlLine);
                    END;
                END;
        END;
    end;

    local procedure InsertVAT(GenJnlLine: Record "81"; VATPostingSetup: Record "325"; GLEntryAmount: Decimal; GLEntryVATAmount: Decimal; GLEntryBaseAmount: Decimal; SrcCurrCode: Code[10]; SrcCurrGLEntryAmt: Decimal; SrcCurrGLEntryVATAmt: Decimal; SrcCurrGLEntryBaseAmt: Decimal)
    var
        TaxJurisdiction: Record "320";
        VATAmount: Decimal;
        VATBase: Decimal;
        SrcCurrVATAmount: Decimal;
        SrcCurrVATBase: Decimal;
        VATDifferenceLCY: Decimal;
        SrcCurrVATDifference: Decimal;
        UnrealizedVAT: Boolean;
    begin
        // Post VAT
        // VAT for VAT entry
        VATEntry.INIT;
        VATEntry.CopyFromGenJnlLine(GenJnlLine);
        VATEntry."Entry No." := NextVATEntryNo;
        VATEntry."EU Service" := VATPostingSetup."EU Service";
        VATEntry."Transaction No." := NextTransactionNo;
        VATEntry."Sales Tax Connection No." := NextConnectionNo;

        IF GenJnlLine."VAT Difference" = 0 THEN
            VATDifferenceLCY := 0
        ELSE
            IF GenJnlLine."Currency Code" = '' THEN
                VATDifferenceLCY := GenJnlLine."VAT Difference"
            ELSE
                VATDifferenceLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      GenJnlLine."Posting Date", GenJnlLine."Currency Code", GenJnlLine."VAT Difference",
                      CurrExchRate.ExchangeRate(GenJnlLine."Posting Date", GenJnlLine."Currency Code")));

        IF GenJnlLine."VAT Calculation Type" = GenJnlLine."VAT Calculation Type"::"Sales Tax" THEN BEGIN
            IF TaxDetail."Tax Jurisdiction Code" <> '' THEN
                TaxJurisdiction.GET(TaxDetail."Tax Jurisdiction Code");
            IF GenJnlLine."Gen. Posting Type" <> GenJnlLine."Gen. Posting Type"::Settlement THEN BEGIN
                VATEntry."Tax Group Used" := TaxDetail."Tax Group Code";
                VATEntry."Tax Type" := TaxDetail."Tax Type";
                VATEntry."Tax on Tax" := TaxDetail."Calculate Tax on Tax";
            END;
            VATEntry."Tax Jurisdiction Code" := TaxDetail."Tax Jurisdiction Code";
        END;

        IF AddCurrencyCode <> '' THEN
            IF AddCurrencyCode <> SrcCurrCode THEN BEGIN
                SrcCurrGLEntryAmt := ExchangeAmtLCYToFCY2(GLEntryAmount);
                SrcCurrGLEntryVATAmt := ExchangeAmtLCYToFCY2(GLEntryVATAmount);
                SrcCurrGLEntryBaseAmt := ExchangeAmtLCYToFCY2(GLEntryBaseAmount);
                SrcCurrVATDifference := ExchangeAmtLCYToFCY2(VATDifferenceLCY);
            END ELSE
                SrcCurrVATDifference := GenJnlLine."VAT Difference";

        UnrealizedVAT :=
          (((VATPostingSetup."Unrealized VAT Type" > 0) AND
            (VATPostingSetup."VAT Calculation Type" IN
             [VATPostingSetup."VAT Calculation Type"::"Normal VAT",
              VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT",
              VATPostingSetup."VAT Calculation Type"::"Full VAT"])) OR
           ((TaxJurisdiction."Unrealized VAT Type" > 0) AND
            (VATPostingSetup."VAT Calculation Type" IN
             [VATPostingSetup."VAT Calculation Type"::"Sales Tax"]))) AND
          IsNotPayment(GenJnlLine."Document Type");
        IF GLSetup."Prepayment Unrealized VAT" AND NOT GLSetup."Unrealized VAT" AND
           (VATPostingSetup."Unrealized VAT Type" > 0)
        THEN
            UnrealizedVAT := GenJnlLine.Prepayment;

        // VAT for VAT entry
        IF GenJnlLine."Gen. Posting Type" <> 0 THEN BEGIN
            CASE GenJnlLine."VAT Posting" OF
                GenJnlLine."VAT Posting"::"Automatic VAT Entry":
                    BEGIN
                        VATAmount := GLEntryVATAmount;
                        VATBase := GLEntryBaseAmount;
                        SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                        SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
                    END;
                GenJnlLine."VAT Posting"::"Manual VAT Entry":
                    BEGIN
                        IF GenJnlLine."Gen. Posting Type" = GenJnlLine."Gen. Posting Type"::Settlement THEN BEGIN
                            VATAmount := GLEntryAmount;
                            SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                            VATEntry.Closed := TRUE;
                        END ELSE BEGIN
                            VATAmount := GLEntryVATAmount;
                            SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                        END;
                        VATBase := GLEntryBaseAmount;
                        SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
                    END;
            END;

            IF UnrealizedVAT THEN BEGIN
                VATEntry.Amount := 0;
                VATEntry.Base := 0;
                VATEntry."Unrealized Amount" := VATAmount;
                VATEntry."Unrealized Base" := VATBase;
                VATEntry."Remaining Unrealized Amount" := VATEntry."Unrealized Amount";
                VATEntry."Remaining Unrealized Base" := VATEntry."Unrealized Base";
            END ELSE BEGIN
                VATEntry.Amount := VATAmount;
                VATEntry.Base := VATBase;
                VATEntry."Unrealized Amount" := 0;
                VATEntry."Unrealized Base" := 0;
                VATEntry."Remaining Unrealized Amount" := 0;
                VATEntry."Remaining Unrealized Base" := 0;
            END;

            IF AddCurrencyCode = '' THEN BEGIN
                VATEntry."Additional-Currency Base" := 0;
                VATEntry."Additional-Currency Amount" := 0;
                VATEntry."Add.-Currency Unrealized Amt." := 0;
                VATEntry."Add.-Currency Unrealized Base" := 0;
            END ELSE
                IF UnrealizedVAT THEN BEGIN
                    VATEntry."Additional-Currency Base" := 0;
                    VATEntry."Additional-Currency Amount" := 0;
                    VATEntry."Add.-Currency Unrealized Base" := SrcCurrVATBase;
                    VATEntry."Add.-Currency Unrealized Amt." := SrcCurrVATAmount;
                END ELSE BEGIN
                    VATEntry."Additional-Currency Base" := SrcCurrVATBase;
                    VATEntry."Additional-Currency Amount" := SrcCurrVATAmount;
                    VATEntry."Add.-Currency Unrealized Base" := 0;
                    VATEntry."Add.-Currency Unrealized Amt." := 0;
                END;
            VATEntry."Add.-Curr. Rem. Unreal. Amount" := VATEntry."Add.-Currency Unrealized Amt.";
            VATEntry."Add.-Curr. Rem. Unreal. Base" := VATEntry."Add.-Currency Unrealized Base";
            VATEntry."VAT Difference" := VATDifferenceLCY;
            VATEntry."Add.-Curr. VAT Difference" := SrcCurrVATDifference;

            VATEntry.INSERT(TRUE);
            GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.", VATEntry."Entry No.");
            NextVATEntryNo := NextVATEntryNo + 1;
        END;

        // VAT for G/L entry/entries
        IF (GLEntryVATAmount <> 0) OR
           ((SrcCurrGLEntryVATAmt <> 0) AND (SrcCurrCode = AddCurrencyCode))
        THEN
            CASE GenJnlLine."Gen. Posting Type" OF
                GenJnlLine."Gen. Posting Type"::Purchase:
                    CASE VATPostingSetup."VAT Calculation Type" OF
                        VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                      VATPostingSetup."VAT Calculation Type"::"Full VAT":
                            CreateGLEntry(GenJnlLine, VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                              GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                        VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                            BEGIN
                                CreateGLEntry(GenJnlLine, VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                                  GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                                CreateGLEntry(GenJnlLine, VATPostingSetup.GetRevChargeAccount(UnrealizedVAT),
                                  -GLEntryVATAmount, -SrcCurrGLEntryVATAmt, TRUE);
                            END;
                        VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                            IF GenJnlLine."Use Tax" THEN BEGIN
                                InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(UnrealizedVAT), '',
                                  GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                                InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetRevChargeAccount(UnrealizedVAT), '',
                                  -GLEntryVATAmount, -SrcCurrGLEntryVATAmt, TRUE);
                            END ELSE
                                InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(UnrealizedVAT), '',
                                  GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                    END;
                GenJnlLine."Gen. Posting Type"::Sale:
                    CASE VATPostingSetup."VAT Calculation Type" OF
                        VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                      VATPostingSetup."VAT Calculation Type"::"Full VAT":
                            CreateGLEntry(GenJnlLine, VATPostingSetup.GetSalesAccount(UnrealizedVAT),
                              GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                        VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                            ;
                        VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetSalesAccount(UnrealizedVAT), '',
                              GLEntryVATAmount, SrcCurrGLEntryVATAmt, TRUE);
                    END;
            END;
    end;

    local procedure SummarizeVAT(SummarizeGLEntries: Boolean; GLEntry: Record "17")
    var
        InsertedTempVAT: Boolean;
    begin
        InsertedTempVAT := FALSE;
        IF SummarizeGLEntries THEN
            IF TempGLEntryVAT.FINDSET THEN
                REPEAT
                    IF (TempGLEntryVAT."G/L Account No." = GLEntry."G/L Account No.") AND
                       (TempGLEntryVAT."Bal. Account No." = GLEntry."Bal. Account No.")
                    THEN BEGIN
                        TempGLEntryVAT.Amount := TempGLEntryVAT.Amount + GLEntry.Amount;
                        TempGLEntryVAT."Additional-Currency Amount" :=
                          TempGLEntryVAT."Additional-Currency Amount" + GLEntry."Additional-Currency Amount";
                        TempGLEntryVAT.MODIFY;
                        InsertedTempVAT := TRUE;
                    END;
                UNTIL (TempGLEntryVAT.NEXT = 0) OR InsertedTempVAT;
        IF NOT InsertedTempVAT OR NOT SummarizeGLEntries THEN BEGIN
            TempGLEntryVAT := GLEntry;
            TempGLEntryVAT."Entry No." :=
              TempGLEntryVAT."Entry No." + InsertedTempGLEntryVAT;
            TempGLEntryVAT.INSERT;
            InsertedTempGLEntryVAT := InsertedTempGLEntryVAT + 1;
        END;
    end;

    local procedure InsertSummarizedVAT(GenJnlLine: Record "81")
    begin
        IF TempGLEntryVAT.FINDSET THEN BEGIN
            REPEAT
                InsertGLEntry(GenJnlLine, TempGLEntryVAT, TRUE);
            UNTIL TempGLEntryVAT.NEXT = 0;
            TempGLEntryVAT.DELETEALL;
            InsertedTempGLEntryVAT := 0;
        END;
        NextConnectionNo := NextConnectionNo + 1;
    end;

    local procedure PostGLAcc(GenJnlLine: Record "81"; Balancing: Boolean)
    var
        GLAcc: Record "15";
        GLEntry: Record "17";
        VATPostingSetup: Record "325";
    begin
        GLAcc.GET(GenJnlLine."Account No.");
        // G/L entry
        InitGLEntry(GenJnlLine, GLEntry,
          GenJnlLine."Account No.", GenJnlLine."Amount (LCY)",
          GenJnlLine."Source Currency Amount", TRUE, GenJnlLine."System-Created Entry");
        IF NOT GenJnlLine."System-Created Entry" THEN
            IF GenJnlLine."Posting Date" = NORMALDATE(GenJnlLine."Posting Date") THEN
                GLAcc.TESTFIELD("Direct Posting", TRUE);
        IF GLAcc."Omit Default Descr. in Jnl." THEN
            IF DELCHR(GenJnlLine.Description, '=', ' ') = '' THEN
                ERROR(
                  DescriptionMustNotBeBlankErr,
                  GLAcc.FIELDCAPTION("Omit Default Descr. in Jnl."),
                  GLAcc."No.",
                  GenJnlLine.FIELDCAPTION(Description));
        GLEntry."Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        GLEntry."No. Series" := GenJnlLine."Posting No. Series";
        IF GenJnlLine."Additional-Currency Posting" =
           GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only"
        THEN BEGIN
            GLEntry."Additional-Currency Amount" := GenJnlLine.Amount;
            GLEntry.Amount := 0;
        END;
        // Store Entry No. to global variable for return:
        GLEntryNo := GLEntry."Entry No.";
        InitVAT(GenJnlLine, GLEntry, VATPostingSetup);
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        PostJob(GenJnlLine, GLEntry);
        PostVAT(GenJnlLine, GLEntry, VATPostingSetup);

        IF ("Sales Invoice No." <> '') AND (GenJnlLine."Account No." = '701001') THEN
            CommissionUpdate("Sales Invoice No."); //Sipradi-YS *8.21.2012* Update Sales Invoice Header

        DeferralPosting(GenJnlLine."Deferral Code", GenJnlLine."Source Code", GenJnlLine."Account No.", GenJnlLine, Balancing);
        OnMoveGenJournalLine(GLEntry.RECORDID);
    end;

    local procedure PostCust(var GenJnlLine: Record "81"; Balancing: Boolean)
    var
        LineFeeNoteOnReportHist: Record "1053";
        Cust: Record "18";
        CustPostingGr: Record "92";
        CustLedgEntry: Record "21";
        CVLedgEntryBuf: Record "382";
        TempDtldCVLedgEntryBuf: Record "383" temporary;
        DtldCustLedgEntry: Record "379";
        ReceivablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
    begin
        Cust.GET(GenJnlLine."Account No.");
        Cust.CheckBlockedCustOnJnls(Cust, GenJnlLine."Document Type", TRUE);

        IF GenJnlLine."Posting Group" = '' THEN BEGIN
            Cust.TESTFIELD("Customer Posting Group");
            GenJnlLine."Posting Group" := Cust."Customer Posting Group";
        END;
        CustPostingGr.GET(GenJnlLine."Posting Group");
        ReceivablesAccount := CustPostingGr.GetReceivablesAccount;

        DtldCustLedgEntry.LOCKTABLE;
        CustLedgEntry.LOCKTABLE;

        InitCustLedgEntry(GenJnlLine, CustLedgEntry);

        IF NOT Cust."Block Payment Tolerance" THEN
            CalcPmtTolerancePossible(
              GenJnlLine, CustLedgEntry."Pmt. Discount Date", CustLedgEntry."Pmt. Disc. Tolerance Date",
              CustLedgEntry."Max. Payment Tolerance");

        TempDtldCVLedgEntryBuf.DELETEALL;
        TempDtldCVLedgEntryBuf.INIT;
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        TempDtldCVLedgEntryBuf."CV Ledger Entry No." := CustLedgEntry."Entry No.";
        CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
        TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
        CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
        CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

        CalcPmtDiscPossible(GenJnlLine, CVLedgEntryBuf);

        IF GenJnlLine."Currency Code" <> '' THEN BEGIN
            GenJnlLine.TESTFIELD("Currency Factor");
            CVLedgEntryBuf."Original Currency Factor" := GenJnlLine."Currency Factor"
        END ELSE
            CVLedgEntryBuf."Original Currency Factor" := 1;
        CVLedgEntryBuf."Adjusted Currency Factor" := CVLedgEntryBuf."Original Currency Factor";

        // Check the document no.
        IF GenJnlLine."Recurring Method" = 0 THEN
            IF IsNotPayment(GenJnlLine."Document Type") THEN BEGIN
                GenJnlCheckLine.CheckSalesDocNoIsNotUsed(GenJnlLine."Document Type", GenJnlLine."Document No.");
                CheckSalesExtDocNo(GenJnlLine);
            END;

        // Post application
        ApplyCustLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Cust);

        // Post customer entry
        CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        CustLedgEntry."Amount to Apply" := 0;
        CustLedgEntry."Applies-to Doc. No." := '';
        CustLedgEntry.INSERT(TRUE);

        // Post detailed customer entries
        DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, CustPostingGr, TRUE);

        // Post Reminder Terms - Note About Line Fee on Report
        LineFeeNoteOnReportHist.Save(CustLedgEntry);

        IF DtldLedgEntryInserted THEN
            IF IsTempGLEntryBufEmpty THEN
                DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);

        DeferralPosting(GenJnlLine."Deferral Code", GenJnlLine."Source Code", ReceivablesAccount, GenJnlLine, Balancing);
        OnMoveGenJournalLine(CustLedgEntry.RECORDID);
    end;

    local procedure PostVend(GenJnlLine: Record "81"; Balancing: Boolean)
    var
        Vend: Record "23";
        VendPostingGr: Record "93";
        VendLedgEntry: Record "25";
        CVLedgEntryBuf: Record "382";
        TempDtldCVLedgEntryBuf: Record "383" temporary;
        DtldVendLedgEntry: Record "380";
        PayablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
    begin
        Vend.GET(GenJnlLine."Account No.");
        Vend.CheckBlockedVendOnJnls(Vend, GenJnlLine."Document Type", TRUE);

        IF GenJnlLine."Posting Group" = '' THEN BEGIN
            Vend.TESTFIELD("Vendor Posting Group");
            GenJnlLine."Posting Group" := Vend."Vendor Posting Group";
        END;
        VendPostingGr.GET(GenJnlLine."Posting Group");
        PayablesAccount := VendPostingGr.GetPayablesAccount;

        DtldVendLedgEntry.LOCKTABLE;
        VendLedgEntry.LOCKTABLE;

        InitVendLedgEntry(GenJnlLine, VendLedgEntry);

        IF NOT Vend."Block Payment Tolerance" THEN
            CalcPmtTolerancePossible(
              GenJnlLine, VendLedgEntry."Pmt. Discount Date", VendLedgEntry."Pmt. Disc. Tolerance Date",
              VendLedgEntry."Max. Payment Tolerance");

        TempDtldCVLedgEntryBuf.DELETEALL;
        TempDtldCVLedgEntryBuf.INIT;
        TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
        TempDtldCVLedgEntryBuf."CV Ledger Entry No." := VendLedgEntry."Entry No.";
        CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
        TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf, CVLedgEntryBuf, TRUE);
        CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
        CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

        CalcPmtDiscPossible(GenJnlLine, CVLedgEntryBuf);

        IF GenJnlLine."Currency Code" <> '' THEN BEGIN
            GenJnlLine.TESTFIELD("Currency Factor");
            CVLedgEntryBuf."Adjusted Currency Factor" := GenJnlLine."Currency Factor"
        END ELSE
            CVLedgEntryBuf."Adjusted Currency Factor" := 1;
        CVLedgEntryBuf."Original Currency Factor" := CVLedgEntryBuf."Adjusted Currency Factor";

        // Check the document no.
        IF GenJnlLine."Recurring Method" = 0 THEN
            IF IsNotPayment(GenJnlLine."Document Type") THEN BEGIN
                GenJnlCheckLine.CheckPurchDocNoIsNotUsed(GenJnlLine."Document Type", GenJnlLine."Document No.");
                CheckPurchExtDocNo(GenJnlLine);
            END;

        // Post application
        ApplyVendLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Vend);

        // Post vendor entry
        VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        VendLedgEntry."Amount to Apply" := 0;
        VendLedgEntry."Applies-to Doc. No." := '';
        VendLedgEntry.INSERT(TRUE);

        // Post detailed vendor entries
        DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, VendPostingGr, TRUE);

        IF DtldLedgEntryInserted THEN
            IF IsTempGLEntryBufEmpty THEN
                DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
        DeferralPosting(GenJnlLine."Deferral Code", GenJnlLine."Source Code", PayablesAccount, GenJnlLine, Balancing);
        OnMoveGenJournalLine(VendLedgEntry.RECORDID);
    end;

    local procedure PostBankAcc(GenJnlLine: Record "81"; Balancing: Boolean)
    var
        BankAcc: Record "270";
        BankAccLedgEntry: Record "271";
        CheckLedgEntry: Record "272";
        CheckLedgEntry2: Record "272";
        BankAccPostingGr: Record "277";
    begin
        BankAcc.GET(GenJnlLine."Account No.");
        BankAcc.TESTFIELD(Blocked, FALSE);
        IF GenJnlLine."Currency Code" = '' THEN
            BankAcc.TESTFIELD("Currency Code", '')
        ELSE
            IF BankAcc."Currency Code" <> '' THEN
                GenJnlLine.TESTFIELD("Currency Code", BankAcc."Currency Code");

        BankAcc.TESTFIELD("Bank Acc. Posting Group");
        BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group");

        BankAccLedgEntry.LOCKTABLE;

        InitBankAccLedgEntry(GenJnlLine, BankAccLedgEntry);

        BankAccLedgEntry."Bank Acc. Posting Group" := BankAcc."Bank Acc. Posting Group";
        BankAccLedgEntry."Currency Code" := BankAcc."Currency Code";
        IF BankAcc."Currency Code" <> '' THEN
            BankAccLedgEntry.Amount := GenJnlLine.Amount
        ELSE
            BankAccLedgEntry.Amount := GenJnlLine."Amount (LCY)";
        BankAccLedgEntry."Amount (LCY)" := GenJnlLine."Amount (LCY)";
        BankAccLedgEntry.Open := GenJnlLine.Amount <> 0;
        BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
        BankAccLedgEntry.Positive := GenJnlLine.Amount > 0;
        BankAccLedgEntry.UpdateDebitCredit(GenJnlLine.Correction);
        BankAccLedgEntry.INSERT(TRUE);

        IF ((GenJnlLine.Amount <= 0) AND (GenJnlLine."Bank Payment Type" = GenJnlLine."Bank Payment Type"::"Computer Check") AND GenJnlLine."Check Printed") OR
           ((GenJnlLine.Amount < 0) AND (GenJnlLine."Bank Payment Type" = GenJnlLine."Bank Payment Type"::"Manual Check"))
        THEN BEGIN
            IF BankAcc."Currency Code" <> GenJnlLine."Currency Code" THEN
                ERROR(BankPaymentTypeMustNotBeFilledErr);
            CASE GenJnlLine."Bank Payment Type" OF
                GenJnlLine."Bank Payment Type"::"Computer Check":
                    BEGIN
                        GenJnlLine.TESTFIELD("Check Printed", TRUE);
                        CheckLedgEntry.LOCKTABLE;
                        CheckLedgEntry.RESET;
                        CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
                        CheckLedgEntry.SETRANGE("Bank Account No.", GenJnlLine."Account No.");
                        CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
                        CheckLedgEntry.SETRANGE("Check No.", GenJnlLine."Document No.");
                        IF CheckLedgEntry.FINDSET THEN
                            REPEAT
                                CheckLedgEntry2 := CheckLedgEntry;
                                CheckLedgEntry2."Entry Status" := CheckLedgEntry2."Entry Status"::Posted;
                                CheckLedgEntry2."Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
                                CheckLedgEntry2.MODIFY;
                            UNTIL CheckLedgEntry.NEXT = 0;
                    END;
                GenJnlLine."Bank Payment Type"::"Manual Check":
                    BEGIN
                        IF GenJnlLine."Document No." = '' THEN
                            ERROR(DocNoMustBeEnteredErr, GenJnlLine."Bank Payment Type");
                        CheckLedgEntry.RESET;
                        IF NextCheckEntryNo = 0 THEN BEGIN
                            CheckLedgEntry.LOCKTABLE;
                            IF CheckLedgEntry.FINDLAST THEN
                                NextCheckEntryNo := CheckLedgEntry."Entry No." + 1
                            ELSE
                                NextCheckEntryNo := 1;
                        END;

                        CheckLedgEntry.SETRANGE("Bank Account No.", GenJnlLine."Account No.");
                        CheckLedgEntry.SETFILTER(
                          "Entry Status", '%1|%2|%3',
                          CheckLedgEntry."Entry Status"::Printed,
                          CheckLedgEntry."Entry Status"::Posted,
                          CheckLedgEntry."Entry Status"::"Financially Voided");
                        CheckLedgEntry.SETRANGE("Check No.", GenJnlLine."Document No.");
                        IF NOT CheckLedgEntry.ISEMPTY THEN
                            ERROR(CheckAlreadyExistsErr, GenJnlLine."Document No.");

                        InitCheckLedgEntry(BankAccLedgEntry, CheckLedgEntry);
                        CheckLedgEntry."Bank Payment Type" := CheckLedgEntry."Bank Payment Type"::"Manual Check";
                        IF BankAcc."Currency Code" <> '' THEN
                            CheckLedgEntry.Amount := -GenJnlLine.Amount
                        ELSE
                            CheckLedgEntry.Amount := -GenJnlLine."Amount (LCY)";
                        CheckLedgEntry.INSERT(TRUE);
                        NextCheckEntryNo := NextCheckEntryNo + 1;
                    END;
            END;
        END;


        // CNY.RK >>

        CheckEnt_G.RESET;
        CheckEnt_G.SETRANGE("Bank No.", GenJnlLine."Account No.");
        CheckEnt_G.SETRANGE("Cheque No.", GenJnlLine."Cheque No.");
        IF CheckEnt_G.FINDFIRST THEN BEGIN
            CheckEnt_G.Posted := TRUE;
            CheckEnt_G."Document No." := GenJnlLine."Document No.";
            CheckEnt_G."Cheque Date" := GenJnlLine."Posting Date";
            IF GenJnlLine."Document Class" = GenJnlLine."Document Class"::Vendor THEN BEGIN
                IF Vendor_G.GET(GenJnlLine."Document Subclass") THEN
                    CheckEnt_G."Payee Name" := Vendor_G.Name;
            END ELSE
                IF GenJnlLine."Document Class" = GenJnlLine."Document Class"::Customer THEN BEGIN
                    IF Customer_G.GET(GenJnlLine."Document Subclass") THEN
                        CheckEnt_G."Payee Name" := Customer_G.Name;
                END;

            //CheckEnt_G."Payee Name" := GenJnlLine."Document Subclass";
            CheckEnt_G."Document Class" := GenJnlLine."Document Class";
            CheckEnt_G."Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            CheckEnt_G."Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            CheckEnt_G."Cheque Type" := GenJnlLine."Cheque Type";
            CheckEnt_G."Cheque Amount" := GenJnlLine.Amount;
            CheckEnt_G.MODIFY;
        END;

        // CNY.RK <<

        BankAccPostingGr.TESTFIELD("G/L Bank Account No.");
        CreateGLEntryBalAcc(
          GenJnlLine, BankAccPostingGr."G/L Bank Account No.", GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount",
          GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
        DeferralPosting(GenJnlLine."Deferral Code", GenJnlLine."Source Code", BankAccPostingGr."G/L Bank Account No.", GenJnlLine, Balancing);
        OnMoveGenJournalLine(BankAccLedgEntry.RECORDID);
    end;

    local procedure PostFixedAsset(GenJnlLine: Record "81")
    var
        GLEntry: Record "17";
        GLEntry2: Record "17";
        TempFAGLPostBuf: Record "5637" temporary;
        FAGLPostBuf: Record "5637";
        VATPostingSetup: Record "325";
        FAJnlPostLine: Codeunit "5632";
        FAAutomaticEntry: Codeunit "5607";
        ShortcutDim1Code: Code[20];
        ShortcutDim2Code: Code[20];
        Correction2: Boolean;
        NetDisposalNo: Integer;
        DimensionSetID: Integer;
        VATEntryGLEntryNo: Integer;
    begin
        InitGLEntry(GenJnlLine, GLEntry, '', GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount", TRUE, GenJnlLine."System-Created Entry");
        GLEntry."Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        InitVAT(GenJnlLine, GLEntry, VATPostingSetup);
        GLEntry2 := GLEntry;
        FAJnlPostLine.GenJnlPostLine(
          GenJnlLine, GLEntry2.Amount, GLEntry2."VAT Amount", NextTransactionNo, NextEntryNo, GLReg."No.");
        ShortcutDim1Code := GenJnlLine."Shortcut Dimension 1 Code";
        ShortcutDim2Code := GenJnlLine."Shortcut Dimension 2 Code";
        DimensionSetID := GenJnlLine."Dimension Set ID";
        Correction2 := GenJnlLine.Correction;
        IF FAJnlPostLine.FindFirstGLAcc(TempFAGLPostBuf) THEN
            REPEAT
                GenJnlLine."Shortcut Dimension 1 Code" := TempFAGLPostBuf."Global Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := TempFAGLPostBuf."Global Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := TempFAGLPostBuf."Dimension Set ID";
                GenJnlLine.Correction := TempFAGLPostBuf.Correction;
                FADimAlreadyChecked := TempFAGLPostBuf."FA Posting Group" <> '';
                CheckDimValueForDisposal(GenJnlLine, TempFAGLPostBuf."Account No.");
                IF TempFAGLPostBuf."Original General Journal Line" THEN
                    InitGLEntry(GenJnlLine, GLEntry, TempFAGLPostBuf."Account No.", TempFAGLPostBuf.Amount, GLEntry2."Additional-Currency Amount", TRUE, TRUE)
                ELSE BEGIN
                    CheckNonAddCurrCodeOccurred('');
                    InitGLEntry(GenJnlLine, GLEntry, TempFAGLPostBuf."Account No.", TempFAGLPostBuf.Amount, 0, FALSE, TRUE);
                END;
                FADimAlreadyChecked := FALSE;
                GLEntry.CopyPostingGroupsFromGLEntry(GLEntry2);
                GLEntry."VAT Amount" := GLEntry2."VAT Amount";
                GLEntry."Bal. Account Type" := GLEntry2."Bal. Account Type";
                GLEntry."Bal. Account No." := GLEntry2."Bal. Account No.";
                GLEntry."FA Entry Type" := TempFAGLPostBuf."FA Entry Type";
                GLEntry."FA Entry No." := TempFAGLPostBuf."FA Entry No.";
                IF TempFAGLPostBuf."Net Disposal" THEN
                    NetDisposalNo := NetDisposalNo + 1
                ELSE
                    NetDisposalNo := 0;
                IF TempFAGLPostBuf."Automatic Entry" AND NOT TempFAGLPostBuf."Net Disposal" THEN
                    FAAutomaticEntry.AdjustGLEntry(GLEntry);
                IF NetDisposalNo > 1 THEN
                    GLEntry."VAT Amount" := 0;
                IF TempFAGLPostBuf."FA Posting Group" <> '' THEN BEGIN
                    FAGLPostBuf := TempFAGLPostBuf;
                    FAGLPostBuf."Entry No." := NextEntryNo;
                    FAGLPostBuf.INSERT;
                END;
                InsertGLEntry(GenJnlLine, GLEntry, TRUE);
                IF (VATEntryGLEntryNo = 0) AND (GLEntry."Gen. Posting Type" <> GLEntry."Gen. Posting Type"::" ") THEN
                    VATEntryGLEntryNo := GLEntry."Entry No.";
            UNTIL FAJnlPostLine.GetNextGLAcc(TempFAGLPostBuf) = 0;
        GenJnlLine."Shortcut Dimension 1 Code" := ShortcutDim1Code;
        GenJnlLine."Shortcut Dimension 2 Code" := ShortcutDim2Code;
        GenJnlLine."Dimension Set ID" := DimensionSetID;
        GenJnlLine.Correction := Correction2;
        GLEntry := GLEntry2;
        IF VATEntryGLEntryNo = 0 THEN
            VATEntryGLEntryNo := GLEntry."Entry No.";
        TempGLEntryBuf."Entry No." := VATEntryGLEntryNo; // Used later in InsertVAT(): GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.",VATEntry."Entry No.")
        PostVAT(GenJnlLine, GLEntry, VATPostingSetup);

        FAJnlPostLine.UpdateRegNo(GLReg."No.");
        GenJnlLine.OnMoveGenJournalLine(GLEntry.RECORDID);
    end;

    local procedure PostICPartner(GenJnlLine: Record "81")
    var
        ICPartner: Record "413";
        AccountNo: Code[20];
    begin
        IF GenJnlLine."Account No." <> ICPartner.Code THEN
            ICPartner.GET(GenJnlLine."Account No.");
        IF (GenJnlLine."Document Type" = GenJnlLine."Document Type"::"Credit Memo") XOR (GenJnlLine.Amount > 0) THEN BEGIN
            ICPartner.TESTFIELD("Receivables Account");
            AccountNo := ICPartner."Receivables Account";
        END ELSE BEGIN
            ICPartner.TESTFIELD("Payables Account");
            AccountNo := ICPartner."Payables Account";
        END;

        CreateGLEntryBalAcc(
          GenJnlLine, AccountNo, GenJnlLine."Amount (LCY)", GenJnlLine."Source Currency Amount",
          GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
    end;

    local procedure PostJob(GenJnlLine: Record "81"; GLEntry: Record "17")
    var
        JobPostLine: Codeunit "1001";
    begin
        IF JobLine THEN BEGIN
            JobLine := FALSE;
            JobPostLine.PostGenJnlLine(GenJnlLine, GLEntry);
        END;
    end;

    [Scope('Internal')]
    procedure StartPosting(GenJnlLine: Record "81")
    var
        GenJnlTemplate: Record "80";
        AccountingPeriod: Record "50";
    begin
        OnBeforePostGenJnlLine(GenJnlLine);

        GlobalGLEntry.LOCKTABLE;
        IF GlobalGLEntry.FINDLAST THEN BEGIN
            NextEntryNo := GlobalGLEntry."Entry No." + 1;
            NextTransactionNo := GlobalGLEntry."Transaction No." + 1;
        END ELSE BEGIN
            NextEntryNo := 1;
            NextTransactionNo := 1;
        END;

        InitLastDocDate(GenJnlLine);
        CurrentBalance := 0;

        AccountingPeriod.RESET;
        AccountingPeriod.SETCURRENTKEY(Closed);
        AccountingPeriod.SETRANGE(Closed, FALSE);
        AccountingPeriod.FINDFIRST;
        FiscalYearStartDate := AccountingPeriod."Starting Date";

        GetGLSetup;

        IF NOT GenJnlTemplate.GET(GenJnlLine."Journal Template Name") THEN
            GenJnlTemplate.INIT;

        VATEntry.LOCKTABLE;
        IF VATEntry.FINDLAST THEN
            NextVATEntryNo := VATEntry."Entry No." + 1
        ELSE
            NextVATEntryNo := 1;
        NextConnectionNo := 1;
        FirstNewVATEntryNo := NextVATEntryNo;

        GLReg.LOCKTABLE;
        IF GLReg.FINDLAST THEN
            GLReg."No." := GLReg."No." + 1
        ELSE
            GLReg."No." := 1;
        GLReg.INIT;
        GLReg."From Entry No." := NextEntryNo;
        GLReg."From VAT Entry No." := NextVATEntryNo;
        GLReg."From TDS Entry No." := NextTdsEntryNo; //TDS2.00
        GLReg."Creation Date" := TODAY;
        GLReg."Source Code" := GenJnlLine."Source Code";
        GLReg."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        GLReg."User ID" := USERID;
        GLReg."Pre Assigned No." := "Pre Assigned No."; //**SM 11-08-2013 to flow document no. before posting
        IsGLRegInserted := FALSE;

        OnAfterInitGLRegister(GLReg, GenJnlLine);

        GetCurrencyExchRate(GenJnlLine);
        TempGLEntryBuf.DELETEALL;
        CalculateCurrentBalance(
          GenJnlLine."Account No.", GenJnlLine."Bal. Account No.", GenJnlLine.IncludeVATAmount, GenJnlLine."Amount (LCY)", GenJnlLine."VAT Amount");
    end;

    [Scope('Internal')]
    procedure ContinuePosting(GenJnlLine: Record "81")
    begin
        IF (LastDocType <> GenJnlLine."Document Type") OR (LastDocNo <> GenJnlLine."Document No.") OR
   (LastDate <> GenJnlLine."Posting Date") OR ((CurrentBalance = 0) AND (TotalAddCurrAmount = 0)) AND NOT GenJnlLine."System-Created Entry"
THEN BEGIN
            CheckPostUnrealizedVAT(GenJnlLine, FALSE);
            NextTransactionNo := NextTransactionNo + 1;
            InitLastDocDate(GenJnlLine);
            FirstNewVATEntryNo := NextVATEntryNo;
        END;

        GetCurrencyExchRate(GenJnlLine);
        TempGLEntryBuf.DELETEALL;
        CalculateCurrentBalance(
          GenJnlLine."Account No.", GenJnlLine."Bal. Account No.", GenJnlLine.IncludeVATAmount, GenJnlLine."Amount (LCY)", GenJnlLine."VAT Amount");
    end;

    [Scope('Internal')]
    procedure FinishPosting()
    var
        CostAccSetup: Record "1108";
        TransferGlEntriesToCA: Codeunit "1105";
        IsTransactionConsistent: Boolean;
    begin
        IsTransactionConsistent :=
          (BalanceCheckAmount = 0) AND (BalanceCheckAmount2 = 0) AND
          (BalanceCheckAddCurrAmount = 0) AND (BalanceCheckAddCurrAmount2 = 0);

        IF TempGLEntryBuf.FINDSET THEN BEGIN
            REPEAT
                GlobalGLEntry := TempGLEntryBuf;
                IF AddCurrencyCode = '' THEN BEGIN
                    GlobalGLEntry."Additional-Currency Amount" := 0;
                    GlobalGLEntry."Add.-Currency Debit Amount" := 0;
                    GlobalGLEntry."Add.-Currency Credit Amount" := 0;
                END;
                GlobalGLEntry."Prior-Year Entry" := GlobalGLEntry."Posting Date" < FiscalYearStartDate;
                GlobalGLEntry.INSERT(TRUE);
                OnAfterInsertGlobalGLEntry(GlobalGLEntry);
            UNTIL TempGLEntryBuf.NEXT = 0;

            GLReg."To VAT Entry No." := NextVATEntryNo - 1;
            GLReg."To TDS Entry No." := NextTdsEntryNo - 1; //TDS2.00
            GLReg."To Entry No." := GlobalGLEntry."Entry No.";
            IF IsTransactionConsistent THEN
                IF IsGLRegInserted THEN
                    GLReg.MODIFY
                ELSE BEGIN
                    GLReg.INSERT;
                    IsGLRegInserted := TRUE;
                END;
        END;
        GlobalGLEntry.CONSISTENT(IsTransactionConsistent);

        IF CostAccSetup.GET THEN
            IF CostAccSetup."Auto Transfer from G/L" THEN
                TransferGlEntriesToCA.GetGLEntries;

        FirstEntryNo := 0;
    end;

    local procedure PostUnrealizedVAT(GenJnlLine: Record "81")
    begin
        IF CheckUnrealizedCust THEN BEGIN
            CustUnrealizedVAT(GenJnlLine, UnrealizedCustLedgEntry, UnrealizedRemainingAmountCust);
            CheckUnrealizedCust := FALSE;
        END;
        IF CheckUnrealizedVend THEN BEGIN
            VendUnrealizedVAT(GenJnlLine, UnrealizedVendLedgEntry, UnrealizedRemainingAmountVend);
            CheckUnrealizedVend := FALSE;
        END;
    end;

    local procedure CheckPostUnrealizedVAT(GenJnlLine: Record "81"; CheckCurrentBalance: Boolean)
    begin
        IF CheckCurrentBalance AND (CurrentBalance = 0) OR NOT CheckCurrentBalance THEN
            PostUnrealizedVAT(GenJnlLine)
    end;

    local procedure InitGLEntry(GenJnlLine: Record "81"; var GLEntry: Record "17"; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean)
    var
        GLAcc: Record "15";
        lrecVFiSetup: Record "33020064";
        VFline: Record "33020063";
        PaidAmount: Decimal;
        VFline1: Record "33020063";
        VFline2: Record "33020063";
        PendingAmt: Decimal;
    begin
        IF GLAccNo <> '' THEN BEGIN
            GLAcc.GET(GLAccNo);
            GLAcc.TESTFIELD(Blocked, FALSE);
            GLAcc.TESTFIELD("Account Type", GLAcc."Account Type"::Posting);

            //EDMS1.0.00 >>
            IF (GLAcc."Vehicle ID Mandatory") THEN
                GenJnlLine.TESTFIELD("Vehicle Serial No.");
            //EDMS1.0.00 <<

            // Check the Value Posting field on the G/L Account if it is not checked already in Codeunit 11
            IF (NOT
                ((GLAccNo = GenJnlLine."Account No.") AND
                 (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account")) OR
                ((GLAccNo = GenJnlLine."Bal. Account No.") AND
                 (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"G/L Account"))) AND
               NOT FADimAlreadyChecked
            THEN
                CheckGLAccDimError(GenJnlLine, GLAccNo);
        END;


        //--surya--check and block if Document Class Mandatory in GL Account
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
            TDSAccount.SETRANGE("No.", GenJnlLine."Account No.");
            IF TDSAccount.FINDFIRST THEN BEGIN
                IF TDSAccount."Document Class Mandatory" THEN BEGIN
                    // CASE IF DOCUMENT CLASS IS BLANK ---> chandra 01.09.2015
                    IF TDSAccount."Document Class" = TDSAccount."Document Class"::" " THEN BEGIN
                        IF GenJnlLine."Document Subclass" = '' THEN
                            ERROR('Please update Document Class account in %1, %2, %3,%4',
                                  GenJnlLine.TABLECAPTION, GenJnlLine."Journal Template Name",
                                  GenJnlLine."Journal Batch Name", GenJnlLine."Line No.");
                    END;
                    // CASE IF DOCUMENT CLASS IS CUSTOMER ---> chandra 01.09.2015
                    IF TDSAccount."Document Class" = TDSAccount."Document Class"::Customer THEN BEGIN
                        IF (GenJnlLine."Document Class" <> GenJnlLine."Document Class"::Customer) OR (GenJnlLine."Document Subclass" = '') THEN
                            ERROR('Please update Document Class Customer in %1, %2, %3,%4',
                                  GenJnlLine.TABLECAPTION, GenJnlLine."Journal Template Name",
                                  GenJnlLine."Journal Batch Name", GenJnlLine."Line No.");
                    END;
                    // CASE IF DOCUMENT CLASS IS VENDOR ---> chandra 01.09.2015
                    IF TDSAccount."Document Class" = TDSAccount."Document Class"::Vendor THEN BEGIN
                        IF (GenJnlLine."Document Class" <> GenJnlLine."Document Class"::Vendor) OR (GenJnlLine."Document Subclass" = '') THEN
                            ERROR('Please update Document Class Vendor in %1, %2, %3,%4',
                                  GenJnlLine.TABLECAPTION, GenJnlLine."Journal Template Name",
                                  GenJnlLine."Journal Batch Name", GenJnlLine."Line No.");
                    END;
                    // CASE IF DOCUMENT CLASS IS BANK ACCOUNT ---> chandra 01.09.2015
                    IF TDSAccount."Document Class" = TDSAccount."Document Class"::"Bank Account" THEN BEGIN
                        IF (GenJnlLine."Document Class" <> GenJnlLine."Document Class"::"Bank Account")
                        OR (GenJnlLine."Document Subclass" = '') THEN BEGIN
                            ERROR('Please update Document Class Bank Account in %1, %2, %3,%4',
                                  GenJnlLine.TABLECAPTION, GenJnlLine."Journal Template Name",
                                  GenJnlLine."Journal Batch Name", GenJnlLine."Line No.");
                        END;
                    END;
                    //
                END;
            END;
        END;
        //---surya-Document Class Mandatory---15 May 2012
        //VF >>
        //OnProcessInitGLEntry(GLEntry,GenJnlLine); //Added Min
        //VF <<
        //  Update Vehicle finance payment line >> //Min Comment
        /*IF (GenJnlLine."VF Loan File No." <> '') AND (GenJnlLine."VF Loan Disburse Entry"=FALSE)
           AND (GenJnlLine.Amount < 0) AND (GenJnlLine."VF Installment No." <> 0) THEN BEGIN
              LineNo := 0;
              VFPaymentRec.SETRANGE("Loan No.",GenJnlLine."VF Loan File No.");
              VFPaymentRec.SETRANGE("Installment No.",GenJnlLine."VF Installment No.");
              VFPaymentRec.SETRANGE("G/L Receipt No.",GenJnlLine."Document No.");
              IF VFPaymentRec.FINDFIRST THEN BEGIN
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Principal THEN
                  VFPaymentRec."Principal Paid" := ABS(GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Interest THEN
                  VFPaymentRec."Interest Paid" := ABS(GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Penalty THEN
                  VFPaymentRec."Penalty Paid" := ABS(GenJnlLine.Amount);
                VFPaymentRec.MODIFY;
              END ELSE BEGIN
                VFPaymentRec.RESET;
                VFPaymentRec.SETRANGE("Loan No.",GenJnlLine."VF Loan File No.");
                VFPaymentRec.SETRANGE("Installment No.",GenJnlLine."VF Installment No.");
                IF VFPaymentRec.FINDLAST THEN
                  LineNo := VFPaymentRec."Line No." + 10000
                ELSE
                  LineNo := 10000;
        
                VFPaymentRec.RESET;
                VFPaymentRec.INIT;
                VFPaymentRec."Loan No." := GenJnlLine."VF Loan File No.";
                VFPaymentRec."Installment No." := GenJnlLine."VF Installment No.";
                VFPaymentRec."Line No." := LineNo + 10000;
        
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Principal THEN
                  VFPaymentRec."Principal Paid" := ABS(GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Interest THEN
                  VFPaymentRec."Interest Paid" := ABS(GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Penalty THEN
                  VFPaymentRec."Penalty Paid" := ABS(GenJnlLine.Amount);
        
                //update delay days and duration from previous payment
                VFRec.GET(GenJnlLine."VF Loan File No.");
                IF NOT PenaltyUpdated THEN BEGIN
                  VFPaymentRec."Delay by No. of Days" := VFRec."Temp Delay Days";
                  VFPaymentRec."Duration of days fr Prev. Mnth" := VFRec."No of Due Days";
                  VFPaymentRec."Calculated Penalty" := VFRec."Temp Penalty";
                  PenaltyUpdated := TRUE;
                END;
                VFPaymentRec."VF Posting Description" := GenJnlLine.Narration;
                VFPaymentRec."Payment Description" := GenJnlLine.Description;
                VFPaymentRec."Payment Date" :=   GenJnlLine."Document Date";
                VFPaymentRec."G/L Posting Date" := GenJnlLine."Posting Date";
                VFPaymentRec."G/L Receipt No." := GenJnlLine."Document No.";
                VFPaymentRec."Posting Type" := GenJnlLine."VF Posting Type";
                VFPaymentRec."User ID" := USERID;
                VFPaymentRec."VF Receipt No." := GenJnlLine."External Document No.";
                VFPaymentRec."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                VFPaymentRec."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                VFPaymentRec."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                VFPaymentRec.INSERT;
          END;
          */
        //update last receipt date and line clear fields
        VFline.RESET;
        VFline.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
        VFline.SETRANGE("Line Cleared", FALSE);
        IF VFline.FINDFIRST THEN BEGIN
            REPEAT
                VFline.CALCFIELDS("Principal Paid", "Total Principal Paid", "Last Payment Received Date");
                IF ROUND(VFline."Calculated Principal", 1, '>') <= ROUND(VFline."Principal Paid", 1, '>') THEN
                    VFline."Line Cleared" := TRUE;
                VFline."Last Payment Date" := VFline."Last Payment Received Date";
                VFline.MODIFY;
            UNTIL VFline.NEXT = 0;
        END;
        //update remaninig principal
        VFRec.GET(GenJnlLine."VF Loan File No.");
        CLEAR(PrincipalPaidTotal);
        VFline.RESET;
        VFline.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
        //VFline.SETRANGE("Line Cleared",FALSE);
        //VFline.SETFILTER("Installment No.",'%1..%2',1,VFRec."Tenure in Months");
        IF VFline.FINDFIRST THEN BEGIN
            REPEAT
                VFline2.RESET;
                VFline2.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
                VFline2.SETFILTER("Installment No.", '%1..%2', 1, VFline."Installment No.");
                IF VFline2.FINDFIRST THEN BEGIN
                    PrincipalPaidTotal := 0;
                    REPEAT
                        VFline2.CALCFIELDS("Principal Paid");
                        PrincipalPaidTotal += VFline2."Principal Paid";
                    UNTIL VFline2.NEXT = 0;
                END;
                VFline."Remaining Principal Amount" := VFRec."Loan Amount" - PrincipalPaidTotal;
                VFline.MODIFY;
            UNTIL VFline.NEXT = 0;
        END;
        //END; //Min Comment
        //  Update Vehicle finance payment line  - Installments - Surya 28Aug2012<<
        //update vehicle finance payment line - insurance and other payments >>

        /*IF ((GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Insurance) //Min comment
           OR (GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Other Charges")) AND
           (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer)  THEN BEGIN
          VFPaymentRec.RESET;
          VFPaymentRec.SETRANGE("Loan No.",GenJnlLine."VF Loan File No.");
          VFPaymentRec.SETRANGE("Installment No.",0);
          LineNo := 0;
          IF VFPaymentRec.FINDLAST THEN
            LineNo := VFPaymentRec."Line No." + 10000
          ELSE
            LineNo := 10000;
          VFPaymentRec.RESET;
          VFPaymentRec.INIT;
          VFPaymentRec."Loan No." := GenJnlLine."VF Loan File No.";
          VFPaymentRec."Installment No." := 0;
          VFPaymentRec."Line No." := LineNo + 10000;
          VFPaymentRec."Payment Date" :=   GenJnlLine."Document Date";
          VFPaymentRec."G/L Posting Date" := GenJnlLine."Posting Date";
          VFPaymentRec."G/L Receipt No." := GenJnlLine."Document No.";
          VFPaymentRec."Payment Description" := GenJnlLine.Description;
          VFPaymentRec."Posting Type" := GenJnlLine."VF Posting Type";
          VFPaymentRec."User ID - Before Posting" := GenJnlLine."Created by";
          IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Insurance THEN
            VFPaymentRec."Insurance Paid" := GenJnlLine.Amount;
          IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Other Charges" THEN
            VFPaymentRec."Other Charges Paid" := GenJnlLine.Amount;
          VFPaymentRec."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
          VFPaymentRec."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
          VFPaymentRec.INSERT;
        END;*/
        //--insurance and other payments <<
        GLEntry.INIT;
        GLEntry.CopyFromGenJnlLine(GenJnlLine);

        //VF >>
        GLEntry."VF Posting Type" := GenJnlLine."VF Posting Type";
        GLEntry."Loan File No." := GenJnlLine."VF Loan File No.";
        IF GenJnlLine."VF Loan Disburse Entry" THEN BEGIN
            VFRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            IF VFRec.FINDFIRST THEN BEGIN
                VFRec."Loan Disbursed" := TRUE;
                VFRec."Loan Released" := TRUE;
                VFRec.MODIFY;
            END;
        END;
        //VF <<


        //LC6.1.0 - Added for LC Tracking.
        GLEntry."System LC No." := GenJnlLine."Sys. LC No.";
        GLEntry."Bank LC No." := GenJnlLine."Bank LC No.";
        GLEntry."LC Amend No." := GenJnlLine."LC Amend No.";

        //agile 25 Jun 2013 LC Value Entries>>
        IF GLAcc."Link to Register Type" = GLAcc."Link to Register Type"::Insurance THEN
            UpdateLCValueEntries(GenJnlLine."Sys. LC No.", 0, GenJnlLine."Amount (LCY)", GenJnlLine."Document No.")
        ELSE
            IF GLAcc."Link to Register Type" = GLAcc."Link to Register Type"::"Letter of Credit" THEN
                UpdateLCValueEntries(GenJnlLine."Sys. LC No.", 1, GenJnlLine."Amount (LCY)", GenJnlLine."Document No.");
        //agile 25 Jun 2013 LC Value Entries<<

        /*
        //SM 14-06-2013 TDS Entries
        IF GLAcc."Link to Register Type" = GLAcc."Link to Register Type"::TDS THEN BEGIN
           //IF GenJnlLine."Source Code" <>'' THEN
           PurchasesPayableSetup.GET;                                                              //chandra 12 Jan 2015
           IF GenJnlLine."Source Code" <> PurchasesPayableSetup."TDS Posting Source Code" THEN     //chandra 12 Jan 2015
              UpdateTDSEntries(GenJnlLine."Document No.",GenJnlLine."Amount (LCY)",GenJnlLine."Account No.",
                              GenJnlLine."Shortcut Dimension 1 Code",GenJnlLine."Shortcut Dimension 2 Code"
                              ,GenJnlLine."External Document No.",GenJnlLine."Posting Date",GenJnlLine."Document Subclass");
        END;
        //SM 14-06-2013 TDS Entries
        */
        //***SM 20-05-2014 to insert negative lines in posted salary plan
        IF GenJnlLine."Salary Error Line No." <> 0 THEN BEGIN
            PayRevMgt.InsertNegativeLines(GenJnlLine);
        END;
        //***SM 20-05-2014 to insert negative lines in posted salary plan

        ///8.24.2012
        GLEntry."VIN - COGS" := GenJnlLine."VIN - COGS";

        GLEntry."Entry No." := NextEntryNo;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry."G/L Account No." := GLAccNo;
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry.Amount := Amount;

        //EDMS1.0.00 >>
        GLEntry."Vehicle Serial No." := GenJnlLine."Vehicle Serial No.";
        GLEntry."Vehicle Accounting Cycle No." := GenJnlLine."Vehicle Accounting Cycle No.";
        //EDMS1.0.00 <<

        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(Amount, AmountAddCurr, GLEntry."Additional-Currency Amount", UseAmountAddCurr, GenJnlLine);

        // TO insert File Ledger Entries for Journals - CNY.RK >>

        FileLedgerEntry.RESET;
        FileLedgerEntry.SETRANGE(Inventory, GLEntry."Document No.");
        IF FileLedgerEntry.ISEMPTY THEN BEGIN
            FileDetails.RESET;
            FileDetails.SETRANGE("Resp Center / Jou Temp", GenJnlLine."Journal Template Name");
            FileDetails.SETRANGE(Close, FALSE);
            IF FileDetails.FINDFIRST THEN BEGIN

                FileLedgerEntry.RESET;
                IF FileLedgerEntry.FINDLAST THEN
                    EntryNo := FileLedgerEntry."Entry No."
                ELSE
                    EntryNo := 0;

                IF GenJnlLine."Source Code" = 'CASHRECJNL' THEN
                    DocumentType := 10
                ELSE
                    IF (GenJnlLine."Source Code" = 'GENJNL') AND (GenJnlLine."Recurring Method" = 0) THEN
                        DocumentType := 9
                    ELSE
                        IF (GenJnlLine."Source Code" = 'GENJNL') AND (GenJnlLine."Recurring Method" <> 0) THEN
                            DocumentType := 12
                        ELSE
                            IF GenJnlLine."Source Code" = 'PAYMENTJNL' THEN
                                DocumentType := 11
                            ELSE
                                DocumentType := 0;

                FileLedgerEntry.INIT;
                FileLedgerEntry."Entry No." := EntryNo + 1;
                FileLedgerEntry."QR Code Text" := GLEntry."Posting Date";
                FileLedgerEntry."Item Description" := FileDetails."Line No.";
                FileLedgerEntry.Inventory := GLEntry."Document No.";
                //FileLedgerEntry."Location Code" := "Location Code";
                FileLedgerEntry."File No." := FileDetails."File No.";
                FileLedgerEntry."User ID" := USERID;
                FileLedgerEntry."Entry Type" := FileLedgerEntry."Entry Type"::"0";
                FileLedgerEntry.Open := TRUE;
                FileLedgerEntry."Lot No." := GenJnlLine."Journal Template Name";
                FileLedgerEntry."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                FileLedgerEntry."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                FileLedgerEntry.INSERT;
            END;
        END;

        // TO insert File Ledger Entries for Journals - CNY.RK <<
        IF GLAcc."Link to Register Type" = GLAcc."Link to Register Type"::Advance THEN
            InsertAdvLoanRegister(0, GLEntry)
        ELSE
            IF GLAcc."Link to Register Type" = GLAcc."Link to Register Type"::Loan THEN
                InsertAdvLoanRegister(1, GLEntry);
        OnProcessInitGLEntry(GLEntry, GenJnlLine); //Added Min

    end;

    local procedure InitGLEntryVAT(GenJnlLine: Record "81"; AccNo: Code[20]; BalAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmtAddCurr: Boolean)
    var
        GLEntry: Record "17";
    begin
        IF UseAmtAddCurr THEN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE)
        ELSE BEGIN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
            GLEntry."Additional-Currency Amount" := AmountAddCurr;
            GLEntry."Bal. Account No." := BalAccNo;
        END;
        SummarizeVAT(GLSetup."Summarize G/L Entries", GLEntry);
    end;

    local procedure InitGLEntryVATCopy(GenJnlLine: Record "81"; AccNo: Code[20]; BalAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATEntry: Record "254")
    var
        GLEntry: Record "17";
    begin
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."Bal. Account No." := BalAccNo;
        GLEntry.CopyPostingGroupsFromVATEntry(VATEntry);
        SummarizeVAT(GLSetup."Summarize G/L Entries", GLEntry);
    end;

    [Scope('Internal')]
    procedure InsertGLEntry(GenJnlLine: Record "81"; GLEntry: Record "17"; CalcAddCurrResiduals: Boolean)
    begin
        GLEntry.TESTFIELD("G/L Account No.");

        IF GLEntry.Amount <> ROUND(GLEntry.Amount) THEN
            GLEntry.FIELDERROR(
              Amount,
              STRSUBSTNO(NeedsRoundingErr, GLEntry.Amount));

        UpdateCheckAmounts(
          GLEntry."Posting Date", GLEntry.Amount, GLEntry."Additional-Currency Amount",
          BalanceCheckAmount, BalanceCheckAmount2, BalanceCheckAddCurrAmount, BalanceCheckAddCurrAmount2);

        GLEntry.UpdateDebitCredit(GenJnlLine.Correction);

        TempGLEntryBuf := GLEntry;

        OnBeforeInsertGLEntryBuffer(TempGLEntryBuf, GenJnlLine);

        TempGLEntryBuf.INSERT;

        IF FirstEntryNo = 0 THEN
            FirstEntryNo := TempGLEntryBuf."Entry No.";
        NextEntryNo := NextEntryNo + 1;

        IF CalcAddCurrResiduals THEN
            HandleAddCurrResidualGLEntry(GenJnlLine, GLEntry.Amount, GLEntry."Additional-Currency Amount");
    end;

    local procedure CreateGLEntry(GenJnlLine: Record "81"; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean)
    var
        GLEntry: Record "17";
    begin
        IF UseAmountAddCurr THEN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE)
        ELSE BEGIN
            InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
            GLEntry."Additional-Currency Amount" := AmountAddCurr;
        END;
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    end;

    local procedure CreateGLEntryBalAcc(GenJnlLine: Record "81"; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; BalAccType: Option; BalAccNo: Code[20])
    var
        GLEntry: Record "17";
    begin
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE);
        GLEntry."Bal. Account Type" := BalAccType;
        GLEntry."Bal. Account No." := BalAccNo;
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        GenJnlLine.OnMoveGenJournalLine(GLEntry.RECORDID);
    end;

    local procedure CreateGLEntryGainLoss(GenJnlLine: Record "81"; AccNo: Code[20]; Amount: Decimal; UseAmountAddCurr: Boolean)
    var
        GLEntry: Record "17";
    begin
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, UseAmountAddCurr, TRUE);
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    end;

    local procedure CreateGLEntryVAT(GenJnlLine: Record "81"; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATAmount: Decimal; DtldCVLedgEntryBuf: Record "383")
    var
        GLEntry: Record "17";
    begin
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."VAT Amount" := VATAmount;
        GLEntry.CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf, DtldCVLedgEntryBuf."Gen. Posting Type");
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        InsertVATEntriesFromTemp(DtldCVLedgEntryBuf, GLEntry);
    end;

    local procedure CreateGLEntryVATCollectAdj(GenJnlLine: Record "81"; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATAmount: Decimal; DtldCVLedgEntryBuf: Record "383"; var AdjAmount: array[4] of Decimal)
    var
        GLEntry: Record "17";
    begin
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, 0, FALSE, TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."VAT Amount" := VATAmount;
        GLEntry.CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf, DtldCVLedgEntryBuf."Gen. Posting Type");
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
        CollectAdjustment(AdjAmount, GLEntry.Amount, GLEntry."Additional-Currency Amount");
        InsertVATEntriesFromTemp(DtldCVLedgEntryBuf, GLEntry);
    end;

    local procedure CreateGLEntryFromVATEntry(GenJnlLine: Record "81"; VATAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATEntry: Record "254")
    var
        GLEntry: Record "17";
    begin
        InitGLEntry(GenJnlLine, GLEntry, VATAccNo, Amount, 0, FALSE, TRUE);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry.CopyPostingGroupsFromVATEntry(VATEntry);
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    end;

    local procedure CreateDeferralScheduleFromGL(var GenJournalLine: Record "81"; IsBalancing: Boolean)
    begin
        IF (GenJournalLine."Account No." <> '') AND (GenJournalLine."Deferral Code" <> '') THEN
            IF ((GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor]) AND (GenJournalLine."Source Code" = GLSourceCode)) OR
               (GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::"Bank Account"])
            THEN BEGIN
                IF NOT IsBalancing THEN
                    CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJournalLine);
                DeferralUtilities.CreateScheduleFromGL(GenJournalLine, FirstEntryNo);
            END;
    end;

    local procedure UpdateCheckAmounts(PostingDate: Date; Amount: Decimal; AddCurrAmount: Decimal; var BalanceCheckAmount: Decimal; var BalanceCheckAmount2: Decimal; var BalanceCheckAddCurrAmount: Decimal; var BalanceCheckAddCurrAmount2: Decimal)
    begin
        IF PostingDate = NORMALDATE(PostingDate) THEN BEGIN
            BalanceCheckAmount :=
              BalanceCheckAmount + Amount * ((PostingDate - 01010000D) MOD 99 + 1);
            BalanceCheckAmount2 :=
              BalanceCheckAmount2 + Amount * ((PostingDate - 01010000D) MOD 98 + 1);
        END ELSE BEGIN
            BalanceCheckAmount :=
              BalanceCheckAmount + Amount * ((NORMALDATE(PostingDate) - 01010000D + 50) MOD 99 + 1);
            BalanceCheckAmount2 :=
              BalanceCheckAmount2 + Amount * ((NORMALDATE(PostingDate) - 01010000D + 50) MOD 98 + 1);
        END;

        IF AddCurrencyCode <> '' THEN
            IF PostingDate = NORMALDATE(PostingDate) THEN BEGIN
                BalanceCheckAddCurrAmount :=
                  BalanceCheckAddCurrAmount + AddCurrAmount * ((PostingDate - 01010000D) MOD 99 + 1);
                BalanceCheckAddCurrAmount2 :=
                  BalanceCheckAddCurrAmount2 + AddCurrAmount * ((PostingDate - 01010000D) MOD 98 + 1);
            END ELSE BEGIN
                BalanceCheckAddCurrAmount :=
                  BalanceCheckAddCurrAmount +
                  AddCurrAmount * ((NORMALDATE(PostingDate) - 01010000D + 50) MOD 99 + 1);
                BalanceCheckAddCurrAmount2 :=
                  BalanceCheckAddCurrAmount2 +
                  AddCurrAmount * ((NORMALDATE(PostingDate) - 01010000D + 50) MOD 98 + 1);
            END
        ELSE BEGIN
            BalanceCheckAddCurrAmount := 0;
            BalanceCheckAddCurrAmount2 := 0;
        END;
    end;

    local procedure CalcPmtDiscPossible(GenJnlLine: Record "81"; var CVLedgEntryBuf: Record "382")
    begin
        IF GenJnlLine."Amount (LCY)" <> 0 THEN BEGIN
            IF (CVLedgEntryBuf."Pmt. Discount Date" >= CVLedgEntryBuf."Posting Date") OR
               (CVLedgEntryBuf."Pmt. Discount Date" = 0D)
            THEN BEGIN
                IF GLSetup."Pmt. Disc. Excl. VAT" THEN BEGIN
                    IF GenJnlLine."Sales/Purch. (LCY)" = 0 THEN
                        CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
                          (GenJnlLine."Amount (LCY)" + TotalVATAmountOnJnlLines(GenJnlLine)) * GenJnlLine.Amount / GenJnlLine."Amount (LCY)"
                    ELSE
                        CVLedgEntryBuf."Original Pmt. Disc. Possible" := GenJnlLine."Sales/Purch. (LCY)" * GenJnlLine.Amount / GenJnlLine."Amount (LCY)"
                END ELSE
                    CVLedgEntryBuf."Original Pmt. Disc. Possible" := GenJnlLine.Amount;
                CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
                  ROUND(
                    CVLedgEntryBuf."Original Pmt. Disc. Possible" * GenJnlLine."Payment Discount %" / 100, AmountRoundingPrecision);
            END;
            CVLedgEntryBuf."Remaining Pmt. Disc. Possible" := CVLedgEntryBuf."Original Pmt. Disc. Possible";
        END;
    end;

    local procedure CalcPmtTolerancePossible(GenJnlLine: Record "81"; PmtDiscountDate: Date; var PmtDiscToleranceDate: Date; var MaxPaymentTolerance: Decimal)
    begin
        IF GenJnlLine."Document Type" IN [GenJnlLine."Document Type"::Invoice, GenJnlLine."Document Type"::"Credit Memo"] THEN BEGIN
            IF PmtDiscountDate <> 0D THEN
                PmtDiscToleranceDate :=
                  CALCDATE(GLSetup."Payment Discount Grace Period", PmtDiscountDate)
            ELSE
                PmtDiscToleranceDate := PmtDiscountDate;

            CASE GenJnlLine."Account Type" OF
                GenJnlLine."Account Type"::Customer:
                    PaymentToleranceMgt.CalcMaxPmtTolerance(
                      GenJnlLine."Document Type", GenJnlLine."Currency Code", GenJnlLine.Amount, GenJnlLine."Amount (LCY)", 1, MaxPaymentTolerance);
                GenJnlLine."Account Type"::Vendor:
                    PaymentToleranceMgt.CalcMaxPmtTolerance(
                      GenJnlLine."Document Type", GenJnlLine."Currency Code", GenJnlLine.Amount, GenJnlLine."Amount (LCY)", -1, MaxPaymentTolerance);
            END;
        END;
    end;

    local procedure CalcPmtTolerance(var NewCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf2: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81"; var PmtTolAmtToBeApplied: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer)
    var
        PmtTol: Decimal;
        PmtTolLCY: Decimal;
        PmtTolAddCurr: Decimal;
    begin
        IF OldCVLedgEntryBuf2."Accepted Payment Tolerance" = 0 THEN
            EXIT;

        PmtTol := -OldCVLedgEntryBuf2."Accepted Payment Tolerance";
        PmtTolAmtToBeApplied := PmtTolAmtToBeApplied + PmtTol;
        PmtTolLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtTol) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OldCVLedgEntryBuf."Accepted Payment Tolerance" := 0;
        OldCVLedgEntryBuf."Pmt. Tolerance (LCY)" := -PmtTolLCY;

        IF NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode THEN
            PmtTolAddCurr := PmtTol
        ELSE
            PmtTolAddCurr := CalcLCYToAddCurr(PmtTolLCY);

        IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND (PmtTolLCY <> 0) THEN
            CalcPmtDiscIfAdjVAT(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtTolLCY, PmtTolAddCurr,
              NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)");

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance", PmtTol, PmtTolLCY, PmtTolAddCurr, 0, 0, 0);
    end;

    local procedure CalcPmtDisc(var NewCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf2: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81"; PmtTolAmtToBeApplied: Decimal; ApplnRoundingPrecision: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer)
    var
        PmtDisc: Decimal;
        PmtDiscLCY: Decimal;
        PmtDiscAddCurr: Decimal;
        MinimalPossibleLiability: Decimal;
        PaymentExceedsLiability: Boolean;
        ToleratedPaymentExceedsLiability: Boolean;
    begin
        MinimalPossibleLiability := ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible");
        PaymentExceedsLiability := ABS(OldCVLedgEntryBuf2."Amount to Apply") >= MinimalPossibleLiability;
        ToleratedPaymentExceedsLiability := ABS(NewCVLedgEntryBuf."Remaining Amount" + PmtTolAmtToBeApplied) >= MinimalPossibleLiability;

        IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, TRUE, TRUE) AND
            ((OldCVLedgEntryBuf2."Amount to Apply" = 0) OR PaymentExceedsLiability) OR
            (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
             (OldCVLedgEntryBuf2."Amount to Apply" <> 0) AND PaymentExceedsLiability AND ToleratedPaymentExceedsLiability))
        THEN BEGIN
            PmtDisc := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
            PmtDiscLCY :=
              ROUND(
                (NewCVLedgEntryBuf."Original Amount" + PmtDisc) / NewCVLedgEntryBuf."Original Currency Factor") -
              NewCVLedgEntryBuf."Original Amt. (LCY)";

            OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscLCY;

            IF (NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode) AND (AddCurrencyCode <> '') THEN
                PmtDiscAddCurr := PmtDisc
            ELSE
                PmtDiscAddCurr := CalcLCYToAddCurr(PmtDiscLCY);

            IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND
               (PmtDiscLCY <> 0)
            THEN
                CalcPmtDiscIfAdjVAT(
                  NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtDiscLCY, PmtDiscAddCurr,
                  NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)");

            DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
              GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
              DtldCVLedgEntryBuf."Entry Type"::"Payment Discount", PmtDisc, PmtDiscLCY, PmtDiscAddCurr, 0, 0, 0);
        END;
    end;

    local procedure CalcPmtDiscIfAdjVAT(var NewCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81"; var PmtDiscLCY2: Decimal; var PmtDiscAddCurr2: Decimal; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer; EntryType: Integer)
    var
        VATEntry2: Record "254";
        VATPostingSetup: Record "325";
        TaxJurisdiction: Record "320";
        DtldCVLedgEntryBuf2: Record "383";
        OriginalAmountAddCurr: Decimal;
        PmtDiscRounding: Decimal;
        PmtDiscRoundingAddCurr: Decimal;
        PmtDiscFactorLCY: Decimal;
        PmtDiscFactorAddCurr: Decimal;
        VATBase: Decimal;
        VATBaseAddCurr: Decimal;
        VATAmount: Decimal;
        VATAmountAddCurr: Decimal;
        TotalVATAmount: Decimal;
        LastConnectionNo: Integer;
        VATEntryModifier: Integer;
    begin
        IF OldCVLedgEntryBuf."Original Amt. (LCY)" = 0 THEN
            EXIT;

        IF (AddCurrencyCode = '') OR (AddCurrencyCode = OldCVLedgEntryBuf."Currency Code") THEN
            OriginalAmountAddCurr := OldCVLedgEntryBuf.Amount
        ELSE
            OriginalAmountAddCurr := CalcLCYToAddCurr(OldCVLedgEntryBuf."Original Amt. (LCY)");

        PmtDiscRounding := PmtDiscLCY2;
        PmtDiscFactorLCY := PmtDiscLCY2 / OldCVLedgEntryBuf."Original Amt. (LCY)";
        IF OriginalAmountAddCurr <> 0 THEN
            PmtDiscFactorAddCurr := PmtDiscAddCurr2 / OriginalAmountAddCurr
        ELSE
            PmtDiscFactorAddCurr := 0;
        VATEntry2.RESET;
        VATEntry2.SETCURRENTKEY("Transaction No.");
        VATEntry2.SETRANGE("Transaction No.", OldCVLedgEntryBuf."Transaction No.");
        IF OldCVLedgEntryBuf."Transaction No." = NextTransactionNo THEN
            VATEntry2.SETRANGE("Entry No.", 0, FirstNewVATEntryNo - 1);
        IF VATEntry2.FINDSET THEN BEGIN
            TotalVATAmount := 0;
            LastConnectionNo := 0;
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF VATEntry2."VAT Calculation Type" =
                   VATEntry2."VAT Calculation Type"::"Sales Tax"
                THEN BEGIN
                    TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                    VATPostingSetup."Adjust for Payment Discount" :=
                      TaxJurisdiction."Adjust for Payment Discount";
                END;
                IF VATPostingSetup."Adjust for Payment Discount" THEN BEGIN
                    IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
                        IF LastConnectionNo <> 0 THEN BEGIN
                            DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
                            DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, FALSE);
                            InsertSummarizedVAT(GenJnlLine);
                        END;

                        CalcPmtDiscVATBases(VATEntry2, VATBase, VATBaseAddCurr);

                        PmtDiscRounding := PmtDiscRounding + VATBase * PmtDiscFactorLCY;
                        VATBase := ROUND(PmtDiscRounding - PmtDiscLCY2);
                        PmtDiscLCY2 := PmtDiscLCY2 + VATBase;

                        PmtDiscRoundingAddCurr := PmtDiscRoundingAddCurr + VATBaseAddCurr * PmtDiscFactorAddCurr;
                        VATBaseAddCurr := ROUND(CalcLCYToAddCurr(VATBase), AddCurrency."Amount Rounding Precision");
                        PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATBaseAddCurr;

                        DtldCVLedgEntryBuf2.INIT;
                        DtldCVLedgEntryBuf2."Posting Date" := GenJnlLine."Posting Date";
                        DtldCVLedgEntryBuf2."Document Type" := GenJnlLine."Document Type";
                        DtldCVLedgEntryBuf2."Document No." := GenJnlLine."Document No.";
                        DtldCVLedgEntryBuf2.Amount := 0;
                        DtldCVLedgEntryBuf2."Amount (LCY)" := -VATBase;
                        DtldCVLedgEntryBuf2."Entry Type" := EntryType;
                        CASE EntryType OF
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                                VATEntryModifier := 0;
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                                VATEntryModifier := 1000000;
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                                VATEntryModifier := 2000000;
                        END;
                        DtldCVLedgEntryBuf2.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
                        // The total payment discount in currency is posted on the entry made in
                        // the function CalcPmtDisc.
                        DtldCVLedgEntryBuf2."User ID" := USERID;
                        DtldCVLedgEntryBuf2."Model Code" := GenJnlLine."Model Code";
                        DtldCVLedgEntryBuf2."Additional-Currency Amount" := -VATBaseAddCurr;
                        DtldCVLedgEntryBuf2.CopyPostingGroupsFromVATEntry(VATEntry2);
                        TotalVATAmount := 0;
                        LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                    END;

                    CalcPmtDiscVATAmounts(
                      VATEntry2, VATBase, VATBaseAddCurr, VATAmount, VATAmountAddCurr,
                      PmtDiscRounding, PmtDiscFactorLCY, PmtDiscLCY2, PmtDiscAddCurr2);

                    TotalVATAmount := TotalVATAmount + VATAmount;

                    IF (PmtDiscAddCurr2 <> 0) AND (PmtDiscLCY2 = 0) THEN BEGIN
                        VATAmountAddCurr := VATAmountAddCurr - PmtDiscAddCurr2;
                        PmtDiscAddCurr2 := 0;
                    END;

                    // Post VAT
                    // VAT for VAT entry
                    IF VATEntry2.Type <> 0 THEN
                        InsertPmtDiscVATForVATEntry(
                          GenJnlLine, TempVATEntry, VATEntry2, VATEntryModifier,
                          VATAmount, VATAmountAddCurr, VATBase, VATBaseAddCurr,
                          PmtDiscFactorLCY, PmtDiscFactorAddCurr);

                    // VAT for G/L entry/entries
                    InsertPmtDiscVATForGLEntry(
                      GenJnlLine, DtldCVLedgEntryBuf, NewCVLedgEntryBuf, VATEntry2,
                      VATPostingSetup, TaxJurisdiction, EntryType, VATAmount, VATAmountAddCurr);
                END;
            UNTIL VATEntry2.NEXT = 0;

            IF LastConnectionNo <> 0 THEN BEGIN
                DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
                DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
                DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                InsertSummarizedVAT(GenJnlLine);
            END;
        END;
    end;

    local procedure CalcPmtDiscTolerance(var NewCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf2: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81"; NextTransactionNo: Integer; FirstNewVATEntryNo: Integer)
    var
        PmtDiscTol: Decimal;
        PmtDiscTolLCY: Decimal;
        PmtDiscTolAddCurr: Decimal;
    begin
        IF NOT OldCVLedgEntryBuf2."Accepted Pmt. Disc. Tolerance" THEN
            EXIT;

        PmtDiscTol := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
        PmtDiscTolLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtDiscTol) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscTolLCY;

        IF NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode THEN
            PmtDiscTolAddCurr := PmtDiscTol
        ELSE
            PmtDiscTolAddCurr := CalcLCYToAddCurr(PmtDiscTolLCY);

        IF NOT GLSetup."Pmt. Disc. Excl. VAT" AND GLSetup."Adjust for Payment Disc." AND (PmtDiscTolLCY <> 0) THEN
            CalcPmtDiscIfAdjVAT(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine, PmtDiscTolLCY, PmtDiscTolAddCurr,
              NextTransactionNo, FirstNewVATEntryNo, DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)");

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance", PmtDiscTol, PmtDiscTolLCY, PmtDiscTolAddCurr, 0, 0, 0);
    end;

    local procedure CalcPmtDiscVATBases(VATEntry2: Record "254"; var VATBase: Decimal; var VATBaseAddCurr: Decimal)
    var
        VATEntry: Record "254";
    begin
        CASE VATEntry2."VAT Calculation Type" OF
            VATEntry2."VAT Calculation Type"::"Normal VAT",
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
            VATEntry2."VAT Calculation Type"::"Full VAT":
                BEGIN
                    VATBase :=
                      VATEntry2.Base + VATEntry2."Unrealized Base";
                    VATBaseAddCurr :=
                      VATEntry2."Additional-Currency Base" +
                      VATEntry2."Add.-Currency Unrealized Base";
                END;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
                BEGIN
                    VATEntry.RESET;
                    VATEntry.SETCURRENTKEY("Transaction No.");
                    VATEntry.SETRANGE("Transaction No.", VATEntry2."Transaction No.");
                    VATEntry.SETRANGE("Sales Tax Connection No.", VATEntry2."Sales Tax Connection No.");
                    VATEntry := VATEntry2;
                    REPEAT
                        IF VATEntry.Base < 0 THEN
                            VATEntry.SETFILTER(Base, '>%1', VATEntry.Base)
                        ELSE
                            VATEntry.SETFILTER(Base, '<%1', VATEntry.Base);
                    UNTIL NOT VATEntry.FINDLAST;
                    VATEntry.RESET;
                    VATBase :=
                      VATEntry.Base + VATEntry."Unrealized Base";
                    VATBaseAddCurr :=
                      VATEntry."Additional-Currency Base" +
                      VATEntry."Add.-Currency Unrealized Base";
                END;
        END;
    end;

    local procedure CalcPmtDiscVATAmounts(VATEntry2: Record "254"; VATBase: Decimal; VATBaseAddCurr: Decimal; var VATAmount: Decimal; var VATAmountAddCurr: Decimal; var PmtDiscRounding: Decimal; PmtDiscFactorLCY: Decimal; var PmtDiscLCY2: Decimal; var PmtDiscAddCurr2: Decimal)
    begin
        CASE VATEntry2."VAT Calculation Type" OF
            VATEntry2."VAT Calculation Type"::"Normal VAT",
          VATEntry2."VAT Calculation Type"::"Full VAT":
                IF (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) OR
                   (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
                THEN BEGIN
                    IF (VATBase = 0) AND
                       (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
                    THEN
                        VATAmount := 0
                    ELSE BEGIN
                        PmtDiscRounding :=
                          PmtDiscRounding +
                          (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                        VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                        PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                    END;
                    IF (VATBaseAddCurr = 0) AND
                       (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
                    THEN
                        VATAmountAddCurr := 0
                    ELSE BEGIN
                        VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                        PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                    END;
                END ELSE BEGIN
                    VATAmount := 0;
                    VATAmountAddCurr := 0;
                END;
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                    VATAmount :=
                      ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
                    VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                END;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
                IF (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax" THEN BEGIN
                    VATAmount :=
                      ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
                    VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                END ELSE
                    IF (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) OR
                       (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
                    THEN BEGIN
                        IF VATBase = 0 THEN
                            VATAmount := 0
                        ELSE BEGIN
                            PmtDiscRounding :=
                              PmtDiscRounding +
                              (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                            VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                            PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                        END;

                        IF VATBaseAddCurr = 0 THEN
                            VATAmountAddCurr := 0
                        ELSE BEGIN
                            VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                            PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                        END;
                    END ELSE BEGIN
                        VATAmount := 0;
                        VATAmountAddCurr := 0;
                    END;
        END;
    end;

    local procedure InsertPmtDiscVATForVATEntry(GenJnlLine: Record "81"; var TempVATEntry: Record "254" temporary; VATEntry2: Record "254"; VATEntryModifier: Integer; VATAmount: Decimal; VATAmountAddCurr: Decimal; VATBase: Decimal; VATBaseAddCurr: Decimal; PmtDiscFactorLCY: Decimal; PmtDiscFactorAddCurr: Decimal)
    var
        TempVATEntryNo: Integer;
    begin
        TempVATEntry.RESET;
        TempVATEntry.SETRANGE("Entry No.", VATEntryModifier, VATEntryModifier + 999999);
        IF TempVATEntry.FINDLAST THEN
            TempVATEntryNo := TempVATEntry."Entry No." + 1
        ELSE
            TempVATEntryNo := VATEntryModifier + 1;
        TempVATEntry := VATEntry2;
        TempVATEntry."Entry No." := TempVATEntryNo;
        TempVATEntry."Posting Date" := GenJnlLine."Posting Date";
        TempVATEntry."Document No." := GenJnlLine."Document No.";
        TempVATEntry."External Document No." := GenJnlLine."External Document No.";
        TempVATEntry."Document Type" := GenJnlLine."Document Type";
        TempVATEntry."Source Code" := GenJnlLine."Source Code";
        TempVATEntry."Reason Code" := GenJnlLine."Reason Code";
        TempVATEntry."Transaction No." := NextTransactionNo;
        TempVATEntry."Sales Tax Connection No." := NextConnectionNo;
        TempVATEntry."Unrealized Amount" := 0;
        TempVATEntry."Unrealized Base" := 0;
        TempVATEntry."Remaining Unrealized Amount" := 0;
        TempVATEntry."Remaining Unrealized Base" := 0;
        TempVATEntry."User ID" := USERID;
        TempVATEntry."Closed by Entry No." := 0;
        TempVATEntry.Closed := FALSE;
        TempVATEntry."Internal Ref. No." := '';
        TempVATEntry.Amount := VATAmount;
        TempVATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        TempVATEntry."VAT Difference" := 0;
        TempVATEntry."Add.-Curr. VAT Difference" := 0;
        TempVATEntry."Add.-Currency Unrealized Amt." := 0;
        TempVATEntry."Add.-Currency Unrealized Base" := 0;
        IF VATEntry2."Tax on Tax" THEN BEGIN
            TempVATEntry.Base :=
              ROUND((VATEntry2.Base + VATEntry2."Unrealized Base") * PmtDiscFactorLCY);
            TempVATEntry."Additional-Currency Base" :=
              ROUND(
                (VATEntry2."Additional-Currency Base" +
                 VATEntry2."Add.-Currency Unrealized Base") * PmtDiscFactorAddCurr,
                AddCurrency."Amount Rounding Precision");
        END ELSE BEGIN
            TempVATEntry.Base := VATBase;
            TempVATEntry."Additional-Currency Base" := VATBaseAddCurr;
        END;

        IF AddCurrencyCode = '' THEN BEGIN
            TempVATEntry."Additional-Currency Base" := 0;
            TempVATEntry."Additional-Currency Amount" := 0;
            TempVATEntry."Add.-Currency Unrealized Amt." := 0;
            TempVATEntry."Add.-Currency Unrealized Base" := 0;
        END;
        TempVATEntry.INSERT;
    end;

    local procedure InsertPmtDiscVATForGLEntry(GenJnlLine: Record "81"; var DtldCVLedgEntryBuf: Record "383"; var NewCVLedgEntryBuf: Record "382"; VATEntry2: Record "254"; var VATPostingSetup: Record "325"; var TaxJurisdiction: Record "320"; EntryType: Integer; VATAmount: Decimal; VATAmountAddCurr: Decimal)
    begin
        DtldCVLedgEntryBuf.INIT;
        DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
        CASE EntryType OF
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)";
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)";
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                DtldCVLedgEntryBuf."Entry Type" :=
                  DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)";
        END;
        DtldCVLedgEntryBuf."Posting Date" := GenJnlLine."Posting Date";
        DtldCVLedgEntryBuf."Document Type" := GenJnlLine."Document Type";
        DtldCVLedgEntryBuf."Document No." := GenJnlLine."Document No.";
        DtldCVLedgEntryBuf.Amount := 0;
        DtldCVLedgEntryBuf."VAT Bus. Posting Group" := VATEntry2."VAT Bus. Posting Group";
        DtldCVLedgEntryBuf."VAT Prod. Posting Group" := VATEntry2."VAT Prod. Posting Group";
        DtldCVLedgEntryBuf."Tax Jurisdiction Code" := VATEntry2."Tax Jurisdiction Code";
        // The total payment discount in currency is posted on the entry made in
        // the function CalcPmtDisc.
        DtldCVLedgEntryBuf."User ID" := USERID;
        DtldCVLedgEntryBuf."Model Code" := GenJnlLine."Model Code";
        DtldCVLedgEntryBuf."Use Additional-Currency Amount" := TRUE;

        CASE VATEntry2.Type OF
            VATEntry2.Type::Purchase:
                CASE VATEntry2."VAT Calculation Type" OF
                    VATEntry2."VAT Calculation Type"::"Normal VAT",
                    VATEntry2."VAT Calculation Type"::"Full VAT":
                        BEGIN
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                        BEGIN
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            InitGLEntryVAT(GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE), '',
                              -VATAmount, -VATAmountAddCurr, FALSE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Sales Tax":
                        IF VATEntry2."Use Tax" THEN BEGIN
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetRevChargeAccount(FALSE), '',
                              -VATAmount, -VATAmountAddCurr, FALSE);
                        END ELSE BEGIN
                            InitGLEntryVAT(GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                END;
            VATEntry2.Type::Sale:
                CASE VATEntry2."VAT Calculation Type" OF
                    VATEntry2."VAT Calculation Type"::"Normal VAT",
                    VATEntry2."VAT Calculation Type"::"Full VAT":
                        BEGIN
                            InitGLEntryVAT(
                              GenJnlLine, VATPostingSetup.GetSalesAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                    VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                        ;
                    VATEntry2."VAT Calculation Type"::"Sales Tax":
                        BEGIN
                            InitGLEntryVAT(
                              GenJnlLine, TaxJurisdiction.GetSalesAccount(FALSE), '',
                              VATAmount, VATAmountAddCurr, FALSE);
                            DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                            DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, NewCVLedgEntryBuf, TRUE);
                        END;
                END;
        END;
    end;

    local procedure CalcCurrencyApplnRounding(var NewCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81"; ApplnRoundingPrecision: Decimal)
    var
        ApplnRounding: Decimal;
        ApplnRoundingLCY: Decimal;
    begin
        IF ((NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Payment) AND
            (NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Refund)) OR
           (NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf."Currency Code")
        THEN
            EXIT;

        ApplnRounding := -(NewCVLedgEntryBuf."Remaining Amount" + OldCVLedgEntryBuf."Remaining Amount");
        ApplnRoundingLCY := ROUND(ApplnRounding / NewCVLedgEntryBuf."Adjusted Currency Factor");

        IF (ApplnRounding = 0) OR (ABS(ApplnRounding) > ApplnRoundingPrecision) THEN
            EXIT;

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding", ApplnRounding, ApplnRoundingLCY, ApplnRounding, 0, 0, 0);
    end;

    local procedure FindAmtForAppln(var NewCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf2: Record "382"; var AppliedAmount: Decimal; var AppliedAmountLCY: Decimal; var OldAppliedAmount: Decimal; ApplnRoundingPrecision: Decimal)
    begin
        IF OldCVLedgEntryBuf2.GETFILTER(Positive) <> '' THEN BEGIN
            IF OldCVLedgEntryBuf2."Amount to Apply" <> 0 THEN BEGIN
                IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
                    (ABS(OldCVLedgEntryBuf2."Amount to Apply") >=
                     ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")))
                THEN
                    AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount"
                ELSE
                    AppliedAmount := -OldCVLedgEntryBuf2."Amount to Apply"
            END ELSE
                AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
        END ELSE BEGIN
            IF OldCVLedgEntryBuf2."Amount to Apply" <> 0 THEN
                IF (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf2, ApplnRoundingPrecision, FALSE, FALSE) AND
                    (ABS(OldCVLedgEntryBuf2."Amount to Apply") >=
                     ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")) AND
                    (ABS(NewCVLedgEntryBuf."Remaining Amount") >=
                     ABS(
                       ABSMin(
                         OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible",
                         OldCVLedgEntryBuf2."Amount to Apply")))) OR
                   OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance"
                THEN BEGIN
                    AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
                    OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance" := FALSE;
                END ELSE
                    AppliedAmount := GetAppliedAmountFromBuffers(NewCVLedgEntryBuf, OldCVLedgEntryBuf2)
            ELSE
                AppliedAmount := ABSMin(NewCVLedgEntryBuf."Remaining Amount", -OldCVLedgEntryBuf2."Remaining Amount");
        END;

        IF (ABS(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply") < ApplnRoundingPrecision) AND
           (ApplnRoundingPrecision <> 0) AND
           (OldCVLedgEntryBuf2."Amount to Apply" <> 0)
        THEN
            AppliedAmount := AppliedAmount - (OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply");

        IF NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf2."Currency Code" THEN BEGIN
            AppliedAmountLCY := ROUND(AppliedAmount / OldCVLedgEntryBuf."Original Currency Factor");
            OldAppliedAmount := AppliedAmount;
        END ELSE BEGIN
            // Management of posting in multiple currencies
            IF AppliedAmount = -OldCVLedgEntryBuf2."Remaining Amount" THEN
                OldAppliedAmount := -OldCVLedgEntryBuf."Remaining Amount"
            ELSE
                OldAppliedAmount :=
                  CurrExchRate.ExchangeAmount(
                    AppliedAmount, NewCVLedgEntryBuf."Currency Code",
                    OldCVLedgEntryBuf2."Currency Code", NewCVLedgEntryBuf."Posting Date");

            IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
                // Post the realized gain or loss on the NewCVLedgEntryBuf
                AppliedAmountLCY := ROUND(OldAppliedAmount / OldCVLedgEntryBuf."Original Currency Factor")
            ELSE
                // Post the realized gain or loss on the OldCVLedgEntryBuf
                AppliedAmountLCY := ROUND(AppliedAmount / NewCVLedgEntryBuf."Original Currency Factor");
        END;
    end;

    local procedure CalcCurrencyUnrealizedGainLoss(var CVLedgEntryBuf: Record "382"; var TempDtldCVLedgEntryBuf: Record "383" temporary; GenJnlLine: Record "81"; AppliedAmount: Decimal; RemainingAmountBeforeAppln: Decimal)
    var
        DtldCustLedgEntry: Record "379";
        DtldVendLedgEntry: Record "380";
        UnRealizedGainLossLCY: Decimal;
    begin
        IF (CVLedgEntryBuf."Currency Code" = '') OR (RemainingAmountBeforeAppln = 0) THEN
            EXIT;

        // Calculate Unrealized GainLoss
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
            UnRealizedGainLossLCY :=
              ROUND(
                DtldCustLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
                ABS(AppliedAmount / RemainingAmountBeforeAppln))
        ELSE
            UnRealizedGainLossLCY :=
              ROUND(
                DtldVendLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
                ABS(AppliedAmount / RemainingAmountBeforeAppln));

        IF UnRealizedGainLossLCY <> 0 THEN
            IF UnRealizedGainLossLCY < 0 THEN
                TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0)
            ELSE
                TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0);
    end;

    local procedure CalcCurrencyRealizedGainLoss(var CVLedgEntryBuf: Record "382"; var TempDtldCVLedgEntryBuf: Record "383" temporary; GenJnlLine: Record "81"; AppliedAmount: Decimal; AppliedAmountLCY: Decimal)
    var
        RealizedGainLossLCY: Decimal;
    begin
        IF CVLedgEntryBuf."Currency Code" = '' THEN
            EXIT;

        // Calculate Realized GainLoss
        RealizedGainLossLCY :=
          AppliedAmountLCY - ROUND(AppliedAmount / CVLedgEntryBuf."Original Currency Factor");
        IF RealizedGainLossLCY <> 0 THEN
            IF RealizedGainLossLCY < 0 THEN
                TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Realized Loss", 0, RealizedGainLossLCY, 0, 0, 0, 0)
            ELSE
                TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
                  GenJnlLine, CVLedgEntryBuf, TempDtldCVLedgEntryBuf,
                  TempDtldCVLedgEntryBuf."Entry Type"::"Realized Gain", 0, RealizedGainLossLCY, 0, 0, 0, 0);
    end;

    local procedure CalcApplication(var NewCVLedgEntryBuf: Record "382"; var OldCVLedgEntryBuf: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81"; AppliedAmount: Decimal; AppliedAmountLCY: Decimal; OldAppliedAmount: Decimal; PrevNewCVLedgEntryBuf: Record "382"; PrevOldCVLedgEntryBuf: Record "382"; var AllApplied: Boolean)
    begin
        IF AppliedAmount = 0 THEN
            EXIT;

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine, OldCVLedgEntryBuf, DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::Application, OldAppliedAmount, AppliedAmountLCY, 0,
          NewCVLedgEntryBuf."Entry No.", PrevOldCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
          PrevOldCVLedgEntryBuf."Max. Payment Tolerance");

        OldCVLedgEntryBuf.Open := OldCVLedgEntryBuf."Remaining Amount" <> 0;
        IF NOT OldCVLedgEntryBuf.Open THEN
            OldCVLedgEntryBuf.SetClosedFields(
              NewCVLedgEntryBuf."Entry No.", GenJnlLine."Posting Date",
              -OldAppliedAmount, -AppliedAmountLCY, NewCVLedgEntryBuf."Currency Code", -AppliedAmount)
        ELSE
            AllApplied := FALSE;

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine, NewCVLedgEntryBuf, DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."Entry Type"::Application, -AppliedAmount, -AppliedAmountLCY, 0,
          NewCVLedgEntryBuf."Entry No.", PrevNewCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
          PrevNewCVLedgEntryBuf."Max. Payment Tolerance");

        NewCVLedgEntryBuf.Open := NewCVLedgEntryBuf."Remaining Amount" <> 0;
        IF NOT NewCVLedgEntryBuf.Open AND NOT AllApplied THEN
            NewCVLedgEntryBuf.SetClosedFields(
              OldCVLedgEntryBuf."Entry No.", GenJnlLine."Posting Date",
              AppliedAmount, AppliedAmountLCY, OldCVLedgEntryBuf."Currency Code", OldAppliedAmount);
    end;

    local procedure CalcAmtLCYAdjustment(var CVLedgEntryBuf: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81")
    var
        AdjustedAmountLCY: Decimal;
    begin
        IF CVLedgEntryBuf."Currency Code" = '' THEN
            EXIT;

        AdjustedAmountLCY :=
          ROUND(CVLedgEntryBuf."Remaining Amount" / CVLedgEntryBuf."Adjusted Currency Factor");

        IF AdjustedAmountLCY <> CVLedgEntryBuf."Remaining Amt. (LCY)" THEN BEGIN
            DtldCVLedgEntryBuf.InitFromGenJnlLine(GenJnlLine);
            DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(CVLedgEntryBuf);
            DtldCVLedgEntryBuf."Entry Type" :=
              DtldCVLedgEntryBuf."Entry Type"::"Correction of Remaining Amount";
            DtldCVLedgEntryBuf."Amount (LCY)" := AdjustedAmountLCY - CVLedgEntryBuf."Remaining Amt. (LCY)";
            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf, CVLedgEntryBuf, FALSE);
        END;
    end;

    local procedure InitBankAccLedgEntry(GenJnlLine: Record "81"; var BankAccLedgEntry: Record "271")
    begin
        BankAccLedgEntry.INIT;
        BankAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        BankAccLedgEntry."Entry No." := NextEntryNo;
        BankAccLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure InitCheckLedgEntry(BankAccLedgEntry: Record "271"; var CheckLedgEntry: Record "272")
    begin
        CheckLedgEntry.INIT;
        CheckLedgEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
        CheckLedgEntry."Entry No." := NextCheckEntryNo;
    end;

    local procedure InitCustLedgEntry(GenJnlLine: Record "81"; var CustLedgEntry: Record "21")
    begin
        CustLedgEntry.INIT;
        CustLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        CustLedgEntry."Entry No." := NextEntryNo;
        CustLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure InitVendLedgEntry(GenJnlLine: Record "81"; var VendLedgEntry: Record "25")
    begin
        VendLedgEntry.INIT;
        VendLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        VendLedgEntry."Entry No." := NextEntryNo;
        VendLedgEntry."Transaction No." := NextTransactionNo;

        //TDS2.00
        IF GenJnlLine."TDS Amount" = 0 THEN
            VendLedgEntry."TDS Amount" := AddTDSAmount(GenJnlLine."Journal Template Name",
                                          GenJnlLine."Journal Batch Name", GenJnlLine."Document No.")
        ELSE
            VendLedgEntry."TDS Amount" := GenJnlLine."TDS Amount";
        //TDS2.00
    end;

    local procedure InsertDtldCustLedgEntry(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; var DtldCustLedgEntry: Record "379"; Offset: Integer)
    begin
        DtldCustLedgEntry.INIT;
        DtldCustLedgEntry.TRANSFERFIELDS(DtldCVLedgEntryBuf);
        DtldCustLedgEntry."Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        DtldCustLedgEntry."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        DtldCustLedgEntry."Reason Code" := GenJnlLine."Reason Code";
        DtldCustLedgEntry."Source Code" := GenJnlLine."Source Code";
        DtldCustLedgEntry."Transaction No." := NextTransactionNo;
        DtldCustLedgEntry.UpdateDebitCredit(GenJnlLine.Correction);
        DtldCustLedgEntry.INSERT(TRUE);
    end;

    local procedure InsertDtldVendLedgEntry(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; var DtldVendLedgEntry: Record "380"; Offset: Integer)
    begin
        DtldVendLedgEntry.INIT;
        DtldVendLedgEntry.TRANSFERFIELDS(DtldCVLedgEntryBuf);
        DtldVendLedgEntry."Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
        DtldVendLedgEntry."Journal Batch Name" := GenJnlLine."Journal Batch Name";
        DtldVendLedgEntry."Reason Code" := GenJnlLine."Reason Code";
        DtldVendLedgEntry."Source Code" := GenJnlLine."Source Code";
        DtldVendLedgEntry."Transaction No." := NextTransactionNo;
        DtldVendLedgEntry.UpdateDebitCredit(GenJnlLine.Correction);
        DtldVendLedgEntry.INSERT(TRUE);
    end;

    local procedure ApplyCustLedgEntry(var NewCVLedgEntryBuf: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81"; Cust: Record "18")
    var
        OldCustLedgEntry: Record "21";
        OldCVLedgEntryBuf: Record "382";
        NewCustLedgEntry: Record "21";
        NewCVLedgEntryBuf2: Record "382";
        TempOldCustLedgEntry: Record "21" temporary;
        Completed: Boolean;
        AppliedAmount: Decimal;
        NewRemainingAmtBeforeAppln: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
    begin
        IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
            EXIT;

        AllApplied := TRUE;
        IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
           NOT
           ((Cust."Application Method" = Cust."Application Method"::"Apply to Oldest") AND
            GenJnlLine."Allow Application")
        THEN
            EXIT;

        PmtTolAmtToBeApplied := 0;
        NewRemainingAmtBeforeAppln := NewCVLedgEntryBuf."Remaining Amount";
        NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

        ApplyingDate := GenJnlLine."Posting Date";

        IF NOT PrepareTempCustLedgEntry(GenJnlLine, NewCVLedgEntryBuf, TempOldCustLedgEntry, Cust, ApplyingDate) THEN
            EXIT;

        GenJnlLine."Posting Date" := ApplyingDate;
        // Apply the new entry (Payment) to the old entries (Invoices) one at a time
        REPEAT
            TempOldCustLedgEntry.CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            TempOldCustLedgEntry.COPYFILTER(Positive, OldCVLedgEntryBuf.Positive);
            OldCVLedgEntryBuf.CopyFromCustLedgEntry(TempOldCustLedgEntry);

            PostApply(
              GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, NewCVLedgEntryBuf, NewCVLedgEntryBuf2,
              Cust."Block Payment Tolerance", AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            IF NOT OldCVLedgEntryBuf.Open THEN BEGIN
                UpdateCalcInterest(OldCVLedgEntryBuf);
                UpdateCalcInterest2(OldCVLedgEntryBuf, NewCVLedgEntryBuf);
            END;

            TempOldCustLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
            OldCustLedgEntry := TempOldCustLedgEntry;
            OldCustLedgEntry."Applies-to ID" := '';
            OldCustLedgEntry."Amount to Apply" := 0;
            OldCustLedgEntry.MODIFY;

            IF GLSetup."Unrealized VAT" OR
               (GLSetup."Prepayment Unrealized VAT" AND TempOldCustLedgEntry.Prepayment)
            THEN
                IF IsNotPayment(TempOldCustLedgEntry."Document Type") THEN BEGIN
                    TempOldCustLedgEntry.RecalculateAmounts(
                      NewCVLedgEntryBuf."Currency Code", TempOldCustLedgEntry."Currency Code", NewCVLedgEntryBuf."Posting Date");
                    CustUnrealizedVAT(
                      GenJnlLine,
                      TempOldCustLedgEntry,
                      CurrExchRate.ExchangeAmount(
                        AppliedAmount, NewCVLedgEntryBuf."Currency Code",
                        TempOldCustLedgEntry."Currency Code", NewCVLedgEntryBuf."Posting Date"));
                END;

            TempOldCustLedgEntry.DELETE;

            // Find the next old entry for application of the new entry
            IF GenJnlLine."Applies-to Doc. No." <> '' THEN
                Completed := TRUE
            ELSE
                IF TempOldCustLedgEntry.GETFILTER(Positive) <> '' THEN
                    IF TempOldCustLedgEntry.NEXT = 1 THEN
                        Completed := FALSE
                    ELSE BEGIN
                        TempOldCustLedgEntry.SETRANGE(Positive);
                        TempOldCustLedgEntry.FIND('-');
                        TempOldCustLedgEntry.CALCFIELDS("Remaining Amount");
                        Completed := TempOldCustLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
                    END
                ELSE
                    IF NewCVLedgEntryBuf.Open THEN
                        Completed := TempOldCustLedgEntry.NEXT = 0
                    ELSE
                        Completed := TRUE;
        UNTIL Completed;

        DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.", "Entry Type");
        DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.", NewCVLedgEntryBuf."Entry No.");
        DtldCVLedgEntryBuf.SETRANGE(
          "Entry Type",
          DtldCVLedgEntryBuf."Entry Type"::Application);
        DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)", Amount);

        CalcCurrencyUnrealizedGainLoss(
          NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, DtldCVLedgEntryBuf.Amount, NewRemainingAmtBeforeAppln);

        CalcAmtLCYAdjustment(NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine);

        NewCVLedgEntryBuf."Applies-to ID" := '';
        NewCVLedgEntryBuf."Amount to Apply" := 0;

        IF NOT NewCVLedgEntryBuf.Open THEN
            UpdateCalcInterest(NewCVLedgEntryBuf);

        IF GLSetup."Unrealized VAT" OR
           (GLSetup."Prepayment Unrealized VAT" AND NewCVLedgEntryBuf.Prepayment)
        THEN
            IF IsNotPayment(NewCVLedgEntryBuf."Document Type") AND
               (NewRemainingAmtBeforeAppln - NewCVLedgEntryBuf."Remaining Amount" <> 0)
            THEN BEGIN
                NewCustLedgEntry.CopyFromCVLedgEntryBuffer(NewCVLedgEntryBuf);
                CheckUnrealizedCust := TRUE;
                UnrealizedCustLedgEntry := NewCustLedgEntry;
                UnrealizedCustLedgEntry.CALCFIELDS("Amount (LCY)", "Original Amt. (LCY)");
                UnrealizedRemainingAmountCust := NewCustLedgEntry."Remaining Amount" - NewRemainingAmtBeforeAppln;
            END;
    end;

    [Scope('Internal')]
    procedure CustPostApplyCustLedgEntry(var GenJnlLinePostApply: Record "81"; var CustLedgEntryPostApply: Record "21")
    var
        Cust: Record "18";
        CustPostingGr: Record "92";
        CustLedgEntry: Record "21";
        DtldCustLedgEntry: Record "379";
        TempDtldCVLedgEntryBuf: Record "383" temporary;
        CVLedgEntryBuf: Record "382";
        GenJnlLine: Record "81";
        DtldLedgEntryInserted: Boolean;
    begin
        GenJnlLine := GenJnlLinePostApply;
        CustLedgEntry.TRANSFERFIELDS(CustLedgEntryPostApply);
        GenJnlLine."Source Currency Code" := CustLedgEntryPostApply."Currency Code";
        GenJnlLine."Applies-to ID" := CustLedgEntryPostApply."Applies-to ID";

        GenJnlCheckLine.RunCheck(GenJnlLine);

        IF NextEntryNo = 0 THEN
            StartPosting(GenJnlLine)
        ELSE
            ContinuePosting(GenJnlLine);

        Cust.GET(CustLedgEntry."Customer No.");
        Cust.CheckBlockedCustOnJnls(Cust, GenJnlLine."Document Type", TRUE);

        IF GenJnlLine."Posting Group" = '' THEN BEGIN
            Cust.TESTFIELD("Customer Posting Group");
            GenJnlLine."Posting Group" := Cust."Customer Posting Group";
        END;
        CustPostingGr.GET(GenJnlLine."Posting Group");
        CustPostingGr.GetReceivablesAccount;

        DtldCustLedgEntry.LOCKTABLE;
        CustLedgEntry.LOCKTABLE;

        // Post the application
        CustLedgEntry.CALCFIELDS(
          Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
          "Original Amount", "Original Amt. (LCY)");
        CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
        ApplyCustLedgEntry(CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Cust);
        CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        CustLedgEntry.MODIFY;

        // Post the Dtld customer entry
        DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, CustPostingGr, FALSE);

        CheckPostUnrealizedVAT(GenJnlLine, TRUE);

        IF DtldLedgEntryInserted THEN
            IF IsTempGLEntryBufEmpty THEN
                DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);
        FinishPosting;
    end;

    local procedure PrepareTempCustLedgEntry(GenJnlLine: Record "81"; var NewCVLedgEntryBuf: Record "382"; var TempOldCustLedgEntry: Record "21" temporary; Cust: Record "18"; var ApplyingDate: Date): Boolean
    var
        OldCustLedgEntry: Record "21";
        SalesSetup: Record "311";
        GenJnlApply: Codeunit "225";
        RemainingAmount: Decimal;
    begin
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
            // Find the entry to be applied to
            OldCustLedgEntry.RESET;
            OldCustLedgEntry.SETCURRENTKEY("Document No.");
            OldCustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            OldCustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            OldCustLedgEntry.SETRANGE("Customer No.", NewCVLedgEntryBuf."CV No.");
            OldCustLedgEntry.SETRANGE(Open, TRUE);

            OldCustLedgEntry.FINDFIRST;
            OldCustLedgEntry.TESTFIELD(Positive, NOT NewCVLedgEntryBuf.Positive);
            IF OldCustLedgEntry."Posting Date" > ApplyingDate THEN
                ApplyingDate := OldCustLedgEntry."Posting Date";
            GenJnlApply.CheckAgainstApplnCurrency(
              NewCVLedgEntryBuf."Currency Code", OldCustLedgEntry."Currency Code", GenJnlLine."Account Type"::Customer, TRUE);
            TempOldCustLedgEntry := OldCustLedgEntry;
            TempOldCustLedgEntry.INSERT;
        END ELSE BEGIN
            // Find the first old entry (Invoice) which the new entry (Payment) should apply to
            OldCustLedgEntry.RESET;
            OldCustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
            TempOldCustLedgEntry.SETCURRENTKEY("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
            OldCustLedgEntry.SETRANGE("Customer No.", NewCVLedgEntryBuf."CV No.");
            OldCustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
            OldCustLedgEntry.SETRANGE(Open, TRUE);
            OldCustLedgEntry.SETFILTER("Entry No.", '<>%1', NewCVLedgEntryBuf."Entry No.");
            IF NOT (Cust."Application Method" = Cust."Application Method"::"Apply to Oldest") THEN
                OldCustLedgEntry.SETFILTER("Amount to Apply", '<>%1', 0);

            IF Cust."Application Method" = Cust."Application Method"::"Apply to Oldest" THEN
                OldCustLedgEntry.SETFILTER("Posting Date", '..%1', GenJnlLine."Posting Date");

            // Check Cust Ledger Entry and add to Temp.
            SalesSetup.GET;
            IF SalesSetup."Appln. between Currencies" = SalesSetup."Appln. between Currencies"::None THEN
                OldCustLedgEntry.SETRANGE("Currency Code", NewCVLedgEntryBuf."Currency Code");
            IF OldCustLedgEntry.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    IF GenJnlApply.CheckAgainstApplnCurrency(
                         NewCVLedgEntryBuf."Currency Code", OldCustLedgEntry."Currency Code", GenJnlLine."Account Type"::Customer, FALSE)
                    THEN BEGIN
                        IF (OldCustLedgEntry."Posting Date" > ApplyingDate) AND (OldCustLedgEntry."Applies-to ID" <> '') THEN
                            ApplyingDate := OldCustLedgEntry."Posting Date";
                        TempOldCustLedgEntry := OldCustLedgEntry;
                        TempOldCustLedgEntry.INSERT;
                    END;
                UNTIL OldCustLedgEntry.NEXT = 0;

            TempOldCustLedgEntry.SETRANGE(Positive, NewCVLedgEntryBuf."Remaining Amount" > 0);

            IF TempOldCustLedgEntry.FIND('-') THEN BEGIN
                RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
                TempOldCustLedgEntry.SETRANGE(Positive);
                TempOldCustLedgEntry.FIND('-');
                REPEAT
                    TempOldCustLedgEntry.CALCFIELDS("Remaining Amount");
                    TempOldCustLedgEntry.RecalculateAmounts(
                      TempOldCustLedgEntry."Currency Code", NewCVLedgEntryBuf."Currency Code", NewCVLedgEntryBuf."Posting Date");
                    IF PaymentToleranceMgt.CheckCalcPmtDiscCVCust(NewCVLedgEntryBuf, TempOldCustLedgEntry, 0, FALSE, FALSE) THEN
                        TempOldCustLedgEntry."Remaining Amount" -= TempOldCustLedgEntry."Remaining Pmt. Disc. Possible";
                    RemainingAmount += TempOldCustLedgEntry."Remaining Amount";
                UNTIL TempOldCustLedgEntry.NEXT = 0;
                TempOldCustLedgEntry.SETRANGE(Positive, RemainingAmount < 0);
            END ELSE
                TempOldCustLedgEntry.SETRANGE(Positive);

            EXIT(TempOldCustLedgEntry.FIND('-'));
        END;
        EXIT(TRUE);
    end;

    local procedure PostDtldCustLedgEntries(GenJnlLine: Record "81"; var DtldCVLedgEntryBuf: Record "383"; CustPostingGr: Record "92"; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean
    var
        TempInvPostBuf: Record "49" temporary;
        DtldCustLedgEntry: Record "379";
        AdjAmount: array[4] of Decimal;
        DtldCustLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
    begin
        IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Customer THEN
            EXIT;

        IF DtldCustLedgEntry.FINDLAST THEN
            DtldCustLedgEntryNoOffset := DtldCustLedgEntry."Entry No."
        ELSE
            DtldCustLedgEntryNoOffset := 0;

        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
            IF LedgEntryInserted THEN BEGIN
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
            END;
            REPEAT
                InsertDtldCustLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, DtldCustLedgEntry, DtldCustLedgEntryNoOffset);

                UpdateTotalAmounts(
                  TempInvPostBuf, GenJnlLine."Dimension Set ID",
                  DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount");

                // Post automatic entries.
                IF ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) OR
                    (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) OR
                   ((AddCurrencyCode <> '') AND (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
                THEN
                    PostDtldCustLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, AdjAmount);
            UNTIL DtldCVLedgEntryBuf.NEXT = 0;
        END;

        CreateGLEntriesForTotalAmounts(
          GenJnlLine, TempInvPostBuf, AdjAmount, SaveEntryNo, CustPostingGr.GetReceivablesAccount, LedgEntryInserted);

        DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
        DtldCVLedgEntryBuf.DELETEALL;
    end;

    local procedure PostDtldCustLedgEntry(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; CustPostingGr: Record "92"; var AdjAmount: array[4] of Decimal)
    var
        AccNo: Code[20];
    begin
        AccNo := GetDtldCustLedgEntryAccNo(GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, 0, FALSE);
        PostDtldCVLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, AccNo, AdjAmount, FALSE);
    end;

    local procedure PostDtldCustLedgEntryUnapply(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; CustPostingGr: Record "92"; OriginalTransactionNo: Integer)
    var
        AdjAmount: array[4] of Decimal;
        AccNo: Code[20];
    begin
        IF (DtldCVLedgEntryBuf."Amount (LCY)" = 0) AND
           (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) AND
           ((AddCurrencyCode = '') OR (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0))
        THEN
            EXIT;

        AccNo := GetDtldCustLedgEntryAccNo(GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, OriginalTransactionNo, TRUE);
        DtldCVLedgEntryBuf."Gen. Posting Type" := DtldCVLedgEntryBuf."Gen. Posting Type"::Sale;
        PostDtldCVLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, AccNo, AdjAmount, TRUE);
    end;

    local procedure GetDtldCustLedgEntryAccNo(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; CustPostingGr: Record "92"; OriginalTransactionNo: Integer; Unapply: Boolean): Code[20]
    var
        GenPostingSetup: Record "252";
        Currency: Record "4";
        AmountCondition: Boolean;
    begin
        AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf, Unapply);
        CASE DtldCVLedgEntryBuf."Entry Type" OF
            DtldCVLedgEntryBuf."Entry Type"::"Initial Entry":
                ;
            DtldCVLedgEntryBuf."Entry Type"::Application:
                ;
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss",
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain",
            DtldCVLedgEntryBuf."Entry Type"::"Realized Loss",
            DtldCVLedgEntryBuf."Entry Type"::"Realized Gain":
                BEGIN
                    GetCurrency(Currency, DtldCVLedgEntryBuf."Currency Code");
                    CheckNonAddCurrCodeOccurred(Currency.Code);
                    EXIT(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount":
                EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                BEGIN
                    DtldCVLedgEntryBuf.TESTFIELD("Gen. Prod. Posting Group");
                    GenPostingSetup.GET(DtldCVLedgEntryBuf."Gen. Bus. Posting Group", DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
                    EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding":
                EXIT(CustPostingGr.GetApplRoundingAccount(AmountCondition));
            DtldCVLedgEntryBuf."Entry Type"::"Correction of Remaining Amount":
                EXIT(CustPostingGr.GetRoundingAccount(AmountCondition));
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance":
                CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                    GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                        EXIT(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
                    GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                        EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance":
                CASE GLSetup."Payment Tolerance Posting" OF
                    GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                        EXIT(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
                    GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                        EXIT(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                BEGIN
                    DtldCVLedgEntryBuf.TESTFIELD("Gen. Prod. Posting Group");
                    GenPostingSetup.GET(DtldCVLedgEntryBuf."Gen. Bus. Posting Group", DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
                    CASE GLSetup."Payment Tolerance Posting" OF
                        GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                            EXIT(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                        GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                            EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                    END;
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                BEGIN
                    GenPostingSetup.GET(DtldCVLedgEntryBuf."Gen. Bus. Posting Group", DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
                    CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                        GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                            EXIT(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                        GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                            EXIT(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                    END;
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)",
          DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)",
          DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                IF Unapply THEN
                    PostDtldCustVATAdjustment(GenJnlLine, DtldCVLedgEntryBuf, OriginalTransactionNo);
            ELSE
                DtldCVLedgEntryBuf.FIELDERROR("Entry Type");
        END;
    end;

    local procedure CustUnrealizedVAT(GenJnlLine: Record "81"; var CustLedgEntry2: Record "21"; SettledAmount: Decimal)
    var
        VATEntry2: Record "254";
        TaxJurisdiction: Record "320";
        VATPostingSetup: Record "325";
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        PaidAmount: Decimal;
        TotalUnrealVATAmountLast: Decimal;
        TotalUnrealVATAmountFirst: Decimal;
        SalesVATAccount: Code[20];
        SalesVATUnrealAccount: Code[20];
        LastConnectionNo: Integer;
    begin
        PaidAmount := CustLedgEntry2."Amount (LCY)" - CustLedgEntry2."Remaining Amt. (LCY)";
        VATEntry2.RESET;
        VATEntry2.SETCURRENTKEY("Transaction No.");
        VATEntry2.SETRANGE("Transaction No.", CustLedgEntry2."Transaction No.");
        IF VATEntry2.FINDSET THEN
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF VATPostingSetup."Unrealized VAT Type" IN
                   [VATPostingSetup."Unrealized VAT Type"::Last, VATPostingSetup."Unrealized VAT Type"::"Last (Fully Paid)"]
                THEN
                    TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
                IF VATPostingSetup."Unrealized VAT Type" IN
                   [VATPostingSetup."Unrealized VAT Type"::First, VATPostingSetup."Unrealized VAT Type"::"First (Fully Paid)"]
                THEN
                    TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
            UNTIL VATEntry2.NEXT = 0;
        IF VATEntry2.FINDSET THEN BEGIN
            LastConnectionNo := 0;
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
                    InsertSummarizedVAT(GenJnlLine);
                    LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                END;

                VATPart :=
                  VATEntry2.GetUnrealizedVATPart(
                    ROUND(SettledAmount / CustLedgEntry2.GetOriginalCurrencyFactor),
                    PaidAmount,
                    CustLedgEntry2."Original Amt. (LCY)",
                    TotalUnrealVATAmountFirst,
                    TotalUnrealVATAmountLast);

                IF VATPart > 0 THEN BEGIN
                    CASE VATEntry2."VAT Calculation Type" OF
                        VATEntry2."VAT Calculation Type"::"Normal VAT",
                        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
                        VATEntry2."VAT Calculation Type"::"Full VAT":
                            BEGIN
                                SalesVATAccount := VATPostingSetup.GetSalesAccount(FALSE);
                                SalesVATUnrealAccount := VATPostingSetup.GetSalesAccount(TRUE);
                            END;
                        VATEntry2."VAT Calculation Type"::"Sales Tax":
                            BEGIN
                                TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                                SalesVATAccount := TaxJurisdiction.GetSalesAccount(FALSE);
                                SalesVATUnrealAccount := TaxJurisdiction.GetSalesAccount(TRUE);
                            END;
                    END;

                    IF VATPart = 1 THEN BEGIN
                        VATAmount := VATEntry2."Remaining Unrealized Amount";
                        VATBase := VATEntry2."Remaining Unrealized Base";
                        VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                        VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
                    END ELSE BEGIN
                        VATAmount := ROUND(VATEntry2."Remaining Unrealized Amount" * VATPart, GLSetup."Amount Rounding Precision");
                        VATBase := ROUND(VATEntry2."Remaining Unrealized Base" * VATPart, GLSetup."Amount Rounding Precision");
                        VATAmountAddCurr :=
                          ROUND(
                            VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                        VATBaseAddCurr :=
                          ROUND(
                            VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                    END;

                    InitGLEntryVAT(
                      GenJnlLine, SalesVATUnrealAccount, SalesVATAccount, -VATAmount, -VATAmountAddCurr, FALSE);
                    InitGLEntryVATCopy(
                      GenJnlLine, SalesVATAccount, SalesVATUnrealAccount, VATAmount, VATAmountAddCurr, VATEntry2);

                    PostUnrealVATEntry(GenJnlLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr);
                END;
            UNTIL VATEntry2.NEXT = 0;

            InsertSummarizedVAT(GenJnlLine);
        END;
    end;

    local procedure ApplyVendLedgEntry(var NewCVLedgEntryBuf: Record "382"; var DtldCVLedgEntryBuf: Record "383"; GenJnlLine: Record "81"; Vend: Record "23")
    var
        OldVendLedgEntry: Record "25";
        OldCVLedgEntryBuf: Record "382";
        NewVendLedgEntry: Record "25";
        NewCVLedgEntryBuf2: Record "382";
        TempOldVendLedgEntry: Record "25" temporary;
        Completed: Boolean;
        AppliedAmount: Decimal;
        NewRemainingAmtBeforeAppln: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
    begin
        IF NewCVLedgEntryBuf."Amount to Apply" = 0 THEN
            EXIT;

        AllApplied := TRUE;
        IF (GenJnlLine."Applies-to Doc. No." = '') AND (GenJnlLine."Applies-to ID" = '') AND
           NOT
           ((Vend."Application Method" = Vend."Application Method"::"Apply to Oldest") AND
            GenJnlLine."Allow Application")
        THEN
            EXIT;

        PmtTolAmtToBeApplied := 0;
        NewRemainingAmtBeforeAppln := NewCVLedgEntryBuf."Remaining Amount";
        NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

        ApplyingDate := GenJnlLine."Posting Date";

        IF NOT PrepareTempVendLedgEntry(GenJnlLine, NewCVLedgEntryBuf, TempOldVendLedgEntry, Vend, ApplyingDate) THEN
            EXIT;

        GenJnlLine."Posting Date" := ApplyingDate;
        // Apply the new entry (Payment) to the old entries (Invoices) one at a time
        REPEAT
            TempOldVendLedgEntry.CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            OldCVLedgEntryBuf.CopyFromVendLedgEntry(TempOldVendLedgEntry);
            TempOldVendLedgEntry.COPYFILTER(Positive, OldCVLedgEntryBuf.Positive);

            PostApply(
              GenJnlLine, DtldCVLedgEntryBuf, OldCVLedgEntryBuf, NewCVLedgEntryBuf, NewCVLedgEntryBuf2,
              Vend."Block Payment Tolerance", AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            // Update the Old Entry
            TempOldVendLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
            OldVendLedgEntry := TempOldVendLedgEntry;
            OldVendLedgEntry."Applies-to ID" := '';
            OldVendLedgEntry."Amount to Apply" := 0;
            OldVendLedgEntry.MODIFY;

            IF GLSetup."Unrealized VAT" OR
               (GLSetup."Prepayment Unrealized VAT" AND TempOldVendLedgEntry.Prepayment)
            THEN
                IF IsNotPayment(TempOldVendLedgEntry."Document Type") THEN BEGIN
                    TempOldVendLedgEntry.RecalculateAmounts(
                      NewCVLedgEntryBuf."Currency Code", TempOldVendLedgEntry."Currency Code", NewCVLedgEntryBuf."Posting Date");
                    VendUnrealizedVAT(
                      GenJnlLine,
                      TempOldVendLedgEntry,
                      CurrExchRate.ExchangeAmount(
                        AppliedAmount, NewCVLedgEntryBuf."Currency Code",
                        TempOldVendLedgEntry."Currency Code", NewCVLedgEntryBuf."Posting Date"));
                END;

            TempOldVendLedgEntry.DELETE;

            // Find the next old entry to apply to the new entry
            IF GenJnlLine."Applies-to Doc. No." <> '' THEN
                Completed := TRUE
            ELSE
                IF TempOldVendLedgEntry.GETFILTER(Positive) <> '' THEN
                    IF TempOldVendLedgEntry.NEXT = 1 THEN
                        Completed := FALSE
                    ELSE BEGIN
                        TempOldVendLedgEntry.SETRANGE(Positive);
                        TempOldVendLedgEntry.FIND('-');
                        TempOldVendLedgEntry.CALCFIELDS("Remaining Amount");
                        Completed := TempOldVendLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
                    END
                ELSE
                    IF NewCVLedgEntryBuf.Open THEN
                        Completed := TempOldVendLedgEntry.NEXT = 0
                    ELSE
                        Completed := TRUE;
        UNTIL Completed;

        DtldCVLedgEntryBuf.SETCURRENTKEY("CV Ledger Entry No.", "Entry Type");
        DtldCVLedgEntryBuf.SETRANGE("CV Ledger Entry No.", NewCVLedgEntryBuf."Entry No.");
        DtldCVLedgEntryBuf.SETRANGE(
          "Entry Type",
          DtldCVLedgEntryBuf."Entry Type"::Application);
        DtldCVLedgEntryBuf.CALCSUMS("Amount (LCY)", Amount);

        CalcCurrencyUnrealizedGainLoss(
          NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, DtldCVLedgEntryBuf.Amount, NewRemainingAmtBeforeAppln);

        CalcAmtLCYAdjustment(NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine);

        NewCVLedgEntryBuf."Applies-to ID" := '';
        NewCVLedgEntryBuf."Amount to Apply" := 0;

        IF GLSetup."Unrealized VAT" OR
           (GLSetup."Prepayment Unrealized VAT" AND NewCVLedgEntryBuf.Prepayment)
        THEN
            IF IsNotPayment(NewCVLedgEntryBuf."Document Type") AND
               (NewRemainingAmtBeforeAppln - NewCVLedgEntryBuf."Remaining Amount" <> 0)
            THEN BEGIN
                NewVendLedgEntry.CopyFromCVLedgEntryBuffer(NewCVLedgEntryBuf);
                CheckUnrealizedVend := TRUE;
                UnrealizedVendLedgEntry := NewVendLedgEntry;
                UnrealizedVendLedgEntry.CALCFIELDS("Amount (LCY)", "Original Amt. (LCY)");
                UnrealizedRemainingAmountVend := -(NewRemainingAmtBeforeAppln - NewVendLedgEntry."Remaining Amount");
            END;
    end;

    [Scope('Internal')]
    procedure VendPostApplyVendLedgEntry(var GenJnlLinePostApply: Record "81"; var VendLedgEntryPostApply: Record "25")
    var
        Vend: Record "23";
        VendPostingGr: Record "93";
        VendLedgEntry: Record "25";
        DtldVendLedgEntry: Record "380";
        TempDtldCVLedgEntryBuf: Record "383" temporary;
        CVLedgEntryBuf: Record "382";
        GenJnlLine: Record "81";
        DtldLedgEntryInserted: Boolean;
    begin
        GenJnlLine := GenJnlLinePostApply;
        VendLedgEntry.TRANSFERFIELDS(VendLedgEntryPostApply);
        GenJnlLine."Source Currency Code" := VendLedgEntryPostApply."Currency Code";
        GenJnlLine."Applies-to ID" := VendLedgEntryPostApply."Applies-to ID";

        GenJnlCheckLine.RunCheck(GenJnlLine);

        IF NextEntryNo = 0 THEN
            StartPosting(GenJnlLine)
        ELSE
            ContinuePosting(GenJnlLine);

        Vend.GET(VendLedgEntry."Vendor No.");
        Vend.CheckBlockedVendOnJnls(Vend, GenJnlLine."Document Type", TRUE);

        IF GenJnlLine."Posting Group" = '' THEN BEGIN
            Vend.TESTFIELD("Vendor Posting Group");
            GenJnlLine."Posting Group" := Vend."Vendor Posting Group";
        END;
        VendPostingGr.GET(GenJnlLine."Posting Group");
        VendPostingGr.GetPayablesAccount;

        DtldVendLedgEntry.LOCKTABLE;
        VendLedgEntry.LOCKTABLE;

        // Post the application
        VendLedgEntry.CALCFIELDS(
          Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
          "Original Amount", "Original Amt. (LCY)");
        CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
        ApplyVendLedgEntry(
          CVLedgEntryBuf, TempDtldCVLedgEntryBuf, GenJnlLine, Vend);
        VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        VendLedgEntry.MODIFY(TRUE);

        // Post Dtld vendor entry
        DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJnlLine, TempDtldCVLedgEntryBuf, VendPostingGr, FALSE);

        CheckPostUnrealizedVAT(GenJnlLine, TRUE);

        IF DtldLedgEntryInserted THEN
            IF IsTempGLEntryBufEmpty THEN
                DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);

        FinishPosting;
    end;

    local procedure PrepareTempVendLedgEntry(GenJnlLine: Record "81"; var NewCVLedgEntryBuf: Record "382"; var TempOldVendLedgEntry: Record "25" temporary; Vend: Record "23"; var ApplyingDate: Date): Boolean
    var
        OldVendLedgEntry: Record "25";
        PurchSetup: Record "312";
        GenJnlApply: Codeunit "225";
        RemainingAmount: Decimal;
    begin
        IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
            // Find the entry to be applied to
            OldVendLedgEntry.RESET;
            OldVendLedgEntry.SETCURRENTKEY("Document No.");
            OldVendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
            OldVendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
            OldVendLedgEntry.SETRANGE("Vendor No.", NewCVLedgEntryBuf."CV No.");
            OldVendLedgEntry.SETRANGE(Open, TRUE);
            OldVendLedgEntry.FINDFIRST;
            OldVendLedgEntry.TESTFIELD(Positive, NOT NewCVLedgEntryBuf.Positive);
            IF OldVendLedgEntry."Posting Date" > ApplyingDate THEN
                ApplyingDate := OldVendLedgEntry."Posting Date";
            GenJnlApply.CheckAgainstApplnCurrency(
              NewCVLedgEntryBuf."Currency Code", OldVendLedgEntry."Currency Code", GenJnlLine."Account Type"::Vendor, TRUE);
            TempOldVendLedgEntry := OldVendLedgEntry;
            TempOldVendLedgEntry.INSERT;
        END ELSE BEGIN
            // Find the first old entry (Invoice) which the new entry (Payment) should apply to
            OldVendLedgEntry.RESET;
            OldVendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
            TempOldVendLedgEntry.SETCURRENTKEY("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
            OldVendLedgEntry.SETRANGE("Vendor No.", NewCVLedgEntryBuf."CV No.");
            OldVendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
            OldVendLedgEntry.SETRANGE(Open, TRUE);
            OldVendLedgEntry.SETFILTER("Entry No.", '<>%1', NewCVLedgEntryBuf."Entry No.");
            IF NOT (Vend."Application Method" = Vend."Application Method"::"Apply to Oldest") THEN
                OldVendLedgEntry.SETFILTER("Amount to Apply", '<>%1', 0);

            IF Vend."Application Method" = Vend."Application Method"::"Apply to Oldest" THEN
                OldVendLedgEntry.SETFILTER("Posting Date", '..%1', GenJnlLine."Posting Date");

            // Check and Move Ledger Entries to Temp
            PurchSetup.GET;
            IF PurchSetup."Appln. between Currencies" = PurchSetup."Appln. between Currencies"::None THEN
                OldVendLedgEntry.SETRANGE("Currency Code", NewCVLedgEntryBuf."Currency Code");
            IF OldVendLedgEntry.FINDSET(FALSE, FALSE) THEN
                REPEAT
                    IF GenJnlApply.CheckAgainstApplnCurrency(
                         NewCVLedgEntryBuf."Currency Code", OldVendLedgEntry."Currency Code", GenJnlLine."Account Type"::Vendor, FALSE)
                    THEN BEGIN
                        IF (OldVendLedgEntry."Posting Date" > ApplyingDate) AND (OldVendLedgEntry."Applies-to ID" <> '') THEN
                            ApplyingDate := OldVendLedgEntry."Posting Date";
                        TempOldVendLedgEntry := OldVendLedgEntry;
                        TempOldVendLedgEntry.INSERT;
                    END;
                UNTIL OldVendLedgEntry.NEXT = 0;

            TempOldVendLedgEntry.SETRANGE(Positive, NewCVLedgEntryBuf."Remaining Amount" > 0);

            IF TempOldVendLedgEntry.FIND('-') THEN BEGIN
                RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
                TempOldVendLedgEntry.SETRANGE(Positive);
                TempOldVendLedgEntry.FIND('-');
                REPEAT
                    TempOldVendLedgEntry.CALCFIELDS("Remaining Amount");
                    TempOldVendLedgEntry.RecalculateAmounts(
                      TempOldVendLedgEntry."Currency Code", NewCVLedgEntryBuf."Currency Code", NewCVLedgEntryBuf."Posting Date");
                    IF PaymentToleranceMgt.CheckCalcPmtDiscCVVend(NewCVLedgEntryBuf, TempOldVendLedgEntry, 0, FALSE, FALSE) THEN
                        TempOldVendLedgEntry."Remaining Amount" -= TempOldVendLedgEntry."Remaining Pmt. Disc. Possible";
                    RemainingAmount += TempOldVendLedgEntry."Remaining Amount";
                UNTIL TempOldVendLedgEntry.NEXT = 0;
                TempOldVendLedgEntry.SETRANGE(Positive, RemainingAmount < 0);
            END ELSE
                TempOldVendLedgEntry.SETRANGE(Positive);
            EXIT(TempOldVendLedgEntry.FIND('-'));
        END;
        EXIT(TRUE);
    end;

    local procedure PostDtldVendLedgEntries(GenJnlLine: Record "81"; var DtldCVLedgEntryBuf: Record "383"; VendPostingGr: Record "93"; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean
    var
        TempInvPostBuf: Record "49" temporary;
        DtldVendLedgEntry: Record "380";
        AdjAmount: array[4] of Decimal;
        DtldVendLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
    begin
        IF GenJnlLine."Account Type" <> GenJnlLine."Account Type"::Vendor THEN
            EXIT;

        IF DtldVendLedgEntry.FINDLAST THEN
            DtldVendLedgEntryNoOffset := DtldVendLedgEntry."Entry No."
        ELSE
            DtldVendLedgEntryNoOffset := 0;

        DtldCVLedgEntryBuf.RESET;
        IF DtldCVLedgEntryBuf.FINDSET THEN BEGIN
            IF LedgEntryInserted THEN BEGIN
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
            END;
            REPEAT
                InsertDtldVendLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, DtldVendLedgEntry, DtldVendLedgEntryNoOffset);

                UpdateTotalAmounts(
                  TempInvPostBuf, GenJnlLine."Dimension Set ID",
                  DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount");

                // Post automatic entries.
                IF ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) OR
                    (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) OR
                   ((AddCurrencyCode <> '') AND (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
                THEN
                    PostDtldVendLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, AdjAmount);
            UNTIL DtldCVLedgEntryBuf.NEXT = 0;
        END;

        CreateGLEntriesForTotalAmounts(
          GenJnlLine, TempInvPostBuf, AdjAmount, SaveEntryNo, VendPostingGr.GetPayablesAccount, LedgEntryInserted);

        DtldLedgEntryInserted := NOT DtldCVLedgEntryBuf.ISEMPTY;
        DtldCVLedgEntryBuf.DELETEALL;
    end;

    local procedure PostDtldVendLedgEntry(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; VendPostingGr: Record "93"; var AdjAmount: array[4] of Decimal)
    var
        AccNo: Code[20];
    begin
        AccNo := GetDtldVendLedgEntryAccNo(GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, 0, FALSE);
        PostDtldCVLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, AccNo, AdjAmount, FALSE);
    end;

    local procedure PostDtldVendLedgEntryUnapply(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; VendPostingGr: Record "93"; OriginalTransactionNo: Integer)
    var
        AccNo: Code[20];
        AdjAmount: array[4] of Decimal;
    begin
        IF (DtldCVLedgEntryBuf."Amount (LCY)" = 0) AND
           (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) AND
           ((AddCurrencyCode = '') OR (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0))
        THEN
            EXIT;

        AccNo := GetDtldVendLedgEntryAccNo(GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, OriginalTransactionNo, TRUE);
        DtldCVLedgEntryBuf."Gen. Posting Type" := DtldCVLedgEntryBuf."Gen. Posting Type"::Purchase;
        PostDtldCVLedgEntry(GenJnlLine, DtldCVLedgEntryBuf, AccNo, AdjAmount, TRUE);
    end;

    local procedure GetDtldVendLedgEntryAccNo(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; VendPostingGr: Record "93"; OriginalTransactionNo: Integer; Unapply: Boolean): Code[20]
    var
        Currency: Record "4";
        GenPostingSetup: Record "252";
        AmountCondition: Boolean;
    begin
        AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf, Unapply);
        CASE DtldCVLedgEntryBuf."Entry Type" OF
            DtldCVLedgEntryBuf."Entry Type"::"Initial Entry":
                ;
            DtldCVLedgEntryBuf."Entry Type"::Application:
                ;
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss",
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain",
            DtldCVLedgEntryBuf."Entry Type"::"Realized Loss",
            DtldCVLedgEntryBuf."Entry Type"::"Realized Gain":
                BEGIN
                    GetCurrency(Currency, DtldCVLedgEntryBuf."Currency Code");
                    CheckNonAddCurrCodeOccurred(Currency.Code);
                    EXIT(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount":
                EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                BEGIN
                    GenPostingSetup.GET(DtldCVLedgEntryBuf."Gen. Bus. Posting Group", DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
                    EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding":
                EXIT(VendPostingGr.GetApplRoundingAccount(AmountCondition));
            DtldCVLedgEntryBuf."Entry Type"::"Correction of Remaining Amount":
                EXIT(VendPostingGr.GetRoundingAccount(AmountCondition));
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance":
                CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                    GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                        EXIT(VendPostingGr.GetPmtToleranceAccount(AmountCondition));
                    GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                        EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance":
                CASE GLSetup."Payment Tolerance Posting" OF
                    GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                        EXIT(VendPostingGr.GetPmtToleranceAccount(AmountCondition));
                    GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                        EXIT(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                BEGIN
                    GenPostingSetup.GET(DtldCVLedgEntryBuf."Gen. Bus. Posting Group", DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
                    CASE GLSetup."Payment Tolerance Posting" OF
                        GLSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                            EXIT(GenPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                        GLSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                            EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                    END;
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                BEGIN
                    GenPostingSetup.GET(DtldCVLedgEntryBuf."Gen. Bus. Posting Group", DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
                    CASE GLSetup."Pmt. Disc. Tolerance Posting" OF
                        GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                            EXIT(GenPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                        GLSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                            EXIT(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                    END;
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)",
          DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)",
          DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                IF Unapply THEN
                    PostDtldVendVATAdjustment(GenJnlLine, DtldCVLedgEntryBuf, OriginalTransactionNo);
            ELSE
                DtldCVLedgEntryBuf.FIELDERROR("Entry Type");
        END;
    end;

    local procedure PostDtldCVLedgEntry(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; AccNo: Code[20]; var AdjAmount: array[4] of Decimal; Unapply: Boolean)
    begin
        CASE DtldCVLedgEntryBuf."Entry Type" OF
            DtldCVLedgEntryBuf."Entry Type"::"Initial Entry":
                ;
            DtldCVLedgEntryBuf."Entry Type"::Application:
                ;
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss",
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain",
            DtldCVLedgEntryBuf."Entry Type"::"Realized Loss",
            DtldCVLedgEntryBuf."Entry Type"::"Realized Gain":
                BEGIN
                    CreateGLEntryGainLoss(GenJnlLine, AccNo, -DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Currency Code" = AddCurrencyCode);
                    IF NOT Unapply THEN
                        CollectAdjustment(AdjAmount, -DtldCVLedgEntryBuf."Amount (LCY)", 0);
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount",
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance",
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance":
                BEGIN
                    CreateGLEntry(GenJnlLine, AccNo, -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                    IF NOT Unapply THEN
                        CollectAdjustment(AdjAmount, -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount");
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)",
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)",
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                BEGIN
                    IF NOT Unapply THEN
                        CreateGLEntryVATCollectAdj(
                          GenJnlLine, AccNo, -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", -DtldCVLedgEntryBuf."VAT Amount (LCY)", DtldCVLedgEntryBuf,
                          AdjAmount)
                    ELSE
                        CreateGLEntryVAT(
                          GenJnlLine, AccNo, -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", -DtldCVLedgEntryBuf."VAT Amount (LCY)", DtldCVLedgEntryBuf);
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding":
                IF DtldCVLedgEntryBuf."Amount (LCY)" <> 0 THEN BEGIN
                    CreateGLEntry(GenJnlLine, AccNo, -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", TRUE);
                    IF NOT Unapply THEN
                        CollectAdjustment(AdjAmount, -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount");
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Correction of Remaining Amount":
                IF DtldCVLedgEntryBuf."Amount (LCY)" <> 0 THEN BEGIN
                    CreateGLEntry(GenJnlLine, AccNo, -DtldCVLedgEntryBuf."Amount (LCY)", 0, FALSE);
                    IF NOT Unapply THEN
                        CollectAdjustment(AdjAmount, -DtldCVLedgEntryBuf."Amount (LCY)", 0);
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)",
  DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)",
  DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                ;
            ELSE
                DtldCVLedgEntryBuf.FIELDERROR("Entry Type");
        END;
    end;

    local procedure PostDtldCustVATAdjustment(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; OriginalTransactionNo: Integer)
    var
        VATPostingSetup: Record "325";
        TaxJurisdiction: Record "320";
    begin
        DtldCVLedgEntryBuf.FindVATEntry(VATEntry, OriginalTransactionNo);

        CASE VATPostingSetup."VAT Calculation Type" OF
            VATPostingSetup."VAT Calculation Type"::"Normal VAT",
            VATPostingSetup."VAT Calculation Type"::"Full VAT":
                BEGIN
                    VATPostingSetup.GET(DtldCVLedgEntryBuf."VAT Bus. Posting Group", DtldCVLedgEntryBuf."VAT Prod. Posting Group");
                    VATPostingSetup.TESTFIELD("VAT Calculation Type", VATEntry."VAT Calculation Type");
                    CreateGLEntry(
                      GenJnlLine, VATPostingSetup.GetSalesAccount(FALSE), -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                END;
            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                ;
            VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                BEGIN
                    DtldCVLedgEntryBuf.TESTFIELD("Tax Jurisdiction Code");
                    TaxJurisdiction.GET(DtldCVLedgEntryBuf."Tax Jurisdiction Code");
                    CreateGLEntry(
                      GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                END;
        END;
    end;

    local procedure PostDtldVendVATAdjustment(GenJnlLine: Record "81"; DtldCVLedgEntryBuf: Record "383"; OriginalTransactionNo: Integer)
    var
        VATPostingSetup: Record "325";
        TaxJurisdiction: Record "320";
    begin
        DtldCVLedgEntryBuf.FindVATEntry(VATEntry, OriginalTransactionNo);

        CASE VATPostingSetup."VAT Calculation Type" OF
            VATPostingSetup."VAT Calculation Type"::"Normal VAT",
            VATPostingSetup."VAT Calculation Type"::"Full VAT":
                BEGIN
                    VATPostingSetup.GET(DtldCVLedgEntryBuf."VAT Bus. Posting Group", DtldCVLedgEntryBuf."VAT Prod. Posting Group");
                    VATPostingSetup.TESTFIELD("VAT Calculation Type", VATEntry."VAT Calculation Type");
                    CreateGLEntry(
                      GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                END;
            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                    VATPostingSetup.GET(DtldCVLedgEntryBuf."VAT Bus. Posting Group", DtldCVLedgEntryBuf."VAT Prod. Posting Group");
                    VATPostingSetup.TESTFIELD("VAT Calculation Type", VATEntry."VAT Calculation Type");
                    CreateGLEntry(
                      GenJnlLine, VATPostingSetup.GetPurchAccount(FALSE), -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                    CreateGLEntry(
                      GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE), DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                END;
            VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                BEGIN
                    TaxJurisdiction.GET(DtldCVLedgEntryBuf."Tax Jurisdiction Code");
                    IF DtldCVLedgEntryBuf."Use Tax" THEN BEGIN
                        CreateGLEntry(
                          GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                        CreateGLEntry(
                          GenJnlLine, TaxJurisdiction.GetRevChargeAccount(FALSE), DtldCVLedgEntryBuf."Amount (LCY)", DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                    END ELSE
                        CreateGLEntry(
                          GenJnlLine, TaxJurisdiction.GetPurchAccount(FALSE), -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount", FALSE);
                END;
        END;
    end;

    local procedure VendUnrealizedVAT(GenJnlLine: Record "81"; var VendLedgEntry2: Record "25"; SettledAmount: Decimal)
    var
        VATEntry2: Record "254";
        TaxJurisdiction: Record "320";
        VATPostingSetup: Record "325";
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        PaidAmount: Decimal;
        TotalUnrealVATAmountFirst: Decimal;
        TotalUnrealVATAmountLast: Decimal;
        PurchVATAccount: Code[20];
        PurchVATUnrealAccount: Code[20];
        PurchReverseAccount: Code[20];
        PurchReverseUnrealAccount: Code[20];
        LastConnectionNo: Integer;
    begin
        VATEntry2.RESET;
        VATEntry2.SETCURRENTKEY("Transaction No.");
        VATEntry2.SETRANGE("Transaction No.", VendLedgEntry2."Transaction No.");
        PaidAmount := -VendLedgEntry2."Amount (LCY)" + VendLedgEntry2."Remaining Amt. (LCY)";
        IF VATEntry2.FINDSET THEN
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF VATPostingSetup."Unrealized VAT Type" IN
                   [VATPostingSetup."Unrealized VAT Type"::Last, VATPostingSetup."Unrealized VAT Type"::"Last (Fully Paid)"]
                THEN
                    TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
                IF VATPostingSetup."Unrealized VAT Type" IN
                   [VATPostingSetup."Unrealized VAT Type"::First, VATPostingSetup."Unrealized VAT Type"::"First (Fully Paid)"]
                THEN
                    TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
            UNTIL VATEntry2.NEXT = 0;
        IF VATEntry2.FINDSET THEN BEGIN
            LastConnectionNo := 0;
            REPEAT
                VATPostingSetup.GET(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                IF LastConnectionNo <> VATEntry2."Sales Tax Connection No." THEN BEGIN
                    InsertSummarizedVAT(GenJnlLine);
                    LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                END;

                VATPart :=
                  VATEntry2.GetUnrealizedVATPart(
                    ROUND(SettledAmount / VendLedgEntry2.GetOriginalCurrencyFactor),
                    PaidAmount,
                    VendLedgEntry2."Original Amt. (LCY)",
                    TotalUnrealVATAmountFirst,
                    TotalUnrealVATAmountLast);

                IF VATPart > 0 THEN BEGIN
                    CASE VATEntry2."VAT Calculation Type" OF
                        VATEntry2."VAT Calculation Type"::"Normal VAT",
                        VATEntry2."VAT Calculation Type"::"Full VAT":
                            BEGIN
                                PurchVATAccount := VATPostingSetup.GetPurchAccount(FALSE);
                                PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(TRUE);
                            END;
                        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                            BEGIN
                                PurchVATAccount := VATPostingSetup.GetPurchAccount(FALSE);
                                PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(TRUE);
                                PurchReverseAccount := VATPostingSetup.GetRevChargeAccount(FALSE);
                                PurchReverseUnrealAccount := VATPostingSetup.GetRevChargeAccount(TRUE);
                            END;
                        VATEntry2."VAT Calculation Type"::"Sales Tax":
                            IF (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax" THEN BEGIN
                                TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                                PurchVATAccount := TaxJurisdiction.GetPurchAccount(FALSE);
                                PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(TRUE);
                                PurchReverseAccount := TaxJurisdiction.GetRevChargeAccount(FALSE);
                                PurchReverseUnrealAccount := TaxJurisdiction.GetRevChargeAccount(TRUE);
                            END ELSE BEGIN
                                TaxJurisdiction.GET(VATEntry2."Tax Jurisdiction Code");
                                PurchVATAccount := TaxJurisdiction.GetPurchAccount(FALSE);
                                PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(TRUE);
                            END;
                    END;

                    IF VATPart = 1 THEN BEGIN
                        VATAmount := VATEntry2."Remaining Unrealized Amount";
                        VATBase := VATEntry2."Remaining Unrealized Base";
                        VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                        VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
                    END ELSE BEGIN
                        VATAmount := ROUND(VATEntry2."Remaining Unrealized Amount" * VATPart, GLSetup."Amount Rounding Precision");
                        VATBase := ROUND(VATEntry2."Remaining Unrealized Base" * VATPart, GLSetup."Amount Rounding Precision");
                        VATAmountAddCurr :=
                          ROUND(
                            VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                        VATBaseAddCurr :=
                          ROUND(
                            VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                    END;

                    InitGLEntryVAT(
                      GenJnlLine, PurchVATUnrealAccount, PurchVATAccount, -VATAmount, -VATAmountAddCurr, FALSE);
                    InitGLEntryVATCopy(
                      GenJnlLine, PurchVATAccount, PurchVATUnrealAccount, VATAmount, VATAmountAddCurr, VATEntry2);

                    IF (VATEntry2."VAT Calculation Type" =
                        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT") OR
                       ((VATEntry2."VAT Calculation Type" =
                         VATEntry2."VAT Calculation Type"::"Sales Tax") AND
                        (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax")
                    THEN BEGIN
                        InitGLEntryVAT(
                          GenJnlLine, PurchReverseUnrealAccount, PurchReverseAccount, VATAmount, VATAmountAddCurr, FALSE);
                        InitGLEntryVATCopy(
                          GenJnlLine, PurchReverseAccount, PurchReverseUnrealAccount, -VATAmount, -VATAmountAddCurr, VATEntry2);
                    END;

                    PostUnrealVATEntry(GenJnlLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr);
                END;
            UNTIL VATEntry2.NEXT = 0;

            InsertSummarizedVAT(GenJnlLine);
        END;
    end;

    local procedure PostUnrealVATEntry(GenJnlLine: Record "81"; var VATEntry2: Record "254"; VATAmount: Decimal; VATBase: Decimal; VATAmountAddCurr: Decimal; VATBaseAddCurr: Decimal)
    begin
        VATEntry.LOCKTABLE;
        VATEntry := VATEntry2;
        VATEntry."Entry No." := NextVATEntryNo;
        VATEntry."Posting Date" := GenJnlLine."Posting Date";
        VATEntry."Document No." := GenJnlLine."Document No.";
        VATEntry."External Document No." := GenJnlLine."External Document No.";
        VATEntry."Document Type" := GenJnlLine."Document Type";
        VATEntry.Amount := VATAmount;
        VATEntry.Base := VATBase;
        VATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        VATEntry."Additional-Currency Base" := VATBaseAddCurr;
        VATEntry.SetUnrealAmountsToZero;
        VATEntry."User ID" := USERID;
        VATEntry."Source Code" := GenJnlLine."Source Code";
        VATEntry."Reason Code" := GenJnlLine."Reason Code";
        VATEntry."Closed by Entry No." := 0;
        VATEntry.Closed := FALSE;
        VATEntry."Transaction No." := NextTransactionNo;
        VATEntry."Sales Tax Connection No." := NextConnectionNo;
        VATEntry."Unrealized VAT Entry No." := VATEntry2."Entry No.";
        VATEntry.INSERT(TRUE);
        NextVATEntryNo := NextVATEntryNo + 1;

        VATEntry2."Remaining Unrealized Amount" :=
          VATEntry2."Remaining Unrealized Amount" - VATEntry.Amount;
        VATEntry2."Remaining Unrealized Base" :=
          VATEntry2."Remaining Unrealized Base" - VATEntry.Base;
        VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Amount" - VATEntry."Additional-Currency Amount";
        VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Base" - VATEntry."Additional-Currency Base";
        VATEntry2.MODIFY;
    end;

    local procedure PostApply(GenJnlLine: Record "81"; var DtldCVLedgEntryBuf: Record "383"; var OldCVLedgEntryBuf: Record "382"; var NewCVLedgEntryBuf: Record "382"; var NewCVLedgEntryBuf2: Record "382"; BlockPaymentTolerance: Boolean; AllApplied: Boolean; var AppliedAmount: Decimal; var PmtTolAmtToBeApplied: Decimal)
    var
        OldCVLedgEntryBuf2: Record "382";
        OldCVLedgEntryBuf3: Record "382";
        OldRemainingAmtBeforeAppln: Decimal;
        ApplnRoundingPrecision: Decimal;
        AppliedAmountLCY: Decimal;
        OldAppliedAmount: Decimal;
    begin
        OldRemainingAmtBeforeAppln := OldCVLedgEntryBuf."Remaining Amount";
        OldCVLedgEntryBuf3 := OldCVLedgEntryBuf;

        // Management of posting in multiple currencies
        OldCVLedgEntryBuf2 := OldCVLedgEntryBuf;
        OldCVLedgEntryBuf.COPYFILTER(Positive, OldCVLedgEntryBuf2.Positive);
        ApplnRoundingPrecision := GetApplnRoundPrecision(NewCVLedgEntryBuf, OldCVLedgEntryBuf);

        OldCVLedgEntryBuf2.RecalculateAmounts(
          OldCVLedgEntryBuf2."Currency Code", NewCVLedgEntryBuf."Currency Code", NewCVLedgEntryBuf."Posting Date");

        IF NOT BlockPaymentTolerance THEN
            CalcPmtTolerance(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
              PmtTolAmtToBeApplied, NextTransactionNo, FirstNewVATEntryNo);

        CalcPmtDisc(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
          PmtTolAmtToBeApplied, ApplnRoundingPrecision, NextTransactionNo, FirstNewVATEntryNo);

        IF NOT BlockPaymentTolerance THEN
            CalcPmtDiscTolerance(
              NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf, GenJnlLine,
              NextTransactionNo, FirstNewVATEntryNo);

        CalcCurrencyApplnRounding(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf2, DtldCVLedgEntryBuf,
          GenJnlLine, ApplnRoundingPrecision);

        FindAmtForAppln(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2,
          AppliedAmount, AppliedAmountLCY, OldAppliedAmount, ApplnRoundingPrecision);

        CalcCurrencyUnrealizedGainLoss(
          OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, -OldAppliedAmount, OldRemainingAmtBeforeAppln);

        CalcCurrencyRealizedGainLoss(
          NewCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, AppliedAmount, AppliedAmountLCY);

        CalcCurrencyRealizedGainLoss(
          OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine, -OldAppliedAmount, -AppliedAmountLCY);

        CalcApplication(
          NewCVLedgEntryBuf, OldCVLedgEntryBuf, DtldCVLedgEntryBuf,
          GenJnlLine, AppliedAmount, AppliedAmountLCY, OldAppliedAmount,
          NewCVLedgEntryBuf2, OldCVLedgEntryBuf3, AllApplied);

        PaymentToleranceMgt.CalcRemainingPmtDisc(NewCVLedgEntryBuf, OldCVLedgEntryBuf, OldCVLedgEntryBuf2, GLSetup);

        CalcAmtLCYAdjustment(OldCVLedgEntryBuf, DtldCVLedgEntryBuf, GenJnlLine);
    end;

    [Scope('Internal')]
    procedure UnapplyCustLedgEntry(GenJnlLine2: Record "81"; DtldCustLedgEntry: Record "379")
    var
        Cust: Record "18";
        CustPostingGr: Record "92";
        GenJnlLine: Record "81";
        DtldCustLedgEntry2: Record "379";
        NewDtldCustLedgEntry: Record "379";
        CustLedgEntry: Record "21";
        DtldCVLedgEntryBuf: Record "383";
        VATEntry: Record "254";
        TempVATEntry2: Record "254" temporary;
        CurrencyLCY: Record "4";
        TempInvPostBuf: Record "49" temporary;
        AdjAmount: array[4] of Decimal;
        NextDtldLedgEntryNo: Integer;
        UnapplyVATEntries: Boolean;
    begin
        GenJnlLine.TRANSFERFIELDS(GenJnlLine2);
        IF GenJnlLine."Document Date" = 0D THEN
            GenJnlLine."Document Date" := GenJnlLine."Posting Date";

        IF NextEntryNo = 0 THEN
            StartPosting(GenJnlLine)
        ELSE
            ContinuePosting(GenJnlLine);

        ReadGLSetup(GLSetup);

        Cust.GET(DtldCustLedgEntry."Customer No.");
        Cust.CheckBlockedCustOnJnls(Cust, GenJnlLine2."Document Type"::Payment, TRUE);
        CustPostingGr.GET(GenJnlLine."Posting Group");
        CustPostingGr.GetReceivablesAccount;

        VATEntry.LOCKTABLE;
        DtldCustLedgEntry.LOCKTABLE;
        CustLedgEntry.LOCKTABLE;

        DtldCustLedgEntry.TESTFIELD("Entry Type", DtldCustLedgEntry."Entry Type"::Application);

        DtldCustLedgEntry2.RESET;
        DtldCustLedgEntry2.FINDLAST;
        NextDtldLedgEntryNo := DtldCustLedgEntry2."Entry No." + 1;
        IF DtldCustLedgEntry."Transaction No." = 0 THEN BEGIN
            DtldCustLedgEntry2.SETCURRENTKEY("Application No.", "Customer No.", "Entry Type");
            DtldCustLedgEntry2.SETRANGE("Application No.", DtldCustLedgEntry."Application No.");
        END ELSE BEGIN
            DtldCustLedgEntry2.SETCURRENTKEY("Transaction No.", "Customer No.", "Entry Type");
            DtldCustLedgEntry2.SETRANGE("Transaction No.", DtldCustLedgEntry."Transaction No.");
        END;
        DtldCustLedgEntry2.SETRANGE("Customer No.", DtldCustLedgEntry."Customer No.");
        DtldCustLedgEntry2.SETFILTER("Entry Type", '>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
        IF DtldCustLedgEntry."Transaction No." <> 0 THEN BEGIN
            UnapplyVATEntries := FALSE;
            DtldCustLedgEntry2.FINDSET;
            REPEAT
                DtldCustLedgEntry2.TESTFIELD(Unapplied, FALSE);
                IF IsVATAdjustment(DtldCustLedgEntry2."Entry Type") THEN
                    UnapplyVATEntries := TRUE
            UNTIL DtldCustLedgEntry2.NEXT = 0;

            PostUnapply(
              GenJnlLine, VATEntry, VATEntry.Type::Sale,
              DtldCustLedgEntry."Customer No.", DtldCustLedgEntry."Transaction No.", UnapplyVATEntries, TempVATEntry);

            DtldCustLedgEntry2.FINDSET;
            REPEAT
                DtldCVLedgEntryBuf.INIT;
                DtldCVLedgEntryBuf.TRANSFERFIELDS(DtldCustLedgEntry2);
                ProcessTempVATEntry(DtldCVLedgEntryBuf, TempVATEntry);
            UNTIL DtldCustLedgEntry2.NEXT = 0;
        END;

        // Look one more time
        DtldCustLedgEntry2.FINDSET;
        TempInvPostBuf.DELETEALL;
        REPEAT
            DtldCustLedgEntry2.TESTFIELD(Unapplied, FALSE);
            InsertDtldCustLedgEntryUnapply(GenJnlLine, NewDtldCustLedgEntry, DtldCustLedgEntry2, NextDtldLedgEntryNo);

            DtldCVLedgEntryBuf.INIT;
            DtldCVLedgEntryBuf.TRANSFERFIELDS(NewDtldCustLedgEntry);
            SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
            CurrencyLCY.InitRoundingPrecision;

            IF (DtldCustLedgEntry2."Transaction No." <> 0) AND IsVATExcluded(DtldCustLedgEntry2."Entry Type") THEN BEGIN
                UnapplyExcludedVAT(
                  TempVATEntry2, DtldCustLedgEntry2."Transaction No.", DtldCustLedgEntry2."VAT Bus. Posting Group",
                  DtldCustLedgEntry2."VAT Prod. Posting Group", DtldCustLedgEntry2."Gen. Prod. Posting Group");
                DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
                  CalcVATAmountFromVATEntry(DtldCVLedgEntryBuf."Amount (LCY)", TempVATEntry2, CurrencyLCY);
            END;
            UpdateTotalAmounts(
              TempInvPostBuf, GenJnlLine."Dimension Set ID", DtldCVLedgEntryBuf."Amount (LCY)",
              DtldCVLedgEntryBuf."Additional-Currency Amount");

            IF NOT (DtldCVLedgEntryBuf."Entry Type" IN [
                                                        DtldCVLedgEntryBuf."Entry Type"::"Initial Entry",
                                                        DtldCVLedgEntryBuf."Entry Type"::Application])
            THEN
                CollectAdjustment(AdjAmount,
                  -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount");

            PostDtldCustLedgEntryUnapply(
              GenJnlLine, DtldCVLedgEntryBuf, CustPostingGr, DtldCustLedgEntry2."Transaction No.");

            DtldCustLedgEntry2.Unapplied := TRUE;
            DtldCustLedgEntry2."Unapplied by Entry No." := NewDtldCustLedgEntry."Entry No.";
            DtldCustLedgEntry2.MODIFY;

            UpdateCustLedgEntry(DtldCustLedgEntry2);
        UNTIL DtldCustLedgEntry2.NEXT = 0;

        CreateGLEntriesForTotalAmountsUnapply(GenJnlLine, TempInvPostBuf, CustPostingGr.GetReceivablesAccount);

        IF IsTempGLEntryBufEmpty THEN
            DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);
        CheckPostUnrealizedVAT(GenJnlLine, TRUE);
        FinishPosting;
    end;

    [Scope('Internal')]
    procedure UnapplyVendLedgEntry(GenJnlLine2: Record "81"; DtldVendLedgEntry: Record "380")
    var
        Vend: Record "23";
        VendPostingGr: Record "93";
        GenJnlLine: Record "81";
        DtldVendLedgEntry2: Record "380";
        NewDtldVendLedgEntry: Record "380";
        VendLedgEntry: Record "25";
        DtldCVLedgEntryBuf: Record "383";
        VATEntry: Record "254";
        TempVATEntry2: Record "254" temporary;
        CurrencyLCY: Record "4";
        TempInvPostBuf: Record "49" temporary;
        AdjAmount: array[4] of Decimal;
        NextDtldLedgEntryNo: Integer;
        UnapplyVATEntries: Boolean;
    begin
        GenJnlLine.TRANSFERFIELDS(GenJnlLine2);
        IF GenJnlLine."Document Date" = 0D THEN
            GenJnlLine."Document Date" := GenJnlLine."Posting Date";

        IF NextEntryNo = 0 THEN
            StartPosting(GenJnlLine)
        ELSE
            ContinuePosting(GenJnlLine);

        ReadGLSetup(GLSetup);

        Vend.GET(DtldVendLedgEntry."Vendor No.");
        Vend.CheckBlockedVendOnJnls(Vend, GenJnlLine2."Document Type"::Payment, TRUE);
        VendPostingGr.GET(GenJnlLine."Posting Group");
        VendPostingGr.GetPayablesAccount;

        VATEntry.LOCKTABLE;
        DtldVendLedgEntry.LOCKTABLE;
        VendLedgEntry.LOCKTABLE;

        DtldVendLedgEntry.TESTFIELD("Entry Type", DtldVendLedgEntry."Entry Type"::Application);

        DtldVendLedgEntry2.RESET;
        DtldVendLedgEntry2.FINDLAST;
        NextDtldLedgEntryNo := DtldVendLedgEntry2."Entry No." + 1;
        IF DtldVendLedgEntry."Transaction No." = 0 THEN BEGIN
            DtldVendLedgEntry2.SETCURRENTKEY("Application No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry2.SETRANGE("Application No.", DtldVendLedgEntry."Application No.");
        END ELSE BEGIN
            DtldVendLedgEntry2.SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry2.SETRANGE("Transaction No.", DtldVendLedgEntry."Transaction No.");
        END;
        DtldVendLedgEntry2.SETRANGE("Vendor No.", DtldVendLedgEntry."Vendor No.");
        DtldVendLedgEntry2.SETFILTER("Entry Type", '>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        IF DtldVendLedgEntry."Transaction No." <> 0 THEN BEGIN
            UnapplyVATEntries := FALSE;
            DtldVendLedgEntry2.FINDSET;
            REPEAT
                DtldVendLedgEntry2.TESTFIELD(Unapplied, FALSE);
                IF IsVATAdjustment(DtldVendLedgEntry2."Entry Type") THEN
                    UnapplyVATEntries := TRUE
            UNTIL DtldVendLedgEntry2.NEXT = 0;

            PostUnapply(
              GenJnlLine, VATEntry, VATEntry.Type::Purchase,
              DtldVendLedgEntry."Vendor No.", DtldVendLedgEntry."Transaction No.", UnapplyVATEntries, TempVATEntry);

            DtldVendLedgEntry2.FINDSET;
            REPEAT
                DtldCVLedgEntryBuf.INIT;
                DtldCVLedgEntryBuf.TRANSFERFIELDS(DtldVendLedgEntry2);
                ProcessTempVATEntry(DtldCVLedgEntryBuf, TempVATEntry);
            UNTIL DtldVendLedgEntry2.NEXT = 0;
        END;

        // Look one more time
        DtldVendLedgEntry2.FINDSET;
        TempInvPostBuf.DELETEALL;
        REPEAT
            DtldVendLedgEntry2.TESTFIELD(Unapplied, FALSE);
            InsertDtldVendLedgEntryUnapply(GenJnlLine, NewDtldVendLedgEntry, DtldVendLedgEntry2, NextDtldLedgEntryNo);

            DtldCVLedgEntryBuf.INIT;
            DtldCVLedgEntryBuf.TRANSFERFIELDS(NewDtldVendLedgEntry);
            SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
            CurrencyLCY.InitRoundingPrecision;

            IF (DtldVendLedgEntry2."Transaction No." <> 0) AND IsVATExcluded(DtldVendLedgEntry2."Entry Type") THEN BEGIN
                UnapplyExcludedVAT(
                  TempVATEntry2, DtldVendLedgEntry2."Transaction No.", DtldVendLedgEntry2."VAT Bus. Posting Group",
                  DtldVendLedgEntry2."VAT Prod. Posting Group", DtldVendLedgEntry2."Gen. Prod. Posting Group");
                DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
                  CalcVATAmountFromVATEntry(DtldCVLedgEntryBuf."Amount (LCY)", TempVATEntry2, CurrencyLCY);
            END;
            UpdateTotalAmounts(
              TempInvPostBuf, GenJnlLine."Dimension Set ID", DtldCVLedgEntryBuf."Amount (LCY)",
              DtldCVLedgEntryBuf."Additional-Currency Amount");

            IF NOT (DtldCVLedgEntryBuf."Entry Type" IN [
                                                        DtldCVLedgEntryBuf."Entry Type"::"Initial Entry",
                                                        DtldCVLedgEntryBuf."Entry Type"::Application])
            THEN
                CollectAdjustment(AdjAmount,
                  -DtldCVLedgEntryBuf."Amount (LCY)", -DtldCVLedgEntryBuf."Additional-Currency Amount");

            PostDtldVendLedgEntryUnapply(
              GenJnlLine, DtldCVLedgEntryBuf, VendPostingGr, DtldVendLedgEntry2."Transaction No.");

            DtldVendLedgEntry2.Unapplied := TRUE;
            DtldVendLedgEntry2."Unapplied by Entry No." := NewDtldVendLedgEntry."Entry No.";
            DtldVendLedgEntry2.MODIFY;

            UpdateVendLedgEntry(DtldVendLedgEntry2);
        UNTIL DtldVendLedgEntry2.NEXT = 0;

        CreateGLEntriesForTotalAmountsUnapply(GenJnlLine, TempInvPostBuf, VendPostingGr.GetPayablesAccount);

        IF IsTempGLEntryBufEmpty THEN
            DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
        CheckPostUnrealizedVAT(GenJnlLine, TRUE);
        FinishPosting;
    end;

    local procedure UnapplyExcludedVAT(var TempVATEntry: Record "254" temporary; TransactionNo: Integer; VATBusPostingGroup: Code[10]; VATProdPostingGroup: Code[10]; GenProdPostingGroup: Code[10])
    begin
        TempVATEntry.SETRANGE("VAT Bus. Posting Group", VATBusPostingGroup);
        TempVATEntry.SETRANGE("VAT Prod. Posting Group", VATProdPostingGroup);
        TempVATEntry.SETRANGE("Gen. Prod. Posting Group", GenProdPostingGroup);
        IF NOT TempVATEntry.FINDFIRST THEN BEGIN
            TempVATEntry.RESET;
            IF TempVATEntry.FINDLAST THEN
                TempVATEntry."Entry No." := TempVATEntry."Entry No." + 1
            ELSE
                TempVATEntry."Entry No." := 1;
            TempVATEntry.INIT;
            TempVATEntry."VAT Bus. Posting Group" := VATBusPostingGroup;
            TempVATEntry."VAT Prod. Posting Group" := VATProdPostingGroup;
            TempVATEntry."Gen. Prod. Posting Group" := GenProdPostingGroup;
            VATEntry.SETCURRENTKEY("Transaction No.");
            VATEntry.SETRANGE("Transaction No.", TransactionNo);
            VATEntry.SETRANGE("VAT Bus. Posting Group", VATBusPostingGroup);
            VATEntry.SETRANGE("VAT Prod. Posting Group", VATProdPostingGroup);
            VATEntry.SETRANGE("Gen. Prod. Posting Group", GenProdPostingGroup);
            IF VATEntry.FINDSET THEN
                REPEAT
                    IF VATEntry."Unrealized VAT Entry No." = 0 THEN BEGIN
                        TempVATEntry.Base := TempVATEntry.Base + VATEntry.Base;
                        TempVATEntry.Amount := TempVATEntry.Amount + VATEntry.Amount;
                    END;
                UNTIL VATEntry.NEXT = 0;
            CLEAR(VATEntry);
            TempVATEntry.INSERT;
        END;
    end;

    local procedure PostUnrealVATByUnapply(GenJnlLine: Record "81"; VATPostingSetup: Record "325"; VATEntry: Record "254"; NewVATEntry: Record "254")
    var
        VATEntry2: Record "254";
        AmountAddCurr: Decimal;
    begin
        AmountAddCurr := CalcAddCurrForUnapplication(VATEntry."Posting Date", VATEntry.Amount);
        CreateGLEntry(
          GenJnlLine, GetPostingAccountNo(VATPostingSetup, VATEntry, TRUE), VATEntry.Amount, AmountAddCurr, FALSE);
        CreateGLEntryFromVATEntry(
          GenJnlLine, GetPostingAccountNo(VATPostingSetup, VATEntry, FALSE), -VATEntry.Amount, -AmountAddCurr, VATEntry);

        VATEntry2.GET(VATEntry."Unrealized VAT Entry No.");
        VATEntry2."Remaining Unrealized Amount" := VATEntry2."Remaining Unrealized Amount" - NewVATEntry.Amount;
        VATEntry2."Remaining Unrealized Base" := VATEntry2."Remaining Unrealized Base" - NewVATEntry.Base;
        VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Amount" - NewVATEntry."Additional-Currency Amount";
        VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Base" - NewVATEntry."Additional-Currency Base";
        VATEntry2.MODIFY;
    end;

    local procedure PostPmtDiscountVATByUnapply(GenJnlLine: Record "81"; ReverseChargeVATAccNo: Code[20]; VATAccNo: Code[20]; VATEntry: Record "254")
    var
        AmountAddCurr: Decimal;
    begin
        AmountAddCurr := CalcAddCurrForUnapplication(VATEntry."Posting Date", VATEntry.Amount);
        CreateGLEntry(GenJnlLine, ReverseChargeVATAccNo, VATEntry.Amount, AmountAddCurr, FALSE);
        CreateGLEntry(GenJnlLine, VATAccNo, -VATEntry.Amount, -AmountAddCurr, FALSE);
    end;

    local procedure PostUnapply(GenJnlLine: Record "81"; var VATEntry: Record "254"; VATEntryType: Option; BilltoPaytoNo: Code[20]; TransactionNo: Integer; var UnapplyVATEntries: Boolean; var TempVATEntry: Record "254" temporary)
    var
        VATPostingSetup: Record "325";
        VATEntry2: Record "254";
        GLEntryVATEntryLink: Record "253";
        AccNo: Code[20];
        TempVATEntryNo: Integer;
    begin
        TempVATEntryNo := 1;
        VATEntry.SETCURRENTKEY(Type, "Bill-to/Pay-to No.", "Transaction No.");
        VATEntry.SETRANGE(Type, VATEntryType);
        VATEntry.SETRANGE("Bill-to/Pay-to No.", BilltoPaytoNo);
        VATEntry.SETRANGE("Transaction No.", TransactionNo);
        IF VATEntry.FINDSET THEN BEGIN
            VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
            IF VATPostingSetup."Adjust for Payment Discount" AND NOT IsNotPayment(VATEntry."Document Type") AND
               (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT")
            THEN
                UnapplyVATEntries := TRUE;
            REPEAT
                IF UnapplyVATEntries OR (VATEntry."Unrealized VAT Entry No." <> 0) THEN BEGIN
                    InsertTempVATEntry(GenJnlLine, VATEntry, TempVATEntryNo, TempVATEntry);
                    IF VATEntry."Unrealized VAT Entry No." <> 0 THEN BEGIN
                        VATPostingSetup.GET(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
                        IF VATPostingSetup."VAT Calculation Type" IN
                           [VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                            VATPostingSetup."VAT Calculation Type"::"Full VAT"]
                        THEN
                            PostUnrealVATByUnapply(GenJnlLine, VATPostingSetup, VATEntry, TempVATEntry)
                        ELSE
                            IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                                PostUnrealVATByUnapply(GenJnlLine, VATPostingSetup, VATEntry, TempVATEntry);
                                CreateGLEntry(
                                  GenJnlLine, VATPostingSetup.GetRevChargeAccount(TRUE),
                                  -VATEntry.Amount, CalcAddCurrForUnapplication(VATEntry."Posting Date", -VATEntry.Amount), FALSE);
                                CreateGLEntry(
                                  GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE),
                                  VATEntry.Amount, CalcAddCurrForUnapplication(VATEntry."Posting Date", VATEntry.Amount), FALSE);
                            END ELSE
                                PostUnrealVATByUnapply(GenJnlLine, VATPostingSetup, VATEntry, TempVATEntry);
                        VATEntry2 := TempVATEntry;
                        VATEntry2."Entry No." := NextVATEntryNo;
                        VATEntry2.INSERT;
                        IF VATEntry2."Unrealized VAT Entry No." = 0 THEN
                            GLEntryVATEntryLink.InsertLink(NextEntryNo, VATEntry2."Entry No.");
                        TempVATEntry.DELETE;
                        IncrNextVATEntryNo;
                    END;

                    IF VATPostingSetup."Adjust for Payment Discount" AND NOT IsNotPayment(VATEntry."Document Type") AND
                       (VATPostingSetup."VAT Calculation Type" =
                        VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") AND
                       (VATEntry."Unrealized VAT Entry No." = 0)
                    THEN BEGIN
                        CASE VATEntryType OF
                            VATEntry.Type::Sale:
                                AccNo := VATPostingSetup.GetSalesAccount(FALSE);
                            VATEntry.Type::Purchase:
                                AccNo := VATPostingSetup.GetPurchAccount(FALSE);
                        END;
                        PostPmtDiscountVATByUnapply(GenJnlLine, VATPostingSetup.GetRevChargeAccount(FALSE), AccNo, VATEntry);
                    END;
                END;
            UNTIL VATEntry.NEXT = 0;
        END;
    end;

    local procedure CalcAddCurrForUnapplication(Date: Date; Amt: Decimal): Decimal
    var
        AddCurrency: Record "4";
        CurrExchRate: Record "330";
    begin
        IF AddCurrencyCode = '' THEN
            EXIT;

        AddCurrency.GET(AddCurrencyCode);
        AddCurrency.TESTFIELD("Amount Rounding Precision");

        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              Date, AddCurrencyCode, Amt, CurrExchRate.ExchangeRate(Date, AddCurrencyCode)),
            AddCurrency."Amount Rounding Precision"));
    end;

    local procedure CalcVATAmountFromVATEntry(AmountLCY: Decimal; var VATEntry: Record "254"; CurrencyLCY: Record "4") VATAmountLCY: Decimal
    begin
        IF (AmountLCY = VATEntry.Base) OR (VATEntry.Base = 0) THEN BEGIN
            VATAmountLCY := VATEntry.Amount;
            VATEntry.DELETE;
        END ELSE BEGIN
            VATAmountLCY :=
              ROUND(
                VATEntry.Amount * AmountLCY / VATEntry.Base,
                CurrencyLCY."Amount Rounding Precision",
                CurrencyLCY.VATRoundingDirection);
            VATEntry.Base := VATEntry.Base - AmountLCY;
            VATEntry.Amount := VATEntry.Amount - VATAmountLCY;
            VATEntry.MODIFY;
        END;
    end;

    local procedure InsertDtldCustLedgEntryUnapply(GenJnlLine: Record "81"; var NewDtldCustLedgEntry: Record "379"; OldDtldCustLedgEntry: Record "379"; var NextDtldLedgEntryNo: Integer)
    begin
        NewDtldCustLedgEntry := OldDtldCustLedgEntry;
        NewDtldCustLedgEntry."Entry No." := NextDtldLedgEntryNo;
        NewDtldCustLedgEntry."Posting Date" := GenJnlLine."Posting Date";
        NewDtldCustLedgEntry."Transaction No." := NextTransactionNo;
        NewDtldCustLedgEntry."Application No." := 0;
        NewDtldCustLedgEntry.Amount := -OldDtldCustLedgEntry.Amount;
        NewDtldCustLedgEntry."Amount (LCY)" := -OldDtldCustLedgEntry."Amount (LCY)";
        NewDtldCustLedgEntry."Debit Amount" := -OldDtldCustLedgEntry."Debit Amount";
        NewDtldCustLedgEntry."Credit Amount" := -OldDtldCustLedgEntry."Credit Amount";
        NewDtldCustLedgEntry."Debit Amount (LCY)" := -OldDtldCustLedgEntry."Debit Amount (LCY)";
        NewDtldCustLedgEntry."Credit Amount (LCY)" := -OldDtldCustLedgEntry."Credit Amount (LCY)";
        NewDtldCustLedgEntry.Unapplied := TRUE;
        NewDtldCustLedgEntry."Unapplied by Entry No." := OldDtldCustLedgEntry."Entry No.";
        NewDtldCustLedgEntry."Document No." := GenJnlLine."Document No.";
        NewDtldCustLedgEntry."Source Code" := GenJnlLine."Source Code";
        NewDtldCustLedgEntry."User ID" := USERID;
        NewDtldCustLedgEntry."Model Code" := GenJnlLine."Model Code";
        NewDtldCustLedgEntry.INSERT(TRUE);
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    end;

    local procedure InsertDtldVendLedgEntryUnapply(GenJnlLine: Record "81"; var NewDtldVendLedgEntry: Record "380"; OldDtldVendLedgEntry: Record "380"; var NextDtldLedgEntryNo: Integer)
    begin
        NewDtldVendLedgEntry := OldDtldVendLedgEntry;
        NewDtldVendLedgEntry."Entry No." := NextDtldLedgEntryNo;
        NewDtldVendLedgEntry."Posting Date" := GenJnlLine."Posting Date";
        NewDtldVendLedgEntry."Transaction No." := NextTransactionNo;
        NewDtldVendLedgEntry."Application No." := 0;
        NewDtldVendLedgEntry.Amount := -OldDtldVendLedgEntry.Amount;
        NewDtldVendLedgEntry."Amount (LCY)" := -OldDtldVendLedgEntry."Amount (LCY)";
        NewDtldVendLedgEntry."Debit Amount" := -OldDtldVendLedgEntry."Debit Amount";
        NewDtldVendLedgEntry."Credit Amount" := -OldDtldVendLedgEntry."Credit Amount";
        NewDtldVendLedgEntry."Debit Amount (LCY)" := -OldDtldVendLedgEntry."Debit Amount (LCY)";
        NewDtldVendLedgEntry."Credit Amount (LCY)" := -OldDtldVendLedgEntry."Credit Amount (LCY)";
        NewDtldVendLedgEntry.Unapplied := TRUE;
        NewDtldVendLedgEntry."Unapplied by Entry No." := OldDtldVendLedgEntry."Entry No.";
        NewDtldVendLedgEntry."Document No." := GenJnlLine."Document No.";
        NewDtldVendLedgEntry."Source Code" := GenJnlLine."Source Code";
        NewDtldVendLedgEntry."User ID" := USERID;
        NewDtldVendLedgEntry.INSERT(TRUE);
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    end;

    local procedure InsertTempVATEntry(GenJnlLine: Record "81"; VATEntry: Record "254"; var TempVATEntryNo: Integer; var TempVATEntry: Record "254" temporary)
    begin
        TempVATEntry := VATEntry;
        TempVATEntry."Entry No." := TempVATEntryNo;
        TempVATEntryNo := TempVATEntryNo + 1;
        TempVATEntry."Closed by Entry No." := 0;
        TempVATEntry.Closed := FALSE;
        TempVATEntry.CopyAmountsFromVATEntry(VATEntry, TRUE);
        TempVATEntry."Posting Date" := GenJnlLine."Posting Date";
        TempVATEntry."Document No." := GenJnlLine."Document No.";
        TempVATEntry."User ID" := USERID;
        TempVATEntry."Transaction No." := NextTransactionNo;
        TempVATEntry.INSERT;
    end;

    local procedure ProcessTempVATEntry(DtldCVLedgEntryBuf: Record "383"; var TempVATEntry: Record "254" temporary)
    var
        VATEntrySaved: Record "254";
        VATBaseSum: array[3] of Decimal;
        DeductedVATBase: Decimal;
        EntryNoBegin: array[3] of Integer;
        i: Integer;
    begin
        IF NOT (DtldCVLedgEntryBuf."Entry Type" IN
                [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)",
                 DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)",
                 DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"])
        THEN
            EXIT;

        DeductedVATBase := 0;
        TempVATEntry.RESET;
        TempVATEntry.SETRANGE("Entry No.", 0, 999999);
        TempVATEntry.SETRANGE("Gen. Bus. Posting Group", DtldCVLedgEntryBuf."Gen. Bus. Posting Group");
        TempVATEntry.SETRANGE("Gen. Prod. Posting Group", DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
        TempVATEntry.SETRANGE("VAT Bus. Posting Group", DtldCVLedgEntryBuf."VAT Bus. Posting Group");
        TempVATEntry.SETRANGE("VAT Prod. Posting Group", DtldCVLedgEntryBuf."VAT Prod. Posting Group");
        IF TempVATEntry.FINDSET THEN
            REPEAT
                CASE TRUE OF
                    VATBaseSum[3] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                        i := 4;
                    VATBaseSum[2] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                        i := 3;
                    VATBaseSum[1] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                        i := 2;
                    TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                        i := 1;
                    ELSE
                        i := 0;
                END;
                IF i > 0 THEN BEGIN
                    TempVATEntry.RESET;
                    IF i > 1 THEN BEGIN
                        IF EntryNoBegin[i - 1] < TempVATEntry."Entry No." THEN
                            TempVATEntry.SETRANGE("Entry No.", EntryNoBegin[i - 1], TempVATEntry."Entry No.")
                        ELSE
                            TempVATEntry.SETRANGE("Entry No.", TempVATEntry."Entry No.", EntryNoBegin[i - 1]);
                    END ELSE
                        TempVATEntry.SETRANGE("Entry No.", TempVATEntry."Entry No.");
                    TempVATEntry.FINDSET;
                    REPEAT
                        VATEntrySaved := TempVATEntry;
                        CASE DtldCVLedgEntryBuf."Entry Type" OF
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                                TempVATEntry.RENAME(TempVATEntry."Entry No." + 2000000);
                            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                                TempVATEntry.RENAME(TempVATEntry."Entry No." + 1000000);
                        END;
                        TempVATEntry := VATEntrySaved;
                        DeductedVATBase += TempVATEntry.Base;
                    UNTIL TempVATEntry.NEXT = 0;
                    FOR i := 1 TO 3 DO BEGIN
                        VATBaseSum[i] := 0;
                        EntryNoBegin[i] := 0;
                    END;
                    TempVATEntry.SETRANGE("Entry No.", 0, 999999);
                END ELSE BEGIN
                    VATBaseSum[3] += TempVATEntry.Base;
                    VATBaseSum[2] := VATBaseSum[1] + TempVATEntry.Base;
                    VATBaseSum[1] := TempVATEntry.Base;
                    IF EntryNoBegin[3] > 0 THEN
                        EntryNoBegin[3] := TempVATEntry."Entry No.";
                    EntryNoBegin[2] := EntryNoBegin[1];
                    EntryNoBegin[1] := TempVATEntry."Entry No.";
                END;
            UNTIL TempVATEntry.NEXT = 0;
    end;

    local procedure UpdateCustLedgEntry(DtldCustLedgEntry: Record "379")
    var
        CustLedgEntry: Record "21";
    begin
        IF DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."Entry Type"::Application THEN
            EXIT;

        CustLedgEntry.GET(DtldCustLedgEntry."Cust. Ledger Entry No.");
        CustLedgEntry."Remaining Pmt. Disc. Possible" := DtldCustLedgEntry."Remaining Pmt. Disc. Possible";
        CustLedgEntry."Max. Payment Tolerance" := DtldCustLedgEntry."Max. Payment Tolerance";
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        IF NOT CustLedgEntry.Open THEN BEGIN
            CustLedgEntry.Open := TRUE;
            CustLedgEntry."Closed by Entry No." := 0;
            CustLedgEntry."Closed at Date" := 0D;
            CustLedgEntry."Closed by Amount" := 0;
            CustLedgEntry."Closed by Amount (LCY)" := 0;
            CustLedgEntry."Closed by Currency Code" := '';
            CustLedgEntry."Closed by Currency Amount" := 0;
            CustLedgEntry."Pmt. Disc. Given (LCY)" := 0;
            CustLedgEntry."Pmt. Tolerance (LCY)" := 0;
            CustLedgEntry."Calculate Interest" := FALSE;
        END;
        CustLedgEntry.MODIFY;
    end;

    local procedure UpdateVendLedgEntry(DtldVendLedgEntry: Record "380")
    var
        VendLedgEntry: Record "25";
    begin
        IF DtldVendLedgEntry."Entry Type" <> DtldVendLedgEntry."Entry Type"::Application THEN
            EXIT;

        VendLedgEntry.GET(DtldVendLedgEntry."Vendor Ledger Entry No.");
        VendLedgEntry."Remaining Pmt. Disc. Possible" := DtldVendLedgEntry."Remaining Pmt. Disc. Possible";
        VendLedgEntry."Max. Payment Tolerance" := DtldVendLedgEntry."Max. Payment Tolerance";
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        IF NOT VendLedgEntry.Open THEN BEGIN
            VendLedgEntry.Open := TRUE;
            VendLedgEntry."Closed by Entry No." := 0;
            VendLedgEntry."Closed at Date" := 0D;
            VendLedgEntry."Closed by Amount" := 0;
            VendLedgEntry."Closed by Amount (LCY)" := 0;
            VendLedgEntry."Closed by Currency Code" := '';
            VendLedgEntry."Closed by Currency Amount" := 0;
            VendLedgEntry."Pmt. Disc. Rcd.(LCY)" := 0;
            VendLedgEntry."Pmt. Tolerance (LCY)" := 0;
        END;
        VendLedgEntry.MODIFY;
    end;

    local procedure UpdateCalcInterest(var CVLedgEntryBuf: Record "382")
    var
        CustLedgEntry: Record "21";
        CVLedgEntryBuf2: Record "382";
    begin
        IF CustLedgEntry.GET(CVLedgEntryBuf."Closed by Entry No.") THEN BEGIN
            CVLedgEntryBuf2.TRANSFERFIELDS(CustLedgEntry);
            UpdateCalcInterest2(CVLedgEntryBuf, CVLedgEntryBuf2);
        END;
        CustLedgEntry.SETCURRENTKEY("Closed by Entry No.");
        CustLedgEntry.SETRANGE("Closed by Entry No.", CVLedgEntryBuf."Entry No.");
        IF CustLedgEntry.FINDSET THEN
            REPEAT
                CVLedgEntryBuf2.TRANSFERFIELDS(CustLedgEntry);
                UpdateCalcInterest2(CVLedgEntryBuf, CVLedgEntryBuf2);
            UNTIL CustLedgEntry.NEXT = 0;
    end;

    local procedure UpdateCalcInterest2(var CVLedgEntryBuf: Record "382"; var CVLedgEntryBuf2: Record "382")
    begin
        IF CVLedgEntryBuf."Due Date" < CVLedgEntryBuf2."Document Date" THEN
            CVLedgEntryBuf."Calculate Interest" := TRUE;
    end;

    local procedure GLCalcAddCurrency(Amount: Decimal; AddCurrAmount: Decimal; OldAddCurrAmount: Decimal; UseAddCurrAmount: Boolean; GenJnlLine: Record "81"): Decimal
    begin
        IF (AddCurrencyCode <> '') AND
           (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None)
        THEN BEGIN
            IF (GenJnlLine."Source Currency Code" = AddCurrencyCode) AND UseAddCurrAmount THEN
                EXIT(AddCurrAmount);

            EXIT(ExchangeAmtLCYToFCY2(Amount));
        END;
        EXIT(OldAddCurrAmount);
    end;

    local procedure HandleAddCurrResidualGLEntry(GenJnlLine: Record "81"; Amount: Decimal; AmountAddCurr: Decimal)
    var
        GLAcc: Record "15";
        GLEntry: Record "17";
    begin
        IF AddCurrencyCode = '' THEN
            EXIT;

        TotalAddCurrAmount := TotalAddCurrAmount + AmountAddCurr;
        TotalAmount := TotalAmount + Amount;

        IF (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None) AND
           (TotalAmount = 0) AND (TotalAddCurrAmount <> 0) AND
           CheckNonAddCurrCodeOccurred(GenJnlLine."Source Currency Code")
        THEN BEGIN
            GLEntry.INIT;
            GLEntry.CopyFromGenJnlLine(GenJnlLine);
            GLEntry."External Document No." := '';
            GLEntry.Description :=
              COPYSTR(
                STRSUBSTNO(
                  ResidualRoundingErr,
                  GLEntry.FIELDCAPTION("Additional-Currency Amount")),
                1, MAXSTRLEN(GLEntry.Description));
            GLEntry."Source Type" := 0;
            GLEntry."Source No." := '';
            GLEntry."Job No." := '';
            GLEntry.Quantity := 0;
            GLEntry."Entry No." := NextEntryNo;
            GLEntry."Transaction No." := NextTransactionNo;
            IF TotalAddCurrAmount < 0 THEN
                GLEntry."G/L Account No." := AddCurrency."Residual Losses Account"
            ELSE
                GLEntry."G/L Account No." := AddCurrency."Residual Gains Account";
            GLEntry.Amount := 0;
            GLEntry."System-Created Entry" := TRUE;
            GLEntry."Additional-Currency Amount" := -TotalAddCurrAmount;
            GLAcc.GET(GLEntry."G/L Account No.");
            GLAcc.TESTFIELD(Blocked, FALSE);
            GLAcc.TESTFIELD("Account Type", GLAcc."Account Type"::Posting);
            InsertGLEntry(GenJnlLine, GLEntry, FALSE);

            CheckGLAccDimError(GenJnlLine, GLEntry."G/L Account No.");

            TotalAddCurrAmount := 0;
        END;
    end;

    local procedure CalcLCYToAddCurr(AmountLCY: Decimal): Decimal
    begin
        IF AddCurrencyCode = '' THEN
            EXIT;

        EXIT(ExchangeAmtLCYToFCY2(AmountLCY));
    end;

    local procedure GetCurrencyExchRate(GenJnlLine: Record "81")
    var
        NewCurrencyDate: Date;
    begin
        IF AddCurrencyCode = '' THEN
            EXIT;

        AddCurrency.GET(AddCurrencyCode);
        AddCurrency.TESTFIELD("Amount Rounding Precision");
        AddCurrency.TESTFIELD("Residual Gains Account");
        AddCurrency.TESTFIELD("Residual Losses Account");

        NewCurrencyDate := GenJnlLine."Posting Date";
        IF GenJnlLine."Reversing Entry" THEN
            NewCurrencyDate := NewCurrencyDate - 1;
        IF (NewCurrencyDate <> CurrencyDate) OR
           UseCurrFactorOnly
        THEN BEGIN
            UseCurrFactorOnly := FALSE;
            CurrencyDate := NewCurrencyDate;
            CurrencyFactor :=
              CurrExchRate.ExchangeRate(CurrencyDate, AddCurrencyCode);
        END;
        IF (GenJnlLine."FA Add.-Currency Factor" <> 0) AND
           (GenJnlLine."FA Add.-Currency Factor" <> CurrencyFactor)
        THEN BEGIN
            UseCurrFactorOnly := TRUE;
            CurrencyDate := 0D;
            CurrencyFactor := GenJnlLine."FA Add.-Currency Factor";
        END;
    end;

    local procedure ExchangeAmtLCYToFCY2(Amount: Decimal): Decimal
    begin
        IF UseCurrFactorOnly THEN
            EXIT(
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCYOnlyFactor(Amount, CurrencyFactor),
                AddCurrency."Amount Rounding Precision"));
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              CurrencyDate, AddCurrencyCode, Amount, CurrencyFactor),
            AddCurrency."Amount Rounding Precision"));
    end;

    local procedure CheckNonAddCurrCodeOccurred(CurrencyCode: Code[10]): Boolean
    begin
        NonAddCurrCodeOccured :=
          NonAddCurrCodeOccured OR (AddCurrencyCode <> CurrencyCode);
        EXIT(NonAddCurrCodeOccured);
    end;

    local procedure TotalVATAmountOnJnlLines(GenJnlLine: Record "81") TotalVATAmount: Decimal
    var
        GenJnlLine2: Record "81";
    begin
        GenJnlLine2.SETRANGE("Source Code", GenJnlLine."Source Code");
        GenJnlLine2.SETRANGE("Document No.", GenJnlLine."Document No.");
        GenJnlLine2.SETRANGE("Posting Date", GenJnlLine."Posting Date");
        IF GenJnlLine2.FINDSET THEN
            REPEAT
                TotalVATAmount += GenJnlLine2."VAT Amount (LCY)" - GenJnlLine2."Bal. VAT Amount (LCY)";
            UNTIL GenJnlLine2.NEXT = 0;
        EXIT(TotalVATAmount);
    end;

    [Scope('Internal')]
    procedure SetGLRegReverse(var ReverseGLReg: Record "45")
    begin
        GLReg.Reversed := TRUE;
        ReverseGLReg := GLReg;
    end;

    local procedure InsertVATEntriesFromTemp(var DtldCVLedgEntryBuf: Record "383"; GLEntry: Record "17")
    var
        Complete: Boolean;
        LinkedAmount: Decimal;
        FirstEntryNo: Integer;
        LastEntryNo: Integer;
    begin
        TempVATEntry.RESET;
        TempVATEntry.SETRANGE("Gen. Bus. Posting Group", GLEntry."Gen. Bus. Posting Group");
        TempVATEntry.SETRANGE("Gen. Prod. Posting Group", GLEntry."Gen. Prod. Posting Group");
        TempVATEntry.SETRANGE("VAT Bus. Posting Group", GLEntry."VAT Bus. Posting Group");
        TempVATEntry.SETRANGE("VAT Prod. Posting Group", GLEntry."VAT Prod. Posting Group");
        CASE DtldCVLedgEntryBuf."Entry Type" OF
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)":
                BEGIN
                    FirstEntryNo := 0;
                    LastEntryNo := 999999;
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                BEGIN
                    FirstEntryNo := 1000000;
                    LastEntryNo := 1999999;
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)":
                BEGIN
                    FirstEntryNo := 2000000;
                    LastEntryNo := 2999999;
                END;
        END;
        TempVATEntry.SETRANGE("Entry No.", FirstEntryNo, LastEntryNo);
        IF TempVATEntry.FINDSET THEN
            REPEAT
                VATEntry := TempVATEntry;
                VATEntry."Entry No." := NextVATEntryNo;
                VATEntry.INSERT(TRUE);
                NextVATEntryNo := NextVATEntryNo + 1;
                IF VATEntry."Unrealized VAT Entry No." = 0 THEN
                    GLEntryVATEntryLink.InsertLink(GLEntry."Entry No.", VATEntry."Entry No.");
                IF VATEntry."VAT Calculation Type" = VATEntry."VAT Calculation Type"::"Full VAT" THEN BEGIN
                    LinkedAmount += VATEntry.Amount;
                    Complete := LinkedAmount = -DtldCVLedgEntryBuf."VAT Amount (LCY)";
                END ELSE BEGIN
                    LinkedAmount += VATEntry.Base;
                    Complete := LinkedAmount = -DtldCVLedgEntryBuf."Amount (LCY)";
                END;
                LastEntryNo := TempVATEntry."Entry No.";
            UNTIL Complete OR (TempVATEntry.NEXT = 0);

        TempVATEntry.SETRANGE("Entry No.", FirstEntryNo, LastEntryNo);
        TempVATEntry.DELETEALL;
    end;

    local procedure ABSMin(Decimal1: Decimal; Decimal2: Decimal): Decimal
    begin
        IF ABS(Decimal1) < ABS(Decimal2) THEN
            EXIT(Decimal1);
        EXIT(Decimal2);
    end;

    [Scope('Internal')]
    procedure ABSMax(Decimal1: Decimal; Decimal2: Decimal): Decimal
    begin
        IF ABS(Decimal1) > ABS(Decimal2) THEN
            EXIT(Decimal1);
        EXIT(Decimal2);
    end;

    local procedure GetApplnRoundPrecision(NewCVLedgEntryBuf: Record "382"; OldCVLedgEntryBuf: Record "382"): Decimal
    var
        ApplnCurrency: Record "4";
        CurrencyCode: Code[10];
    begin
        IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
            CurrencyCode := NewCVLedgEntryBuf."Currency Code"
        ELSE
            CurrencyCode := OldCVLedgEntryBuf."Currency Code";
        IF CurrencyCode = '' THEN
            EXIT(0);
        ApplnCurrency.GET(CurrencyCode);
        IF ApplnCurrency."Appln. Rounding Precision" <> 0 THEN
            EXIT(ApplnCurrency."Appln. Rounding Precision");
        EXIT(GLSetup."Appln. Rounding Precision");
    end;

    local procedure GetGLSetup()
    begin
        IF GLSetupRead THEN
            EXIT;

        GLSetup.GET;
        GLSetupRead := TRUE;

        AddCurrencyCode := GLSetup."Additional Reporting Currency";
    end;

    local procedure ReadGLSetup(var NewGLSetup: Record "98")
    begin
        NewGLSetup := GLSetup;
    end;

    local procedure CheckSalesExtDocNo(GenJnlLine: Record "81")
    var
        SalesSetup: Record "311";
    begin
        SalesSetup.GET;
        IF NOT SalesSetup."Ext. Doc. No. Mandatory" THEN
            EXIT;

        IF GenJnlLine."Document Type" IN
           [GenJnlLine."Document Type"::Invoice,
            GenJnlLine."Document Type"::"Credit Memo",
            GenJnlLine."Document Type"::Payment,
            GenJnlLine."Document Type"::Refund,
            GenJnlLine."Document Type"::" "]
        THEN
            GenJnlLine.TESTFIELD("External Document No.");
    end;

    local procedure CheckPurchExtDocNo(GenJnlLine: Record "81")
    var
        PurchSetup: Record "312";
        OldVendLedgEntry: Record "25";
    begin
        PurchSetup.GET;
        IF NOT (PurchSetup."Ext. Doc. No. Mandatory" OR (GenJnlLine."External Document No." <> '')) THEN
            EXIT;

        GenJnlLine.TESTFIELD("External Document No.");
        OldVendLedgEntry.RESET;
        OldVendLedgEntry.SETRANGE("External Document No.", GenJnlLine."External Document No.");
        OldVendLedgEntry.SETRANGE("Document Type", GenJnlLine."Document Type");
        OldVendLedgEntry.SETRANGE("Vendor No.", GenJnlLine."Account No.");
        OldVendLedgEntry.SETRANGE(Reversed, FALSE);
        IF NOT OldVendLedgEntry.ISEMPTY THEN
            ERROR(
              PurchaseAlreadyExistsErr,
              GenJnlLine."Document Type", GenJnlLine."External Document No.");
    end;

    local procedure CheckDimValueForDisposal(GenJnlLine: Record "81"; AccountNo: Code[20])
    var
        DimMgt: Codeunit "408";
        TableID: array[10] of Integer;
        AccNo: array[10] of Code[20];
    begin
        IF ((GenJnlLine.Amount = 0) OR (GenJnlLine."Amount (LCY)" = 0)) AND
           (GenJnlLine."FA Posting Type" = GenJnlLine."FA Posting Type"::Disposal)
        THEN BEGIN
            TableID[1] := DimMgt.TypeToTableID1(GenJnlLine."Account Type"::"G/L Account");
            AccNo[1] := AccountNo;
            IF NOT DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") THEN
                ERROR(DimMgt.GetDimValuePostingErr);
        END;
    end;

    [Scope('Internal')]
    procedure SetOverDimErr()
    begin
        OverrideDimErr := TRUE;
    end;

    local procedure CheckGLAccDimError(GenJnlLine: Record "81"; GLAccNo: Code[20])
    var
        DimMgt: Codeunit "408";
        TableID: array[10] of Integer;
        AccNo: array[10] of Code[20];
    begin
        IF (GenJnlLine.Amount = 0) AND (GenJnlLine."Amount (LCY)" = 0) THEN
            EXIT;

        TableID[1] := DATABASE::"G/L Account";
        AccNo[1] := GLAccNo;
        IF DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") THEN
            EXIT;

        IF GenJnlLine."Line No." <> 0 THEN
            ERROR(
              DimensionUsedErr,
              GenJnlLine.TABLECAPTION, GenJnlLine."Journal Template Name",
              GenJnlLine."Journal Batch Name", GenJnlLine."Line No.",
              DimMgt.GetDimValuePostingErr);

        ERROR(DimMgt.GetDimValuePostingErr);
    end;

    local procedure CalculateCurrentBalance(AccountNo: Code[20]; BalAccountNo: Code[20]; InclVATAmount: Boolean; AmountLCY: Decimal; VATAmount: Decimal)
    begin
        IF (AccountNo <> '') AND (BalAccountNo <> '') THEN
            EXIT;

        IF AccountNo = BalAccountNo THEN
            EXIT;

        IF NOT InclVATAmount THEN
            VATAmount := 0;

        IF BalAccountNo <> '' THEN
            CurrentBalance -= AmountLCY + VATAmount
        ELSE
            CurrentBalance += AmountLCY + VATAmount;
    end;

    local procedure GetCurrency(var Currency: Record "4"; CurrencyCode: Code[10])
    begin
        IF Currency.Code <> CurrencyCode THEN BEGIN
            IF CurrencyCode = '' THEN
                CLEAR(Currency)
            ELSE
                Currency.GET(CurrencyCode);
        END;
    end;

    local procedure CollectAdjustment(var AdjAmount: array[4] of Decimal; Amount: Decimal; AmountAddCurr: Decimal)
    var
        Offset: Integer;
    begin
        Offset := GetAdjAmountOffset(Amount, AmountAddCurr);
        AdjAmount[Offset] += Amount;
        AdjAmount[Offset + 1] += AmountAddCurr;
    end;

    local procedure HandleDtldAdjustment(GenJnlLine: Record "81"; var GLEntry: Record "17"; AdjAmount: array[4] of Decimal; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAccNo: Code[20])
    begin
        IF NOT PostDtldAdjustment(
             GenJnlLine, GLEntry, AdjAmount,
             TotalAmountLCY, TotalAmountAddCurr, GLAccNo,
             GetAdjAmountOffset(TotalAmountLCY, TotalAmountAddCurr))
        THEN
            InitGLEntry(GenJnlLine, GLEntry, GLAccNo, TotalAmountLCY, TotalAmountAddCurr, TRUE, TRUE);
    end;

    local procedure PostDtldAdjustment(GenJnlLine: Record "81"; var GLEntry: Record "17"; AdjAmount: array[4] of Decimal; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAcc: Code[20]; ArrayIndex: Integer): Boolean
    begin
        IF (GenJnlLine."Bal. Account No." <> '') AND
           ((AdjAmount[ArrayIndex] <> 0) OR (AdjAmount[ArrayIndex + 1] <> 0)) AND
           ((TotalAmountLCY + AdjAmount[ArrayIndex] <> 0) OR (TotalAmountAddCurr + AdjAmount[ArrayIndex + 1] <> 0))
        THEN BEGIN
            CreateGLEntryBalAcc(
              GenJnlLine, GLAcc, -AdjAmount[ArrayIndex], -AdjAmount[ArrayIndex + 1],
              GenJnlLine."Bal. Account Type", GenJnlLine."Bal. Account No.");
            InitGLEntry(GenJnlLine, GLEntry,
              GLAcc, TotalAmountLCY + AdjAmount[ArrayIndex],
              TotalAmountAddCurr + AdjAmount[ArrayIndex + 1], TRUE, TRUE);
            AdjAmount[ArrayIndex] := 0;
            AdjAmount[ArrayIndex + 1] := 0;
            EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    local procedure GetAdjAmountOffset(Amount: Decimal; AmountACY: Decimal): Integer
    begin
        IF (Amount > 0) OR (Amount = 0) AND (AmountACY > 0) THEN
            EXIT(1);
        EXIT(3);
    end;

    [Scope('Internal')]
    procedure GetNextEntryNo(): Integer
    begin
        EXIT(NextEntryNo);
    end;

    [Scope('Internal')]
    procedure GetNextTransactionNo(): Integer
    begin
        EXIT(NextTransactionNo);
    end;

    [Scope('Internal')]
    procedure GetNextVATEntryNo(): Integer
    begin
        EXIT(NextVATEntryNo);
    end;

    [Scope('Internal')]
    procedure IncrNextVATEntryNo()
    begin
        NextVATEntryNo := NextVATEntryNo + 1;
    end;

    local procedure IsNotPayment(DocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund): Boolean
    begin
        EXIT(DocumentType IN [DocumentType::Invoice,
                              DocumentType::"Credit Memo",
                              DocumentType::"Finance Charge Memo",
                              DocumentType::Reminder]);
    end;

    local procedure IsTempGLEntryBufEmpty(): Boolean
    begin
        EXIT(TempGLEntryBuf.ISEMPTY);
    end;

    local procedure IsVATAdjustment(EntryType: Option): Boolean
    var
        DtldCVLedgEntryBuf: Record "383";
    begin
        EXIT(EntryType IN [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Adjustment)",
                           DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                           DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]);
    end;

    local procedure IsVATExcluded(EntryType: Option): Boolean
    var
        DtldCVLedgEntryBuf: Record "383";
    begin
        EXIT(EntryType IN [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)",
                           DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)",
                           DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"]);
    end;

    local procedure UpdateGLEntryNo(var GLEntryNo: Integer; var SavedEntryNo: Integer)
    begin
        IF SavedEntryNo <> 0 THEN BEGIN
            GLEntryNo := SavedEntryNo;
            NextEntryNo := NextEntryNo - 1;
            SavedEntryNo := 0;
        END;
    end;

    local procedure UpdateTotalAmounts(var TempInvPostBuf: Record "49" temporary; DimSetID: Integer; AmountToCollect: Decimal; AmountACYToCollect: Decimal)
    begin
        TempInvPostBuf.SETRANGE("Dimension Set ID", DimSetID);
        IF TempInvPostBuf.FINDFIRST THEN BEGIN
            TempInvPostBuf.Amount += AmountToCollect;
            TempInvPostBuf."Amount (ACY)" += AmountACYToCollect;
            TempInvPostBuf.MODIFY;
        END ELSE BEGIN
            TempInvPostBuf.INIT;
            TempInvPostBuf."Dimension Set ID" := DimSetID;
            TempInvPostBuf.Amount := AmountToCollect;
            TempInvPostBuf."Amount (ACY)" := AmountACYToCollect;
            TempInvPostBuf.INSERT;
        END;
    end;

    local procedure CreateGLEntriesForTotalAmountsUnapply(GenJnlLine: Record "81"; var TempInvPostBuf: Record "49" temporary; Account: Code[20])
    var
        DimMgt: Codeunit "408";
    begin
        TempInvPostBuf.SETRANGE("Dimension Set ID");
        IF TempInvPostBuf.FINDSET THEN
            REPEAT
                IF (TempInvPostBuf.Amount <> 0) OR
                   (TempInvPostBuf."Amount (ACY)" <> 0) AND (GLSetup."Additional Reporting Currency" <> '')
                THEN BEGIN
                    DimMgt.UpdateGenJnlLineDim(GenJnlLine, TempInvPostBuf."Dimension Set ID");
                    CreateGLEntry(GenJnlLine, Account, TempInvPostBuf.Amount, TempInvPostBuf."Amount (ACY)", TRUE);
                END;
            UNTIL TempInvPostBuf.NEXT = 0;
    end;

    local procedure CreateGLEntriesForTotalAmounts(GenJnlLine: Record "81"; var InvPostBuf: Record "49"; AdjAmountBuf: array[4] of Decimal; SavedEntryNo: Integer; GLAccNo: Code[20]; LedgEntryInserted: Boolean)
    var
        DimMgt: Codeunit "408";
        GLEntryInserted: Boolean;
    begin
        GLEntryInserted := FALSE;

        InvPostBuf.RESET;
        IF InvPostBuf.FINDSET THEN
            REPEAT
                IF (InvPostBuf.Amount <> 0) OR (InvPostBuf."Amount (ACY)" <> 0) AND (AddCurrencyCode <> '') THEN BEGIN
                    DimMgt.UpdateGenJnlLineDim(GenJnlLine, InvPostBuf."Dimension Set ID");
                    CreateGLEntryForTotalAmounts(GenJnlLine, InvPostBuf.Amount, InvPostBuf."Amount (ACY)", AdjAmountBuf, SavedEntryNo, GLAccNo);
                    GLEntryInserted := TRUE;
                END;
            UNTIL InvPostBuf.NEXT = 0;

        IF NOT GLEntryInserted AND LedgEntryInserted THEN
            CreateGLEntryForTotalAmounts(GenJnlLine, 0, 0, AdjAmountBuf, SavedEntryNo, GLAccNo);
    end;

    local procedure CreateGLEntryForTotalAmounts(GenJnlLine: Record "81"; Amount: Decimal; AmountACY: Decimal; AdjAmountBuf: array[4] of Decimal; var SavedEntryNo: Integer; GLAccNo: Code[20])
    var
        GLEntry: Record "17";
    begin
        HandleDtldAdjustment(GenJnlLine, GLEntry, AdjAmountBuf, Amount, AmountACY, GLAccNo);
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        UpdateGLEntryNo(GLEntry."Entry No.", SavedEntryNo);
        InsertGLEntry(GenJnlLine, GLEntry, TRUE);
    end;

    local procedure SetAddCurrForUnapplication(var DtldCVLedgEntryBuf: Record "383")
    begin
        IF NOT (DtldCVLedgEntryBuf."Entry Type" IN [DtldCVLedgEntryBuf."Entry Type"::Application, DtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss",
                         DtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain", DtldCVLedgEntryBuf."Entry Type"::"Realized Loss",
                         DtldCVLedgEntryBuf."Entry Type"::"Realized Gain", DtldCVLedgEntryBuf."Entry Type"::"Correction of Remaining Amount"])
THEN
            IF (DtldCVLedgEntryBuf."Entry Type" = DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding") OR
               ((AddCurrencyCode <> '') AND (AddCurrencyCode = DtldCVLedgEntryBuf."Currency Code"))
            THEN
                DtldCVLedgEntryBuf."Additional-Currency Amount" := DtldCVLedgEntryBuf.Amount
            ELSE
                DtldCVLedgEntryBuf."Additional-Currency Amount" := CalcAddCurrForUnapplication(DtldCVLedgEntryBuf."Posting Date", DtldCVLedgEntryBuf."Amount (LCY)");
    end;

    local procedure GetAppliedAmountFromBuffers(NewCVLedgEntryBuf: Record "382"; OldCVLedgEntryBuf: Record "382"): Decimal
    begin
        IF (((NewCVLedgEntryBuf."Document Type" = NewCVLedgEntryBuf."Document Type"::Payment) AND
             (OldCVLedgEntryBuf."Document Type" = OldCVLedgEntryBuf."Document Type"::"Credit Memo")) OR
            ((NewCVLedgEntryBuf."Document Type" = NewCVLedgEntryBuf."Document Type"::Refund) AND
             (OldCVLedgEntryBuf."Document Type" = OldCVLedgEntryBuf."Document Type"::Invoice))) AND
           (ABS(NewCVLedgEntryBuf."Remaining Amount") < ABS(OldCVLedgEntryBuf."Amount to Apply"))
        THEN
            EXIT(ABSMax(NewCVLedgEntryBuf."Remaining Amount", -OldCVLedgEntryBuf."Amount to Apply"));
        EXIT(ABSMin(NewCVLedgEntryBuf."Remaining Amount", -OldCVLedgEntryBuf."Amount to Apply"));
    end;

    local procedure PostDeferral(var GenJournalLine: Record "81"; AccountNumber: Code[20])
    var
        DeferralTemplate: Record "1700";
        DeferralHeader: Record "1701";
        DeferralLine: Record "1702";
        GLEntry: Record "17";
        CurrExchRate: Record "330";
        DeferralUtilities: Codeunit "1720";
        PerPostDate: Date;
        PeriodicCount: Integer;
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
        EmptyDeferralLine: Boolean;
    begin
        IF GenJournalLine."Source Type" IN [GenJournalLine."Source Type"::Vendor, GenJournalLine."Source Type"::Customer] THEN
            // Purchasing and Sales, respectively
            // We can create these types directly from the GL window, need to make sure we don't already have a deferral schedule
            // created for this GL Trx before handing it off to sales/purchasing subsystem
            IF GenJournalLine."Source Code" <> GLSourceCode THEN BEGIN
                PostDeferralPostBuffer(GenJournalLine);
                EXIT;
            END;

        IF DeferralHeader.GET(DeferralDocType::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.") THEN BEGIN
            EmptyDeferralLine := FALSE;
            // Get the range of detail records for this schedule
            DeferralLine.SETRANGE("Deferral Doc. Type", DeferralDocType::"G/L");
            DeferralLine.SETRANGE("Gen. Jnl. Template Name", GenJournalLine."Journal Template Name");
            DeferralLine.SETRANGE("Gen. Jnl. Batch Name", GenJournalLine."Journal Batch Name");
            DeferralLine.SETRANGE("Document Type", 0);
            DeferralLine.SETRANGE("Document No.", '');
            DeferralLine.SETRANGE("Line No.", GenJournalLine."Line No.");
            IF DeferralLine.FINDSET THEN
                REPEAT
                    IF DeferralLine.Amount = 0.0 THEN
                        EmptyDeferralLine := TRUE;
                UNTIL (DeferralLine.NEXT = 0) OR EmptyDeferralLine;
            IF EmptyDeferralLine THEN
                ERROR(ZeroDeferralAmtErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");
            DeferralHeader."Amount to Defer (LCY)" :=
              ROUND(CurrExchRate.ExchangeAmtFCYToLCY(GenJournalLine."Posting Date", GenJournalLine."Currency Code",
                  DeferralHeader."Amount to Defer", GenJournalLine."Currency Factor"));
            DeferralHeader.MODIFY;
        END;

        DeferralUtilities.RoundDeferralAmount(
          DeferralHeader,
          GenJournalLine."Currency Code", GenJournalLine."Currency Factor", GenJournalLine."Posting Date", AmtToDefer, AmtToDeferACY);

        DeferralTemplate.GET(GenJournalLine."Deferral Code");
        DeferralTemplate.TESTFIELD("Deferral Account");
        DeferralTemplate.TESTFIELD("Deferral %");

        // Get the Deferral Header table so we know the amount to defer...
        // Assume straight GL posting
        IF DeferralHeader.GET(DeferralDocType::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.") THEN BEGIN
            // Get the range of detail records for this schedule
            DeferralLine.SETRANGE("Deferral Doc. Type", DeferralDocType::"G/L");
            DeferralLine.SETRANGE("Gen. Jnl. Template Name", GenJournalLine."Journal Template Name");
            DeferralLine.SETRANGE("Gen. Jnl. Batch Name", GenJournalLine."Journal Batch Name");
            DeferralLine.SETRANGE("Document Type", 0);
            DeferralLine.SETRANGE("Document No.", '');
            DeferralLine.SETRANGE("Line No.", GenJournalLine."Line No.");
        END ELSE
            ERROR(NoDeferralScheduleErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");

        InitGLEntry(GenJournalLine, GLEntry,
          AccountNumber,
          -DeferralHeader."Amount to Defer (LCY)",
          -DeferralHeader."Amount to Defer", TRUE, TRUE);
        GLEntry.Description := GenJournalLine.Description;
        InsertGLEntry(GenJournalLine, GLEntry, TRUE);

        InitGLEntry(GenJournalLine, GLEntry,
          DeferralTemplate."Deferral Account",
          DeferralHeader."Amount to Defer (LCY)",
          DeferralHeader."Amount to Defer", TRUE, TRUE);
        GLEntry.Description := GenJournalLine.Description;
        InsertGLEntry(GenJournalLine, GLEntry, TRUE);

        // Here we want to get the Deferral Details table range and loop through them...
        IF DeferralLine.FINDSET THEN BEGIN
            PeriodicCount := 1;
            REPEAT
                PerPostDate := DeferralLine."Posting Date";
                IF GenJnlCheckLine.DateNotAllowed(PerPostDate) THEN
                    ERROR(InvalidPostingDateErr, PerPostDate);

                InitGLEntry(GenJournalLine, GLEntry, AccountNumber, DeferralLine."Amount (LCY)",
                  DeferralLine.Amount,
                  TRUE, TRUE);
                GLEntry."Posting Date" := PerPostDate;
                GLEntry.Description := DeferralLine.Description;
                InsertGLEntry(GenJournalLine, GLEntry, TRUE);

                InitGLEntry(GenJournalLine, GLEntry,
                  DeferralTemplate."Deferral Account", -DeferralLine."Amount (LCY)",
                  -DeferralLine.Amount,
                  TRUE, TRUE);
                GLEntry."Posting Date" := PerPostDate;
                GLEntry.Description := DeferralLine.Description;
                InsertGLEntry(GenJournalLine, GLEntry, TRUE);
                PeriodicCount := PeriodicCount + 1;
            UNTIL DeferralLine.NEXT = 0;
        END ELSE
            ERROR(NoDeferralScheduleErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");
    end;

    local procedure PostDeferralPostBuffer(GenJournalLine: Record "81")
    var
        DeferralPostBuffer: Record "1703";
        GLEntry: Record "17";
        PostDate: Date;
    begin
        IF GenJournalLine."Source Type" = GenJournalLine."Source Type"::Customer THEN
            DeferralDocType := DeferralDocType::Sales
        ELSE
            DeferralDocType := DeferralDocType::Purchase;

        DeferralPostBuffer.SETRANGE("Deferral Doc. Type", DeferralDocType);
        DeferralPostBuffer.SETRANGE("Document No.", GenJournalLine."Document No.");
        DeferralPostBuffer.SETRANGE("Deferral Line No.", GenJournalLine."Deferral Line No.");

        IF DeferralPostBuffer.FINDSET THEN BEGIN
            REPEAT
                PostDate := DeferralPostBuffer."Posting Date";
                IF GenJnlCheckLine.DateNotAllowed(PostDate) THEN
                    ERROR(InvalidPostingDateErr, PostDate);

                // When no sales/purch amount is entered, the offset was already posted
                IF (DeferralPostBuffer."Sales/Purch Amount" <> 0) OR (DeferralPostBuffer."Sales/Purch Amount (LCY)" <> 0) THEN BEGIN
                    InitGLEntry(GenJournalLine, GLEntry, DeferralPostBuffer."G/L Account",
                      DeferralPostBuffer."Sales/Purch Amount (LCY)",
                      DeferralPostBuffer."Sales/Purch Amount",
                      TRUE, TRUE);
                    GLEntry."Posting Date" := PostDate;
                    GLEntry.Description := DeferralPostBuffer.Description;
                    GLEntry.CopyFromDeferralPostBuffer(DeferralPostBuffer);
                    InsertGLEntry(GenJournalLine, GLEntry, TRUE);
                END;

                InitGLEntry(GenJournalLine, GLEntry,
                  DeferralPostBuffer."Deferral Account",
                  -DeferralPostBuffer."Amount (LCY)",
                  -DeferralPostBuffer.Amount,
                  TRUE, TRUE);
                GLEntry."Posting Date" := PostDate;
                GLEntry.Description := DeferralPostBuffer.Description;
                InsertGLEntry(GenJournalLine, GLEntry, TRUE);
            UNTIL DeferralPostBuffer.NEXT = 0;
            DeferralPostBuffer.DELETEALL;
        END;
    end;

    [Scope('Internal')]
    procedure RemoveDeferralSchedule(GenJournalLine: Record "81")
    var
        DeferralUtilities: Codeunit "1720";
        DeferralDocType: Option Purchase,Sales,"G/L";
    begin
        // Removing deferral schedule after all deferrals for this line have been posted successfully
        DeferralUtilities.DeferralCodeOnDelete(
  DeferralDocType::"G/L",
  GenJournalLine."Journal Template Name",
  GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.");
    end;

    local procedure GetGLSourceCode()
    var
        SourceCodeSetup: Record "242";
    begin
        SourceCodeSetup.GET;
        GLSourceCode := SourceCodeSetup."General Journal";
    end;

    local procedure DeferralPosting(DeferralCode: Code[10]; SourceCode: Code[10]; AccountNo: Code[20]; var GenJournalLine: Record "81"; Balancing: Boolean)
    begin
        IF DeferralCode <> '' THEN
            // Sales and purchasing could have negative amounts, so check for them first...
            IF (SourceCode <> GLSourceCode) AND
             (GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor])
          THEN
                PostDeferralPostBuffer(GenJournalLine)
            ELSE
                // Pure GL trx, only post deferrals if it is not a balancing entry
                IF NOT Balancing THEN
                    PostDeferral(GenJournalLine, AccountNo);
    end;

    local procedure GetPostingAccountNo(VATPostingSetup: Record "325"; VATEntry: Record "254"; UnrealizedVAT: Boolean): Code[20]
    var
        TaxJurisdiction: Record "320";
    begin
        IF VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Sales Tax" THEN BEGIN
            VATEntry.TESTFIELD("Tax Jurisdiction Code");
            TaxJurisdiction.GET(VATEntry."Tax Jurisdiction Code");
            CASE VATEntry.Type OF
                VATEntry.Type::Sale:
                    EXIT(TaxJurisdiction.GetSalesAccount(UnrealizedVAT));
                VATEntry.Type::Purchase:
                    EXIT(TaxJurisdiction.GetPurchAccount(UnrealizedVAT));
            END;
        END;

        CASE VATEntry.Type OF
            VATEntry.Type::Sale:
                EXIT(VATPostingSetup.GetSalesAccount(UnrealizedVAT));
            VATEntry.Type::Purchase:
                EXIT(VATPostingSetup.GetPurchAccount(UnrealizedVAT));
        END;
    end;

    local procedure IsDebitAmount(DtldCVLedgEntryBuf: Record "383"; Unapply: Boolean): Boolean
    var
        VATPostingSetup: Record "325";
        VATAmountCondition: Boolean;
        EntryAmount: Decimal;
    begin
        VATAmountCondition :=
  DtldCVLedgEntryBuf."Entry Type" IN [DtldCVLedgEntryBuf."Entry Type"::"Payment Discount (VAT Excl.)", DtldCVLedgEntryBuf."Entry Type"::"Payment Tolerance (VAT Excl.)",
                   DtldCVLedgEntryBuf."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"];
        IF VATAmountCondition THEN BEGIN
            VATPostingSetup.GET(DtldCVLedgEntryBuf."VAT Bus. Posting Group", DtldCVLedgEntryBuf."VAT Prod. Posting Group");
            VATAmountCondition := VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Full VAT";
        END;
        IF VATAmountCondition THEN
            EntryAmount := DtldCVLedgEntryBuf."VAT Amount (LCY)"
        ELSE
            EntryAmount := DtldCVLedgEntryBuf."Amount (LCY)";
        IF Unapply THEN
            EXIT(EntryAmount > 0);
        EXIT(EntryAmount <= 0);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "81")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitGLRegister(var GLRegister: Record "45"; var GenJournalLine: Record "81")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertGlobalGLEntry(var GLEntry: Record "17")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertGLEntryBuffer(var TempGLEntryBuf: Record "17" temporary; var GenJournalLine: Record "81")
    begin
    end;

    [Scope('Internal')]
    procedure CommissionUpdate(InvNo: Code[20])
    var
        SalesInvHeader: Record "112";
        UserSetup: Record "91";
        Vehicle: Record "25006005";
        Text000: Label 'You are not authorised to post multiple commission for same %1 (%2).Commission has already been posted for %3.';
        Text001: Label 'Commission for Vehicle %1 has already been posted for %2. Do you want to proceed again?';
        Text002: Label 'Process cancelled by user.';
        Text003: Label 'Commission for Invoice %1 has already been posted. Do you want to proceed again?';
        VendorList: Text[1024];
        GLEntry: Record "17";
    begin
        SalesInvHeader.RESET;
        SalesInvHeader.SETRANGE("No.", InvNo);
        IF SalesInvHeader.FINDFIRST THEN BEGIN
            // ------------** COMMISSION CHECKING FOR VEHICLE DOCUMENT **-------------------------
            IF SalesInvHeader."Document Profile" = SalesInvHeader."Document Profile"::"Vehicles Trade" THEN BEGIN
                SalesInvHeader.TESTFIELD(SalesInvHeader."Vehicle Sr. No.");
                Vehicle.RESET;
                Vehicle.SETRANGE("Serial No.", SalesInvHeader."Vehicle Sr. No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                    IF Vehicle."Commission Posted" THEN BEGIN
                        VendorList := '';
                        GLEntry.RESET;
                        //GLEntry.SETRANGE("Sales Invoice No.",SalesInvHeader."No.");
                        GLEntry.SETRANGE(VIN, Vehicle.VIN);
                        GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::Vendor);
                        IF GLEntry.FINDSET THEN
                            REPEAT
                                VendorList += '/' + GLEntry."Source No.";
                            UNTIL GLEntry.NEXT = 0;
                        UserSetup.GET(USERID);
                        IF NOT UserSetup."Allow Post.Multiple Commission" THEN
                            ERROR(Text000, 'Vehicle', Vehicle.VIN, VendorList)
                        ELSE BEGIN
                            IF NOT CONFIRM(Text001, FALSE, Vehicle.VIN, VendorList) THEN
                                ERROR(Text002, Vehicle.VIN);
                        END;
                    END;
                    Vehicle."Commission Posted" := TRUE;
                    Vehicle.MODIFY;
                END;
            END
            // ------------** COMMISSION CHECKING FOR OTHER DOCUMENT **-------------------------
            ELSE BEGIN
                UserSetup.GET(USERID);
                IF SalesInvHeader."Commission Posted" THEN BEGIN
                    IF NOT UserSetup."Allow Post.Multiple Commission" THEN
                        ERROR(Text000, 'Invoice', SalesInvHeader."No.")
                    ELSE
                        IF NOT CONFIRM(Text003, FALSE, SalesInvHeader."No.") THEN
                            ERROR(Text002, SalesInvHeader."No.");
                END;
            END;

            SalesInvHeader."Commission Posted" := TRUE;
            SalesInvHeader.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateLCValueEntries(LCCode: Code[20]; Type: Option Insurance,"Letter of Credit"; Charge: Decimal; DocumentNo: Code[20])
    var
        LCDetails: Record "33020012";
        LCValueEntries: Record "33020023";
        LCValueAllotment: Record "33020024";
    begin
        LCDetails.RESET;
        LCDetails.SETRANGE("No.", LCCode);
        IF LCDetails.FINDFIRST THEN BEGIN
            LCValueEntries.RESET;
            LCValueEntries.LOCKTABLE;
            LCValueEntries.SETRANGE("LC Code", LCCode);
            IF LCValueEntries.FINDLAST THEN
                LCValueEntries."Line No." += 1
            ELSE
                LCValueEntries."Line No." := 1;

            LCValueEntries.INIT;
            LCValueEntries."LC Code" := LCCode;
            LCValueEntries.Type := Type;
            LCValueEntries."Charge (LCY)" := Charge;
            LCValueEntries."Value (LCY)" := LCDetails."LC Value (LCY)";
            LCValueEntries."Document No." := DocumentNo; //**SM to get document no. from the gen. journal line
            LCValueEntries.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateTDSEntries(DocumentNo: Code[20]; Charge: Decimal; AcNo: Code[20]; BranchCode: Code[20]; CostRevenue: Code[20]; ExtDocNo: Code[20]; PostingDate: Date; DocumentSubclass: Code[20]; var RecGlEntry: Record "17")
    var
        TDSPostingCode: Code[20];
        TDSPostingPercentage: Decimal;
        SourceType: Option Customer,Vendor;
        Customer: Record "18";
        Vendor: Record "23";
        DimSetEntry: Record "480";
    begin
        //***SM 14-06-2013 TDS Entries from gen. journal line
        TDSPostingGroup.RESET;
        TDSPostingGroup.SETRANGE("GL Account No.", AcNo);
        IF TDSPostingGroup.FINDFIRST THEN BEGIN
            TDSPostingCode := TDSPostingGroup.Code;
            TDSPostingPercentage := TDSPostingGroup."TDS%";
        END;

        PayrollGeneralSetup.RESET;
        PayrollGeneralSetup.SETRANGE("Income Tax Account 1", AcNo);
        IF PayrollGeneralSetup.FINDFIRST THEN BEGIN
            TDSPostingCode := PayrollGeneralSetup."Income Tax Account 1";
        END;

        PayrollGeneralSetup.RESET;
        PayrollGeneralSetup.SETRANGE("Income Tax Account 2", AcNo);
        IF PayrollGeneralSetup.FINDFIRST THEN BEGIN
            TDSPostingCode := PayrollGeneralSetup."Income Tax Account 2";
        END;

        TDSEntries.RESET;
        TDSEntries.LOCKTABLE;
        IF TDSEntries.FINDLAST THEN
            TDSEntries."Entry No." := TDSEntries."Entry No." + 1
        ELSE
            TDSEntries."Entry No." := 1;

        /*
        JnlLineDim1.RESET;
        JnlLineDim1.SETRANGE("Table ID",81);
        JnlLineDim1.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
        JnlLineDim1.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
        JnlLineDim1.SETRANGE("Journal Line No.",GenJnlLine."Line No.");
        JnlLineDim1.SETRANGE("Dimension Code",'EMPLOYEE');
        IF NOT JnlLineDim1.FINDFIRST THEN;
        */

        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", RecGlEntry."Dimension Set ID");
        DimSetEntry.SETRANGE("Dimension Code", 'EMPLOYEE');
        IF DimSetEntry.FINDFIRST THEN;

        TDSEntries.INIT;
        TDSEntries."Document No." := DocumentNo;
        TDSEntries."TDS Posting Group" := TDSPostingCode;
        TDSEntries."TDS%" := TDSPostingPercentage;
        TDSEntries."TDS Amount" := Charge;
        TDSEntries."User ID" := USERID;
        TDSEntries."Shortcut Dimension 1 Code" := BranchCode;
        TDSEntries."Shortcut Dimension 2 Code" := CostRevenue;
        TDSEntries."Shortcut Dimension 3 Code" := DimSetEntry."Dimension Value Code";
        TDSEntries."Dimension Set ID" := RecGlEntry."Dimension Set ID";
        TDSEntries."External Document No." := ExtDocNo;
        TDSEntries."Posting Date" := PostingDate;
        TDSEntries."Document Date" := PostingDate;
        TDSEntries."Bill-to/Pay-to No." := DocumentSubclass;
        TDSEntries.INSERT(TRUE);

        Vendor.RESET;
        Vendor.SETRANGE("No.", DocumentSubclass);
        IF Vendor.FINDFIRST THEN BEGIN
            TDSEntries."Source Type" := TDSEntries."Source Type"::Vendor;
        END;
        TDSEntries.MODIFY;
        Customer.RESET;
        Customer.SETRANGE("No.", DocumentSubclass);
        IF Customer.FINDFIRST THEN BEGIN
            TDSEntries."Source Type" := TDSEntries."Source Type"::Customer;
        END;
        TDSEntries.MODIFY;
        //***SM 14-06-2013 TDS Entries from gen. journal line

    end;

    [Scope('Internal')]
    procedure InsertAdvLoanRegister(RegisterType: Option Advance,Loan; var RecGlEntry: Record "17")
    var
        EmpAdvReg: Record "33020508";
        EmpLoanReg: Record "33020509";
        DimSetEntry: Record "480";
    begin
        /*
        JnlLineDim.RESET;
        JnlLineDim.SETRANGE("Table ID",81);
        JnlLineDim.SETRANGE("Journal Template Name",GenJnlLine."Journal Template Name");
        JnlLineDim.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
        JnlLineDim.SETRANGE("Journal Line No.",GenJnlLine."Line No.");
        JnlLineDim.SETRANGE("Dimension Code",'EMPLOYEE');
        IF NOT JnlLineDim.FINDFIRST THEN;
          //ERROR(Text000,GenJnlLine."Line No.");
        */


        DimSetEntry.RESET;
        DimSetEntry.SETRANGE("Dimension Set ID", RecGlEntry."Dimension Set ID");
        DimSetEntry.SETRANGE("Dimension Code", 'EMPLOYEE');
        IF DimSetEntry.FINDFIRST THEN;

        CASE RegisterType OF
            RegisterType::Advance:
                BEGIN
                    EmpAdvReg.LOCKTABLE;
                    IF EmpAdvReg.FINDLAST THEN
                        EmpAdvReg."Entry No." += 1
                    ELSE
                        EmpAdvReg."Entry No." := 1;

                    EmpAdvReg.INIT;
                    EmpAdvReg."Employee Code" := DimSetEntry."Dimension Value Code";
                    EmpAdvReg."Creation Date" := TODAY;
                    EmpAdvReg.Amount := RecGlEntry.Amount;
                    EmpAdvReg."G/L Entry No." := RecGlEntry."Entry No.";
                    EmpAdvReg."Source Code" := RecGlEntry."Source Code";
                    EmpAdvReg."User ID" := USERID;
                    EmpAdvReg."Document No." := RecGlEntry."Document No.";
                    EmpAdvReg.INSERT(TRUE);
                END;
            RegisterType::Loan:
                BEGIN
                    EmpLoanReg.LOCKTABLE;
                    IF EmpLoanReg.FINDLAST THEN
                        EmpLoanReg."Entry No." += 1
                    ELSE
                        EmpLoanReg."Entry No." := 1;

                    EmpLoanReg.INIT;
                    EmpLoanReg."Employee Code" := DimSetEntry."Dimension Value Code";
                    EmpLoanReg."Creation Date" := TODAY;
                    EmpLoanReg.Amount := RecGlEntry.Amount;
                    EmpLoanReg."G/L Entry No." := RecGlEntry."Entry No.";
                    EmpLoanReg."Source Code" := RecGlEntry."Source Code";
                    EmpLoanReg."User ID" := USERID;
                    EmpLoanReg."Document No." := RecGlEntry."Document No.";
                    EmpLoanReg.INSERT(TRUE);
                END;
        END;

    end;

    [Scope('Internal')]
    procedure GetNextTdsEntryNo(): Integer
    begin
        //TDS2.00
        EXIT(NextTdsEntryNo);
        //TDS2.00
    end;

    [Scope('Internal')]
    procedure NextTdsEntryNo(): Integer
    var
        TDSEntry1: Record "33019850";
        TDSEntryNo: Integer;
    begin
        //TDS2.00
        TDSEntry1.LOCKTABLE;
        TDSEntry1.RESET;
        IF TDSEntry1.FINDLAST THEN
            TDSEntryNo := TDSEntry1."Entry No." + 1
        ELSE
            TDSEntryNo := 1;
        EXIT(TDSEntryNo);
        //TDS2.00
    end;

    [Scope('Internal')]
    procedure InsertTDS(GenJournalLine: Record "81")
    var
        TDSEntry1: Record "33019850";
        SourceCodeSetup: Record "242";
    begin
        //TDS2.00
        GetPurchaseTDSVendorName(GenJournalLine);
        GetTDSGLCodeName(GenJournalLine);
        SourceCodeSetup.GET;

        IF ("TDS Group" <> '') AND ("TDS Amount" <> 0) THEN BEGIN

            // TESTFIELD("Document Subclass");
            // TESTFIELD("Document Class","Document Class"::Vendor);

            TDSEntry1.INIT;
            TDSEntryNo := GetNextTdsEntryNo;
            TDSEntry1."Entry No." := TDSEntryNo;
            TDSEntry1."Posting Date" := GenJournalLine."Posting Date";
            TDSEntry1."Document No." := GenJournalLine."Document No.";
            TDSEntry1."Source Type" := TDSEntry1."Source Type"::Vendor;
            IF GenJournalLine."Source Code" = SourceCodeSetup.Purchases THEN
                TDSEntry1."Bill-to/Pay-to No." := GenJournalLine."Source No."
            ELSE
                TDSEntry1."Bill-to/Pay-to No." := GenJournalLine."Document Subclass";

            TDSEntry1."TDS Posting Group" := GenJournalLine."TDS Group";
            TDSEntry1."TDS%" := GenJournalLine."TDS%";
            TDSEntry1.Base := GenJournalLine."TDS Base Amount";
            TDSEntry1."TDS Amount" := GenJournalLine."TDS Amount";
            TDSEntry1."User ID" := USERID;
            TDSEntry1."Transaction No." := NextTransactionNo;
            TDSEntry1."Source Code" := GenJournalLine."Source Code";
            TDSEntry1."External Document No." := GenJournalLine."External Document No.";
            TDSEntry1."Document Date" := GenJournalLine."Document Date";
            TDSEntry1."Shortcut Dimension 1 Code" := GenJournalLine."Shortcut Dimension 1 Code";
            TDSEntry1."Shortcut Dimension 2 Code" := GenJournalLine."Shortcut Dimension 2 Code";
            TDSEntry1."Dimension Set ID" := GenJournalLine."Dimension Set ID";
            TDSEntry1."TDS Type" := GenJournalLine."TDS Type";
            TDSEntry1."Vendor Name" := VendorName;
            TDSEntry1."GL Account Name" := GLAccountName;
            TDSEntry1.INSERT;

        END;
        //TDS2.00
    end;

    [Scope('Internal')]
    procedure GetPurchaseTDSVendorName(GenJnlLine: Record "81")
    var
        Vendor: Record "23";
    begin
        //TDS2.00
        CLEAR(VendorName);
        IF "TDS Group" <> '' THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("No.", "Document Subclass");
            IF Vendor.FINDFIRST THEN
                VendorName := Vendor.Name;
        END;
        //TDS2.00
    end;

    [Scope('Internal')]
    procedure GetTDSGLCodeName(GenJnlLine: Record "81")
    var
        TDSpostingGroup: Record "33019849";
        GLAccount: Record "15";
    begin
        //TDS2.00
        CLEAR(GLAccountNo);
        CLEAR(GLAccountName);
        IF "TDS Group" <> '' THEN BEGIN
            TDSpostingGroup.RESET;
            TDSpostingGroup.SETRANGE(Code, "TDS Group");
            IF TDSpostingGroup.FINDFIRST THEN BEGIN
                GLAccountNo := TDSpostingGroup."GL Account No.";
                GLAccount.RESET;
                GLAccount.SETRANGE("No.", GLAccountNo);
                IF GLAccount.FINDFIRST THEN
                    GLAccountName := GLAccount.Name;
            END;
        END;
        //TDS2.00
    end;

    [Scope('Internal')]
    procedure CreateTDSJnlLine(GenJournalLine: Record "81")
    var
        TDSLine: Record "81";
        TDSPostSetup: Record "33019849";
        GenLineNo: Integer;
    begin
        //TDS2.00
        GenJournalLine.TESTFIELD("Document Subclass");
        GenJournalLine.TESTFIELD("Document Class", "Document Class"::Vendor);

        GenLine.RESET;
        GenLine.SETRANGE("Journal Template Name", GenJournalLine."Journal Template Name");
        GenLine.SETRANGE("Journal Batch Name", GenJournalLine."Journal Batch Name");
        IF GenLine.FINDLAST THEN
            GenLineNo := GenLine."Line No." + 10000
        ELSE
            GenLineNo := 10000;

        TDSPostSetup.RESET;
        TDSPostSetup.SETRANGE(Code, "TDS Group");
        TDSPostSetup.FINDFIRST;

        TDSLine.LOCKTABLE;
        TDSLine.INIT;
        TDSLine."Journal Template Name" := GenJournalLine."Journal Template Name";
        TDSLine."Journal Batch Name" := GenJournalLine."Journal Batch Name";
        TDSLine."Line No." := GenLineNo;
        TDSLine."Document Type" := GenJournalLine."Document Type";
        TDSLine."Account Type" := TDSLine."Account Type"::"G/L Account";
        TDSLine."Account No." := TDSPostSetup."GL Account No.";
        TDSLine."Posting Date" := GenJournalLine."Posting Date";
        TDSLine."Document Date" := GenJournalLine."Document Date";
        TDSLine."Document No." := GenJournalLine."Document No.";
        TDSLine."TDS Line" := TRUE;
        TDSLine.Description := TDSDesc;
        TDSLine.VALIDATE(Amount, -"TDS Amount");
        TDSLine.VALIDATE("Shortcut Dimension 1 Code", GenJournalLine."Shortcut Dimension 1 Code");
        TDSLine.VALIDATE("Shortcut Dimension 2 Code", GenJournalLine."Shortcut Dimension 2 Code");
        //TDSLine.Comment := Comment;
        TDSLine."Document Class" := "Document Class";
        TDSLine."Document Subclass" := "Document Subclass";
        //TDSLine."Party Name" := "Party Name";
        TDSLine."External Document No." := GenJournalLine."External Document No.";
        //TDSLine."Assigned User ID" := "Assigned User ID";
        TDSLine."Pre Assigned No." := GenJournalLine."Document No.";
        TDSLine."Posting No. Series" := GenJournalLine."Posting No. Series";
        TDSLine.INSERT;
        //TDS2.00
        /*
        //TDS2.00 >>
        IF "TDS Line" = TRUE THEN
          GLEntryTDSEntryLink.InsertLink(GLEntry."Entry No.",TDSEntryNo);
        //TDS2.00
        */

    end;

    [Scope('Internal')]
    procedure AddTDSAmount(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]): Decimal
    var
        GenJournalLine: Record "81";
        TDSAmount: Decimal;
    begin
        //TDS2.00
        CLEAR(TDSAmount);
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJournalLine.SETRANGE("Document No.", DocumentNo);
        IF GenJournalLine.FINDSET THEN
            REPEAT
                TDSAmount += GenJournalLine."TDS Amount";
            UNTIL GenJournalLine.NEXT = 0;
        EXIT(TDSAmount);
    end;

    [Scope('Internal')]
    procedure GetVFPrepaymentAmount(LoanNo: Code[20]) PrepaymentAmount: Decimal
    var
        VFPaymentLine: Record "33020072";
    begin
        //STPL.15.08 >>
        PrepaymentAmount := 0;
        VFPaymentLine.RESET;
        VFPaymentLine.SETRANGE("Loan No.", LoanNo);
        VFPaymentLine.SETRANGE("Posting Type", VFPaymentLine."Posting Type"::Prepayment);
        IF VFPaymentLine.FINDFIRST THEN
            REPEAT
                PrepaymentAmount += VFPaymentLine."Prepayment Paid";
            UNTIL VFPaymentLine.NEXT = 0;
        EXIT(PrepaymentAmount);
        //STPL.15.08 <<
    end;

    [Scope('Internal')]
    procedure OnProcessInitGLEntry(var GLEntry: Record "17"; GenJnlLine: Record "81")
    var
        VFSetup: Record "33020064";
    begin
        IF VFSetup.GET THEN BEGIN
            IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                ProcessVehicleFinance_HP(GLEntry, GenJnlLine)
            ELSE
                ProcessVehicleFinance_VF(GLEntry, GenJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure ProcessVehicleFinance_HP(var GLEntry: Record "17"; GenJnlLine: Record "81")
    var
        VFRec: Record "33020062";
        VFPaymentRec: Record "33020072";
        lrecVFiSetup: Record "33020064";
        VFline: Record "33020063";
        PaidAmount: Decimal;
        VFline1: Record "33020063";
        VFline2: Record "33020063";
        PendingAmt: Decimal;
        CheckPrincipalAndInterest: Boolean;
        LineNo: Integer;
        PrincipalPaidTotal: Decimal;
        PenaltyUpdated: Boolean;
        InitVFPaymentLines: Boolean;
    begin
        InitVFPaymentLines := (GenJnlLine.Amount < 0);
        IF NOT InitVFPaymentLines THEN
            InitVFPaymentLines := ('Adj. ' + FORMAT(GenJnlLine."VF Posting Type") +
                                  ' Entries of ' + GenJnlLine."VF Loan File No." + ' Inst No ' + FORMAT(GenJnlLine."VF Installment No.")) =
                                 GenJnlLine.Description;
        IF (GenJnlLine."VF Loan File No." <> '') AND (GenJnlLine."VF Loan Disburse Entry" = FALSE)
           AND (InitVFPaymentLines) AND (GenJnlLine."VF Installment No." <> 0) THEN BEGIN
            LineNo := 0;
            VFPaymentRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            VFPaymentRec.SETRANGE("Installment No.", GenJnlLine."VF Installment No.");
            VFPaymentRec.SETRANGE("G/L Receipt No.", GenJnlLine."Document No.");
            IF VFPaymentRec.FINDFIRST THEN BEGIN
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Principal THEN
                    VFPaymentRec."Principal Paid" := VFPaymentRec."Principal Paid" - GenJnlLine.Amount;
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Interest THEN
                    VFPaymentRec."Interest Paid" := VFPaymentRec."Interest Paid" - GenJnlLine.Amount;
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Penalty THEN
                    VFPaymentRec."Penalty Paid" := VFPaymentRec."Penalty Paid" - GenJnlLine.Amount;
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Prepayment THEN
                    VFPaymentRec."Prepayment Paid" := VFPaymentRec."Prepayment Paid" - GenJnlLine.Amount;
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Capitalization THEN
                    VFPaymentRec."Prepayment Paid" := -(VFPaymentRec."Prepayment Paid" - GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Interest on CAD" THEN
                    VFPaymentRec."CAD Interest Paid" := VFPaymentRec."CAD Interest Paid" - GenJnlLine.Amount;

                VFPaymentRec.MODIFY;
            END ELSE BEGIN
                VFPaymentRec.RESET;
                VFPaymentRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
                VFPaymentRec.SETRANGE("Installment No.", GenJnlLine."VF Installment No.");
                IF VFPaymentRec.FINDLAST THEN
                    LineNo := VFPaymentRec."Line No." + 10000
                ELSE
                    LineNo := 10000;

                VFPaymentRec.RESET;
                CLEAR(VFPaymentRec);
                VFPaymentRec.INIT;
                VFPaymentRec."Loan No." := GenJnlLine."VF Loan File No.";
                VFPaymentRec."Installment No." := GenJnlLine."VF Installment No.";
                VFPaymentRec."Line No." := LineNo + 10000;

                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Principal THEN
                    VFPaymentRec."Principal Paid" := -GenJnlLine.Amount;
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Interest THEN
                    VFPaymentRec."Interest Paid" := -GenJnlLine.Amount;
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Penalty THEN
                    VFPaymentRec."Penalty Paid" := -GenJnlLine.Amount;

                /*IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN          //ZM Temp. code added jan 18, 2017
                  VFPaymentRec."Penalty Paid" := -VFPaymentRec."Penalty Paid";*/


                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Prepayment THEN
                    VFPaymentRec."Prepayment Paid" := -GenJnlLine.Amount;
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Interest on CAD" THEN
                    VFPaymentRec."CAD Interest Paid" := -GenJnlLine.Amount;
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Capitalization THEN
                    VFPaymentRec."Prepayment Paid" := GenJnlLine.Amount;

                //update delay days and duration from previous payment
                VFRec.GET(GenJnlLine."VF Loan File No.");
                VFline.GET(GenJnlLine."VF Loan File No.", GenJnlLine."VF Installment No.");
                //IF NOT PenaltyUpdated THEN BEGIN
                VFPaymentRec."Delay by No. of Days" := VFline."Delay by No. of Days";
                VFPaymentRec."Duration of days fr Prev. Mnth" := VFRec."No of Due Days";
                //VFPaymentRec."Calculated Penalty" := VFRec."Temp Penalty";
                //PenaltyUpdated := TRUE;
                //END;
                VFPaymentRec."Calculated Penalty" := VFline."Calculated Penalty";
                VFPaymentRec."VF Posting Description" := GenJnlLine.Narration;
                VFPaymentRec."Payment Description" := GenJnlLine.Description;
                VFPaymentRec."Payment Date" := GenJnlLine."Document Date";
                VFPaymentRec."G/L Posting Date" := GenJnlLine."Posting Date";
                VFPaymentRec."G/L Receipt No." := GenJnlLine."Document No.";
                VFPaymentRec."Posting Type" := GenJnlLine."VF Posting Type";
                VFPaymentRec."User ID" := USERID;
                VFPaymentRec."VF Receipt No." := GenJnlLine."External Document No.";
                VFPaymentRec."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                VFPaymentRec."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                VFPaymentRec."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                VFPaymentRec.INSERT;
            END;

            //update remaninig principal
            IF (GenJnlLine."VF Posting Type" <> GenJnlLine."VF Posting Type"::Prepayment) THEN BEGIN
                VFRec.GET(GenJnlLine."VF Loan File No.");
                CLEAR(PrincipalPaidTotal);
                VFline.RESET;
                VFline.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
                IF VFline.FINDFIRST THEN BEGIN
                    REPEAT
                        VFline2.RESET;
                        VFline2.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
                        VFline2.SETFILTER("Installment No.", '%1..%2', 1, VFline."Installment No.");
                        IF VFline2.FINDFIRST THEN BEGIN
                            PrincipalPaidTotal := 0;
                            REPEAT
                                VFline2.CALCFIELDS("Principal Paid");
                                PrincipalPaidTotal += VFline2."Principal Paid";
                            UNTIL VFline2.NEXT = 0;
                        END;
                        //STPL.15.08 >>
                        IF VFline."Line Cleared" THEN BEGIN
                            VFline."Remaining Principal Amount" := VFRec."Loan Amount" - PrincipalPaidTotal;
                            VFline."Calculated Penalty" := 0;
                        END
                        ELSE
                            VFline."Remaining Principal Amount" := VFRec."Loan Amount" - PrincipalPaidTotal - GetVFPrepaymentAmount(VFline."Loan No.");
                        //STPL.15.08 <<
                        VFline.MODIFY;
                    UNTIL VFline.NEXT = 0;
                END;
            END;

            //Find if there is any capitalization line in the loan file
            VFline2.RESET;
            VFline2.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            VFline2.SETRANGE("Loan Capitalized", TRUE);
            IF VFline2.FINDFIRST THEN BEGIN
                VFRec.GET(GenJnlLine."VF Loan File No.");
                VFline.RESET;
                VFline.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
                VFline.SETRANGE("Line Cleared", FALSE);
                IF VFline.FINDFIRST THEN BEGIN
                    REPEAT
                        VFRec.CALCFIELDS("Total Principal Paid");
                        VFline."Remaining Principal Amount" := VFRec."Loan Amount" - VFRec."Total Principal Paid";
                        VFline.MODIFY;
                    UNTIL VFline.NEXT = 0;
                END;
                VFline.RESET;
                VFline.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
                VFline.SETRANGE("Line Cleared", TRUE);
                IF VFline.FINDFIRST THEN BEGIN
                    REPEAT
                        VFline."Remaining Principal Amount" := VFline.Balance;
                        VFline.MODIFY;
                    UNTIL VFline.NEXT = 0;
                END;

            END;

            //update last receipt date and line clear fields
            VFline.RESET;
            VFline.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            VFline.SETRANGE("Line Cleared", FALSE);
            IF VFline.FINDFIRST THEN BEGIN
                REPEAT
                    VFline.CALCFIELDS("Principal Paid", "Total Principal Paid", "Last Payment Received Date", "Interest Paid");
                    CheckPrincipalAndInterest := TRUE;
                    IF GenJnlLine."VF Loan Clear Entry" THEN BEGIN
                        IF VFline."EMI Mature Date" > GenJnlLine."Posting Date" THEN
                            CheckPrincipalAndInterest := FALSE;
                    END;
                    IF CheckPrincipalAndInterest THEN BEGIN
                        IF ROUND(VFline."Calculated Principal" + VFline."Calculated Interest", 1, '=') <=
                            ROUND(VFline."Principal Paid" + VFline."Interest Paid", 1, '=') THEN BEGIN
                            VFline."Line Cleared" := TRUE;
                            VFline."Calculated Penalty" := 0;
                        END;
                    END
                    ELSE BEGIN
                        IF ROUND(VFline."Calculated Principal", 1, '=') <=
                            ROUND(VFline."Principal Paid", 1, '=') THEN BEGIN
                            VFline."Line Cleared" := TRUE;
                            VFline."Calculated Penalty" := 0;
                        END;
                    END;
                    VFline."Last Payment Date" := VFline."Last Payment Received Date";
                    VFline.MODIFY;
                UNTIL VFline.NEXT = 0;
            END;

        END;
        //  Uapdate Vehicle finance payment line  - Installments - Surya 28Aug2012<<
        //update vehicle finance payment line - insurance and other payments >>
        IF (((GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Insurance)
           OR (GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Other Charges")) AND
           (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer))
            OR
           ((GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Interest on CAD") OR
            (GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Insurance Interest"))
             THEN BEGIN

            VFPaymentRec.RESET;
            VFPaymentRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            VFPaymentRec.SETRANGE("Installment No.", 0);
            LineNo := 0;
            IF VFPaymentRec.FINDLAST THEN
                LineNo := VFPaymentRec."Line No." + 10000
            ELSE
                LineNo := 10000;
            VFPaymentRec.RESET;
            VFPaymentRec.INIT;
            VFPaymentRec."Loan No." := GenJnlLine."VF Loan File No.";
            VFPaymentRec."Installment No." := 0;
            VFPaymentRec."Line No." := LineNo + 10000;
            VFPaymentRec."Payment Date" := GenJnlLine."Document Date";
            VFPaymentRec."G/L Posting Date" := GenJnlLine."Posting Date";
            VFPaymentRec."G/L Receipt No." := GenJnlLine."Document No.";
            VFPaymentRec."Payment Description" := GenJnlLine.Description;
            VFPaymentRec."Posting Type" := GenJnlLine."VF Posting Type";
            VFPaymentRec."User ID - Before Posting" := GenJnlLine."Created by";
            IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Insurance THEN
                VFPaymentRec."Insurance Paid" := GenJnlLine.Amount
            ELSE
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Insurance Interest" THEN
                    VFPaymentRec."Insurance Interest Paid" := -GenJnlLine.Amount
                ELSE
                    IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Interest on CAD" THEN BEGIN
                        VFPaymentRec."CAD Interest Paid" := -GenJnlLine.Amount;
                    END
                    ELSE
                        IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Other Charges" THEN
                            VFPaymentRec."Other Charges Paid" := GenJnlLine.Amount;
            VFPaymentRec."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            VFPaymentRec."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            VFPaymentRec.INSERT;
        END;
        //--insurance and other payments <<
        GLEntry."VF Posting Type" := GenJnlLine."VF Posting Type";
        GLEntry."Loan File No." := GenJnlLine."VF Loan File No.";
        GLEntry."VF Loan Clear Entry" := GenJnlLine."VF Loan Clear Entry";

        IF GenJnlLine."VF Loan Disburse Entry" THEN BEGIN
            VFRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            IF VFRec.FINDFIRST THEN BEGIN
                VFRec."Loan Disbursed" := TRUE;
                VFRec."Loan Released" := TRUE;
                VFRec.MODIFY;
            END;
        END;
        IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Interest on CAD" THEN BEGIN
            VFRec.RESET;
            VFRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            IF VFRec.FINDFIRST THEN BEGIN
                VFRec.VALIDATE("Interest Due on CAD", 0);
                VFRec.MODIFY;
            END;
        END;

    end;

    [Scope('Internal')]
    procedure ProcessVehicleFinance_VF(GLEntry: Record "17"; GenJnlLine: Record "81")
    var
        VFRec: Record "33020062";
        VFPaymentRec: Record "33020072";
        lrecVFiSetup: Record "33020064";
        VFline: Record "33020063";
        PaidAmount: Decimal;
        VFline1: Record "33020063";
        VFline2: Record "33020063";
        PendingAmt: Decimal;
        CheckPrincipalAndInterest: Boolean;
        LineNo: Integer;
        PrincipalPaidTotal: Decimal;
    begin
        //  Uapdate Vehicle finance payment line >>
        IF (GenJnlLine."VF Loan File No." <> '') AND (GenJnlLine."VF Loan Disburse Entry" = FALSE)
           AND (GenJnlLine.Amount < 0) AND (GenJnlLine."VF Installment No." <> 0) THEN BEGIN
            LineNo := 0;
            VFPaymentRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            VFPaymentRec.SETRANGE("Installment No.", GenJnlLine."VF Installment No.");
            VFPaymentRec.SETRANGE("G/L Receipt No.", GenJnlLine."Document No.");
            IF VFPaymentRec.FINDFIRST THEN BEGIN
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Principal THEN
                    VFPaymentRec."Principal Paid" := ABS(GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Interest THEN
                    VFPaymentRec."Interest Paid" := ABS(GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Penalty THEN
                    VFPaymentRec."Penalty Paid" := ABS(GenJnlLine.Amount);
                VFPaymentRec.MODIFY;
            END ELSE BEGIN
                VFPaymentRec.RESET;
                VFPaymentRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
                VFPaymentRec.SETRANGE("Installment No.", GenJnlLine."VF Installment No.");
                IF VFPaymentRec.FINDLAST THEN
                    LineNo := VFPaymentRec."Line No." + 10000
                ELSE
                    LineNo := 10000;

                VFPaymentRec.RESET;
                VFPaymentRec.INIT;
                VFPaymentRec."Loan No." := GenJnlLine."VF Loan File No.";
                VFPaymentRec."Installment No." := GenJnlLine."VF Installment No.";
                VFPaymentRec."Line No." := LineNo + 10000;

                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Principal THEN
                    VFPaymentRec."Principal Paid" := ABS(GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Interest THEN
                    VFPaymentRec."Interest Paid" := ABS(GenJnlLine.Amount);
                IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Penalty THEN
                    VFPaymentRec."Penalty Paid" := ABS(GenJnlLine.Amount);

                //update delay days and duration from previous payment
                VFRec.GET(GenJnlLine."VF Loan File No.");
                IF NOT PenaltyUpdated THEN BEGIN
                    VFPaymentRec."Delay by No. of Days" := VFRec."Temp Delay Days";
                    VFPaymentRec."Duration of days fr Prev. Mnth" := VFRec."No of Due Days";
                    VFPaymentRec."Calculated Penalty" := VFRec."Temp Penalty";
                    PenaltyUpdated := TRUE;
                END;
                VFPaymentRec."VF Posting Description" := GenJnlLine.Narration;
                VFPaymentRec."Payment Description" := GenJnlLine.Description;
                VFPaymentRec."Payment Date" := GenJnlLine."Document Date";
                VFPaymentRec."G/L Posting Date" := GenJnlLine."Posting Date";
                VFPaymentRec."G/L Receipt No." := GenJnlLine."Document No.";
                VFPaymentRec."Posting Type" := GenJnlLine."VF Posting Type";
                VFPaymentRec."User ID" := USERID;
                VFPaymentRec."VF Receipt No." := GenJnlLine."External Document No.";
                VFPaymentRec."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
                VFPaymentRec."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
                VFPaymentRec."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                VFPaymentRec.INSERT;
            END;

            //update last receipt date and line clear fields
            VFline.RESET;
            VFline.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            VFline.SETRANGE("Line Cleared", FALSE);
            IF VFline.FINDFIRST THEN BEGIN
                REPEAT
                    VFline.CALCFIELDS("Principal Paid", "Total Principal Paid", "Last Payment Received Date");
                    IF ROUND(VFline."Calculated Principal", 1, '>') <=
                        ROUND(VFline."Principal Paid", 1, '>') THEN
                        VFline."Line Cleared" := TRUE;
                    VFline."Last Payment Date" := VFline."Last Payment Received Date";
                    VFline.MODIFY;
                UNTIL VFline.NEXT = 0;
            END;
            //update remaninig principal
            VFRec.GET(GenJnlLine."VF Loan File No.");
            CLEAR(PrincipalPaidTotal);
            VFline.RESET;
            VFline.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            //VFline.SETRANGE("Line Cleared",FALSE);
            //VFline.SETFILTER("Installment No.",'%1..%2',1,VFRec."Tenure in Months");
            IF VFline.FINDFIRST THEN BEGIN
                REPEAT
                    VFline2.RESET;
                    VFline2.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
                    VFline2.SETFILTER("Installment No.", '%1..%2', 1, VFline."Installment No.");
                    IF VFline2.FINDFIRST THEN BEGIN
                        PrincipalPaidTotal := 0;
                        REPEAT
                            VFline2.CALCFIELDS("Principal Paid");
                            PrincipalPaidTotal += VFline2."Principal Paid";
                        UNTIL VFline2.NEXT = 0;
                    END;
                    VFline."Remaining Principal Amount" := VFRec."Loan Amount" - PrincipalPaidTotal;
                    VFline.MODIFY;
                UNTIL VFline.NEXT = 0;
            END;
        END;
        //  Uapdate Vehicle finance payment line  - Installments - Surya 28Aug2012<<
        //update vehicle finance payment line - insurance and other payments >>

        IF ((GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Insurance)
           OR (GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Other Charges")) AND
           (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) THEN BEGIN
            VFPaymentRec.RESET;
            VFPaymentRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            VFPaymentRec.SETRANGE("Installment No.", 0);
            LineNo := 0;
            IF VFPaymentRec.FINDLAST THEN
                LineNo := VFPaymentRec."Line No." + 10000
            ELSE
                LineNo := 10000;
            VFPaymentRec.RESET;
            VFPaymentRec.INIT;
            VFPaymentRec."Loan No." := GenJnlLine."VF Loan File No.";
            VFPaymentRec."Installment No." := 0;
            VFPaymentRec."Line No." := LineNo + 10000;
            VFPaymentRec."Payment Date" := GenJnlLine."Document Date";
            VFPaymentRec."G/L Posting Date" := GenJnlLine."Posting Date";
            VFPaymentRec."G/L Receipt No." := GenJnlLine."Document No.";
            VFPaymentRec."Payment Description" := GenJnlLine.Description;
            VFPaymentRec."Posting Type" := GenJnlLine."VF Posting Type";
            VFPaymentRec."User ID - Before Posting" := GenJnlLine."Created by";
            IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::Insurance THEN
                VFPaymentRec."Insurance Paid" := GenJnlLine.Amount;
            IF GenJnlLine."VF Posting Type" = GenJnlLine."VF Posting Type"::"Other Charges" THEN
                VFPaymentRec."Other Charges Paid" := GenJnlLine.Amount;
            VFPaymentRec."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            VFPaymentRec."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            VFPaymentRec.INSERT;
        END;
        //--insurance and other payments <<
        GLEntry."VF Posting Type" := GenJnlLine."VF Posting Type";
        GLEntry."Loan File No." := GenJnlLine."VF Loan File No.";
        GLEntry."VF Loan Clear Entry" := GenJnlLine."VF Loan Clear Entry";

        IF GenJnlLine."VF Loan Disburse Entry" THEN BEGIN
            VFRec.SETRANGE("Loan No.", GenJnlLine."VF Loan File No.");
            IF VFRec.FINDFIRST THEN BEGIN
                VFRec."Loan Disbursed" := TRUE;
                VFRec."Loan Released" := TRUE;
                VFRec.MODIFY;
            END;
        END;
    end;
}

