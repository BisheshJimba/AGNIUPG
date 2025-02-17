codeunit 25006128 "Service Jnl.-Post+Print"
{
    TableNo = 25006165;

    trigger OnRun()
    begin
        ServiceJnlLine.COPY(Rec);
        Code;
        Rec.COPY(ServiceJnlLine);
    end;

    var
        ServiceJnlTemplate: Record "25006163";
        ServiceJnlLine: Record "25006165";
        ServiceReg: Record "5934";
        ServiceJnlPostBatch: Codeunit "25006108";
        TempJnlBatchName: Code[10];
        Text001: Label 'Do you want to post the journal lines and print the posting report?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. ';
        Text005: Label 'You are now in the %1 journal.';

    local procedure "Code"()
    begin
        ServiceJnlTemplate.GET(ServiceJnlLine."Journal Template Name");
        ServiceJnlTemplate.TESTFIELD("Posting Report ID");

        IF NOT CONFIRM(Text001) THEN
            EXIT;

        TempJnlBatchName := ServiceJnlLine."Journal Batch Name";

        ServiceJnlPostBatch.RUN(ServiceJnlLine);

        IF ServiceReg.GET(ServiceJnlLine."Line No.") THEN BEGIN
            ServiceReg.SETRECFILTER;
            REPORT.RUN(ServiceJnlTemplate."Posting Report ID", FALSE, FALSE, ServiceReg);
        END;

        IF ServiceJnlLine."Line No." = 0 THEN
            MESSAGE(Text002)
        ELSE
            IF TempJnlBatchName = ServiceJnlLine."Journal Batch Name" THEN
                MESSAGE(Text003)
            ELSE
                MESSAGE(
                  Text004 +
                  Text005,
                  ServiceJnlLine."Journal Batch Name");

        IF NOT ServiceJnlLine.FINDSET OR (TempJnlBatchName <> ServiceJnlLine."Journal Batch Name") THEN BEGIN
            ServiceJnlLine.RESET;
            ServiceJnlLine.FILTERGROUP(2);
            ServiceJnlLine.SETRANGE("Journal Template Name", ServiceJnlLine."Journal Template Name");
            ServiceJnlLine.SETRANGE("Journal Batch Name", ServiceJnlLine."Journal Batch Name");
            ServiceJnlLine.FILTERGROUP(0);
            ServiceJnlLine."Line No." := 1;
        END;
    end;
}

