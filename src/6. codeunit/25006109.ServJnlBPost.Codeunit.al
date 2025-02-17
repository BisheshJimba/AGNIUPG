codeunit 25006109 "Serv. Jnl.-B.Post"
{
    TableNo = 25006164;

    trigger OnRun()
    begin
        ServJnlBatch.COPY(Rec);
        Code;
        Rec := ServJnlBatch;
    end;

    var
        Text000: Label 'Do you want to post the journals?';
        Text001: Label 'The journals were successfully posted.';
        Text002: Label 'It was not possible to post all of the journals. ';
        Text003: Label 'The journals that were not successfully posted are now marked.';
        ServJnlTemplate: Record "25006163";
        ServJnlBatch: Record "25006164";
        ServJnlLine: Record "25006165";
        ServJnlPostBatch: Codeunit "25006108";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        ServJnlTemplate.GET(ServJnlBatch."Journal Template Name");
        ServJnlTemplate.TESTFIELD("Force Posting Report", FALSE);

        IF NOT CONFIRM(Text000) THEN
            EXIT;

        ServJnlBatch.FINDSET;
        REPEAT
            ServJnlLine."Journal Template Name" := ServJnlBatch."Journal Template Name";
            ServJnlLine."Journal Batch Name" := ServJnlBatch.Name;
            ServJnlLine."Line No." := 1;
            CLEAR(ServJnlPostBatch);
            IF ServJnlPostBatch.RUN(ServJnlLine) THEN
                ServJnlBatch.MARK(FALSE)
            ELSE BEGIN
                ServJnlBatch.MARK(TRUE);
                JnlWithErrors := TRUE;
            END;
        UNTIL ServJnlBatch.NEXT = 0;

        IF NOT JnlWithErrors THEN
            MESSAGE(Text001)
        ELSE
            MESSAGE(
              Text002 +
              Text003);

        IF NOT ServJnlBatch.FINDSET THEN BEGIN
            ServJnlBatch.RESET;
            ServJnlBatch.FILTERGROUP(2);
            ServJnlBatch.SETRANGE("Journal Template Name", ServJnlBatch."Journal Template Name");
            ServJnlBatch.FILTERGROUP(0);
            ServJnlBatch.Name := '';
        END;
    end;
}

