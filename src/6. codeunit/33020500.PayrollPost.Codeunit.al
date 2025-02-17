codeunit 33020500 "Payroll-Post"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    TableNo = 33020510;

    trigger OnRun()
    var
        PayrollComponentUsage: Record "33020504";
        SalaryLineRec: Record "33020511";
        SalLdrEntry: Record "33020520";
    begin
        PayrollSetup.GET;
        CLEARALL;
        //"Posting Date" := TODAY;
        Rec.MODIFY;
        SalaryHeader := Rec;
        SalaryHeader.TESTFIELD("From Date");
        SalaryHeader.TESTFIELD("To Date");
        SalaryHeader.TESTFIELD("Posting Date");
        SalaryHeader.TESTFIELD(Month);
        SalaryHeader.TESTFIELD("Global Dimension 1 Code");
        SalaryHeader.TESTFIELD("Global Dimension 2 Code");
        SalaryHeader.TESTFIELD("Accountability Center");
        SalaryHeader.TESTFIELD("Journal Template Name");
        SalaryHeader.TESTFIELD("Journal Batch Name");

        //ER-- Restrict consecutive Irregular Process to avoid Incorrect Tax Calc>>
        IF "Irregular Process" THEN BEGIN
            SalaryLineRec.RESET;
            SalaryLineRec.SETRANGE("Document No.", SalaryHeader."No.");
            IF SalaryLineRec.FINDFIRST THEN
                REPEAT
                    SalLdrEntry.RESET;
                    SalLdrEntry.SETRANGE("Employee Code", SalaryLineRec."Employee No.");
                    //SalLdrEntry.SETRANGE("Irregular Process",TRUE);
                    SalLdrEntry.SETRANGE(Reversed, FALSE);
                    IF SalLdrEntry.FINDLAST THEN
                        IF SalLdrEntry."Irregular Process" THEN
                            ERROR(NoConsecutiveIrregularP, SalaryLineRec."Employee No.");
                UNTIL SalaryLineRec.NEXT = 0;
        END;
        //ER-- Restrict consecutive Irregular Process to avoid Incorrect Tax Calc<<

        IF GenJnlCheckLine.DateNotAllowed(SalaryHeader."Posting Date") THEN
            SalaryHeader.FIELDERROR("Posting Date", Text000);
        IF PostNothing THEN
            ERROR(Text001);
        CopyAndCheckDocDimToTempDocDim;
        Window.OPEN(
          '#1###########################################\\' +
          Text002 +
          Text003
          );

        Window.UPDATE(1, STRSUBSTNO('%1 %2', Text005, SalaryHeader."No."));
        CODEUNIT.RUN(CODEUNIT::"Release Payroll Document", SalaryHeader);
        PRSetup.GET;
        PRSetup.TESTFIELD("Income Tax Account 1");
        PRSetup.TESTFIELD("Salary Account");
        SourceCodeSetup.GET;
        SourceCodeSetup.TESTFIELD("Payroll Management");
        SrcCode := SourceCodeSetup."Payroll Management";
        IF ("Posting No." = '') THEN BEGIN
            IF (SalaryHeader."No. Series" <> '')
            THEN
                SalaryHeader.TESTFIELD("Posting No. Series");
            IF (SalaryHeader."No. Series" <> "Posting No. Series")
            THEN BEGIN
                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", SalaryHeader."Posting Date", TRUE);
                ModifyHeader := TRUE;
            END;
        END;
        IF ModifyHeader THEN BEGIN
            SalaryHeader.MODIFY;
            COMMIT;
        END;
        IF SalaryHeader.RECORDLEVELLOCKING THEN BEGIN
            SalaryLine.LOCKTABLE;
        END;

        //Posting to mirror table Begin >>>
        PostedSalaryHeader.INIT;
        PostedSalaryHeader.TRANSFERFIELDS(SalaryHeader);
        PostedSalaryHeader."No." := "Posting No.";
        PostedSalaryHeader."Pre-Assigned No." := SalaryHeader."No.";
        Window.UPDATE(1, STRSUBSTNO(Text006, Text005, SalaryHeader."No.", PostedSalaryHeader."No."));
        PostedSalaryHeader."Source Code" := SrcCode;
        PostedSalaryHeader."User ID" := USERID;
        PostedSalaryHeader."No. Printed" := 0;
        PostedSalaryHeader.INSERT;
        PostedSalaryHeader.COPYLINKS(Rec);
        LineCount := 0;
        SalaryLine.RESET;
        SalaryLine.SETRANGE("Document No.", SalaryHeader."No.");
        IF SalaryLine.FINDSET THEN
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);
                PostedSalaryLine.INIT;
                PostedSalaryLine.TRANSFERFIELDS(SalaryLine);
                PostedSalaryLine."Document No." := PostedSalaryHeader."No.";
                PostedSalaryLine."From Date" := PostedSalaryHeader."From Date";
                PostedSalaryLine."To Date" := PostedSalaryHeader."To Date";
                PostedSalaryLine.Month := PostedSalaryHeader.Month;
                //***SM 18 May 2014
                PostedSalaryLine."Pre Assigned No." := SalaryLine."Document No.";
                //***SM 18 May 2014
                PostedSalaryLine.INSERT;

                SalaryLedgerEntry.LOCKTABLE;
                IF SalaryLedgerEntry.FINDLAST THEN
                    SalaryLedgerEntry."Entry No." := SalaryLedgerEntry."Entry No." + 1
                ELSE
                    SalaryLedgerEntry."Entry No." := 1;
                SalaryLedgerEntry.INIT;
                SalaryLedgerEntry."Employee Code" := SalaryLine."Employee No.";
                SalaryLedgerEntry."Salary From" := PostedSalaryHeader."From Date";
                SalaryLedgerEntry."Salary To" := PostedSalaryHeader."To Date";
                SalaryLedgerEntry."Fiscal Year From" := PRSetup."Payroll Fiscal Year Start Date";
                SalaryLedgerEntry."Fiscal Year To" := PRSetup."Payroll Fiscal Year End Date";
                SalaryLedgerEntry."Irregular Process" := SalaryHeader."Irregular Process";
                IF NOT SalaryHeader."Irregular Process" THEN BEGIN
                    SalaryLedgerEntry."Basic Salary" := SalaryLine."Basic with Grade";
                END;
                SalaryLedgerEntry."Total Benefits" := SalaryLine."Total Benefit" + SalaryLine."Total Employer Contribution";
                SalaryLedgerEntry."Total Employer Contribution" := SalaryLine."Total Employer Contribution";
                SalaryLedgerEntry."Total Deduction" := SalaryLine."Total Deduction";
                //PRMGT1.00
                SalaryLedgerEntry."Gratuity Amount" := SalaryLine.Gratuity;
                SalaryLedgerEntry."Gratuity TDS Payable" := SalaryLine."Gratuity TDS Payable";
                SalaryLedgerEntry."Net Gratuity" := SalaryLine."Net Gratuity";
                SalaryLedgerEntry."SSF(1.67%) Amount" := SalaryLine."SSF(1.67 %)"; //Min 12/18/2019
                                                                                   //PRMGT1.00
                                                                                   //SalaryLedgerEntry."Tax Paid" := SalaryLine."Tax for Period";
                SalaryLedgerEntry."Tax Paid" := (SalaryLine."Tax Paid on First Account" + SalaryLine."Tax Paid on Second Account");
                //SalaryLedgerEntry."Tax Paid on First Account" := TaxAmount[1];
                //SalaryLedgerEntry."Tax Paid on Second Account" := TaxAmount[2];
                SalaryLedgerEntry."Tax Paid on First Account" := SalaryLine."Tax Paid on First Account";
                SalaryLedgerEntry."Tax Paid on Second Account" := SalaryLine."Tax Paid on Second Account";
                SalaryLedgerEntry."Tax Credit" := SalaryLine."Total Tax Credit";
                SalaryLedgerEntry."Last Slab (%)" := SalaryLine."Last Slab (%)";
                SalaryLedgerEntry."Remaining Amount to Cross Slab" := SalaryLine."Remaining Amount to Cross Slab";
                SalaryLedgerEntry."Provident Fund" := 2 * SalaryLine."Total Employer Contribution";
                SalaryLedgerEntry.CIT := SalaryLine."Variable Field 33020502"; //hardcoded for CIT quick solution
                SalaryLedgerEntry."Creation Date" := TODAY;
                SalaryLedgerEntry."Source No." := PostedSalaryHeader."No.";
                SalaryLedgerEntry.INSERT;

                //Update Encash  ratan
                LeaveEncshLedgerInsert(SalaryLine);
            UNTIL SalaryLine.NEXT = 0;
        //Posting to mirror table End >>>

        PostToJournal();


        Window.CLOSE;
        //Deleting All Documents Begin>>>

        IF SalaryHeader.HASLINKS THEN SalaryHeader.DELETELINKS;
        SalaryHeader.DELETE;
        SalaryLine.RESET;
        SalaryLine.SETRANGE("Document No.", SalaryHeader."No.");
        IF SalaryLine.FINDFIRST THEN
            REPEAT
                IF SalaryLine.HASLINKS THEN
                    SalaryLine.DELETELINKS;
            UNTIL SalaryLine.NEXT = 0;
        SalaryLine.DELETEALL;
        SalaryCreditAssign.RESET;
        SalaryCreditAssign.SETRANGE("Salary Header No.", SalaryHeader."No.");
        SalaryCreditAssign.DELETEALL;
        //Deleting All Documents End>>>
        Rec := SalaryHeader;
        COMMIT;
    end;

    var
        SalaryHeader: Record "33020510";
        SalaryLine: Record "33020511";
        SourceCodeSetup: Record "242";
        PRSetup: Record "33020507";
        PostedSalaryHeader: Record "33020512";
        PostedSalaryLine: Record "33020513";
        GLEntry: Record "17";
        GenJnlCheckLine: Codeunit "11";
        Text000: Label 'is not within your range of allowed posting dates.';
        NoSeriesMgt: Codeunit "396";
        DimMgt: Codeunit "408";
        DimBufMgt: Codeunit "411";
        GenJnlPostLine: Codeunit "12";
        Window: Dialog;
        Text001: Label 'There is nothing to post.';
        Text002: Label 'Posting lines                     #2######\';
        Text003: Label 'Creating Journals    #3######\';
        Text004: Label 'Creating salary ledger entries   #4######';
        Text005: Label 'Salary Plan';
        Text006: Label '%1 %2 -> Posted %3';
        LineCount: Integer;
        ModifyHeader: Boolean;
        SrcCode: Code[10];
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ","Salary Plan";
        SalaryPostBuffer: Record "33020518" temporary;
        SalaryCreditAssign: Record "33020514";
        TaxAccount: array[2] of Code[20];
        TaxAccountCount: Integer;
        SalaryLedgerEntry: Record "33020520";
        TotalPF: Decimal;
        TaxAmount: array[2] of Decimal;
        PostedSalaryLine1: Record "33020513";
        Employee1: Record "5200";
        TaxSetupLine: Record "33020506";
        CheckAmt: Decimal;
        NoConsecutiveIrregularP: Label 'You are not allowed to process Irregular Salary Plan consecutively for Employee %1';
        CompanyInfo: Record "79";
        PayrollSetup: Record "33020507";

    [Scope('Internal')]
    procedure PostNothing(): Boolean
    begin
        SalaryLine.RESET;
        SalaryLine.SETRANGE("Document No.", SalaryHeader."No.");
        IF SalaryLine.ISEMPTY THEN
            EXIT(TRUE);
    end;

    local procedure CopyAndCheckDocDimToTempDocDim()
    var
        SalesLine2: Record "37";
        DimExist: Boolean;
    begin
        /*
        TempDocDim.RESET;
        TempDocDim.DELETEALL;
        DocDim.SETRANGE("Table ID",DATABASE::"Salary Line");
        DocDim.SETRANGE("Document Type",DocumentType::"Salary Plan");
        DocDim.SETRANGE("Document No.",SalaryHeader."No.");
        IF DocDim.FINDSET THEN BEGIN
          REPEAT
            TempDocDim.INIT;
            TempDocDim := DocDim;
            TempDocDim.INSERT;
          UNTIL DocDim.NEXT = 0;
        END;
        TempDocDim.RESET;
        */

    end;

    [Scope('Internal')]
    procedure PostToJournal()
    var
        GenJnlLine: Record "81";
        i: Integer;
        LineNo: Integer;
        GenJnlBatch: Record "232";
        GenJnlPostBatch: Codeunit "13";
    begin
        SalaryCreditAssign.RESET;
        SalaryCreditAssign.SETRANGE("Salary Header No.", SalaryHeader."No.");
        IF SalaryCreditAssign.FINDFIRST THEN;
        TaxAccountCount := GetTaxAccount;
        SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
        SalaryPostBuffer.DELETEALL;
        IF SalaryLine.FINDFIRST THEN
            REPEAT
                FOR i := 0 TO 19 DO BEGIN
                    InsertPostingBuffer(33020500 + i);
                END;
                InsertTaxLine();
                IF SalaryLine.Gratuity <> 0 THEN
                    InsertGratuityLine; //PRMGT1.00
                IF SalaryLine."SSF(1.67 %)" <> 0 THEN
                    InsertSSFLine; //Min 12/18/2019
                IF SalaryLine."Basic with Grade" <> 0 THEN
                    InsertBasicLine(FALSE, 0);
            UNTIL SalaryLine.NEXT = 0;
        InsertBalancingLine();
        LineNo := 10000;
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", SalaryHeader."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", SalaryHeader."Journal Batch Name");
        IF GenJnlLine.FINDSET THEN
            GenJnlLine.DELETEALL;
        LineCount := 0;
        SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
        IF SalaryPostBuffer.FINDFIRST THEN
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(3, LineCount);
                CLEAR(GenJnlLine);
                GenJnlLine.INIT;
                GenJnlLine.VALIDATE("Journal Template Name", SalaryHeader."Journal Template Name");
                GenJnlLine.VALIDATE("Journal Batch Name", SalaryHeader."Journal Batch Name");
                GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::Payment);
                GenJnlLine.VALIDATE("Posting Date", SalaryHeader."Posting Date");
                GenJnlLine.VALIDATE("Document Date", SalaryHeader."Document Date");
                GenJnlLine."Line No." := LineNo;
                GenJnlLine."Document No." := PostedSalaryHeader."No.";
                GenJnlLine.VALIDATE("Account Type", SalaryPostBuffer.Type);
                GenJnlLine.VALIDATE("Account No.", SalaryPostBuffer."Account Code");
                GenJnlLine.VALIDATE(Amount, SalaryPostBuffer.Amount);
                //message('1..'+format(genjnlline.amount));
                GenJnlLine.Description := SalaryHeader.Remarks;
                GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", SalaryPostBuffer."Global Dimension 1 Code");
                GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", SalaryPostBuffer."Global Dimension 2 Code");
                GenJnlLine."Source Code" := SrcCode;
                GenJnlLine.Comment := SalaryPostBuffer."Employee Code";

                IF (SalaryPostBuffer."Employee Code" <> '') AND
                  (NOT SalaryPostBuffer."Balancing Line") THEN BEGIN
                    GenJnlLine.ValidateShortcutDimCode(GetDimensionNo, SalaryPostBuffer."Employee Code");
                END;

                GenJnlLine.INSERT(TRUE);
                /*IF (PRSetup."Posting Method" = PRSetup."Posting Method"::"Employee Wise") AND
                  (NOT SalaryPostBuffer."Balancing Line") THEN BEGIN
                    //commented on 4/22/2013
                */
                IF (SalaryPostBuffer."Employee Code" <> '') AND
                  (NOT SalaryPostBuffer."Balancing Line") THEN BEGIN
                    GenJnlLine.ValidateShortcutDimCode(GetDimensionNo, SalaryPostBuffer."Employee Code");
                END;
                LineNo += 10000;
            UNTIL SalaryPostBuffer.NEXT = 0;

        GenJnlPostBatch.RUN(GenJnlLine);

        SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
        SalaryPostBuffer.DELETEALL;

    end;

    [Scope('Internal')]
    procedure InsertPostingBuffer(FieldID: Integer)
    var
        VFUsage: Record "33020517";
        PayrollComponent: Record "33020503";
        CalculatedAmount: Decimal;
        AccumulatedContribution: Decimal;
    begin
        VFUsage.RESET;
        VFUsage.SETRANGE("Table No.", DATABASE::"Salary Line");
        VFUsage.SETRANGE("Field No.", FieldID);
        IF VFUsage.FINDFIRST THEN BEGIN
            PayrollComponent.GET(VFUsage."Variable Field Code");
            PayrollComponent.TESTFIELD("G/L Account");
            IF (PayrollComponent.Type = PayrollComponent.Type::Benefits) OR
             (PayrollComponent.Type = PayrollComponent.Type::"Employer Contribution")
             THEN BEGIN
                CalculatedAmount := EvaluateFields(FieldID);
                IF (PayrollComponent.Type = PayrollComponent.Type::"Employer Contribution") THEN
                    TotalPF := CalculatedAmount;
            END
            ELSE
                IF (PayrollComponent.Type = PayrollComponent.Type::Deduction) THEN BEGIN
                    IF (PayrollComponent.Subtype = PayrollComponent.Subtype::Retirement) AND
                      (PayrollComponent.Code = 'PF DEDUCTION') //hardcoded
                      THEN
                        CalculatedAmount := -2 * EvaluateFields(FieldID)
                    ELSE
                        CalculatedAmount := -1 * EvaluateFields(FieldID);
                END;
            IF CalculatedAmount <> 0 THEN BEGIN
                SalaryPostBuffer.RESET;
                SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
                SalaryPostBuffer.SETRANGE(Type, SalaryPostBuffer.Type::"G/L Account");
                SalaryPostBuffer.SETRANGE("Account Code", PayrollComponent."G/L Account");
                //SalaryPostBuffer.SETRANGE("Global Dimension 1 Code",SalaryLine."Global Dimension 1 Code");
                //SalaryPostBuffer.SETRANGE("Global Dimension 2 Code",SalaryLine."Global Dimension 2 Code");
                IF PayrollComponent."Posting Method" = PayrollComponent."Posting Method"::"Employee Wise" THEN BEGIN
                    SalaryPostBuffer.SETRANGE("Employee Code", SalaryLine."Employee No.");
                END
                ELSE BEGIN
                    SalaryPostBuffer.SETRANGE("Global Dimension 1 Code", SalaryLine."Global Dimension 1 Code");
                    SalaryPostBuffer.SETRANGE("Global Dimension 2 Code", SalaryLine."Global Dimension 2 Code");
                END;
                IF SalaryPostBuffer.FINDFIRST THEN BEGIN
                    SalaryPostBuffer.Amount += CalculatedAmount;
                    SalaryPostBuffer.MODIFY;
                    /*
                    IF (PayrollComponent.Type = PayrollComponent.Type::"Employer Contribution") THEN BEGIN
                      InsertBasicLine(TRUE,ABS(CalculatedAmount));
                    END;
                    */
                END
                ELSE BEGIN
                    CLEAR(SalaryPostBuffer);
                    SalaryPostBuffer.INIT;
                    SalaryPostBuffer."Document No." := SalaryHeader."No.";
                    SalaryPostBuffer.Type := SalaryPostBuffer.Type::"G/L Account";
                    SalaryPostBuffer."Account Code" := PayrollComponent."G/L Account";
                    SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
                    SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
                    SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
                    /*IF PRSetup."Posting Method" = PRSetup."Posting Method"::"Employee Wise" THEN
                      SalaryPostBuffer."Employee Code" := SalaryLine."Employee No."; commented on 4/22/2013*/
                    IF PayrollComponent."Posting Method" = PayrollComponent."Posting Method"::"Employee Wise" THEN BEGIN
                        SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
                    END;
                    SalaryPostBuffer.Amount := CalculatedAmount;
                    SalaryPostBuffer.INSERT;
                    /*
                    IF (PayrollComponent.Type = PayrollComponent.Type::"Employer Contribution") THEN BEGIN
                      InsertBasicLine(TRUE,ABS(CalculatedAmount));
                    END;
                    */
                END;
            END;
        END;

    end;

    [Scope('Internal')]
    procedure InsertTaxLine()
    var
        TaxLine: Integer;
        TempTaxAmount: Decimal;
    begin
        TaxAmount[1] := 0;
        TaxAmount[2] := 0;
        FOR TaxLine := 1 TO TaxAccountCount DO BEGIN
            SplitTaxAmount(TempTaxAmount, TaxLine);
            IF TempTaxAmount <> 0 THEN BEGIN
                SalaryPostBuffer.RESET;
                SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
                SalaryPostBuffer.SETRANGE("Account Code", TaxAccount[TaxLine]);
                SalaryPostBuffer.SETRANGE("Employee Code", SalaryPostBuffer."Employee Code");
                /* Commented Because client wants the tax details employee wise
                IF PRSetup."Posting Method" = PRSetup."Posting Method"::"Employee Wise" THEN
                  SalaryPostBuffer.SETRANGE("Employee Code",SalaryPostBuffer."Employee Code");
                ELSE BEGIN
                   SalaryPostBuffer.SETRANGE("Global Dimension 1 Code",SalaryLine."Global Dimension 1 Code");
                   SalaryPostBuffer.SETRANGE("Global Dimension 2 Code",SalaryLine."Global Dimension 2 Code");
                END;
                */
                IF SalaryPostBuffer.FINDFIRST THEN BEGIN
                    SalaryPostBuffer.Amount -= TempTaxAmount;
                    SalaryPostBuffer.MODIFY;
                END
                ELSE BEGIN
                    CLEAR(SalaryPostBuffer);
                    SalaryPostBuffer.INIT;
                    SalaryPostBuffer."Document No." := SalaryHeader."No.";
                    SalaryPostBuffer.Type := SalaryPostBuffer.Type::"G/L Account";
                    SalaryPostBuffer."Account Code" := TaxAccount[TaxLine];
                    SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
                    SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
                    SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
                    /*Commented Because client wants the tax details employee wise
                    IF PRSetup."Posting Method" = PRSetup."Posting Method"::"Employee Wise" THEN
                      SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
                     */
                    SalaryPostBuffer.Amount := -TempTaxAmount;
                    TaxAmount[TaxLine] := TempTaxAmount;
                    SalaryPostBuffer.INSERT;
                END;
            END;
        END;

    end;

    [Scope('Internal')]
    procedure InsertBasicLine(AddContribution: Boolean; ContributionValue: Decimal)
    begin
        IF NOT SalaryHeader."Irregular Process" THEN BEGIN
            SalaryPostBuffer.RESET;
            SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
            SalaryPostBuffer.SETRANGE("Account Code", PRSetup."Salary Account");
            IF PRSetup."Posting Method" = PRSetup."Posting Method"::"Employee Wise" THEN
                SalaryPostBuffer.SETRANGE("Employee Code", SalaryPostBuffer."Employee Code")
            ELSE BEGIN
                SalaryPostBuffer.SETRANGE("Global Dimension 1 Code", SalaryLine."Global Dimension 1 Code");
                SalaryPostBuffer.SETRANGE("Global Dimension 2 Code", SalaryLine."Global Dimension 2 Code");
            END;
            IF SalaryPostBuffer.FINDFIRST THEN BEGIN
                IF AddContribution THEN
                    SalaryPostBuffer.Amount := SalaryPostBuffer.Amount + ContributionValue
                ELSE
                    SalaryPostBuffer.Amount := SalaryPostBuffer.Amount + SalaryLine."Basic with Grade";
                SalaryPostBuffer.MODIFY;
            END
            ELSE BEGIN
                CLEAR(SalaryPostBuffer);
                SalaryPostBuffer.INIT;
                SalaryPostBuffer."Document No." := SalaryHeader."No.";
                SalaryPostBuffer.Type := SalaryPostBuffer.Type::"G/L Account";
                SalaryPostBuffer."Account Code" := PRSetup."Salary Account";
                SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
                SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
                IF PRSetup."Posting Method" = PRSetup."Posting Method"::"Employee Wise" THEN
                    SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
                IF AddContribution THEN
                    SalaryPostBuffer.Amount := ContributionValue
                ELSE
                    SalaryPostBuffer.Amount := SalaryLine."Basic with Grade";
                SalaryPostBuffer.INSERT;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure InsertBalancingLine()
    var
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
    begin
        SalaryCreditAssign.RESET;
        SalaryCreditAssign.SETRANGE("Salary Header No.", SalaryHeader."No.");
        IF SalaryCreditAssign.FINDSET THEN
            REPEAT
                IF SalaryCreditAssign.Type = SalaryCreditAssign.Type::"Bank Account" THEN
                    AccountType := AccountType::"Bank Account"
                ELSE
                    AccountType := AccountType::"G/L Account";
                CLEAR(SalaryPostBuffer);
                SalaryPostBuffer.INIT;
                SalaryPostBuffer."Document No." := SalaryHeader."No.";
                SalaryPostBuffer.Type := AccountType;
                SalaryPostBuffer."Account Code" := SalaryCreditAssign.Code;
                SalaryPostBuffer."Global Dimension 1 Code" := SalaryCreditAssign."Global Dimension 1 Code";
                SalaryPostBuffer."Global Dimension 2 Code" := SalaryCreditAssign."Global Dimension 2 Code";
                SalaryPostBuffer.Amount := -(SalaryCreditAssign.Amount);
                SalaryPostBuffer."Balancing Line" := TRUE;
                SalaryPostBuffer.INSERT;
            UNTIL SalaryCreditAssign.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure InsertBalancingLine2()
    var
        CreditAmount: Decimal;
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
    begin
        /*SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.",SalaryHeader."No.");
        IF PRSetup."Posting Method" = PRSetup."Posting Method"::"Employee Wise" THEN BEGIN
          SalaryPostBuffer.SETRANGE("Employee Code",SalaryPostBuffer."Employee Code");
          SalaryPostBuffer.SETFILTER("Employee Filter",SalaryPostBuffer."Employee Code");
        END
        ELSE BEGIN
           SalaryPostBuffer.SETRANGE("Global Dimension 1 Code",SalaryLine."Global Dimension 1 Code");
           SalaryPostBuffer.SETRANGE("Global Dimension 2 Code",SalaryLine."Global Dimension 2 Code");
           SalaryPostBuffer.SETFILTER("Global Dimension 1 Filter",SalaryLine."Global Dimension 1 Code");
           SalaryPostBuffer.SETFILTER("Global Dimension 2 Filter",SalaryLine."Global Dimension 2 Code");
        END;
        IF SalaryPostBuffer.FINDFIRST THEN BEGIN
           SalaryPostBuffer.CALCFIELDS("Total Amount");
           CreditAmount := -SalaryPostBuffer."Total Amount";
           IF SalaryCreditAssign.Amount >= ABS(CreditAmount) THEN BEGIN
            SalaryCreditAssign.Amount -= ABS(CreditAmount);
           END
           ELSE BEGIN
            SalaryCreditAssign.NEXT;
            SalaryCreditAssign.Amount -= ABS(CreditAmount);
           END;
           SalaryCreditAssign.MODIFY;
        
           IF SalaryCreditAssign.Type = SalaryCreditAssign.Type::"Bank Account" THEN
             AccountType := AccountType::"Bank Account"
           ELSE
            AccountType := AccountType::"G/L Account";
           SalaryPostBuffer.SETRANGE("Balancing Line",TRUE);
           SalaryPostBuffer.SETRANGE(Type,AccountType);
           SalaryPostBuffer.SETRANGE("Account Code",SalaryCreditAssign.Code);
           IF SalaryPostBuffer.FINDFIRST THEN
            SalaryPostBuffer.DELETE;
           SalaryPostBuffer.INIT;
           SalaryPostBuffer."Document No." := SalaryHeader."No.";
           SalaryPostBuffer.Type := AccountType;
           SalaryPostBuffer."Account Code" :=SalaryCreditAssign.Code;
           SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
           SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
           IF PRSetup."Posting Method" = PRSetup."Posting Method"::"Employee Wise" THEN
             SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
           SalaryPostBuffer.Amount := CreditAmount;
           SalaryPostBuffer."Balancing Line" := TRUE;
           SalaryPostBuffer.INSERT;
        END
        ELSE BEGIN
        END;
        */

    end;

    [Scope('Internal')]
    procedure EvaluateFields(IDValue: Integer): Decimal
    var
        i: Integer;
        VFieldID: Integer;
        ComponentID: Code[20];
    begin
        CASE IDValue OF
            33020500:
                BEGIN
                    IF SalaryLine."Variable Field 33020500" <> 0 THEN
                        EXIT(SalaryLine."Variable Field 33020500");
                END;
            33020501:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020501");
                END;
            33020502:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020502");
                END;
            33020503:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020503");
                END;
            33020504:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020504");
                END;
            33020505:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020505");
                END;
            33020506:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020506");
                END;
            33020507:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020507");
                END;
            33020508:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020508");
                END;
            33020509:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020509");
                END;
            33020510:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020510");
                END;
            33020511:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020511");
                END;
            33020512:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020512");
                END;
            33020513:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020513");
                END;
            33020514:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020514");
                END;
            33020515:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020515");
                END;
            33020516:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020516");
                END;
            33020517:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020517");
                END;
            33020518:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020518");
                END;
            33020519:
                BEGIN
                    EXIT(SalaryLine."Variable Field 33020519");
                END;
            ELSE BEGIN
                EXIT(0);
            END;

        END;
    end;

    [Scope('Internal')]
    procedure GetTaxAccount(): Integer
    begin
        TaxAccount[1] := PRSetup."Income Tax Account 1";
        IF PRSetup."Income Tax Account 2" <> '' THEN BEGIN
            TaxAccount[2] := PRSetup."Income Tax Account 2";
            EXIT(2);
        END
        ELSE BEGIN
            EXIT(1);
        END;
    end;

    [Scope('Internal')]
    procedure SplitTaxAmount(var TempTaxAmount: Decimal; TaxLineNo: Integer)
    var
        TaxLine: Record "33020506";
        Employee: Record "5200";
        FirstSlabTaxAmount: Decimal;
    begin
        IF TaxAccountCount > 1 THEN BEGIN
            IF TaxLineNo > 1 THEN BEGIN
                TempTaxAmount := SalaryLine."Tax Paid on Second Account";//SalaryLine."Tax for Period" - TempTaxAmount;
                                                                         //MESSAGE('temptaxamount line 1--->'+FORMAT(TempTaxAmount));
            END
            ELSE BEGIN
                Employee.GET(SalaryLine."Employee No.");
                TaxLine.RESET;
                TaxLine.SETRANGE(Code, Employee."Tax Code");
                IF TaxLine.FINDFIRST THEN BEGIN
                    //FirstSlabTaxAmount := (TaxLine."End Amount"-TaxLine."Start Amount")*(TaxLine."Tax Rate"/100.0);
                    //IF FirstSlabTaxAmount <= SalaryLine."Tax for Period" THEN
                    TempTaxAmount := SalaryLine."Tax Paid on First Account";//FirstSlabTaxAmount
                                                                            //ELSE
                                                                            //TempTaxAmount := SalaryLine."Tax for Period";
                                                                            //MESSAGE('temptaxamount line 2--->'+FORMAT(TempTaxAmount));
                END;
            END;
        END
        ELSE
            TempTaxAmount := SalaryLine."Tax for Period";
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
    procedure InsertGratuityLine()
    var
        TDSPostingGrp: Record "33019849";
    begin
        //PRMGT1.00
        SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
        SalaryPostBuffer.SETRANGE("Employee Code", SalaryLine."Employee No.");
        SalaryPostBuffer.SETRANGE("Account Code", PRSetup."Gratuity Expense A/c");
        IF NOT SalaryPostBuffer.FINDFIRST THEN BEGIN
            CLEAR(SalaryPostBuffer);
            SalaryPostBuffer.INIT;
            SalaryPostBuffer."Document No." := SalaryHeader."No.";
            SalaryPostBuffer.Type := SalaryPostBuffer.Type::"G/L Account";
            SalaryPostBuffer."Account Code" := PRSetup."Gratuity Expense A/c";
            SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
            SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
            SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
            SalaryPostBuffer.Amount := SalaryLine.Gratuity;
            SalaryPostBuffer."TDS Group" := PRSetup."TDS Group";
            SalaryPostBuffer.INSERT;
        END;
        /*
        TDSPostingGrp.GET(PRSetup."TDS Group");
        SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.",SalaryHeader."No.");
        SalaryPostBuffer.SETRANGE("Employee Code",SalaryLine."Employee No.");
        SalaryPostBuffer.SETRANGE("Account Code",TDSPostingGrp."GL Account No.");
        IF NOT SalaryPostBuffer.FINDFIRST THEN BEGIN
          CLEAR(SalaryPostBuffer);
          SalaryPostBuffer.INIT;
          SalaryPostBuffer."Document No." := SalaryHeader."No.";
          SalaryPostBuffer.Type := SalaryPostBuffer.Type::"G/L Account";
          SalaryPostBuffer."Account Code" := TDSPostingGrp."GL Account No.";
          SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
          SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
          SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
          SalaryPostBuffer.Amount := -SalaryLine."Gratuity TDS Payable";
          SalaryPostBuffer.INSERT;
        END;
        */
        SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
        SalaryPostBuffer.SETRANGE("Employee Code", SalaryLine."Employee No.");
        SalaryPostBuffer.SETRANGE("Account Code", PRSetup."Gratuity Payable A/c");
        IF NOT SalaryPostBuffer.FINDFIRST THEN BEGIN
            CLEAR(SalaryPostBuffer);
            SalaryPostBuffer.INIT;
            SalaryPostBuffer."Document No." := SalaryHeader."No.";
            SalaryPostBuffer.Type := SalaryPostBuffer.Type::"G/L Account";
            SalaryPostBuffer."Account Code" := PRSetup."Gratuity Payable A/c";
            SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
            SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
            SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
            SalaryPostBuffer.Amount := -SalaryLine.Gratuity;
            SalaryPostBuffer.INSERT;
        END;

    end;

    [Scope('Internal')]
    procedure EmailSalarySheetAttachment(EmailSalaryLine: Record "33020513")
    var
        EmpRec: Record "5200";
        MailTo: Text;
        Dear: Text;
        Subject: Text;
        MessageText: Text;
        EmailSalaryHdr: Record "33020512";
        EmailBody: Text;
        SMTPMailSetup: Record "409";
        SMTPMail: Codeunit "400";
        Salarysheet: Report "33020502";
        FileName: Text;
        EmployeeRec: Record "5200";
        CCMail: Text;
        FileDirectory: Text;
        FileManagement: Codeunit "419";
    begin
        EmailSalaryHdr.RESET;
        EmailSalaryHdr.SETRANGE("No.", EmailSalaryLine."Document No.");
        EmailSalaryHdr.SETRANGE("Employee Filter", EmailSalaryLine."Employee No.");
        EmailSalaryHdr.FINDFIRST;
        /*
        EmployeeRec.RESET;
        EmployeeRec.SETFILTER("Department Name",'Human Resource Department');
        IF EmployeeRec.FINDFIRST THEN REPEAT
          IF EmployeeRec."Company E-Mail" <> '' THEN  //Agni UPG 2009
            CCMail += ';'+EmployeeRec."Company E-Mail";
        UNTIL EmployeeRec.NEXT =0;
        */
        EmpRec.GET(EmailSalaryLine."Employee No.");
        IF EmpRec."Company E-Mail" <> '' THEN BEGIN
            MailTo := EmpRec."Company E-Mail";

            Dear := 'Dear Sir/Madam,';
            Subject := 'Salary Statement of ' + FORMAT(EmailSalaryHdr."Nepali Month");
            MessageText := 'Please find the attached salary statement.';

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
            EmailBody := EmailBody + Dear + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                           + 'HR Department' + '<br><br><hr>';
            FileName := 'Salary Sheet (' + FORMAT(EmailSalaryHdr."Nepali Month") + ')_' + EmpRec.FullName;
            SMTPMailSetup.GET;
            SMTPMail.CreateMessage(CompanyInfo.Name, SMTPMailSetup."User ID", MailTo, Subject, EmailBody, TRUE);
            //SMTPMail.AddCC(CCMail);

            //    Salarysheet.SETTABLEVIEW(EmailSalaryHdr);
            //    Salarysheet.SAVEASPDF(PayrollSetup."Salary Statement File Path"+'/'+FileName+'.pdf');
            //    SMTPMail.AddAttachment(PayrollSetup."Salary Statement File Path"+'/'+FileName+'.pdf',FileName+'.pdf'); //For Attachment
            FileDirectory := FileManagement.ServerTempFileName('pdf');
            REPORT.SAVEASPDF(33020502, FileDirectory, EmailSalaryHdr);
            SMTPMail.AddAttachment(FileDirectory, FileName + '.pdf');
            IF NOT SMTPMail.TrySend THEN
                ERROR('email not sent');
        END;

    end;

    [Scope('Internal')]
    procedure InsertSSFLine()
    var
        TDSPostingGrp: Record "33019849";
    begin
        SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
        SalaryPostBuffer.SETRANGE("Employee Code", SalaryLine."Employee No.");
        SalaryPostBuffer.SETRANGE("Account Code", PRSetup."SSF Expense A/c");
        IF NOT SalaryPostBuffer.FINDFIRST THEN BEGIN
            CLEAR(SalaryPostBuffer);
            SalaryPostBuffer.INIT;
            SalaryPostBuffer."Document No." := SalaryHeader."No.";
            SalaryPostBuffer.Type := SalaryPostBuffer.Type::"G/L Account";
            SalaryPostBuffer."Account Code" := PRSetup."SSF Expense A/c";
            SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
            SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
            SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
            SalaryPostBuffer.Amount := SalaryLine."SSF(1.67 %)";
            SalaryPostBuffer."TDS Group" := PRSetup."TDS Group";
            SalaryPostBuffer.INSERT;
        END;

        SalaryPostBuffer.RESET;
        SalaryPostBuffer.SETRANGE("Document No.", SalaryHeader."No.");
        SalaryPostBuffer.SETRANGE("Employee Code", SalaryLine."Employee No.");
        SalaryPostBuffer.SETRANGE("Account Code", PRSetup."SSF Payable A/c");
        IF NOT SalaryPostBuffer.FINDFIRST THEN BEGIN
            CLEAR(SalaryPostBuffer);
            SalaryPostBuffer.INIT;
            SalaryPostBuffer."Document No." := SalaryHeader."No.";
            SalaryPostBuffer.Type := SalaryPostBuffer.Type::"G/L Account";
            SalaryPostBuffer."Account Code" := PRSetup."SSF Payable A/c";
            SalaryPostBuffer."Global Dimension 1 Code" := SalaryLine."Global Dimension 1 Code";
            SalaryPostBuffer."Global Dimension 2 Code" := SalaryLine."Global Dimension 2 Code";
            SalaryPostBuffer."Employee Code" := SalaryLine."Employee No.";
            SalaryPostBuffer.Amount := -SalaryLine."SSF(1.67 %)";
            SalaryPostBuffer.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure LeaveEncshLedgerInsert(SalaryPlanLine: Record "33020511")
    var
        LeaveEncashLedger: Record "33020529";
        EngNep: Record "33020302";
    begin
        EngNep.RESET;
        EngNep.SETRANGE("English Date", TODAY);
        IF EngNep.FINDFIRST THEN;
        CLEAR(LeaveEncashLedger);
        LeaveEncashLedger.INIT;
        LeaveEncashLedger."Employee No." := SalaryPlanLine."Employee No.";
        LeaveEncashLedger.Type := LeaveEncashLedger.Type::Encashed;
        LeaveEncashLedger."Fiscal Year" := EngNep."Fiscal Year";
        LeaveEncashLedger."Register Date" := TODAY;
        LeaveEncashLedger."User Id" := USERID;
        LeaveEncashLedger.Days := -SalaryPlanLine."Leave Encash Days";
        LeaveEncashLedger.INSERT(TRUE);
    end;
}

