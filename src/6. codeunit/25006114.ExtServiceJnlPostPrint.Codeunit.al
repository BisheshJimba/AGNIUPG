codeunit 25006114 "Ext. Service Jnl.-Post+Print"
{
    TableNo = 25006143;

    trigger OnRun()
    begin
        ExtServiceJnlLine.COPY(Rec);
        Code;
        Rec.COPY(ExtServiceJnlLine);
    end;

    var
        ExtServiceJnlTemplate: Record "25006142";
        ExtServiceJnlLine: Record "25006143";
        ExtServiceReg: Record "25006152";
        ExtServiceJnlPostBatch: Codeunit "25006112";
        TempJnlBatchName: Code[10];
        Text001: Label 'Do you want to post the journal lines and print the posting report?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. ';
        Text005: Label 'You are now in the %1 journal.';

    local procedure "Code"()
    begin
        ExtServiceJnlTemplate.GET(ExtServiceJnlLine."Journal Template Name");
        ExtServiceJnlTemplate.TESTFIELD("Posting Report ID");

        IF NOT CONFIRM(Text001) THEN
            EXIT;

        TempJnlBatchName := ExtServiceJnlLine."Journal Batch Name";

        ExtServiceJnlPostBatch.RUN(ExtServiceJnlLine);

        IF ExtServiceReg.GET(ExtServiceJnlLine."Line No.") THEN BEGIN
            ExtServiceReg.SETRECFILTER;
            REPORT.RUN(ExtServiceJnlTemplate."Posting Report ID", FALSE, FALSE, ExtServiceReg);
        END;

        IF ExtServiceJnlLine."Line No." = 0 THEN
            MESSAGE(Text002)
        ELSE
            IF TempJnlBatchName = ExtServiceJnlLine."Journal Batch Name" THEN
                MESSAGE(Text003)
            ELSE
                MESSAGE(
                  Text004 +
                  Text005,
                  ExtServiceJnlLine."Journal Batch Name");

        IF NOT ExtServiceJnlLine.FINDSET OR (TempJnlBatchName <> ExtServiceJnlLine."Journal Batch Name") THEN BEGIN
            ExtServiceJnlLine.RESET;
            ExtServiceJnlLine.FILTERGROUP(2);
            ExtServiceJnlLine.SETRANGE("Journal Template Name", ExtServiceJnlLine."Journal Template Name");
            ExtServiceJnlLine.SETRANGE("Journal Batch Name", ExtServiceJnlLine."Journal Batch Name");
            ExtServiceJnlLine.FILTERGROUP(0);
            ExtServiceJnlLine."Line No." := 1;
        END;
    end;
}

