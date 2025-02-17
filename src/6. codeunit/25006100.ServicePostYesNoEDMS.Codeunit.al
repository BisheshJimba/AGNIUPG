codeunit 25006100 "Service-Post (Yes/No) EDMS"
{
    TableNo = 25006145;

    trigger OnRun()
    begin
        ServiceHeader.COPY(Rec);
        Code;
        Rec := ServiceHeader;
    end;

    var
        ServicePost: Codeunit "33020235";
        ServiceHeader: Record "25006145";
        Text001: Label 'Do you want to post the %1?';
        NoSeriesMgt: Codeunit "396";

    [Scope('Internal')]
    procedure "Code"()
    var
        ReleaseServDoc: Codeunit "25006119";
    begin
        CASE ServiceHeader."Document Type" OF
            ServiceHeader."Document Type"::Order:
                IF CONFIRM(Text001, FALSE, ServiceHeader."Document Type") THEN BEGIN
                    ReleaseServDoc.PerformManualRelease(ServiceHeader);
                    ServicePost.RUN(ServiceHeader);
                END;
            ServiceHeader."Document Type"::"Return Order":
                IF CONFIRM(Text001, FALSE, ServiceHeader."Document Type") THEN BEGIN
                    ReleaseServDoc.PerformManualRelease(ServiceHeader);
                    ServicePost.RUN(ServiceHeader);
                END;
        END
    end;
}

