codeunit 25006607 "Serv.-Post Prepayment (Yes/No)"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Do you want to post the prepayments for %1 %2?';
        Text001: Label 'Do you want to post a credit memo for the prepayments for %1 %2?';
        SalesInvHeader: Record "112";
        SalesCrMemoHeader: Record "114";

    [Scope('Internal')]
    procedure PostPrepmtInvoiceYN(var ServHeader2: Record "25006145"; Print: Boolean)
    var
        ServHeader: Record "25006145";
        ServPostPrepayments: Codeunit "25006608";
    begin
        ServHeader.COPY(ServHeader2);
        IF NOT CONFIRM(Text000, FALSE, ServHeader."Document Type", ServHeader."No.") THEN
            EXIT;

        ServPostPrepayments.Invoice(ServHeader);

        IF Print THEN
            GetReport(ServHeader, 0);

        COMMIT;
        ServHeader2 := ServHeader;
    end;

    [Scope('Internal')]
    procedure PostPrepmtCrMemoYN(var ServHeader2: Record "25006145"; Print: Boolean)
    var
        ServHeader: Record "25006145";
        ServPostPrepayments: Codeunit "25006608";
    begin
        ServHeader.COPY(ServHeader2);
        IF NOT CONFIRM(Text001, FALSE, ServHeader."Document Type", ServHeader."No.") THEN
            EXIT;

        ServPostPrepayments.CreditMemo(ServHeader);

        IF Print THEN
            GetReport(ServHeader, 1);

        COMMIT;
        ServHeader2 := ServHeader;
    end;

    [Scope('Internal')]
    procedure GetReport(var ServHeader: Record "25006145"; DocumentType: Option Invoice,"Credit Memo")
    var
        ReportSelection: Record "77";
    begin
        CASE DocumentType OF
            DocumentType::Invoice:
                BEGIN
                    SalesInvHeader."No." := "Last Prepayment No.";
                    SalesInvHeader.SETRECFILTER;
                    PrintReport(ReportSelection.Usage::"S.Invoice");
                END;
            DocumentType::"Credit Memo":
                BEGIN
                    SalesCrMemoHeader."No." := "Last Prepmt. Cr. Memo No.";
                    SalesCrMemoHeader.SETRECFILTER;
                    PrintReport(ReportSelection.Usage::"S.Cr.Memo");
                END;
        END;
    end;

    local procedure PrintReport(ReportUsage: Integer)
    var
        ReportSelection: Record "77";
    begin
        ReportSelection.SETRANGE(Usage, ReportUsage);
        ReportSelection.FINDSET;
        REPEAT
            ReportSelection.TESTFIELD("Report ID");
            CASE ReportUsage OF
                ReportSelection.Usage::"S.Invoice":
                    REPORT.RUN(ReportSelection."Report ID", FALSE, FALSE, SalesInvHeader);
                ReportSelection.Usage::"S.Cr.Memo":
                    REPORT.RUN(ReportSelection."Report ID", FALSE, FALSE, SalesCrMemoHeader);
            END;
        UNTIL ReportSelection.NEXT = 0;
    end;
}

