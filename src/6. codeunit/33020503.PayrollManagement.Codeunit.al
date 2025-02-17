codeunit 33020503 "Payroll Management"
{
    // ********************** PAYROLL 6.1.0 YURAN@AGILE *************************


    trigger OnRun()
    begin
    end;

    var
        Employee: Record "5200";
        PayrollComponentUsage: Record "33020504";
        PayrollComponent: Record "33020503";
        SalaryLine: Record "33020511";
        VFUsage: Record "33020517";
        Components: array[20, 2] of Code[20];
        FieldID: Integer;
        CompID: Integer;
        CalculatedAmount: Decimal;
        TotalPay: Decimal;
        TotalDeduction: Decimal;
        TotalEmpContribution: Decimal;
        SalaryHeader: Record "33020510";
        PRSetup: Record "33020507";
        TaxSetupHeader: Record "33020505";
        TaxSetupLine: Record "33020506";
        PayMonth: Integer;
        RemainingAmount: Decimal;
        Text000: Label 'Attendance has not been processed for employee %1.';
        TotalMonthforTax: Integer;
        TotalPaidDays: Decimal;
        TotalAbsentDays: Decimal;
        TotalWorkingDays: Decimal;
        Text001: Label 'Employee %1 has been %2. Salary cannot be processed further.';
        Totaldayswork: Integer;
        LeaveDeductedAmount: Decimal;
        TotalLeaveDeduction: Decimal;
        Text002: Label 'There must be leave deduction component assigned to the Employee %1.';
        RemainingMonth: Integer;
        TotalTaxPaid: Decimal;
        TotalTaxCredit: Decimal;
        Text003: Label 'Salary for Employee %1 has already been processed for the date (%2 - %3).';
        Text004: Label 'Employee %1 has no Paid Days for the date (%2 - %3).';
        CummulativeContribution: Decimal;
        InvestmentOnRetirement: Decimal;
        Operators: array[4, 4] of Code[10];
        OPMaster: Code[20];
        ExNo: Integer;
        OsNo: Integer;
        NsNo: Integer;
        EscapeComponentValidation: Boolean;
        Text007: Label 'Employee %1 has invalid Column Name in Component %2.';
        TaxLedgerEntry: Record "33020521";
        Taxledgerentry1: Record "33020521";
        RemainingAmtTaxLedger: Decimal;
        Employee1: Record "5200";
        CheckAmt: Decimal;
        EmpRecForTaxLedg: Record "5200";
        TaxSetupLine1: Record "33020506";
        TaxRate: Decimal;
        TaxSetupLineSplit: Record "33020506";
        FirstSlabAmt: Decimal;
        FirstSlabTax: Decimal;
        TaxSetupDiff: Decimal;
        AdjTaxDiff: Decimal;
        PostedTaxAdj: Record "33020513";
        DelTaxLed: Record "33020521";
        TaxEntryNo: Integer;
        TaxLedDeleted: Record "33020521";
        DelAllTax: Record "33020521";
        TaxSetupIrregular: Record "33020506";
        EmpIrregularTax: Record "5200";
        TaxDifferenceIrregular: Decimal;
        RemainAmtIrregular: Decimal;
        LastMnthSalaryLedg: Record "33020520";
        FYMonth: Integer;
        FYYear: Integer;
        SalMonth: Integer;
        Salyear: Integer;
        ModifyTaxLedgEntry: Record "33020521";
        AnnualSST: Decimal;
        Employee2: Record "5200";
        taxsetupline2: Record "33020506";
        CheckAmt1: Decimal;
        AdjTaxDiff1: Decimal;
        taxrate1: Decimal;
        taxsetupheader2: Record "33020505";
        TaxHdr1: Record "33020505";
        taxsetupheader3: Record "33020505";
        ReggularSalaryLine: Record "33020511";
        IrregularSalaryLine: Record "33020511";
        FirstSlabEndValue: Decimal;
        TaxPaidMonths: Integer;
        HealthInsurance: Decimal;
        HealthInsuranceExact: Decimal;
        BuidlingInsurance: Decimal;
        BuildingInsuranceExact: Decimal;
        MedicalTax: Decimal;
        MedicalTaxExact: Decimal;

    [Scope('Internal')]
    procedure SetEmployee(var EmployeeRec: Record "5200")
    begin
        //Globally Declaring Employee Record Variable >>>>
        Employee := EmployeeRec;
        IF Employee.Status IN [Employee.Status::"Trf Sister Concern", Employee.Status::Left,
            Employee.Status::Retired, Employee.Status::Terminated] THEN
            ERROR(Text001, Employee."No.", FORMAT(Employee.Status));
        Employee.TESTFIELD(Level);
        Employee.TESTFIELD(Grade);
        Employee.TESTFIELD("Global Dimension 1 Code");
        Employee.TESTFIELD("Global Dimension 2 Code");
        Employee.TESTFIELD("Tax Code");
        Employee.TESTFIELD("Employment Date");
    end;

    [Scope('Internal')]
    procedure InitSalaryLines(var SalaryLineRec: Record "33020511")
    var
        LastLineNo: Integer;
    begin
        //Whenever the Employee Field is validated in "Salary Line" Table, it executes this function >>>

        TotalPay := 0.0;
        TotalDeduction := 0.0;
        TotalEmpContribution := 0.0;
        SalaryLineRec."Basic with Grade" := GetBasicSalary;
        //getleaveEncash
        //GetLeaveEncashAmount(SalaryLineRec,"Basic with Grade");
        SalaryLineRec.VALIDATE("Global Dimension 1 Code", SalaryLineRec.Employee."Global Dimension 1 Code");
        SalaryLineRec.VALIDATE("Global Dimension 2 Code", SalaryLineRec.Employee."Global Dimension 2 Code");
        SalaryLine := SalaryLineRec;
        DelAllTax.RESET;
        DelAllTax.SETRANGE("Employee No.", SalaryLine."Employee No.");
        DelAllTax.SETRANGE("Document No.", SalaryLine."Document No.");
        IF DelAllTax.FINDFIRST THEN BEGIN
            DelAllTax.DELETEALL;
        END;

        GetSalaryHeader();
        IF (DocExists) AND (NOT SalaryHeader."Irregular Process") THEN
            ERROR(Text003, SalaryLineRec.Employee."No.", SalaryHeader."From Date", SalaryHeader."To Date");

        //***SM to check last month posted salary
        PRSetup.GET;
        FYMonth := DATE2DMY(PRSetup."Payroll Fiscal Year End Date", 2);
        FYYear := DATE2DMY(PRSetup."Payroll Fiscal Year End Date", 3);

        LastMnthSalaryLedg.RESET;
        LastMnthSalaryLedg.SETRANGE("Employee Code", SalaryLineRec."Employee No.");
        LastMnthSalaryLedg.SETRANGE(Reversed, FALSE);
        LastMnthSalaryLedg.SETRANGE("Irregular Process", FALSE);
        LastMnthSalaryLedg.SETRANGE("Fiscal Year From", PRSetup."Payroll Fiscal Year Start Date");
        LastMnthSalaryLedg.SETRANGE("Fiscal Year To", PRSetup."Payroll Fiscal Year End Date");
        IF LastMnthSalaryLedg.FINDFIRST THEN BEGIN
            REPEAT
                SalMonth := DATE2DMY(LastMnthSalaryLedg."Salary To", 2);
                Salyear := DATE2DMY(LastMnthSalaryLedg."Salary To", 3);
                IF (FYMonth = SalMonth) AND (FYYear = Salyear) THEN
                    ERROR('The Regular Salary plan for %1 has been already posted for this fiscal year.',
                          FORMAT(PRSetup."Payroll Fiscal Year End Date", 0, '<Month Text> <Year>'));
            UNTIL LastMnthSalaryLedg.NEXT = 0;
        END;
        //***SM to check last month posted salary

        GetPaidAmount;
        SalaryLine."Basic with Grade" := GetBasicSalary;
        IF NOT SalaryHeader."Irregular Process" THEN BEGIN
            LeaveDeductedAmount := ROUND(((SalaryLine."Basic with Grade" / TotalWorkingDays) * TotalAbsentDays), 0.01, '=');  //<jm>
            IF LeaveDeductedAmount > 0 THEN
                SalaryLine."Basic with Grade" -= LeaveDeductedAmount;
            //IF TotalPaidDays > 0 THEN BEGIN
            CalcBenefits();
            CalcDeduction();
            CalcEmployerContribution();
            SalaryLine.VALIDATE("Total Deduction", SalaryLine."Total Deduction");

            //END
            //ELSE
            // ERROR(Text004,Employee."No.",SalaryHeader."From Date",SalaryHeader."To Date");
        END;
        CalcTaxSplit();
        Recaltaxsplitforextacases();
        FirstTaxAccAdjustment();
        SalaryLine."Variable Field 33020507" := SalaryLine."Variable Field 33020508"; //hard coded - for quick fix to copy value of PF
        SalaryLine.Gratuity := SalaryLineRec.Employee."Gratuity %" / 100 * SalaryLine."Basic with Grade";
        SalaryLine."SSF(1.67 %)" := 0.0167 * SalaryLine."Basic with Grade"; // Min 12/18/2019
        SalaryLineRec := SalaryLine;
    end;

    [Scope('Internal')]
    procedure CalcBenefits()
    var
        PayrollPercent: Decimal;
    begin
        // Calculation of Benefits for the employee
        TotalPay := 0;
        PayrollComponentUsage.RESET;
        PayrollComponentUsage.SETRANGE("Employee No.", Employee."No.");
        PayrollComponentUsage.SETRANGE("Payroll Type", PayrollComponentUsage."Payroll Type"::Benefits);
        IF PayrollComponentUsage.FINDSET THEN
            REPEAT
                PayrollComponent.GET(PayrollComponentUsage."Payroll Component Code");
                IF PayrollComponent."Enable % wise calculation" THEN
                    PayrollPercent := Employee."Payroll %" / 100
                ELSE
                    PayrollPercent := 1;
                CalculatedAmount := 0.0;
                IF (IsValidComponent)
                  THEN BEGIN
                    IF PayrollComponentUsage.Formula <> '' THEN
                        CalculatedAmount := ROUND(EvaluateAmount(PayrollComponentUsage.Formula, FALSE), 0.01, '=') * PayrollPercent
                    ELSE
                        CalculatedAmount := PayrollComponentUsage.Amount * PayrollPercent;
                    PayrollComponentUsage.CALCFIELDS("Deduct on Leave");
                    IF PayrollComponentUsage."Deduct on Leave" THEN BEGIN
                        LeaveDeductedAmount := ROUND((CalculatedAmount / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                        IF LeaveDeductedAmount > 0 THEN
                            CalculatedAmount -= LeaveDeductedAmount;
                    END;
                    TotalPay += CalculatedAmount;
                END;
                IF PRSetup."Leave Deduction Component" <> PayrollComponentUsage."Payroll Component Code" THEN
                    EvaluateFields(1, PayrollComponentUsage."Payroll Component Code");

            //MESSAGE(PayrollComponentUsage."Payroll Component Code" + FORMAT(CalculatedAmount));
            UNTIL PayrollComponentUsage.NEXT = 0;
        SalaryLine.VALIDATE("Total Benefit", TotalPay + SalaryLine."Basic with Grade");
    end;

    [Scope('Internal')]
    procedure CalcDeduction()
    var
        PayrollPercent: Decimal;
    begin
        // Calculation of Deduction for the employee
        TotalDeduction := 0;
        PayrollComponentUsage.RESET;
        PayrollComponentUsage.SETRANGE("Employee No.", Employee."No.");
        PayrollComponentUsage.SETRANGE("Payroll Type", PayrollComponentUsage."Payroll Type"::Deduction);
        IF PayrollComponentUsage.FINDSET THEN
            REPEAT
                PayrollComponent.GET(PayrollComponentUsage."Payroll Component Code");
                IF PayrollComponent."Enable % wise calculation" THEN
                    PayrollPercent := Employee."Payroll %" / 100
                ELSE
                    PayrollPercent := 1;
                CalculatedAmount := 0.0;
                IF (IsValidComponent)
                  THEN BEGIN
                    IF PayrollComponentUsage.Formula <> '' THEN BEGIN
                        IF (PayrollComponentUsage."Payroll Subtype" = PayrollComponentUsage."Payroll Subtype"::Retirement) AND
                          (PayrollComponentUsage."Retirement Investment" = FALSE) THEN BEGIN
                            CalculatedAmount := ROUND(EvaluateAmount(PayrollComponentUsage.Formula, TRUE), 0.01, '=');
                            IF (PayrollComponentUsage."Applicable from" > SalaryHeader."From Date") AND
                                (PayrollComponentUsage."Applicable from" <= SalaryHeader."To Date") THEN BEGIN
                                CalculatedAmount := ROUND(EvaluateAmount(PayrollComponentUsage.Formula, FALSE), 0.01, '=') * PayrollPercent;
                                CalculatedAmount := CalculatedAmount - ((PayrollComponentUsage."Applicable from" -
                                                  SalaryHeader."From Date") * CalculatedAmount / TotalWorkingDays);
                            END;
                        END
                        ELSE BEGIN

                            CalculatedAmount := ROUND(EvaluateAmount(PayrollComponentUsage.Formula, FALSE), 0.01, '=') * PayrollPercent;
                            PayrollComponentUsage.CALCFIELDS("Deduct on Leave");
                            IF PayrollComponentUsage."Deduct on Leave" THEN BEGIN
                                IF (NOT PayrollComponentUsage.Fixed) THEN BEGIN
                                    LeaveDeductedAmount := ROUND((CalculatedAmount / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                                    IF LeaveDeductedAmount > 0 THEN
                                        CalculatedAmount -= LeaveDeductedAmount;
                                END;
                            END;
                        END;
                    END
                    ELSE BEGIN
                        CalculatedAmount := PayrollComponentUsage.Amount * PayrollPercent;
                        PayrollComponentUsage.CALCFIELDS("Deduct on Leave");
                        IF PayrollComponentUsage."Deduct on Leave" THEN BEGIN
                            IF (NOT PayrollComponentUsage.Fixed) THEN BEGIN
                                // LeaveDeductedAmount := ROUND((CalculatedAmount/TotalWorkingDays)*TotalAbsentDays,0.01,'=');
                                LeaveDeductedAmount := ROUND((CalculatedAmount / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');  //<jm>
                                IF LeaveDeductedAmount > 0 THEN
                                    CalculatedAmount -= LeaveDeductedAmount;
                            END;
                        END;
                    END;
                    TotalDeduction += CalculatedAmount;
                END;

                IF PRSetup."Leave Deduction Component" <> PayrollComponentUsage."Payroll Component Code" THEN
                    EvaluateFields(1, PayrollComponentUsage."Payroll Component Code");
            //MESSAGE(PayrollComponentUsage."Payroll Component Code" + FORMAT(CalculatedAmount));
            UNTIL PayrollComponentUsage.NEXT = 0;
        SalaryLine.VALIDATE("Total Deduction", TotalDeduction);
    end;

    [Scope('Internal')]
    procedure CalcEmployerContribution()
    begin
        TotalEmpContribution := 0;
        PayrollComponentUsage.RESET;
        PayrollComponentUsage.SETRANGE("Employee No.", Employee."No.");
        PayrollComponentUsage.SETRANGE("Payroll Type", PayrollComponentUsage."Payroll Type"::"Employer Contribution");
        IF PayrollComponentUsage.FINDSET THEN
            REPEAT
                CalculatedAmount := 0.0;
                IF (IsValidComponent)
                  THEN BEGIN
                    IF PayrollComponentUsage.Formula <> '' THEN
                        CalculatedAmount := ROUND(EvaluateAmount(PayrollComponentUsage.Formula, FALSE), 0.01, '=')
                    ELSE
                        CalculatedAmount := PayrollComponentUsage.Amount;
                    PayrollComponentUsage.CALCFIELDS("Deduct on Leave");
                    IF PayrollComponentUsage."Deduct on Leave" THEN BEGIN
                        // LeaveDeductedAmount := ROUND((CalculatedAmount/TotalWorkingDays)*TotalAbsentDays,0.01,'=');
                        LeaveDeductedAmount := ROUND((CalculatedAmount / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                        IF LeaveDeductedAmount > 0 THEN
                            CalculatedAmount -= LeaveDeductedAmount;
                    END;
                    TotalEmpContribution += CalculatedAmount;
                END;
                IF PRSetup."Leave Deduction Component" <> PayrollComponentUsage."Payroll Component Code" THEN
                    EvaluateFields(1, PayrollComponentUsage."Payroll Component Code");
            UNTIL PayrollComponentUsage.NEXT = 0;
        SalaryLine.VALIDATE("Total Employer Contribution", TotalEmpContribution);
    end;

    [Scope('Internal')]
    procedure UpdateSalaryLine(var SalaryLineRec: Record "33020511"; FieldID: Integer; xRecValue: Decimal; RecValue: Decimal)
    var
        Text000: Label 'You cannot modify %1 on Salary Plan.';
        Text001: Label 'Payroll Component %1 is currently Inactive for all Employees.';
        Text002: Label 'Payroll Component %1 is not valid for Employee %2.';
        Text003: Label 'Payroll Component %1 is not within the valid Period for Employee %2';
    begin
        IF (RecValue <> xRecValue) THEN BEGIN
            VFUsage.RESET;
            VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
            VFUsage.SETRANGE("Field No.", FieldID);
            IF VFUsage.FINDFIRST THEN BEGIN
                PayrollComponent.GET(VFUsage."Variable Field Code");
                IF PayrollComponent.Status = PayrollComponent.Status::Inactive THEN
                    ERROR(Text001, PayrollComponent.Code);
                IF NOT PayrollComponent."Plan Flexible" THEN
                    ERROR(Text000, PayrollComponent.Code);
                SalaryLine := SalaryLineRec; // added on 4.1.2013
                GetSalaryHeader;
                PayrollComponentUsage.RESET;
                PayrollComponentUsage.SETRANGE("Employee No.", SalaryLineRec."Employee No.");
                PayrollComponentUsage.SETRANGE("Payroll Component Code", VFUsage."Variable Field Code");
                IF NOT PayrollComponentUsage.FINDFIRST THEN
                    ERROR(Text002, VFUsage."Variable Field Code", SalaryLineRec."Employee No.");
                IF (NOT IsValidComponent) AND (NOT EscapeComponentValidation) THEN
                    ERROR(Text003, PayrollComponentUsage."Payroll Component Code", SalaryLineRec."Employee No.");
                GetSalaryHeader();
                GetPaidAmount;
                PayrollComponentUsage.CALCFIELDS("Deduct on Leave");
                IF PayrollComponent.Type = PayrollComponent.Type::Benefits THEN BEGIN
                    IF PayrollComponentUsage."Deduct on Leave" THEN BEGIN
                        LeaveDeductedAmount := -ROUND((xRecValue / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                        SalaryLine."Total Deduction" := SalaryLine."Total Deduction" + LeaveDeductedAmount;
                        LeaveDeductedAmount := ROUND((RecValue / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                        SalaryLine."Total Deduction" := SalaryLine."Total Deduction" + LeaveDeductedAmount;
                    END;
                    SalaryLine.VALIDATE("Total Benefit", SalaryLine."Total Benefit" - xRecValue + RecValue);
                END
                ELSE
                    IF PayrollComponent.Type = PayrollComponent.Type::Deduction THEN BEGIN
                        IF PayrollComponentUsage."Deduct on Leave" THEN BEGIN
                            LeaveDeductedAmount := -ROUND((xRecValue / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                            SalaryLine."Total Deduction" := SalaryLine."Total Deduction" + LeaveDeductedAmount;
                            LeaveDeductedAmount := ROUND((RecValue / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                            SalaryLine."Total Deduction" := SalaryLine."Total Deduction" + LeaveDeductedAmount;
                        END;
                        SalaryLine.VALIDATE("Total Deduction", SalaryLine."Total Deduction" - xRecValue + RecValue);
                    END
                    ELSE
                        IF PayrollComponent.Type = PayrollComponent.Type::"Employer Contribution" THEN BEGIN
                            IF PayrollComponentUsage."Deduct on Leave" THEN BEGIN
                                LeaveDeductedAmount := -ROUND((xRecValue / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                                SalaryLine.VALIDATE("Total Deduction", SalaryLine."Total Deduction" + LeaveDeductedAmount);
                                LeaveDeductedAmount := ROUND((RecValue / TotalWorkingDays) * TotalAbsentDays, 0.01, '=');
                                SalaryLine.VALIDATE("Total Deduction", SalaryLine."Total Deduction" + LeaveDeductedAmount);
                            END;
                            SalaryLine.VALIDATE("Total Employer Contribution", SalaryLine."Total Employer Contribution" - xRecValue + RecValue);
                        END;
            END;
            SalaryLineRec := SalaryLine;
            SalaryLineRec.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure GetPayMonth(FieldID: Integer; Type: Option Earning,Retirement; ValueOfBenefit: Decimal): Decimal
    var
        PayrollCompUsage: Record "33020504";
        PayStartMonth: Integer;
        YearStartMonth: Integer;
        YearDifference: Integer;
        MaxMonth: Integer;
        PayrollPercent: Decimal;
    begin
        //IF IsValidComponent THEN BEGIN
        VFUsage.RESET;
        VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
        VFUsage.SETRANGE("Field No.", FieldID);
        IF VFUsage.FINDFIRST THEN BEGIN
            PayrollComponent.GET(VFUsage."Variable Field Code");
            IF PayrollComponent."Enable % wise calculation" THEN
                PayrollPercent := Employee."Payroll %" / 100
            ELSE
                PayrollPercent := 1;
            IF PayrollCompUsage.GET(Employee."No.", PayrollComponent.Code) THEN BEGIN
                CASE Type OF
                    Type::Earning:
                        BEGIN
                            IF (PayrollComponent.Type = PayrollComponent.Type::Benefits) THEN BEGIN
                                IF ((PayrollComponent."Tax Credit Amount" <> 0) AND
                                      (PayrollComponent."Tax Credit %" <> 0)) THEN BEGIN
                                    IF ((ValueOfBenefit * PayrollComponent."Tax Credit %" / 100.0) < PayrollComponent."Tax Credit Amount") THEN
                                        TotalTaxCredit += ROUND((ValueOfBenefit * PayrollComponent."Tax Credit %" / 100.0), 0.01, '=')
                                    ELSE
                                        TotalTaxCredit += ROUND(PayrollComponent."Tax Credit Amount", 0.01, '=');
                                END;
                            END;
                            IF ((PayrollComponent.Type = PayrollComponent.Type::Benefits))
                             THEN BEGIN
                                IF (PayrollCompUsage.Fixed) AND (PayrollComponent."Apply Every Month") THEN BEGIN
                                    //PayrollCompUsage.TESTFIELD(Amount);
                                    EXIT((RemainingMonth - 1) * PayrollCompUsage.Amount * PayrollPercent)
                                END
                                ELSE
                                    IF (PayrollCompUsage.Fixed) AND (NOT PayrollComponent."Apply Every Month") THEN BEGIN
                                        //PayrollCompUsage.TESTFIELD(Amount);
                                        IF (PayrollCompUsage."Applicable Month" = SalaryHeader.Month) AND                //modified by chandra
                                           (PayrollComponentUsage."Applicable from" > SalaryHeader."From Date") AND      //added by chandra
                                           (PayrollComponentUsage."Applicable from" <= SalaryHeader."To Date") THEN      //added by chandra
                                            EXIT(1 * PayrollCompUsage.Amount * PayrollPercent)
                                    END
                            END
                            //added on 4-24-2013 >>
                            ELSE
                                IF ((PayrollComponent.Type = PayrollComponent.Type::"Employer Contribution") AND
                              (PayrollComponent.Subtype = PayrollComponent.Subtype::Retirement))
                             THEN BEGIN
                                    IF (PayrollComponent."Apply Every Month") THEN BEGIN
                                        IF PayrollCompUsage.Formula <> '' THEN
                                            EXIT((RemainingMonth - 1) * EvaluateAmount(PayrollCompUsage.Formula, FALSE))
                                        ELSE
                                            EXIT((RemainingMonth - 1) * PayrollCompUsage.Amount * PayrollPercent);
                                    END
                                END;
                            //added on 4-24-2013 <<
                            EXIT(0);
                        END;
                    Type::Retirement:
                        BEGIN
                            IF (PayrollComponent.Subtype = PayrollComponent.Subtype::Retirement)
                             THEN BEGIN
                                IF PayrollComponent."Apply Every Month" THEN BEGIN
                                    PayrollCompUsage.RESET;
                                    PayrollCompUsage.SETRANGE("Employee No.", Employee."No.");
                                    PayrollCompUsage.SETRANGE("Payroll Component Code", PayrollComponent.Code);
                                    IF PayrollCompUsage.FINDFIRST THEN BEGIN
                                        IF PayrollCompUsage."Applicable from" <> 0D THEN BEGIN
                                            IF PRSetup."Payroll Fiscal Year Start Date" < PayrollCompUsage."Applicable from" THEN BEGIN
                                                IF PayMonth <> 1 THEN BEGIN
                                                    PayStartMonth := DATE2DMY(PayrollCompUsage."Applicable from", 2);
                                                    YearStartMonth := DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2);
                                                    PayMonth := 12 - ABS(PayStartMonth - YearStartMonth);
                                                END;
                                            END;
                                        END;
                                    END;
                                    EXIT(PayMonth)
                                END
                                ELSE
                                    EXIT(1);
                            END
                            ELSE
                                EXIT(0);
                        END;
                END;
            END;
        END;
        //END;
    end;

    [Scope('Internal')]
    procedure CalculateComponent(Type: Option Earning,Retirement): Decimal
    begin
        EXIT((SalaryLine."Variable Field 33020500" * GetPayMonth(33020500, Type, SalaryLine."Variable Field 33020500") +
              SalaryLine."Variable Field 33020501" * GetPayMonth(33020501, Type, SalaryLine."Variable Field 33020501") +
              SalaryLine."Variable Field 33020502" * GetPayMonth(33020502, Type, SalaryLine."Variable Field 33020502") +
              SalaryLine."Variable Field 33020503" * GetPayMonth(33020503, Type, SalaryLine."Variable Field 33020503") +
              SalaryLine."Variable Field 33020504" * GetPayMonth(33020504, Type, SalaryLine."Variable Field 33020504") +
              SalaryLine."Variable Field 33020505" * GetPayMonth(33020505, Type, SalaryLine."Variable Field 33020505") +
              SalaryLine."Variable Field 33020506" * GetPayMonth(33020506, Type, SalaryLine."Variable Field 33020506") +
              SalaryLine."Variable Field 33020507" * GetPayMonth(33020507, Type, SalaryLine."Variable Field 33020507") +
              SalaryLine."Variable Field 33020508" * GetPayMonth(33020508, Type, SalaryLine."Variable Field 33020508") +
              SalaryLine."Variable Field 33020509" * GetPayMonth(33020509, Type, SalaryLine."Variable Field 33020509") +
              SalaryLine."Variable Field 33020510" * GetPayMonth(33020510, Type, SalaryLine."Variable Field 33020510") +
              SalaryLine."Variable Field 33020511" * GetPayMonth(33020511, Type, SalaryLine."Variable Field 33020511") +
              SalaryLine."Variable Field 33020512" * GetPayMonth(33020512, Type, SalaryLine."Variable Field 33020512") +
              SalaryLine."Variable Field 33020513" * GetPayMonth(33020513, Type, SalaryLine."Variable Field 33020513") +
              SalaryLine."Variable Field 33020514" * GetPayMonth(33020514, Type, SalaryLine."Variable Field 33020514") +
              SalaryLine."Variable Field 33020515" * GetPayMonth(33020515, Type, SalaryLine."Variable Field 33020515") +
              SalaryLine."Variable Field 33020516" * GetPayMonth(33020516, Type, SalaryLine."Variable Field 33020516") +
              SalaryLine."Variable Field 33020517" * GetPayMonth(33020517, Type, SalaryLine."Variable Field 33020517") +
              SalaryLine."Variable Field 33020518" * GetPayMonth(33020518, Type, SalaryLine."Variable Field 33020518") +
              SalaryLine."Variable Field 33020519" * GetPayMonth(33020519, Type, SalaryLine."Variable Field 33020519")
              ));
    end;

    [Scope('Internal')]
    procedure CalculateEarning(): Decimal
    var
        PostedSalaryLine: Record "33020513";
        TotalCummulativeEarning: Decimal;
        SalaryLedgerEntry: Record "33020520";
        Type: Option Earning,Retirement;
        YearDifference: Integer;
    begin
        //RemainingMonth := 12 - (DATE2DMY(SalaryHeader."From Date",2) - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date",2));
        YearDifference := (DATE2DMY(SalaryHeader."From Date", 3) - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 3));

        //ratan 8.27.2021 remaining month to be calculated based on last working day>>
        IF Employee."Last Working Day" = 0D THEN BEGIN
            RemainingMonth := 12 -
                             ((DATE2DMY(SalaryHeader."From Date", 2) + YearDifference * 12)
                              - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2));
        END
        ELSE BEGIN
            IF (DATE2DMY(Employee."Last Working Day", 2) IN [1, 2, 3, 4, 5, 6, 7]) THEN
                RemainingMonth := (12 + DATE2DMY(Employee."Last Working Day", 2) - (DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2))) -
                               ((DATE2DMY(SalaryHeader."From Date", 2) + YearDifference * 12)
                                - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2))
            ELSE
                RemainingMonth := (DATE2DMY(Employee."Last Working Day", 2) - (DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2))) -
                               ((DATE2DMY(SalaryHeader."From Date", 2) + YearDifference * 12)
                                - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2));
        END;
        //MESSAGE(FORMAT(RemainingMonth));  //cccc

        SalaryLedgerEntry.RESET;
        SalaryLedgerEntry.SETCURRENTKEY("Employee Code", "Fiscal Year From", SalaryLedgerEntry."Fiscal Year To");
        SalaryLedgerEntry.SETRANGE("Employee Filter", Employee."No.");
        SalaryLedgerEntry.SETRANGE("Fiscal Year DateFilter", PRSetup."Payroll Fiscal Year Start Date");
        SalaryLedgerEntry.CALCFIELDS("Basic Cummulation", "Tax Cummulation", "Benefit Cummulation", "Deduction Cummulation",
                                      SalaryLedgerEntry."Emp. Contribution Cummulation", "CIT Cummulation");
        TotalCummulativeEarning := SalaryLedgerEntry."Benefit Cummulation";
        //MESSAGE('Benefit Cummulation>>'+FORMAT(TotalCummulativeEarning));

        TotalCummulativeEarning += GetBasicSalary * (RemainingMonth - 1) +
                                   +GetBenefits + GetProjectionForBenefit;

        //MESSAGE('11 month basic '+FORMAT((GetBasicSalary * ( RemainingMonth - 1))));
        //MESSAGE('Total cummulative earning '+FORMAT(TotalCummulativeEarning));

        TotalTaxPaid := SalaryLedgerEntry."Tax Cummulation";
        //MESSAGE('Tax Paid--->>'+FORMAT(TotalTaxPaid));
        CummulativeContribution := SalaryLedgerEntry."Emp. Contribution Cummulation";
        /*InvestmentOnRetirement := SalaryLedgerEntry."CIT Cummulation" + SalaryLine."Variable Field 33020511" //hardcoded for quick solution
                                   + GetProjectionInvestment*(RemainingMonth - 1);*/ //sipradi modified on June 23 2013
        InvestmentOnRetirement := SalaryLedgerEntry."CIT Cummulation" + GetCITCurrent
                                   + GetProjectionInvestment * (RemainingMonth - 1);
        //MESSAGE('Projection with basic >>'+FORMAT(TotalCummulativeEarning));
        EXIT(TotalCummulativeEarning);

    end;

    [Scope('Internal')]
    procedure CalculateRetirement(): Decimal
    var
        Type: Option Earning,Retirement;
        TotalValue: Decimal;
        PayrollCompUsage: Record "33020504";
        PayStartMonth: Integer;
        YearStartMonth: Integer;
        EmpContribution: Decimal;
    begin
        TotalValue := 0;
        PayrollCompUsage.RESET;
        PayrollCompUsage.SETRANGE("Employee No.", Employee."No.");
        PayrollCompUsage.SETRANGE("Payroll Type", PayrollCompUsage."Payroll Type"::"Employer Contribution");
        IF PayrollCompUsage.FINDFIRST THEN BEGIN
            IF PayrollCompUsage."Applicable from" <> 0D THEN BEGIN
                IF PRSetup."Payroll Fiscal Year Start Date" < PayrollCompUsage."Applicable from" THEN BEGIN
                    PayStartMonth := DATE2DMY(PayrollCompUsage."Applicable from", 2);
                    YearStartMonth := DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2);
                    PayMonth := 12 - ABS(PayStartMonth - YearStartMonth);
                END
                ELSE BEGIN
                    PayStartMonth := DATE2DMY(SalaryHeader."From Date", 2);
                    YearStartMonth := DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2);
                    PayMonth := 12 - ABS(PayStartMonth - YearStartMonth);
                END;
            END
            ELSE
                PayMonth := RemainingMonth;
            EmpContribution := 0.1 * GetBasicSalary * (PayMonth - 1);
            //MESSAGE('Emp contribution ' + FORMAT(EmpContribution));
        END;
        //MESSAGE(FORMAT(InvestmentOnRetirement));
        TotalValue := 2 * (SalaryLine."Total Employer Contribution" + CummulativeContribution + EmpContribution);
        //message('emp contribution '+format(totalvalue));
        TotalValue += InvestmentOnRetirement;
        //MESSAGE('with CIT '+FORMAT(TotalValue));
        EXIT(TotalValue);
    end;

    [Scope('Internal')]
    procedure CalcSalary(var SalaryLineRec: Record "33020511")
    var
        Text000: Label 'Tax Setup %1 is outdated for employee %2. Please update Tax Setup.';
    begin
        PRSetup.GET;
        IF PRSetup."Tax Ex. Amt. (%) on Retirement" > 0 THEN
            PRSetup.TESTFIELD("Tax Ex. Amt. not Exceeding");
        PRSetup.TESTFIELD("Working Days in a Month");
        PRSetup.TESTFIELD("Payroll Fiscal Year Start Date");
        PRSetup.TESTFIELD("Payroll Fiscal Year End Date");

        Employee.GET(SalaryLineRec."Employee No.");
        TaxSetupHeader.RESET;
        TaxSetupHeader.SETRANGE(Code, Employee."Tax Code");
        TaxSetupHeader.FINDFIRST;
        TaxSetupHeader.TESTFIELD("Effective from");
        TaxSetupHeader.TESTFIELD("Effective to");
        SalaryLine := SalaryLineRec;
        GetSalaryHeader();
        IF TaxSetupHeader."Effective to" < SalaryHeader."To Date" THEN
            ERROR(Text000, TaxSetupHeader.Code, Employee."No.");
        CalcAmount();
        SalaryLineRec := SalaryLine;
    end;

    [Scope('Internal')]
    procedure CalcAmount()
    var
        EmploymentMonth: Integer;
        PayPeriodStartMonths: Integer;
        TotalAnnualEarning: Decimal;
        RetirementFund: Decimal;
        RetirementFundLimit1: Decimal;
        RetirementFundLimit2: Decimal;
        RetirementFund2: Decimal;
        SumOfTax: Decimal;
        RetirementFundExceed: Decimal;
        InsuranceAmountExact: Decimal;
        InsuranceAmount: Decimal;
        DonationAmount: Decimal;
        DonationLimit1: Decimal;
        DonationLimit2: Decimal;
        DonationAmount2: Decimal;
        SalaryLedgEntry: Record "33020520";
        TaxPaid: Decimal;
        RetirementFundWithIrregularComp: Decimal;
        RetirementFundWithoutIrregularComp: Decimal;
    begin
        GetPaidAmount();
        IF PRSetup."Payroll Fiscal Year Start Date" < Employee."Employment Date" THEN BEGIN
            EmploymentMonth := DATE2DMY(Employee."Employment Date", 2) + 1;
            PayPeriodStartMonths := DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2);
            PayMonth := 12 - ABS(EmploymentMonth - PayPeriodStartMonths);
        END
        ELSE
            PayMonth := 12;

        IF PRSetup."Tax Calculation Type" = PRSetup."Tax Calculation Type"::Monthly THEN BEGIN
            PayMonth := 1;
        END;
        TotalTaxCredit := 0;
        TotalAnnualEarning := CalculateEarning();
        TotalAnnualEarning += SalaryLine."Non-Payment Adjustment";

        //*******RETIREMENT FUND CALCULATION ******************


        RetirementFund := CalculateRetirement();
        RetirementFundLimit1 := PRSetup."Tax Ex. Amt. not Exceeding";
        RetirementFundLimit2 := PRSetup."Tax Ex. Amt. (%) on Retirement" * TotalAnnualEarning / 100.0;
        IF RetirementFundLimit1 < RetirementFundLimit2 THEN
            RetirementFund2 := RetirementFundLimit1
        ELSE
            RetirementFund2 := RetirementFundLimit2;
        IF RetirementFund2 < RetirementFund THEN
            RetirementFund := RetirementFund2;
        //IRGCMP1.00 >>

        RetirementFundWithIrregularComp := RetirementFund;



        RetirementFundLimit1 := PRSetup."Tax Ex. Amt. not Exceeding";
        RetirementFundLimit2 := PRSetup."Tax Ex. Amt. (%) on Retirement" * (TotalAnnualEarning - EvaluateAndCalculateIrregularComponent(SalaryLine)) / 100.0;
        IF RetirementFundLimit1 < RetirementFundLimit2 THEN
            RetirementFund2 := RetirementFundLimit1
        ELSE
            RetirementFund2 := RetirementFundLimit2;
        IF RetirementFund2 < RetirementFund THEN
            RetirementFund := RetirementFund2;

        RetirementFundWithoutIrregularComp := RetirementFund;
        //IRGCMP1.00 <<
        //MESSAGE(FORMAT(RetirementFund));



        //*******DONATION CALCULATION ******************
        DonationAmount := Employee."Donation Amount";
        DonationLimit1 := PRSetup."Tax Ex. Amt. not Exeed on Don.";
        DonationLimit2 := PRSetup."Tax Ex. Amt. (%) on Donation" * (TotalAnnualEarning - RetirementFund) / 100.0;
        IF DonationLimit1 < DonationLimit2 THEN
            DonationAmount2 := DonationLimit1
        ELSE
            DonationAmount2 := DonationLimit2;
        IF DonationAmount2 < DonationAmount THEN
            DonationAmount := DonationAmount2;

        //*******LIFE INSURANCE AMOUNT CALCULATION ******************
        InsuranceAmount := Employee."Premium of Life Insurance";
        IF InsuranceAmount > PRSetup."Tax Ex. Insurance Amt." THEN
            InsuranceAmountExact := (PRSetup."Tax Ex. Insurance Amt.")
        ELSE
            InsuranceAmountExact := InsuranceAmount;

        //*******Health INSURANCE AMOUNT CALCULATION ******************
        HealthInsurance := Employee."Premium of Health Insurance";
        IF HealthInsurance > PRSetup."Tax Ex. Amt. on Health Insur." THEN
            HealthInsuranceExact := (PRSetup."Tax Ex. Amt. on Health Insur.")
        ELSE
            HealthInsuranceExact := HealthInsurance;

        //*******Building INSURANCE AMOUNT CALCULATION ******************
        BuidlingInsurance := Employee."Premium of Building Insurance";
        IF BuidlingInsurance > PRSetup."Tax Ex. Amt on Building Insur." THEN
            BuildingInsuranceExact := (PRSetup."Tax Ex. Amt on Building Insur.")
        ELSE
            BuildingInsuranceExact := BuidlingInsurance;

        //*******TAX CALCULATION ******************

        //SalaryLine."Taxable Income" := TotalAnnualEarning - RetirementFund - InsuranceAmountExact - DonationAmount;//IRGCMP1.0 previous code commented
        SalaryLine."Taxable Income" := TotalAnnualEarning - RetirementFundWithIrregularComp - InsuranceAmountExact - HealthInsuranceExact - BuildingInsuranceExact - DonationAmount; //IRGCMP1.0
        RemainingAmount := SalaryLine."Taxable Income";
        RemainingAmtTaxLedger := RemainingAmount;

        //IRGCMP1.00 >>

        //Normal Calculation Without Irregular component

        ReggularSalaryLine := SalaryLine;
        //ReggularSalaryLine."Taxable Income" := SalaryLine."Taxable Income" - EvaluateAndCalculateIrregularComponent(SalaryLine);
        ReggularSalaryLine."Taxable Income" := TotalAnnualEarning - RetirementFundWithoutIrregularComp - InsuranceAmountExact - HealthInsuranceExact - BuildingInsuranceExact - DonationAmount - EvaluateAndCalculateIrregularComponent(SalaryLine);
        RemainingAmount := ReggularSalaryLine."Taxable Income";
        RemainingAmtTaxLedger := RemainingAmount;
        PerformTaxCalculation(ReggularSalaryLine);

        //Calculation With Irregular component
        IrregularSalaryLine := SalaryLine;
        IrregularSalaryLine."Taxable Income" := SalaryLine."Taxable Income";
        RemainingAmount := IrregularSalaryLine."Taxable Income";
        RemainingAmtTaxLedger := RemainingAmount;
        PerformTaxCalculation(IrregularSalaryLine);

        //
        SalaryLine."Last Slab (%)" := IrregularSalaryLine."Last Slab (%)";
        SalaryLine."Tax Paid on First Account" := IrregularSalaryLine."Tax Paid on First Account";
        SalaryLine."Tax Paid on Second Account" := IrregularSalaryLine."Tax Paid on Second Account";
        SalaryLine."Tax for Period" := IrregularSalaryLine."Tax for Period" + ROUND(((IrregularSalaryLine."Tax for Period" - ReggularSalaryLine."Tax for Period") * (RemainingMonth - 1)), 0.01, '=');

        //IRGCMP1.00 <<

        //FOR REGULAR PROCESS>>>START
        /*//Traditional code commented for the sakes of IRGCMP1.0 and transfered to function performtaxcalculation
        SumOfTax := 0;
        TaxSetupLine.RESET;
        TaxSetupLine.SETRANGE(Code,TaxSetupHeader.Code);
        IF TaxSetupLine.FINDSET THEN REPEAT
            IF RemainingAmount > 0 THEN BEGIN
              TaxSetupLine.TESTFIELD("Tax Rate");
              SumOfTax +=  GetTax(TaxSetupLine."Start Amount",TaxSetupLine."End Amount")*TaxSetupLine."Tax Rate"/100.0;
        
                IF NOT SalaryHeader."Irregular Process" THEN BEGIN
                  IF TaxLedgerEntry.FINDLAST THEN
                     TaxLedgerEntry."Entry No." := TaxLedgerEntry."Entry No." + 1
                  ELSE
                     TaxLedgerEntry."Entry No." := 1;
                  TaxLedgerEntry.INIT;
                  TaxLedgerEntry."Employee No." := SalaryLine."Employee No.";
                  TaxLedgerEntry."Tax Start Amount" := TaxSetupLine."Start Amount";
                  IF TaxSetupLine."End Amount" > RemainingAmtTaxLedger THEN
                     TaxLedgerEntry."Tax End Amount" := RemainingAmtTaxLedger
                  ELSE
                     TaxLedgerEntry."Tax End Amount" := TaxSetupLine."End Amount";
                  TaxLedgerEntry."Tax Rate" := TaxSetupLine."Tax Rate";
                  TaxLedgerEntry.Difference := (TaxLedgerEntry."Tax End Amount" - TaxSetupLine."Start Amount") + 1;
                  TaxLedgerEntry."Percent Calculation" :=   TaxLedgerEntry.Difference * (TaxLedgerEntry."Tax Rate"/100);
                  TaxLedgerEntry."Sum of Tax" := SumOfTax;
                  TaxLedgerEntry."Monthly Tax"  := SalaryLine."Tax for Period";
                  TaxLedgerEntry."Created Date" := WORKDATE;
                  TaxLedgerEntry."Document No." := SalaryLine."Document No.";
                  TaxLedgerEntry."Tax Setup End Amt" := TaxSetupLine."End Amount";
                  Taxledgerentry1.RESET;
                  Taxledgerentry1.SETRANGE("Employee No.",TaxLedgerEntry."Employee No.");
                  Taxledgerentry1.SETRANGE("Tax Rate",TaxLedgerEntry."Tax Rate");
                  Taxledgerentry1.SETRANGE("Document No.",TaxLedgerEntry."Document No.");
                  //Taxledgerentry1.SETRANGE("Created Date",TaxLedgerEntry."Created Date");
                  IF Taxledgerentry1.FINDFIRST THEN BEGIN
                     Taxledgerentry1."Tax Start Amount" := TaxSetupLine."Start Amount";
                     IF TaxSetupLine."End Amount" > RemainingAmtTaxLedger THEN
                        Taxledgerentry1."Tax End Amount" := RemainingAmtTaxLedger
                     ELSE
                        Taxledgerentry1."Tax End Amount" := TaxSetupLine."End Amount";
                     Taxledgerentry1."Tax Rate" := TaxSetupLine."Tax Rate";
                     Taxledgerentry1.Difference := (Taxledgerentry1."Tax End Amount" - TaxSetupLine."Start Amount") + 1;
                     Taxledgerentry1."Percent Calculation" := Taxledgerentry1.Difference*(Taxledgerentry1."Tax Rate"/100);
                     Taxledgerentry1."Sum of Tax" := SumOfTax;
                     Taxledgerentry1."Monthly Tax" := SalaryLine."Tax for Period";
                    // MESSAGE('tax ledger tax>>'+FORMAT(Taxledgerentry1."Monthly Tax"));
                     Taxledgerentry1."Tax Setup End Amt" := TaxSetupLine."End Amount";
                     Taxledgerentry1."Created Date" := WORKDATE;
                     Taxledgerentry1.MODIFY;
                  END ELSE
                     TaxLedgerEntry.INSERT(TRUE);
        
                     DelTaxLed.RESET;
                     DelTaxLed.SETRANGE("Employee No.",SalaryLine."Employee No.");
                     DelTaxLed.SETRANGE("Document No.",SalaryLine."Document No.");
                     IF DelTaxLed.FINDFIRST THEN BEGIN
                        REPEAT
                          IF DelTaxLed."Tax End Amount" < DelTaxLed."Tax Setup End Amt" THEN BEGIN
                           // MESSAGE('tax '+FORMAT(DelTaxLed."Tax End Amount"));
                             TaxEntryNo := DelTaxLed."Entry No.";
                             TaxLedDeleted.RESET;
                             TaxLedDeleted.SETRANGE("Employee No.",SalaryLine."Employee No.");
                             TaxLedDeleted.SETRANGE("Document No.",SalaryLine."Document No.");
                             TaxLedDeleted.SETFILTER("Entry No.",'>%1',TaxEntryNo);
                             IF TaxLedDeleted.FINDFIRST THEN
                                TaxLedDeleted.DELETE;
                          END;
                        UNTIL DelTaxLed.NEXT = 0;
                      END;
                END;
        
              IF NOT SalaryHeader."Irregular Process" THEN
                SalaryLine."Last Slab (%)" := TaxSetupLine."Tax Rate";
            END;
        UNTIL (TaxSetupLine.NEXT = 0);
        SalaryLine."Total Tax Credit" := TotalTaxCredit;
        IF NOT SalaryHeader."Irregular Process" THEN BEGIN
          IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN
            SumOfTax := (SumOfTax - (SumOfTax * TaxSetupHeader."Special Tax Exempt %") / 100);
        
           SumOfTax := SumOfTax - TotalTaxPaid;
           //MESSAGE('Tax excluding Paid'+FORMAT(SumOfTax));
        
          IF SumOfTax > TotalTaxCredit THEN
            SumOfTax -= TotalTaxCredit
          ELSE
            SumOfTax := 0;
          SalaryLine."Tax for Period" := ROUND(SumOfTax/RemainingMonth,0.01,'=');
        END
        
        //FOR REGULAR PROCESS>>>END
        
        //FOR IRREGULAR PROCESS>>>START
        
        ELSE BEGIN
          SalaryLine."Taxable Income" := SalaryLine."Total Benefit";
          SalaryLedgEntry.RESET;
          SalaryLedgEntry.SETCURRENTKEY("Employee Code","Fiscal Year From","Fiscal Year To");
          SalaryLedgEntry.SETRANGE("Employee Code",Employee."No.");
          SalaryLedgEntry.SETRANGE("Fiscal Year From",PRSetup."Payroll Fiscal Year Start Date");
          SalaryLedgEntry.SETRANGE("Fiscal Year To",PRSetup."Payroll Fiscal Year End Date");
          SalaryLedgEntry.SETRANGE("Irregular Process",FALSE);
          SalaryLedgEntry.SETRANGE(Reversed,FALSE);
          IF SalaryLedgEntry.FINDLAST THEN BEGIN
            IF SalaryLine."Taxable Income" <= SalaryLedgEntry."Remaining Amount to Cross Slab" THEN BEGIN
              SalaryLine."Tax for Period" := ROUND((SalaryLine."Taxable Income" * SalaryLedgEntry."Last Slab (%)"/100),0.01,'=');
              SalaryLine."Last Slab (%)" := SalaryLedgEntry."Last Slab (%)"; //PRM7.1.1
              SalaryLine."Remaining Amount to Cross Slab" := SalaryLedgEntry."Remaining Amount to Cross Slab"- SalaryLine."Taxable Income";
              //PRM7.1.1
                //ER Addition of Code which was at the end
                IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN BEGIN
                  SalaryLine.VALIDATE("Tax for Period",ROUND(((SalaryLine."Tax for Period" -
                        (SalaryLine."Tax for Period" * TaxSetupHeader."Special Tax Exempt %") / 100)),0.01,'='));
                END;
                IF SalaryLine."Tax for Period" > TotalTaxCredit THEN
                  SalaryLine."Tax for Period" -= TotalTaxCredit
                ELSE
                  SalaryLine."Tax for Period" := 0;
                //ER Addition of Code which was at the end
              //***SM Tax split for irregular salary plan
              EmpIrregularTax.RESET;
              EmpIrregularTax.SETRANGE("No.",SalaryLine."Employee No.");
              EmpIrregularTax.FINDFIRST;
        
              TaxSetupIrregular.RESET;
              TaxSetupIrregular.SETRANGE(Code,EmpIrregularTax."Tax Code");
              TaxSetupIrregular.FINDFIRST;
        
              IF TaxSetupIrregular."Tax Rate" = SalaryLedgEntry."Last Slab (%)" THEN
                 SalaryLine."Tax Paid on First Account" := ROUND(SalaryLine."Tax for Period",0.01,'=')
              ELSE
                 SalaryLine."Tax Paid on Second Account" := ROUND(SalaryLine."Tax for Period",0.01,'=');
              //MESSAGE('Case 1 Tax for period' +FORMAT(SalaryLine."Tax for Period"));
              //MESSAGE('Case 1 1st acc' +FORMAT(SalaryLine."Tax Paid on First Account"));
              //MESSAGE('Case 1 2nd acc' +FORMAT(SalaryLine."Tax Paid on Second Account"));
              //***SM Tax split for irregular salary plan
            END
            ELSE BEGIN
              SalaryLine."Tax for Period" :=
                ROUND((SalaryLedgEntry."Remaining Amount to Cross Slab" * SalaryLedgEntry."Last Slab (%)"/100),0.01,'=');
              //ER Addition of Code which was at the end
                IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN BEGIN
                  SalaryLine.VALIDATE("Tax for Period",ROUND(((SalaryLine."Tax for Period" -
                        (SalaryLine."Tax for Period" * TaxSetupHeader."Special Tax Exempt %") / 100)),0.01,'='));
                END;
                IF SalaryLine."Tax for Period" > TotalTaxCredit THEN
                  SalaryLine."Tax for Period" -= TotalTaxCredit
                ELSE
                  SalaryLine."Tax for Period" := 0;
               //ER Addition of Code which was at the end
              //***SM 02 June 2014
              EmpIrregularTax.RESET;
              EmpIrregularTax.SETRANGE("No.",SalaryLine."Employee No.");
              EmpIrregularTax.FINDFIRST;
        
              TaxSetupIrregular.RESET;
              TaxSetupIrregular.SETRANGE(Code,EmpIrregularTax."Tax Code");
              TaxSetupIrregular.FINDFIRST;
        
              IF TaxSetupIrregular."Tax Rate" = SalaryLedgEntry."Last Slab (%)" THEN
                 SalaryLine."Tax Paid on First Account" := ROUND(SalaryLine."Tax for Period",0.01,'=')
              ELSE
                 SalaryLine."Tax Paid on Second Account" := ROUND(SalaryLine."Tax for Period",0.01,'=');
        
              //MESSAGE('Case 2 1st acc' +FORMAT(SalaryLine."Tax Paid on First Account"));
              //MESSAGE('Case 2 2nd acc' +FORMAT(SalaryLine."Tax Paid on Second Account"));
        
              //***SM 02 June 2014
              RemainingAmount := SalaryLine."Taxable Income" - SalaryLedgEntry."Remaining Amount to Cross Slab";
              //MESSAGE(FORMAT(RemainingAmount));
              TaxSetupLine.SETRANGE("Tax Rate",SalaryLedgEntry."Last Slab (%)");
              TaxSetupLine.FINDFIRST;
              TaxSetupLine.SETRANGE("Tax Rate");
              IF TaxSetupLine.NEXT = 0 THEN BEGIN
                SalaryLine."Tax for Period" +=RemainingAmount * SalaryLedgEntry."Last Slab (%)"/100;
                //ER Addition of Code which was at the end
                  IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN BEGIN
                    SalaryLine.VALIDATE("Tax for Period",ROUND(((SalaryLine."Tax for Period" -
                          (SalaryLine."Tax for Period" * TaxSetupHeader."Special Tax Exempt %") / 100)),0.01,'='));
                  END;
                  IF SalaryLine."Tax for Period" > TotalTaxCredit THEN
                    SalaryLine."Tax for Period" -= TotalTaxCredit
                  ELSE
                    SalaryLine."Tax for Period" := 0;
                 //ER Addition of Code which was at the end
        
                //***SM 02 June 2014
                SalaryLine."Tax Paid on Second Account" :=
                      ROUND((SalaryLine."Tax for Period" - SalaryLine."Tax Paid on First Account"),0.01,'=');
                //MESSAGE('Case 3 1st acc' +FORMAT(SalaryLine."Tax Paid on First Account"));
                //MESSAGE('Case 3 2nd acc' +FORMAT(SalaryLine."Tax Paid on Second Account"));
                //***SM 02 June 2014
              END ELSE BEGIN
              //ER
                TaxPaid := RemainingAmount * TaxSetupLine."Tax Rate"/100;
                  //ER Addition of Code which was at the end
                  IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN BEGIN
                    TaxPaid := ROUND(((TaxPaid - (TaxPaid * TaxSetupHeader."Special Tax Exempt %") / 100)),0.01,'=')
                  END;
                  IF TaxPaid > TotalTaxCredit THEN
                    TaxPaid -= TotalTaxCredit
                  ELSE
                   TaxPaid := 0;
                   //ER Addition of Code which was at the end
                SalaryLine."Tax for Period" += TaxPaid;
                SalaryLine."Remaining Amount to Cross Slab" := TaxSetupLine."End Amount" - TaxSetupLine."Start Amount" - RemainingAmount;
                //PRM7.1.1
                SalaryLine."Tax for Period" := ROUND(SalaryLine."Tax for Period",0.01,'=');
                SalaryLine."Last Slab (%)" := TaxSetupLine."Tax Rate"; //PRM7.1.1
                //***SM 02 June 2014
                SalaryLine."Tax Paid on Second Account" :=
                      ROUND((SalaryLine."Tax for Period" - SalaryLine."Tax Paid on First Account"),0.01,'=');
                    //MESSAGE('Case 4 remaining amount' +FORMAT(RemainingAmount));
                    //MESSAGE('Case 4 tax paid' +FORMAT(TaxPaid));
                    //MESSAGE('Case 4 tax rate' +FORMAT(TaxSetupLine."Tax Rate"));
                    //MESSAGE('Case 4 tax for the period' +FORMAT(SalaryLine."Tax for Period"));
                    //MESSAGE('Case 4 1st acc' +FORMAT(SalaryLine."Tax Paid on First Account"));
                    //MESSAGE('Case 4 2nd acc' +FORMAT(SalaryLine."Tax Paid on Second Account"));
                //***SM 02 June 2014
              END;
            END;
          END;
        END;
        */

        //FOR IRREGULAR PROCESS>>>END

        //MESSAGE(FORMAT(SalaryLine."Tax for Period" ));

        SalaryLine."Net Pay" := SalaryLine."Total Benefit" - SalaryLine."Total Deduction" - SalaryLine."Tax Paid on First Account" -
                                SalaryLine."Tax Paid on Second Account";

    end;

    [Scope('Internal')]
    procedure GetTax(StartAmount: Decimal; EndAmount: Decimal): Decimal
    var
        RemainingAmountCopy: Decimal;
    begin
        IF (EndAmount - StartAmount) <= RemainingAmount THEN BEGIN
            //MESSAGE('Remaining amount org-->>>'+FORMAT(RemainingAmount));
            RemainingAmount := RemainingAmount - (EndAmount - StartAmount + 1);
            //MESSAGE('Remaining amount 1-->>>'+FORMAT(RemainingAmount));
            EXIT(EndAmount - StartAmount + 1)
        END
        ELSE BEGIN
            RemainingAmountCopy := RemainingAmount;
            IF NOT SalaryHeader."Irregular Process" THEN
                SalaryLine."Remaining Amount to Cross Slab" := (EndAmount - StartAmount + 1) - RemainingAmount;
            //   message(format(
            RemainingAmount := 0;
            //MESSAGE('Remaining amount 2--->'+FORMAT(RemainingAmountCopy));
            EXIT(RemainingAmountCopy);
        END;
    end;

    [Scope('Internal')]
    procedure SetComponents()
    begin
        //Inserts all Components and corresponding Variable Field IDs to Array Components[FieldID][CompID]
        FieldID := 1;
        CompID := 1;
        VFUsage.RESET;
        VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
        IF VFUsage.FINDSET THEN
            REPEAT
                Components[FieldID] [CompID] := FORMAT(VFUsage."Field No.");
                CompID += 1;
                Components[FieldID] [CompID] := VFUsage."Variable Field Code";
                FieldID += 1;
                CompID := 1;
            UNTIL VFUsage.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetSalaryHeader()
    begin
        //Globally Defines SalaryHeader Record Variable
        SalaryHeader.RESET;
        SalaryHeader.SETRANGE("No.", SalaryLine."Document No.");
        SalaryHeader.FINDFIRST;
        SalaryHeader.TESTFIELD("From Date");
        SalaryHeader.TESTFIELD("To Date");
        SalaryHeader.TESTFIELD(Month);
    end;

    [Scope('Internal')]
    procedure EvaluateFields(IDType: Option "Field",Component; IDValue: Code[20])
    var
        i: Integer;
        VFieldID: Integer;
        ComponentID: Code[20];
    begin
        CASE IDType OF
            IDType::Component:
                BEGIN
                    VFUsage.RESET;
                    VFUsage.SETCURRENTKEY("Table No.", "Variable Field Code");
                    VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
                    VFUsage.SETRANGE("Variable Field Code", IDValue);
                    IF VFUsage.FINDFIRST THEN BEGIN
                        EvaluateFields(0, FORMAT(VFUsage."Field No."));
                    END;
                END;
            IDType::Field:
                BEGIN
                    CASE IDValue OF
                        '33020500':
                            BEGIN
                                SalaryLine."Variable Field 33020500" := CalculatedAmount;
                            END;
                        '33020501':
                            BEGIN
                                SalaryLine."Variable Field 33020501" := CalculatedAmount;
                            END;
                        '33020502':
                            BEGIN
                                SalaryLine."Variable Field 33020502" := CalculatedAmount;
                            END;
                        '33020503':
                            BEGIN
                                SalaryLine."Variable Field 33020503" := CalculatedAmount;
                            END;
                        '33020504':
                            BEGIN
                                SalaryLine."Variable Field 33020504" := CalculatedAmount;
                            END;
                        '33020505':
                            BEGIN
                                SalaryLine."Variable Field 33020505" := CalculatedAmount;
                            END;
                        '33020506':
                            BEGIN
                                SalaryLine."Variable Field 33020506" := CalculatedAmount;
                            END;
                        '33020507':
                            BEGIN
                                SalaryLine."Variable Field 33020507" := CalculatedAmount;
                            END;
                        '33020508':
                            BEGIN
                                SalaryLine."Variable Field 33020508" := CalculatedAmount;
                            END;
                        '33020509':
                            BEGIN
                                SalaryLine."Variable Field 33020509" := CalculatedAmount;
                            END;
                        '33020510':
                            BEGIN
                                SalaryLine."Variable Field 33020510" := CalculatedAmount;
                            END;
                        '33020511':
                            BEGIN
                                SalaryLine."Variable Field 33020511" := CalculatedAmount;
                            END;
                        '33020512':
                            BEGIN
                                SalaryLine."Variable Field 33020512" := CalculatedAmount;
                            END;
                        '33020513':
                            BEGIN
                                SalaryLine."Variable Field 33020513" := CalculatedAmount;
                            END;
                        '33020514':
                            BEGIN
                                SalaryLine."Variable Field 33020514" := CalculatedAmount;
                            END;
                        '33020515':
                            BEGIN
                                SalaryLine."Variable Field 33020515" := CalculatedAmount;
                            END;
                        '33020516':
                            BEGIN
                                SalaryLine."Variable Field 33020516" := CalculatedAmount;
                            END;
                        '33020517':
                            BEGIN
                                SalaryLine."Variable Field 33020517" := CalculatedAmount;
                            END;
                        '33020518':
                            BEGIN
                                SalaryLine."Variable Field 33020518" := CalculatedAmount;
                            END;
                        '33020519':
                            BEGIN
                                SalaryLine."Variable Field 33020519" := CalculatedAmount;
                            END;
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure EvaluateLeaveFields(IDType: Option "Field",Component; IDValue: Code[20])
    var
        i: Integer;
        VFieldID: Integer;
        ComponentID: Code[20];
    begin
        CASE IDType OF
            IDType::Component:
                BEGIN
                    VFUsage.RESET;
                    VFUsage.SETCURRENTKEY("Table No.", "Variable Field Code");
                    VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
                    VFUsage.SETRANGE("Variable Field Code", IDValue);
                    IF VFUsage.FINDFIRST THEN BEGIN
                        EvaluateLeaveFields(0, FORMAT(VFUsage."Field No."));
                    END;
                END;
            IDType::Field:
                BEGIN
                    CASE IDValue OF
                        '33020500':
                            BEGIN
                                SalaryLine."Variable Field 33020500" += LeaveDeductedAmount;
                            END;
                        '33020501':
                            BEGIN
                                SalaryLine."Variable Field 33020501" += LeaveDeductedAmount;
                            END;
                        '33020502':
                            BEGIN
                                SalaryLine."Variable Field 33020502" += LeaveDeductedAmount;
                            END;
                        '33020503':
                            BEGIN
                                SalaryLine."Variable Field 33020503" += LeaveDeductedAmount;
                            END;
                        '33020504':
                            BEGIN
                                SalaryLine."Variable Field 33020504" += LeaveDeductedAmount;
                            END;
                        '33020505':
                            BEGIN
                                SalaryLine."Variable Field 33020505" += LeaveDeductedAmount;
                            END;
                        '33020506':
                            BEGIN
                                SalaryLine."Variable Field 33020506" += LeaveDeductedAmount;
                            END;
                        '33020507':
                            BEGIN
                                SalaryLine."Variable Field 33020507" += LeaveDeductedAmount;
                            END;
                        '33020508':
                            BEGIN
                                SalaryLine."Variable Field 33020508" += LeaveDeductedAmount;
                            END;
                        '33020509':
                            BEGIN
                                SalaryLine."Variable Field 33020509" += LeaveDeductedAmount;
                            END;
                        '33020510':
                            BEGIN
                                SalaryLine."Variable Field 33020510" += LeaveDeductedAmount;
                            END;
                        '33020511':
                            BEGIN
                                SalaryLine."Variable Field 33020511" += LeaveDeductedAmount;
                            END;
                        '33020512':
                            BEGIN
                                SalaryLine."Variable Field 33020512" += LeaveDeductedAmount;
                            END;
                        '33020513':
                            BEGIN
                                SalaryLine."Variable Field 33020513" += LeaveDeductedAmount;
                            END;
                        '33020514':
                            BEGIN
                                SalaryLine."Variable Field 33020514" += LeaveDeductedAmount;
                            END;
                        '33020515':
                            BEGIN
                                SalaryLine."Variable Field 33020515" += LeaveDeductedAmount;
                            END;
                        '33020516':
                            BEGIN
                                SalaryLine."Variable Field 33020516" += LeaveDeductedAmount;
                            END;
                        '33020517':
                            BEGIN
                                SalaryLine."Variable Field 33020517" += LeaveDeductedAmount;
                            END;
                        '33020518':
                            BEGIN
                                SalaryLine."Variable Field 33020518" += LeaveDeductedAmount;
                            END;
                        '33020519':
                            BEGIN
                                SalaryLine."Variable Field 33020519" += LeaveDeductedAmount;
                            END;
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure IsValidComponent(): Boolean
    var
        EMonth: Integer;
    begin
        PayrollComponent.GET(PayrollComponentUsage."Payroll Component Code");
        IF PayrollComponent.Status = PayrollComponent.Status::Active THEN BEGIN
            IF PayrollComponentUsage."Applicable Month" <> PayrollComponentUsage."Applicable Month"::" " THEN BEGIN
                IF FORMAT(SalaryHeader.Month) = FORMAT(PayrollComponentUsage."Applicable Month") THEN
                    IF IsValidPeriod THEN
                        EXIT(TRUE);
            END
            ELSE BEGIN
                IF IsValidPeriod THEN
                    EXIT(TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure IsValidPeriod(): Boolean
    begin
        IF (PayrollComponentUsage."Applicable from" <> 0D) AND (PayrollComponentUsage."Applicable to" <> 0D) THEN BEGIN
            IF (PayrollComponentUsage."Applicable from" <= SalaryHeader."From Date") AND
                (PayrollComponentUsage."Applicable to" >= SalaryHeader."To Date")
             THEN
                EXIT(TRUE);
        END
        ELSE
            IF (PayrollComponentUsage."Applicable from" <> 0D) AND (PayrollComponentUsage."Applicable to" = 0D) THEN BEGIN
                IF PayrollComponentUsage."Applicable from" <= SalaryHeader."From Date" THEN
                    EXIT(TRUE);
            END
            ELSE
                IF (PayrollComponentUsage."Applicable from" = 0D) AND (PayrollComponentUsage."Applicable to" <> 0D) THEN BEGIN
                    IF PayrollComponentUsage."Applicable to" >= SalaryHeader."To Date" THEN
                        EXIT(TRUE);
                END
                ELSE
                    EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure GetBasicSalary(): Decimal
    var
        SalaryLog: Record "33020519";
        Text000: Label 'Salary Structure has not been defined for Employee %1.';
    begin
        SalaryLog.RESET;
        SalaryLog.SETRANGE("Employee No.", Employee."No.");
        IF SalaryLog.FINDLAST THEN BEGIN
            EXIT((SalaryLog."Basic with Grade" + SalaryLog."Increment Value") * Employee."Payroll %" / 100);
        END
        ELSE
            ERROR(Text000, Employee."No.");
        //MESSAGE('Basic '+ FORMAT(SalaryLog."Basic with Grade"));
    end;

    [Scope('Internal')]
    procedure CreateComponenetUsage(ComponentGroup: Record "33020515"; EmployeeCode: Code[20])
    var
        CompUsage: Record "33020504";
        CompGroupLine: Record "33020516";
        RecCompUsage: Record "33020504";
    begin
        RecCompUsage.RESET;
        RecCompUsage.SETRANGE("Employee No.", EmployeeCode);
        CompGroupLine.RESET;
        CompGroupLine.SETRANGE("Component Group Code", ComponentGroup.Code);
        IF CompGroupLine.FINDSET THEN
            REPEAT
                RecCompUsage.SETRANGE("Payroll Component Code", CompGroupLine."Component Code");
                IF NOT RecCompUsage.FINDFIRST THEN BEGIN
                    CompUsage.INIT;
                    CompUsage."Employee No." := EmployeeCode;
                    CompUsage.VALIDATE("Payroll Component Code", CompGroupLine."Component Code");
                    CompUsage.INSERT;
                END;
            UNTIL CompGroupLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetPaidAmount(): Decimal
    var
        AttRegister: Record "33020557";
        BasicPerDay: Decimal;
        UnpaidDays: Decimal;
        TotalUnpaidHolidays: Decimal;
        EmployementDateFound: Boolean;
        CalendarMgmt: Codeunit "33020504";
        StartDate: Date;
        PaidHolidays: Decimal;
        AttLedgerEntry: Record "33020556";
    begin
        PRSetup.GET;
        PRSetup.TESTFIELD("Working Days in a Month");
        PRSetup.TESTFIELD("Leave Deduction Component");
        AttRegister.RESET;
        AttRegister.SETCURRENTKEY("Employee No.", "Attendance From", "Attendance To", "No.");
        AttRegister.SETRANGE("Employee No.", SalaryLine."Employee No.");
        AttRegister.SETRANGE("Attendance From", SalaryHeader."From Date");
        AttRegister.SETRANGE("Attendance To", SalaryHeader."To Date");
        IF AttRegister.FINDLAST THEN BEGIN
            AttRegister.CALCFIELDS("Total Holidays");
            SalaryLine."Present Days" := AttRegister."Present Days";
            SalaryLine."Absent Days" := AttRegister."Absent Days";
            SalaryLine."Paid Days" := AttRegister."Paid Days";
            TotalWorkingDays := SalaryHeader."To Date" - SalaryHeader."From Date" + 1;
            TotalPaidDays := AttRegister."Paid Days";
            TotalAbsentDays := TotalWorkingDays - SalaryLine."Paid Days" - AttRegister."Total Holidays";

            StartDate := SalaryHeader."From Date";
            PaidHolidays := 0;
            AttLedgerEntry.RESET;
            AttLedgerEntry.SETCURRENTKEY("Employee No.", "Attendance Date");
            AttLedgerEntry.SETRANGE("No.", AttRegister."No."); //ER 6.4.14 incase of multiple Attendance Processed
            AttLedgerEntry.SETRANGE("Employee No.", SalaryLine."Employee No.");
            AttLedgerEntry.SETRANGE("Attendance Date", SalaryHeader."From Date", SalaryHeader."To Date");
            AttLedgerEntry.SETRANGE("Day Type", AttLedgerEntry."Day Type"::Holiday);
            IF AttLedgerEntry.FINDFIRST THEN BEGIN
                REPEAT
                    //IF (AttLedgerEntry."Attendance Date" >= Employee."Employment Date") AND
                    IF (AttLedgerEntry."Entry Subtype" <> AttLedgerEntry."Entry Subtype"::Unpaid) THEN
                        PaidHolidays += 1; // only Paid Holidays are considered
                UNTIL AttLedgerEntry.NEXT = 0;
            END;

            //MESSAGE('%1***%2***%3',TotalWorkingDays, TotalPaidDays,PaidHolidays);

            TotalAbsentDays := TotalWorkingDays - TotalPaidDays - PaidHolidays;
            SalaryLine."Absent Days" := TotalAbsentDays;
            SalaryLine."Paid Days" := TotalWorkingDays - SalaryLine."Absent Days";

            //MESSAGE(FORMAT(Totalabsentdays));
            /* EmployementDateFound :=FALSE;
             TotalUnpaidHolidays := 0;
             REPEAT
               IF Employee."Employment Date" = StartDate THEN
                 EmployementDateFound := TRUE;
               StartDate += 1;
             UNTIL (StartDate >= SalaryHeader."To Date") OR EmployementDateFound;

             IF EmployementDateFound THEN BEGIN
               StartDate := SalaryHeader."From Date";
               REPEAT
                 IF CalendarMgmt.CheckDateStatus(PRSetup."Base Calender",StartDate,SalaryLine.Remarks) THEN
                   TotalUnpaidHolidays += 1;
                 StartDate += 1;
               UNTIL StartDate >= Employee."Employment Date" - 1;
             END;

             TotalAbsentDays += TotalUnpaidHolidays;
             EXIT(BasicPerDay);  */
        END
        ELSE BEGIN
            IF NOT SalaryHeader."Irregular Process" THEN
                ERROR(Text000, Employee."No.");
        END;

    end;

    [Scope('Internal')]
    procedure GetVFCaption(TableNo: Integer; FieldNo: Integer; LanguageCode: Code[10]): Text[30]
    var
        VFUsage: Record "33020517";
        VF: Record "33020503";
    begin
        IF VFUsage.GET(TableNo, FieldNo) THEN BEGIN
            IF VF.GET(VFUsage."Variable Field Code") THEN BEGIN
                EXIT(COPYSTR(VF.Code, 1, 20));
            END;
        END;
        EXIT('');
    end;

    [Scope('Internal')]
    procedure DocExists(): Boolean
    var
        SalaryLedgEntry: Record "33020520";
    begin
        SalaryLedgEntry.RESET;
        SalaryLedgEntry.SETCURRENTKEY("Employee Code", "Salary From", "Salary To");
        SalaryLedgEntry.SETRANGE("Employee Code", Employee."No.");
        SalaryLedgEntry.SETRANGE("Salary From", SalaryHeader."From Date");
        SalaryLedgEntry.SETRANGE("Salary To", SalaryHeader."To Date");
        SalaryLedgEntry.SETFILTER(Reversed, '%1', FALSE);
        SalaryLedgEntry.SETRANGE("Irregular Process", FALSE);
        IF SalaryLedgEntry.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure CalculateFormula(UsageFormula: Code[100]): Decimal
    begin
    end;

    [Scope('Internal')]
    procedure InsertLeaveDeduction()
    var
        RecPayrollComponentUsage: Record "33020504";
    begin
        RecPayrollComponentUsage.RESET;
        RecPayrollComponentUsage.SETRANGE("Employee No.", SalaryLine."Employee No.");
        RecPayrollComponentUsage.SETRANGE("Payroll Component Code", PRSetup."Leave Deduction Component");
        IF NOT RecPayrollComponentUsage.FINDFIRST THEN
            ERROR(Text002, Employee."No.");
        EvaluateLeaveFields(1, PRSetup."Leave Deduction Component");
        TotalLeaveDeduction += LeaveDeductedAmount;
    end;

    [Scope('Internal')]
    procedure GetBenefits(): Decimal
    begin
        EXIT(SalaryLine."Total Benefit" + SalaryLine."Total Employer Contribution");
    end;

    [Scope('Internal')]
    procedure GetProjectionForBenefit(): Decimal
    var
        Type: Option Earning,Retirement;
        TotalProjection: Decimal;
    begin
        Type := Type::Earning;
        TotalProjection :=
            (GetPayMonth(33020500, Type, SalaryLine."Variable Field 33020500") +
              GetPayMonth(33020501, Type, SalaryLine."Variable Field 33020501") +
              GetPayMonth(33020502, Type, SalaryLine."Variable Field 33020502") +
              GetPayMonth(33020503, Type, SalaryLine."Variable Field 33020503") +
              GetPayMonth(33020504, Type, SalaryLine."Variable Field 33020504") +
              GetPayMonth(33020505, Type, SalaryLine."Variable Field 33020505") +
              GetPayMonth(33020506, Type, SalaryLine."Variable Field 33020506") +
              GetPayMonth(33020507, Type, SalaryLine."Variable Field 33020507") +
              GetPayMonth(33020508, Type, SalaryLine."Variable Field 33020508") +
              GetPayMonth(33020509, Type, SalaryLine."Variable Field 33020509") +
              GetPayMonth(33020510, Type, SalaryLine."Variable Field 33020510") +
              GetPayMonth(33020511, Type, SalaryLine."Variable Field 33020511") +
              GetPayMonth(33020512, Type, SalaryLine."Variable Field 33020512") +
              GetPayMonth(33020513, Type, SalaryLine."Variable Field 33020513") +
              GetPayMonth(33020514, Type, SalaryLine."Variable Field 33020514") +
              GetPayMonth(33020515, Type, SalaryLine."Variable Field 33020515") +
              GetPayMonth(33020516, Type, SalaryLine."Variable Field 33020516") +
              GetPayMonth(33020517, Type, SalaryLine."Variable Field 33020517") +
              GetPayMonth(33020518, Type, SalaryLine."Variable Field 33020518") +
              GetPayMonth(33020519, Type, SalaryLine."Variable Field 33020519")
              );
        EXIT(ROUND(TotalProjection, 0.01, '='));
    end;

    [Scope('Internal')]
    procedure GetProjectionInvestment(): Decimal
    var
        PayrollCompUsage: Record "33020504";
        TotalInv: Decimal;
    begin
        TotalInv := 0;
        PayrollCompUsage.RESET;   //sipradi modified on June 23 2013
        PayrollCompUsage.SETRANGE("Employee No.", Employee."No.");
        PayrollCompUsage.SETRANGE("Retirement Investment", TRUE);
        IF PayrollCompUsage.FINDFIRST THEN
            REPEAT
                IF PayrollCompUsage.Formula <> '' THEN
                    TotalInv += EvaluateAmount(PayrollCompUsage.Formula, FALSE)
                ELSE
                    TotalInv += PayrollCompUsage.Amount;
            UNTIL PayrollCompUsage.NEXT = 0;
        EXIT(TotalInv);
    end;

    [Scope('Internal')]
    procedure EvaluateAmount(Expression: Code[100]; BasicFromLine: Boolean): Decimal
    var
        OperatorStack: array[100] of Code[10];
        NumberStack: array[100] of Decimal;
        Result: Decimal;
        i: Integer;
        DecNumber: Decimal;
        NextNumber: Variant;
        ContiguousNumber: Boolean;
        CurrExpr: Code[100];
        OperatorFound: Boolean;
    begin
        ResolveColumn(Expression, BasicFromLine);
        Expression := DELCHR(Expression, '=', ',');
        OPMaster := '+-*/';
        FOR i := 1 TO STRLEN(OPMaster) DO BEGIN
            Operators[i] [1] := FORMAT(OPMaster[i]);
            Operators[i] [2] := FORMAT(i);
        END;
        ExNo := STRLEN(Expression);
        OsNo := 1;
        NsNo := 1;
        REPEAT
            IF Expression[ExNo] IN ['+', '-', '*', '/'] THEN BEGIN
                OperatorFound := FALSE;
                REPEAT
                    IF OsNo > 1 THEN BEGIN
                        IF HasHighPriority(FORMAT(Expression[ExNo]), OperatorStack[OsNo - 1]) THEN BEGIN
                            NsNo -= 1;
                            GetFromStack(NumberStack, OperatorStack, FALSE);
                            NsNo += 1;
                        END;
                    END;
                    IF OsNo - 1 = 0 THEN
                        OperatorFound := FALSE
                    ELSE
                        IF (HasHighPriority(FORMAT(Expression[ExNo]), OperatorStack[OsNo - 1])) THEN BEGIN
                            OperatorFound := TRUE;
                        END;
                UNTIL NOT OperatorFound;
                OperatorStack[OsNo] := FORMAT(Expression[ExNo]);
                OsNo += 1;
            END
            ELSE BEGIN
                CurrExpr := '';
                REPEAT
                    ContiguousNumber := FALSE;
                    IF Expression[ExNo] IN ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'] THEN BEGIN
                        CurrExpr := FORMAT(Expression[ExNo]) + CurrExpr;
                    END;
                    IF ExNo > 1 THEN BEGIN
                        IF EVALUATE(DecNumber, FORMAT(Expression[ExNo - 1])) OR (Expression[ExNo - 1] = '.') THEN BEGIN
                            ContiguousNumber := TRUE;
                            ExNo -= 1;
                        END;
                    END;
                UNTIL NOT ContiguousNumber;
                EVALUATE(DecNumber, CurrExpr);
                NumberStack[NsNo] := DecNumber;
                NsNo += 1;
            END;
            ExNo -= 1;
        UNTIL ExNo = 0;
        NsNo -= 1;
        GetFromStack(NumberStack, OperatorStack, TRUE);
        EXIT(NumberStack[1]);
    end;

    [Scope('Internal')]
    procedure HasHighPriority(RecentOperator: Code[10]; PreviousOperator: Code[10]): Boolean
    var
        i: Integer;
        RecentPriority: Integer;
        PreviousPriority: Integer;
    begin
        FOR i := 1 TO STRLEN(OPMaster) DO BEGIN
            IF RecentOperator = FORMAT(Operators[i] [1]) THEN
                EVALUATE(RecentPriority, Operators[i] [2]);
            IF PreviousOperator = Operators[i] [1] THEN
                EVALUATE(PreviousPriority, Operators[i] [2]);
        END;
        IF PreviousPriority >= RecentPriority THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure GetFromStack(var NumberStack: array[100] of Decimal; var OperatorStack: array[100] of Code[10]; FetchAll: Boolean)
    begin
        IF OsNo > 1 THEN BEGIN
            CASE OperatorStack[OsNo - 1] OF
                '*':
                    NumberStack[NsNo - 1] := NumberStack[NsNo] * NumberStack[NsNo - 1];
                '/':
                    NumberStack[NsNo - 1] := NumberStack[NsNo] / NumberStack[NsNo - 1];
                '+':
                    NumberStack[NsNo - 1] := NumberStack[NsNo] + NumberStack[NsNo - 1];
                '-':
                    NumberStack[NsNo - 1] := NumberStack[NsNo] - NumberStack[NsNo - 1];
            END;
            OsNo -= 1;
            NsNo -= 1;
        END;
        IF (OsNo > 1) AND FetchAll THEN BEGIN
            GetFromStack(NumberStack, OperatorStack, TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure ResolveColumn(var Expression: Code[100]; BasicFromLine: Boolean)
    var
        StrPosition: Integer;
        StrLength: Integer;
        PayrollCompUsage: Record "33020504";
    begin
        Expression := DELCHR(Expression, '=');
        StrPosition := STRPOS(Expression, 'BASIC');
        IF StrPosition > 0 THEN BEGIN
            Expression := DELSTR(Expression, StrPosition, STRLEN('BASIC'));
            IF BasicFromLine THEN
                Expression := INSSTR(Expression, FORMAT(SalaryLine."Basic with Grade"), StrPosition)
            ELSE
                Expression := INSSTR(Expression, FORMAT(GetBasicSalary), StrPosition)
        END;
        StrLength := STRLEN(Expression);
        REPEAT
            IF Expression[StrLength] IN ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                                      'Y', 'Z'] THEN BEGIN
                PayrollCompUsage.RESET;
                PayrollCompUsage.SETCURRENTKEY("Employee No.", "Column Name");
                PayrollCompUsage.SETRANGE("Employee No.", Employee."No.");
                PayrollCompUsage.SETRANGE("Column Name", FORMAT(Expression[StrLength]));
                IF PayrollCompUsage.FINDFIRST THEN BEGIN
                    StrPosition := STRPOS(Expression, FORMAT(Expression[StrLength]));
                    Expression := DELSTR(Expression, StrPosition, STRLEN(FORMAT(Expression[StrLength])));
                    Expression := INSSTR(Expression, FORMAT(PayrollCompUsage.Amount), StrPosition);
                END ELSE BEGIN
                    ERROR(Text007, Employee."No.", FORMAT(Expression[StrLength]));
                END;
            END;
            StrLength -= 1;
        UNTIL StrLength = 0;
    end;

    [Scope('Internal')]
    procedure GetCITCurrent() TotalInv: Decimal
    var
        PayrollComp: Record "33020503";
    begin
        TotalInv := 0;     //sipradi modified on June 23 2013
        PayrollComp.RESET;
        PayrollComp.SETCURRENTKEY("Retirement Investment");
        PayrollComp.SETRANGE("Retirement Investment", TRUE);
        IF PayrollComp.FINDSET THEN
            REPEAT
                TotalInv += EvaluateComponent(1, PayrollComp.Code);
            UNTIL PayrollComp.NEXT = 0;
        EXIT(TotalInv);
    end;

    [Scope('Internal')]
    procedure EvaluateComponent(IDType: Option "Field",Component; IDValue: Code[20]): Decimal
    var
        i: Integer;
        VFieldID: Integer;
        ComponentID: Code[20];
    begin
        CASE IDType OF      //sipradi modified on June 23 2013
            IDType::Component:
                BEGIN
                    VFUsage.RESET;
                    VFUsage.SETCURRENTKEY("Table No.", "Variable Field Code");
                    VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
                    VFUsage.SETRANGE("Variable Field Code", IDValue);
                    IF VFUsage.FINDFIRST THEN BEGIN
                        EXIT(EvaluateComponent(0, FORMAT(VFUsage."Field No.")));
                    END;
                END;
            IDType::Field:
                BEGIN
                    CASE IDValue OF
                        '33020500':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020500");
                            END;
                        '33020501':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020501");
                            END;
                        '33020502':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020502");
                            END;
                        '33020503':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020503");
                            END;
                        '33020504':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020504");
                            END;
                        '33020505':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020505");
                            END;
                        '33020506':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020506");
                            END;
                        '33020507':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020507");
                            END;
                        '33020508':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020508");
                            END;
                        '33020509':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020509");
                            END;
                        '33020510':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020510");
                            END;
                        '33020511':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020511");
                            END;
                        '33020512':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020512");
                            END;
                        '33020513':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020513");
                            END;
                        '33020514':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020514");
                            END;
                        '33020515':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020515");
                            END;
                        '33020516':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020516");
                            END;
                        '33020517':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020517");
                            END;
                        '33020518':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020518");
                            END;
                        '33020519':
                            BEGIN
                                EXIT(SalaryLine."Variable Field 33020519");
                            END;
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure EvaluateIrregularComponents(TempSalaryHeader: Record "33020510"; ComponentCode: Code[20])
    var
        FieldID: Integer;
    begin
        EscapeComponentValidation := TRUE;
        SalaryHeader.GET(TempSalaryHeader."No.");
        IF SalaryHeader."Irregular Process" THEN BEGIN
            SalaryLine.RESET;
            SalaryLine.SETRANGE("Document No.", SalaryHeader."No.");
            IF SalaryLine.FINDSET THEN BEGIN
                REPEAT
                    IF Employee.GET(SalaryLine."Employee No.") THEN BEGIN
                        PayrollComponentUsage.RESET;
                        PayrollComponentUsage.SETRANGE("Employee No.", Employee."No.");
                        PayrollComponentUsage.SETRANGE("Payroll Component Code", ComponentCode);
                        IF PayrollComponentUsage.FINDFIRST THEN BEGIN
                            IF PayrollComponentUsage.Formula <> '' THEN
                                CalculatedAmount := ROUND(EvaluateAmount(PayrollComponentUsage.Formula, FALSE), 0.01, '=')
                            ELSE
                                CalculatedAmount := PayrollComponentUsage.Amount;
                            EvaluateFields(1, PayrollComponentUsage."Payroll Component Code");
                            VFUsage.RESET;
                            VFUsage.SETCURRENTKEY("Table No.", "Variable Field Code");
                            VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
                            VFUsage.SETRANGE("Variable Field Code", ComponentCode);
                            IF VFUsage.FINDFIRST THEN BEGIN
                                FieldID := VFUsage."Field No.";
                            END;
                            UpdateSalaryLine(SalaryLine, FieldID, 0, CalculatedAmount);
                            //CalcAmount();
                        END;
                    END;
                UNTIL SalaryLine.NEXT = 0;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CalcTaxSplit()
    var
        TaxLedEntry: Record "33020521";
        SalaryLedgerEntry: Record "33020520";
        PayrollGeneralSetup: Record "33020507";
        TaxPaidTillNow: Decimal;
        TaxIncludingCurrentMonth: Decimal;
        RecTaxSetup: Record "33020505";
        RecTaxSetupLine: Record "33020506";
        RecEmployee: Record "5200";
        TaxPaidTillNowInFirstAccount: Decimal;
        TaxPaidInFirstAccountInclCurrentMonth: Decimal;
        YearDifference: Integer;
    begin
        ModifyTaxLedgEntry.RESET;
        ModifyTaxLedgEntry.SETRANGE("Document No.", SalaryLine."Document No.");
        ModifyTaxLedgEntry.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF ModifyTaxLedgEntry.FINDFIRST THEN BEGIN
            // MESSAGE(SalaryLine."Document No.");
            // MESSAGE(SalaryLine."Employee No.");
            REPEAT
                ModifyTaxLedgEntry.CALCFIELDS("Total Tax Sum");
                // MESSAGE(FORMAT(ModifyTaxLedgEntry."Total Tax Sum"));
                IF ModifyTaxLedgEntry."Total Tax Sum" <> 0 THEN BEGIN
                    EmpRecForTaxLedg.RESET;
                    EmpRecForTaxLedg.SETRANGE("No.", ModifyTaxLedgEntry."Employee No.");
                    EmpRecForTaxLedg.FINDFIRST;

                    TaxSetupLine1.RESET;
                    TaxSetupLine1.SETRANGE(Code, EmpRecForTaxLedg."Tax Code");
                    IF TaxSetupLine1.FINDFIRST THEN BEGIN
                        TaxRate := TaxSetupLine1."Tax Rate";
                        TaxSetupDiff := TaxSetupLine1."End Amount" - TaxSetupLine1."Start Amount" + 1;
                        TaxHdr1.RESET;
                        TaxHdr1.SETRANGE(Code, TaxSetupLine1.Code);
                        TaxHdr1.FINDFIRST;
                    END;
                    // MESSAGE(FORMAT(TaxRate));
                    IF ModifyTaxLedgEntry."Tax Rate" = TaxRate THEN BEGIN
                        // MESSAGE(FORMAT(SalaryLine."Taxable Income"));
                        // MESSAGE(FORMAT(TaxSetupDiff));
                        // MESSAGE('Percent Calculation/12>>>>'+FORMAT(ModifyTaxLedgEntry."Percent Calculation"/12));
                        // MESSAGE('TaxSetupDiff/12>>>>'+FORMAT((TaxSetupDiff*TaxRate/100)/12));
                        // IF (ModifyTaxLedgEntry."Percent Calculation"/12 >= ModifyTaxLedgEntry."Monthly Tax") THEN BEGIN
                        IF ((TaxSetupDiff * TaxRate / 100) / 12 >= ModifyTaxLedgEntry."Monthly Tax") THEN BEGIN
                            ModifyTaxLedgEntry."Tax Split" := SalaryLine."Tax for Period";
                            FirstSlabAmt := ModifyTaxLedgEntry."Percent Calculation";
                            FirstSlabTax := ModifyTaxLedgEntry."Tax Split";
                            // END ELSE IF (ModifyTaxLedgEntry."Percent Calculation"/12 < ModifyTaxLedgEntry."Monthly Tax") THEN BEGIN
                        END ELSE
                            IF ((TaxSetupDiff * TaxRate / 100) / 12 < ModifyTaxLedgEntry."Monthly Tax") THEN BEGIN
                                // MESSAGE(FORMAT(ModifyTaxLedgEntry."Percent Calculation"/12)); //CCC
                                // MESSAGE('Actual Tax'+FORMAT(ModifyTaxLedgEntry."Monthly Tax"));
                                ModifyTaxLedgEntry."Tax Split" := ((TaxSetupDiff * TaxRate / 100) / 12 * (100 - TaxHdr1."Special Tax Exempt %")) / 100;
                                FirstSlabAmt := ModifyTaxLedgEntry."Percent Calculation";
                                FirstSlabTax := ModifyTaxLedgEntry."Tax Split";
                                // MESSAGE('first slab tax >>>'+FORMAT(FirstSlabTax));
                            END;
                    END ELSE BEGIN
                        ModifyTaxLedgEntry."Tax Split" := ModifyTaxLedgEntry."Percent Calculation" /
                                                        (ModifyTaxLedgEntry."Total Tax Sum" - FirstSlabAmt)
                                                          *
                                                       (ModifyTaxLedgEntry."Monthly Tax" - FirstSlabTax);
                    END;
                END;
                ModifyTaxLedgEntry.MODIFY;
            UNTIL ModifyTaxLedgEntry.NEXT = 0
        END;

        TaxLedEntry.RESET;
        TaxLedEntry.SETRANGE("Document No.", SalaryLine."Document No.");
        TaxLedEntry.SETRANGE("Employee No.", SalaryLine."Employee No.");
        IF TaxLedEntry.FINDFIRST THEN BEGIN
            Employee1.RESET;
            Employee1.SETRANGE("No.", SalaryLine."Employee No.");
            Employee1.FINDFIRST;

            TaxSetupLineSplit.RESET;
            TaxSetupLineSplit.SETRANGE(Code, Employee1."Tax Code");
            TaxSetupLineSplit.FINDFIRST;

            REPEAT
                IF TaxLedEntry."Tax Rate" = TaxSetupLineSplit."Tax Rate" THEN
                    SalaryLine."Tax Paid on First Account" := ROUND(TaxLedEntry."Tax Split", 0.01, '=')
                ELSE
                    SalaryLine."Tax Paid on Second Account" += ROUND(TaxLedEntry."Tax Split", 0.01, '=');
            UNTIL TaxLedEntry.NEXT = 0;
        END;

        //IRGCMP1.00 >>

        PayrollGeneralSetup.RESET;
        CLEAR(TaxPaidTillNow);
        CLEAR(TaxPaidInFirstAccountInclCurrentMonth);
        CLEAR(TaxPaidTillNowInFirstAccount);
        PayrollGeneralSetup.GET;
        SalaryLedgerEntry.RESET;
        SalaryLedgerEntry.SETRANGE("Employee Code", SalaryLine."Employee No.");
        SalaryLedgerEntry.SETFILTER("Salary From", '>=%1', PayrollGeneralSetup."Payroll Fiscal Year Start Date");
        IF SalaryLedgerEntry.FINDFIRST THEN
            REPEAT
                TaxPaidTillNow += SalaryLedgerEntry."Tax Paid";
                TaxPaidTillNowInFirstAccount += SalaryLedgerEntry."Tax Paid on First Account";
                IF NOT SalaryLedgerEntry.Reversed THEN //ratan
                    TaxPaidMonths += 1;

            UNTIL SalaryLedgerEntry.NEXT = 0;
        TaxIncludingCurrentMonth := TaxPaidTillNow + SalaryLine."Tax for Period";
        Employee.GET(SalaryLine."Employee No.");
        RecTaxSetup.RESET;
        RecTaxSetup.SETRANGE(Code, Employee."Tax Code");
        IF RecTaxSetup.FINDFIRST THEN BEGIN
            RecTaxSetupLine.RESET;
            RecTaxSetupLine.SETRANGE(Code, RecTaxSetup.Code);
            RecTaxSetupLine.FINDFIRST;
        END;

        FirstSlabEndValue := ROUND(((RecTaxSetupLine."End Amount" * (RecTaxSetupLine."Tax Rate" / 100)) * (1 - (RecTaxSetup."Special Tax Exempt %" / 100))), 0.01, '=');
        CalcRemainingMonth; //ratan 8.27.21

        //Handling 3 conditions, 1st account crossed, both accounttouched and full amount on 2nd account.
        IF TaxPaidTillNowInFirstAccount <= FirstSlabEndValue THEN BEGIN
            /*IF (TaxPaidTillNowInFirstAccount + SalaryLine."Tax for Period") <= FirstSlabEndValue THEN BEGIN
              SalaryLine."Tax Paid on First Account" := SalaryLine."Tax for Period";
              SalaryLine."Tax Paid on Second Account" := 0;
            END ELSE BEGIN
              SalaryLine."Tax Paid on First Account" := FirstSlabEndValue - TaxPaidTillNowInFirstAccount;
              SalaryLine."Tax Paid on Second Account" := SalaryLine."Tax for Period" - SalaryLine."Tax Paid on First Account";
            END;*/ //ratan old logic commented
            IF TaxPaidMonths = 0 THEN //SRT Oct 15th 2019
                SalaryLine."Tax Paid on First Account" := (FirstSlabEndValue - TaxPaidTillNowInFirstAccount) / 12
            ELSE BEGIN
                IF TaxPaidMonths <> 12 THEN BEGIN   //ratan to avoid 'attempt to divide by zero error'
                    IF SalaryLine."Tax for Period" <= (FirstSlabEndValue - TaxPaidTillNowInFirstAccount) / (12 - TaxPaidMonths) THEN BEGIN
                        SalaryLine."Tax Paid on First Account" := SalaryLine."Tax for Period";
                        SalaryLine."Tax Paid on Second Account" := 0;
                    END ELSE BEGIN
                        SalaryLine."Tax Paid on First Account" := (FirstSlabEndValue - TaxPaidTillNowInFirstAccount) / (12 - TaxPaidMonths); //SRT Oct 15th 2019
                        SalaryLine."Tax Paid on Second Account" := (SalaryLine."Tax for Period" - SalaryLine."Tax Paid on First Account"); //* ( 1 - (RecTaxSetup."Special Tax Exempt %"/100) );
                    END;
                END ELSE BEGIN
                    SalaryLine."Tax Paid on First Account" := 0;
                    SalaryLine."Tax Paid on Second Account" := SalaryLine."Tax for Period";
                END;
            END;
        END ELSE BEGIN
            //    SalaryLine."Tax Paid on First Account" := FirstSlabEndValue - TaxPaidTillNow ;
            //    IF SalaryLine."Tax Paid on First Account" < 0 THEN
            SalaryLine."Tax Paid on First Account" := 0;
            SalaryLine."Tax Paid on Second Account" := SalaryLine."Tax for Period";
        END;

        //IRGCMP1.00 <<

        SalaryLine."Net Pay" := SalaryLine."Total Benefit" - SalaryLine."Total Deduction" - SalaryLine."Tax Paid on First Account" -
                                SalaryLine."Tax Paid on Second Account";

        // FirstTaxAccAdjustment();

    end;

    [Scope('Internal')]
    procedure FirstTaxAccAdjustment()
    var
        SalaryLedgEntry: Record "33020520";
    begin
        PRSetup.GET;
        IF DATE2DMY(SalaryHeader."To Date", 2) = DATE2DMY(PRSetup."Payroll Fiscal Year End Date", 2) THEN BEGIN
            Employee1.RESET;
            Employee1.SETRANGE("No.", SalaryLine."Employee No.");
            Employee1.SETFILTER("Payroll Period Filter", '%1..%2', PRSetup."Payroll Fiscal Year Start Date",
                               PRSetup."Payroll Fiscal Year End Date");
            Employee1.FINDFIRST;
            Employee1.CALCFIELDS("Tax on First Account");
            TaxSetupLine.RESET;
            TaxSetupLine.SETRANGE(Code, Employee1."Tax Code");
            IF TaxSetupLine.FINDFIRST THEN BEGIN
                taxsetupheader3.RESET;
                taxsetupheader3.SETRANGE(Code, TaxSetupLine.Code);
                taxsetupheader3.FINDFIRST;
                CheckAmt := (((TaxSetupLine."End Amount" - TaxSetupLine."Start Amount") + 1) * (TaxSetupLine."Tax Rate" / 100))
                            * (100 - taxsetupheader3."Special Tax Exempt %") / 100;
                AdjTaxDiff := ((TaxSetupLine."End Amount" - TaxSetupLine."Start Amount") + 1);
                //MESSAGE('Check Amt---> '+FORMAT(CheckAmt));
                //MESSAGE('Check Amt2---> '+FORMAT(AdjTaxDiff));
            END;

            //MESSAGE('Check Amt3---> '+FORMAT(Employee1."Tax on First Account"+ SalaryLine."Tax Paid on First Account"));
            //MESSAGE('Check Amt4---> '+FORMAT(SalaryLine."Taxable Income"));

            IF AdjTaxDiff >= SalaryLine."Taxable Income" THEN BEGIN
                taxsetupheader2.RESET;
                taxsetupheader2.SETRANGE(Code, Employee1."Tax Code");
                taxsetupheader2.FINDFIRST;
                IF taxsetupheader2."Special Tax Exempt %" <> 0 THEN
                    AnnualSST :=
                    (SalaryLine."Taxable Income" * TaxSetupLine."Tax Rate" / 100) * ((100 - taxsetupheader2."Special Tax Exempt %") / 100);
                IF taxsetupheader2."Special Tax Exempt %" = 0 THEN
                    AnnualSST := SalaryLine."Taxable Income" * TaxSetupLine."Tax Rate" / 100;

                //MESSAGE('AnnualSST---> '+FORMAT(AnnualSST));

                SalaryLine."Tax Exceeding First Slab" :=
                 ROUND(((Employee1."Tax on First Account" + SalaryLine."Tax Paid on First Account") - AnnualSST), 0.01, '=');
            END;

            //MESSAGE('Check Amt5---> '+FORMAT(AnnualSST));
            //MESSAGE('Check Amt6.1---> '+FORMAT(SalaryLine."Tax Exceeding First Slab"));

            IF AdjTaxDiff < SalaryLine."Taxable Income" THEN
                SalaryLine."Tax Exceeding First Slab" :=
                 ROUND(((Employee1."Tax on First Account" + SalaryLine."Tax Paid on First Account") - CheckAmt), 0.01, '=');
            //MESSAGE('Check Amt6.2---> '+FORMAT(SalaryLine."Tax Exceeding First Slab"));
            /*
                 Commented for IRGCMP1.00
               IF SalaryLine."Tax Exceeding First Slab" <> 0 THEN BEGIN
                  SalaryLine."Tax Paid on First Account" -= ROUND(SalaryLine."Tax Exceeding First Slab",0.01,'=');
                  SalaryLine."Tax Paid on Second Account" += ROUND(SalaryLine."Tax Exceeding First Slab",0.01,'=');
               END;
             */
            //chandra
            /*IF SalaryLine."Tax Paid on First Account"<=0 THEN
               SalaryLine."Tax Paid on First Account" :=0; */

            /*IF SalaryLine."Tax Paid on Second Account"<=0 THEN
               SalaryLine."Tax Paid on Second Account" :=0; */
            //chandra

        END;

        SalaryLine."Net Pay" := SalaryLine."Total Benefit" - SalaryLine."Total Deduction" - SalaryLine."Tax Paid on First Account" -
                                SalaryLine."Tax Paid on Second Account";

    end;

    [Scope('Internal')]
    procedure Recaltaxsplitforextacases()
    begin
        IF NOT SalaryHeader."Irregular Process" THEN BEGIN
            PRSetup.GET;
            Employee2.RESET;
            Employee2.SETRANGE("No.", SalaryLine."Employee No.");
            Employee2.SETFILTER("Payroll Period Filter", '%1..%2', PRSetup."Payroll Fiscal Year Start Date",
                                 PRSetup."Payroll Fiscal Year End Date");
            Employee2.FINDFIRST;
            Employee2.CALCFIELDS("Tax on First Account");
            taxsetupline2.RESET;
            taxsetupline2.SETRANGE(Code, Employee1."Tax Code");
            IF taxsetupline2.FINDFIRST THEN BEGIN
                taxrate1 := taxsetupline2."Tax Rate";
                CheckAmt1 := ((taxsetupline2."End Amount" - taxsetupline2."Start Amount") + 1) * (taxsetupline2."Tax Rate" / 100);
                //  message('chkamt---> '+format(CheckAmt1));
                // AdjTaxDiff1 := ((TaxSetupLine2."End Amount" - TaxSetupLine2."Start Amount") + 1);
            END;

            // >>>adjust tax paid on first a/c, where tax paid on first account is greater than 208.33 (e.g. employee joined within fiscal year)

            IF SalaryLine."Last Slab (%)" = taxrate1 THEN BEGIN
                // message('tax rate1--->'+format(taxrate1));
                SalaryLine."Tax Paid on First Account" := SalaryLine."Tax for Period";
                SalaryLine."Tax Paid on Second Account" := SalaryLine."Tax for Period" - SalaryLine."Tax Paid on First Account";

                SalaryLine."Net Pay" := SalaryLine."Total Benefit" - SalaryLine."Total Deduction" - SalaryLine."Tax Paid on First Account" -
                                        SalaryLine."Tax Paid on Second Account";

                // message('tax1.1---> '+format(SalaryLine."Tax Paid on First Account"));
                // message('tax1.2---> '+format(+SalaryLine."Tax Paid on Second Account"));
            END;

            // >>>adjust tax paid on first account, where tax paid on first account exceeds 2500 because of irregular salary plan process

            // message('chkamt1---> '+format(CheckAmt1));
            // message('tax1forecast---> '+format((Employee2."Tax on First Account"+SalaryLine."Tax Paid on First Account")));

            /* IF (Employee2."Tax on First Account"+SalaryLine."Tax Paid on First Account") > CheckAmt1 THEN BEGIN
                SalaryLine."Tax Exceeding First Slab" :=
                    ROUND(((Employee2."Tax on First Account"+SalaryLine."Tax Paid on First Account") - CheckAmt1),0.01,'=');
                IF SalaryLine."Tax Exceeding First Slab" <> 0 THEN BEGIN
                   SalaryLine."Tax Paid on First Account" -= ROUND(SalaryLine."Tax Exceeding First Slab",0.01,'=');
                   SalaryLine."Tax Paid on Second Account" += ROUND(SalaryLine."Tax Exceeding First Slab",0.01,'=');
                END;

                IF SalaryLine."Tax Paid on First Account"<=0 THEN
                   SalaryLine."Tax Paid on First Account" :=0;

                IF SalaryLine."Tax Paid on Second Account"<=0 THEN
                   SalaryLine."Tax Paid on Second Account" :=0;

             SalaryLine."Net Pay" := SalaryLine."Total Benefit" - SalaryLine."Total Deduction" - SalaryLine."Tax Paid on First Account" -
                                                                                     SalaryLine."Tax Paid on Second Account";
             // message('tax1exceed---> '+format(SalaryLine."Tax Exceeding First Slab"));
             // message('tax2.1---> '+format(SalaryLine."Tax Paid on First Account"));
             // message('tax2.2---> '+format(+SalaryLine."Tax Paid on Second Account"));
             END; */
        END;

    end;

    local procedure PerformTaxCalculation(var SalaryLine: Record "33020511")
    var
        SumOfTax: Decimal;
        RetirementFundExceed: Decimal;
        InsuranceAmountExact: Decimal;
        InsuranceAmount: Decimal;
        DonationAmount: Decimal;
        DonationLimit1: Decimal;
        DonationLimit2: Decimal;
        DonationAmount2: Decimal;
        SalaryLedgEntry: Record "33020520";
        TaxPaid: Decimal;
        PGSetup: Record "33020507";
        Employee: Record "5200";
    begin
        //FOR REGULAR PROCESS>>>START
        PGSetup.GET();
        IF Employee.GET(SalaryLine."Employee No.") THEN
            MedicalTax := Employee."Amount of Medical Tax" * PGSetup."Tax Ex. Amt(%) Med. Tax Credit" / 100;
        IF PGSetup."Tax Ex. Amt.  Med. Tax Credit" > MedicalTax THEN
            MedicalTaxExact := MedicalTax
        ELSE
            MedicalTaxExact := PGSetup."Tax Ex. Amt.  Med. Tax Credit";
        SumOfTax := 0;
        TaxSetupLine.RESET;
        TaxSetupLine.SETRANGE(Code, TaxSetupHeader.Code);
        IF TaxSetupLine.FINDSET THEN
            REPEAT
                IF RemainingAmount > 0 THEN BEGIN
                    TaxSetupLine.TESTFIELD("Tax Rate");
                    SumOfTax += GetTax(TaxSetupLine."Start Amount", TaxSetupLine."End Amount") * TaxSetupLine."Tax Rate" / 100.0;

                    IF NOT SalaryHeader."Irregular Process" THEN BEGIN
                        IF TaxLedgerEntry.FINDLAST THEN
                            TaxLedgerEntry."Entry No." := TaxLedgerEntry."Entry No." + 1
                        ELSE
                            TaxLedgerEntry."Entry No." := 1;
                        TaxLedgerEntry.INIT;
                        TaxLedgerEntry."Employee No." := SalaryLine."Employee No.";
                        TaxLedgerEntry."Tax Start Amount" := TaxSetupLine."Start Amount";
                        IF TaxSetupLine."End Amount" > RemainingAmtTaxLedger THEN
                            TaxLedgerEntry."Tax End Amount" := RemainingAmtTaxLedger
                        ELSE
                            TaxLedgerEntry."Tax End Amount" := TaxSetupLine."End Amount";
                        TaxLedgerEntry."Tax Rate" := TaxSetupLine."Tax Rate";
                        TaxLedgerEntry.Difference := (TaxLedgerEntry."Tax End Amount" - TaxSetupLine."Start Amount") + 1;
                        TaxLedgerEntry."Percent Calculation" := TaxLedgerEntry.Difference * (TaxLedgerEntry."Tax Rate" / 100);
                        TaxLedgerEntry."Sum of Tax" := SumOfTax;
                        TaxLedgerEntry."Monthly Tax" := SalaryLine."Tax for Period";
                        TaxLedgerEntry."Created Date" := WORKDATE;
                        TaxLedgerEntry."Document No." := SalaryLine."Document No.";
                        TaxLedgerEntry."Tax Setup End Amt" := TaxSetupLine."End Amount";
                        Taxledgerentry1.RESET;
                        Taxledgerentry1.SETRANGE("Employee No.", TaxLedgerEntry."Employee No.");
                        Taxledgerentry1.SETRANGE("Tax Rate", TaxLedgerEntry."Tax Rate");
                        Taxledgerentry1.SETRANGE("Document No.", TaxLedgerEntry."Document No.");
                        //Taxledgerentry1.SETRANGE("Created Date",TaxLedgerEntry."Created Date");
                        IF Taxledgerentry1.FINDFIRST THEN BEGIN
                            Taxledgerentry1."Tax Start Amount" := TaxSetupLine."Start Amount";
                            IF TaxSetupLine."End Amount" > RemainingAmtTaxLedger THEN
                                Taxledgerentry1."Tax End Amount" := RemainingAmtTaxLedger
                            ELSE
                                Taxledgerentry1."Tax End Amount" := TaxSetupLine."End Amount";
                            Taxledgerentry1."Tax Rate" := TaxSetupLine."Tax Rate";
                            Taxledgerentry1.Difference := (Taxledgerentry1."Tax End Amount" - TaxSetupLine."Start Amount") + 1;
                            Taxledgerentry1."Percent Calculation" := Taxledgerentry1.Difference * (Taxledgerentry1."Tax Rate" / 100);
                            Taxledgerentry1."Sum of Tax" := SumOfTax;
                            Taxledgerentry1."Monthly Tax" := SalaryLine."Tax for Period";
                            // MESSAGE('tax ledger tax>>'+FORMAT(Taxledgerentry1."Monthly Tax"));
                            Taxledgerentry1."Tax Setup End Amt" := TaxSetupLine."End Amount";
                            Taxledgerentry1."Created Date" := WORKDATE;
                            Taxledgerentry1.MODIFY;
                        END ELSE
                            TaxLedgerEntry.INSERT(TRUE);

                        DelTaxLed.RESET;
                        DelTaxLed.SETRANGE("Employee No.", SalaryLine."Employee No.");
                        DelTaxLed.SETRANGE("Document No.", SalaryLine."Document No.");
                        IF DelTaxLed.FINDFIRST THEN BEGIN
                            REPEAT
                                IF DelTaxLed."Tax End Amount" < DelTaxLed."Tax Setup End Amt" THEN BEGIN
                                    // MESSAGE('tax '+FORMAT(DelTaxLed."Tax End Amount"));
                                    TaxEntryNo := DelTaxLed."Entry No.";
                                    TaxLedDeleted.RESET;
                                    TaxLedDeleted.SETRANGE("Employee No.", SalaryLine."Employee No.");
                                    TaxLedDeleted.SETRANGE("Document No.", SalaryLine."Document No.");
                                    TaxLedDeleted.SETFILTER("Entry No.", '>%1', TaxEntryNo);
                                    IF TaxLedDeleted.FINDFIRST THEN
                                        TaxLedDeleted.DELETE;
                                END;
                            UNTIL DelTaxLed.NEXT = 0;
                        END;
                    END;

                    IF NOT SalaryHeader."Irregular Process" THEN
                        SalaryLine."Last Slab (%)" := TaxSetupLine."Tax Rate";
                END;
            UNTIL (TaxSetupLine.NEXT = 0);

        SalaryLine."Total Tax Credit" := TotalTaxCredit;
        IF NOT SalaryHeader."Irregular Process" THEN BEGIN
            IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN
                SumOfTax := (SumOfTax - ((SumOfTax * TaxSetupHeader."Special Tax Exempt %") / 100));

            SumOfTax := SumOfTax - TotalTaxPaid; //OG
                                                 //  SumOfTax := ((SumOfTax )- (TotalTaxPaid+MedicalTaxExact)); //nilesh
                                                 //MESSAGE('Tax excluding Paid'+FORMAT(SumOfTax));

            IF SumOfTax > TotalTaxCredit THEN
                SumOfTax -= TotalTaxCredit
            ELSE
                SumOfTax := 0;
            IF SumOfTax <> 0 THEN
                SumOfTax -= MedicalTaxExact;
            SalaryLine."Tax for Period" := ROUND(SumOfTax / RemainingMonth, 0.01, '=');
        END

        //FOR REGULAR PROCESS>>>END

        //FOR IRREGULAR PROCESS>>>START

        ELSE BEGIN
            SalaryLine."Taxable Income" := SalaryLine."Total Benefit";
            SalaryLedgEntry.RESET;
            SalaryLedgEntry.SETCURRENTKEY("Employee Code", "Fiscal Year From", "Fiscal Year To");
            SalaryLedgEntry.SETRANGE("Employee Code", Employee."No.");
            SalaryLedgEntry.SETRANGE("Fiscal Year From", PRSetup."Payroll Fiscal Year Start Date");
            SalaryLedgEntry.SETRANGE("Fiscal Year To", PRSetup."Payroll Fiscal Year End Date");
            SalaryLedgEntry.SETRANGE("Irregular Process", FALSE);
            SalaryLedgEntry.SETRANGE(Reversed, FALSE);
            IF SalaryLedgEntry.FINDLAST THEN BEGIN
                IF SalaryLine."Taxable Income" <= SalaryLedgEntry."Remaining Amount to Cross Slab" THEN BEGIN
                    SalaryLine."Tax for Period" := ROUND((SalaryLine."Taxable Income" * SalaryLedgEntry."Last Slab (%)" / 100), 0.01, '=');
                    SalaryLine."Last Slab (%)" := SalaryLedgEntry."Last Slab (%)"; //PRM7.1.1
                    SalaryLine."Remaining Amount to Cross Slab" := SalaryLedgEntry."Remaining Amount to Cross Slab" - SalaryLine."Taxable Income";
                    //PRM7.1.1
                    //ER Addition of Code which was at the end
                    IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN BEGIN
                        SalaryLine.VALIDATE("Tax for Period", ROUND(((SalaryLine."Tax for Period" -
                              (SalaryLine."Tax for Period" * TaxSetupHeader."Special Tax Exempt %") / 100)), 0.01, '='));
                    END;
                    IF SalaryLine."Tax for Period" > TotalTaxCredit THEN
                        SalaryLine."Tax for Period" -= TotalTaxCredit
                    ELSE
                        SalaryLine."Tax for Period" := 0;
                    //ER Addition of Code which was at the end
                    //***SM Tax split for irregular salary plan
                    EmpIrregularTax.RESET;
                    EmpIrregularTax.SETRANGE("No.", SalaryLine."Employee No.");
                    EmpIrregularTax.FINDFIRST;

                    TaxSetupIrregular.RESET;
                    TaxSetupIrregular.SETRANGE(Code, EmpIrregularTax."Tax Code");
                    TaxSetupIrregular.FINDFIRST;

                    IF TaxSetupIrregular."Tax Rate" = SalaryLedgEntry."Last Slab (%)" THEN
                        SalaryLine."Tax Paid on First Account" := ROUND(SalaryLine."Tax for Period", 0.01, '=')
                    ELSE
                        SalaryLine."Tax Paid on Second Account" := ROUND(SalaryLine."Tax for Period", 0.01, '=');
                    //MESSAGE('Case 1 Tax for period' +FORMAT(SalaryLine."Tax for Period"));
                    //MESSAGE('Case 1 1st acc' +FORMAT(SalaryLine."Tax Paid on First Account"));
                    //MESSAGE('Case 1 2nd acc' +FORMAT(SalaryLine."Tax Paid on Second Account"));
                    //***SM Tax split for irregular salary plan
                END
                ELSE BEGIN
                    SalaryLine."Tax for Period" :=
                      ROUND((SalaryLedgEntry."Remaining Amount to Cross Slab" * SalaryLedgEntry."Last Slab (%)" / 100), 0.01, '=');
                    //ER Addition of Code which was at the end
                    IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN BEGIN
                        SalaryLine.VALIDATE("Tax for Period", ROUND(((SalaryLine."Tax for Period" -
                              (SalaryLine."Tax for Period" * TaxSetupHeader."Special Tax Exempt %") / 100)), 0.01, '='));
                    END;
                    IF SalaryLine."Tax for Period" > TotalTaxCredit THEN
                        SalaryLine."Tax for Period" -= TotalTaxCredit
                    ELSE
                        SalaryLine."Tax for Period" := 0;

                    //ER Addition of Code which was at the end
                    //***SM 02 June 2014
                    EmpIrregularTax.RESET;
                    EmpIrregularTax.SETRANGE("No.", SalaryLine."Employee No.");
                    EmpIrregularTax.FINDFIRST;

                    TaxSetupIrregular.RESET;
                    TaxSetupIrregular.SETRANGE(Code, EmpIrregularTax."Tax Code");
                    TaxSetupIrregular.FINDFIRST;

                    IF TaxSetupIrregular."Tax Rate" = SalaryLedgEntry."Last Slab (%)" THEN
                        SalaryLine."Tax Paid on First Account" := ROUND(SalaryLine."Tax for Period", 0.01, '=')
                    ELSE
                        SalaryLine."Tax Paid on Second Account" := ROUND(SalaryLine."Tax for Period", 0.01, '=');

                    //MESSAGE('Case 2 1st acc' +FORMAT(SalaryLine."Tax Paid on First Account"));
                    //MESSAGE('Case 2 2nd acc' +FORMAT(SalaryLine."Tax Paid on Second Account"));

                    //***SM 02 June 2014
                    RemainingAmount := SalaryLine."Taxable Income" - SalaryLedgEntry."Remaining Amount to Cross Slab";
                    //MESSAGE(FORMAT(RemainingAmount));
                    TaxSetupLine.SETRANGE("Tax Rate", SalaryLedgEntry."Last Slab (%)");
                    TaxSetupLine.FINDFIRST;
                    TaxSetupLine.SETRANGE("Tax Rate");
                    IF TaxSetupLine.NEXT = 0 THEN BEGIN
                        SalaryLine."Tax for Period" += RemainingAmount * SalaryLedgEntry."Last Slab (%)" / 100;
                        //ER Addition of Code which was at the end
                        IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN BEGIN
                            SalaryLine.VALIDATE("Tax for Period", ROUND(((SalaryLine."Tax for Period" -
                                  (SalaryLine."Tax for Period" * TaxSetupHeader."Special Tax Exempt %") / 100)), 0.01, '='));
                        END;
                        IF SalaryLine."Tax for Period" > TotalTaxCredit THEN
                            SalaryLine."Tax for Period" -= TotalTaxCredit
                        ELSE
                            SalaryLine."Tax for Period" := 0;
                        //ER Addition of Code which was at the end

                        //***SM 02 June 2014
                        SalaryLine."Tax Paid on Second Account" :=
                              ROUND((SalaryLine."Tax for Period" - SalaryLine."Tax Paid on First Account"), 0.01, '=');
                        //MESSAGE('Case 3 1st acc' +FORMAT(SalaryLine."Tax Paid on First Account"));
                        //MESSAGE('Case 3 2nd acc' +FORMAT(SalaryLine."Tax Paid on Second Account"));
                        //***SM 02 June 2014
                    END ELSE BEGIN
                        //ER
                        TaxPaid := RemainingAmount * TaxSetupLine."Tax Rate" / 100;
                        //ER Addition of Code which was at the end
                        IF TaxSetupHeader."Special Tax Exempt %" <> 0 THEN BEGIN
                            TaxPaid := ROUND(((TaxPaid - (TaxPaid * TaxSetupHeader."Special Tax Exempt %") / 100)), 0.01, '=')
                        END;
                        IF TaxPaid > TotalTaxCredit THEN
                            TaxPaid -= TotalTaxCredit
                        ELSE
                            TaxPaid := 0;
                        //ER Addition of Code which was at the end
                        SalaryLine."Tax for Period" += TaxPaid;
                        SalaryLine."Remaining Amount to Cross Slab" := TaxSetupLine."End Amount" - TaxSetupLine."Start Amount" - RemainingAmount;
                        //PRM7.1.1
                        SalaryLine."Tax for Period" := ROUND(SalaryLine."Tax for Period", 0.01, '=');
                        SalaryLine."Last Slab (%)" := TaxSetupLine."Tax Rate"; //PRM7.1.1
                                                                               //***SM 02 June 2014
                        IF SalaryLine."Tax for Period" > 0 THEN
                            SalaryLine."Tax for Period" -= MedicalTaxExact;
                        SalaryLine."Tax Paid on Second Account" :=
                              ROUND((SalaryLine."Tax for Period" - SalaryLine."Tax Paid on First Account"), 0.01, '=');
                        //MESSAGE('Case 4 remaining amount' +FORMAT(RemainingAmount));
                        //MESSAGE('Case 4 tax paid' +FORMAT(TaxPaid));
                        //MESSAGE('Case 4 tax rate' +FORMAT(TaxSetupLine."Tax Rate"));
                        //MESSAGE('Case 4 tax for the period' +FORMAT(SalaryLine."Tax for Period"));
                        //MESSAGE('Case 4 1st acc' +FORMAT(SalaryLine."Tax Paid on First Account"));
                        //MESSAGE('Case 4 2nd acc' +FORMAT(SalaryLine."Tax Paid on Second Account"));
                        //***SM 02 June 2014
                    END;
                END;
            END;
        END;

        //FOR IRREGULAR PROCESS>>>END
    end;

    [Scope('Internal')]
    procedure EvaluateAndCalculateIrregularComponent(SalaryLine: Record "33020511"): Decimal
    var
        i: Integer;
        VFieldID: Integer;
        ComponentID: Code[20];
        IrregularComponentSum: Decimal;
        Component: Record "33020503";
    begin
        CLEAR(IrregularComponentSum);
        VFUsage.RESET;
        VFUsage.SETCURRENTKEY("Table No.", "Variable Field Code");
        VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
        //    VFUsage.SETRANGE("Variable Field Code",IDValue);

        IF VFUsage.FINDFIRST THEN
            REPEAT
                PayrollComponent.RESET;
                PayrollComponent.GET(VFUsage."Variable Field Code");
                IF PayrollComponent."Current Month Tax Application" THEN BEGIN
                    CASE FORMAT(VFUsage."Field No.") OF
                        '33020500':
                            BEGIN
                                IrregularComponentSum += SalaryLine."Variable Field 33020500";
                            END;
                        '33020501':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020501");
                            END;
                        '33020502':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020502");
                            END;
                        '33020503':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020503");
                            END;
                        '33020504':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020504");
                            END;
                        '33020505':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020505");
                            END;
                        '33020506':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020506");
                            END;
                        '33020507':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020507");
                            END;
                        '33020508':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020508");
                            END;
                        '33020509':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020509");
                            END;
                        '33020510':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020510");
                            END;
                        '33020511':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020511");
                            END;
                        '33020512':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020512");
                            END;
                        '33020513':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020513");
                            END;
                        '33020514':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020514");
                            END;
                        '33020515':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020515");
                            END;
                        '33020516':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020516");
                            END;
                        '33020517':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020517");
                            END;
                        '33020518':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020518");
                            END;
                        '33020519':
                            BEGIN
                                IrregularComponentSum += (SalaryLine."Variable Field 33020519");
                            END;
                    END;
                END;
            UNTIL VFUsage.NEXT = 0;

        EXIT(IrregularComponentSum);
    end;

    local procedure CalcRemainingMonth()
    var
        YearDifference: Integer;
    begin
        YearDifference := (DATE2DMY(SalaryHeader."From Date", 3) - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 3));
        IF Employee."Last Working Day" = 0D THEN BEGIN
            RemainingMonth := 12 -
                             ((DATE2DMY(SalaryHeader."From Date", 2) + YearDifference * 12)
                              - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2));
        END
        ELSE BEGIN
            IF (DATE2DMY(Employee."Last Working Day", 2) IN [1, 2, 3, 4, 5, 6, 7]) THEN
                RemainingMonth := (12 + DATE2DMY(Employee."Last Working Day", 2) - (DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2))) -
                               ((DATE2DMY(SalaryHeader."From Date", 2) + YearDifference * 12)
                                - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2))
            ELSE
                RemainingMonth := (DATE2DMY(Employee."Last Working Day", 2) - (DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2))) -
                               ((DATE2DMY(SalaryHeader."From Date", 2) + YearDifference * 12)
                                - DATE2DMY(PRSetup."Payroll Fiscal Year Start Date", 2));
        END;
    end;

    [Scope('Internal')]
    procedure EncashLeave(EmpCode: Code[20]; EncashType: Option " ","Year End Encash",Resignation)
    var
        Emp: Record "5200";
        LeaveAccount: Record "33020370";
        LeaveEncashLedger: Record "33020529";
        EngNep: Record "33020302";
    begin
        EngNep.RESET;
        EngNep.SETRANGE("English Date", TODAY);
        EngNep.FINDFIRST;

        LeaveAccount.RESET;
        IF EmpCode <> '' THEN
            LeaveAccount.SETRANGE("Employee Code", EmpCode);
        LeaveAccount.SETRANGE("Leave Type", 'HL');
        LeaveAccount.SETFILTER("Balance Days", '>0');
        LeaveAccount.SETFILTER("Earned Days", '>90');
        IF LeaveAccount.FINDFIRST THEN
            REPEAT
                CLEAR(LeaveEncashLedger);
                LeaveEncashLedger.INIT;
                LeaveEncashLedger."Employee No." := LeaveAccount."Employee Code";
                LeaveEncashLedger."Leave Code" := LeaveAccount."Leave Type";
                LeaveEncashLedger."Register Date" := TODAY;
                LeaveEncashLedger."Encash Source" := LeaveEncashLedger."Encash Source"::"Year End Encash";
                IF EmpCode <> '' THEN
                    LeaveEncashLedger."Encash Source" := EncashType;
                LeaveEncashLedger."User Id" := USERID;
                LeaveEncashLedger.Days := LeaveAccount."Balance Days";
                LeaveEncashLedger."Fiscal Year" := EngNep."Fiscal Year";
                LeaveEncashLedger.INSERT(TRUE);
                LeaveAccount."Balance Days" := 0;
                LeaveAccount.MODIFY;
            UNTIL LeaveAccount.NEXT = 0;

        CLEAR(LeaveAccount);
        LeaveAccount.RESET;
        IF EmpCode <> '' THEN
            LeaveAccount.SETRANGE("Employee Code", EmpCode);
        LeaveAccount.SETRANGE("Leave Type", 'SC');
        LeaveAccount.SETFILTER("Balance Days", '>0');
        LeaveAccount.SETFILTER("Earned Days", '>45');
        IF LeaveAccount.FINDFIRST THEN
            REPEAT
                CLEAR(LeaveEncashLedger);
                LeaveEncashLedger.INIT;
                LeaveEncashLedger."Employee No." := LeaveAccount."Employee Code";
                LeaveEncashLedger."Leave Code" := LeaveAccount."Leave Type";
                LeaveEncashLedger."Register Date" := TODAY;
                LeaveEncashLedger."Encash Source" := LeaveEncashLedger."Encash Source"::"Year End Encash";
                IF EmpCode <> '' THEN
                    LeaveEncashLedger."Encash Source" := EncashType;
                LeaveEncashLedger."User Id" := USERID;
                LeaveEncashLedger.Days := LeaveAccount."Balance Days";
                LeaveEncashLedger."Fiscal Year" := EngNep."Fiscal Year";
                LeaveEncashLedger.INSERT(TRUE);
                LeaveAccount."Balance Days" := 0;
                LeaveAccount.MODIFY;
            UNTIL LeaveAccount.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetLeaveEncashAmount(var PSalaryLine: Record "33020511"; BasicAmt: Decimal)
    var
        LeaveEncashLedger: Record "33020529";
        LPayrollComponentUsage: Record "33020504";
        PayrollComponentUsage1: Record "33020504";
        PGSetup: Record "33020507";
    begin
        LeaveEncashLedger.RESET;
        LeaveEncashLedger.SETRANGE("Employee No.", PSalaryLine."Employee No.");
        LeaveEncashLedger.CALCSUMS(Days);

        PGSetup.GET;
        IF LeaveEncashLedger.Days > 0 THEN
            PGSetup.TESTFIELD("leave Encash Component");
        LPayrollComponentUsage.RESET;
        LPayrollComponentUsage.SETRANGE("Employee No.", PSalaryLine."Employee No.");
        LPayrollComponentUsage.SETRANGE("Payroll Component Code", PGSetup."leave Encash Component");
        IF NOT LPayrollComponentUsage.FINDFIRST THEN BEGIN
            CLEAR(PayrollComponentUsage1);
            PayrollComponentUsage1.INIT;
            PayrollComponentUsage1.VALIDATE("Employee No.", PSalaryLine."Employee No.");
            PayrollComponentUsage1.VALIDATE("Payroll Component Code", PGSetup."leave Encash Component");
            PayrollComponentUsage1.VALIDATE(Amount, ROUND(LeaveEncashLedger.Days * BasicAmt / 30, 0.01, '='));
            PayrollComponentUsage1.INSERT(TRUE);
        END
        ELSE BEGIN
            LPayrollComponentUsage.Amount := ROUND(LeaveEncashLedger.Days * BasicAmt / 30, 0.01, '=');
            LPayrollComponentUsage.MODIFY(TRUE);
        END;

        PSalaryLine."Leave Encash Days" := LeaveEncashLedger.Days;
        //PSalaryLine."Variable Field 33020517" := ROUND(LeaveEncashLedger.Days * BasicAmt / 30,0.01,'=');
    end;
}

