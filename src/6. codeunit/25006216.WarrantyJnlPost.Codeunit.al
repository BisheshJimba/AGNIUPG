codeunit 25006216 "Warranty Jnl.-Post"
{
    TableNo = 25006206;

    trigger OnRun()
    begin
        JnlLine.COPY(Rec);
        Code;
        Rec.COPY(JnlLine);
    end;

    var
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. ';
        Text005: Label 'You are now in the %1 journal.';
        JnlTemplate: Record "25006204";
        JnlLine: Record "25006206";
        JnlPostBatch: Codeunit "25006214";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        JnlTemplate.GET(JnlLine."Journal Template Name");
        JnlTemplate.TESTFIELD("Force Posting Report", FALSE);
        IF JnlTemplate.Recurring AND (JnlLine.GETFILTER("Debit Code") <> '') THEN
            JnlLine.FIELDERROR("Debit Code", Text000);

        IF NOT CONFIRM(Text001, FALSE) THEN
            EXIT;

        TempJnlBatchName := JnlLine."Journal Batch Name";

        JnlPostBatch.RUN(JnlLine);

        IF JnlLine."Line No." = 0 THEN
            MESSAGE(Text002)
        ELSE
            IF TempJnlBatchName = JnlLine."Journal Batch Name" THEN
                MESSAGE(Text003)
            ELSE
                MESSAGE(
                  Text004 +
                  Text005,
                  JnlLine."Journal Batch Name");

        IF NOT JnlLine.FINDSET OR (TempJnlBatchName <> JnlLine."Journal Batch Name") THEN BEGIN
            JnlLine.RESET;
            JnlLine.FILTERGROUP(2);
            JnlLine.SETRANGE("Journal Template Name", JnlLine."Journal Template Name");
            JnlLine.SETRANGE("Journal Batch Name", JnlLine."Journal Batch Name");
            JnlLine.FILTERGROUP(0);
            JnlLine."Line No." := 1;
        END;
    end;
}

