codeunit 33020062 "Calculate EMI"
{
    // 28 NOV 2011: Surya
    // 
    // 1. Function to Calculate Initial EMI and Create Amortization Table for the subsequent loan customer
    // 2. Function to Reschedule loan
    // 3. If Recalculate flag is true system will recalculate the interest amount;
    // 
    // 29 August 2012: Surya
    // 
    // 1. Create Calculate Due Function
    // 
    // 6 September 2012: Surya
    // 
    // 1. Create AvoidRounding Function


    trigger OnRun()
    begin
    end;

    var
        Flag: Boolean;
        PreRate: Decimal;
        OK: Boolean;
        DifferentialDays: Integer;
        DifferentialInterest: Decimal;
        CreateVFJournal: Codeunit "33020063";
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        VFSetup: Record "33020064";
        VFPostingType: Option " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges",Prepayment,"Insurance Interest","Interest on CAD",Capitalization;
        VFLines: Record "33020063";
        EMIDelayDays: Integer;
        DueAmountPrincipal: Decimal;
        DueAmountInterest: Decimal;
        DueAmountPenalty: Decimal;
        Vehicle: Record "25006005";
        MakeCode: Code[20];
        ModelVersionCode: Code[20];
        DepreciationDays: Integer;
        DepreciationValue: Decimal;
        NRVDelayDays: Integer;
        TotalRecNo: Integer;
        Window: Dialog;
        RecNo: Integer;
        DueInstallment: Integer;
        "Calculation Date": Date;
        VFLine2: Record "33020063";
        LastPaymentDate: Date;
        SumCalPenalty: Decimal;
        SumPaidPenalty: Decimal;
        PenaltyAsOfNow: Decimal;
        VFLine: Record "33020063";
        CurrentDueInstallment: Integer;
        CurrentDuePrincipal: Decimal;
        VFPaymentRec: Record "33020072";
        DepreciationMonth: Decimal;
        DepreciationRatePerMonth: Decimal;
        TotalDue: Decimal;
        LoanStatus: Record "33020067";
        InterestSettled: Decimal;
        DaysSinceCaptured: Integer;
        FollowUp: Record "33020075";
        PrincipalPaidTotal: Decimal;
        VFHeader: Record "33020062";
        i: Integer;
        RescheduleLog: Record "33020071";
        UserSetup: Record "91";
        AdvancePayment: Boolean;
        NewCompanyName: Text[30];
        ChangeCompanyRec: Boolean;
        Text000: Label 'EMI Calculated successfully.';
        CalculatedDelayDays: Integer;
        CurrentEMI: Decimal;
        TempLoanAmount: Decimal;
        HideMessage: Boolean;

    [Scope('Internal')]
    procedure CalculateEMI(Principal: Decimal; InterestRate: Decimal; TenureInMonth: Integer; LoanNo: Code[20]; Recalculate: Boolean)
    var
        Rate: Decimal;
        EMI: Decimal;
        tValue: Decimal;
        FinanceLine: Record "33020074";
        InstallmentNo: Integer;
        MonthPrincipal: Decimal;
        MonthInterest: Decimal;
        LineNo: Integer;
        MonthBalance: Decimal;
        PreviousMonthBalance: Decimal;
        NextDate: Date;
        FinanceRec: Record "33020073";
        PaidVFLineChecking: Record "33020063";
        PreDueDate: Date;
        RunningPrincipleAmt: Decimal;
    begin
        Rate := ROUND(InterestRate / 12 / 100, 0.000001, '=');
        IF InterestRate = 0 THEN
            EMI := Principal / TenureInMonth
        ELSE
            EMI := Principal * Rate * POWER(1 + Rate, TenureInMonth) / (POWER(1 + Rate, TenureInMonth) - 1);
        RunningPrincipleAmt := Principal;
        FinanceLine.RESET;
        FinanceLine.SETRANGE("Application No.", LoanNo);
        //FinanceLine.SETRANGE(FinanceLine."Line Cleared",TRUE);
        IF FinanceLine.FINDFIRST THEN
            FinanceLine.DELETEALL;
        FinanceRec.SETRANGE("Application No.", LoanNo);
        IF FinanceRec.FINDFIRST THEN BEGIN

            InstallmentNo := 1;
            MonthPrincipal := Principal;

            WHILE InstallmentNo <> (TenureInMonth + 1) DO BEGIN
                IF InstallmentNo = 1 THEN BEGIN
                    MonthBalance := Principal * (1 + Rate) - EMI;
                    MonthInterest := Rate * Principal;
                END ELSE BEGIN
                    MonthBalance := PreviousMonthBalance * (1 + Rate) - EMI;
                    MonthInterest := Rate * PreviousMonthBalance;
                END;

                MonthPrincipal := EMI - MonthInterest;

                //FinanceLine.INIT;
                IF NOT FinanceLine.GET(LoanNo, LineNo + 10000) THEN BEGIN

                    FinanceLine."Application No." := LoanNo;
                    FinanceLine."Line No." := LineNo + 10000;
                END;
                IF InstallmentNo = 1 THEN
                    FinanceLine."EMI Mature Date" := FinanceRec."First Installment Date"
                ELSE
                    FinanceLine."EMI Mature Date" := CALCDATE('<+1M>', NextDate);
                FinanceLine."Installment No." := InstallmentNo;
                FinanceLine."EMI Amount" := EMI;
                FinanceLine."Calculated Principal" := MonthPrincipal;
                FinanceLine."Calculated Interest" := MonthInterest;
                FinanceLine.Balance := MonthBalance;
                PreviousMonthBalance := MonthBalance;

                // Check already Paid installments Added
                IF InstallmentNo <> 1 THEN
                    FinanceLine."Duration of days fr Prev. Mnth" := FinanceLine."EMI Mature Date" - NextDate;
                IF NOT (RunningPrincipleAmt < 0) THEN
                    FinanceLine."Remaining Principal Amount" := RunningPrincipleAmt - FinanceLine."Principal Paid";
                PaidVFLineChecking.SETRANGE(PaidVFLineChecking."Loan No.", FinanceLine."Application No.");
                PaidVFLineChecking.SETRANGE(PaidVFLineChecking."Line No.", FinanceLine."Line No.");
                IF PaidVFLineChecking.FINDFIRST THEN BEGIN
                    IF NOT PaidVFLineChecking."Line Cleared" THEN
                        FinanceLine.MODIFY;
                    IF Recalculate THEN;
                    //CreateLogOnIntRateChange(FinanceLine,InterestRate);
                END
                ELSE BEGIN
                    // Check already Paid installments
                    FinanceLine.INSERT;
                END;
                NextDate := FinanceLine."EMI Mature Date";
                RunningPrincipleAmt := RunningPrincipleAmt - FinanceLine."Principal Paid"; //bolcked
                InstallmentNo += 1;
                LineNo += 10000;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure RescheduleEMI(LoanNo: Code[20]; InstNo: Integer; NewInterestRate: Decimal; NewPrincipal: Decimal; NewTenure: Integer; NewEffectiveDate: Date; ReasonText: Text[100]; DocumentDate: Date; CheckofBank: Text[50]; CheckNo: Code[20]; DepositedToBank: Code[20]; PrepaymentAmount: Decimal) IsRescheduled: Boolean
    var
        Rate: Decimal;
        EMI: Decimal;
        VFHeaderRS: Record "33020062";
        VFLinesRS: Record "33020063";
        VFPaymentLineRS: Record "33020072";
        LastLineNo: Integer;
        InstallmentNo: Integer;
        PreviousMonthBalance: Decimal;
        MonthBalance: Decimal;
        MonthInterest: Decimal;
        MonthPrincipal: Decimal;
        LastInstallmentDate: Date;
        PrincipalToAdd: Decimal;
        Text0001: Label 'The loan no. %1 is already closed. Cannot post reschedling entries.';
        BatchName: Code[20];
        OldPrincipal: Decimal;
        LoanControlAccount: Code[20];
        NewMaturityDate: Date;
        LastLogNo: Integer;
        OldInstNo: Integer;
        ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit;
    begin
        LastLineNo := 0;
        PreviousMonthBalance := 0;

        //get last installment balance
        OldInstNo := InstNo;
        IF InstNo = 1 THEN
            InstNo := 2;
        VFLinesRS.RESET;
        VFLinesRS.SETRANGE("Loan No.", LoanNo);
        VFLinesRS.SETRANGE("Installment No.", InstNo - 1);
        IF VFLinesRS.FINDLAST THEN BEGIN
            LastLineNo := VFLinesRS."Line No.";
            PreviousMonthBalance := VFLinesRS.Balance;
            LastInstallmentDate := VFLinesRS."EMI Mature Date";
            IF VFLinesRS."Installment No." > 1 THEN //AGILE.17.02 10 feb 2017
                IF VFLinesRS."Line Cleared" = FALSE THEN
                    ERROR('Cannot reschedule loan since the installment no. %1 is not cleared.', InstNo - 1);
        END ELSE
            ERROR('No lines found for rescheduling.');

        InstNo := OldInstNo;
        //AGILE.16.08 21 AUG 2016 >>
        /*
        IF LastInstallmentDate <> NewEffectiveDate THEN BEGIN
          NewMaturityDate := NewEffectiveDate;
          VFLinesRS.RESET;
          VFLinesRS.SETRANGE("Loan No.",LoanNo);
          VFLinesRS.SETRANGE("Line Cleared",FALSE);
          IF VFLinesRS.FINDSET THEN REPEAT
            VFLinesRS."EMI Mature Date" := NewMaturityDate;
            VFLinesRS.MODIFY;
            NewMaturityDate := CALCDATE('<+1M>',NewMaturityDate);
          UNTIL VFLinesRS.NEXT = 0;
          EXIT(true);
        END;
        */
        //AGILE.16.08 21 AUG 2016 <<

        VFLinesRS.RESET;
        VFLinesRS.SETRANGE("Loan No.", LoanNo);
        VFLinesRS.SETRANGE("Installment No.", InstNo);
        IF VFLinesRS.FINDFIRST THEN BEGIN
            IF VFLinesRS."Line Cleared" THEN
                ERROR('Cannot reschedule loan since the installment no. %1 is already cleared.', InstNo);
            IF VFLinesRS."Defer Principal" THEN
                ERROR('Cannot reschedule loan when the principal is deferred for installment no. %1', InstNo);
        END;


        Rate := ROUND(NewInterestRate / 12 / 100, 0.000001, '=');
        NewTenure := (NewTenure - (InstNo - 1));

        VFHeader.RESET;
        VFHeader.SETRANGE("Loan No.", LoanNo);
        IF VFHeader.FINDFIRST THEN;
        EMI := NewPrincipal * Rate * POWER(1 + Rate, NewTenure) / (POWER(1 + Rate, NewTenure) - 1);
        InstallmentNo := InstNo;

        //delete and recreate lines
        i := 1;

        LastInstallmentDate := NewEffectiveDate;
        VFLinesRS.RESET;
        VFLinesRS.SETRANGE("Loan No.", LoanNo);
        VFLinesRS.SETFILTER("Installment No.", '>=%1', InstNo);
        IF VFLinesRS.FINDFIRST THEN BEGIN
            VFLinesRS.CALCFIELDS("Principal Paid");
            PreviousMonthBalance := (NewPrincipal + PrincipalToAdd);
            VFLinesRS.DELETEALL;
            WHILE i <> (NewTenure + 1) DO BEGIN
                CLEAR(VFLinesRS);
                VFLinesRS.INIT;
                IF i = 1 THEN
                    VFLinesRS.Rescheduled := TRUE;
                MonthBalance := PreviousMonthBalance * (1 + Rate) - EMI;
                MonthInterest := Rate * PreviousMonthBalance;
                MonthPrincipal := EMI - MonthInterest;
                VFLinesRS."Loan No." := LoanNo;
                VFLinesRS."Line No." := LastLineNo + 10000;
                IF i = 1 THEN
                    VFLinesRS."EMI Mature Date" := LastInstallmentDate
                ELSE
                    VFLinesRS."EMI Mature Date" := CALCDATE('<+1M>', LastInstallmentDate);
                VFLinesRS."Installment No." := InstallmentNo;
                VFLinesRS."EMI Amount" := EMI;
                VFLinesRS."Calculated Principal" := MonthPrincipal;
                VFLinesRS."Calculated Interest" := MonthInterest;
                VFLinesRS.Balance := MonthBalance;
                PreviousMonthBalance := MonthBalance;
                VFLinesRS.INSERT;
                LastInstallmentDate := VFLinesRS."EMI Mature Date";
                InstallmentNo += 1;
                i += 1;
                LastLineNo += 10000;
            END;

            //update remaining principal and last payment date
            VFHeader.SETRANGE("Loan No.", LoanNo);
            IF VFHeader.FINDFIRST THEN BEGIN
                CLEAR(PrincipalPaidTotal);
                VFLine.RESET;
                VFLine.SETRANGE("Loan No.", LoanNo);
                VFLine.SETFILTER("Installment No.", '%1..%2', InstNo, InstallmentNo);
                IF VFLine.FINDFIRST THEN BEGIN
                    REPEAT
                        VFLine.CALCFIELDS("Principal Paid");
                        VFLine.CALCFIELDS("Last Payment Received Date");
                        PrincipalPaidTotal := VFLine."Principal Paid";
                        VFLine."Last Payment Date" := VFLine."Last Payment Received Date";
                        IF VFLine."Installment No." = InstNo THEN
                            VFLine."Remaining Principal Amount" := NewPrincipal
                        ELSE
                            VFLine."Remaining Principal Amount" := NewPrincipal - PrincipalPaidTotal;
                        VFLine.MODIFY;
                    UNTIL VFLine.NEXT = 0;
                END;
            END;
            //update reschedule log
            VFHeaderRS.GET(LoanNo);
            VFHeaderRS.CALCFIELDS("Total Principal Paid");
            RescheduleLog.RESET;
            RescheduleLog.SETRANGE(Date, TODAY);
            RescheduleLog.SETRANGE("Vehicle Finance No.", LoanNo);
            RescheduleLog.SETRANGE("Installment No.", InstNo);
            IF RescheduleLog.FINDLAST THEN
                LastLogNo := RescheduleLog."Line No." + 1
            ELSE
                LastLogNo := 1;

            CLEAR(RescheduleLog);
            RescheduleLog.INIT;
            RescheduleLog.Date := TODAY;
            RescheduleLog."Effective Date" := NewEffectiveDate;
            RescheduleLog."Reason for Rescheduling" := ReasonText;
            RescheduleLog."Vehicle Finance No." := LoanNo;
            RescheduleLog."Installment No." := InstNo;
            RescheduleLog."Line No." := LastLogNo;
            OldPrincipal := VFHeaderRS."Loan Amount";
            RescheduleLog."Old Principal" := OldPrincipal;
            RescheduleLog."Old Interest Rate" := VFHeaderRS."Interest Rate";
            RescheduleLog."Old Tenure" := VFHeaderRS."Tenure in Months";
            RescheduleLog."Remaining Principal" := VFHeaderRS."Loan Amount" - VFHeaderRS."Total Principal Paid" - GetTotalPrepaymentPaid(LoanNo);
            RescheduleLog."New Principal" := NewPrincipal;
            RescheduleLog."Total New Principal" := VFHeaderRS."Total Principal Paid" + NewPrincipal;
            RescheduleLog."New Interest Rate" := NewInterestRate;
            RescheduleLog."New Tenure" := (NewTenure + (InstNo - 1));
            RescheduleLog."Change in Principal" := PrepaymentAmount;
            RescheduleLog."Prepayment Amount" := PrepaymentAmount;
            RescheduleLog."User ID" := USERID;
            RescheduleLog."Check of Bank" := CheckofBank;
            RescheduleLog."Deposited to Bank" := DepositedToBank;
            RescheduleLog."Check No." := CheckNo;
            RescheduleLog."Reschedule Type" := RescheduleLog."Reschedule Type"::EMI;
            RescheduleLog.INSERT;
            IsRescheduled := TRUE;

            //update Vehicle Finance Header
            TempLoanAmount := 0;
            TempLoanAmount := VFHeaderRS."Total Principal Paid" + NewPrincipal;
            VFSetup.GET;
            VFHeaderRS."Interest Rate" := NewInterestRate;
            VFHeaderRS."Penalty %" := NewInterestRate + VFSetup."Penalty % - Interest %"; //ZM mar 15, 2017
            VFHeaderRS."Tenure in Months" := (NewTenure + (InstNo - 1));
            VFHeaderRS.MODIFY;


            //create journal entry to adjust changes in principal while rescheduling
            COMMIT;

            //Send SMS while rescheduling >>>
            SMSOnRescheduleEMI(RescheduleLog, VFHeaderRS);
            //Send SMS while rescheduling <<

            IF (TempLoanAmount - OldPrincipal) <> 0 THEN BEGIN
                IF VFHeaderRS.Closed THEN
                    ERROR(Text0001, LoanNo);

                VFSetup.GET;
                VFSetup.TESTFIELD("VB Journal Batch Name");
                VFSetup.TESTFIELD("Loan Control Account");
                UserSetup.GET(USERID);
                BatchName := VFSetup."VB Journal Batch Name";
                CreateVFJournal.SetReceiptType(ReceiptType::Installment);
                CreateVFJournal.LoanApproval(TODAY, AccountType::Customer, VFHeaderRS."Customer No.", 'Loan reschedlued for File No.' + LoanNo,
                  -PrepaymentAmount, LoanNo, '', BatchName, VFHeaderRS."Shortcut Dimension 1 Code",
                  VFHeaderRS."Shortcut Dimension 2 Code", InstNo, VFPostingType::Prepayment, TRUE, FALSE, DocumentDate, FALSE, '', 'Loan Prepayment',
                  VFHeaderRS."Shortcut Dimension 3 Code");

                CreateVFJournal.LoanApproval(TODAY, AccountType::Customer, VFHeaderRS."Nominee Account No."
                  , 'Loan reschedlued for File No. ' + LoanNo,
                  PrepaymentAmount, LoanNo, '', BatchName, VFHeaderRS."Shortcut Dimension 1 Code",
                  VFHeaderRS."Shortcut Dimension 2 Code", InstNo, VFPostingType::Principal, TRUE, FALSE, DocumentDate, FALSE, '', 'Loan Prepayment',
                  VFHeaderRS."Shortcut Dimension 3 Code");
            END;
        END;
        EXIT(IsRescheduled);

    end;

    [Scope('Internal')]
    procedure CreateLogOnIntRateChange(VFiLinesForLogEntry: Record "33020063"; CurrInterestRt: Decimal)
    var
        VFIntRtChangLog: Record "33020071";
        VFIntRtChangLogVersion: Record "33020071";
        lVFHeader: Record "33020062";
    begin
    end;

    [Scope('Internal')]
    procedure CalculateInterestRate(VFHeader: Record "33020062"; VFLine: Record "33020063"): Decimal
    var
        "Payment Received Date": Date;
    begin
        IF NOT Flag THEN
            IF (VFLine."Last Payment Received Date" <> 0D) THEN BEGIN
                Flag := TRUE;
                IF VFHeader."Interest Rate" = 0 THEN
                    EXIT(VFLine."Remaining Principal Amount" * VFHeader."Interest Rate" *
                    (("Payment Received Date" - VFLine."Last Payment Received Date")) / (100 * 365))
                ELSE
                    EXIT(VFLine."Remaining Principal Amount" * VFHeader."Interest Rate" *
                    (("Payment Received Date" - VFLine."Last Payment Received Date")) / (100 * 365));
            END
            ELSE BEGIN
                Flag := TRUE;
                IF VFHeader."Interest Rate" = 0 THEN
                    EXIT(VFLine."Remaining Principal Amount" * VFHeader."Interest Rate" *
                    (("Payment Received Date" - VFHeader."Disbursement Date") - VFHeader."Credit Allowded Days (CAD)") / (100 * 365))
                ELSE
                    //MESSAGE(FORMAT((("Payment Received Date"-"Disbursement Date")-"Credit Allowded Days (CAD)")));
                    EXIT(VFLine."Remaining Principal Amount" * VFHeader."Interest Rate" *
            (("Payment Received Date" - VFHeader."Disbursement Date") - VFHeader."Credit Allowded Days (CAD)") / (100 * 365));
            END
    end;

    [Scope('Internal')]
    procedure TotalAmountDueAsOnDate(lVFLine: Record "33020063"): Decimal
    var
        PenaltyAmount: Decimal;
        InterestAmount: Decimal;
        PrincipalAmount: Decimal;
    begin
    end;

    [Scope('Internal')]
    procedure Penaltycal(VFinHrd: Record "33020062"; VFinLine: Record "33020063"): Decimal
    begin
    end;

    [Scope('Internal')]
    procedure UpdateRemainingPrincipal(LoanNo: Code[20]; InstallmentNo: Integer)
    var
        PrincipalPaidTotal: Decimal;
        VFLine: Record "33020063";
    begin
    end;

    [Scope('Internal')]
    procedure UpdateLineClear(LoanNo: Code[20])
    begin
    end;

    [Scope('Internal')]
    procedure CalculateDueAndNRV(var VFRec: Record "33020062"; CalculationDate: Date)
    var
        PenaltyDays: Integer;
        NRVSetup: Record "33020066";
        NRVValue: Decimal;
        DepreciationRate: Decimal;
        InterestDue: Decimal;
        PreviousDueDays: Integer;
    begin
        IF ChangeCompanyRec THEN
            NRVSetup.CHANGECOMPANY(NewCompanyName);
        CLEAR(LastPaymentDate);
        CLEAR(EMIDelayDays);
        CLEAR(DueAmountPrincipal);
        CLEAR(DueAmountInterest);
        CLEAR(DueAmountPenalty);
        CLEAR(NRVDelayDays);
        CLEAR(DueInstallment);
        CLEAR(TotalDue);
        CLEAR(AdvancePayment);
        CLEAR(CalculatedDelayDays);
        CLEAR(VFRec."Interest Due Defered");
        CLEAR(CurrentEMI);

        //Calculate Dues as of Today
        IF ChangeCompanyRec THEN
            VFSetup.CHANGECOMPANY(NewCompanyName);
        VFSetup.GET;
        "Calculation Date" := CalculationDate;

        AdjustVFPaymentLines(VFRec);

        VFLines.RESET;
        IF ChangeCompanyRec THEN
            VFLines.CHANGECOMPANY(NewCompanyName);
        VFLines.SETRANGE("Loan No.", VFRec."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        IF VFLines.FINDFIRST THEN BEGIN
            CurrentEMI := VFLines."EMI Amount";
            VFLine2.RESET;
            IF ChangeCompanyRec THEN
                VFLine2.CHANGECOMPANY(NewCompanyName);
            VFLine2.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine2.SETFILTER("Last Payment Date", '<>%1', 0D);
            VFLine2.SETFILTER("Principal Paid", '<>%1', 0);
            IF VFLine2.FIND('+') THEN
                LastPaymentDate := VFLine2."Last Payment Date"
            ELSE BEGIN
                LastPaymentDate := CALCDATE('-1M', VFLines."EMI Mature Date");
            END;

            //---last payment from vehicle payment line to be used for interest calculation
            VFPaymentRec.RESET;
            IF ChangeCompanyRec THEN
                VFPaymentRec.CHANGECOMPANY(NewCompanyName);
            VFPaymentRec.SETRANGE("Loan No.", VFRec."Loan No.");
            VFPaymentRec.SETFILTER("Principal Paid", '>%1', 0);
            VFPaymentRec.SETFILTER("Payment Date", '<=%1', CalculationDate);
            IF VFPaymentRec.FINDLAST THEN
                LastPaymentDate := VFPaymentRec."Payment Date"
            ELSE
                LastPaymentDate := CALCDATE('-1M', VFLines."EMI Mature Date");

            /*
            IF CalculationDate < LastPaymentDate THEN
              ERROR('Calculation date cannot be earlier than Last Payment Date.');
            */

            //Due installment and principal as of today
            VFLine2.RESET;
            IF ChangeCompanyRec THEN
                VFLine2.CHANGECOMPANY(NewCompanyName);
            VFLine2.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine2.SETRANGE("Line Cleared", FALSE);
            VFLine2.SETFILTER("EMI Mature Date", '<=%1', CalculationDate);
            IF VFLine2.FINDFIRST THEN BEGIN
                CalculatedDelayDays := "Calculation Date" - VFLine2."EMI Mature Date"; //SM 09 01 2015
                CLEAR(CurrentDueInstallment);
                CLEAR(CurrentDuePrincipal);
                REPEAT
                    VFLine2.CALCFIELDS("Principal Paid");
                    CurrentDueInstallment += 1;
                    CurrentDuePrincipal += VFLine2."Calculated Principal" - VFLine2."Principal Paid";
                UNTIL VFLine2.NEXT = 0;
            END;


            EMIDelayDays := "Calculation Date" - LastPaymentDate;
            IF NRVDelayDays = 0 THEN
                NRVDelayDays := EMIDelayDays;

            VFLine2.RESET;
            IF ChangeCompanyRec THEN
                VFLine2.CHANGECOMPANY(NewCompanyName);
            VFLine2.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine2.SETRANGE("Line Cleared", TRUE);
            IF VFLine2.FINDFIRST THEN
                REPEAT
                    VFLine2."Calculated Penalty" := 0;
                    VFLine2.MODIFY;
                UNTIL VFLine2.NEXT = 0;


            VFLine2.RESET;
            IF ChangeCompanyRec THEN
                VFLine2.CHANGECOMPANY(NewCompanyName);
            VFLine2.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine2.SETRANGE("Line Cleared", TRUE);
            IF VFLine2.FINDLAST THEN
                IF VFLine2."EMI Mature Date" >= "Calculation Date" THEN BEGIN
                    NRVDelayDays := 0;
                    AdvancePayment := TRUE;
                END;

            //delay days
            VFLines."Delay by No. of Days" := EMIDelayDays;
            VFRec."Due Installment as of Today" := CurrentDueInstallment;
            VFRec."Due Principal" := CurrentDuePrincipal;

            VFRec."Due Calculated as of" := "Calculation Date";
            // due days
            VFRec.CALCFIELDS("Date Last Line Cleared");
            IF VFRec."Date Last Line Cleared" <> 0D THEN BEGIN
                //if calculationdate > VFRec."Date Last Line Cleared" then
                VFRec."No of Due Days" := CalculationDate - VFRec."Date Last Line Cleared";
                //   IF VFRec."No of Due Days" < 0 THEN
                //     VFRec."No of Due Days" := 0;
            END ELSE
                VFRec."No of Due Days" := CalculationDate - VFRec."First Installment Date";

            IF VFRec."No of Due Days" < 0 THEN
                VFRec."No of Due Days" := 0;

            SumCalPenalty := 0;
            SumPaidPenalty := 0;

            VFLine.RESET;
            IF ChangeCompanyRec THEN
                VFLine.CHANGECOMPANY(NewCompanyName);
            VFLine.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine.SETRANGE("Line Cleared", FALSE);
            //VFLine.SETFILTER("EMI Mature Date",'<%1',CalculationDate);
            IF VFLine.FINDFIRST THEN BEGIN
                //if calculationdate < vfline."EMI Mature Date" then
                //  VFRec."No of Due Days" := 0;
                REPEAT
                    VFLine."Calculated Penalty" := 0;
                    VFLine."Delay by No. of Days" := 0;
                    VFLine.CALCFIELDS("Principal Paid", "Interest Paid");
                    IF ROUND(VFLine."Calculated Principal", 0.01, '=') <> ROUND(VFLine."Principal Paid", 0.01, '=') THEN BEGIN
                        IF VFLine."EMI Mature Date" < CalculationDate THEN BEGIN
                            PreviousDueDays := GetPartialPaymentDays(VFLine."Loan No.", VFLine."Installment No.");
                            IF PreviousDueDays > (CalculationDate - VFLine."EMI Mature Date") THEN
                                VFLine."Delay by No. of Days" := 0
                            ELSE
                                VFLine."Delay by No. of Days" := (CalculationDate - VFLine."EMI Mature Date") - PreviousDueDays;
                            IF NOT VFLine."Wave Penalty" THEN BEGIN
                                //VFLine."Calculated Penalty" := (VFLine."Calculated Principal" + VFLine."Calculated Interest" -
                                //VFLine."Principal Paid" - VFLine."Interest Paid") * (VFRec."Penalty %" /100) * (VFLine."Delay by No. of Days"/365);
                                VFLine."Calculated Penalty" := (VFLine."Calculated Principal" - VFLine."Principal Paid") *     //prabesh 12-6-23
                                                        (VFRec."Penalty %" / 100) * (VFLine."Delay by No. of Days" / 365);
                                VFLine."Calculated Penalty" += GetRemainingPenalty(VFLine);
                            END;
                        END;
                    END;
                    VFLine.MODIFY;
                UNTIL VFLine.NEXT = 0;
            END;
            REPEAT
                DueInstallment += 1;
            UNTIL VFLines.NEXT = 0;

            VFRec."Due Installments" := DueInstallment;

            VFLine.RESET;
            IF ChangeCompanyRec THEN
                VFLine.CHANGECOMPANY(NewCompanyName);
            VFLine.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine.SETRANGE("Line Cleared", FALSE);
            IF VFLine.FINDFIRST THEN BEGIN
                REPEAT
                    VFLine.CALCFIELDS("Penalty Paid");
                    SumCalPenalty += VFLine."Calculated Penalty";
                    SumPaidPenalty += VFLine."Penalty Paid";
                UNTIL VFLine.NEXT = 0;
            END;

            //VFRec."Penalty Due" := SumCalPenalty - SumPaidPenalty;
            VFRec."Penalty Due" := SumCalPenalty;
            VFRec.MODIFY;
        END;

        VFLines.RESET;
        IF ChangeCompanyRec THEN
            VFLines.CHANGECOMPANY(NewCompanyName);
        VFLines.SETRANGE("Loan No.", VFRec."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        IF VFLines.FINDFIRST THEN BEGIN
            VFRec."Principal Due" := ROUND(VFLines."Remaining Principal Amount", 0.01, '=');
            //CurrentEMI := VFLines."EMI Amount";
            //interest paid after last principal payment date
            CLEAR(InterestSettled);
            VFPaymentRec.RESET;
            IF ChangeCompanyRec THEN
                VFPaymentRec.CHANGECOMPANY(NewCompanyName);
            VFPaymentRec.SETRANGE("Loan No.", VFRec."Loan No.");
            VFPaymentRec.SETFILTER("Payment Date", '>%1', LastPaymentDate);
            IF VFPaymentRec.FINDFIRST THEN
                REPEAT
                    InterestSettled += VFPaymentRec."Interest Paid";
                UNTIL VFPaymentRec.NEXT = 0;

            //VFRec."Interest Due" := (VFLines."Remaining Principal Amount" * (EMIDelayDays/365) * (VFRec."Interest Rate"/100))
            //                        - InterestSettled;
        END ELSE
            VFRec."Principal Due" := ROUND(VFRec."Loan Amount", 0.01, '=');

        InterestDue := 0;
        VFLines.RESET;
        IF ChangeCompanyRec THEN
            VFLines.CHANGECOMPANY(NewCompanyName);
        VFLines.SETRANGE("Loan No.", VFRec."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        VFLines.SETFILTER("EMI Mature Date", '<=%1', CalculationDate);
        IF VFLines.FINDFIRST THEN
            REPEAT
                VFLines.CALCFIELDS("Interest Paid");
                InterestDue += VFLines."Calculated Interest" - VFLines."Interest Paid";
            UNTIL VFLines.NEXT = 0;

        VFRec."Interest Due" := InterestDue;

        // Interest Due Deferred begin
        VFLines.RESET;
        IF ChangeCompanyRec THEN
            VFLines.CHANGECOMPANY(NewCompanyName);
        VFLines.SETRANGE("Loan No.", VFRec."Loan No.");
        VFLines.SETFILTER("EMI Mature Date", '<=%1', CalculationDate);
        IF VFLines.FINDLAST THEN BEGIN
            VFRec."Due Installment Days" := CalculationDate - VFLines."EMI Mature Date";
            VFLines.SETFILTER("EMI Mature Date", '>=%1', CalculationDate);
            VFLines.SETRANGE("Line Cleared", FALSE);
            IF VFLines.FINDFIRST THEN BEGIN
                //VFRec."Interest Due Defered" := (VFLines."Remaining Principal Amount") * VFRec."Interest Rate" / 100
                //         * (VFRec."Due Installment Days") /365
                IF VFLines."Remaining Principal Amount" > 0 THEN
                    VFRec."Interest Due Defered" := ROUND((VFLines."Remaining Principal Amount" - VFRec."Due Principal") * VFRec."Interest Rate" / 100
                               * (VFRec."Due Installment Days") / 365, 0.01, '=');   //ZM Aug 15, 2018 Rounding Added
            END
            ELSE
                VFRec."Interest Due Defered" := 0;
        END;
        VFRec."Total Int. Due to clear Loan" := VFRec."Interest Due Defered" + VFRec."Interest Due";
        // Interest Due Deferred end

        //TotalDue := VFRec."Principal Due" + VFRec."Interest Due" + VFRec."Penalty Due" + VFRec."Interest Due Defered";
        //VFRec."Total Due" := TotalDue;

        VFRec.CALCFIELDS("Insurance Due", "Other Amount Due", "Interest Paid on Insurance");

        //11 APRIL 2016 >>
        //VFRec."Interest Due on Insurance" := GetInterestOnInsuranceDue(VFRec."Loan No.",VFRec."Insurance Due",CalculationDate,VFRec."Interest Rate",VFRec."Interest Paid on Insurance");
        VFRec."Interest Due on Insurance" := GetInterestOnInsuranceDue2(VFRec."Loan No.", VFRec."Insurance Due", CalculationDate, VFRec."Interest Rate", VFRec."Interest Paid on Insurance");    //ZM Jan 22, 2019
        VFRec."Interest Due on Insurance" := ROUND(VFRec."Interest Due on Insurance", 0.01, '='); //ZM Nov 21, 2018
                                                                                                  //11 APRIL 2016 <<

        VFRec."Total Due as of Today" := VFRec."Interest Due" + VFRec."Penalty Due" + VFRec."Insurance Due"
                                           + VFRec."Other Amount Due" + VFRec."Due Principal" + VFRec."Interest Due on Insurance" + VFRec."Interest Due on CAD";

        VFRec."Total Due as of Today" := ROUND(VFRec."Total Due as of Today", 0.01); //ZM Oct 6,2016

        //ZM Aug 05, 2018 >>
        TotalDue := VFRec."Principal Due" + VFRec."Penalty Due" + VFRec."Total Int. Due to clear Loan" +
                     VFRec."Insurance Due" + VFRec."Other Amount Due" + VFRec."Interest Due on Insurance" +
                      VFRec."Interest Due on CAD";

        /*
        message('"Principal Due" >> %1\"Penalty Due" >>%2\"Total Int. Due to clear Loan" >> %3\"Insurance Due" >> %4\"Other Amount Due" >> %5\"Interest Due on Insurance" >> %6\"Interest Due on CAD" >> %7TotalDue >>    %8',
                VFRec."Principal Due",
                VFRec."Penalty Due" ,
                VFRec."Total Int. Due to clear Loan" ,
                VFRec."Insurance Due" ,
                VFRec."Other Amount Due",
                VFRec."Interest Due on Insurance" ,
                VFRec."Interest Due on CAD",
                TotalDue);
        */
        //VFRec."Total Due"  := TotalDue;
        VFRec."Total Due" := ROUND(TotalDue, 0.01, '=');   //ZM Nov 21, 2018
                                                           //ZM Aug 05, 2018 <<

        VFRec."Due Days Crossed Maturity" := CalculatedDelayDays; //SM 09.01.2015
        VFRec."EMI Amount" := CurrentEMI;
        VFRec.CALCFIELDS("Total Interest Paid on CAD");
        IF VFRec."Interest on CAD" > VFRec."Total Interest Paid on CAD" THEN
            VFRec."Interest Due on CAD" := VFRec."Interest on CAD" - VFRec."Total Interest Paid on CAD"
        ELSE
            VFRec."Interest Due on CAD" := 0;
        VFRec.MODIFY;

        VFLines.RESET;
        IF ChangeCompanyRec THEN
            VFLines.CHANGECOMPANY(NewCompanyName);
        VFLines.SETRANGE("Loan No.", VFRec."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        IF NOT VFLines.FINDFIRST THEN BEGIN
            SumCalPenalty := 0;
            SumPaidPenalty := 0;
            VFLine.RESET;
            IF ChangeCompanyRec THEN
                VFLine.CHANGECOMPANY(NewCompanyName);
            VFLine.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine.SETRANGE("Line Cleared", FALSE);
            IF VFLine.FINDFIRST THEN BEGIN
                REPEAT
                    VFLine.CALCFIELDS("Penalty Paid");
                    SumCalPenalty += VFLine."Calculated Penalty";
                    SumPaidPenalty += VFLine."Penalty Paid";
                UNTIL VFLine.NEXT = 0;
            END;
            //VFRec."Penalty Due" := SumCalPenalty - SumPaidPenalty;
            VFRec."Penalty Due" := SumCalPenalty;
            VFRec.CALCFIELDS("Insurance Due", "Other Amount Due");
            VFRec."Due Installment as of Today" := 0;
            VFRec."Due Principal" := 0;
            VFRec."Principal Due" := 0;
            VFRec."Interest Due" := 0;
            VFRec."Due Installments" := 0;
            VFRec."No of Due Days" := 0;

            VFRec."Total Due" := VFRec."Insurance Due" + VFRec."Other Amount Due" + VFRec."Penalty Due" + VFRec."Interest Due on Insurance";
            VFRec."Total Due" := ROUND(VFRec."Total Due", 0.01, '=');
            /*  VFRec."Total Due" := VFRec."Penalty Due" + VFRec."Total Int. Due to clear Loan" +
                         VFRec."Insurance Due" + VFRec."Other Amount Due" + VFRec."Interest Due on Insurance" +
                          VFRec."Interest Due on CAD";
            */

            VFRec.MODIFY;
        END;

        //Net Realization Value & Status
        IF ChangeCompanyRec THEN
            VFSetup.CHANGECOMPANY(NewCompanyName);
        VFSetup.GET;
        Vehicle.RESET;
        IF ChangeCompanyRec THEN
            Vehicle.CHANGECOMPANY(NewCompanyName);

        Vehicle.SETRANGE("Serial No.", VFRec."Vehicle No.");
        IF Vehicle.FINDFIRST THEN BEGIN
            ModelVersionCode := Vehicle."Model Version No.";
            NRVSetup.SETRANGE("Model Version", ModelVersionCode);
            IF NRVSetup.FINDFIRST THEN BEGIN
                //IF VFRec."Sales Invoice Date" <> 0D THEN BEGIN
                IF VFRec."Disbursement Date" <> 0D THEN BEGIN
                    DepreciationDays := "Calculation Date" - VFRec."Disbursement Date"; //VFRec."Sales Invoice Date";     //ZM Feb 15, 2018
                                                                                        /*
                                                                                        IF VFRec."Market Price" = 0 THEN
                                                                                           VFRec."Market Price" := NRVSetup."Market Price";
                                                                                        */
                    IF VFRec."Depreciation Rate" = 0 THEN
                        VFRec."Depreciation Rate" := NRVSetup."Depreciation Rate";

                    //STPL.17.03 27 MAR 2017 >>
                    IF VFRec."Market Price" = 0 THEN
                        VFRec."Market Price" := VFRec."Vehicle Cost";

                    //STPL.17.03 27 MAR 2017 <<
                    VFRec.MODIFY;
                    VFRec.TESTFIELD("Market Price");
                    VFRec.TESTFIELD("Depreciation Rate");

                    NRVValue := VFRec."Market Price";
                    DepreciationRate := VFRec."Depreciation Rate";

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Daily THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays, 1, '=');
                        DepreciationRatePerMonth := (DepreciationRate / 100) / 365;

                        IF DepreciationMonth > VFRec."Tenure in Months" * 365 / 12 THEN
                            DepreciationMonth := ROUND(VFRec."Tenure in Months" * 365 / 12, 1, '=');          //ZM Feb 15 2018

                    END;

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Monthly THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays / 30, 1, '=');
                        DepreciationRatePerMonth := (DepreciationRate / 100) / 12;

                        IF DepreciationMonth > VFRec."Tenure in Months" THEN
                            DepreciationMonth := VFRec."Tenure in Months";            //ZM Feb 15 2018

                    END;

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Yearly THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays / 365, 1, '=');
                        DepreciationRatePerMonth := (DepreciationRate / 100);

                        IF DepreciationMonth > VFRec."Tenure in Months" / 12 THEN
                            DepreciationMonth := ROUND(VFRec."Tenure in Months" / 12, 1, '=');       //ZM Feb 15 2018

                    END;

                    WHILE DepreciationMonth > 0 DO BEGIN
                        DepreciationValue := ROUND(NRVValue * DepreciationRatePerMonth, 0.1, '=');  //* DepreciationMonth;     //ZM Feb 15 2018
                        NRVValue -= DepreciationValue;
                        DepreciationMonth -= 1;
                    END;

                    VFRec."Net Realization Value" := ROUND(NRVValue, 1, '=');
                    IF (NRVValue < TotalDue) AND (NOT AdvancePayment) THEN
                        VFRec."NRV Status" := VFRec."NRV Status"::Risky
                    ELSE
                        VFRec."NRV Status" := VFRec."NRV Status"::"Risk Free";
                    VFRec."NRV Calculation Date" := "Calculation Date";
                    NRVDelayDays := VFRec."No of Due Days";
                    VFRec.MODIFY;
                END;
            END;
        END;

        //Loan Status
        LoanStatus.RESET;
        IF ChangeCompanyRec THEN
            LoanStatus.CHANGECOMPANY(NewCompanyName);
        IF LoanStatus.FINDFIRST THEN BEGIN
            REPEAT
                IF (CalculatedDelayDays >= LoanStatus."From Days") AND (CalculatedDelayDays <= LoanStatus."To Days") THEN BEGIN //SM 03 Sep 2015
                    VFRec."Loan Status" := LoanStatus."Loan Status";
                    VFRec.MODIFY;
                END;
            UNTIL LoanStatus.NEXT = 0;
        END;
        IF VFRec."Principal Due" = 0 THEN BEGIN
            VFRec."Loan Status" := VFRec."Loan Status"::Performing;
            VFRec."NRV Status" := VFRec."NRV Status"::"Risk Free";
            VFRec.MODIFY;
        END;

        //Update followed up within 30 days
        FollowUp.RESET;
        IF ChangeCompanyRec THEN
            FollowUp.CHANGECOMPANY(NewCompanyName);
        FollowUp.SETRANGE("Loan No.", VFRec."Loan No.");
        FollowUp.SETFILTER("Follow-Up Date", '%1..%2', CALCDATE('-1M', TODAY), TODAY);
        IF FollowUp.FINDFIRST THEN BEGIN
            VFRec."Followed Up in Last 30 Days" := TRUE;
            VFRec.MODIFY;
        END ELSE BEGIN
            VFRec."Followed Up in Last 30 Days" := FALSE;
            VFRec.MODIFY;
        END;

    end;

    [Scope('Internal')]
    procedure CloseLoanFile(VFRec: Record "33020062")
    begin
    end;

    [Scope('Internal')]
    procedure AvoidRounding(LoanNo: Code[20]; ExtDocumentNo: Code[20])
    var
        GenJnlLine: Record "81";
        PostedAmount: Decimal;
    begin
        GenJnlLine.SETRANGE(GenJnlLine."VF Loan File No.", LoanNo);
        GenJnlLine.SETRANGE(GenJnlLine."External Document No.", ExtDocumentNo);
        IF GenJnlLine.FINDFIRST THEN
            REPEAT
                PostedAmount += GenJnlLine.Amount;
            UNTIL GenJnlLine.NEXT = 0;
        IF (PostedAmount <> 0) THEN BEGIN
            GenJnlLine.SETRANGE(GenJnlLine."VF Loan File No.", LoanNo);
            GenJnlLine.SETRANGE(GenJnlLine."External Document No.", ExtDocumentNo);
            IF GenJnlLine.FINDLAST THEN BEGIN
                GenJnlLine.VALIDATE(Amount, GenJnlLine.Amount - PostedAmount);
                GenJnlLine.MODIFY;
                IF GenJnlLine.Amount = 0 THEN
                    GenJnlLine.DELETE(TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeInterestRate(VFHeader: Record "33020062"; VFLines: Record "33020063")
    begin
    end;

    [Scope('Internal')]
    procedure ChangeSMSCompany(_CompanyName: Text[30])
    begin
        NewCompanyName := _CompanyName;
        ChangeCompanyRec := TRUE;
        VFSetup.CHANGECOMPANY(NewCompanyName);
        VFLines.CHANGECOMPANY(NewCompanyName);
        Vehicle.CHANGECOMPANY(NewCompanyName);
        VFLine2.CHANGECOMPANY(NewCompanyName);
        VFLine.CHANGECOMPANY(NewCompanyName);
        VFPaymentRec.CHANGECOMPANY(NewCompanyName);
        LoanStatus.CHANGECOMPANY(NewCompanyName);
        FollowUp.CHANGECOMPANY(NewCompanyName);
        VFHeader.CHANGECOMPANY(NewCompanyName);
        RescheduleLog.CHANGECOMPANY(NewCompanyName);
        UserSetup.CHANGECOMPANY(NewCompanyName);
    end;

    [Scope('Internal')]
    procedure RescheduleTenure(PrepaymentAmount: Decimal; InterestRate: Decimal; LoanNo: Code[10]; ReasonText: Text[100]; DocumentDate: Date; CheckofBank: Text[50]; CheckNo: Code[20]; DepositedToBank: Code[20]; IsLoanCapitalization: Boolean): Boolean
    var
        VFHeader: Record "33020062";
        VFLine: Record "33020063";
        VFLineArchive: Record "33020078";
        RemainingPrincipal: Decimal;
        LineNumber: Integer;
        EMIDate: Date;
        ArchiveNo: Integer;
        InstallmentNo: Integer;
        EMIAmount: Decimal;
        TotalInstallments: Integer;
        PrincipalBalance: Decimal;
        AdvancePrincipal: Decimal;
        RescheduleAmount: Decimal;
        EffectiveDate: Date;
        OldPrincipal: Decimal;
        OldTenure: Integer;
        BatchName: Code[10];
        RescheduleInstallment: Integer;
        ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit;
        NewPrincipalAmount: Decimal;
        RescheduledLine: Record "33020063";
        CalculatedRemAmt: Decimal;
        PrincipalDueasofToday: Decimal;
        FirstLine: Integer;
    begin
        //archive vf lines before rescheduling
        //edited to add capitalization processes - 21 July 2020 - //Surya
        CLEAR(ArchiveNo);
        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", LoanNo);
        IF VFLine.FINDFIRST THEN BEGIN
            OldTenure := VFLine.COUNT;
            VFLineArchive.RESET;
            VFLineArchive.SETRANGE("Loan No.", LoanNo);
            IF VFLineArchive.FINDLAST THEN
                ArchiveNo := VFLineArchive."Archive No." + 1
            ELSE
                ArchiveNo := 1;
            REPEAT
                VFLineArchive."Loan No." := VFLine."Loan No.";
                VFLineArchive."Archive No." := ArchiveNo;
                VFLineArchive."Line No." := VFLine."Line No.";
                VFLineArchive."EMI Mature Date" := VFLine."EMI Mature Date";
                VFLineArchive."EMI Amount" := VFLine."EMI Amount";
                VFLineArchive."Calculated Principal" := VFLine."Calculated Principal";
                VFLineArchive."Calculated Interest" := VFLine."Calculated Interest";
                VFLineArchive.Balance := VFLine.Balance;
                VFLineArchive."Installment No." := VFLine."Installment No.";
                VFLineArchive."Calculated Rebate" := VFLine."Calculated Rebate";
                VFLineArchive."Actual Balance" := VFLine."Actual Balance";
                VFLineArchive."Line Cleared" := VFLine."Line Cleared";
                VFLineArchive."Last Payment Date" := VFLine."Last Payment Date";
                VFLineArchive."Duration of days fr Prev. Mnth" := VFLine."Duration of days fr Prev. Mnth";
                VFLineArchive."Remaining Principal Amount" := VFLine."Remaining Principal Amount";
                VFLineArchive."Pending Interest" := VFLine."Pending Interest";
                VFLineArchive."Interest Rate" := VFLine."Interest Rate";
                VFLineArchive."Temp Calculated Penalty" := VFLine."Temp Calculated Penalty";
                VFLineArchive."Old Interest Rate" := VFLine."Old Interest Rate";
                VFLineArchive."New Interest Rate" := VFLine."New Interest Rate";
                VFLineArchive."Temp Penalty Delay Days" := VFLine."Temp Penalty Delay Days";
                VFLineArchive."SMS Logs Created" := VFLine."SMS Logs Created";
                VFLineArchive."SMS Entry No." := VFLine."SMS Entry No.";
                VFLineArchive.INSERT;
            UNTIL VFLine.NEXT = 0;
        END;


        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", LoanNo);
        VFLine.SETRANGE("Line Cleared", TRUE);
        IF VFLine.FINDLAST THEN BEGIN
            EMIDate := VFLine."EMI Mature Date";
            InstallmentNo := VFLine."Installment No.";
            RescheduleInstallment := VFLine."Installment No." + 1;
            LineNumber := VFLine."Line No.";
            EMIAmount := VFLine."EMI Amount";
        END ELSE BEGIN
            VFLine.SETRANGE("Line Cleared", FALSE);
            IF VFLine.FINDFIRST THEN BEGIN
                EMIDate := VFLine."EMI Mature Date";
                InstallmentNo := 0;
                RescheduleInstallment := 1;
                LineNumber := VFLine."Line No.";
                EMIAmount := VFLine."EMI Amount";
            END;
        END;

        IF IsLoanCapitalization THEN BEGIN                          //capitalization
            VFHeader.SETRANGE("Loan No.", LoanNo);
            IF VFHeader.FINDFIRST THEN BEGIN
                RescheduleInstallment += VFHeader."Due Installment as of Today";
                PrincipalDueasofToday := VFHeader."Due Principal";
            END;
            VFLine.RESET;
            VFLine.SETRANGE("Loan No.", LoanNo);
            VFLine.SETRANGE("Installment No.", RescheduleInstallment);
            IF VFLine.FINDFIRST THEN BEGIN
                EMIDate := CALCDATE('<-1M>', VFLine."EMI Mature Date");     //correction required
                LineNumber := VFLine."Line No." - 10000;
                EMIAmount := VFLine."EMI Amount";
                InstallmentNo := VFLine."Installment No." - 1;
                FirstLine := InstallmentNo;
            END;
        END;

        RescheduledLine.RESET;
        RescheduledLine.SETRANGE("Loan No.", LoanNo);
        RescheduledLine.SETRANGE("Line Cleared", TRUE);
        IF RescheduledLine.FINDLAST THEN BEGIN
            CalculatedRemAmt := RescheduledLine."Remaining Principal Amount" - PrepaymentAmount;
        END
        ELSE BEGIN
            RescheduledLine.RESET;
            RescheduledLine.SETRANGE("Loan No.", LoanNo);
            RescheduledLine.SETRANGE("Line Cleared", FALSE);
            IF RescheduledLine.FINDFIRST THEN BEGIN
                CalculatedRemAmt := RescheduledLine."Remaining Principal Amount" - PrepaymentAmount;
            END;
        END;


        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", LoanNo);
        VFLine.SETRANGE("Line Cleared", FALSE);
        IF IsLoanCapitalization THEN
            VFLine.SETFILTER("Installment No.", '>=%1', RescheduleInstallment);
        IF VFLine.FINDFIRST THEN BEGIN
            VFLine.CALCFIELDS("Principal Paid");
            AdvancePrincipal := VFLine."Principal Paid";
            PrincipalBalance := VFLine."Remaining Principal Amount" - PrepaymentAmount;
            //RemainingPrincipal := PrincipalBalance + AdvancePrincipal;
            IF NOT IsLoanCapitalization THEN
                RemainingPrincipal := PrincipalBalance
            ELSE
                RemainingPrincipal := PrincipalBalance - PrincipalDueasofToday;        //**

            CalculatedRemAmt := RemainingPrincipal;
            EffectiveDate := VFLine."EMI Mature Date";
            VFLine.DELETEALL;
        END;

        VFLine.RESET;

        NewPrincipalAmount := 0;

        WHILE RemainingPrincipal > EMIAmount DO BEGIN
            CLEAR(VFLine);
            VFLine.INIT;
            VFLine."Loan No." := LoanNo;
            VFLine."Line No." := LineNumber + 10000;
            VFLine."Installment No." := InstallmentNo + 1;
            EMIDate := CALCDATE('<+1M>', EMIDate);
            VFLine."EMI Mature Date" := EMIDate;
            VFLine."EMI Amount" := EMIAmount;
            VFLine."Calculated Interest" := (RemainingPrincipal * InterestRate / 12) / 100;
            VFLine."Calculated Principal" := EMIAmount - VFLine."Calculated Interest";
            RemainingPrincipal -= VFLine."Calculated Principal";
            VFLine.Balance := RemainingPrincipal;
            VFLine."Remaining Principal Amount" := CalculatedRemAmt; //RemainingPrincipal;
            IF (InstallmentNo = FirstLine) AND IsLoanCapitalization THEN
                VFLine."Loan Capitalized" := TRUE;
            IF NewPrincipalAmount = 0 THEN
                NewPrincipalAmount := VFLine."Calculated Principal" + VFLine.Balance;
            LineNumber += 10000;
            InstallmentNo += 1;
            VFLine.INSERT;
        END;

        IF RemainingPrincipal > 0 THEN BEGIN
            CLEAR(VFLine);
            VFLine.INIT;
            VFLine."Loan No." := LoanNo;
            VFLine."Line No." := LineNumber + 10000;
            VFLine."Installment No." := InstallmentNo + 1;
            VFLine."EMI Mature Date" := CALCDATE('<+1M>', EMIDate);
            VFLine."Calculated Principal" := RemainingPrincipal;
            VFLine."Calculated Interest" := (RemainingPrincipal * InterestRate / 12) / 100;
            VFLine."EMI Amount" := VFLine."Calculated Principal" + VFLine."Calculated Interest";
            VFLine.Balance := RemainingPrincipal - VFLine."Calculated Principal";
            VFLine.INSERT;
        END;

        VFHeader.SETRANGE("Loan No.", LoanNo);
        VFHeader.FINDFIRST;
        VFHeader.CALCFIELDS("Total Principal Paid");
        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", LoanNo);

        //update reschedule log
        RescheduleLog.INIT;
        RescheduleLog.Date := TODAY;
        RescheduleLog."Effective Date" := EffectiveDate;
        RescheduleLog."Reason for Rescheduling" := ReasonText;
        RescheduleLog."Vehicle Finance No." := LoanNo;
        RescheduleLog."Installment No." := RescheduleInstallment;
        OldPrincipal := VFHeader."Loan Amount";
        RescheduleLog."Old Principal" := OldPrincipal;
        RescheduleLog."Old Interest Rate" := VFHeader."Interest Rate";
        RescheduleLog."Old Tenure" := OldTenure;
        RescheduleLog."Remaining Principal" := VFHeader."Loan Amount" - VFHeader."Total Principal Paid";
        RescheduleLog."New Principal" := NewPrincipalAmount;
        RescheduleLog."New Interest Rate" := InterestRate;
        RescheduleLog."New Tenure" := VFLine.COUNT;
        ;
        RescheduleLog."User ID" := USERID;
        RescheduleLog."Reschedule Type" := RescheduleLog."Reschedule Type"::Tenure;
        RescheduleLog."Prepayment Amount" := PrepaymentAmount;
        RescheduleLog."Check of Bank" := CheckofBank;
        RescheduleLog."Deposited to Bank" := DepositedToBank;
        RescheduleLog."Check No." := CheckNo;
        RescheduleLog.INSERT;
        //  IsRescheduled := TRUE;

        //post prepayment journal


        VFSetup.GET;
        VFSetup.TESTFIELD("VB Journal Batch Name");
        VFSetup.TESTFIELD("Loan Control Account");
        UserSetup.GET(USERID);
        BatchName := VFSetup."VB Journal Batch Name";
        COMMIT;// 11 JUNE 2015 >>

        //Send SMS while rescheduling >>>
        SMSOnRescheduleTenure(RescheduleLog, VFHeader);
        //Send SMS while rescheduling <<

        IF NOT IsLoanCapitalization THEN BEGIN
            CreateVFJournal.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal.LoanApproval(TODAY, AccountType::Customer, VFHeader."Customer No.", 'Loan prepayment for File No.' + LoanNo,
              -PrepaymentAmount, LoanNo, '', BatchName, VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", RescheduleInstallment, VFPostingType::Prepayment, TRUE, FALSE, DocumentDate, FALSE, '', '',
              VFHeader."Shortcut Dimension 3 Code");

            CreateVFJournal.LoanApproval(TODAY, AccountType::Customer, VFHeader."Nominee Account No."
              , 'Loan reschedlued for File No. ' + LoanNo,
              PrepaymentAmount, LoanNo, '', BatchName, VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", RescheduleInstallment, VFPostingType::Principal, TRUE, FALSE, DocumentDate, FALSE, '', '',
              VFHeader."Shortcut Dimension 3 Code");
        END ELSE BEGIN              //loan capitalization related journal entries
            CreateVFJournal.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal.LoanApproval(TODAY, AccountType::Customer, VFHeader."Nominee Account No.", 'Loan capitalization for File No.' + LoanNo,
              PrepaymentAmount, LoanNo, '', BatchName, VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", RescheduleInstallment, VFPostingType::Capitalization, TRUE, FALSE, DocumentDate, FALSE, '', '',
              VFHeader."Shortcut Dimension 3 Code");

            CreateVFJournal.LoanApproval(TODAY, AccountType::Customer, VFHeader."Customer No."
              , 'Loan capitalized for File No. ' + LoanNo,
              -PrepaymentAmount, LoanNo, '', BatchName, VFHeader."Shortcut Dimension 1 Code",
              VFHeader."Shortcut Dimension 2 Code", RescheduleInstallment, VFPostingType::Capitalization, TRUE, FALSE, DocumentDate, FALSE, '', '',
              VFHeader."Shortcut Dimension 3 Code");
        END;

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CalculateEMIAfterApproval(Principal: Decimal; InterestRate: Decimal; TenureInMonth: Integer; LoanNo: Code[20]; Recalculate: Boolean)
    var
        Rate: Decimal;
        EMI: Decimal;
        tValue: Decimal;
        FinanceLine: Record "33020063";
        InstallmentNo: Integer;
        MonthPrincipal: Decimal;
        MonthInterest: Decimal;
        LineNo: Integer;
        MonthBalance: Decimal;
        PreviousMonthBalance: Decimal;
        NextDate: Date;
        FinanceRec: Record "33020062";
        PreDueDate: Date;
        RunningPrincipleAmt: Decimal;
        RecordInserted: Boolean;
    begin
        Rate := ROUND(InterestRate / 12 / 100, 0.000001, '=');
        IF InterestRate = 0 THEN
            EMI := Principal / TenureInMonth
        ELSE
            EMI := Principal * Rate * POWER(1 + Rate, TenureInMonth) / (POWER(1 + Rate, TenureInMonth) - 1);
        RunningPrincipleAmt := Principal;
        FinanceLine.RESET;
        FinanceLine.SETRANGE("Loan No.", LoanNo);
        //FinanceLine.SETRANGE(FinanceLine."Line Cleared",TRUE);
        IF FinanceLine.FINDFIRST THEN
            FinanceLine.DELETEALL;
        FinanceRec.SETRANGE("Loan No.", LoanNo);
        IF FinanceRec.FINDFIRST THEN BEGIN

            InstallmentNo := 1;
            MonthPrincipal := Principal;

            WHILE InstallmentNo <> (TenureInMonth + 1) DO BEGIN
                IF InstallmentNo = 1 THEN BEGIN
                    MonthBalance := Principal * (1 + Rate) - EMI;
                    MonthInterest := Rate * Principal;
                END ELSE BEGIN
                    MonthBalance := PreviousMonthBalance * (1 + Rate) - EMI;
                    MonthInterest := Rate * PreviousMonthBalance;
                END;

                MonthPrincipal := EMI - MonthInterest;

                //FinanceLine.INIT;
                IF NOT FinanceLine.GET(LoanNo, LineNo + 10000) THEN BEGIN

                    FinanceLine."Loan No." := LoanNo;
                    FinanceLine."Line No." := LineNo + 10000;
                END;
                IF InstallmentNo = 1 THEN
                    FinanceLine."EMI Mature Date" := FinanceRec."First Installment Date"
                ELSE
                    FinanceLine."EMI Mature Date" := CALCDATE('<+1M>', NextDate);
                FinanceLine."Installment No." := InstallmentNo;
                FinanceLine."EMI Amount" := EMI;
                FinanceLine."Calculated Principal" := MonthPrincipal;
                FinanceLine."Calculated Interest" := MonthInterest;
                FinanceLine.Balance := MonthBalance;
                PreviousMonthBalance := MonthBalance;

                // Check already Paid installments Added
                IF InstallmentNo <> 1 THEN
                    FinanceLine."Duration of days fr Prev. Mnth" := FinanceLine."EMI Mature Date" - NextDate;
                IF NOT (RunningPrincipleAmt < 0) THEN
                    FinanceLine."Remaining Principal Amount" := RunningPrincipleAmt - FinanceLine."Principal Paid";

                FinanceLine.INSERT;
                RecordInserted := TRUE;
                NextDate := FinanceLine."EMI Mature Date";
                RunningPrincipleAmt := RunningPrincipleAmt - FinanceLine."Principal Paid"; //blocked
                InstallmentNo += 1;
                LineNo += 10000;
            END;
        END;
        IF RecordInserted THEN
            MESSAGE(Text000);
    end;

    [Scope('Internal')]
    procedure GetPartialPaymentDays(LoanNo: Code[20]; InstallmentNo: Integer) TotalDays: Decimal
    var
        VFPaymentLines: Record "33020072";
    begin
        VFPaymentLines.RESET;
        VFPaymentLines.SETRANGE("Loan No.", LoanNo);
        VFPaymentLines.SETRANGE("Installment No.", InstallmentNo);
        IF VFPaymentLines.FINDSET THEN
            REPEAT
                TotalDays += VFPaymentLines."Delay by No. of Days";
            UNTIL VFPaymentLines.NEXT = 0;
        EXIT(TotalDays);
    end;

    [Scope('Internal')]
    procedure CreateNomineeAccount(LoanAccountNo: Code[20]; var NomineeAccountNo: Code[20]; var NomineeAccountName: Text[50])
    var
        Customer: Record "18";
        NACustomer: Record "18";
        VFSetup: Record "33020064";
        NoSeriesMgt: Codeunit "396";
        Text001: Label 'Nominee account already exists for customer %1.';
        Text002: Label 'Do you want to create Nominee Account for Customer %1?';
        Text003: Label 'Nominee account %1 created for customer %2.';
    begin
        IF NOT HideMessage THEN
            IF NOT CONFIRM(Text002, FALSE, LoanAccountNo) THEN
                EXIT;
        Customer.RESET;
        Customer.SETRANGE("No.", LoanAccountNo);
        Customer.FINDFIRST;

        IF Customer."Nominee Account" <> '' THEN
            ERROR(Text001, Customer."No.");

        VFSetup.GET;
        CLEAR(NACustomer);
        NACustomer.INIT;
        IF NACustomer."No." = '' THEN BEGIN
            VFSetup.TESTFIELD("Nominee Account Nos.");
            NoSeriesMgt.InitSeries(VFSetup."Nominee Account Nos.", NACustomer."No. Series", 0D, NACustomer."No.", NACustomer."No. Series");
        END;

        NACustomer.SetInsertFromContact(TRUE);
        NACustomer.TRANSFERFIELDS(Customer, FALSE);
        IF VFSetup."Nominee Account Posting Group" <> '' THEN
            NACustomer."Customer Posting Group" := VFSetup."Nominee Account Posting Group";
        NACustomer.Type := NACustomer.Type::Nominee;

        NACustomer.INSERT(TRUE);

        Customer."Nominee Account" := NACustomer."No.";
        Customer.MODIFY(TRUE);

        NomineeAccountNo := NACustomer."No.";
        NomineeAccountName := NACustomer.Name;
        IF NOT HideMessage THEN
            MESSAGE(Text003, NomineeAccountNo, Customer."No.");
    end;

    [Scope('Internal')]
    procedure CreateNomineeAccounts()
    var
        VFHeader: Record "33020062";
        LoanCustomer: Record "18";
        NomineeCustomer: Record "18";
    begin
        HideMessage := TRUE;
        VFHeader.RESET;
        VFHeader.SETRANGE(Closed, FALSE);
        VFHeader.SETRANGE("Loan Disbursed", TRUE);
        VFHeader.SETRANGE(Approved, TRUE);
        IF VFHeader.FINDSET THEN
            REPEAT
                LoanCustomer.RESET;
                LoanCustomer.SETRANGE("No.", VFHeader."Customer No.");
                IF LoanCustomer.FINDFIRST THEN BEGIN
                    IF LoanCustomer."Nominee Account" = '' THEN BEGIN
                        CreateNomineeAccount(LoanCustomer."No.", VFHeader."Nominee Account No.", VFHeader."Nominee Account Name");
                    END
                    ELSE BEGIN
                        NomineeCustomer.RESET;
                        NomineeCustomer.SETRANGE("No.", LoanCustomer."Nominee Account");
                        IF NomineeCustomer.FINDFIRST THEN BEGIN
                            VFHeader."Nominee Account No." := NomineeCustomer."No.";
                            VFHeader."Nominee Account Name" := NomineeCustomer.Name;
                        END;
                    END;
                    VFHeader.MODIFY(TRUE);
                END;
            UNTIL VFHeader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetInterestOnInsuranceDue(LoanNo: Code[20]; InsuranceDue: Decimal; CalculationDate: Date; InterestRatePercent: Decimal; InterestPaidOnInsurance: Decimal) InsuranceInterest: Decimal
    var
        VehicleFinancePaymentLines: Record "33020072";
        DueDays: Integer;
        InterestRate: Decimal;
    begin
        IF InsuranceDue > 0 THEN BEGIN
            VehicleFinancePaymentLines.RESET;
            IF ChangeCompanyRec THEN
                VehicleFinancePaymentLines.CHANGECOMPANY(NewCompanyName);
            VehicleFinancePaymentLines.SETRANGE("Loan No.", LoanNo);
            VehicleFinancePaymentLines.SETRANGE("Installment No.", 0);
            VehicleFinancePaymentLines.SETFILTER("Insurance Paid", '<>%1', 0);
            IF VehicleFinancePaymentLines.FINDLAST THEN BEGIN
                DueDays := CalculationDate - VehicleFinancePaymentLines."G/L Posting Date";
                InterestRate := InterestRatePercent / 100;
                IF DueDays > 0 THEN BEGIN
                    InsuranceInterest := (InterestRate * DueDays * InsuranceDue) / 365 - InterestPaidOnInsurance;
                END;
            END;
        END;
        EXIT(InsuranceInterest);
    end;

    [Scope('Internal')]
    procedure GetRemainingPenalty(VFLine: Record "33020063"): Decimal
    var
        VehicleFinancePaymentLines: Record "33020072";
        TotalPenalty: Decimal;
        PenaltyPaid: Decimal;
    begin
        VehicleFinancePaymentLines.RESET;
        IF ChangeCompanyRec THEN
            VehicleFinancePaymentLines.CHANGECOMPANY(NewCompanyName);
        VehicleFinancePaymentLines.SETRANGE("Loan No.", VFLine."Loan No.");
        VehicleFinancePaymentLines.SETRANGE("Installment No.", VFLine."Installment No.");
        VehicleFinancePaymentLines.SETRANGE("Posting Type", VehicleFinancePaymentLines."Posting Type"::Penalty);
        IF VehicleFinancePaymentLines.FINDFIRST THEN
            REPEAT
                TotalPenalty += VehicleFinancePaymentLines."Calculated Penalty";
                PenaltyPaid += VehicleFinancePaymentLines."Penalty Paid";
            UNTIL VehicleFinancePaymentLines.NEXT = 0;
        EXIT(TotalPenalty - PenaltyPaid);
    end;

    [Scope('Internal')]
    procedure GetTotalPrepaymentPaid(LoanNo: Code[20]) TotalPrepaymentPaid: Decimal
    var
        VehicleFinancePaymentLines: Record "33020072";
    begin
        VehicleFinancePaymentLines.RESET;
        IF ChangeCompanyRec THEN
            VehicleFinancePaymentLines.CHANGECOMPANY(NewCompanyName);
        VehicleFinancePaymentLines.SETRANGE("Loan No.", LoanNo);
        IF VehicleFinancePaymentLines.FINDFIRST THEN
            REPEAT
                TotalPrepaymentPaid += VehicleFinancePaymentLines."Prepayment Paid";
            UNTIL VehicleFinancePaymentLines.NEXT = 0;
        EXIT(TotalPrepaymentPaid);
    end;

    [Scope('Internal')]
    procedure SMSOnRescheduleEMI(var RescheduleLog2: Record "33020071"; var VFHeader2: Record "33020062")
    var
        STPLMgt: Codeunit "50000";
        VFLineRec: Record "33020063";
        VariationText: Text;
        NewAmount: Decimal;
        PerChange: Decimal;
        MobileNo: Text[30];
        RescheduleLineNo: Integer;
        StartDate: Date;
        Customer: Record "18";
        VFLineRec2: Record "33020063";
    begin
        PerChange := RescheduleLog2."New Interest Rate" - RescheduleLog2."Old Interest Rate";
        IF (RescheduleLog2."Prepayment Amount" = 0) AND (PerChange <> 0) THEN BEGIN
            NewAmount := 0;
            VFLineRec.RESET;
            VFLineRec.SETRANGE("Loan No.", VFHeader2."Loan No.");
            VFLineRec.SETRANGE(Rescheduled, TRUE);
            IF VFLineRec.FINDLAST THEN BEGIN
                NewAmount := VFLineRec."EMI Amount";
                RescheduleLineNo := VFLineRec."Line No.";
                VFLineRec2.RESET;
                VFLineRec2.SETRANGE("Loan No.", VFHeader2."Loan No.");
                VFLineRec2.SETFILTER("Line No.", '<%1', RescheduleLineNo);
                IF VFLineRec2.FINDLAST THEN
                    StartDate := VFLineRec2."EMI Mature Date" + 1;
            END;
            IF PerChange < 0 THEN
                VariationText := 'decreased'
            ELSE
                IF PerChange > 0 THEN
                    VariationText := 'increased';
            Customer.GET(VFHeader2."Customer No.");
            STPLMgt.InserRescheduleSMS(0, VFHeader2."Loan No.", 20, Customer."Mobile No.", COMPANYNAME, '', VariationText, StartDate, NewAmount, ABS(PerChange));
        END;
    end;

    [Scope('Internal')]
    procedure SMSOnRescheduleTenure(var RescheduleLog2: Record "33020071"; var VFHeader2: Record "33020062")
    var
        STPLMgt: Codeunit "50000";
        VFLineRec: Record "33020063";
        VariationText: Text;
        NewAmount: Decimal;
        PerChange: Decimal;
        MobileNo: Text[30];
        RescheduleLineNo: Integer;
        StartDate: Date;
        Customer: Record "18";
    begin
        PerChange := RescheduleLog2."New Interest Rate" - RescheduleLog2."Old Interest Rate";
        IF (RescheduleLog2."Prepayment Amount" = 0) AND (PerChange <> 0) THEN BEGIN
            NewAmount := 0;
            VFLineRec.RESET;
            VFLineRec.SETRANGE("Loan No.", VFHeader2."Loan No.");
            VFLineRec.SETRANGE(Rescheduled, TRUE);
            IF VFLineRec.FINDLAST THEN BEGIN
                RescheduleLineNo := VFLineRec."Installment No.";
            END;
            VFLineRec.RESET;
            VFLineRec.SETRANGE("Loan No.", VFHeader2."Loan No.");
            VFLineRec.SETRANGE("Installment No.", RescheduleLineNo - 1);
            IF VFLineRec.FINDFIRST THEN BEGIN
                StartDate := VFLineRec."EMI Mature Date" + 1;
            END;
            VFLineRec.RESET;
            VFLineRec.SETRANGE("Loan No.", VFHeader2."Loan No.");
            IF VFLineRec.FINDLAST THEN
                NewAmount := VFLineRec."Installment No.";

            IF PerChange < 0 THEN
                VariationText := 'decreased'
            ELSE
                IF PerChange > 0 THEN
                    VariationText := 'increased';
            Customer.GET(VFHeader2."Customer No.");
            STPLMgt.InserRescheduleSMS(0, VFHeader2."Loan No.", 21, Customer."Mobile No.", COMPANYNAME, '', VariationText, StartDate, NewAmount, ABS(PerChange));
        END;
    end;

    [Scope('Internal')]
    procedure PartialPaymentExists(LoanNo: Code[20]; var InstallmentNo: Integer): Boolean
    var
        VehicleFinanceLines: Record "33020063";
    begin
        VehicleFinanceLines.RESET;
        VehicleFinanceLines.SETRANGE("Loan No.", LoanNo);
        VehicleFinanceLines.SETRANGE("Line Cleared", FALSE);
        VehicleFinanceLines.SETFILTER("Principal Paid", '<>%1', 0);
        IF VehicleFinanceLines.FINDFIRST THEN BEGIN
            InstallmentNo := VehicleFinanceLines."Installment No.";
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure AdjustVFPaymentLines(VFHeader: Record "33020062")
    var
        VFPaymentLine: Record "33020072";
        VFLine: Record "33020063";
        AdjPrincipalAmount: Decimal;
        AdjInterestAmount: Decimal;
        AdjType: Option Principal,Interest;
    begin
        AdjPrincipalAmount := 0;
        AdjInterestAmount := 0;

        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", VFHeader."Loan No.");
        VFLine.SETRANGE("Line Cleared", FALSE);
        IF VFLine.ISEMPTY THEN
            EXIT;

        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", VFHeader."Loan No.");
        IF VFLine.FINDSET THEN
            REPEAT
                VFLine.CALCFIELDS("Principal Paid");
                VFLine.CALCFIELDS("Interest Paid");
                IF VFLine."Principal Paid" - VFLine."Calculated Principal" > 0.01 THEN BEGIN
                    AdjPrincipalAmount := VFLine."Principal Paid" - VFLine."Calculated Principal";
                    CreateVFPaymentAdjLine(VFLine."Loan No.", VFLine."Installment No.", AdjPrincipalAmount, AdjType::Principal);
                END;
                IF VFLine."Interest Paid" - VFLine."Calculated Interest" > 0.01 THEN BEGIN
                    AdjInterestAmount := VFLine."Interest Paid" - VFLine."Calculated Interest";
                    CreateVFPaymentAdjLine(VFLine."Loan No.", VFLine."Installment No.", AdjInterestAmount, AdjType::Interest);
                END;
            UNTIL VFLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateVFPaymentAdjLine(LoanNo: Code[20]; InstallmentNo: Integer; AdjustmentAmount: Decimal; AdjType: Option Principal,Interest)
    var
        VFPaymentLine: Record "33020072";
        RefVFPaymentLine: Record "33020072";
    begin
        RefVFPaymentLine.RESET;
        RefVFPaymentLine.SETRANGE("Loan No.", LoanNo);
        RefVFPaymentLine.SETRANGE("Installment No.", InstallmentNo);
        IF RefVFPaymentLine.FINDLAST THEN BEGIN
            CLEAR(VFPaymentLine);
            VFPaymentLine.INIT;
            VFPaymentLine."Loan No." := LoanNo;
            VFPaymentLine."Installment No." := InstallmentNo;
            VFPaymentLine."Line No." := RefVFPaymentLine."Line No." + 10000;
            VFPaymentLine."Payment Date" := RefVFPaymentLine."Payment Date";
            VFPaymentLine."G/L Posting Date" := RefVFPaymentLine."G/L Posting Date";
            VFPaymentLine."G/L Receipt No." := RefVFPaymentLine."G/L Receipt No.";
            VFPaymentLine."Payment Description" := STRSUBSTNO('System Negative Adjustment on %1', FORMAT(AdjType));
            IF AdjType = AdjType::Principal THEN
                VFPaymentLine."Posting Type" := RefVFPaymentLine."Posting Type"::Principal
            ELSE
                IF AdjType = AdjType::Interest THEN
                    VFPaymentLine."Posting Type" := RefVFPaymentLine."Posting Type"::Interest;

            VFPaymentLine."User ID - Before Posting" := '';
            IF AdjType = AdjType::Interest THEN
                VFPaymentLine."Interest Paid" := -1 * AdjustmentAmount
            ELSE
                IF AdjType = AdjType::Principal THEN
                    VFPaymentLine."Principal Paid" := -1 * AdjustmentAmount;

            VFPaymentLine."Shortcut Dimension 1 Code" := RefVFPaymentLine."Shortcut Dimension 1 Code";
            VFPaymentLine."Shortcut Dimension 2 Code" := RefVFPaymentLine."Shortcut Dimension 2 Code";
            VFPaymentLine.INSERT;
            IF AdjType = AdjType::Principal THEN
                CreateNewVFPaymentLineForPrincipal(LoanNo, VFPaymentLine, AdjustmentAmount)
            ELSE
                IF AdjType = AdjType::Interest THEN
                    CreateNewVFPaymentLineForInterest(LoanNo, VFPaymentLine, AdjustmentAmount);

        END;
    end;

    [Scope('Internal')]
    procedure CreateNewVFPaymentLineForPrincipal(LoanNo: Code[20]; NewVFPaymentLine: Record "33020072"; AdjAmount: Decimal)
    var
        VFHeader: Record "33020062";
        VFPaymentLine: Record "33020072";
        VFLine: Record "33020063";
        RefVFPaymentLine: Record "33020072";
        AmountToApply: Decimal;
    begin
        VFHeader.GET(LoanNo);
        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", LoanNo);
        IF VFLine.FINDSET THEN
            REPEAT
                AmountToApply := 0;
                VFLine.CALCFIELDS("Principal Paid");
                IF VFLine."Calculated Principal" - VFLine."Principal Paid" > 0.01 THEN BEGIN
                    CLEAR(RefVFPaymentLine);
                    RefVFPaymentLine.RESET;
                    RefVFPaymentLine.SETRANGE("Loan No.", LoanNo);
                    RefVFPaymentLine.SETRANGE("Installment No.", VFLine."Installment No.");
                    IF RefVFPaymentLine.FINDLAST THEN;

                    IF (VFLine."Calculated Principal" - VFLine."Principal Paid") >= AdjAmount THEN
                        AmountToApply := AdjAmount
                    ELSE
                        AmountToApply := VFLine."Calculated Principal" - VFLine."Principal Paid";

                    CLEAR(VFPaymentLine);
                    VFPaymentLine.INIT;
                    VFPaymentLine."Loan No." := LoanNo;
                    VFPaymentLine."Installment No." := VFLine."Installment No.";
                    VFPaymentLine."Line No." := RefVFPaymentLine."Line No." + 10000;
                    VFPaymentLine."Payment Date" := NewVFPaymentLine."Payment Date";
                    VFPaymentLine."G/L Posting Date" := NewVFPaymentLine."G/L Posting Date";
                    VFPaymentLine."G/L Receipt No." := NewVFPaymentLine."G/L Receipt No.";
                    VFPaymentLine."Payment Description" := STRSUBSTNO('System Positive Adjustment on %1', FORMAT(VFPaymentLine."Posting Type"::Principal));
                    VFPaymentLine."Posting Type" := VFPaymentLine."Posting Type"::Principal;
                    VFPaymentLine."User ID - Before Posting" := NewVFPaymentLine."User ID - Before Posting";
                    VFPaymentLine."Principal Paid" := AmountToApply;
                    VFPaymentLine."Shortcut Dimension 1 Code" := VFHeader."Shortcut Dimension 1 Code";
                    VFPaymentLine."Shortcut Dimension 2 Code" := VFHeader."Shortcut Dimension 2 Code";
                    VFPaymentLine.INSERT;

                    AdjAmount := AdjAmount - AmountToApply;
                    IF AdjAmount < 0.01 THEN
                        EXIT;

                END;
            UNTIL VFLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateNewVFPaymentLineForInterest(LoanNo: Code[20]; NewVFPaymentLine: Record "33020072"; AdjAmount: Decimal)
    var
        VFHeader: Record "33020062";
        VFPaymentLine: Record "33020072";
        VFLine: Record "33020063";
        RefVFPaymentLine: Record "33020072";
        AmountToApply: Decimal;
    begin
        VFHeader.GET(LoanNo);
        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", LoanNo);
        IF VFLine.FINDSET THEN
            REPEAT
                AmountToApply := 0;
                VFLine.CALCFIELDS("Interest Paid");
                IF VFLine."Calculated Interest" - VFLine."Interest Paid" > 0.01 THEN BEGIN
                    CLEAR(RefVFPaymentLine);
                    RefVFPaymentLine.RESET;
                    RefVFPaymentLine.SETRANGE("Loan No.", LoanNo);
                    RefVFPaymentLine.SETRANGE("Installment No.", VFLine."Installment No.");
                    IF RefVFPaymentLine.FINDLAST THEN;

                    IF (VFLine."Calculated Interest" - VFLine."Interest Paid") >= AdjAmount THEN
                        AmountToApply := AdjAmount
                    ELSE
                        AmountToApply := VFLine."Calculated Interest" - VFLine."Interest Paid";

                    CLEAR(VFPaymentLine);
                    VFPaymentLine.INIT;
                    VFPaymentLine."Loan No." := LoanNo;
                    VFPaymentLine."Installment No." := VFLine."Installment No.";
                    VFPaymentLine."Line No." := RefVFPaymentLine."Line No." + 10000;
                    VFPaymentLine."Payment Date" := NewVFPaymentLine."Payment Date";
                    VFPaymentLine."G/L Posting Date" := NewVFPaymentLine."G/L Posting Date";
                    VFPaymentLine."G/L Receipt No." := NewVFPaymentLine."G/L Receipt No.";
                    VFPaymentLine."Payment Description" := STRSUBSTNO('System Positive Adjustment on %1', FORMAT(VFPaymentLine."Posting Type"::Interest));
                    VFPaymentLine."Posting Type" := VFPaymentLine."Posting Type"::Interest;
                    VFPaymentLine."User ID - Before Posting" := NewVFPaymentLine."User ID - Before Posting";
                    VFPaymentLine."Interest Paid" := AmountToApply;

                    VFPaymentLine."Shortcut Dimension 1 Code" := VFHeader."Shortcut Dimension 1 Code";
                    VFPaymentLine."Shortcut Dimension 2 Code" := VFHeader."Shortcut Dimension 2 Code";
                    VFPaymentLine.INSERT;

                    AdjAmount := AdjAmount - AmountToApply;
                    IF AdjAmount < 0.01 THEN
                        EXIT;

                END;
            UNTIL VFLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetInterestOnInsuranceDue2(LoanNo: Code[20]; InsuranceDue: Decimal; CalculationDate: Date; InterestRatePercent: Decimal; InterestPaidOnInsurance: Decimal) InsuranceInterest: Decimal
    var
        VehicleFinancePaymentLines: Record "33020072";
        DueDays: Integer;
        InterestRate: Decimal;
        CalcInterest: Boolean;
        InterestStartDate: Date;
        InterestCalcTillDate: Date;
        VFSetup2: Record "33020064";
        NewInterestCalDate: Date;
        InterestPaidOnInsurance2: Decimal;
    begin
        IF InsuranceDue > 0 THEN BEGIN
            VehicleFinancePaymentLines.RESET;
            IF ChangeCompanyRec THEN
                VehicleFinancePaymentLines.CHANGECOMPANY(NewCompanyName);

            VehicleFinancePaymentLines.SETRANGE("Loan No.", LoanNo);
            VehicleFinancePaymentLines.SETRANGE("Installment No.", 0);
            VehicleFinancePaymentLines.SETFILTER("Insurance Paid", '<>%1', 0);

            IF ChangeCompanyRec THEN
                VFSetup2.CHANGECOMPANY(NewCompanyName);

            VFSetup2.GET;
            //IF VFSetup2."Ins. Interest Cal. Cutoff Date" <> 0D THEN
            NewInterestCalDate := GetNewInterestCalulationStartDate(LoanNo, VFSetup2."Ins. Interest Cal. Cutoff Date");

            IF NewInterestCalDate <> 0D THEN BEGIN
                VehicleFinancePaymentLines.SETFILTER("G/L Posting Date", '>=%1', NewInterestCalDate);
                IF VehicleFinancePaymentLines.FINDFIRST THEN;
            END ELSE BEGIN
                IF VehicleFinancePaymentLines.FINDLAST THEN
                    NewInterestCalDate := VehicleFinancePaymentLines."G/L Posting Date";
            END;

            InterestCalcTillDate := CalculationDate;
            REPEAT
                InterestStartDate := VehicleFinancePaymentLines."G/L Posting Date";
                IF InterestStartDate <> 0D THEN
                    IF InterestCalcTillDate - InterestStartDate > 0 THEN BEGIN
                        InsuranceInterest := InsuranceInterest + VehicleFinancePaymentLines."Insurance Paid" * (InterestCalcTillDate - InterestStartDate);
                        CalcInterest := TRUE
                    END;

            UNTIL VehicleFinancePaymentLines.NEXT = 0;

            IF CalcInterest THEN BEGIN

                VehicleFinancePaymentLines.RESET;
                IF ChangeCompanyRec THEN
                    VehicleFinancePaymentLines.CHANGECOMPANY(NewCompanyName);
                VehicleFinancePaymentLines.SETRANGE("Loan No.", LoanNo);
                VehicleFinancePaymentLines.SETRANGE("Installment No.", 0);
                VehicleFinancePaymentLines.SETFILTER("Insurance Interest Paid", '<>%1', 0);
                IF NewInterestCalDate <> 0D THEN
                    VehicleFinancePaymentLines.SETFILTER("G/L Posting Date", '>=%1', NewInterestCalDate);
                IF VehicleFinancePaymentLines.FINDFIRST THEN
                    REPEAT
                        InterestPaidOnInsurance2 += InterestPaidOnInsurance2 + VehicleFinancePaymentLines."Insurance Interest Paid";
                    UNTIL VehicleFinancePaymentLines.NEXT = 0;


                InsuranceInterest := InsuranceInterest / 365 * InterestRatePercent / 100 - InterestPaidOnInsurance2;
                IF InsuranceInterest < 0 THEN
                    InsuranceInterest := 0;
            END;

            /*
               DueDays := CalculationDate - VehicleFinancePaymentLines."G/L Posting Date";
               InterestRate := InterestRatePercent / 100;
               IF DueDays > 0 THEN BEGIN
                 InsuranceInterest := (InterestRate * DueDays * InsuranceDue) / 365 - InterestPaidOnInsurance;
               END;
            */
            //  END;
        END;
        EXIT(InsuranceInterest);

    end;

    [Scope('Internal')]
    procedure GetNewInterestCalulationStartDate(LoanNo: Code[20]; CutoffDate: Date): Date
    var
        VFPaymentLine: Record "33020072";
    begin
        VFPaymentLine.RESET;
        IF ChangeCompanyRec THEN
            VFPaymentLine.CHANGECOMPANY(NewCompanyName);
        IF CutoffDate <> 0D THEN BEGIN
            VFPaymentLine.SETRANGE

            ("Loan No.", LoanNo);
            VFPaymentLine.SETRANGE("Installment No.", 0);
            VFPaymentLine.SETFILTER("Insurance Paid", '>%1', 0);
            VFPaymentLine.SETFILTER("G/L Posting Date"
            , '>=%1', CutoffDate);
            IF VFPaymentLine.FINDFIRST THEN
                EXIT(VFPaymentLine."G/L Posting Date")
            ELSE BEGIN
                VFPaymentLine.SETRANGE("G/L Posting Date");
                IF VFPaymentLine.FINDLAST THEN BEGIN
                    EXIT(VFPaymentLine."G/L Posting Date");
                END
            END;
        END ELSE BEGIN
            VFPaymentLine.SETRANGE("Loan No.", LoanNo);
            VFPaymentLine.SETRANGE("Installment No.", 0);
            VFPaymentLine.SETFILTER("Insurance Paid", '>%1', 0);
            VFPaymentLine.SETFILTER("G/L Posting Date", '>=%1', CutoffDate);
            IF VFPaymentLine.FINDLAST THEN
                EXIT(VFPaymentLine."G/L Posting Date");
        END;
    end;

    [Scope('Internal')]
    procedure DifferPrincipal(LoanNo: Code[20]; FromInstNo: Integer; ToInstNo: Integer) IsDiferred: Boolean
    var
        EMIAmount: Decimal;
        DeferredPrincipalAmount: Decimal;
        InstNo: Integer;
        PrincipalBalance: Decimal;
        CalculatedInterest: Decimal;
        CalculatedPrincipal: Decimal;
        NextDate: Date;
        LineNo: Integer;
        RemainingPrincipal: Decimal;
    begin
        VFHeader.RESET;
        VFHeader.SETRANGE("Loan No.", LoanNo);
        VFHeader.FINDFIRST;
        VFLine.RESET;
        PrincipalBalance := 0;
        RemainingPrincipal := 0;
        //update calculated princial, balance and flag deffered principal lines
        FOR i := FromInstNo TO ToInstNo DO BEGIN
            VFLine.SETRANGE("Loan No.", LoanNo);
            VFLine.SETRANGE("Installment No.", i);
            IF VFLine.FINDFIRST THEN BEGIN
                VFLine.CALCFIELDS("Principal Paid");
                IF (VFLine."Line Cleared" = TRUE) OR (VFLine."Principal Paid" <> 0) THEN
                    ERROR('Deferral of principal is not allowed when the line is cleard or there is a partial payment on Principal Amount');
                VFLine."Defer Principal" := TRUE;
                VFLine."Deferred Principal" := VFLine."Calculated Principal";
                IF i = FromInstNo THEN
                    PrincipalBalance := VFLine."Calculated Principal" + VFLine.Balance;
                VFLine.Balance := PrincipalBalance;
                VFLine."Calculated Principal" := 0;
                VFLine."Calculated Interest" := (PrincipalBalance * VFHeader."Interest Rate" / 100) / 12;
                RemainingPrincipal := VFLine."Remaining Principal Amount";
                VFLine.MODIFY;
            END;
        END;

        //update subsequent lines and append new installments
        InstNo := ToInstNo + 1;
        REPEAT
            VFLine.RESET;
            VFLine.SETRANGE("Loan No.", LoanNo);
            VFLine.SETRANGE("Installment No.", InstNo);
            IF VFLine.FINDFIRST THEN BEGIN
                EMIAmount := VFLine."EMI Amount";
                CalculatedInterest := (PrincipalBalance * VFHeader."Interest Rate" / 100) / 12;
                CalculatedPrincipal := EMIAmount - CalculatedInterest;
                PrincipalBalance -= CalculatedPrincipal;
                VFLine."Calculated Interest" := CalculatedInterest;
                VFLine."Calculated Principal" := CalculatedPrincipal;
                VFLine.Balance := PrincipalBalance;
                VFLine.MODIFY;
                InstNo += 1;
                NextDate := VFLine."EMI Mature Date";
                LineNo := VFLine."Line No." + 10000;
            END ELSE BEGIN
                VFLine.RESET;
                VFLine.INIT;
                VFLine."Loan No." := LoanNo;
                VFLine."Line No." := LineNo;
                VFLine."Installment No." := InstNo;
                NextDate := CALCDATE('<+1M>', NextDate);
                VFLine."EMI Mature Date" := NextDate;
                CalculatedInterest := (PrincipalBalance * VFHeader."Interest Rate" / 100) / 12;
                VFLine."Calculated Interest" := CalculatedInterest;
                CalculatedPrincipal := EMIAmount - CalculatedInterest;
                PrincipalBalance -= CalculatedPrincipal;
                VFLine."Remaining Principal Amount" := RemainingPrincipal;
                IF PrincipalBalance < CalculatedPrincipal THEN BEGIN
                    VFLine."Calculated Principal" := PrincipalBalance + EMIAmount - CalculatedInterest;
                    VFLine.Balance := 0;
                    VFLine."EMI Amount" := VFLine."Calculated Principal" + CalculatedInterest;
                END ELSE BEGIN
                    VFLine."Calculated Principal" := CalculatedPrincipal;
                    VFLine.Balance := PrincipalBalance;
                    VFLine."EMI Amount" := EMIAmount;
                END;

                VFLine.INSERT;
                InstNo += 1;
                LineNo += 10000;
            END;
        UNTIL PrincipalBalance <= CalculatedPrincipal;

        VFHeader.RESET;
        VFHeader.SETRANGE("Loan No.", LoanNo);
        IF VFHeader.FINDFIRST THEN BEGIN
            VFLine.SETRANGE("Loan No.", LoanNo);
            VFLine.FINDSET;
            VFHeader."Tenure in Months" := VFLine.COUNT;
            VFHeader.MODIFY;
        END;

        EXIT(IsDiferred);
    end;
}

