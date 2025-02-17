codeunit 25006309 "Vehicle Opt. Jnl.-Post"
{
    // //==================================================================================================================================
    // MërÒis: Ÿurnâla grâmato³anas pamata jeb sâkuma koda bloks
    // //==================================================================================================================================

    TableNo = 25006387;

    trigger OnRun()
    begin
        recVehOptJnlLine.COPY(Rec);
        fCode;
        Rec.COPY(recVehOptJnlLine);
    end;

    var
        Text001: Label 'Do you want to post the journal lines?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. ';
        Text005: Label 'You are now in the %1 journal.';
        recVehOptJnlTemplate: Record "25006385";
        recVehOptJnlLine: Record "25006387";
        cuVehOptJnlPostBatch: Codeunit "25006308";
        codTempJnlBatchName: Code[10];

    local procedure fCode()
    begin
        recVehOptJnlTemplate.GET(recVehOptJnlLine."Journal Template Name");
        recVehOptJnlTemplate.TESTFIELD("Force Posting Report", FALSE);

        IF NOT CONFIRM(Text001, FALSE) THEN
            EXIT;

        codTempJnlBatchName := recVehOptJnlLine."Journal Batch Name";

        cuVehOptJnlPostBatch.RUN(recVehOptJnlLine);

        IF recVehOptJnlLine."Line No." = 0 THEN
            MESSAGE(Text002)
        ELSE
            IF codTempJnlBatchName = recVehOptJnlLine."Journal Batch Name" THEN
                MESSAGE(Text003)
            ELSE
                MESSAGE(
                  Text004 +
                  Text005,
                  recVehOptJnlLine."Journal Batch Name");

        IF NOT recVehOptJnlLine.FINDSET OR (codTempJnlBatchName <> recVehOptJnlLine."Journal Batch Name") THEN BEGIN
            recVehOptJnlLine.RESET;
            recVehOptJnlLine.FILTERGROUP(2);
            recVehOptJnlLine.SETRANGE("Journal Template Name", recVehOptJnlLine."Journal Template Name");
            recVehOptJnlLine.SETRANGE("Journal Batch Name", recVehOptJnlLine."Journal Batch Name");
            recVehOptJnlLine.FILTERGROUP(0);
            recVehOptJnlLine."Line No." := 1;
        END;
    end;
}

