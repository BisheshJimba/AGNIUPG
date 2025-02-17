codeunit 25006108 "Serv. Jnl.-Post Batch"
{
    Permissions = TableData 25006164 = imd;
    TableNo = 25006165;

    trigger OnRun()
    begin
        ServJnlLine.COPY(Rec);
        Code;
        Rec := ServJnlLine;
    end;

    var
        Text000: Label 'cannot exceed %1 characters';
        Text001: Label 'Journal Batch Name    #1##########\\';
        Text002: Label 'Checking lines        #2######\';
        Text003: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@\';
        Text004: Label 'Updating lines        #5###### @6@@@@@@@@@@@@@';
        Text005: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: Label 'A maximum of %1 posting number series can be used in each journal.';
        Text007: Label '<Month Text>';
        ServJnlTemplate: Record "25006163";
        ServJnlBatch: Record "25006164";
        ServJnlLine: Record "25006165";
        ServJnlLine2: Record "25006165";
        ServJnlLine3: Record "25006165";
        ServLedgEntry: Record "25006167";
        ServReg: Record "25006168";
        NoSeries: Record "308" temporary;
        ServJnlCheckLine: Codeunit "25006106";
        ServJnlPostLine: Codeunit "25006107";
        NoSeriesMgt: Codeunit "396";
        NoSeriesMgt2: array[10] of Codeunit "396";
        Window: Dialog;
        ServRegNo: Integer;
        StartLineNo: Integer;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        AccountingPeriod: Record "50";
        LineCount: Integer;
        NoOfRecords: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;
        DF0: DateFormula;

    local procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "410";
    begin
        ServJnlLine.SETRANGE("Journal Template Name", ServJnlLine."Journal Template Name");
        ServJnlLine.SETRANGE("Journal Batch Name", ServJnlLine."Journal Batch Name");
        IF ServJnlLine.RECORDLEVELLOCKING THEN
            ServJnlLine.LOCKTABLE;

        ServJnlTemplate.GET(ServJnlLine."Journal Template Name");
        ServJnlBatch.GET(ServJnlLine."Journal Template Name", ServJnlLine."Journal Batch Name");
        IF STRLEN(INCSTR(ServJnlBatch.Name)) > MAXSTRLEN(ServJnlBatch.Name) THEN
            ServJnlBatch.FIELDERROR(
              Name,
              STRSUBSTNO(
                Text000,
                MAXSTRLEN(ServJnlBatch.Name)));

        IF ServJnlTemplate.Recurring THEN BEGIN
            ServJnlLine.SETRANGE("Posting Date", 0D, WORKDATE);
            ServJnlLine.SETFILTER("Expiration Date", '%1 | %2..', 0D, WORKDATE);
        END;

        IF NOT ServJnlLine.FINDSET THEN BEGIN
            ServJnlLine."Line No." := 0;
            COMMIT;
            EXIT;
        END;

        IF ServJnlTemplate.Recurring THEN
            Window.OPEN(
              Text001 +
              Text002 +
              Text003 +
              Text004)
        ELSE
            Window.OPEN(
              Text001 +
              Text002 +
              Text005);
        Window.UPDATE(1, ServJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := ServJnlLine."Line No.";
        REPEAT
            LineCount := LineCount + 1;
            Window.UPDATE(2, LineCount);
            CheckRecurringLine(ServJnlLine);
            //30.10.2012 EDMS >>
            ServJnlCheckLine.RunCheck(ServJnlLine);
            //30.10.2012 EDMS <<

            IF ServJnlLine.NEXT = 0 THEN
                ServJnlLine.FINDFIRST;
        UNTIL ServJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        //  LedgEntryDim.LOCKTABLE; //30.10.2012 EDMS
        ServLedgEntry.LOCKTABLE;
        IF ServJnlLine.RECORDLEVELLOCKING THEN
            IF ServLedgEntry.FINDLAST THEN;
        ServReg.LOCKTABLE;
        IF ServReg.FINDLAST AND (ServReg."To Entry No." = 0) THEN
            ServRegNo := ServReg."No."
        ELSE
            ServRegNo := ServReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        ServJnlLine.FINDSET;
        REPEAT
            LineCount := LineCount + 1;
            Window.UPDATE(3, LineCount);
            Window.UPDATE(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            IF NOT EmptyLine AND
               (ServJnlBatch."No. Series" <> '') AND
               (ServJnlLine."Document No." <> LastDocNo2)
            THEN
                ServJnlLine.TESTFIELD("Document No.", NoSeriesMgt.GetNextNo(ServJnlBatch."No. Series", ServJnlLine."Posting Date", FALSE));
            LastDocNo2 := ServJnlLine."Document No.";
            MakeRecurringTexts(ServJnlLine);
            IF "Posting No. Series" = '' THEN
                "Posting No. Series" := ServJnlBatch."No. Series"
            ELSE
                IF NOT EmptyLine THEN
                    IF ServJnlLine."Document No." = LastDocNo THEN
                        ServJnlLine."Document No." := LastPostedDocNo
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
                        LastDocNo := ServJnlLine."Document No.";
                        EVALUATE(PostingNoSeriesNo, NoSeries.Description);
                        ServJnlLine."Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series", ServJnlLine."Posting Date", FALSE);
                        LastPostedDocNo := ServJnlLine."Document No.";
                    END;

            //30.10.2012 EDMS >>
            //    ServJnlPostLine.RunWithCheck(ServJnlLine,TempJnlLineDim);
            ServJnlPostLine.RunWithCheck(ServJnlLine);
        //30.10.2012 EDMS <<

        UNTIL ServJnlLine.NEXT = 0;

        // Copy register no. and current journal batch name to the Serv. journal
        IF ServReg.FINDLAST THEN BEGIN
            IF ServReg."No." > ServRegNo THEN
                ServRegNo := ServReg."No."
            ELSE BEGIN
                IF ServReg."No." = ServRegNo THEN BEGIN
                    IF ServReg."To Entry No." = 0 THEN
                        ServRegNo := 0
                    ELSE
                        ServRegNo := ServReg."No.";
                END ELSE
                    ServRegNo := 0;
            END;
        END ELSE
            ServRegNo := 0;

        ServJnlLine.INIT;
        ServJnlLine."Line No." := ServRegNo;
        //  "Line No." := 10000;

        // Update/delete lines
        IF ServRegNo <> 0 THEN BEGIN
            IF NOT ServJnlLine.RECORDLEVELLOCKING THEN BEGIN
                //      JnlLineDim.LOCKTABLE(TRUE,TRUE); //30.10.2012 EDMS
                ServJnlLine.LOCKTABLE(TRUE, TRUE);
            END;
            IF ServJnlTemplate.Recurring THEN BEGIN
                // Recurring journal
                LineCount := 0;
                ServJnlLine2.COPYFILTERS(ServJnlLine);
                ServJnlLine2.FINDSET(TRUE, FALSE);
                REPEAT
                    LineCount := LineCount + 1;
                    Window.UPDATE(5, LineCount);
                    Window.UPDATE(6, ROUND(LineCount / NoOfRecords * 10000, 1));
                    IF ServJnlLine2."Posting Date" <> 0D THEN
                        ServJnlLine2.VALIDATE("Posting Date", CALCDATE(ServJnlLine2."Recurring Frequency", ServJnlLine2."Posting Date"));
                    IF (ServJnlLine2."Recurring Method" = ServJnlLine2."Recurring Method"::Variable) AND
                       (ServJnlLine2."Vehicle Serial No." <> '')
                    THEN BEGIN
                        ServJnlLine2.Quantity := 0;
                        ServJnlLine2."Total Cost" := 0;
                        ServJnlLine2.Amount := 0;
                    END;
                    ServJnlLine2.MODIFY;
                UNTIL ServJnlLine2.NEXT = 0;
            END ELSE BEGIN
                // Not a recurring journal
                ServJnlLine2.COPYFILTERS(ServJnlLine);
                ServJnlLine2.SETFILTER("Vehicle Serial No.", '<>%1', '');
                IF ServJnlLine2.FINDLAST THEN; // Remember the last line


                ServJnlLine3.COPY(ServJnlLine);
                IF ServJnlLine3.FIND('-') THEN
                    REPEAT


                        ServJnlLine3.DELETE;
                    UNTIL ServJnlLine3.NEXT = 0;

                ServJnlLine3.RESET;
                ServJnlLine3.SETRANGE("Journal Template Name", ServJnlLine."Journal Template Name");
                ServJnlLine3.SETRANGE("Journal Batch Name", ServJnlLine."Journal Batch Name");
                IF NOT ServJnlLine3.FINDLAST THEN
                    IF INCSTR(ServJnlLine."Journal Batch Name") <> '' THEN BEGIN
                        ServJnlBatch.DELETE;
                        ServJnlBatch.Name := INCSTR(ServJnlLine."Journal Batch Name");
                        IF ServJnlBatch.INSERT THEN;
                        ServJnlLine."Journal Batch Name" := ServJnlBatch.Name;
                    END;

                ServJnlLine3.SETRANGE("Journal Batch Name", ServJnlLine."Journal Batch Name");
                IF (ServJnlBatch."No. Series" = '') AND NOT ServJnlLine3.FINDLAST THEN BEGIN
                    ServJnlLine3.INIT;
                    ServJnlLine3."Journal Template Name" := ServJnlLine."Journal Template Name";
                    ServJnlLine3."Journal Batch Name" := ServJnlLine."Journal Batch Name";
                    ServJnlLine3."Line No." := 10000;
                    ServJnlLine3.INSERT;
                    ServJnlLine3.SetUpNewLine(ServJnlLine2);
                    ServJnlLine3.MODIFY;
                END;
            END;
        END;
        IF ServJnlBatch."No. Series" <> '' THEN
            NoSeriesMgt.SaveNoSeries;
        IF NoSeries.FINDSET THEN
            REPEAT
                EVALUATE(PostingNoSeriesNo, NoSeries.Description);
                NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries;
            UNTIL NoSeries.NEXT = 0;

        COMMIT;
        UpdateAnalysisView.UpdateAll(0, TRUE);
        COMMIT;
    end;

    local procedure CheckRecurringLine(var ServJnlLine2: Record "25006165")
    begin
        IF ServJnlLine2."Vehicle Serial No." <> '' THEN
            IF ServJnlTemplate.Recurring THEN BEGIN
                ServJnlLine2.TESTFIELD("Recurring Method");
                ServJnlLine2.TESTFIELD("Recurring Frequency");
                IF "Recurring Method" = "Recurring Method"::Variable THEN
                    ServJnlLine2.TESTFIELD(Quantity);
            END ELSE BEGIN
                ServJnlLine2.TESTFIELD("Recurring Method", 0);
                ServJnlLine2.TESTFIELD("Recurring Frequency", DF0);
            END;
    end;

    local procedure MakeRecurringTexts(var ServJnlLine2: Record "25006165")
    begin
        IF (ServJnlLine2."Vehicle Serial No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN // Not recurring
            Day := DATE2DMY(ServJnlLine2."Posting Date", 1);
            Week := DATE2DWY(ServJnlLine2."Posting Date", 2);
            Month := DATE2DMY(ServJnlLine2."Posting Date", 2);
            MonthText := FORMAT(ServJnlLine2."Posting Date", 0, Text007);
            AccountingPeriod.SETRANGE("Starting Date", 0D, ServJnlLine2."Posting Date");
            IF NOT AccountingPeriod.FINDLAST THEN
                AccountingPeriod.Name := '';
            ServJnlLine2."Document No." :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO(ServJnlLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN(ServJnlLine2."Document No.")),
                '>');
            Description :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO(Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN(Description)),
                '>');
        END;
    end;
}

