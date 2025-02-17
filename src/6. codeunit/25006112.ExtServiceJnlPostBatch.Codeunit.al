codeunit 25006112 "Ext. Service Jnl.-Post Batch"
{
    TableNo = 25006143;

    trigger OnRun()
    begin
        ExtServiceJnlLine.COPY(Rec);
        Code;
        Rec := ExtServiceJnlLine;
    end;

    var
        Text000: Label 'cannot exceed %1 characters';
        Text001: Label 'Journal Batch Name    #1##########\\';
        Text002: Label 'Checking lines        #2######\';
        Text005: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: Label 'A maximum of %1 posting number series can be used in each journal.';
        ExtServiceJnlTemplate: Record "25006142";
        ExtServiceJnlBatch: Record "25006144";
        ExtServiceJnlLine: Record "25006143";
        ExtServiceJnlLine2: Record "25006143";
        ExtServiceJnlLine3: Record "25006143";
        ExtServiceLedgEntry: Record "25006137";
        ExtServiceReg: Record "25006152";
        NoSeries: Record "308" temporary;
        ExtServiceJnlCheckLine: Codeunit "25006110";
        ExtServiceJnlPostLine: Codeunit "25006111";
        NoSeriesMgt: Codeunit "396";
        NoSeriesMgt2: array[10] of Codeunit "396";
        Window: Dialog;
        ExtServiceRegNo: Integer;
        StartLineNo: Integer;
        Month: Integer;
        LineCount: Integer;
        NoOfRecords: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;

    local procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "410";
    begin
        ExtServiceJnlLine.SETRANGE("Journal Template Name", ExtServiceJnlLine."Journal Template Name");
        ExtServiceJnlLine.SETRANGE("Journal Batch Name", ExtServiceJnlLine."Journal Batch Name");
        IF ExtServiceJnlLine.RECORDLEVELLOCKING THEN
            ExtServiceJnlLine.LOCKTABLE;

        ExtServiceJnlTemplate.GET(ExtServiceJnlLine."Journal Template Name");
        ExtServiceJnlBatch.GET(ExtServiceJnlLine."Journal Template Name", ExtServiceJnlLine."Journal Batch Name");
        IF STRLEN(INCSTR(ExtServiceJnlBatch.Name)) > MAXSTRLEN(ExtServiceJnlBatch.Name) THEN
            ExtServiceJnlBatch.FIELDERROR(
              Name,
              STRSUBSTNO(
                Text000,
                MAXSTRLEN(ExtServiceJnlBatch.Name)));

        IF NOT ExtServiceJnlLine.FINDSET THEN BEGIN
            ExtServiceJnlLine."Line No." := 0;
            COMMIT;
            EXIT;
        END;

        Window.OPEN(
          Text001 +
          Text002 +
          Text005);
        Window.UPDATE(1, ExtServiceJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := ExtServiceJnlLine."Line No.";
        REPEAT
            LineCount := LineCount + 1;
            Window.UPDATE(2, LineCount);

            // 30.10.2012 EDMS >>


            //    ExtServiceJnlCheckLine.RunCheck(ExtServiceJnlLine,TempJnlLineDim);
            ExtServiceJnlCheckLine.RunCheck(ExtServiceJnlLine);
            // 30.10.2012 EDMS <<
            IF ExtServiceJnlLine.NEXT = 0 THEN
                ExtServiceJnlLine.FINDSET;
        UNTIL ExtServiceJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        //  LedgEntryDim.LOCKTABLE;  //30.10.2012 EDMS
        ExtServiceLedgEntry.LOCKTABLE;
        IF ExtServiceJnlLine.RECORDLEVELLOCKING THEN
            IF ExtServiceLedgEntry.FINDLAST THEN;
        ExtServiceReg.LOCKTABLE;
        IF ExtServiceReg.FINDLAST AND (ExtServiceReg."To Entry No." = 0) THEN
            ExtServiceRegNo := ExtServiceReg."No."
        ELSE
            ExtServiceRegNo := ExtServiceReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        ExtServiceJnlLine.FINDSET;
        REPEAT
            LineCount := LineCount + 1;
            Window.UPDATE(3, LineCount);
            Window.UPDATE(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            IF NOT EmptyLine AND
               (ExtServiceJnlBatch."No. Series" <> '') AND
               (ExtServiceJnlLine."Document No." <> LastDocNo2)
            THEN
                ExtServiceJnlLine.TESTFIELD("Document No.", NoSeriesMgt.GetNextNo(ExtServiceJnlBatch."No. Series", ExtServiceJnlLine."Posting Date", FALSE));
            LastDocNo2 := ExtServiceJnlLine."Document No.";
            IF "Posting No. Series" = '' THEN
                "Posting No. Series" := ExtServiceJnlBatch."No. Series"
            ELSE
                IF NOT EmptyLine THEN
                    IF ExtServiceJnlLine."Document No." = LastDocNo THEN
                        ExtServiceJnlLine."Document No." := LastPostedDocNo
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
                        LastDocNo := ExtServiceJnlLine."Document No.";
                        EVALUATE(PostingNoSeriesNo, NoSeries.Description);
                        ExtServiceJnlLine."Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series", ExtServiceJnlLine."Posting Date", FALSE);
                        LastPostedDocNo := ExtServiceJnlLine."Document No.";
                    END;

            //30.10.2012 EDMS >>
            ExtServiceJnlPostLine.RunWithCheck(ExtServiceJnlLine);
        //30.10.2012 EDMS <<

        UNTIL ExtServiceJnlLine.NEXT = 0;

        // Copy register no. and current journal batch name to the Ext. service journal
        IF NOT ExtServiceReg.FINDLAST OR (ExtServiceReg."No." <> ExtServiceRegNo) THEN
            ExtServiceRegNo := 0;

        ExtServiceJnlLine.INIT;
        ExtServiceJnlLine."Line No." := ExtServiceRegNo;

        // Update/delete lines
        IF ExtServiceRegNo <> 0 THEN BEGIN
            IF NOT ExtServiceJnlLine.RECORDLEVELLOCKING THEN BEGIN
                //      JnlLineDim.LOCKTABLE(TRUE,TRUE); //30.10.2012 EDMS
                ExtServiceJnlLine.LOCKTABLE(TRUE, TRUE);
            END;
            // Not a recurring journal
            ExtServiceJnlLine2.COPYFILTERS(ExtServiceJnlLine);
            ExtServiceJnlLine2.SETFILTER("Ext. Service No.", '<>%1', '');
            IF ExtServiceJnlLine2.FINDLAST THEN; // Remember the last line

            ExtServiceJnlLine3.COPY(ExtServiceJnlLine);
            ExtServiceJnlLine3.DELETEALL;

            ExtServiceJnlLine3.RESET;
            ExtServiceJnlLine3.SETRANGE("Journal Template Name", ExtServiceJnlLine."Journal Template Name");
            ExtServiceJnlLine3.SETRANGE("Journal Batch Name", ExtServiceJnlLine."Journal Batch Name");
            IF NOT ExtServiceJnlLine3.FINDLAST THEN
                IF INCSTR(ExtServiceJnlLine."Journal Batch Name") <> '' THEN BEGIN
                    ExtServiceJnlBatch.DELETE;
                    ExtServiceJnlBatch.Name := INCSTR(ExtServiceJnlLine."Journal Batch Name");
                    IF ExtServiceJnlBatch.INSERT THEN;
                    ExtServiceJnlLine."Journal Batch Name" := ExtServiceJnlBatch.Name;
                END;

            ExtServiceJnlLine3.SETRANGE("Journal Batch Name", ExtServiceJnlLine."Journal Batch Name");
            IF (ExtServiceJnlBatch."No. Series" = '') AND NOT ExtServiceJnlLine3.FINDLAST THEN BEGIN
                ExtServiceJnlLine3.INIT;
                ExtServiceJnlLine3."Journal Template Name" := ExtServiceJnlLine."Journal Template Name";
                ExtServiceJnlLine3."Journal Batch Name" := ExtServiceJnlLine."Journal Batch Name";
                ExtServiceJnlLine3."Line No." := 10000;
                ExtServiceJnlLine3.INSERT;
                ExtServiceJnlLine3.SetUpNewLine(ExtServiceJnlLine2);
                ExtServiceJnlLine3.MODIFY;
            END;
        END;
        IF ExtServiceJnlBatch."No. Series" <> '' THEN
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
}

