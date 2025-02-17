codeunit 25006116 "Ext. Service Jnl.-B.Post+Print"
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
        ExtServiceReg: Record "25006152";
        ExtServiceJnlPostBatch: Codeunit "25006112";
        JnlWithErrors: Boolean;
        Text000: Label 'Do you want to post the journals and print the posting report?';
        Text001: Label 'The journals were successfully posted.';
        Text002: Label 'It was not possible to post all of the journals. ';
        Text003: Label 'The journals that were not successfully posted are now marked.';

    local procedure "Code"()
    begin
        ExtServiceJnlTemplate.GET(ExtServiceJnlBatch."Journal Template Name");
        ExtServiceJnlTemplate.TESTFIELD("Posting Report ID");

        IF NOT CONFIRM(Text000) THEN
            EXIT;

        ExtServiceJnlBatch.FINDSET;
        REPEAT
            ExtServiceJnlLine."Journal Template Name" := ExtServiceJnlBatch."Journal Template Name";
            ExtServiceJnlLine."Journal Batch Name" := ExtServiceJnlBatch.Name;
            ExtServiceJnlLine."Line No." := 1;
            CLEAR(ExtServiceJnlPostBatch);
            IF ExtServiceJnlPostBatch.RUN(ExtServiceJnlLine) THEN BEGIN
                ExtServiceJnlBatch.MARK(FALSE);
                IF ExtServiceReg.GET(ExtServiceJnlLine."Line No.") THEN BEGIN
                    ExtServiceReg.SETRECFILTER;
                    REPORT.RUN(ExtServiceJnlTemplate."Posting Report ID", FALSE, FALSE, ExtServiceReg);
                END;
            END ELSE BEGIN
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
            ExtServiceJnlBatch.Name := '';
        END;
    end;
}

