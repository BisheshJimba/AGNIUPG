codeunit 25006122 "Service-Post+Print EDMS"
{
    TableNo = 25006145;

    trigger OnRun()
    begin
        ServiceHeader.COPY(Rec);
        Code;
        Rec := ServiceHeader;
    end;

    var
        Text001: Label 'Do you want to post and print the %1?';
        ServiceHeader: Record "25006145";
        PostedServiceOrder: Record "25006149";
        PostedServiceRetOrder: Record "25006154";
        ReportSelection: Record "77";
        ServicePost: Codeunit "33020235";
        Selection: Integer;

    local procedure "Code"()
    var
        ReleaseServDoc: Codeunit "25006119";
    begin
        IF NOT
  CONFIRM(
    Text001, FALSE,
    ServiceHeader."Document Type")
THEN
            EXIT;

        ReleaseServDoc.PerformManualRelease(ServiceHeader);
        ServicePost.RUN(ServiceHeader);

        GetReport(ServiceHeader);
        COMMIT;
    end;

    [Scope('Internal')]
    procedure GetReport(var ServiceHeader: Record "25006145")
    begin
        CASE ServiceHeader."Document Type" OF
            ServiceHeader."Document Type"::Order:
                BEGIN
                    PostedServiceOrder."No." := "Posting No.";
                    PostedServiceOrder.SETRECFILTER;
                    PrintReport(ReportSelection.Usage::"Pst.Serv.Inv.Edms");
                END;
            ServiceHeader."Document Type"::"Return Order":
                BEGIN
                    PostedServiceRetOrder."No." := "Posting No.";
                    PostedServiceRetOrder.SETRECFILTER;
                    PrintReport(ReportSelection.Usage::"Pst.Serv.Cr.M.Edms");
                END;
        END;
    end;

    local procedure PrintReport(ReportUsage: Integer)
    begin
        ReportSelection.RESET;
        ReportSelection.SETRANGE(Usage, ReportUsage);
        IF NOT ReportSelection.FINDSET THEN EXIT;
        REPEAT
            ReportSelection.TESTFIELD("Report ID");
            CASE ReportUsage OF
                ReportSelection.Usage::"Asm. Order":
                    REPORT.RUN(ReportSelection."Report ID", FALSE, FALSE, PostedServiceOrder);
                ReportSelection.Usage::"P.Assembly Order":
                    REPORT.RUN(ReportSelection."Report ID", FALSE, FALSE, PostedServiceRetOrder);
            END;
        UNTIL ReportSelection.NEXT = 0;
    end;
}

