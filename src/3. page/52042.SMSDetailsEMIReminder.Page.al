page 52042 "SMS Details EMI Reminder"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020258;
    SourceTableView = WHERE(Message Type=FILTER(Credit Bill Follow up|Reschedule Tenure|15));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No.";"Document No.")
                {
                }
                field("Mobile Number";"Mobile Number")
                {
                }
                field("Message Text";"Message Text")
                {
                }
                field(Status;Status)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group()
            {
                action("Re-Send Failed SMS")
                {
                    Ellipsis = true;
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        SMSDetails: Record "33020258";
                        Text000: Label 'Processed : #1######\Total Failed Records : #2######## \SMS Success Count : #3######\SMS Failed Count : #4######';
                        SMSWebService: Codeunit "50002";
                        MessageID: Text;
                        ProgressWindow: Dialog;
                        SuccessCount: Integer;
                        FailedCount: Integer;
                        TotalProcessedRecords: Integer;
                    begin
                        //SRT Jan 23rd 2020 >>
                        IF NOT CONFIRM('Do you want to re-send all the failed sms again?',FALSE) THEN
                          EXIT;

                        SMSDetails.RESET;
                        SMSDetails.SETRANGE(Status,SMSDetails.Status::Failed);
                        //Processed : #1######\Total Failed Records : #2######## \SMS Success Count : #3######\SMS Failed Count : #4######
                        ProgressWindow.OPEN(Text000);
                        ProgressWindow.UPDATE(2,SMSDetails.COUNT);
                        IF SMSDetails.FINDFIRST THEN REPEAT
                           CLEAR(SMSWebService);
                           IF SMSWebService.SendSMS(SMSDetails."Mobile Number",SMSDetails."Message Text",MessageID) THEN BEGIN
                            SMSDetails.Status := SMSDetails.Status::Sent;
                            SMSDetails.Comment := 'SENT';
                            SMSDetails."SMS API Response" := MessageID;
                            SMSDetails.MODIFY;
                            SuccessCount += 1;
                            ProgressWindow.UPDATE(3,SuccessCount);
                           END ELSE BEGIN
                            SMSDetails.Status := SMSDetails.Status::Failed;  //if response code is not 201
                            SMSDetails.Comment := 'Failed';
                            SMSDetails."SMS API Response" := MessageID;
                            SMSDetails.MODIFY;
                            FailedCount += 1;
                            ProgressWindow.UPDATE(4,FailedCount);
                           END;
                           TotalProcessedRecords += 1;
                           ProgressWindow.UPDATE(1,TotalProcessedRecords);
                        UNTIL SMSDetails.NEXT = 0;
                        //SRT Jan 23rd 2020 <<
                    end;
                }
            }
        }
    }
}

