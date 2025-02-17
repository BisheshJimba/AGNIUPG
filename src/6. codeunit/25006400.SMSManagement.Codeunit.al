codeunit 25006400 "SMS Management"
{

    trigger OnRun()
    begin
    end;

    var
        BulkSMSMgt: Codeunit "25006402";
        SMSBatchBuffer: Record "25006401" temporary;
        SMSMgtSetup: Record "25006403";
        ContactNo: Code[20];
        SalespersonCode: Code[10];
        DocumentType: Option;
        DocumentNo: Code[20];

    [Scope('Internal')]
    procedure AddSMSToQueue(PhoneNo: Text[30]; Message: Text[250]): Boolean
    var
        BatchQueueEntryNo: Integer;
    begin
        SMSMgtSetup.GET;
        BatchQueueEntryNo := CreateSMSBatchQueueEntry(FALSE, SMSMgtSetup."Enable Repliable SMS", SMSMgtSetup."SMS Sender Id");
        CreateSMSEntry(BatchQueueEntryNo, PhoneNo, Message);
    end;

    [Scope('Internal')]
    procedure AddSMSBatchToQueue() ResponseText: Text
    var
        SMSEntryNo: Integer;
        EntryNo: Integer;
        BatchQueueEntryNo: Integer;
        BatchData: BigText;
    begin
        SMSMgtSetup.GET;
        BatchQueueEntryNo := CreateSMSBatchQueueEntry(TRUE, SMSMgtSetup."Enable Repliable SMS", SMSMgtSetup."SMS Sender Id");
        SMSBatchBuffer.RESET;
        IF SMSBatchBuffer.FINDFIRST THEN BEGIN
            REPEAT
                CreateSMSEntry(BatchQueueEntryNo, SMSBatchBuffer."Phone No.", SMSBatchBuffer."Message Text");
            UNTIL SMSBatchBuffer.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure GetSMSQuotation(PhoneNo: Text[30]; Message: Text[250]) ResponseText: Text
    var
        ResponseData: BigText;
    begin
        SMSMgtSetup.GET;
        BulkSMSMgt.SetPrerequisites(SMSMgtSetup."SMS Provider Username", SMSMgtSetup."SMS Provider Password", SMSMgtSetup."Provider URL");
        BulkSMSMgt.RequestQuote(PhoneNo, Message, ResponseData);
        ResponseData.GETSUBTEXT(ResponseText, 1, 250);
    end;

    [Scope('Internal')]
    procedure GetCredits() ResponseText: Text
    var
        ResponseData: BigText;
    begin
        SMSMgtSetup.GET;
        BulkSMSMgt.SetPrerequisites(SMSMgtSetup."SMS Provider Username", SMSMgtSetup."SMS Provider Password", SMSMgtSetup."Provider URL");
        BulkSMSMgt.RequestCredits(ResponseData);
        ResponseData.GETSUBTEXT(ResponseText, 1, 250);
    end;

    [Scope('Internal')]
    procedure GetReplays() ResponseText: Text
    var
        ResponseData: BigText;
        crlf: Text[2];
        i: Integer;
        ResponseDataTmp: BigText;
        ResponseLine: Text;
        ResponseStatus: Text;
        LineNo: Integer;
    begin
        SMSMgtSetup.GET;
        BulkSMSMgt.SetPrerequisites(SMSMgtSetup."SMS Provider Username", SMSMgtSetup."SMS Provider Password", SMSMgtSetup."Provider URL");
        BulkSMSMgt.RequestReplays(GetLastReplayId, ResponseData);
        ResponseData.GETSUBTEXT(ResponseText, 1, 250);
        ResponseStatus := COPYSTR(ResponseText, 1, 19);

        IF ResponseStatus = '0|records to follow' THEN BEGIN
            ResponseDataTmp := ResponseData;
            //crlf[1] := 13;
            crlf[1] := 10;
            i := ResponseDataTmp.TEXTPOS(FORMAT(crlf));
            WHILE i > 0 DO BEGIN
                LineNo += 1;
                ResponseDataTmp.GETSUBTEXT(ResponseLine, 1, i);
                IF LineNo > 2 THEN BEGIN
                    CreateSMSReplayEntry(
                      BulkSMSMgt.GetResponseField(ResponseLine, 5),
                      BulkSMSMgt.GetResponseField(ResponseLine, 3),
                      BulkSMSMgt.GetResponseField(ResponseLine, 2),
                      BulkSMSMgt.GetResponseField(ResponseLine, 6),
                      BulkSMSMgt.GetResponseField(ResponseLine, 1)
                    );
                END;
                ResponseDataTmp.GETSUBTEXT(ResponseDataTmp, i + 1);
                i := ResponseDataTmp.TEXTPOS(FORMAT(crlf));
            END;
        END;
    end;

    [Scope('Internal')]
    procedure GetLastReplayId(): Integer
    var
        SMSEntry: Record "25006401";
    begin
        SMSEntry.RESET;
        SMSEntry.SETRANGE(Replay, TRUE);
        IF SMSEntry.FINDLAST THEN
            EXIT(SMSEntry."Provider ReplayId");
    end;

    local procedure CreateSMSEntry(BatchQueueEntryNo: Integer; PhoneNo: Text[30]; Message: Text[250]) EntryNo: Integer
    var
        SMSEntry: Record "25006401";
    begin
        SMSEntry.RESET;
        IF SMSEntry.FINDLAST THEN
            EntryNo := SMSEntry."Entry No." + 1
        ELSE
            EntryNo := 1;

        SMSEntry.INIT;
        SMSEntry."Entry No." := EntryNo;
        SMSEntry."Phone No." := PhoneNo;
        SMSEntry."Message Text" := Message;
        SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Queued;
        SMSEntry."Queue Status" := SMSEntry."Queue Status"::Pending;
        SMSEntry."Batch Queue Entry No." := BatchQueueEntryNo;
        SMSEntry."Entry Created" := CURRENTDATETIME;
        SMSEntry."Contact No." := ContactNo;
        SMSEntry."Salesperson Code" := SalespersonCode;
        SMSEntry."Document No." := DocumentNo;
        SMSEntry."Document Type" := DocumentType;
        SMSEntry.INSERT;
    end;

    local procedure CreateSMSReplayEntry(PhoneNo: Text[30]; Message: Text[250]; ReplayPhoneNo: Text[30]; BatchId: Text; ReplayId: Text) EntryNo: Integer
    var
        SMSEntry: Record "25006401";
    begin
        SMSEntry.RESET;
        IF SMSEntry.FINDLAST THEN
            EntryNo := SMSEntry."Entry No." + 1
        ELSE
            EntryNo := 1;

        SMSEntry.INIT;
        SMSEntry."Entry No." := EntryNo;
        SMSEntry."Phone No." := PhoneNo;
        SMSEntry."Message Text" := Message;
        SMSEntry.Replay := TRUE;
        SMSEntry."Replay Phone No." := ReplayPhoneNo;
        SMSEntry."Provider BatchId" := BatchId;
        EVALUATE(SMSEntry."Provider ReplayId", ReplayId);
        SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Delivered;
        SMSEntry."Queue Status" := SMSEntry."Queue Status"::Finished;
        SMSEntry."Entry Created" := CURRENTDATETIME;
        SMSEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure CreateSMSBatchQueueEntry(MultipleMessageBatch: Boolean; Repliable: Boolean; SenderId: Text) EntryNo: Integer
    var
        SMSBatchQueueEntry: Record "25006402";
        TokenManagement: Codeunit "25006881";
        ErrMsg: Text;
    begin
        IF NOT TokenManagement.CheckTokens(1, 'SMS', ErrMsg) THEN
            ERROR(ErrMsg);

        SMSMgtSetup.GET;
        SMSBatchQueueEntry.RESET;
        IF SMSBatchQueueEntry.FINDLAST THEN
            EntryNo := SMSBatchQueueEntry."Entry No." + 1
        ELSE
            EntryNo := 1;

        SMSBatchQueueEntry.INIT;
        SMSBatchQueueEntry."Entry No." := EntryNo;
        SMSBatchQueueEntry.Status := SMSBatchQueueEntry.Status::Pending;
        SMSBatchQueueEntry."SMS Repliable" := Repliable;
        SMSBatchQueueEntry."SMS SenderId" := SenderId;
        IF MultipleMessageBatch THEN
            SMSBatchQueueEntry."Entry Type" := SMSBatchQueueEntry."Entry Type"::"Multiple SMS"
        ELSE
            SMSBatchQueueEntry."Entry Type" := SMSBatchQueueEntry."Entry Type"::"Single SMS";
        SMSBatchQueueEntry."Entry Created" := CURRENTDATETIME;
        SMSBatchQueueEntry."Expire Date Time" := CREATEDATETIME(CALCDATE(GetBatchQueueExpirePeriodFormula, TODAY), TIME);
        SMSBatchQueueEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure LogRequest(Url: Text; RequestData: BigText; ResponseData: BigText; "Source Type": Option "Std. Request","SMS Message","SMS Batch"; "Source Id": Integer)
    var
        SMSRequestLog: Record "25006400";
        EntryNo: Integer;
        OstreamReq: OutStream;
        OstreamResp: OutStream;
        ReqText: Text;
        RespText: Text;
    begin
        SMSRequestLog.RESET;
        IF SMSRequestLog.FINDLAST THEN
            EntryNo := SMSRequestLog."Entry No." + 1
        ELSE
            EntryNo := 1;


        RequestData.GETSUBTEXT(ReqText, 1, 250);
        ResponseData.GETSUBTEXT(RespText, 1, 250);

        SMSRequestLog.INIT;
        SMSRequestLog."Entry No." := EntryNo;
        SMSRequestLog.Url := Url;
        SMSRequestLog.RequestData := ReqText;
        SMSRequestLog.ResponseData := RespText;
        SMSRequestLog."Source Type" := "Source Type";
        SMSRequestLog."Source Id" := "Source Id";
        SMSRequestLog.RequestDataBlob.CREATEOUTSTREAM(OstreamReq);
        RequestData.WRITE(OstreamReq);
        SMSRequestLog.ResponseDataBlob.CREATEOUTSTREAM(OstreamResp);
        ResponseData.WRITE(OstreamResp);
        SMSRequestLog."Entry Time" := CURRENTDATETIME;
        SMSRequestLog.INSERT;
        COMMIT;
    end;

    [Scope('Internal')]
    procedure ClearSMSBatch()
    begin
        SMSBatchBuffer.DELETEALL;
    end;

    [Scope('Internal')]
    procedure AddSMSToBatch(PhoneNo: Text; MessageText: Text)
    var
        EntryNo: Integer;
    begin
        IF SMSBatchBuffer.FINDLAST THEN
            EntryNo := SMSBatchBuffer."Entry No." + 1
        ELSE
            EntryNo := 1;

        SMSBatchBuffer.INIT;
        SMSBatchBuffer."Entry No." := EntryNo;
        SMSBatchBuffer."Phone No." := PhoneNo;
        SMSBatchBuffer."Message Text" := MessageText;
        SMSBatchBuffer.INSERT;
    end;

    [Scope('Internal')]
    procedure UpdateSMSEntryStatusForBatch(BatchQueueEntryNo: Integer; SMSQueueStatus: Option; SMSDeliveryStatus: Option; ProviderBatchId: Text): Boolean
    var
        SMSEntry: Record "25006401";
    begin
        SMSEntry.RESET;
        SMSEntry.SETRANGE(SMSEntry."Batch Queue Entry No.", BatchQueueEntryNo);
        IF SMSEntry.FINDFIRST THEN
            REPEAT
                SMSEntry."Provider BatchId" := ProviderBatchId;
                SMSEntry."Queue Status" := SMSQueueStatus;
                SMSEntry."Delivery Status" := SMSDeliveryStatus;
                SMSEntry."Sent In Multiple Batch" := TRUE;
                IF SMSEntry."Delivery Status" = SMSEntry."Delivery Status"::Sent THEN
                    SMSEntry."Message Sent" := CURRENTDATETIME;
                SMSEntry.MODIFY;
            UNTIL SMSEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateSMSByReportedStatus(SMSEntryNo: Integer; ReportedStatus: Integer)
    var
        SMSEntry: Record "25006401";
        SegManagement: Codeunit "5051";
    begin
        IF SMSEntry.GET(SMSEntryNo) THEN BEGIN
            CASE ReportedStatus OF
                0://In Progress
                    SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Sent;
                10:
                    SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Delivered;
                11:
                    SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Delivered;
                12:
                    SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Delivered;
                50:
                    SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Failed;
                ELSE
                    SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Failed;
            END;

            IF SMSEntry."Delivery Status" = SMSEntry."Delivery Status"::Delivered THEN BEGIN
                SMSEntry."Interaction Log Entry No." := SegManagement.LogSMSContactInteraction(SMSEntryNo);
            END;

            SMSEntry.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure GetBatchQueueExpirePeriodFormula() ExpireFormula: Code[10]
    begin
        SMSMgtSetup.GET;
        CASE SMSMgtSetup."Sms Batch Queue Expire Period" OF
            SMSMgtSetup."Sms Batch Queue Expire Period"::"2 Days":
                ExpireFormula := '<2D>';
            SMSMgtSetup."Sms Batch Queue Expire Period"::"7 Days":
                ExpireFormula := '<7D>';
            SMSMgtSetup."Sms Batch Queue Expire Period"::"14 Days":
                ExpireFormula := '<14D>';
            ELSE
                ExpireFormula := '<2D>';
        END;
    end;

    [Scope('Internal')]
    procedure GetBatchQueueArchivePeriodFormula() ArchiveFormula: Code[10]
    begin
        SMSMgtSetup.GET;
        CASE SMSMgtSetup."Sms Batch Queue Arch. Period" OF
            SMSMgtSetup."Sms Batch Queue Arch. Period"::"30 Days":
                ArchiveFormula := '<-30D>';
            SMSMgtSetup."Sms Batch Queue Arch. Period"::"60 Days":
                ArchiveFormula := '<-60D>';
            SMSMgtSetup."Sms Batch Queue Arch. Period"::"90 Days":
                ArchiveFormula := '<-90D>';
            ELSE
                ArchiveFormula := '<-30D>';
        END;
    end;

    [Scope('Internal')]
    procedure SetContactNo(ContactNoToSet: Code[20])
    begin
        ContactNo := ContactNoToSet;
    end;

    [Scope('Internal')]
    procedure SetSalespersonCode(SalespersonCodeToSet: Code[10])
    begin
        SalespersonCode := SalespersonCodeToSet;
    end;

    [Scope('Internal')]
    procedure SetDocumentNo(DocumentNoToSet: Code[20])
    begin
        DocumentNo := DocumentNoToSet;
    end;

    [Scope('Internal')]
    procedure SetDocumentType(DocumentTypeToSet: Option)
    begin
        DocumentType := DocumentTypeToSet;
    end;
}

