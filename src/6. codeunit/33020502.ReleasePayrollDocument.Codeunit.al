codeunit 33020502 "Release Payroll Document"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    TableNo = 33020510;

    trigger OnRun()
    begin
        IF Rec.Status = Rec.Status::Released THEN
            EXIT;
        Rec.TESTFIELD("From Date");
        Rec.TESTFIELD("To Date");
        Rec.TESTFIELD(Month);
        Rec.TESTFIELD("Global Dimension 1 Code");
        Rec.TESTFIELD("Global Dimension 2 Code");
        Rec.TESTFIELD("Accountability Center");
        Checklines(Rec);
        SalCrAssign.RESET;
        SalCrAssign.SETRANGE("Salary Header No.", Rec."No.");
        IF SalCrAssign.FINDSET THEN BEGIN
            REPEAT
                SalCrAssign.TESTFIELD(Code);
                SalCrAssign.TESTFIELD("Global Dimension 1 Code");
                SalCrAssign.TESTFIELD("Global Dimension 2 Code");
                SalCrAssign.TESTFIELD(Amount);
            UNTIL SalCrAssign.NEXT = 0;
        END
        ELSE
            ERROR(Text000, Rec."No.");
        SalCrAssign.CALCFIELDS("Total Assigned");
        Rec.CALCFIELDS("Salary in Hand");
        IF ROUND(Rec."Salary in Hand", 0.01, '>') <> ROUND(SalCrAssign."Total Assigned", 0.01, '>') THEN BEGIN
            DiffAmount := ROUND(Rec."Salary in Hand", 0.01, '>') - ROUND(SalCrAssign."Total Assigned", 0.01, '>');
            ERROR(Text001, Rec."No.", DiffAmount);
        END;
        Rec.Status := Rec.Status::Released;
        Rec.MODIFY(TRUE);
    end;

    var
        SalCrAssign: Record "33020514";
        Text000: Label 'Credit must be allocated for Salary Plan %1.';
        Text001: Label 'Sum of Credit Allocation must be equal to Total Salary Calculation for Salary Plan %1. Difference in Amout is %2';
        Text002: Label '%1 cannot be negative for Employee %2. Please adjust the line before posting.';
        Text003: Label 'Salary for Employee %1 has already been processed for the date (%2 - %3).';
        DiffAmount: Decimal;

    [Scope('Internal')]
    procedure Reopen(var SalaryHeader: Record "33020510")
    var
        SalaryLine: Record "37";
    begin
        IF SalaryHeader.Status = SalaryHeader.Status::Open THEN
            EXIT;
        SalaryHeader.Status := SalaryHeader.Status::Open;
        //Check Data Here
        SalaryHeader.MODIFY(TRUE);
    end;

    [Scope('Internal')]
    procedure PerformManualRelease(var SalaryHeader: Record "33020510")
    var
        ApprovalEntry: Record "454";
        ApprovedOnly: Boolean;
    begin
        //ApprovalTest Code Here
        CODEUNIT.RUN(33020502, SalaryHeader);
    end;

    [Scope('Internal')]
    procedure PerformManualReopen(var SalaryHeader: Record "33020510")
    begin
        //ApprovalTest Code Here
        Reopen(SalaryHeader);
    end;

    [Scope('Internal')]
    procedure Checklines(SalaryHeader: Record "33020510")
    var
        SalaryLine: Record "33020511";
    begin
        SalaryLine.RESET;
        SalaryLine.SETRANGE("Document No.", SalaryHeader."No.");
        //SalaryLine.SETFILTER("Employee No.",'<>%1','');
        IF SalaryLine.FINDSET THEN BEGIN
            IF SalaryLine."Net Pay" < 0 THEN
                ERROR(Text002, SalaryLine.FIELDCAPTION("Net Pay"), SalaryLine."Employee No.");
            IF SalaryLine."Tax for Period" < 0 THEN
                ERROR(Text002, SalaryLine.FIELDCAPTION("Tax for Period"), SalaryLine."Employee No.");
            IF (DocExists(SalaryHeader, SalaryLine."Employee No.")) AND (NOT "Irregular Process") THEN
                ERROR(Text003, SalaryLine."Employee No.", SalaryHeader."From Date", SalaryHeader."To Date");

        END;
    end;

    [Scope('Internal')]
    procedure DocExists(SalaryHeader: Record "33020510"; EmpCode: Code[20]): Boolean
    var
        SalaryLedgEntry: Record "33020520";
    begin
        SalaryLedgEntry.RESET;
        SalaryLedgEntry.SETCURRENTKEY("Employee Code", "Salary From", "Salary To");
        SalaryLedgEntry.SETRANGE("Employee Code", EmpCode);
        SalaryLedgEntry.SETRANGE("Salary From", SalaryHeader."From Date");
        SalaryLedgEntry.SETRANGE("Salary To", SalaryHeader."To Date");
        SalaryLedgEntry.SETRANGE(Reversed, FALSE);
        SalaryLedgEntry.SETRANGE("Irregular Process", FALSE); //chandra
        IF SalaryLedgEntry.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;
}

