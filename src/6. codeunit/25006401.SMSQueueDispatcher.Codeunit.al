codeunit 25006401 "SMS Queue Dispatcher"
{

    trigger OnRun()
    var
        ResponseText: Text[250];
        ReportedStatus: Integer;
        ResponseData: BigText;
        ResponseStatus: Text;
        BatchQueueEntry: Record "25006402";
        RequestLog: Record "25006400";
        cr: Char;
        BatchData: BigText;
        AllSMSEntryFinished: Boolean;
        ProviderField: Text;
        ProviderBatchCost: Decimal;
        TokenManagement: Codeunit "25006881";
    begin
        SMSMgtSetup.GET;
        BulkSMSManagement.SetPrerequisites(SMSMgtSetup."SMS Provider Username", SMSMgtSetup."SMS Provider Password", SMSMgtSetup."Provider URL");

        //Clear Old History Entries
        BatchQueueEntry.RESET;
        BatchQueueEntry.SETFILTER("Expire Date Time", '<%1', CREATEDATETIME(CALCDATE(SMSManagement.GetBatchQueueArchivePeriodFormula, TODAY), TIME));
        IF BatchQueueEntry.FINDFIRST THEN BEGIN
            BatchQueueEntry.DELETEALL;
        END;

        RequestLog.RESET;
        RequestLog.SETFILTER(RequestLog."Entry Time", '<%1', CREATEDATETIME(CALCDATE(SMSManagement.GetBatchQueueArchivePeriodFormula, TODAY), TIME));
        IF RequestLog.FINDFIRST THEN BEGIN
            RequestLog.DELETEALL;
        END;

        //Finish Expired batches
        BatchQueueEntry.RESET;
        IF BatchQueueEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF BatchQueueEntry."Expire Date Time" < CURRENTDATETIME THEN BEGIN
                    BatchQueueEntry.Status := BatchQueueEntry.Status::Finished;
                    BatchQueueEntry.MODIFY;
                END;
            UNTIL BatchQueueEntry.NEXT = 0;
        END;

        //Get report for all sent sms
        ResponseText := '';
        BatchQueueEntry.RESET;
        BatchQueueEntry.SETRANGE(BatchQueueEntry.Status, BatchQueueEntry.Status::"Waiting Report");
        IF BatchQueueEntry.FINDFIRST THEN BEGIN
            REPEAT
                AllSMSEntryFinished := TRUE;

                //Single SMS Batch
                SMSEntry.RESET;
                SMSEntry.SETRANGE(SMSEntry."Batch Queue Entry No.", BatchQueueEntry."Entry No.");
                SMSEntry.SETRANGE(SMSEntry."Queue Status", SMSEntry."Queue Status"::"Waiting Report");
                IF SMSEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        IF BulkSMSManagement.RequestReport(BatchQueueEntry."Entry No.", BatchQueueEntry."Provider BatchId", SMSEntry."Phone No.", ResponseData) THEN BEGIN
                            ResponseData.GETSUBTEXT(ResponseText, 1, 250);
                            ResponseStatus := BulkSMSManagement.GetResponseField(ResponseText, 1);
                            IF ResponseStatus = '0' THEN BEGIN
                                ResponseText := DELSTR(ResponseText, 1, 19);
                                ResponseText := DELCHR(ResponseText, '<>', ' ');
                                ResponseText := BulkSMSManagement.ClearText(ResponseText);
                                ResponseText := DELCHR(ResponseText, '<>', ' ');
                            END ELSE
                                ResponseText := '';

                            IF EVALUATE(ReportedStatus, BulkSMSManagement.GetResponseField(ResponseText, 2)) THEN;
                            IF ReportedStatus <> 0 THEN BEGIN
                                //(0 - in progress)
                                SMSEntry."Provider Reported Status" := ReportedStatus;
                                SMSEntry."Queue Status" := SMSEntry."Queue Status"::Finished;
                                SMSEntry.MODIFY;
                            END ELSE
                                AllSMSEntryFinished := FALSE;
                            SMSManagement.UpdateSMSByReportedStatus(SMSEntry."Entry No.", ReportedStatus);
                        END ELSE BEGIN
                            AllSMSEntryFinished := FALSE;
                            BatchQueueEntry."Last Request Attempt" := CURRENTDATETIME;
                            BatchQueueEntry."Request Attempts" += 1;
                            BatchQueueEntry.MODIFY;
                        END;
                    UNTIL SMSEntry.NEXT = 0;
                END;
                IF AllSMSEntryFinished THEN BEGIN
                    BatchQueueEntry.Status := BatchQueueEntry.Status::Finished;
                    BatchQueueEntry.MODIFY;
                END;
            UNTIL BatchQueueEntry.NEXT = 0;
        END;

        //Send All Queued SMS Messages
        ResponseText := '';
        BatchQueueEntry.RESET;
        BatchQueueEntry.SETRANGE(BatchQueueEntry.Status, BatchQueueEntry.Status::Pending);

        IF BatchQueueEntry.FINDFIRST THEN BEGIN
            REPEAT
                ProviderBatchCost := 0;
                IF BatchQueueEntry."Entry Type" = BatchQueueEntry."Entry Type"::"Single SMS" THEN BEGIN
                    //Single SMS Batch
                    SMSEntry.RESET;
                    SMSEntry.SETRANGE(SMSEntry."Batch Queue Entry No.", BatchQueueEntry."Entry No.");
                    IF SMSEntry.FINDFIRST THEN BEGIN
                        BulkSMSManagement.SetRepliable(BatchQueueEntry."SMS Repliable");
                        BulkSMSManagement.SetSenderId(BatchQueueEntry."SMS SenderId");

                        //Get Batch Cost
                        BulkSMSManagement.RequestSendSMSQuote(SMSEntry."Phone No.", SMSEntry."Message Text", BatchQueueEntry."Entry No.", ResponseData);
                        ResponseData.GETSUBTEXT(ResponseText, 1, 250);
                        ProviderField := BulkSMSManagement.GetResponseField(ResponseText, 3);
                        IF ProviderField <> '' THEN
                            EVALUATE(ProviderBatchCost, ProviderField);

                        IF BulkSMSManagement.RequestSendSMS(SMSEntry."Phone No.", SMSEntry."Message Text", BatchQueueEntry."Entry No.", ResponseData) THEN BEGIN
                            ResponseData.GETSUBTEXT(ResponseText, 1, 250);
                            ResponseStatus := BulkSMSManagement.GetResponseField(ResponseText, 1);
                            IF ResponseStatus = '0' THEN BEGIN
                                BatchQueueEntry."Provider BatchId" := BulkSMSManagement.GetResponseField(ResponseText, 3);
                                BatchQueueEntry.Status := BatchQueueEntry.Status::"Waiting Report";
                                BatchQueueEntry."Last Request Attempt" := CURRENTDATETIME;
                                BatchQueueEntry."Request Attempts" += 1;
                                BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                                BatchQueueEntry.MODIFY;

                                SMSEntry."Provider BatchId" := BatchQueueEntry."Provider BatchId";
                                SMSEntry."Queue Status" := SMSEntry."Queue Status"::"Waiting Report";
                                SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Sent;
                                SMSEntry."Message Sent" := CURRENTDATETIME;
                                SMSEntry."Provider Batch Cost" := ProviderBatchCost;
                                SMSEntry.MODIFY;
                                TokenManagement.RegisterSpentTokens(1, 'SMS', FORMAT(SMSEntry."Entry No."));
                            END ELSE BEGIN
                                BatchQueueEntry."Provider BatchId" := BulkSMSManagement.GetResponseField(ResponseText, 3);
                                BatchQueueEntry.Status := BatchQueueEntry.Status::Finished;
                                BatchQueueEntry."Last Request Attempt" := CURRENTDATETIME;
                                BatchQueueEntry."Request Attempts" += 1;
                                BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                                BatchQueueEntry.MODIFY;

                                SMSEntry."Provider BatchId" := BatchQueueEntry."Provider BatchId";
                                SMSEntry."Delivery Status" := SMSEntry."Delivery Status"::Failed;
                                SMSEntry."Queue Status" := SMSEntry."Queue Status"::Finished;
                                SMSEntry."Provider Batch Cost" := ProviderBatchCost;
                                SMSEntry.MODIFY;
                            END;
                        END ELSE BEGIN
                            BatchQueueEntry."Last Request Attempt" := CURRENTDATETIME;
                            BatchQueueEntry."Request Attempts" += 1;
                            BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                            BatchQueueEntry.MODIFY;
                        END;
                    END;
                END ELSE BEGIN
                    //Multiple SMS Batch
                    SMSEntry.RESET;
                    SMSEntry.SETRANGE(SMSEntry."Batch Queue Entry No.", BatchQueueEntry."Entry No.");
                    IF SMSEntry.FINDFIRST THEN BEGIN
                        BulkSMSManagement.SetRepliable(BatchQueueEntry."SMS Repliable");
                        BulkSMSManagement.SetSenderId(BatchQueueEntry."SMS SenderId");

                        CLEAR(BatchData);
                        REPEAT
                            BatchData.ADDTEXT(SMSEntry."Phone No." + ',');
                        UNTIL SMSEntry.NEXT = 0;

                        //Get Batch Cost
                        BulkSMSManagement.RequestSendSMSBatchQuote(BatchQueueEntry."Entry No.", BatchData, SMSEntry."Message Text", ResponseData);
                        ResponseData.GETSUBTEXT(ResponseText, 1, 250);
                        ProviderField := BulkSMSManagement.GetResponseField(ResponseText, 3);
                        IF ProviderField <> '' THEN
                            EVALUATE(ProviderBatchCost, ProviderField);

                        IF BulkSMSManagement.RequestSendSMSBatch(BatchQueueEntry."Entry No.", BatchData, SMSEntry."Message Text", ResponseData) THEN BEGIN
                            ResponseData.GETSUBTEXT(ResponseText, 1, 250);
                            ResponseStatus := BulkSMSManagement.GetResponseField(ResponseText, 1);
                            IF ResponseStatus = '0' THEN BEGIN
                                BatchQueueEntry."Provider BatchId" := BulkSMSManagement.GetResponseField(ResponseText, 3);
                                BatchQueueEntry.Status := BatchQueueEntry.Status::"Waiting Report";
                                BatchQueueEntry."Last Request Attempt" := CURRENTDATETIME;
                                BatchQueueEntry."Request Attempts" += 1;
                                BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                                BatchQueueEntry.MODIFY;
                                SMSManagement.UpdateSMSEntryStatusForBatch(
                                  BatchQueueEntry."Entry No.",
                                  SMSEntry."Queue Status"::"Waiting Report",
                                  SMSEntry."Delivery Status"::Sent,
                                  BatchQueueEntry."Provider BatchId");
                                TokenManagement.RegisterSpentTokens(1, 'SMS', FORMAT(SMSEntry."Entry No."));
                            END ELSE BEGIN
                                BatchQueueEntry.Status := BatchQueueEntry.Status::Finished;
                                BatchQueueEntry."Last Request Attempt" := CURRENTDATETIME;
                                BatchQueueEntry."Request Attempts" += 1;
                                BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                                BatchQueueEntry.MODIFY;
                                SMSManagement.UpdateSMSEntryStatusForBatch(
                                  BatchQueueEntry."Entry No.",
                                  SMSEntry."Queue Status"::Finished,
                                  SMSEntry."Delivery Status"::Failed,
                                  BatchQueueEntry."Provider BatchId");
                            END;
                        END ELSE BEGIN
                            BatchQueueEntry."Last Request Attempt" := CURRENTDATETIME;
                            BatchQueueEntry."Request Attempts" += 1;
                            BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                            BatchQueueEntry.MODIFY;
                        END;
                    END;
                END;
            UNTIL BatchQueueEntry.NEXT = 0;
        END;

        //Get Replay messages
        SMSManagement.GetReplays();
    end;

    var
        SMSEntry: Record "25006401";
        SMSManagement: Codeunit "25006400";
        BulkSMSManagement: Codeunit "25006402";
        SMSMgtSetup: Record "25006403";
}

