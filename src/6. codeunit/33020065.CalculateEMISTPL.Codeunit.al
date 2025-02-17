codeunit 33020065 "Calculate EMI - STPL"
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
        CreateVFJournal: Codeunit "33020066";
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        VFSetup: Record "33020064";
        VFPostingType: Option " ",Principal,Interest,Penalty,"Service Charge","Other Charge";
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
        NonClearedEMImaturityDate: Date;
        CalculatedDelayDays: Integer;
        CurrentEMI: Decimal;

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
    procedure RescheduleEMI(LoanNo: Code[20]; InstNo: Integer; NewInterestRate: Decimal; NewPrincipal: Decimal; NewTenure: Integer; NewEffectiveDate: Date; ReasonText: Text[100]) IsRescheduled: Boolean
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
    begin
        LastLineNo := 0;
        PreviousMonthBalance := 0;

        //get last installment balance
        VFLinesRS.RESET;
        VFLinesRS.SETRANGE("Loan No.", LoanNo);
        VFLinesRS.SETRANGE("Installment No.", InstNo - 1);
        IF VFLinesRS.FINDLAST THEN BEGIN
            LastLineNo := VFLinesRS."Line No.";
            PreviousMonthBalance := VFLinesRS.Balance;
            LastInstallmentDate := VFLinesRS."EMI Mature Date";
            IF VFLinesRS."Line Cleared" = FALSE THEN
                ERROR('Cannot reschedule loan since the installment no. %1 is not cleared.', InstNo - 1);
        END ELSE
            ERROR('No lines found for rescheduling.');

        VFLinesRS.RESET;
        VFLinesRS.SETRANGE("Loan No.", LoanNo);
        VFLinesRS.SETRANGE("Installment No.", InstNo);
        IF VFLinesRS.FINDFIRST THEN BEGIN
            IF VFLinesRS."Line Cleared" THEN
                ERROR('Cannot reschedule loan since the installment no. %1 is already cleared.', InstNo);
        END;

        PrincipalToAdd := 0;
        VFLinesRS.RESET;
        VFLinesRS.SETRANGE("Loan No.", LoanNo);
        VFLinesRS.SETRANGE("Line Cleared", FALSE);
        IF VFLinesRS.FINDFIRST THEN BEGIN
            VFLinesRS.CALCFIELDS("Principal Paid");
            PrincipalToAdd := VFLinesRS."Principal Paid";
        END;

        Rate := ROUND(NewInterestRate / 12 / 100, 0.000001, '=');
        NewTenure := (NewTenure - (InstNo - 1));

        EMI := (NewPrincipal + PrincipalToAdd) * Rate * POWER(1 + Rate, NewTenure) / (POWER(1 + Rate, NewTenure) - 1);
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
                        PrincipalPaidTotal += VFLine."Principal Paid";
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
            RescheduleLog.INIT;
            RescheduleLog.Date := TODAY;
            RescheduleLog."Effective Date" := NewEffectiveDate;
            RescheduleLog."Reason for Rescheduling" := ReasonText;
            RescheduleLog."Vehicle Finance No." := LoanNo;
            RescheduleLog."Installment No." := InstNo;
            OldPrincipal := VFHeaderRS."Loan Amount";
            RescheduleLog."Old Principal" := OldPrincipal;
            RescheduleLog."Old Interest Rate" := VFHeaderRS."Interest Rate";
            RescheduleLog."Old Tenure" := VFHeaderRS."Tenure in Months";
            RescheduleLog."Remaining Principal" := VFHeaderRS."Loan Amount" - VFHeaderRS."Total Principal Paid";
            RescheduleLog."New Principal" := NewPrincipal;
            RescheduleLog."Total New Principal" := VFHeaderRS."Total Principal Paid" + NewPrincipal;
            RescheduleLog."New Interest Rate" := NewInterestRate;
            RescheduleLog."New Tenure" := (NewTenure + (InstNo - 1));
            RescheduleLog."Change in Principal" := RescheduleLog."Total New Principal" - OldPrincipal;
            RescheduleLog."User ID" := USERID;
            RescheduleLog."Reason for Rescheduling" := '';
            RescheduleLog.INSERT;
            IsRescheduled := TRUE;
            //update Vehicle Finance Header
            VFHeaderRS."Loan Amount" := VFHeaderRS."Total Principal Paid" + NewPrincipal;
            VFHeaderRS."Interest Rate" := NewInterestRate;
            VFHeaderRS."Tenure in Months" := (NewTenure + (InstNo - 1));
            VFHeaderRS.MODIFY;

            //create journal entry to adjust changes in principal while rescheduling

            COMMIT;
            IF (VFHeaderRS."Loan Amount" - OldPrincipal) <> 0 THEN BEGIN
                IF VFHeaderRS.Closed THEN
                    ERROR(Text0001, LoanNo);

                VFSetup.GET;
                VFSetup.TESTFIELD("VB Journal Batch Name");
                VFSetup.TESTFIELD("Loan Control Account");
                UserSetup.GET(USERID);
                BatchName := VFSetup."VB Journal Batch Name";

                CreateVFJournal.LoanApproval(TODAY, AccountType::Customer, VFHeaderRS."Customer No.", 'Loan reschedlued for File No.' + LoanNo,
                  VFHeaderRS."Loan Amount" - OldPrincipal, LoanNo, '', BatchName, VFHeaderRS."Shortcut Dimension 1 Code",
                  VFHeaderRS."Shortcut Dimension 2 Code", 0, VFPostingType::Principal, TRUE, FALSE, TODAY, TRUE, '', '',
                  VFHeaderRS."Shortcut Dimension 3 Code");

                CreateVFJournal.LoanApproval(TODAY, AccountType::"Bank Account", VFSetup."Loan Control Account"
                  , 'Loan reschedlued for File No. ' + LoanNo,
                  -(VFHeaderRS."Loan Amount" - OldPrincipal), LoanNo, '', BatchName, VFHeaderRS."Shortcut Dimension 1 Code",
                  VFHeaderRS."Shortcut Dimension 2 Code", 0, VFPostingType::Principal, TRUE, FALSE, TODAY, TRUE, '', '',
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
        CLEAR(VFRec."Principal Due");
        CLEAR(VFRec."Interest Due");
        CLEAR(VFRec."Penalty Due");
        CLEAR(CurrentEMI);
        //CLEAR(VFLines);

        //Calculate Dues as of Today
        IF ChangeCompanyRec THEN
            VFSetup.CHANGECOMPANY(NewCompanyName);
        VFSetup.GET;
        "Calculation Date" := CalculationDate;

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
            NonClearedEMImaturityDate := VFLines."EMI Mature Date";
            VFLine2.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine2.SETFILTER("Last Payment Date", '<>%1', 0D);
            VFLine2.SETFILTER("Principal Paid", '<>%1', 0);
            IF VFLine2.FIND('+') THEN
                LastPaymentDate := VFLine2."Last Payment Date"
            ELSE
                LastPaymentDate := CALCDATE('-1M', VFLines."EMI Mature Date");

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
                VFLine2.CALCFIELDS("Principal Paid");
                CLEAR(CurrentDueInstallment);
                CLEAR(CurrentDuePrincipal);
                REPEAT
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
            //MESSAGE('%1',VFRec."Date Last Line Cleared");
            IF VFRec."Date Last Line Cleared" <> 0D THEN BEGIN
                //message('%1',VFRec."Date Last Line Cleared");
                //VFRec."No of Due Days" := CalculationDate - CALCDATE('<+1M>',VFRec."Date Last Line Cleared");
                VFRec."No of Due Days" := CalculationDate - VFRec."Date Last Line Cleared";
                IF VFRec."No of Due Days" < 0 THEN
                    VFRec."No of Due Days" := 0;
            END ELSE
                VFRec."No of Due Days" := CalculationDate - VFRec."First Installment Date";
            //penalty days (last payment date or EMI matured date - whichever is later
            IF (CalculationDate - VFLines."EMI Mature Date") > (CalculationDate - LastPaymentDate) THEN
                PenaltyDays := (CalculationDate - LastPaymentDate)
            ELSE
                PenaltyDays := (CalculationDate - VFLines."EMI Mature Date");
            IF PenaltyDays < 0 THEN
                PenaltyDays := 0;

            PenaltyAsOfNow := VFLines."EMI Amount" * (VFRec."Penalty %" / 100) * (PenaltyDays / 365);
            VFLines."Temp Calculated Penalty" := PenaltyAsOfNow;

            VFLines."Temp Penalty Delay Days" := PenaltyDays;

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
                            IF NOT VFLine."Wave Penalty" THEN
                                // VFLine."Calculated Penalty" := (VFLine."Calculated Principal" + VFLine."Calculated Interest" -
                                //   VFLine."Principal Paid" - VFLine."Interest Paid") * (VFRec."Penalty %" /100) * (VFLine."Delay by No. of Days"/365);
                                VFLine."Calculated Penalty" := (VFLine."Calculated Principal" - VFLine."Principal Paid") *     //prabesh 12-6-23
                                                (VFRec."Penalty %" / 100) * (VFLine."Delay by No. of Days" / 365);
                        END;
                    END;
                    VFLine.MODIFY;
                UNTIL VFLine.NEXT = 0;
            END;

            REPEAT
                DueInstallment += 1;
            UNTIL VFLines.NEXT = 0;

            VFRec."Due Installments" := DueInstallment;

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
                VFRec."Penalty Due" := SumCalPenalty - SumPaidPenalty;
                VFRec.MODIFY;

            END;
            /*
            IF (PenaltyAsOfNow + SumCalPenalty - SumPaidPenalty) >0 THEN
              VFRec."Penalty Due" := PenaltyAsOfNow + SumCalPenalty - SumPaidPenalty
            ELSE
              VFRec."Penalty Due" := 0;
            */
            IF PenaltyDays > 0 THEN
                VFRec."Temp Delay Days" := PenaltyDays
            ELSE
                VFRec."Temp Delay Days" := 0;
            IF PenaltyAsOfNow > 0 THEN
                VFRec."Temp Penalty" := PenaltyAsOfNow
            ELSE
                VFRec."Temp Penalty" := 0;
            VFRec.MODIFY;
        END;

        VFLines.RESET;
        IF ChangeCompanyRec THEN
            VFLines.CHANGECOMPANY(NewCompanyName);
        VFLines.SETRANGE("Loan No.", VFRec."Loan No.");
        VFLines.SETRANGE("Line Cleared", FALSE);
        IF VFLines.FINDFIRST THEN BEGIN
            VFRec."Principal Due" := VFLines."Remaining Principal Amount";
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
            //IF "Calculation Date" >= NonClearedEMImaturityDate THEN
            VFRec."Interest Due" := (VFLines."Remaining Principal Amount" * (EMIDelayDays / 365) * (VFRec."Interest Rate" / 100))
                                  - InterestSettled
            //ELSE
            //VFRec."Interest Due" := 0;
        END ELSE
            VFRec."Principal Due" := VFRec."Loan Amount";

        VFRec."Total Int. Due to clear Loan" := VFRec."Interest Due Defered" + VFRec."Interest Due";
        TotalDue := VFRec."Principal Due" + VFRec."Interest Due" + VFRec."Penalty Due";
        VFRec."Total Due" := TotalDue;

        VFRec.CALCFIELDS("Insurance Due", "Other Amount Due");
        VFRec."Total Due as of Today" := VFRec."Interest Due" + VFRec."Penalty Due" + VFRec."Insurance Due"
                                           + VFRec."Other Amount Due" + VFRec."Due Principal";
        VFRec."Due Days Crossed Maturity" := CalculatedDelayDays; //SM 09.01.2015
        VFRec."EMI Amount" := CurrentEMI;
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
            IF VFLines.FINDFIRST THEN BEGIN
                REPEAT
                    VFLine.CALCFIELDS("Penalty Paid");
                    SumCalPenalty += VFLine."Calculated Penalty";
                    SumPaidPenalty += VFLine."Penalty Paid";
                UNTIL VFLine.NEXT = 0;
            END;
            VFRec."Penalty Due" := SumCalPenalty - SumPaidPenalty;
            VFRec.CALCFIELDS("Insurance Due", "Other Amount Due");
            VFRec."Due Installment as of Today" := 0;
            VFRec."Due Principal" := 0;
            VFRec."Principal Due" := 0;
            VFRec."Interest Due" := 0;
            VFRec."Due Installments" := 0;
            VFRec."No of Due Days" := 0;
            VFRec."Total Due" := VFRec."Insurance Due" + VFRec."Other Amount Due" + VFRec."Penalty Due";
            VFRec."Due Days Crossed Maturity" := CalculatedDelayDays; //SM 09.01.2015
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
                IF VFRec."Sales Invoice Date" <> 0D THEN BEGIN
                    DepreciationDays := "Calculation Date" - VFRec."Sales Invoice Date";

                    IF VFRec."Market Price" = 0 THEN
                        VFRec."Market Price" := NRVSetup."Market Price";
                    IF VFRec."Depreciation Rate" = 0 THEN
                        VFRec."Depreciation Rate" := NRVSetup."Depreciation Rate";

                    VFRec.MODIFY;
                    VFRec.TESTFIELD("Market Price");
                    VFRec.TESTFIELD("Depreciation Rate");

                    NRVValue := VFRec."Market Price";
                    DepreciationRate := VFRec."Depreciation Rate";

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Daily THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays, 1, '=');
                        DepreciationRatePerMonth := (DepreciationRate / 100) / 365;
                    END;

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Monthly THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays / 30, 1, '=');
                        DepreciationRatePerMonth := (DepreciationRate / 100) / 12;
                    END;

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Yearly THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays / 356, 1, '=');
                        DepreciationRatePerMonth := (DepreciationRate / 100);
                    END;

                    WHILE DepreciationMonth > 0 DO BEGIN
                        DepreciationValue := NRVValue * DepreciationRatePerMonth;
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
        //IF ChangeCompanyRec THEN
        //  LoanStatus.CHANGECOMPANY(NewCompanyName);

        IF LoanStatus.FINDFIRST THEN BEGIN
            REPEAT
                IF (CalculatedDelayDays >= LoanStatus."From Days") AND (CalculatedDelayDays <= LoanStatus."To Days") THEN BEGIN //SM 09 01 2015
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
}

