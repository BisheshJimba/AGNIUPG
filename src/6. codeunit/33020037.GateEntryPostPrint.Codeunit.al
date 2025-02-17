codeunit 33020037 "Gate Entry- Post + Print"
{
    TableNo = 33020035;

    trigger OnRun()
    begin
        GateEntryHeader.COPY(Rec);
        Code;
        Rec := GateEntryHeader;
        MESSAGE(Text16501);
    end;

    var
        Text16500: Label 'Do you want to Post the Gate Entry?';
        GateEntryHeader: Record "33020035";
        GateEntryPost: Codeunit "33020035";
        Text16501: Label 'Gate Entry Posted successfully.';
        PostedGateEntryHeader: Record "33020038";
        TransferShipmentHeader: Record "5744";
        PostedGateEntryLine: Record "33020039";
        SalesInvoiceHeader: Record "112";

    local procedure "Code"()
    begin
        IF NOT CONFIRM(Text16500, FALSE) THEN
            EXIT;
        GateEntryPost.RUN(GateEntryHeader);
        GetReport(GateEntryHeader);
        COMMIT;
    end;

    [Scope('Internal')]
    procedure GetReport(GateEntryHeaders: Record "33020035")
    begin
        PostedGateEntryHeader.RESET;
        PostedGateEntryHeader.SETRANGE("Gate Entry No.", GateEntryHeaders."No.");
        IF PostedGateEntryHeader.FINDFIRST THEN
            PrintReport;
    end;

    [Scope('Internal')]
    procedure PrintReport()
    begin
        PostedGateEntryLine.RESET;
        PostedGateEntryLine.SETRANGE("Gate Entry No.", PostedGateEntryHeader."No.");
        IF PostedGateEntryLine.FINDFIRST THEN BEGIN
            CASE PostedGateEntryLine."Source Type" OF
                PostedGateEntryLine."Source Type"::"Transfer Shipment":
                    BEGIN
                        TransferShipmentHeader.RESET;
                        TransferShipmentHeader.SETRANGE("No.", PostedGateEntryLine."Source No.");
                        IF TransferShipmentHeader.FINDFIRST THEN BEGIN
                            CASE TransferShipmentHeader."Document Profile" OF
                                TransferShipmentHeader."Document Profile"::"Spare Parts Trade":
                                    REPORT.RUN(33020035, FALSE, FALSE, PostedGateEntryHeader);
                                TransferShipmentHeader."Document Profile"::"Vehicles Trade":
                                    REPORT.RUN(33020035, FALSE, FALSE, PostedGateEntryHeader);//REPORT.RUN(5704,FALSE,FALSE,PostedGateEntryHeader);
                            END;
                        END;
                    END;
                PostedGateEntryLine."Source Type"::Service:
                    BEGIN
                        SalesInvoiceHeader.RESET;
                        SalesInvoiceHeader.SETRANGE("No.", PostedGateEntryLine."Source No.");
                        IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                            REPORT.RUN(33020246, FALSE, FALSE, SalesInvoiceHeader);
                        END

                    END;
            END;
        END;
    end;
}

