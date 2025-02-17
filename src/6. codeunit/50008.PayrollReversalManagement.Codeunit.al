codeunit 50008 "Payroll Reversal Management"
{

    trigger OnRun()
    var
        SalesLine: Record "37";
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document No.", 'SNBSO80-01053');
        SalesLine.SETFILTER("Line No.", '%1', 690000);
        IF SalesLine.FINDSET THEN
            REPEAT
                //SalesLine.VALIDATE("Outstanding Quantity",0);
                //SalesLine.VALIDATE("Outstanding Qty. (Base)",0);
                //SalesLine.VALIDATE("Qty. Shipped Not Invoiced",1);
                //SalesLine.VALIDATE("Quantity Shipped",5);
                //SalesLine.VALIDATE("Qty. Shipped (Base)",5);
                //SalesLine.VALIDATE("Shipped Not Invoiced",6541.34);
                //SalesLine.VALIDATE("Shipped Not Invoiced (LCY)",6541.34);
                SalesLine.VALIDATE("Qty. Shipped Not Invd. (Base)", 5);
                //SalesLine.VALIDATE("Quantity Invoiced",5);
                SalesLine.VALIDATE("Qty. Invoiced (Base)", 5);
                //SalesLine.VALIDATE("Outstanding Amount (LCY)",0);
                //SalesLine.VALIDATE("Outstanding Amount",0);
                //SalesLine.VALIDATE("Qty. to Ship",0);
                //SalesLine.VALIDATE("Completely Shipped",TRUE);
                SalesLine.MODIFY;
            UNTIL SalesLine.NEXT = 0;
        MESSAGE('Done');
    end;

    var
        Text001: Label 'Do you really want to reverse the salary plan?';
        LineNo: Integer;
        LineCount: Integer;
        SalaryLedEntry: Record "33020520";
        EntryNo: Integer;
        PayGenSetup: Record "33020507";
        PSHdr: Record "33020512";
        GenJnlPostBatch: Codeunit "13";
        GenLineNo: Integer;
        NewLine: Integer;
        TotalBasic: Decimal;
        TotalTax: Decimal;
        TotalBalance: Decimal;
        TotalDeduction: Decimal;
        ActualBasic: Decimal;
        SourceCodeSetup: Record "242";
        SrcCode: Code[10];
        BalancingNewLine: Integer;
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        TextError: Label 'There is no Salary Ledger entry for Employee %1 with Document No. %2';

    [Scope('Internal')]
    procedure ReversePostedSalaryTotal(PostedSalaryNo: Code[20]; PostedJournalTemplate: Code[10]; PostedJournalBatch: Code[10])
    var
        PostedSalaryHdr: Record "33020512";
        PostedSalaryLine: Record "33020513";
        PostedSalaryLine1: Record "33020513";
        PostedSalaryLine2: Record "33020513";
        Text000: Label 'There is nothing to reverse.';
        SalaryLdrEntry: Record "33020520";
    begin
        IF Code THEN BEGIN
            PayGenSetup.GET;

            PostedSalaryLine2.RESET;
            PostedSalaryLine2.SETRANGE("Document No.", PostedSalaryNo);
            IF PostedSalaryLine2.FINDFIRST THEN
                LineCount := PostedSalaryLine2.COUNT;

            PostedSalaryLine2.RESET;
            PostedSalaryLine2.SETRANGE("Document No.", PostedSalaryNo);
            IF PostedSalaryLine2.FINDLAST THEN BEGIN
                LineNo := PostedSalaryLine2."Line No.";
            END;

            PostedSalaryHdr.RESET;
            PostedSalaryHdr.SETRANGE("No.", PostedSalaryNo);
            PostedSalaryHdr.SETRANGE(Reversed, FALSE);
            IF PostedSalaryHdr.FINDFIRST THEN BEGIN
                PostedSalaryLine.RESET;
                PostedSalaryLine.SETRANGE("Document No.", PostedSalaryHdr."No.");
                IF PostedSalaryLine.FINDFIRST THEN BEGIN
                    REPEAT
                        IF NOT CheckPostedSalaryPlan(PostedSalaryLine."Document No.", PostedSalaryLine."Employee No.", PostedSalaryLine."From Date",
                                                     PostedSalaryLine."To Date") THEN BEGIN

                            SalaryLdrEntry.RESET;
                            SalaryLdrEntry.SETRANGE("Employee Code", PostedSalaryLine."Employee No.");
                            SalaryLdrEntry.SETRANGE("Source No.", PostedSalaryLine."Document No.");
                            IF NOT SalaryLdrEntry.FINDFIRST THEN
                                ERROR(TextError, PostedSalaryLine."Employee No.", PostedSalaryLine."Document No.");
                            LineCount -= 1;
                            PostedSalaryLine1.INIT;
                            PostedSalaryLine1."Document No." := PostedSalaryNo;
                            PostedSalaryLine1."Employee No." := PostedSalaryLine."Employee No.";
                            PostedSalaryLine1."Line No." := LineNo + 10000;
                            LineNo := LineNo + 10000;
                            PostedSalaryLine1."Basic Salary" := -PostedSalaryLine."Basic Salary";
                            PostedSalaryLine1."Net Pay" := -PostedSalaryLine."Net Pay";
                            PostedSalaryLine1."Taxable Income" := -PostedSalaryLine."Taxable Income";
                            PostedSalaryLine1."Monthly Tax" := -PostedSalaryLine."Monthly Tax";
                            PostedSalaryLine1."Total Benefit" := -PostedSalaryLine."Total Benefit";
                            PostedSalaryLine1."Total Deduction" := -PostedSalaryLine."Total Deduction";
                            PostedSalaryLine1."Total Employer Contribution" := -PostedSalaryLine."Total Employer Contribution";
                            PostedSalaryLine1."Global Dimension 1 Code" := PostedSalaryLine."Global Dimension 1 Code";
                            PostedSalaryLine1."Global Dimension 2 Code" := PostedSalaryLine."Global Dimension 2 Code";
                            PostedSalaryLine1."Present Days" := -PostedSalaryLine."Present Days";
                            PostedSalaryLine1."Absent Days" := -PostedSalaryLine."Absent Days";
                            PostedSalaryLine1."Paid Days" := -PostedSalaryLine."Paid Days";
                            PostedSalaryLine1."Job Title" := PostedSalaryLine."Job Title";
                            PostedSalaryLine1."From Date" := PostedSalaryLine."From Date";
                            PostedSalaryLine1."To Date" := PostedSalaryLine."To Date";
                            PostedSalaryLine1.Month := PostedSalaryLine.Month;
                            PostedSalaryLine1."Last Slab (%)" := PostedSalaryLine."Last Slab (%)";
                            PostedSalaryLine1."Remaining Amount to Cross Slab" := -PostedSalaryLine."Remaining Amount to Cross Slab";
                            PostedSalaryLine1."Total Deduction" := -PostedSalaryLine."Total Deduction";
                            PostedSalaryLine1."Tax Paid on First Account" := -PostedSalaryLine."Tax Paid on First Account";
                            PostedSalaryLine1."Tax Paid on Second Account" := -PostedSalaryLine."Tax Paid on Second Account";
                            PostedSalaryLine1."Variable Field 33020500" := -PostedSalaryLine."Variable Field 33020500";
                            PostedSalaryLine1."Variable Field 33020501" := -PostedSalaryLine."Variable Field 33020501";
                            PostedSalaryLine1."Variable Field 33020502" := -PostedSalaryLine."Variable Field 33020502";
                            PostedSalaryLine1."Variable Field 33020503" := -PostedSalaryLine."Variable Field 33020503";
                            PostedSalaryLine1."Variable Field 33020504" := -PostedSalaryLine."Variable Field 33020504";
                            PostedSalaryLine1."Variable Field 33020505" := -PostedSalaryLine."Variable Field 33020505";
                            PostedSalaryLine1."Variable Field 33020506" := -PostedSalaryLine."Variable Field 33020506";
                            PostedSalaryLine1."Variable Field 33020507" := -PostedSalaryLine."Variable Field 33020507";
                            PostedSalaryLine1."Variable Field 33020508" := -PostedSalaryLine."Variable Field 33020508";
                            PostedSalaryLine1."Variable Field 33020509" := -PostedSalaryLine."Variable Field 33020509";
                            PostedSalaryLine1."Variable Field 33020510" := -PostedSalaryLine."Variable Field 33020510";
                            PostedSalaryLine1."Variable Field 33020511" := -PostedSalaryLine."Variable Field 33020511";
                            PostedSalaryLine1."Variable Field 33020512" := -PostedSalaryLine."Variable Field 33020512";
                            PostedSalaryLine1."Variable Field 33020513" := -PostedSalaryLine."Variable Field 33020513";
                            PostedSalaryLine1."Variable Field 33020514" := -PostedSalaryLine."Variable Field 33020514";
                            PostedSalaryLine1."Variable Field 33020515" := -PostedSalaryLine."Variable Field 33020515";
                            PostedSalaryLine1."Variable Field 33020516" := -PostedSalaryLine."Variable Field 33020516";
                            PostedSalaryLine1."Variable Field 33020517" := -PostedSalaryLine."Variable Field 33020517";
                            PostedSalaryLine1."Variable Field 33020518" := -PostedSalaryLine."Variable Field 33020518";
                            PostedSalaryLine1."Variable Field 33020519" := -PostedSalaryLine."Variable Field 33020519";
                            PostedSalaryLine1."Variable Field 33020520" := -PostedSalaryLine."Variable Field 33020520";
                            PostedSalaryLine1."Variable Field 33020521" := -PostedSalaryLine."Variable Field 33020521";
                            PostedSalaryLine1."Variable Field 33020522" := -PostedSalaryLine."Variable Field 33020522";
                            PostedSalaryLine1."Variable Field 33020523" := -PostedSalaryLine."Variable Field 33020523";
                            PostedSalaryLine1."Variable Field 33020524" := -PostedSalaryLine."Variable Field 33020524";
                            PostedSalaryLine1.Gratuity := -PostedSalaryLine.Gratuity;
                            PostedSalaryLine.Reversed := TRUE;
                            PostedSalaryLine.MODIFY;

                        END ELSE
                            ERROR('Salary for the employee no. %1 has been processed for the following month. Please reverse the following month' +
                                   ' salary for this reversal.', PostedSalaryLine."Employee No.");

                        PostedSalaryLine1.INSERT(TRUE);


                        CreateNegativeLedger(PostedSalaryLine."From Date", PostedSalaryLine."To Date", PayGenSetup."Payroll Fiscal Year Start Date",
                                             PayGenSetup."Payroll Fiscal Year End Date",
                                             PostedSalaryLine."Employee No.", PostedSalaryLine."Basic Salary", PostedSalaryLine."Monthly Tax",
                                             PostedSalaryLine."Document No."); //ER

                    UNTIL (PostedSalaryLine.NEXT = 0) OR (LineCount = 0);

                    CreateReverseJournal(PostedSalaryNo, PostedJournalTemplate, PostedJournalBatch);

                    PostedSalaryHdr.RESET;
                    PostedSalaryHdr.SETRANGE("No.", PostedSalaryNo);
                    IF PostedSalaryHdr.FINDFIRST THEN BEGIN
                        PostedSalaryHdr.Reversed := TRUE;
                        PostedSalaryHdr.MODIFY;
                    END;
                    // MESSAGE('The Reversal Journal Lines have been created. Please check and post the journal.');
                END ELSE
                    ERROR(Text000);
            END ELSE
                ERROR('This posted salary plan has already been reversed.');
        END;
    end;

    [Scope('Internal')]
    procedure ReversePostedSalaryIndividual(var PostedSalaryLineInd: Record "33020513")
    var
        PostedSalaryHdr: Record "33020512";
        PostedSalaryLine: Record "33020513";
        PostedSalaryLine1: Record "33020513";
        PostedSalaryLine2: Record "33020513";
        Text000: Label 'There is nothing to reverse.';
    begin
        IF Code THEN BEGIN
            PayGenSetup.GET;

            PostedSalaryHdr.RESET;
            PostedSalaryHdr.SETRANGE("No.", PostedSalaryLineInd."Document No.");
            IF PostedSalaryHdr.FINDFIRST THEN;

            PostedSalaryLine2.RESET;
            PostedSalaryLine2.SETRANGE("Document No.", PostedSalaryLineInd."Document No.");
            IF PostedSalaryLine2.FINDLAST THEN BEGIN
                LineNo := PostedSalaryLine2."Line No.";
            END;
            REPEAT
                PostedSalaryLine.RESET;
                PostedSalaryLine.SETRANGE("Document No.", PostedSalaryLineInd."Document No.");
                PostedSalaryLine.SETRANGE("Employee No.", PostedSalaryLineInd."Employee No.");
                PostedSalaryLine.SETFILTER("Taxable Income", '>=%1', 0);
                PostedSalaryLine.SETRANGE(Reversed, FALSE);
                IF PostedSalaryLine.FINDFIRST THEN BEGIN
                    IF NOT CheckPostedSalaryPlan(PostedSalaryLineInd."Document No.", PostedSalaryLineInd."Employee No.",
                                                 PostedSalaryLineInd."From Date", PostedSalaryLineInd."To Date") THEN BEGIN

                    END ELSE
                        ERROR('Salary for the employee no. %1 has been processed for the following month. Please reverse the following month'
                        + ' salary for this reversal.', PostedSalaryLineInd."Employee No.");
                    /*
                    TotalTax += PostedSalaryLine."Monthly Tax";
                    TotalDeduction += PostedSalaryLine."Total Deduction";
                    TotalBasic += PostedSalaryLine."Basic Salary";
                    */

                    CreateReverseJournalIndividual(PostedSalaryLineInd."Document No.", PostedSalaryHdr."Posting Date",
                                                   PostedSalaryHdr."Document Date", PostedSalaryLine."Monthly Tax",
                                            PostedSalaryLine."Total Benefit" - PostedSalaryLine."Total Deduction", TotalBalance, TotalTax, TotalBasic,
                                             PostedSalaryLine."Global Dimension 1 Code", PostedSalaryLine."Global Dimension 2 Code",
                                             PostedSalaryHdr."Journal Template Name", PostedSalaryHdr."Journal Batch Name",
                                             PostedSalaryLine."Line No.", PostedSalaryLineInd."Employee No.");
                END ELSE
                    ERROR(Text000);
            UNTIL PostedSalaryLineInd.NEXT = 0;
            MESSAGE('The Reversal Journal Lines have been created. Please check and post the journal.');
        END;

    end;

    [Scope('Internal')]
    procedure CreateNegativeLedger(SalaryFrom: Date; SalaryTo: Date; FiscalYearFrom: Date; FiscalYearTo: Date; EmployeeNo: Code[20]; TaxableBenefit: Decimal; MonthlyTax: Decimal; SourceNo: Code[20])
    var
        ReversedSalaryLedgEntry: Record "33020520";
        ReverseEntryNo: Integer;
    begin
        CLEAR(ReverseEntryNo);
        ReversedSalaryLedgEntry.RESET;
        ReversedSalaryLedgEntry.SETRANGE("Employee Code", EmployeeNo);
        ReversedSalaryLedgEntry.SETRANGE("Source No.", SourceNo); //ER 6.4.14
        ReversedSalaryLedgEntry.SETRANGE("Fiscal Year From", FiscalYearFrom);
        ReversedSalaryLedgEntry.SETRANGE("Fiscal Year To", FiscalYearTo);
        ReversedSalaryLedgEntry.SETRANGE("Salary From", SalaryFrom);
        ReversedSalaryLedgEntry.SETRANGE("Salary To", SalaryTo);
        ReversedSalaryLedgEntry.SETRANGE(Reversed, FALSE);
        IF ReversedSalaryLedgEntry.FINDFIRST THEN BEGIN
            ReverseEntryNo := ReversedSalaryLedgEntry."Entry No.";

            IF SalaryLedEntry.FINDLAST THEN
                EntryNo := SalaryLedEntry."Entry No." + 1
            ELSE
                EntryNo := 1;

            SalaryLedEntry.INIT;
            SalaryLedEntry."Entry No." := EntryNo;
            SalaryLedEntry."Employee Code" := EmployeeNo;
            SalaryLedEntry."Salary From" := SalaryFrom;
            SalaryLedEntry."Salary To" := SalaryTo;
            SalaryLedEntry."Fiscal Year From" := FiscalYearFrom;
            SalaryLedEntry."Fiscal Year To" := FiscalYearTo;
            SalaryLedEntry."Basic Salary" := -ReversedSalaryLedgEntry."Basic Salary";
            SalaryLedEntry."Total Benefits" := -ReversedSalaryLedgEntry."Total Benefits";
            SalaryLedEntry."Tax Paid" := -ReversedSalaryLedgEntry."Tax Paid";
            SalaryLedEntry."Total Employer Contribution" := -ReversedSalaryLedgEntry."Total Employer Contribution";
            SalaryLedEntry.CIT := -ReversedSalaryLedgEntry.CIT;
            SalaryLedEntry."Last Slab (%)" := ReversedSalaryLedgEntry."Last Slab (%)";
            SalaryLedEntry."Remaining Amount to Cross Slab" := -ReversedSalaryLedgEntry."Remaining Amount to Cross Slab";
            SalaryLedEntry."Provident Fund" := -ReversedSalaryLedgEntry."Provident Fund";
            SalaryLedEntry."Total Deduction" := -ReversedSalaryLedgEntry."Total Deduction";
            SalaryLedEntry."Tax Paid on First Account" := -ReversedSalaryLedgEntry."Tax Paid on First Account";
            SalaryLedEntry."Tax Paid on Second Account" := -ReversedSalaryLedgEntry."Tax Paid on Second Account";
            SalaryLedEntry.Reversed := TRUE;
            SalaryLedEntry."Creation Date" := TODAY;
            SalaryLedEntry."Reversed Entry No." := ReverseEntryNo;
            SalaryLedEntry."Irregular Process" := ReversedSalaryLedgEntry."Irregular Process"; //ER 6.4.14
            SalaryLedEntry."Source No." := ReversedSalaryLedgEntry."Source No."; //ER 6.4.14
            SalaryLedEntry.INSERT(TRUE);

            ReversedSalaryLedgEntry.Reversed := TRUE;
            ReversedSalaryLedgEntry.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure "Code"(): Boolean
    begin
        IF NOT CONFIRM(Text001, TRUE) THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CreateReverseJournal(DocNo: Code[20]; JTemp: Code[10]; JBatch: Code[10])
    var
        GLentry: Record "17";
        GenJnlLine: Record "81";
    begin
        GenLineNo := 0;

        GLentry.RESET;
        GLentry.SETRANGE("Document No.", DocNo);
        GLentry.SETRANGE(Reversed, FALSE);
        GLentry.SETFILTER(Amount, '<>%1', 0);
        IF GLentry.FINDFIRST THEN BEGIN
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", JTemp);
            GenJnlLine.SETRANGE("Journal Batch Name", GLentry."Journal Batch Name");
            IF GenJnlLine.FINDSET THEN
                GenJnlLine.DELETEALL;
            REPEAT
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := JTemp;
                GenJnlLine.VALIDATE("Journal Batch Name", GLentry."Journal Batch Name");
                GenJnlLine."Line No." := GenLineNo + 10000;
                GenLineNo := GenLineNo + 10000;
                GenJnlLine.VALIDATE("Account Type", GLentry."Source Type");
                IF GLentry."Source No." <> '' THEN
                    GenJnlLine.VALIDATE("Account No.", GLentry."Source No.")
                ELSE
                    GenJnlLine.VALIDATE("Account No.", GLentry."G/L Account No.");
                GenJnlLine.VALIDATE("Posting Date", GLentry."Posting Date");
                GenJnlLine.VALIDATE("Document Date", GLentry."Document Date");
                GenJnlLine.VALIDATE("Document Type", GLentry."Document Type");
                GenJnlLine."Document No." := DocNo;
                GenJnlLine.Description := GLentry.Description;
                GenJnlLine.VALIDATE(Amount, -GLentry.Amount);
                GenJnlLine.VALIDATE("Source Code", GLentry."Source Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", GLentry."Global Dimension 1 Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", GLentry."Global Dimension 2 Code");
                //GenJnlLine.VALIDATE("Shortcut Dimension 3 Code",GLentry."Shortcut Dimension 3 Code");
                //GenJnlLine.VALIDATE("Shortcut Dimension 4 Code",GLentry."Shortcut Dimension 4 Code");
                //GenJnlLine.VALIDATE("Shortcut Dimension 5 Code",GLentry."Shortcut Dimension 5 Code");
                //GenJnlLine.VALIDATE("Shortcut Dimension 6 Code",GLentry."Shortcut Dimension 6 Code");
                //GenJnlLine.VALIDATE("Shortcut Dimension 7 Code",GLentry."Shortcut Dimension 7 Code");
                //GenJnlLine.VALIDATE("Shortcut Dimension 8 Code",GLentry."Shortcut Dimension 8 Code");
                GenJnlLine.VALIDATE("Payroll Reversed", TRUE);

                GLentry.CALCFIELDS("Employee Code");

                GenJnlLine.ValidateShortcutDimCode(GetDimensionNo, GLentry."Employee Code");
                GenJnlLine.INSERT(TRUE);
            UNTIL GLentry.NEXT = 0;
        END;

        GenJnlPostBatch.RUN(GenJnlLine);
    end;

    [Scope('Internal')]
    procedure CreateReverseJournalIndividual(DocNo: Code[20]; PostingDate: Date; DocumentDate: Date; MonthlyTax: Decimal; BasicSalary: Decimal; BalanceAmt: Decimal; TotalTaxPaid: Decimal; TotalBasicCummulation: Decimal; GB1: Code[20]; GB2: Code[20]; JournalTemp: Code[10]; JournalBatch: Code[10]; ErrorLineNo: Integer; EmployeeNo: Code[20])
    var
        GLentry: Record "17";
        GenJnlLine: Record "81";
        PostedSalaryHdr: Record "33020512";
        PostedSalaryLine: Record "33020513";
    begin
        PayGenSetup.GET;

        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("Payroll Management");
        SrcCode := SourceCodeSetup."Payroll Management";

        GLentry.RESET;
        GLentry.SETRANGE("Document No.", DocNo);
        GLentry.SETFILTER("Employee Code", '%1', EmployeeNo);
        GLentry.SETRANGE(Reversed, FALSE);
        IF GLentry.FINDFIRST THEN BEGIN
            REPEAT
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", JournalTemp);
                GenJnlLine.SETRANGE("Journal Batch Name", GLentry."Journal Batch Name");
                IF GenJnlLine.FINDLAST THEN
                    NewLine := GenJnlLine."Line No." + 10000
                ELSE
                    NewLine := 10000;
                GenJnlLine.INIT;
                GenJnlLine."Line No." := NewLine;
                //NewLine := NewLine + 10000;
                GenJnlLine."Journal Template Name" := JournalTemp;
                GenJnlLine.VALIDATE("Journal Batch Name", GLentry."Journal Batch Name");
                IF GLentry."Source No." <> '' THEN
                    GenJnlLine.VALIDATE("Account No.", GLentry."Source No.")
                ELSE
                    GenJnlLine.VALIDATE("Account No.", GLentry."G/L Account No.");

                //GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
                //GenJnlLine.VALIDATE("Account No.",PayGenSetup."Income Tax Account 1");
                GenJnlLine.VALIDATE("Posting Date", GLentry."Posting Date");//PostingDate);
                GenJnlLine.VALIDATE("Document Date", GLentry."Document Date");//DocumentDate);
                GenJnlLine.VALIDATE("Document Type", GLentry."Document Type");
                GenJnlLine."Document No." := DocNo;
                GenJnlLine."Salary Error Line No." := ErrorLineNo;
                GenJnlLine.VALIDATE(Amount, -GLentry.Amount);
                GenJnlLine.VALIDATE("Source Code", SrcCode);
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", GB1);
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", GB2);
                GenJnlLine."Payroll Reversed" := TRUE;
                GLentry.CALCFIELDS("Employee Code");

                GenJnlLine.ValidateShortcutDimCode(GetDimensionNo, GLentry."Employee Code");
                GenJnlLine.INSERT(TRUE);
            UNTIL GLentry.NEXT = 0;
        END;
        /*
         IF BasicSalary <> 0  THEN BEGIN
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name",JournalTemp);
            GenJnlLine.SETRANGE("Journal Batch Name",GLentry."Journal Batch Name");
            IF GenJnlLine.FINDLAST THEN
               NewLine := GenJnlLine."Line No." + 10000
            ELSE
               NewLine := 10000;
            GenJnlLine.RESET;
            GenJnlLine.INIT;
            GenJnlLine."Journal Template Name" := JournalTemp;
            GenJnlLine.VALIDATE("Journal Batch Name",GLentry."Journal Batch Name");
            GenJnlLine."Line No." := NewLine;
            //NewLine := NewLine + 10000;
            GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Account No.",PayGenSetup."Salary Account");
            GenJnlLine.VALIDATE("Posting Date",PostingDate);
            GenJnlLine.VALIDATE("Document Date",DocumentDate);
            GenJnlLine.VALIDATE("Document Type",GLentry."Document Type");
            GenJnlLine."Document No." := DocNo;
            GenJnlLine.VALIDATE(Amount,);
            GenJnlLine.VALIDATE("Source Code",SrcCode);
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code",GB1);
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code",GB2);
            GenJnlLine."Payroll Reversed" := TRUE;
            GLentry.CALCFIELDS("Employee Code");
            CLEAR(JnlLineDim);
            JnlLineDim.INIT;
            JnlLineDim."Table ID" := DATABASE::"Gen. Journal Line";
            JnlLineDim."Journal Template Name" :=  GenJnlLine."Journal Template Name";
            JnlLineDim."Journal Batch Name" := GenJnlLine."Journal Batch Name";
            JnlLineDim."Journal Line No." := GenJnlLine."Line No.";
            JnlLineDim."Dimension Code" := 'EMPLOYEE';
            JnlLineDim."Dimension Value Code" := GLentry."Employee Code";
            JnlLineDim.INSERT;

            GenJnlLine.INSERT(TRUE);

         END;
      END;
      */

    end;

    [Scope('Internal')]
    procedure CreateBalancingLine(DocNo: Code[20]; BalanceAmt: Decimal; CreditAssignType: Option "G/L Account","Bank Account"; BalanceAccount: Code[20]; PostingDate: Date; DocumentDate: Date)
    var
        GenJnlLine: Record "81";
        GLentry: Record "17";
    begin
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("Payroll Management");
        SrcCode := SourceCodeSetup."Payroll Management";

        GLentry.RESET;
        GLentry.SETRANGE("Document No.", DocNo);
        IF GLentry.FINDFIRST THEN BEGIN
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", 'PAYROLL');
            GenJnlLine.SETRANGE("Journal Batch Name", GLentry."Journal Batch Name");
            IF GenJnlLine.FINDLAST THEN
                BalancingNewLine := GenJnlLine."Line No."
            ELSE
                BalancingNewLine := 10000;

            IF BalanceAmt <> 0 THEN BEGIN
                GenJnlLine.INIT;
                GenJnlLine."Journal Template Name" := 'PAYROLL';
                GenJnlLine.VALIDATE("Journal Batch Name", GLentry."Journal Batch Name");
                GenJnlLine."Line No." := BalancingNewLine + 10000;
                //BalancingNewLine := BalancingNewLine + 10000;
                IF CreditAssignType = CreditAssignType::"Bank Account" THEN
                    AccountType := AccountType::"Bank Account"
                ELSE
                    AccountType := AccountType::"G/L Account";
                GenJnlLine.VALIDATE("Account Type", AccountType);
                GenJnlLine.VALIDATE("Account No.", BalanceAccount);
                GenJnlLine.VALIDATE("Posting Date", PostingDate);
                GenJnlLine.VALIDATE("Document Date", DocumentDate);
                GenJnlLine.VALIDATE("Document Type", GLentry."Document Type");
                GenJnlLine."Document No." := DocNo;
                GenJnlLine.VALIDATE(Amount, BalanceAmt);
                GenJnlLine.VALIDATE("Source Code", SrcCode);
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", GLentry."Global Dimension 1 Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", GLentry."Global Dimension 2 Code");
                GenJnlLine."Payroll Reversed" := TRUE;
                GenJnlLine.INSERT;
            END;

            //GenJnlPostBatch.RUN(GenJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure CheckPostedSalaryPlan(DocumentNo: Code[20]; EmployeeNo: Code[20]; FromDate: Date; ToDate: Date): Boolean
    var
        PostedSalaryPlanLine: Record "33020513";
    begin
        PostedSalaryPlanLine.RESET;
        PostedSalaryPlanLine.SETRANGE("Employee No.", EmployeeNo);
        PostedSalaryPlanLine.SETFILTER("From Date", '>%1', FromDate);
        PostedSalaryPlanLine.SETFILTER("Taxable Income", '>%1', 0);
        PostedSalaryPlanLine.SETRANGE(Reversed, FALSE);
        IF PostedSalaryPlanLine.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure InsertNegativeLines(var GJnlLine: Record "81")
    var
        PostedSalaryHdr: Record "33020512";
        PostedSalaryLine: Record "33020513";
        PostedSalaryLine1: Record "33020513";
        PostedSalaryLine2: Record "33020513";
        Text000: Label 'There is nothing to reverse.';
    begin
        PayGenSetup.GET;

        PostedSalaryHdr.RESET;
        PostedSalaryHdr.SETRANGE("No.", GJnlLine."Document No.");
        IF PostedSalaryHdr.FINDFIRST THEN;

        PostedSalaryLine2.RESET;
        PostedSalaryLine2.SETRANGE("Document No.", GJnlLine."Document No.");
        IF PostedSalaryLine2.FINDLAST THEN BEGIN
            LineNo := PostedSalaryLine2."Line No.";
        END;
        PostedSalaryLine.RESET;
        PostedSalaryLine.SETRANGE("Document No.", GJnlLine."Document No.");
        PostedSalaryLine.SETRANGE("Line No.", GJnlLine."Salary Error Line No.");
        PostedSalaryLine.SETFILTER("Taxable Income", '>=%1', 0);
        PostedSalaryLine.SETFILTER(Reversed, '%1', FALSE);
        IF PostedSalaryLine.FINDFIRST THEN BEGIN
            IF NOT CheckPostedSalaryPlan(PostedSalaryLine."Document No.", PostedSalaryLine."Employee No.",
                                         PostedSalaryLine."From Date", PostedSalaryLine."To Date") THEN BEGIN
                PostedSalaryLine1.INIT;
                PostedSalaryLine1."Document No." := PostedSalaryLine."Document No.";
                PostedSalaryLine1."Employee No." := PostedSalaryLine."Employee No.";
                PostedSalaryLine1."Line No." := LineNo + 10000;
                LineNo += 10000;
                PostedSalaryLine1."Basic Salary" := -PostedSalaryLine."Basic Salary";
                PostedSalaryLine1."Net Pay" := -PostedSalaryLine."Net Pay";
                PostedSalaryLine1."Taxable Income" := -PostedSalaryLine."Taxable Income";
                PostedSalaryLine1."Monthly Tax" := -PostedSalaryLine."Monthly Tax";
                PostedSalaryLine1."Total Benefit" := -PostedSalaryLine."Total Benefit";
                PostedSalaryLine1."Total Deduction" := -PostedSalaryLine."Total Deduction";
                PostedSalaryLine1."Total Employer Contribution" := -PostedSalaryLine."Total Employer Contribution";
                PostedSalaryLine1."Global Dimension 1 Code" := PostedSalaryLine."Global Dimension 1 Code";
                PostedSalaryLine1."Global Dimension 2 Code" := PostedSalaryLine."Global Dimension 2 Code";
                PostedSalaryLine1."Present Days" := PostedSalaryLine."Present Days";
                PostedSalaryLine1."Absent Days" := PostedSalaryLine."Absent Days";
                PostedSalaryLine1."Paid Days" := PostedSalaryLine."Paid Days";
                PostedSalaryLine1."Job Title" := PostedSalaryLine."Job Title";
                PostedSalaryLine1."From Date" := PostedSalaryLine."From Date";
                PostedSalaryLine1."To Date" := PostedSalaryLine."To Date";
                PostedSalaryLine1.Month := PostedSalaryLine.Month;
                PostedSalaryLine1."Last Slab (%)" := PostedSalaryLine."Last Slab (%)";
                PostedSalaryLine1."Remaining Amount to Cross Slab" := -PostedSalaryLine."Remaining Amount to Cross Slab";
                PostedSalaryLine1."Tax Paid on First Account" := -PostedSalaryLine."Tax Paid on First Account";
                PostedSalaryLine1."Tax Paid on Second Account" := -PostedSalaryLine."Tax Paid on Second Account";
                PostedSalaryLine1."Variable Field 33020500" := -PostedSalaryLine."Variable Field 33020500";
                PostedSalaryLine1."Variable Field 33020501" := -PostedSalaryLine."Variable Field 33020501";
                PostedSalaryLine1."Variable Field 33020502" := -PostedSalaryLine."Variable Field 33020502";
                PostedSalaryLine1."Variable Field 33020503" := -PostedSalaryLine."Variable Field 33020503";
                PostedSalaryLine1."Variable Field 33020504" := -PostedSalaryLine."Variable Field 33020504";
                PostedSalaryLine1."Variable Field 33020505" := -PostedSalaryLine."Variable Field 33020505";
                PostedSalaryLine1."Variable Field 33020506" := -PostedSalaryLine."Variable Field 33020506";
                PostedSalaryLine1."Variable Field 33020507" := -PostedSalaryLine."Variable Field 33020507";
                PostedSalaryLine1."Variable Field 33020508" := -PostedSalaryLine."Variable Field 33020508";
                PostedSalaryLine1."Variable Field 33020509" := -PostedSalaryLine."Variable Field 33020509";
                PostedSalaryLine1."Variable Field 33020510" := -PostedSalaryLine."Variable Field 33020510";
                PostedSalaryLine1."Variable Field 33020511" := -PostedSalaryLine."Variable Field 33020511";
                PostedSalaryLine1."Variable Field 33020512" := -PostedSalaryLine."Variable Field 33020512";
                PostedSalaryLine1."Variable Field 33020513" := -PostedSalaryLine."Variable Field 33020513";
                PostedSalaryLine1."Variable Field 33020514" := -PostedSalaryLine."Variable Field 33020514";
                PostedSalaryLine1."Variable Field 33020515" := -PostedSalaryLine."Variable Field 33020515";
                PostedSalaryLine1."Variable Field 33020516" := -PostedSalaryLine."Variable Field 33020516";
                PostedSalaryLine1."Variable Field 33020517" := -PostedSalaryLine."Variable Field 33020517";
                PostedSalaryLine1."Variable Field 33020518" := -PostedSalaryLine."Variable Field 33020518";
                PostedSalaryLine1."Variable Field 33020519" := -PostedSalaryLine."Variable Field 33020519";
                PostedSalaryLine1."Variable Field 33020520" := -PostedSalaryLine."Variable Field 33020520";
                PostedSalaryLine1."Variable Field 33020521" := -PostedSalaryLine."Variable Field 33020521";
                PostedSalaryLine1."Variable Field 33020522" := -PostedSalaryLine."Variable Field 33020522";
                PostedSalaryLine1."Variable Field 33020523" := -PostedSalaryLine."Variable Field 33020523";
                PostedSalaryLine1."Variable Field 33020524" := -PostedSalaryLine."Variable Field 33020524";
            END ELSE
                ERROR('Salary for the employee no. %1 has been processed for the following month. Please reverse the following month'
                + ' salary for this reversal.', PostedSalaryLine."Employee No.");

            PostedSalaryLine1.INSERT(TRUE);

            TotalTax += PostedSalaryLine."Monthly Tax";
            TotalDeduction += PostedSalaryLine."Total Deduction";
            TotalBasic += PostedSalaryLine."Basic Salary";


            CreateNegativeLedger(PostedSalaryLine."From Date", PostedSalaryLine."To Date", PayGenSetup."Payroll Fiscal Year Start Date",
                                   PayGenSetup."Payroll Fiscal Year End Date",
                                   PostedSalaryLine."Employee No.", PostedSalaryLine."Basic Salary", PostedSalaryLine."Monthly Tax",
                                   PostedSalaryLine."Document No."); //ER

            PostedSalaryLine.Reversed := TRUE;
            PostedSalaryLine.MODIFY;
        END ELSE
            ERROR(Text000);
    end;

    local procedure GetDimensionNo(): Integer
    var
        GLSetup: Record "98";
    begin
        GLSetup.GET;
        IF GLSetup."Shortcut Dimension 1 Code" = 'EMPLOYEE' THEN
            EXIT(1)
        ELSE
            IF GLSetup."Shortcut Dimension 2 Code" = 'EMPLOYEE' THEN
                EXIT(2)
            ELSE
                IF GLSetup."Shortcut Dimension 3 Code" = 'EMPLOYEE' THEN
                    EXIT(3)
                ELSE
                    IF GLSetup."Shortcut Dimension 4 Code" = 'EMPLOYEE' THEN
                        EXIT(4)
                    ELSE
                        IF GLSetup."Shortcut Dimension 5 Code" = 'EMPLOYEE' THEN
                            EXIT(5)
                        ELSE
                            IF GLSetup."Shortcut Dimension 6 Code" = 'EMPLOYEE' THEN
                                EXIT(6)
                            ELSE
                                IF GLSetup."Shortcut Dimension 7 Code" = 'EMPLOYEE' THEN
                                    EXIT(7)
                                ELSE
                                    IF GLSetup."Shortcut Dimension 8 Code" = 'EMPLOYEE' THEN
                                        EXIT(8)
    end;

    [Scope('Internal')]
    procedure updatePayroll(Code_: Code[20])
    var
        PostedSalHdr: Record "33020512";
        SalLine: Record "33020513";
        SalaryLedgerEntry: Record "33020520";
        ReverseSalaryLed: Record "33020520";
        PayGenSetup: Record "33020507";
    begin
        IF PostedSalHdr.GET(Code_) THEN BEGIN
            PayGenSetup.GET;
            SalLine.RESET;
            SalLine.SETRANGE("Document No.", PostedSalHdr."No.");
            IF SalLine.FINDSET THEN
                REPEAT
                    CLEAR(ReverseSalaryLed);

                    ReverseSalaryLed.RESET;
                    ReverseSalaryLed.SETRANGE("Employee Code", SalLine."Employee No.");
                    ReverseSalaryLed.SETRANGE("Source No.", SalLine."Document No.");
                    ReverseSalaryLed.SETRANGE("Fiscal Year From", PayGenSetup."Payroll Fiscal Year Start Date");
                    ReverseSalaryLed.SETRANGE("Fiscal Year To", PayGenSetup."Payroll Fiscal Year End Date");
                    ReverseSalaryLed.SETRANGE("Salary From", SalLine."From Date");
                    ReverseSalaryLed.SETRANGE("Salary To", SalLine."To Date");
                    ReverseSalaryLed.SETRANGE(Reversed, FALSE);
                    ReverseSalaryLed.FINDFIRST;

                    SalaryLedgerEntry.INIT;
                    IF SalaryLedgerEntry.FINDLAST THEN
                        SalaryLedgerEntry."Entry No." += 1
                    ELSE
                        SalaryLedgerEntry."Entry No." := 1;

                    SalaryLedgerEntry."Employee Code" := ReverseSalaryLed."Employee Code";
                    SalaryLedgerEntry."Salary From" := ReverseSalaryLed."Salary From";
                    SalaryLedgerEntry."Salary To" := SalaryLedgerEntry."Salary To";
                    SalaryLedgerEntry."Fiscal Year From" := PayGenSetup."Payroll Fiscal Year Start Date";
                    SalaryLedgerEntry."Fiscal Year To" := PayGenSetup."Payroll Fiscal Year End Date";
                    SalaryLedgerEntry."Basic Salary" := -ReverseSalaryLed."Basic Salary";
                    SalaryLedgerEntry."Total Benefits" := -ReverseSalaryLed."Total Benefits";
                    SalaryLedgerEntry."Tax Paid" := -ReverseSalaryLed."Tax Paid";
                    SalaryLedgerEntry."Total Employer Contribution" := -ReverseSalaryLed."Total Employer Contribution";
                    SalaryLedgerEntry.CIT := -ReverseSalaryLed.CIT;
                    SalaryLedgerEntry."Last Slab (%)" := -ReverseSalaryLed."Last Slab (%)";
                    SalaryLedgerEntry."Remaining Amount to Cross Slab" := -ReverseSalaryLed."Remaining Amount to Cross Slab";
                    SalaryLedgerEntry."Provident Fund" := -ReverseSalaryLed."Provident Fund";
                    SalaryLedgerEntry."Total Deduction" := -ReverseSalaryLed."Total Deduction";
                    SalaryLedgerEntry."Tax Paid on First Account" := -ReverseSalaryLed."Tax Paid on First Account";
                    SalaryLedgerEntry."Tax Paid on Second Account" := -ReverseSalaryLed."Tax Paid on Second Account";
                    SalaryLedgerEntry."Gratuity Amount" := -ReverseSalaryLed."Gratuity Amount"; //added
                    SalaryLedgerEntry."SSF(1.67%) Amount" := -ReverseSalaryLed."SSF(1.67%) Amount";


                    SalaryLedgerEntry."Creation Date" := TODAY;
                    SalaryLedgerEntry.Reversed := TRUE;
                    SalaryLedgerEntry."Irregular Process" := ReverseSalaryLed."Irregular Process";
                    SalaryLedgerEntry."Source No." := ReverseSalaryLed."Source No.";
                    SalaryLedgerEntry."Aryan Reversed" := TRUE;

                    SalaryLedgerEntry.INSERT(TRUE);


                    ReverseSalaryLed.Reversed := TRUE;
                    ReverseSalaryLed.MODIFY;

                    SalLine.Reversed := TRUE;
                    SalLine.MODIFY;

                    PostedSalHdr.Reversed := TRUE;
                    PostedSalHdr.MODIFY;

                UNTIL SalLine.NEXT = 0;
        END;
    end;
}

