codeunit 33020068 "Close Loan File"
{
    // 1. Process Day End
    // 2. Total Due as on Today on VFheader must be zero after day end
    // 3. Get Total Due to clear loan from VFHeader field "Total Due", this must be greater than zero
    // 4. If Nominee Balance is greater than or equal to "Total Due" then goahead
    // 5. Check loan file ,with if "Interest Due Defered" + "Principal Due" not equal to "Total Due" give error
    // 6. Find the line having loan cleared false
    // 7. Get "Principal Due" and process payment
    // 8. Get "Interest Due Defered" and process payment
    // 9. Delete all lines after having loan cleared false.
    // 10. Mark true on Closed on VFHeader.

    TableNo = 33020062;

    trigger OnRun()
    begin
        CLEARALL;
        VFHeader := Rec;
        VFSetup.GET;
        UserSetup.GET(USERID);
        VFHeader.TESTFIELD(Blocked, FALSE);
        VFHeader.TESTFIELD(Approved, TRUE);
        VFHeader.TESTFIELD("Loan Disbursed", TRUE);
        VFHeader.TESTFIELD(Closed, FALSE);

        //ProcessDayEnd("Loan No.");

        CLEAR(CalculateEMI);
        CalculateEMI.CalculateDueAndNRV(VFHeader, TODAY);

        VFHeader.GET(VFHeader."Loan No.");
        VFHeader.TESTFIELD("Total Due as of Today", 0);

        DueAmountForLoanClosure := ROUND("Total Due", 0.01, '=');
        ActualPaymentAmount := 0;
        IF NOT LoanCustomer.GET(VFHeader."Customer No.") THEN
            ERROR(ErrNoLoanCustomer);
        IF NOT NomineeCustomer.GET("Nominee Account No.") THEN
            ERROR(ErrNoNomineeCustomer);

        IF DueAmountForLoanClosure > 0 THEN BEGIN
            NomineeCustomer.CALCFIELDS("Balance (LCY)");
            PaymentAmount := NomineeCustomer."Balance (LCY)" * -1;
            IF PaymentAmount <= 0 THEN
                ERROR(ErrNoPaymentAmount)
            ELSE
                IF PaymentAmount > 0 THEN BEGIN
                    IF PaymentAmount > DueAmountForLoanClosure THEN
                        PaymentAmount := DueAmountForLoanClosure;
                    ActualPaymentAmount := PaymentAmount;
                    ProcessCashReceipt(VFHeader);
                END;
        END;
        Rec := VFHeader;
        COMMIT;
    end;

    var
        VFHeader: Record "33020062";
        VFLines: Record "33020063";
        VFSetup: Record "33020064";
        UserSetup: Record "91";
        LoanCustomer: Record "18";
        NomineeCustomer: Record "18";
        CalculateEMI: Codeunit "33020062";
        CreateVFJournal_HP: Codeunit "33020063";
        DueAmountForLoanClosure: Decimal;
        ActualPaymentAmount: Decimal;
        ErrNoLoanCustomer: Label 'Loan Customer Account does not exists.';
        ErrNoNomineeCustomer: Label 'Nominee Account does not exists.';
        ErrNoPaymentAmount: Label 'There is no sufficient balance in nominee account to close this loan document.';
        ErrLessPaymentAmount: Label 'Payment Amount is less then due Amount.';
        PaymentAmount: Decimal;
        AppliedAmount: Decimal;
        MsgTransactionSuccess: Label 'Loan file %1 has now been closed.';
        ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit;
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        VFPostingType: Option " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges",Prepayment,"Insurance Interest","Interest on CAD";
        TempCashReceiptNo: Code[20];
        ErrNoVFLines: Label 'There is no installment remaining.';
        ErrPrincipalPaidLess: Label 'This Loan File cannot be closed. Total principal paid is less then loan amount.';
        ErrOutstandingInterest: Label 'This Loan File can not be closed. There is outstanding interest to be cleared for this loan file.';
        ErrTotalDue: Label 'This Loan File can not be closed. There is dues remaining to be cleared for this loan file.';
        ErrPaymentApplication: Label 'Total due to clear loan is %1 but applied amount is %2.';

    [Scope('Internal')]
    procedure ProcessCashReceipt(var VFHeader: Record "33020062")
    var
        VehicleFinanceHeader: Record "33020062";
    begin
        VFHeader.GET(VFHeader."Loan No.");

        //ERROR('VFHeader."Total Due" >> %1',VFHeader."Total Due");
        //VFHeader."Total Due" := ROUND("Total Due",0.01,'=');
        //TESTFIELD("Total Due","Principal Due" + "Interest Due Defered");
        VFHeader.TESTFIELD("Total Due", ROUND("Principal Due", 0.01, '=') + "Interest Due Defered");

        VFHeader.CALCFIELDS(VIN);
        VFLines.RESET;
        VFLines.SETCURRENTKEY("Loan No.", "Installment No.");
        VFLines.SETRANGE("Loan No.", VFHeader."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        IF NOT VFLines.FINDFIRST THEN
            ERROR(ErrNoVFLines);
        ProcessPaymentJournal;
    end;

    [Scope('Internal')]
    procedure ProcessPaymentJournal()
    begin
        //Nominee account debit, loan related accounts credit
        CreateVFJournal_HP.SetClearLoan(TRUE);
        CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
        CreateVFJournal_HP.LoanApproval(TODAY, AccountType::Customer, NomineeCustomer."No."
          , 'APPLIED to LOAN#' + VFHeader."Loan No.",
          ROUND(PaymentAmount, 0.01, '='), VFHeader."Loan No.", VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
          VFHeader."Shortcut Dimension 2 Code", 0, VFPostingType::Principal, FALSE, FALSE,
          TODAY, FALSE, '', 'APPLIED to LOAN#' + VFHeader."Loan No.", VFHeader."Shortcut Dimension 3 Code");
        AppliedAmount := PaymentAmount;

        ProcessInterest(VFHeader."Loan No.");
        ProcessPrincipal(VFHeader."Loan No.");

        CalculateEMI.AvoidRounding(VFHeader."Loan No.", TempCashReceiptNo);
    end;

    [Scope('Internal')]
    procedure ProcessInterest(LoanNo: Code[20])
    var
        AvailableforInterest: Decimal;
    begin
        AvailableforInterest := 0;
        IF (PaymentAmount < VFHeader."Interest Due Defered") THEN
            AvailableforInterest := PaymentAmount
        ELSE
            AvailableforInterest := VFHeader."Interest Due Defered";
        IF AvailableforInterest > 0 THEN BEGIN
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(TRUE);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::"G/L Account", VFSetup."Interest Posting Account"
              , 'Cash receipt against Interest Due of ' + LoanNo,
              ROUND(-AvailableforInterest, 0.01, '=')
              , LoanNo, VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code", VFHeader."Shortcut Dimension 2 Code",
              VFLines."Installment No.", VFPostingType::Interest, FALSE, FALSE,
              TODAY, FALSE, TempCashReceiptNo, 'Cash receipt against Interest Due of ' + LoanNo, VFHeader."Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - AvailableforInterest, 1, '=');
        END;
    end;

    [Scope('Internal')]
    procedure ProcessPrincipal(LoanNo: Code[20])
    var
        AvailableforPrincipal: Decimal;
        Installment: Integer;
    begin
        AvailableforPrincipal := 0;
        IF (PaymentAmount < VFHeader."Principal Due") THEN
            AvailableforPrincipal := PaymentAmount
        ELSE
            AvailableforPrincipal := VFHeader."Principal Due";
        IF AvailableforPrincipal > 0 THEN BEGIN
            CreateVFJournal_HP.SetClearLoan(TRUE);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::Customer, LoanCustomer."No."
              , STRSUBSTNO('Principal against due of %1 cleared', LoanNo, VFLines."Installment No."),
              ROUND(-AvailableforPrincipal, 0.01, '=')
              , LoanNo, VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", VFLines."Installment No."
              , VFPostingType::Principal, FALSE, FALSE, TODAY, FALSE, TempCashReceiptNo, STRSUBSTNO('Principal against due of %1 Inst No %2', LoanNo, VFLines."Installment No."),
              VFHeader."Shortcut Dimension 3 Code");
        END;
        PaymentAmount := ROUND(PaymentAmount - AvailableforPrincipal, 1, '=');
    end;

    [Scope('Internal')]
    procedure DeleteJournalLines()
    var
        GenJnlLine: Record "81";
    begin
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", VFSetup."VF Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UserSetup."VF Posting Batch");
        GenJnlLine.DELETEALL(TRUE);
    end;

    [Scope('Internal')]
    procedure PostPaymentJournal()
    var
        GenJnlBatchPost: Codeunit "233";
        GenJnlLine: Record "81";
    begin
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", VFSetup."VF Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UserSetup."VF Posting Batch");
        IF GenJnlLine.FINDFIRST THEN BEGIN
            COMMIT;
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure ProcessDayEnd(LoanNo: Code[20])
    begin
        COMMIT;
        CODEUNIT.RUN(CODEUNIT::"Day End - Hire Purchase", VFHeader);

        PostPaymentJournal;
        DeleteJournalLines;

        VFHeader.GET(LoanNo);
    end;
}

