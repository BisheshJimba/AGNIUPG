codeunit 33020064 "Calculate VF Dues - Back Date"
{
    // 14 October 2012: Surya
    // 
    // 1. Function to calculate back dated dues and penalty for VF reporting


    trigger OnRun()
    begin
    end;

    var
        VFLine: Record "33020063";
        VFPayment: Record "33020072";
        LastPaymentDate: Date;
        LastInstNo: Integer;
        VFSetup: Record "33020064";
        DelayDays: Integer;
        PrincipalDue: Decimal;
        InterestDue: Decimal;
        PenaltyDue: Decimal;
        InterestPaid: Decimal;
        PebaltyPaid: Decimal;
        PenaltyDays: Integer;
        PenaltyAsOfNow: Decimal;
        DueInstallment: Integer;
        SumCalPenalty: Decimal;
        SumPaidPenalty: Decimal;
        PenaltyDays1: Integer;
        PenaltyDays2: Integer;
        PrincipalDueAsOfToday: Decimal;
        DueInstallmentAsOfToday: Integer;
        Vehicle: Record "25006005";
        ModelVersionCode: Code[20];
        NRVSetup: Record "33020066";
        DepreciationDays: Integer;
        NRVValue: Decimal;
        DepreciationMonth: Decimal;
        DepreciationRatePerMonth: Decimal;
        DepreciationValue: Decimal;
        LoanStatus: Record "33020067";

    [Scope('Internal')]
    procedure CalculateBackDatedDues(VFRec: Record "33020062"; CalculationDate: Date)
    var
        PenaltyDays: Integer;
    begin
        PenaltyDays := 0;
        LastInstNo := 0;
        DelayDays := 0;
        PrincipalDue := 0;
        InterestDue := 0;
        PenaltyDue := 0;
        InterestPaid := 0;
        PebaltyPaid := 0;
        PenaltyDays := 0;
        PenaltyAsOfNow := 0;
        DueInstallment := 0;
        SumCalPenalty := 0;
        SumPaidPenalty := 0;
        PenaltyDays1 := 0;
        PenaltyDays2 := 0;
        PrincipalDueAsOfToday := 0;
        DueInstallmentAsOfToday := 0;

        VFSetup.GET;
        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", VFRec."Loan No.");
        VFLine.SETFILTER("Last Payment Date", '<=%1', CalculationDate);
        IF VFLine.FINDLAST THEN BEGIN
            PrincipalDue := VFLine."Remaining Principal Amount";
            VFPayment.RESET;
            VFPayment.SETRANGE("Loan No.", VFRec."Loan No.");
            VFPayment.SETFILTER("Principal Paid", '>%1', 0);
            VFPayment.SETFILTER("Payment Date", '<=%1', CalculationDate);
            IF VFPayment.FINDLAST THEN BEGIN
                LastPaymentDate := VFPayment."Payment Date";
                LastInstNo := VFPayment."Installment No.";
            END ELSE BEGIN
                VFRec."Back Date Calculated" := FALSE;
                VFRec.MODIFY;
                EXIT;
            END;
            DelayDays := CalculationDate - LastPaymentDate;

            InterestDue := PrincipalDue * (VFRec."Interest Rate" / 100) * DelayDays / 365;

            VFPayment.RESET;
            VFPayment.SETRANGE("Loan No.", VFRec."Loan No.");
            VFPayment.SETFILTER("Installment No.", '>%1', LastInstNo);
            VFPayment.SETFILTER("Payment Date", '<=%1', CalculationDate);
            IF VFPayment.FINDFIRST THEN BEGIN
                REPEAT
                    InterestPaid += VFPayment."Interest Paid";
                UNTIL VFPayment.NEXT = 0;
            END;

            InterestDue := InterestDue - InterestPaid;

            //penalty days (last payment date or EMI matured date - whichever is later
            VFLine.RESET;
            VFLine.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine.SETFILTER("Installment No.", '<=%1', LastInstNo);
            IF VFLine.FINDLAST THEN BEGIN
                PenaltyDays1 := CalculationDate - VFLine."EMI Mature Date";
                PenaltyDays2 := CalculationDate - LastPaymentDate;

                IF PenaltyDays1 < PenaltyDays2 THEN
                    PenaltyDays := PenaltyDays2
                ELSE
                    PenaltyDays := PenaltyDays1;

                IF PenaltyDays < 0 THEN
                    PenaltyDays := 0;

                PenaltyAsOfNow := VFLine."EMI Amount" * (VFRec."Penalty %" / 100) * (PenaltyDays / 365);
                VFLine."Temp Calculated Penalty" := PenaltyAsOfNow;
                VFLine."Temp Penalty Delay Days" := PenaltyDays;
                SumCalPenalty := 0;
                SumPaidPenalty := 0;

                VFLine.RESET;
                VFLine.SETRANGE("Loan No.", VFRec."Loan No.");
                IF VFLine.FINDFIRST THEN BEGIN
                    REPEAT
                        VFLine.CALCFIELDS("Penalty Paid");
                        SumCalPenalty += VFLine."Calculated Penalty";
                        SumPaidPenalty += VFLine."Penalty Paid";
                    UNTIL VFLine.NEXT = 0;
                END;
                IF (PenaltyAsOfNow + SumCalPenalty - SumPaidPenalty) > 0 THEN
                    VFRec."Penalty Due" := PenaltyAsOfNow + SumCalPenalty - SumPaidPenalty
                ELSE
                    VFRec."Penalty Due" := 0;
                IF PenaltyDays > 0 THEN
                    VFRec."Temp Delay Days" := PenaltyDays
                ELSE
                    VFRec."Temp Delay Days" := 0;
                IF PenaltyAsOfNow > 0 THEN
                    VFRec."Temp Penalty" := PenaltyAsOfNow
                ELSE
                    VFRec."Temp Penalty" := 0;
            END;

            //due principal as of today
            VFLine.RESET;
            VFLine.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine.SETFILTER("Installment No.", '>=%1', LastInstNo);
            VFLine.SETFILTER("EMI Mature Date", '<=%1', CalculationDate);
            IF VFLine.FINDFIRST THEN BEGIN
                REPEAT
                    VFLine.CALCFIELDS("Principal Paid");
                    IF ROUND(VFLine."Calculated Principal", 1, '>') <> ROUND(VFLine."Principal Paid", 1, '>') THEN
                        PrincipalDueAsOfToday += VFLine."Calculated Principal" - VFLine."Principal Paid"
                    ELSE
                        PrincipalDueAsOfToday += VFLine."Calculated Principal";
                    DueInstallmentAsOfToday += 1;
                UNTIL VFLine.NEXT = 0;
                //IF VFRec."Principal Due" = 0 THEN
                //  PrincipalDueAsOfToday := PrincipalDueAsOfToday - VFRec."EMI Amount";
            END;

            //unpaid installments
            VFLine.RESET;
            VFLine.SETRANGE("Loan No.", VFRec."Loan No.");
            VFLine.SETRANGE("Line Cleared", FALSE);
            IF VFLine.FINDFIRST THEN BEGIN
                DueInstallment := 0;
                REPEAT
                    DueInstallment += 1;
                UNTIL VFLine.NEXT = 0;
            END;

            IF PrincipalDue < 0 THEN
                PrincipalDue := 0;
            IF InterestDue < 0 THEN
                InterestDue := 0;
            IF PenaltyDue < 0 THEN
                PenaltyDue := 0;

            VFRec.CALCFIELDS("Other Amount Due");
            VFRec."No of Due Days" := DelayDays;
            VFRec."Principal Due" := PrincipalDue;
            VFRec."Interest Due" := InterestDue;
            VFRec."Penalty Due" := VFRec."Temp Penalty" + PenaltyAsOfNow;
            VFRec."Total Due" := PrincipalDue + InterestDue + VFRec."Penalty Due" + VFRec."Insurance Due" + VFRec."Other Amount Due";
            IF VFRec."Principal Due" < 1 THEN
                PrincipalDueAsOfToday := 0;

            VFRec."Due Principal" := PrincipalDueAsOfToday;

            VFRec."Due Installment as of Today" := DueInstallmentAsOfToday;
            VFRec."Total Due as of Today" := PrincipalDueAsOfToday + VFRec."Interest Due" + VFRec."Penalty Due";
            //+ VFRec."Insurance Due" + VFRec."Other Amount Due";
            VFRec."Due Installments" := DueInstallment;
            VFRec."Due Calculated as of" := CalculationDate;
            VFRec."Back Date Calculated" := TRUE;
            VFRec.MODIFY;
        END;

        //Net Realization Value & Status
        VFSetup.GET;
        Vehicle.RESET;
        Vehicle.SETRANGE("Serial No.", VFRec."Vehicle No.");
        IF Vehicle.FINDFIRST THEN BEGIN
            ModelVersionCode := Vehicle."Model Version No.";
            NRVSetup.SETRANGE("Model Version", ModelVersionCode);
            IF NRVSetup.FINDFIRST THEN BEGIN
                IF VFRec."Sales Invoice Date" <> 0D THEN BEGIN
                    DepreciationDays := CalculationDate - VFRec."Sales Invoice Date";
                    NRVValue := NRVSetup."Market Price";

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Daily THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays, 1, '=');
                        DepreciationRatePerMonth := (NRVSetup."Depreciation Rate" / 100) / 365;
                    END;

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Monthly THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays / 30, 1, '=');
                        DepreciationRatePerMonth := (NRVSetup."Depreciation Rate" / 100) / 12;
                    END;

                    IF VFSetup."NRV Calculation Method" = VFSetup."NRV Calculation Method"::Yearly THEN BEGIN
                        DepreciationMonth := ROUND(DepreciationDays / 356, 1, '=');
                        DepreciationRatePerMonth := (NRVSetup."Depreciation Rate" / 100);
                    END;

                    WHILE DepreciationMonth > 0 DO BEGIN
                        DepreciationValue := NRVValue * DepreciationRatePerMonth;
                        NRVValue -= DepreciationValue;
                        DepreciationMonth -= 1;
                    END;
                    VFRec."Net Realization Value" := ROUND(NRVValue, 1, '=');
                    IF NRVValue < VFRec."Total Due" THEN
                        VFRec."NRV Status" := VFRec."NRV Status"::Risky
                    ELSE
                        VFRec."NRV Status" := VFRec."NRV Status"::"Risk Free";
                    VFRec."No of Due Days" := DelayDays;
                    VFRec."NRV Calculation Date" := CalculationDate;
                    VFRec.MODIFY;
                END;
            END;
        END;

        //Loan Status
        LoanStatus.RESET;
        IF LoanStatus.FINDFIRST THEN BEGIN
            REPEAT
                IF (DelayDays >= LoanStatus."From Days") AND (DelayDays <= LoanStatus."To Days") THEN BEGIN
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
    end;
}

