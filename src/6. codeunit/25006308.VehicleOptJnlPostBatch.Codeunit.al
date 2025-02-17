codeunit 25006308 "Vehicle Opt. Jnl.-Post Batch"
{
    // 21.03.2013 EDMS P8
    //   * fix of modify series no

    Permissions = TableData 233 = imd;
    TableNo = 25006387;

    trigger OnRun()
    begin
        recVehOptJnlLine.COPY(Rec);
        fCode;
        Rec := recVehOptJnlLine;
    end;

    var
        Text000: Label 'cannot exceed %1 characters';
        Text001: Label 'Journal Batch Name    #1##########\\';
        Text002: Label 'Checking lines        #2######\';
        Text005: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: Label 'A maximum of %1 posting number series can be used in each journal.';
        recVehOptJnlTemplate: Record "25006385";
        recVehOptJnlBatch: Record "25006386";
        recVehOptJnlLine: Record "25006387";
        recVehOptJnlLine2: Record "25006387";
        recVehOptJnlLine3: Record "25006387";
        recGLSetup: Record "98";
        recNoSeries: Record "308" temporary;
        cuVehOptJnlCheckLine: Codeunit "25006306";
        cuVehOptJnlPostLine: Codeunit "25006307";
        cuNoSeriesMgt: Codeunit "396";
        cuNoSeriesMgt2: array[10] of Codeunit "396";
        dlgWindow: Dialog;
        iStartLineNo: Integer;
        iNoOfRecords: Integer;
        iLineCount: Integer;
        codLastDocNo: Code[20];
        codLastDocNo2: Code[20];
        codLastPostedDocNo: Code[20];
        iNoOfPostingNoSeries: Integer;
        iPostingNoSeriesNo: Integer;
        recVehOptJnlLine9: Record "25006387";
        recVehOptJnlLine6: Record "25006387";
        iGlobalVehOptRegNo: Integer;

    local procedure fCode()
    var
        recVehOptJnlLine6a: Record "25006387";
    begin
        IF recVehOptJnlLine.RECORDLEVELLOCKING THEN
            recVehOptJnlLine.LOCKTABLE;

        recVehOptJnlLine.SETRANGE("Journal Template Name", recVehOptJnlLine."Journal Template Name");
        recVehOptJnlLine.SETRANGE("Journal Batch Name", recVehOptJnlLine."Journal Batch Name");

        recVehOptJnlTemplate.GET(recVehOptJnlLine."Journal Template Name");
        recVehOptJnlBatch.GET(recVehOptJnlLine."Journal Template Name", recVehOptJnlLine."Journal Batch Name");
        IF STRLEN(INCSTR(recVehOptJnlBatch.Name)) > MAXSTRLEN(recVehOptJnlBatch.Name) THEN
            recVehOptJnlBatch.FIELDERROR(
              Name,
              STRSUBSTNO(
                Text000,
                MAXSTRLEN(recVehOptJnlBatch.Name)));

        IF NOT recVehOptJnlLine.FINDSET THEN BEGIN
            recVehOptJnlLine."Line No." := 0;
            COMMIT;
            EXIT;
        END;

        dlgWindow.OPEN(
          Text001 +
          Text002 +
          Text005);

        dlgWindow.UPDATE(1, recVehOptJnlLine."Journal Batch Name");

        // Check Lines
        iLineCount := 0;
        iStartLineNo := recVehOptJnlLine."Line No.";
        REPEAT
            iLineCount := iLineCount + 1;
            dlgWindow.UPDATE(2, iLineCount);

            fMakeLineCorrectnessCheck(recVehOptJnlLine); //P–Ærbaudes, kas attiecas tikai uz rindu

            IF recVehOptJnlLine.NEXT = 0 THEN
                recVehOptJnlLine.FINDFIRST;
        UNTIL recVehOptJnlLine."Line No." = iStartLineNo;
        iNoOfRecords := iLineCount;


        recGLSetup.GET;

        // Post lines
        iLineCount := 0;
        codLastDocNo := '';
        codLastDocNo2 := '';
        codLastPostedDocNo := '';

        //Gr–Æmato“òanas grupËÇ“òanas cikls - pa aizvieto“òan–Æm
        recVehOptJnlLine9.RESET; //Prim–Ærie ieraksti
        recVehOptJnlLine9.COPYFILTERS(recVehOptJnlLine);

        recVehOptJnlLine6.RESET; //Pak“½autie ieraksti
        recVehOptJnlLine6.COPYFILTERS(recVehOptJnlLine);


        recVehOptJnlLine9.FINDSET;
        REPEAT
            // Gr–Æmatojam prim–Æro rindu
            fPrePostLine(recVehOptJnlLine);
            iLineCount := iLineCount + 1;
            dlgWindow.UPDATE(3, iLineCount);
            dlgWindow.UPDATE(4, ROUND(iLineCount / iNoOfRecords * 10000, 1));

            //Gr–Æmatojam prim–Æro rindu
            cuVehOptJnlPostLine.fRunWithCheck(recVehOptJnlLine, iGlobalVehOptRegNo);
            //21.03.2013 EDMS P8 >>
            IF recVehOptJnlBatch."No. Series" <> '' THEN
                cuNoSeriesMgt.SaveNoSeries;
            IF recNoSeries.FIND('-') THEN
                REPEAT
                    EVALUATE(iPostingNoSeriesNo, recNoSeries.Description);
                    cuNoSeriesMgt2[iPostingNoSeriesNo].SaveNoSeries;
                UNTIL recNoSeries.NEXT = 0;
        //21.03.2013 EDMS P8 <<
        UNTIL recVehOptJnlLine.NEXT = 0;
        recVehOptJnlLine.FINDLAST;

        recVehOptJnlLine.INIT;

        // Update/delete lines
        IF recVehOptJnlLine."Line No." <> 0 THEN BEGIN
            IF NOT recVehOptJnlLine.RECORDLEVELLOCKING THEN BEGIN
                recVehOptJnlLine.LOCKTABLE(TRUE, TRUE);
            END;
            BEGIN
                recVehOptJnlLine2.COPYFILTERS(recVehOptJnlLine);
                IF recVehOptJnlLine2.FINDLAST THEN; // Remember the last line

                recVehOptJnlLine3.COPY(recVehOptJnlLine);
                recVehOptJnlLine3.DELETEALL;

                recVehOptJnlLine3.RESET;
                recVehOptJnlLine3.SETRANGE("Journal Template Name", recVehOptJnlLine."Journal Template Name");
                recVehOptJnlLine3.SETRANGE("Journal Batch Name", recVehOptJnlLine."Journal Batch Name");
                IF NOT recVehOptJnlLine3.FINDLAST THEN
                    IF INCSTR(recVehOptJnlLine."Journal Batch Name") <> '' THEN BEGIN
                        recVehOptJnlBatch.DELETE;
                        recVehOptJnlBatch.Name := INCSTR(recVehOptJnlLine."Journal Batch Name");
                        IF recVehOptJnlBatch.INSERT THEN;
                        recVehOptJnlLine."Journal Batch Name" := recVehOptJnlBatch.Name;
                    END;

                recVehOptJnlLine3.SETRANGE("Journal Batch Name", recVehOptJnlLine."Journal Batch Name");
                IF (recVehOptJnlBatch."No. Series" = '') AND NOT recVehOptJnlLine3.FINDLAST THEN BEGIN
                    recVehOptJnlLine3.INIT;
                    recVehOptJnlLine3."Journal Template Name" := recVehOptJnlLine."Journal Template Name";
                    recVehOptJnlLine3."Journal Batch Name" := recVehOptJnlLine."Journal Batch Name";
                    recVehOptJnlLine3."Line No." := 10000;
                    recVehOptJnlLine3.INSERT;
                    recVehOptJnlLine3.fSetUpNewLine(recVehOptJnlLine2);
                    recVehOptJnlLine3.MODIFY;
                END;
            END;
        END;
        IF recVehOptJnlBatch."No. Series" <> '' THEN
            cuNoSeriesMgt.SaveNoSeries;
        IF recNoSeries.FINDSET THEN
            REPEAT
                EVALUATE(iPostingNoSeriesNo, recNoSeries.Description);
                cuNoSeriesMgt2[iPostingNoSeriesNo].SaveNoSeries;
            UNTIL recNoSeries.NEXT = 0;

        dlgWindow.CLOSE;
        COMMIT;
        CLEAR(cuVehOptJnlCheckLine);
        CLEAR(cuVehOptJnlPostLine);

        COMMIT;
    end;

    [Scope('Internal')]
    procedure fPrePostLine(var recVehOptJnlLine: Record "25006387")
    begin
        //MËÇr“is: Veikt pirms gr–Æmato“òanas pas–Ækumus - p–Ærbaudes
        IF (recVehOptJnlBatch."No. Series" <> '') AND
  (recVehOptJnlLine."Document No." <> codLastDocNo2)
THEN
            recVehOptJnlLine.TESTFIELD("Document No.", cuNoSeriesMgt.GetNextNo(recVehOptJnlBatch."No. Series", recVehOptJnlLine."Posting Date", FALSE));

        codLastDocNo2 := recVehOptJnlLine."Document No.";

        IF recVehOptJnlLine."Posting No. Series" = '' THEN BEGIN
            recVehOptJnlLine."Posting No. Series" := recVehOptJnlBatch."No. Series";
            codLastDocNo := recVehOptJnlLine."Document No.";  //21.03.2013 EDMS P8
            codLastPostedDocNo := recVehOptJnlLine."Document No.";
        END ELSE BEGIN
            IF recVehOptJnlLine."Document No." = codLastDocNo THEN
                recVehOptJnlLine."Document No." := codLastPostedDocNo
            ELSE BEGIN
                IF NOT recNoSeries.GET(recVehOptJnlLine."Posting No. Series") THEN BEGIN
                    iNoOfPostingNoSeries := iNoOfPostingNoSeries + 1;
                    IF iNoOfPostingNoSeries > ARRAYLEN(cuNoSeriesMgt2) THEN
                        ERROR(
                          Text006,
                          ARRAYLEN(cuNoSeriesMgt2));
                    recNoSeries.Code := recVehOptJnlLine."Posting No. Series";
                    recNoSeries.Description := FORMAT(iNoOfPostingNoSeries);
                    recNoSeries.INSERT;
                END;
                codLastDocNo := recVehOptJnlLine."Document No.";
                EVALUATE(iPostingNoSeriesNo, recNoSeries.Description);
                recVehOptJnlLine."Document No." := cuNoSeriesMgt2[iPostingNoSeriesNo].GetNextNo(recVehOptJnlLine."Posting No. Series", recVehOptJnlLine."Posting Date", FALSE);
                codLastPostedDocNo := recVehOptJnlLine."Document No.";
            END;
        END;
    end;

    [Scope('Internal')]
    procedure fMakeLineCorrectnessCheck(var recVehOptJnlLine71: Record "25006387")
    var
        recVehOptJnlLine5: Record "25006387";
        recVehOptJnlLine53: Record "25006387";
    begin

        IF recVehOptJnlLine71."Document No." = '' THEN
            recVehOptJnlLine71.FIELDERROR("Document No.");
    end;
}

