codeunit 25006217 "Warranty Jnl.-Post+Print"
{
    TableNo = 25006206;

    trigger OnRun()
    begin
        WarrantyJnlLine.COPY(Rec);
        Code;
        Rec.COPY(WarrantyJnlLine);
    end;

    var
        WarrantyJnlTemplate: Record "25006204";
        WarrantyJnlLine: Record "25006206";
        WarrantyReg: Record "25006207";
        WarrantyJnlPostBatch: Codeunit "25006214";
        TempJnlBatchName: Code[10];
        Text001: Label 'Do you want to post the journal lines and print the posting report?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. ';
        Text005: Label 'You are now in the %1 journal.';

    local procedure "Code"()
    begin
        WarrantyJnlTemplate.GET(WarrantyJnlLine."Journal Template Name");
        WarrantyJnlTemplate.TESTFIELD("Posting Report ID");

        IF NOT CONFIRM(Text001) THEN
            EXIT;

        TempJnlBatchName := WarrantyJnlLine."Journal Batch Name";

        WarrantyJnlPostBatch.RUN(WarrantyJnlLine);

        IF WarrantyReg.GET(WarrantyJnlLine."Line No.") THEN BEGIN
            WarrantyReg.SETRECFILTER;
            REPORT.RUN(WarrantyJnlTemplate."Posting Report ID", FALSE, FALSE, WarrantyReg);
        END;

        IF WarrantyJnlLine."Line No." = 0 THEN
            MESSAGE(Text002)
        ELSE
            IF TempJnlBatchName = WarrantyJnlLine."Journal Batch Name" THEN
                MESSAGE(Text003)
            ELSE
                MESSAGE(
                  Text004 +
                  Text005,
                  WarrantyJnlLine."Journal Batch Name");

        IF NOT WarrantyJnlLine.FINDSET OR (TempJnlBatchName <> WarrantyJnlLine."Journal Batch Name") THEN BEGIN
            WarrantyJnlLine.RESET;
            WarrantyJnlLine.FILTERGROUP(2);
            WarrantyJnlLine.SETRANGE("Journal Template Name", WarrantyJnlLine."Journal Template Name");
            WarrantyJnlLine.SETRANGE("Journal Batch Name", WarrantyJnlLine."Journal Batch Name");
            WarrantyJnlLine.FILTERGROUP(0);
            WarrantyJnlLine."Line No." := 1;
        END;
    end;
}

