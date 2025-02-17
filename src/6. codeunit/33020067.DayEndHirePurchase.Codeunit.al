codeunit 33020067 "Day End - Hire Purchase"
{
    // Surya
    // 20 Jan 2016
    // Day End Procedure for Hire Purchase
    // 
    // Process:
    // 1. List out the loan files having outstanding dues as of today
    // 2. Scan Nominee account and check balance
    // 3. If balance is found on Nominee, transfer and apply amount to loan file
    // 4. Make receipt of amount only due as of today
    // 5. Leave remaining amount with Nominee

    TableNo = 33020062;

    trigger OnRun()
    var
        VFLines: Record "33020063";
        ActualPaymentAmount: Decimal;
    begin
        CLEARALL;
        VFHeader := Rec;
        CLEAR(CalculateEMI);
        CalculateEMI.CalculateDueAndNRV(VFHeader, TODAY);
        COMMIT;

        IF NOT LoanCustomer.GET(VFHeader."Customer No.") THEN
            ERROR(ErrNoLoanCustomer);
        IF NOT NomineeCustomer.GET("Nominee Account No.") THEN
            ERROR(ErrNoNomineeCustomer);
        DueAmountForDayEnd := ROUND("Total Due as of Today", 0.01, '=');
        IF DueAmountForDayEnd > 0 THEN BEGIN
            NomineeCustomer.CALCFIELDS("Balance (LCY)");
            PaymentAmount := NomineeCustomer."Balance (LCY)" * -1;
            IF PaymentAmount <= 0 THEN
                RegisterDayEndLog(VFHeader, ErrNoPaymentAmount)
            ELSE
                IF PaymentAmount > 0 THEN BEGIN
                    IF PaymentAmount > DueAmountForDayEnd THEN
                        PaymentAmount := DueAmountForDayEnd;
                    ActualPaymentAmount := PaymentAmount;
                    ProcessCashReceipt(VFHeader);
                    IF AppliedAmount < DueAmountForDayEnd THEN
                        RegisterDayEndLog(VFHeader, ErrLessPaymentAmount)
                    ELSE BEGIN
                        IF AppliedAmount = ActualPaymentAmount THEN
                            RegisterDayEndLog(VFHeader, InfoSuccess);
                    END;
                END;
        END;
        Rec := VFHeader;
        COMMIT;
    end;

    var
        VFHeader: Record "33020062";
        VFLines: Record "33020063";
        VFSetup: Record "33020064";
        LoanCustomer: Record "18";
        NomineeCustomer: Record "18";
        UserSetup: Record "91";
        CreateVFJournal_HP: Codeunit "33020063";
        CalculateEMI: Codeunit "33020062";
        DueAmountForDayEnd: Decimal;
        AppliedAmount: Decimal;
        PaymentAmount: Decimal;
        ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit;
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        VFPostingType: Option " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges",Prepayment,"Insurance Interest","Interest on CAD";
        TempCashReceiptNo: Code[20];
        ErrNoLoanCustomer: Label 'Loan Customer Account does not exists.';
        ErrNoNomineeCustomer: Label 'Nominee Account does not exists.';
        ErrNoPaymentAmount: Label 'Loan is due but there is no balance in nominee account.';
        ErrLessPaymentAmount: Label 'Payment Amount is less then due Amount.';
        InfoSuccess: Label 'Success';

    [Scope('Internal')]
    procedure ProcessCashReceipt(var VFHeader: Record "33020062")
    var
        RecVehFHeader: Record "33020062";
    begin
        VFSetup.GET;
        RecVehFHeader.RESET;
        RecVehFHeader.SETCURRENTKEY("Transfered Loan No.");
        RecVehFHeader.SETRANGE("Transfered Loan No.", "Application No.");
        IF NOT RecVehFHeader.FINDFIRST THEN
            VFHeader.TESTFIELD("Loan Disbursed");
        VFHeader.CALCFIELDS("Last Payment Date");
        VFHeader.CALCFIELDS(VIN);
        ProcessPaymentJournal;
    end;

    [Scope('Internal')]
    procedure ProcessPaymentJournal()
    begin
        //Nominee account debit, loan related accounts credit
        CreateVFJournal_HP.SetClearLoan(FALSE);
        CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
        CreateVFJournal_HP.LoanApproval(TODAY, AccountType::Customer, NomineeCustomer."No."
          , 'APPLIED to LOAN#' + VFHeader."Loan No.",
          ROUND(PaymentAmount, 0.01, '='), VFHeader."Loan No.", VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
          VFHeader."Shortcut Dimension 2 Code", 0, VFPostingType::Principal, FALSE, FALSE,
          TODAY, FALSE, '', 'APPLIED to LOAN#' + VFHeader."Loan No.", VFHeader."Shortcut Dimension 3 Code");
        AppliedAmount := PaymentAmount;

        ProcessCADInterest(VFHeader."Loan No.");
        ProcessInsuranceInterest(VFHeader."Loan No.");
        ProcessInsurance(VFHeader."Loan No.");
        ProcessOtherAmount(VFHeader."Loan No.");

        VFLines.RESET;
        VFLines.SETCURRENTKEY("Loan No.", "Installment No.");
        VFLines.SETRANGE("Loan No.", VFHeader."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        IF VFLines.FINDFIRST THEN BEGIN
            REPEAT
                IF VFLines."EMI Mature Date" <= TODAY THEN
                    ProcessPenalty(VFHeader."Loan No.");
            UNTIL NextInstallmentAvailable(VFLines) = FALSE;
        END;

        VFLines.RESET;
        VFLines.SETCURRENTKEY("Loan No.", "Installment No.");
        VFLines.SETRANGE("Loan No.", VFHeader."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        IF VFLines.FINDFIRST THEN BEGIN
            REPEAT
                IF VFLines."EMI Mature Date" <= TODAY THEN
                    ProcessInterest(VFHeader."Loan No.");
            UNTIL NextInstallmentAvailable(VFLines) = FALSE;
        END;

        VFLines.RESET;
        VFLines.SETCURRENTKEY("Loan No.", "Installment No.");
        VFLines.SETRANGE("Loan No.", VFHeader."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        IF VFLines.FINDFIRST THEN BEGIN
            REPEAT
                ProcessPrincipal(VFHeader."Loan No.");
            UNTIL NextInstallmentAvailable(VFLines) = FALSE;
        END;

        CalculateEMI.AvoidRounding(VFHeader."Loan No.", TempCashReceiptNo);
    end;

    [Scope('Internal')]
    procedure ProcessCADInterest(LoanNo: Code[20])
    var
        AvailableforCADInterest: Decimal;
    begin
        AvailableforCADInterest := 0;
        IF PaymentAmount < (VFHeader."Interest Due on CAD") THEN
            AvailableforCADInterest := PaymentAmount
        ELSE
            AvailableforCADInterest := (VFHeader."Interest Due on CAD");
        IF AvailableforCADInterest > 0 THEN BEGIN
            VFSetup.TESTFIELD("CAD Interest Posting Account");
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(FALSE);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::"G/L Account", VFSetup."CAD Interest Posting Account"
              , 'Cash rcpt against interest on CAD of ' + LoanNo,
              ROUND(-AvailableforCADInterest, 0.01, '=')
              , LoanNo, VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", 0
              , VFPostingType::"Interest on CAD", FALSE, FALSE, TODAY, FALSE, TempCashReceiptNo, 'Cash rcpt against interest on CAD of ' + LoanNo,
              VFHeader."Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - AvailableforCADInterest, 1, '=');
        END;
    end;

    [Scope('Internal')]
    procedure ProcessInsuranceInterest(LoanNo: Code[20])
    var
        AvailableforInsuranceInterest: Decimal;
    begin
        AvailableforInsuranceInterest := 0;
        IF PaymentAmount < (VFHeader."Interest Due on Insurance") THEN
            AvailableforInsuranceInterest := PaymentAmount
        ELSE
            AvailableforInsuranceInterest := (VFHeader."Interest Due on Insurance");
        IF AvailableforInsuranceInterest > 0 THEN BEGIN
            VFSetup.TESTFIELD("Insurance Int. Posting Account");
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(FALSE);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::"G/L Account", VFSetup."Insurance Int. Posting Account"
              , 'Cash rcpt against ins. interest Due of ' + LoanNo,
              ROUND(-AvailableforInsuranceInterest, 0.01, '=')
              , LoanNo, VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", 0
              , VFPostingType::"Insurance Interest", FALSE, FALSE, TODAY, FALSE, TempCashReceiptNo, 'Cash rcpt against ins. interest Due of ' + LoanNo,
              VFHeader."Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - AvailableforInsuranceInterest, 1, '=');
        END;
    end;

    [Scope('Internal')]
    procedure ProcessInsurance(LoanNo: Code[20])
    var
        AvailableforInsurance: Decimal;
    begin
        VFHeader.CALCFIELDS("Insurance Due");
        AvailableforInsurance := 0;
        IF PaymentAmount < (VFHeader."Insurance Due") THEN
            AvailableforInsurance := PaymentAmount
        ELSE
            AvailableforInsurance := (VFHeader."Insurance Due");
        IF AvailableforInsurance > 0 THEN BEGIN
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(FALSE);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::Customer, LoanCustomer."No."
              , 'Cash rcpt against insurance Due of ' + LoanNo,
              ROUND(-AvailableforInsurance, 0.01, '=')
              , LoanNo, VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", 0
              , VFPostingType::Insurance, FALSE, FALSE, TODAY, FALSE, TempCashReceiptNo, 'Cash rcpt against insurance Due of ' + LoanNo,
              VFHeader."Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - AvailableforInsurance, 1, '=');
        END;
    end;

    [Scope('Internal')]
    procedure ProcessOtherAmount(LoanNo: Code[20])
    var
        AvailableforOtherAmount: Decimal;
    begin
        VFHeader.CALCFIELDS("Other Amount Due");
        AvailableforOtherAmount := 0;
        IF PaymentAmount < (VFHeader."Other Amount Due") THEN
            AvailableforOtherAmount := PaymentAmount
        ELSE
            AvailableforOtherAmount := (VFHeader."Other Amount Due");
        IF AvailableforOtherAmount > 0 THEN BEGIN
            //VFSetup.TESTFIELD("Other Charges Account");
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(FALSE);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::Customer, LoanCustomer."No."
              , 'Cash rcpt against Other Amount Due of ' + LoanNo,
              ROUND(-AvailableforOtherAmount, 0.01, '=')
              , LoanNo, VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", 0
              , VFPostingType::"Other Charges", FALSE, FALSE, TODAY, FALSE, TempCashReceiptNo, 'Cash rcpt against Other Amount Due of ' + LoanNo,
              VFHeader."Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - AvailableforOtherAmount, 1, '=');

        END;
    end;

    [Scope('Internal')]
    procedure ProcessPenalty(LoanNo: Code[20])
    var
        AvailableforPenalty: Decimal;
    begin
        IF NOT VFLines."Wave Penalty" THEN BEGIN
            AvailableforPenalty := 0;
            IF PaymentAmount < (VFLines."Calculated Penalty") THEN
                AvailableforPenalty := PaymentAmount
            ELSE
                AvailableforPenalty := (VFLines."Calculated Penalty");
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(FALSE);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::"G/L Account", VFSetup."Penalty Posting Account"
              , 'Cash receipt against Penalty Due of ' + LoanNo,
              ROUND(-AvailableforPenalty, 0.01, '=')
              , LoanNo, VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", VFLines."Installment No."
              , VFPostingType::Penalty, FALSE, FALSE, TODAY, FALSE, TempCashReceiptNo, 'Cash receipt against Penalty Due of ' + LoanNo,
              VFHeader."Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - AvailableforPenalty, 1, '=');
        END;
    end;

    [Scope('Internal')]
    procedure ProcessInterest(LoanNo: Code[20])
    var
        AvailableforInterest: Decimal;
    begin
        AvailableforInterest := 0;
        VFLines.CALCFIELDS("Interest Paid");
        IF (PaymentAmount < (VFLines."Calculated Interest" - VFLines."Interest Paid")) THEN
            AvailableforInterest := PaymentAmount
        ELSE
            AvailableforInterest := (VFLines."Calculated Interest" - VFLines."Interest Paid");
        IF AvailableforInterest > 0 THEN BEGIN
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(FALSE);
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
        VFLines.CALCFIELDS("Principal Paid");
        IF (PaymentAmount < (VFLines."Calculated Principal" - VFLines."Principal Paid")) THEN
            AvailableforPrincipal := PaymentAmount
        ELSE
            AvailableforPrincipal := (VFLines."Calculated Principal" - VFLines."Principal Paid");
        IF AvailableforPrincipal > 0 THEN BEGIN
            CreateVFJournal_HP.SetClearLoan(FALSE);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::Customer, LoanCustomer."No."
              , STRSUBSTNO('Principal against due of %1 Inst No %2', LoanNo, VFLines."Installment No."),
              ROUND(-AvailableforPrincipal, 0.01, '=')
              , LoanNo, VFHeader.VIN, 'DEFAULT', VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", VFLines."Installment No."
              , VFPostingType::Principal, FALSE, FALSE, TODAY, FALSE, TempCashReceiptNo, STRSUBSTNO('Principal against due of %1 Inst No %2', LoanNo, VFLines."Installment No."),
              VFHeader."Shortcut Dimension 3 Code");
        END;
        PaymentAmount := ROUND(PaymentAmount - AvailableforPrincipal, 1, '=');
    end;

    [Scope('Internal')]
    procedure NextInstallmentAvailable(var VehicleFinanceLines: Record "33020063"): Boolean
    begin
        IF PaymentAmount > 0 THEN
            IF VehicleFinanceLines.NEXT <> 0 THEN BEGIN
                EXIT(TRUE);
            END;
        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure DeleteJournalLines()
    var
        GenJnlLine: Record "81";
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("VF Posting Batch");
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", VFSetup."VF Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UserSetup."VF Posting Batch");
        GenJnlLine.DELETEALL(TRUE);
    end;

    [Scope('Internal')]
    procedure PostPaymentJournal()
    var
        GenJournalBatch: Record "232";
        GenJnlBatchPost: Codeunit "233";
    begin
        GenJournalBatch.GET(VFSetup."VF Journal Template Name", UserSetup."VF Posting Batch");
        COMMIT;
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-B.Post", GenJournalBatch);
    end;

    [Scope('Internal')]
    procedure RegisterDayEndLog(VFHeader: Record "33020062"; ErrorText: Text)
    var
        HPDayEndLog: Record "33020083";
        LastEntryNo: Integer;
    begin
        HPDayEndLog.RESET;
        IF HPDayEndLog.FINDLAST THEN
            LastEntryNo := HPDayEndLog."Entry No"
        ELSE
            LastEntryNo := 0;
        CLEAR(HPDayEndLog);
        HPDayEndLog.INIT;
        HPDayEndLog."Entry No" := LastEntryNo + 1;
        HPDayEndLog."Loan No." := VFHeader."Loan No.";
        HPDayEndLog.Remarks := COPYSTR(ErrorText, 1, 250);
        HPDayEndLog."Loan Customer No." := LoanCustomer."No.";
        HPDayEndLog."Loan Customer Name" := LoanCustomer.Name;
        HPDayEndLog."Nominee Account No." := NomineeCustomer."No.";
        HPDayEndLog."Nominee Account Name" := NomineeCustomer.Name;
        HPDayEndLog.Date := TODAY;
        HPDayEndLog.Time := TIME;
        HPDayEndLog."Due Amount" := DueAmountForDayEnd;
        HPDayEndLog."Payment Amount" := AppliedAmount;
        HPDayEndLog.INSERT;
    end;
}

