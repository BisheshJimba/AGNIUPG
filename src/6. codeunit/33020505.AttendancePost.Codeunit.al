codeunit 33020505 "Attendance-Post"
{
    TableNo = 33020555;

    trigger OnRun()
    begin
        CLEARALL;
        AttJnlLine := Rec;
        /*
        IF GenJnlCheckLine.DateNotAllowed("Posting Date") THEN
          FIELDERROR("Posting Date",Text001);
        */
        SetTemplate;
        IF Rec.RECORDLEVELLOCKING THEN BEGIN
            AttJnlLine.LOCKTABLE;
            AttJnlDetail.LOCKTABLE;
        END;
        Window.OPEN(
          Text005 +
          Text003 +
          Text006 +
          Text004);
        Window.UPDATE(5, Rec."Journal Batch Name");
        Code;
        COMMIT;

    end;

    var
        AttJnlLine: Record "33020555";
        AttJnlDetail: Record "33020554";
        AttJnlLedger: Record "33020556";
        AttRegister: Record "33020557";
        AttJnlBatch: Record "33020553";
        CurrentTemplate: Code[10];
        CurrentBatch: Code[10];
        Text000: Label 'There is nothing to post.';
        GenJnlCheckLine: Codeunit "11";
        Text001: Label 'is not within your range of allowed posting dates.';
        NoSeriesMgt: Codeunit "396";
        Text002: Label 'Please resolve conflict on calculation for employee %1.';
        Window: Dialog;
        LineCount: Integer;
        Text003: Label 'Checking Lines  #1######  @2@@@@@@@@@@@@@\';
        Text004: Label 'Creating Ledger    #3######  @4@@@@@@@@@@@@@\';
        Text005: Label 'Journal Batch Name #5######\';
        NoOfRecords: Integer;
        Text006: Label 'Creating Register #6###### @7@@@@@@@@@@@@@\';
        CurrDocNo: Code[20];
        PostingNo: Code[20];
        LeaveIsEarnable: Boolean;

    [Scope('Internal')]
    procedure "Code"()
    begin
        CurrDocNo := NoSeriesMgt.GetNextNo(AttJnlBatch."No. Series", TODAY, FALSE);
        LineCount := 0;
        AttJnlLine.RESET;
        AttJnlLine.SETRANGE("Journal Template Name", CurrentTemplate);
        AttJnlLine.SETRANGE("Journal Batch Name", CurrentBatch);
        IF AttJnlLine.FINDSET THEN BEGIN
            NoOfRecords := AttJnlLine.COUNT;
            REPEAT
                LineCount += 1;
                ;
                Window.UPDATE(1, LineCount);
                Window.UPDATE(2, ROUND(LineCount / NoOfRecords * 10000, 1));
                CheckJnlLine();
            UNTIL AttJnlLine.NEXT = 0;
        END
        ELSE BEGIN
            ERROR(Text000);
        END;
        CLEAR(NoSeriesMgt);
        PostingNo := NoSeriesMgt.GetNextNo(AttJnlBatch."Posting No. Series", TODAY, FALSE);
        LineCount := 0;
        AttJnlLine.RESET;
        AttJnlLine.SETRANGE("Journal Template Name", CurrentTemplate);
        AttJnlLine.SETRANGE("Journal Batch Name", CurrentBatch);
        IF AttJnlLine.FINDSET THEN BEGIN
            NoOfRecords := AttJnlLine.COUNT;
            REPEAT
                LineCount += 1;
                ;
                Window.UPDATE(6, LineCount);
                Window.UPDATE(7, ROUND(LineCount / NoOfRecords * 10000, 1));
                PostJnlLine();
            UNTIL AttJnlLine.NEXT = 0;
        END
        ELSE BEGIN
            ERROR(Text000);
        END;
        CurrDocNo := NoSeriesMgt.GetNextNo(AttJnlBatch."No. Series", TODAY, TRUE);
        PostingNo := NoSeriesMgt.GetNextNo(AttJnlBatch."Posting No. Series", TODAY, TRUE);
        Window.CLOSE;
    end;

    [Scope('Internal')]
    procedure SetTemplate()
    begin
        CurrentTemplate := AttJnlLine."Journal Template Name";
        CurrentBatch := AttJnlLine."Journal Batch Name";
        AttJnlBatch.GET(CurrentTemplate, CurrentBatch);
    end;

    [Scope('Internal')]
    procedure CheckJnlLine()
    begin
        AttJnlLine.CALCFIELDS("Conflict Exists");
        IF "Conflict Exists" THEN
            ERROR(Text002, AttJnlLine."Employee No.");
        AttJnlLine.TESTFIELD("Posting No. Series");
        AttJnlLine.TESTFIELD("Document No.", CurrDocNo);
    end;

    [Scope('Internal')]
    procedure PostJnlLine()
    var
        LineCount: Integer;
        NoOfRecords: Integer;
    begin
        AttJnlLine.CALCFIELDS("Present Days", "Absent Days", "Paid Days");
        CLEAR(AttRegister);
        AttRegister.INIT;
        AttRegister.TRANSFERFIELDS(AttJnlLine);
        AttRegister."No." := PostingNo;
        AttRegister."Source No." := AttJnlLine."Document No.";
        AttRegister."Present Days" := AttJnlLine."Present Days";
        AttRegister."Absent Days" := "Absent Days";
        AttRegister."Paid Days" := "Paid Days";
        AttRegister.INSERT;

        IF AttJnlLine.HASLINKS THEN
            AttRegister.COPYLINKS(AttJnlLine);
        LineCount := 0;
        AttJnlDetail.RESET;
        AttJnlDetail.SETRANGE("Journal Template Name", CurrentTemplate);
        AttJnlDetail.SETRANGE("Journal Batch Name", CurrentBatch);
        AttJnlDetail.SETRANGE("Document No.", AttJnlLine."Document No.");
        AttJnlDetail.SETRANGE("Journal Line No.", AttJnlLine."Line No.");
        AttJnlDetail.SETRANGE("Employee No.", AttJnlLine."Employee No.");
        IF AttJnlDetail.FINDSET THEN BEGIN
            NoOfRecords := AttJnlDetail.COUNT;
            LeaveIsEarnable := TRUE;
            REPEAT
                LineCount += 1;
                ;
                Window.UPDATE(3, LineCount);
                Window.UPDATE(4, ROUND(LineCount / NoOfRecords * 10000, 1));
                CLEAR(AttJnlLedger);
                AttJnlLedger.INIT;
                AttJnlLedger.TRANSFERFIELDS(AttJnlDetail);
                AttJnlLedger."No." := AttRegister."No.";
                AttJnlLedger."Source No." := AttRegister."Source No.";
                AttJnlLedger.INSERT;
                IF (AttJnlDetail."Day Type" = AttJnlDetail."Day Type"::Working) AND
                  (AttJnlDetail."Entry Type" = AttJnlDetail."Entry Type"::Absent) AND
                  (AttJnlDetail."Entry Subtype" = AttJnlDetail."Entry Subtype"::" ") THEN
                    LeaveIsEarnable := FALSE;
                AttJnlLedger.COPYLINKS(AttJnlDetail);
            UNTIL AttJnlDetail.NEXT = 0;
            UpdateLeaveEarn(AttJnlLine."Employee No.");
        END;
        IF AttJnlLine.HASLINKS THEN AttJnlLine.DELETELINKS;
        AttJnlLine.DELETE;
        AttJnlDetail.DELETEALL;
    end;

    [Scope('Internal')]
    procedure UpdateLeaveEarn(EmployeeCode: Code[20])
    var
        Employee: Record "5200";
    begin
        Employee.RESET;
        Employee.SETRANGE("No.", EmployeeCode);
        IF Employee.FINDFIRST THEN BEGIN
            IF LeaveIsEarnable THEN
                Employee."Restrict Leave Earn" := FALSE
            ELSE
                Employee."Restrict Leave Earn" := TRUE;
            Employee.MODIFY;
        END;
    end;
}

