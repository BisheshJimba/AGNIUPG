codeunit 33020511 "Dealer Purchase Integration"
{
    Permissions = TableData 112 = rm;
    TableNo = 472;

    trigger OnRun()
    var
        SalesInvHeader: Record "112";
        DealerSynchronization: Codeunit "33020509";
        RecRef: RecordRef;
    begin
        Rec.TESTFIELD("Record ID to Process");
        RecRef.GET(Rec."Record ID to Process");
        RecRef.SETTABLE(SalesInvHeader);
        SalesInvHeader.FIND;
        SetJobQueueStatus(SalesInvHeader, SalesInvHeader."Sync Status"::Synching);
        IF NOT DealerSynchronization.SendSalesDoc(SalesInvHeader) THEN BEGIN
            SetJobQueueStatus(SalesInvHeader, SalesInvHeader."Sync Status"::Error);
            ERROR(GETLASTERRORTEXT);
        END;
        SetJobQueueStatus(SalesInvHeader, SalesInvHeader."Sync Status"::Synched);
    end;

    local procedure SetJobQueueStatus(var SalesInvoiceHeader: Record "112"; NewStatus: Option)
    begin
        SalesInvoiceHeader.LOCKTABLE;
        IF SalesInvoiceHeader.FIND THEN BEGIN
            SalesInvoiceHeader."Sync Status" := NewStatus;
            SalesInvoiceHeader.MODIFY;
            COMMIT;
        END;
    end;
}

