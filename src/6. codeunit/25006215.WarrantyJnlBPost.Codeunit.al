codeunit 25006215 "Warranty Jnl.-B.Post"
{
    TableNo = 25006205;

    trigger OnRun()
    begin
        WarrantyJnlBatch.COPY(Rec);
        Code;
        Rec := WarrantyJnlBatch;
    end;

    var
        Text000: Label 'Do you want to post the journals?';
        Text001: Label 'The journals were successfully posted.';
        Text002: Label 'It was not possible to post all of the journals. ';
        Text003: Label 'The journals that were not successfully posted are now marked.';
        WarrantyJnlTemplate: Record "25006204";
        WarrantyJnlBatch: Record "25006205";
        WarrantyJnlLine: Record "25006206";
        WarrantyJnlPostBatch: Codeunit "25006214";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        WarrantyJnlTemplate.GET(WarrantyJnlBatch."Journal Template Name");
        WarrantyJnlTemplate.TESTFIELD("Force Posting Report", FALSE);

        IF NOT CONFIRM(Text000) THEN
            EXIT;

        WarrantyJnlBatch.FINDSET;
        REPEAT
            WarrantyJnlLine."Journal Template Name" := WarrantyJnlBatch."Journal Template Name";
            WarrantyJnlLine."Journal Batch Name" := WarrantyJnlBatch.Name;
            WarrantyJnlLine."Line No." := 1;
            CLEAR(WarrantyJnlPostBatch);
            IF WarrantyJnlPostBatch.RUN(WarrantyJnlLine) THEN
                WarrantyJnlBatch.MARK(FALSE)
            ELSE BEGIN
                WarrantyJnlBatch.MARK(TRUE);
                JnlWithErrors := TRUE;
            END;
        UNTIL WarrantyJnlBatch.NEXT = 0;

        IF NOT JnlWithErrors THEN
            MESSAGE(Text001)
        ELSE
            MESSAGE(
              Text002 +
              Text003);

        IF NOT WarrantyJnlBatch.FINDSET THEN BEGIN
            WarrantyJnlBatch.RESET;
            WarrantyJnlBatch.FILTERGROUP(2);
            WarrantyJnlBatch.SETRANGE("Journal Template Name", WarrantyJnlBatch."Journal Template Name");
            WarrantyJnlBatch.FILTERGROUP(0);
            WarrantyJnlBatch.Name := '';
        END;
    end;
}

