codeunit 33020063 "Create VF Journals"
{

    trigger OnRun()
    begin
    end;

    var
        GenJnlLine: Record "81";
        GenJnlBatch: Record "232";
        LineNo: Integer;
        NoSeriesMgt: Codeunit "396";
        ok: Boolean;
        VFSetup: Record "33020064";
        TemplateName: Code[10];
        DocNo: Code[20];
        UserSetup: Record "91";
        NoSeries: Code[20];
        ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit;
        ClearLoan: Boolean;
        SourceCodeSetup: Record "242";
        TraceID: Text[80];

    [Scope('Internal')]
    procedure LoanApproval(PostingDate: Date; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]; Description: Text[50]; Amount: Decimal; LoanFileNo: Code[20]; VehicleNo: Code[20]; JournalBatch: Code[10]; GD1: Code[20]; GD2: Code[20]; InstallmentNo: Integer; VFPostingType: Option " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges",Prepayment,"Insurance Interest","Interest on CAD",Capitalization; LoanDisbureseEntry: Boolean; NewNoseries: Boolean; DocumentDate: Date; LoanDisbursedEntry: Boolean; TempReceiptNo: Code[20]; Narration: Text[250]; GD3: Code[20])
    var
        DimMgt: Codeunit "408";
    begin
        IF ROUND(Amount, 0.01, '=') = 0 THEN
            EXIT;
        VFSetup.GET;
        VFSetup.TESTFIELD("VF Journal Template Name");
        //VFSetup.TESTFIELD("VB Journal Batch Name");
        IF UserSetup.GET(USERID) THEN
            UserSetup.TESTFIELD("VF Posting Batch");

        JournalBatch := UserSetup."VF Posting Batch";
        TemplateName := VFSetup."VF Journal Template Name";

        GenJnlLine.RESET;

        IF LineNo = 0 THEN
            LineNo := 10000;

        SourceCodeSetup.GET;
        GenJnlBatch.GET(TemplateName, JournalBatch);
        NoSeries := GenJnlBatch."No. Series";
        GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", JournalBatch);

        IF GenJnlLine.FIND('+') THEN BEGIN
            DocNo := GenJnlLine."Document No.";
            LineNo := GenJnlLine."Line No." + 10000;
        END ELSE BEGIN
            IF GenJnlBatch."No. Series" <> '' THEN BEGIN
                COMMIT;
                CLEAR(NoSeriesMgt);
                DocNo := NoSeriesMgt.TryGetNextNo(NoSeries, PostingDate);
            END;
            LineNo := 10000;
        END;

        IF NewNoseries THEN
            IF GenJnlLine.FIND('+') THEN
                DocNo := INCSTR(GenJnlLine."Document No.");
        CLEAR(GenJnlLine);
        GenJnlLine.RESET;
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := TemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatch;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        GenJnlLine.VALIDATE("Account Type", AccountType);
        GenJnlLine.VALIDATE("Document Type", GenJnlLine."Document Type"::" ");
        GenJnlLine."VF Loan File No." := LoanFileNo;
        GenJnlLine.VALIDATE("Account No.", AccountNo);
        GenJnlLine.VALIDATE(Description, Description);
        GenJnlLine."VF Installment No." := InstallmentNo;
        GenJnlLine.Amount := Amount;
        GenJnlLine.VALIDATE("Posting Date", PostingDate);
        GenJnlLine.VALIDATE("VF Posting Type", VFPostingType);
        GenJnlLine.VALIDATE(VIN, VehicleNo);
        GenJnlLine."VF Loan Disburse Entry" := LoanDisbursedEntry;
        GenJnlLine."External Document No." := TempReceiptNo;
        GenJnlLine."Document Date" := DocumentDate;
        GenJnlLine.Narration := Narration;
        GenJnlLine."Receipt Type" := ReceiptType;
        GenJnlLine."VF Loan Clear Entry" := ClearLoan;
        GenJnlLine."Source Code" := SourceCodeSetup."Cash Receipt Journal";
        GenJnlLine."Trace ID/Ref ID" := TraceID;  //Oct 11 2017
        GenJnlLine.INSERT;
        GenJnlLine.RESET;
        GenJnlLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Line No.");
        GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", JournalBatch);
        GenJnlLine.SETRANGE("Line No.", LineNo);
        GenJnlLine.MODIFY;

        IF GenJnlLine.FINDFIRST THEN BEGIN
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", GD1);
            GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", GD2);
            GenJnlLine.MODIFY;
        END;

        GenJnlLine.ValidateShortcutDimCode(3, GD3);
        GenJnlLine.MODIFY;

        /* DimMgt.SaveJnlLineDim(
           DATABASE::"Gen. Journal Line",TemplateName,
           JournalBatch,LineNo,0,3,GD3);
         */
        /*      MESSAGE('Outer%1',GenJnlLine."Line No.");
        
        VFDocDim.RESET;
        VFDocDim.SETRANGE("Document No.",LoanFileNo);
        IF VFDocDim.FINDFIRST THEN BEGIN
        REPEAT
        MESSAGE('Inner%1 / %2',GenJnlLine."Line No.",VFDocDim."Dimension Code");
          DocDim.INIT;
          DocDim."Table ID" := 81;
          DocDim.VALIDATE("Journal Template Name",TemplateName);
          DocDim.VALIDATE("Journal Batch Name",JournalBatch);
          DocDim."Journal Line No." := GenJnlLine."Line No." +1;
          DocDim.VALIDATE("Dimension Code",VFDocDim."Dimension Code");
          DocDim.VALIDATE("Dimension Value Code",VFDocDim."Dimension Value Code");
        
          DocDim.INSERT;
        
        UNTIL VFDocDim.NEXT = 0;
        END;
         */

    end;

    [Scope('Internal')]
    procedure SetReceiptType(_ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit,"Tendor Amount","LC Amount","Cheque Returned","VF Payment",Advance)
    begin
        ReceiptType := _ReceiptType;
    end;

    [Scope('Internal')]
    procedure SetClearLoan(_ClearLoan: Boolean)
    begin
        ClearLoan := _ClearLoan;
    end;

    [Scope('Internal')]
    procedure SetTraceID(_TraceID: Text[80])
    begin
        TraceID := _TraceID
    end;
}

