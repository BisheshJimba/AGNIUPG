codeunit 25006115 "Ext. Service Jnl.-B.Post"
{
    TableNo = 25006144;

    trigger OnRun()
    begin
        ExtServiceJnlBatch.COPY(Rec);
        Code;
        Rec := ExtServiceJnlBatch;
    end;

    var
        ExtServiceJnlTemplate: Record "25006142";
        ExtServiceJnlBatch: Record "25006144";
        ExtServiceJnlLine: Record "25006143";
        ExtServiceJnlPostBatch: Codeunit "25006112";
        JnlWithErrors: Boolean;
        Text000: Label 'Do you want to post the journals?';
        Text001: Label 'The journals were successfully posted.';
        Text002: Label 'It was not possible to post all of the journals. ';
        Text003: Label 'The journals that were not successfully posted are now marked.';

    local procedure "Code"()
    begin
        ExtServiceJnlTemplate.GET(ExtServiceJnlBatch."Journal Template Name");
        ExtServiceJnlTemplate.TESTFIELD("Force Posting Report", FALSE);

        IF NOT CONFIRM(Text000) THEN
            EXIT;

        ExtServiceJnlBatch.FINDSET;
        REPEAT
            ExtServiceJnlLine."Journal Template Name" := ExtServiceJnlBatch."Journal Template Name";
            ExtServiceJnlLine."Journal Batch Name" := ExtServiceJnlBatch.Name;
            ExtServiceJnlLine."Line No." := 1;
            CLEAR(ExtServiceJnlPostBatch);
            IF ExtServiceJnlPostBatch.RUN(ExtServiceJnlLine) THEN
                ExtServiceJnlBatch.MARK(FALSE)
            ELSE BEGIN
                ExtServiceJnlBatch.MARK(TRUE);
                JnlWithErrors := TRUE;
            END;
        UNTIL ExtServiceJnlBatch.NEXT = 0;

        IF NOT JnlWithErrors THEN
            MESSAGE(Text001)
        ELSE
            MESSAGE(
              Text002 +
              Text003);

        IF NOT ExtServiceJnlBatch.FINDSET THEN BEGIN
            ExtServiceJnlBatch.RESET;
            ExtServiceJnlBatch.FILTERGROUP(2);
            ExtServiceJnlBatch.SETRANGE("Journal Template Name", ExtServiceJnlBatch."Journal Template Name");
            ExtServiceJnlBatch.FILTERGROUP(0);
            ExtServiceJnlBatch.Name := '';
        END;
    end;
}

