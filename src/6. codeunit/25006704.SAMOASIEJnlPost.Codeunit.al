codeunit 25006704 "SAMOA SIE Jnl.-Post"
{
    TableNo = 25006702;

    trigger OnRun()
    begin
        SIEJnlLine.COPY(Rec);
        Code;
        Rec.COPY(SIEJnlLine);
    end;

    var
        GLSetup: Record "98";
        SIEJnlLine: Record "25006702";
        SIEJnlLineB: Record "25006702";
        SIEJnlLineL: Record "25006702";
        DimMgt: Codeunit "408";
        SIERegL: Record "25006709";
        NextEntryNoL: Integer;
        TempJnlBatchName: Code[10];
        GLSetupRead: Boolean;
        Txt001: Label 'In Journal Line No. %1 are empty mandatory fields: %2';
        Txt002: Label 'Can''t find SIE %1 with number %2.';

    [Scope('Internal')]
    procedure "Code"()
    var
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
    begin

        IF "To Validate Field" <> 0 THEN BEGIN
            ValidateField(SIEJnlLine);
            "To Validate Field" := 0;
            EXIT
        END;


        IF GUIALLOWED THEN
            IF NOT CONFIRM(Text001, FALSE) THEN
                EXIT;

        TempJnlBatchName := SIEJnlLine."Journal Batch Name";

        SIEPostBatchRun(SIEJnlLine);

        IF SIEJnlLine."Line No." = 0 THEN
            IF GUIALLOWED THEN
                MESSAGE(Text002)
            ELSE
                IF TempJnlBatchName = SIEJnlLine."Journal Batch Name" THEN
                    IF GUIALLOWED THEN
                        MESSAGE(Text003)
                    ELSE
                        IF GUIALLOWED THEN
                            MESSAGE(
                              Text004,
                                SIEJnlLine."Journal Batch Name");

        IF NOT SIEJnlLine.FINDSET OR (TempJnlBatchName <> SIEJnlLine."Journal Batch Name") THEN BEGIN
            SIEJnlLine.RESET;
            SIEJnlLine.FILTERGROUP := 2;
            SIEJnlLine.SETRANGE("Journal Template Name", SIEJnlLine."Journal Template Name");
            SIEJnlLine.SETRANGE("Journal Batch Name", SIEJnlLine."Journal Batch Name");
            SIEJnlLine.FILTERGROUP := 0;
            SIEJnlLine."Line No." := 1;
        END;
    end;

    [Scope('Internal')]
    procedure SIEPostLineRunWithCheck(var SIEJnlLine2: Record "25006702")
    begin

        SIEJnlLineL.COPY(SIEJnlLine2);


        SIEPostLineCode;
        SIEJnlLine2 := SIEJnlLineL;
    end;

    [Scope('Internal')]
    procedure SIEPostLineRunCheck(var JnlLine: Record "25006702"): Boolean
    var
        SIEExchMgt: Codeunit "25006701";
        ResVar: Text[150];
    begin
        JnlLine.TESTFIELD(Posted, FALSE);
        IF JnlLine."Not Passed Auto Check" THEN EXIT(FALSE);
        ResVar := SIEExchMgt.CheckMandatoryFields(JnlLine);
        IF ResVar <> '' THEN BEGIN
            IF GUIALLOWED THEN
                ERROR(Txt001, JnlLine."Line No.", ResVar);

            JnlLine."Not Passed Auto Check" := TRUE;
            JnlLine.MODIFY;
            EXIT(FALSE)
        END;
        EXIT(TRUE)
    end;

    [Scope('Internal')]
    procedure SIEPostLineCode()
    var
        SIELedgEntry: Record "25006703";
    begin
        IF EmptyLine(SIEJnlLineL) THEN
            EXIT;

        //  IF NOT SIEPostLineRunCheck(SIEJnlLineL,TempJnlLineDimL) THEN EXIT;//30.10.2012 EDMS
        IF NOT SIEPostLineRunCheck(SIEJnlLineL) THEN EXIT;//30.10.2012 EDMS

        SIELedgEntry.RESET;
        IF NextEntryNoL = 0 THEN BEGIN
            SIELedgEntry.LOCKTABLE;
            IF SIELedgEntry.FINDLAST THEN
                NextEntryNoL := SIELedgEntry."Entry No.";
            NextEntryNoL := NextEntryNoL + 1;
        END;

        IF SIERegL."No." = 0 THEN BEGIN
            SIERegL.LOCKTABLE;
            IF (NOT SIERegL.FINDLAST) OR (SIERegL."To Entry No." <> 0) THEN BEGIN
                SIERegL.INIT;
                SIERegL."No." := SIERegL."No." + 1;
                SIERegL."From Entry No." := NextEntryNoL;
                SIERegL."To Entry No." := NextEntryNoL;
                SIERegL."Creation Date" := TODAY;
                SIERegL."Creation Time" := TIME;
                SIERegL."Source Code" := "Source Code";
                SIERegL."Journal Batch Name" := SIEJnlLineL."Journal Batch Name";
                SIERegL."User ID" := USERID;
                SIERegL.INSERT;
            END;
        END;
        SIERegL."To Entry No." := NextEntryNoL;
        SIERegL.MODIFY;

        SIELedgEntry.INIT;

        SIELedgEntry."Location Code" := SIEJnlLineL."Code10 1";
        SIELedgEntry."Code20 1" := "Code20 2";    //Bin
        SIELedgEntry."Code20 2" := "Code20 3";    //Item

        SIELedgEntry.Quantity := SIEJnlLineL."Decimal 3";
        SIELedgEntry."External Document No." := "Code20 1"; //Document No
        SIELedgEntry."SIE No." := SIEJnlLineL."SIE No.";

        SIELedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
        SIELedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
        SIELedgEntry."Source Code" := "Source Code";
        SIELedgEntry."Journal Batch Name" := SIEJnlLineL."Journal Batch Name";
        SIELedgEntry."Posting Date" := WORKDATE;
        SIELedgEntry.Description := Description;
        SIELedgEntry."User ID" := USERID;
        SIELedgEntry."Entry No." := NextEntryNoL;
        SIELedgEntry."Int 1" := SIEJnlLineL."Int 1";  //Transaction ID
        SIELedgEntry."Int 2" := SIEJnlLineL."Int 2";  //Control Panel
        SIELedgEntry."Int 3" := SIEJnlLineL."Int 3";  //Pistol No
        SIELedgEntry."Int 4" := SIEJnlLineL."Int 4";  //Bin
        SIELedgEntry."Int 5" := SIEJnlLineL."Int 5";  //Suppl. Nr.
        SIELedgEntry."Int 6" := SIEJnlLineL."Int 6";  //Group
        SIELedgEntry."Decimal 1" := SIEJnlLineL."Decimal 1";  //Qty. Demanded
        SIELedgEntry."Decimal 2" := SIEJnlLineL."Decimal 2";  //Qty. purified
        SIELedgEntry."Decimal 3" := SIEJnlLineL."Decimal 4";  //Qty Remaining
        SIELedgEntry."Date 1" := SIEJnlLineL."Date 1";  //Tran. date
        SIELedgEntry."Time 1" := SIEJnlLineL."Time 1";  //Tran. time
        SIELedgEntry."Text50 1" := SIEJnlLineL."Text50 1"; //Resource

        SIELedgEntry.INSERT;

        NextEntryNoL := NextEntryNoL + 1;
    end;

    [Scope('Internal')]
    procedure SIEPostLineRun(var SIEJnlLine: Record "25006702")
    begin
        GetGLSetup;

        SIEPostLineRunWithCheck(SIEJnlLine);
        //30.10.2012 EDMS <<
    end;

    [Scope('Internal')]
    procedure EmptyLine(JnlLine: Record "25006702"): Boolean
    begin
        EXIT(JnlLine."Decimal 3" = 0)
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    [Scope('Internal')]
    procedure SIEPostBatchRun(var SIEJnlLineBRec: Record "25006702")
    begin
        SIEJnlLineB.COPY(SIEJnlLineBRec);
        SIEPostBatchCode;
        SIEJnlLineBRec := SIEJnlLineB;
    end;

    local procedure SIEPostBatchCode()
    var
        SIEJnlLine2: Record "25006702";
        SIEJnlLine3: Record "25006702";
        SIELedgEntry: Record "25006703";
        SIEReg: Record "25006709";
        NoSeries: Record "308" temporary;
        NoSeriesMgt: Codeunit "396";
        NoSeriesMgt2: array[10] of Codeunit "396";
        Window: Dialog;
        LineCount: Integer;
        StartLineNo: Integer;
        NoOfRecords: Integer;
        SIERegNo: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        Text000: Label 'cannot exceed %1 characters';
        Text001: Label 'Journal Batch Name    #1##########\\';
        Text002: Label 'Checking lines        #2######\';
        Text003: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@\';
        Text004: Label 'Updating lines        #5###### @6@@@@@@@@@@@@@';
        Text005: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: Label 'A maximum of %1 posting number series can be used in each journal.';
        Text007: Label '<Month Text>';
        PostingNoSeriesNo: Integer;
    begin
        SIEJnlLineB.SETRANGE("Journal Template Name", SIEJnlLineB."Journal Template Name");
        SIEJnlLineB.SETRANGE("Journal Batch Name", SIEJnlLineB."Journal Batch Name");
        SIEJnlLineB.SETRANGE(Posted, FALSE);
        SIEJnlLineB.SETRANGE("Not Passed Auto Check", FALSE);
        IF SIEJnlLineB.RECORDLEVELLOCKING THEN
            SIEJnlLineB.LOCKTABLE;
        IF NOT SIEJnlLineB.FINDSET THEN BEGIN
            SIEJnlLineB."Line No." := 0;
            COMMIT;
            EXIT;
        END;
        IF GUIALLOWED THEN
            Window.OPEN(
              Text001 +
              Text002 +
              Text005);
        IF GUIALLOWED THEN
            Window.UPDATE(1, SIEJnlLineB."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := SIEJnlLineB."Line No.";
        REPEAT
            LineCount := LineCount + 1;
            IF GUIALLOWED THEN
                Window.UPDATE(2, LineCount);


            //30.10.2012 EDMS >>
            SIEPostLineRunCheck(SIEJnlLineB);
            //30.10.2012 EDMS <<
            IF SIEJnlLineB.NEXT = 0 THEN
                SIEJnlLineB.FINDFIRST;
        UNTIL SIEJnlLineB."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        //  LedgEntryDim.LOCKTABLE;//30.10.2012 EDMS
        SIELedgEntry.LOCKTABLE;
        IF SIEJnlLineB.RECORDLEVELLOCKING THEN
            IF SIELedgEntry.FINDLAST THEN;
        SIEReg.LOCKTABLE;
        IF SIEReg.FINDLAST AND (SIEReg."To Entry No." = 0) THEN
            SIERegNo := SIEReg."No."
        ELSE
            SIERegNo := SIEReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        SIEJnlLineB.FINDSET;
        CLEAR(SIERegL);  // Needed because of inexistence of post-line codeunit
        REPEAT
            LineCount := LineCount + 1;
            IF GUIALLOWED THEN Window.UPDATE(3, LineCount);
            IF GUIALLOWED THEN Window.UPDATE(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            //LastDocNo2 := "Document No.";
            SIEPostBatchMakeRecurringTexts(SIEJnlLineB);
            IF "Posting No. Series" = '' THEN
                "Posting No. Series" := ''// SIEJnlBatch."No. Series"
            ELSE
                IF NOT EmptyLine(SIEJnlLineB) THEN
                    IF "Document No." = LastDocNo THEN
                        "Document No." := LastPostedDocNo
                    ELSE BEGIN
                        IF NOT NoSeries.GET("Posting No. Series") THEN BEGIN
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            IF NoOfPostingNoSeries > ARRAYLEN(NoSeriesMgt2) THEN
                                ERROR(
                                  Text006,
                                  ARRAYLEN(NoSeriesMgt2));
                            NoSeries.Code := "Posting No. Series";
                            NoSeries.Description := FORMAT(NoOfPostingNoSeries);
                            NoSeries.INSERT;
                        END;
                        LastDocNo := "Document No.";
                        EVALUATE(PostingNoSeriesNo, NoSeries.Description);
                        "Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series", "Posting Date", FALSE);
                        LastPostedDocNo := "Document No.";
                    END;

            //30.10.2012 EDMS >>
            SIEPostLineRunWithCheck(SIEJnlLineB)
        //30.10.2012 EDMS <<

        UNTIL SIEJnlLineB.NEXT = 0;

        IF NOT SIEReg.FINDLAST OR (SIEReg."No." <> SIERegNo) THEN
            SIERegNo := 0;

        SIEJnlLineB.INIT;
        SIEJnlLineB."Line No." := SIERegNo;

        // Update/delete lines
        IF SIERegNo <> 0 THEN BEGIN
            IF NOT SIEJnlLineB.RECORDLEVELLOCKING THEN BEGIN
                SIEJnlLineB.LOCKTABLE(TRUE, TRUE);
            END;

            SIEJnlLine2.COPYFILTERS(SIEJnlLineB);
            SIEJnlLine2.SETFILTER("SIE No.", '<>%1', '');
            IF SIEJnlLine2.FINDLAST THEN; // Remember the last line


            SIEJnlLine3.COPY(SIEJnlLineB);
            IF SIEJnlLine3.FINDSET THEN
                REPEAT


                    SIEJnlLine3.DELETE;
                UNTIL SIEJnlLine3.NEXT = 0;
            SIEJnlLine3.RESET;
            SIEJnlLine3.SETRANGE("Journal Template Name", SIEJnlLineB."Journal Template Name");
            SIEJnlLine3.SETRANGE("Journal Batch Name", SIEJnlLineB."Journal Batch Name");

        END;
        COMMIT;

        COMMIT;
    end;

    local procedure SIEPostBatchMakeRecurringTexts(var SIEJnlLine2: Record "25006702")
    var
        Day: Integer;
        Month: Integer;
        Week: Integer;
        MonthText: Text[30];
        AccountingPeriod: Record "50";
        Text007: Label '<Month Text>';
    begin
        IF (SIEJnlLine2."SIE No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN
            Day := DATE2DMY("Posting Date", 1);
            Week := DATE2DWY("Posting Date", 2);
            Month := DATE2DMY("Posting Date", 2);
            MonthText := FORMAT("Posting Date", 0, Text007);
            AccountingPeriod.SETRANGE("Starting Date", 0D, "Posting Date");
            IF NOT AccountingPeriod.FINDLAST THEN
                AccountingPeriod.Name := '';
            "Document No." :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO("Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN("Document No.")),
                '>');
            Description :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO(Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN(Description)),
                  '>');
        END;
    end;

    [Scope('Internal')]
    procedure ValidateField(var JnlLine: Record "25006702")
    var
        SIEJnlLine: Record "25006702";
        Item: Record "27";
    begin
        CASE "To Validate Field" OF
            JnlLine.FIELDNO("Int 4"):          //SIEBin
                BEGIN
                    GetLocBinBySIEBin(JnlLine."SIE No.", JnlLine."Int 4",
                    JnlLine."Code10 1",             //Location
                    JnlLine."Code20 2");           //Bin Code
                    GetItemByBin(JnlLine."Code10 1", JnlLine."Code20 2",
                    JnlLine."Code20 3");         //Item No.
                    IF GUIALLOWED THEN
                        Item.GET(JnlLine."Code20 3")
                    ELSE
                        IF NOT Item.GET(JnlLine."Code20 3") THEN EXIT;
                    Description := Item.Description
                END
        END
    end;

    [Scope('Internal')]
    procedure GetItemByBin(Loc: Code[10]; Bin: Code[20]; var ItemNo: Code[20])
    var
        BinCont: Record "7302";
    begin
        BinCont.RESET;
        BinCont.SETCURRENTKEY(Default, "Location Code");
        BinCont.SETRANGE("Location Code", Loc);
        BinCont.SETRANGE("Bin Code", Bin);
        BinCont.SETRANGE(Default, TRUE);
        IF BinCont.FINDFIRST THEN;
        CASE TRUE OF
            BinCont.COUNT > 1:
                IF NOT GUIALLOWED THEN
                    ItemNo := '';
            BinCont.COUNT = 0:
                ItemNo := '';
            ELSE
                ItemNo := BinCont."Item No."
        END;
    end;

    [Scope('Internal')]
    procedure GetLocBinBySIEBin(SIENo: Code[10]; SIEBin: Integer; var LocCode: Code[10]; var BinCode: Code[20])
    var
        SIEObjCat: Record "25006708";
        Bin: Record "7354";
        SIEObject: Record "25006707";
    begin
        SIEObjCat.RESET;
        SIEObjCat.SETRANGE(SYSType, SIEObjCat.SYSType::Bin);
        IF NOT SIEObjCat.FINDFIRST THEN
            IF GUIALLOWED THEN
                ERROR(Txt001, SIEObjCat.TABLECAPTION)
            ELSE
                EXIT;
        SIEObject.RESET;
        SIEObject.SETRANGE("SIE No.", SIENo);
        SIEObject.SETRANGE(Category, SIEObjCat."No.");
        SIEObject.SETRANGE("No.", FORMAT(SIEBin));
        IF NOT SIEObject.FINDFIRST THEN
            IF GUIALLOWED THEN
                ERROR(Txt002, SIEObjCat.SYSType, SIEBin)
            ELSE
                EXIT;
        IF GUIALLOWED THEN
            Bin.GET("NAV No.", "NAV No. 2")
        ELSE
            IF NOT Bin.GET("NAV No.", "NAV No. 2") THEN EXIT;
        LocCode := "NAV No.";
        BinCode := "NAV No. 2"
    end;
}

