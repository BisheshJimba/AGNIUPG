codeunit 25006214 "Warranty Jnl.-Post Batch"
{
    TableNo = 25006206;

    trigger OnRun()
    begin
        WarrantyJnlLine.COPY(Rec);
        Code;
        Rec := WarrantyJnlLine;
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
        WarrantyJnlTemplate: Record "25006204";
        WarrantyJnlBatch: Record "25006205";
        WarrantyJnlLine: Record "25006206";
        WarrantyJnlLine2: Record "25006206";
        WarrantyJnlLine3: Record "25006206";
        WarrantyLedgEntry: Record "25006407";
        WarrantyReg: Record "25006207";
        NoSeries: Record "308" temporary;
        WarrantyJnlCheckLine: Codeunit "25006211";
        WarrantyJnlPostLine: Codeunit "25006212";
        NoSeriesMgt: Codeunit "396";
        NoSeriesMgt2: array[10] of Codeunit "396";
        Window: Dialog;
        WarrantyRegNo: Integer;
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
        WarrantyJnlLine.SETRANGE("Journal Template Name", WarrantyJnlLine."Journal Template Name");
        WarrantyJnlLine.SETRANGE("Journal Batch Name", WarrantyJnlLine."Journal Batch Name");
        IF WarrantyJnlLine.RECORDLEVELLOCKING THEN
            WarrantyJnlLine.LOCKTABLE;

        WarrantyJnlTemplate.GET(WarrantyJnlLine."Journal Template Name");
        WarrantyJnlBatch.GET(WarrantyJnlLine."Journal Template Name", WarrantyJnlLine."Journal Batch Name");
        IF STRLEN(INCSTR(WarrantyJnlBatch.Name)) > MAXSTRLEN(WarrantyJnlBatch.Name) THEN
            WarrantyJnlBatch.FIELDERROR(
              Name,
              STRSUBSTNO(
                Text000,
                MAXSTRLEN(WarrantyJnlBatch.Name)));

        IF WarrantyJnlTemplate.Recurring THEN BEGIN
            WarrantyJnlLine.SETRANGE("Posting Date", 0D, WORKDATE);
        END;

        IF NOT WarrantyJnlLine.FINDSET THEN BEGIN
            WarrantyJnlLine."Line No." := 0;
            COMMIT;
            EXIT;
        END;

        IF WarrantyJnlTemplate.Recurring THEN
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
        Window.UPDATE(1, WarrantyJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := WarrantyJnlLine."Line No.";
        REPEAT
            LineCount := LineCount + 1;
            Window.UPDATE(2, LineCount);
            //CheckRecurringLine(WarrantyJnlLine);
            WarrantyJnlCheckLine.RunCheck(WarrantyJnlLine);

            IF WarrantyJnlLine.NEXT = 0 THEN
                WarrantyJnlLine.FINDFIRST;
        UNTIL WarrantyJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        //  LedgEntryDim.LOCKTABLE; //30.10.2012 EDMS
        WarrantyLedgEntry.LOCKTABLE;
        IF WarrantyJnlLine.RECORDLEVELLOCKING THEN
            IF WarrantyLedgEntry.FINDLAST THEN;
        WarrantyReg.LOCKTABLE;
        IF WarrantyReg.FINDLAST AND (WarrantyReg."To Entry No." = 0) THEN
            WarrantyRegNo := WarrantyReg."No."
        ELSE
            WarrantyRegNo := WarrantyReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        WarrantyJnlLine.FINDSET;
        REPEAT
            LineCount := LineCount + 1;
            Window.UPDATE(3, LineCount);
            Window.UPDATE(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            IF NOT EmptyLine AND
               (WarrantyJnlBatch."No. Series" <> '') AND
               (WarrantyJnlLine."Document No." <> LastDocNo2)
            THEN
                WarrantyJnlLine.TESTFIELD("Document No.", NoSeriesMgt.GetNextNo(WarrantyJnlBatch."No. Series", WarrantyJnlLine."Posting Date", FALSE));
            LastDocNo2 := WarrantyJnlLine."Document No.";
            MakeRecurringTexts(WarrantyJnlLine);
            IF "Posting No. Series" = '' THEN
                "Posting No. Series" := WarrantyJnlBatch."No. Series"
            ELSE
                IF NOT EmptyLine THEN
                    IF WarrantyJnlLine."Document No." = LastDocNo THEN
                        WarrantyJnlLine."Document No." := LastPostedDocNo
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
                        LastDocNo := WarrantyJnlLine."Document No.";
                        EVALUATE(PostingNoSeriesNo, NoSeries.Description);
                        WarrantyJnlLine."Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series", WarrantyJnlLine."Posting Date", FALSE);
                        LastPostedDocNo := WarrantyJnlLine."Document No.";
                    END;

            //30.10.2012 EDMS >>
            //    WarrantyJnlPostLine.RunWithCheck(WarrantyJnlLine,TempJnlLineDim);
            WarrantyJnlPostLine.RunWithCheck(WarrantyJnlLine);
        //30.10.2012 EDMS <<

        UNTIL WarrantyJnlLine.NEXT = 0;

        // Copy register no. and current journal batch name to the Serv. journal
        IF WarrantyReg.FINDLAST THEN BEGIN
            IF WarrantyReg."No." > WarrantyRegNo THEN
                WarrantyRegNo := WarrantyReg."No."
            ELSE BEGIN
                IF WarrantyReg."No." = WarrantyRegNo THEN BEGIN
                    IF WarrantyReg."To Entry No." = 0 THEN
                        WarrantyRegNo := 0
                    ELSE
                        WarrantyRegNo := WarrantyReg."No.";
                END ELSE
                    WarrantyRegNo := 0;
            END;
        END ELSE
            WarrantyRegNo := 0;

        WarrantyJnlLine.INIT;
        WarrantyJnlLine."Line No." := WarrantyRegNo;
        //  "Line No." := 10000;

        // Update/delete lines
        IF WarrantyRegNo <> 0 THEN BEGIN
            IF NOT WarrantyJnlLine.RECORDLEVELLOCKING THEN BEGIN
                //      JnlLineDim.LOCKTABLE(TRUE,TRUE); //30.10.2012 EDMS
                WarrantyJnlLine.LOCKTABLE(TRUE, TRUE);
            END;
            IF WarrantyJnlTemplate.Recurring THEN BEGIN
                // Recurring journal
                LineCount := 0;
                WarrantyJnlLine2.COPYFILTERS(WarrantyJnlLine);
                WarrantyJnlLine2.FINDSET(TRUE, FALSE);
                REPEAT
                    LineCount := LineCount + 1;
                    Window.UPDATE(5, LineCount);
                    Window.UPDATE(6, ROUND(LineCount / NoOfRecords * 10000, 1));
                    IF WarrantyJnlLine2."Posting Date" <> 0D THEN
                        WarrantyJnlLine2.VALIDATE("Posting Date", CALCDATE(WarrantyJnlLine2."Recurring Frequency", WarrantyJnlLine2."Posting Date"));
                    IF (WarrantyJnlLine2."Recurring Method" = WarrantyJnlLine2."Recurring Method"::Variable) AND
                       (WarrantyJnlLine2."Vehicle Serial No." <> '')
                    THEN BEGIN
                        //WarrantyJnlLine2.Quantity := 0;
                        //WarrantyJnlLine2."Total Cost" := 0;
                        //WarrantyJnlLine2.Amount := 0;
                    END;
                    WarrantyJnlLine2.MODIFY;
                UNTIL WarrantyJnlLine2.NEXT = 0;
            END ELSE BEGIN
                // Not a recurring journal
                WarrantyJnlLine2.COPYFILTERS(WarrantyJnlLine);
                WarrantyJnlLine2.SETFILTER("Debit Description", '<>%1', '');
                IF WarrantyJnlLine2.FINDLAST THEN; // Remember the last line


                WarrantyJnlLine3.COPY(WarrantyJnlLine);
                IF WarrantyJnlLine3.FIND('-') THEN
                    REPEAT


                        WarrantyJnlLine3.DELETE;
                    UNTIL WarrantyJnlLine3.NEXT = 0;

                WarrantyJnlLine3.RESET;
                WarrantyJnlLine3.SETRANGE("Journal Template Name", WarrantyJnlLine."Journal Template Name");
                WarrantyJnlLine3.SETRANGE("Journal Batch Name", WarrantyJnlLine."Journal Batch Name");
                IF NOT WarrantyJnlLine3.FINDLAST THEN
                    IF INCSTR(WarrantyJnlLine."Journal Batch Name") <> '' THEN BEGIN
                        WarrantyJnlBatch.DELETE;
                        WarrantyJnlBatch.Name := INCSTR(WarrantyJnlLine."Journal Batch Name");
                        IF WarrantyJnlBatch.INSERT THEN;
                        WarrantyJnlLine."Journal Batch Name" := WarrantyJnlBatch.Name;
                    END;

                WarrantyJnlLine3.SETRANGE("Journal Batch Name", WarrantyJnlLine."Journal Batch Name");
                IF (WarrantyJnlBatch."No. Series" = '') AND NOT WarrantyJnlLine3.FINDLAST THEN BEGIN
                    WarrantyJnlLine3.INIT;
                    WarrantyJnlLine3."Journal Template Name" := WarrantyJnlLine."Journal Template Name";
                    WarrantyJnlLine3."Journal Batch Name" := WarrantyJnlLine."Journal Batch Name";
                    WarrantyJnlLine3."Line No." := 10000;
                    WarrantyJnlLine3.INSERT;
                    WarrantyJnlLine3.SetUpNewLine(WarrantyJnlLine2);
                    WarrantyJnlLine3.MODIFY;
                END;
            END;
        END;
        IF WarrantyJnlBatch."No. Series" <> '' THEN
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

    local procedure CheckRecurringLine(var WarrantyJnlLine2: Record "25006206")
    begin
        IF WarrantyJnlLine2."Debit Description" <> '' THEN
            IF WarrantyJnlTemplate.Recurring THEN BEGIN
                WarrantyJnlLine2.TESTFIELD("Recurring Method");
                WarrantyJnlLine2.TESTFIELD("Recurring Frequency");
                IF "Recurring Method" = "Recurring Method"::Variable THEN
                    WarrantyJnlLine2.TESTFIELD("Vehicle Serial No.");
            END ELSE BEGIN
                WarrantyJnlLine2.TESTFIELD("Recurring Method", 0);
                WarrantyJnlLine2.TESTFIELD("Recurring Frequency", DF0);
            END;
    end;

    local procedure MakeRecurringTexts(var WarrantyJnlLine2: Record "25006206")
    begin
        IF (WarrantyJnlLine2."Vehicle Serial No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN // Not recurring
            Day := DATE2DMY(WarrantyJnlLine2."Posting Date", 1);
            Week := DATE2DWY(WarrantyJnlLine2."Posting Date", 2);
            Month := DATE2DMY(WarrantyJnlLine2."Posting Date", 2);
            MonthText := FORMAT(WarrantyJnlLine2."Posting Date", 0, Text007);
            AccountingPeriod.SETRANGE("Starting Date", 0D, WarrantyJnlLine2."Posting Date");
            IF NOT AccountingPeriod.FINDLAST THEN
                AccountingPeriod.Name := '';
            WarrantyJnlLine2."Document No." :=
              DELCHR(
                PADSTR(
                  STRSUBSTNO(WarrantyJnlLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MAXSTRLEN(WarrantyJnlLine2."Document No.")),
                '>');
            //Description :=
            //  DELCHR(
            //    PADSTR(
            //      STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
            //      MAXSTRLEN(Description)),
            //    '>');
        END;
    end;
}

