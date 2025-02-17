codeunit 50002 "SMS Web Service"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Sending SMS...';
        Text001: Label 'Sending SMS message failed!\Statuscode: %1\Description: %2';
        MessageID: Text[250];
        MessageBody: Text[1024];
        SMSSetup: Record "50006";

    [Scope('Internal')]
    procedure SendSMS(PhoneNo: Text; MessageText: Text; var MessageID: Text[250]) ReturnValue: Boolean
    var
        SMSSetup: Record "50006";
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        encoding: DotNet Encoding;
        result: DotNet String;
        resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        JsonConvert: DotNet JsonConvert;
        null: DotNet Object;
        Window: Dialog;
        data: Text;
        statusCode: Text;
        statusText: Text;
        ResponseCode: Code[10];
    begin
        SMSSetup.GET;
        SMSSetup.TESTFIELD("User Name");
        SMSSetup.TESTFIELD("Password Key");
        SMSSetup.TESTFIELD("SMS Text Length");

        IF GUIALLOWED THEN
            Window.OPEN(Text000);

        data := 'token=' + SMSSetup.Token;
        data += '&username=' + SMSSetup."User Name";
        data += '&password=' + SMSSetup.GetPassword;
        data += '&from=' + SMSSetup.Identity;
        data += '&to=' + PhoneNo;
        data += '&text=' + COPYSTR(MessageText, 1, SMSSetup."SMS Text Length");

        stringContent := stringContent.StringContent(data, encoding.UTF8, 'application/x-www-form-urlencoded');


        ReturnValue := CallRESTWebService1(SMSSetup."Base URL",
                                                           SMSSetup.Method,
                                                           FORMAT(SMSSetup.RESTMethod),
                                                           stringContent,
                                                           HttpResponseMessage);
        IF GUIALLOWED THEN
            Window.CLOSE;

        IF NOT ReturnValue THEN
            EXIT;

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        //MESSAGE('result--->'+FORMAT(result));

        separator := ',';
        resultParts := result.Split(separator.ToCharArray());
        // result message sample // Apr 09 2018 >>> {"response_code": 200, "response": "1 mesages has been queued for delivery", "credit_consumed": 1, "count": 1, "credit_available": 11534.0, "message_id": 3877008}

        //statusCode := resultParts.GetValue(0);
        //statusText := resultParts.GetValue(1);
        //MessageID := DELSTR(FORMAT(resultParts.GetValue(0)),1,18);   //ZM-Agile Apr 09, 2018
        //ResponseCode := MessageID;

        //Result = {"response": "1 mesages has been queued for delivery", "response_code": 200, "count": 1, "message_id": 7578842, "credit_available": 16832.0, "credit_consumed": 1}   //June 14, 2018
        statusCode := FORMAT(result);
        ResponseCode := COPYSTR(statusCode, STRPOS(statusCode, 'response_code') + 16, 3);   //To get response code  //ZM Agile June 14, 2018
        MessageID := result.ToString; //+ ' : ' + ErrorMessage;
        IF (ResponseCode = '200') THEN BEGIN
            EXIT(TRUE);
        END
        ELSE BEGIN
            EXIT(FALSE);
        END;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure CallRESTWebService(BaseUrl: Text; Method: Text; RestMethod: Text; var HttpContent: DotNet HttpContent; var HttpResponseMessage: DotNet HttpResponseMessage)
    var
        HttpClient: DotNet HttpClient;
        Uri: DotNet Uri;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseUrl);


        CASE RestMethod OF
            'GET':
                HttpResponseMessage := HttpClient.GetAsync(Method).Result;
            'POST':
                HttpResponseMessage := HttpClient.PostAsync(Method, HttpContent).Result;
            'PUT':
                HttpResponseMessage := HttpClient.PutAsync(Method, HttpContent).Result;
            'DELETE':
                HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        END;

        HttpResponseMessage.EnsureSuccessStatusCode();
    end;

    [Scope('Internal')]
    procedure InsertSMSInsuranceReminder(DocumentNo: Code[20]; CustomerCode: Code[20]; ExpiryDate: Date; RenewingPolicyDate: Date; PolicyNo: Text[100]; VehicleSerialNo: Code[20])
    var
        SMSTemplates: Record "33020257";
        SMSDetails: Record "33020258";
        SMSDetailsRec: Record "33020258";
        Customer: Record "18";
        Text000: Label 'There is no SMS Templates for Document Profile %1 and Message Type %2.';
        MessageText: Text;
        InsertRecord: Boolean;
        MobileNo: Code[50];
    begin
        IF NOT SendSMSSetupExists THEN
            EXIT;
        IF Customer.GET(CustomerCode) THEN BEGIN
            IF NOT Customer."SMS Not Required" THEN BEGIN
                MobileNo := Customer."Mobile No.";
                IF (MobileNo <> '') AND (STRLEN(MobileNo) < 20) THEN BEGIN
                    MessageText := '';
                    SMSTemplates.RESET;
                    SMSTemplates.SETRANGE(Type, SMSTemplates.Type::"Insurance Reminder");
                    IF SMSTemplates.FINDFIRST THEN BEGIN
                        MessageBody := SMSTemplates."Message Text" + SMSTemplates."Message Text 2";
                        MessageText := STRSUBSTNO(MessageBody, ExpiryDate, VehicleSerialNo);
                    END;
                    IF (MessageText <> '') THEN BEGIN
                        CLEAR(SMSDetails);
                        SMSDetails.LOCKTABLE;
                        IF SMSDetails.FINDLAST THEN
                            SMSDetails."Entry No." += 1
                        ELSE
                            SMSDetails."Entry No." := 1;
                        SMSDetails.INIT;
                        SMSDetails."Message Text" := SMSTemplates."Message Text";
                        SMSDetails."Message Text 2" := SMSTemplates."Message Text 2";
                        SMSDetails."Mobile Number" := MobileNo;
                        SMSDetails."Creation Date" := CURRENTDATETIME;
                        SMSDetails."Message Type" := SMSDetails."Message Type"::"16";
                        SMSDetails.Status := SMSDetails.Status::New;
                        SMSDetails."Last Modified Date" := CURRENTDATETIME;
                        SMSDetails."Document No." := DocumentNo;
                        SMSDetails.Company := COMPANYNAME;
                        SMSDetails."Policy No." := PolicyNo;
                        SMSDetails.INSERT;
                        //SRT Jan 23rd 2020 >>
                        IF SendSMS(SMSDetails."Mobile Number", MessageText, MessageID) THEN BEGIN
                            SMSDetails.Status := SMSDetails.Status::Sent;
                            SMSDetails.Comment := 'SENT';
                            SMSDetails."SMS API Response" := MessageID;
                            SMSDetails.MODIFY
                        END ELSE BEGIN
                            SMSDetails.Status := SMSDetails.Status::Failed;  //if response code is not 201
                            SMSDetails.Comment := 'Failed';
                            SMSDetails."SMS API Response" := MessageID;
                            SMSDetails.MODIFY
                        END;
                        //SRT Jan 23rd 2020 <<
                    END;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SendSMSSetupExists(): Boolean
    var
        SalesSetup: Record "311";
    begin
        SalesSetup.GET;
        EXIT(SalesSetup."Activate SMS System");
    end;

    [Scope('Internal')]
    procedure SendSMSTest()
    var
        SMSTemplates: Record "33020257";
        SMSDetails: Record "33020258";
        SMSDetailsRec: Record "33020258";
        Customer: Record "18";
        MessageText: Text[1024];
        InsertRecord: Boolean;
        MobileNo: Code[50];
    begin
        /*IF NOT SendSMSSetupExists THEN
          EXIT;*/

        // IF NOT Customer."SMS Not Required" THEN BEGIN
        MobileNo := '9860133216';
        IF (MobileNo <> '') AND (STRLEN(MobileNo) < 20) THEN BEGIN
            MessageText := '';
            SMSTemplates.RESET;
            SMSTemplates.SETRANGE(Type, SMSTemplates.Type::"Insurance Reminder");
            IF SMSTemplates.FINDFIRST THEN BEGIN
                MessageBody := STRSUBSTNO(SMSTemplates."Message Text") + STRSUBSTNO(SMSTemplates."Message Text 2");
                MessageText := STRSUBSTNO(MessageBody, '007', '1.12.2022');
            END;
            IF (MessageText <> '') THEN BEGIN
                CLEAR(SMSDetails);
                SMSDetails.LOCKTABLE;
                IF SMSDetails.FINDLAST THEN
                    SMSDetails."Entry No." += 1
                ELSE
                    SMSDetails."Entry No." := 1;
                SMSDetails.INIT;
                SMSDetails."Message Text" := SMSTemplates."Message Text";
                SMSDetails."Message Text 2" := SMSTemplates."Message Text 2";
                SMSDetails."Mobile Number" := MobileNo;
                SMSDetails."Creation Date" := CURRENTDATETIME;
                SMSDetails."Message Type" := SMSDetails."Message Type"::"16";
                SMSDetails.Status := SMSDetails.Status::New;
                SMSDetails."Last Modified Date" := CURRENTDATETIME;
                //   SMSDetails."Document No." := DocumentNo;
                SMSDetails.Company := COMPANYNAME;
                //    SMSDetails."Policy No." := PolicyNo;
                SMSDetails.INSERT;
                //SRT Jan 23rd 2020 >>
                IF SendSMS(MobileNo, MessageText, MessageID) THEN BEGIN
                    SMSDetails.Status := SMSDetails.Status::Sent;
                    SMSDetails.Comment := 'SENT';
                    SMSDetails."SMS API Response" := MessageID;
                    SMSDetails.MODIFY
                END ELSE BEGIN
                    SMSDetails.Status := SMSDetails.Status::Failed;  //if response code is not 201
                    SMSDetails.Comment := 'Failed';
                    SMSDetails."SMS API Response" := MessageID;
                    SMSDetails.MODIFY
                END;
                //SRT Jan 23rd 2020 <<
                // END;

            END;
        END;
        MESSAGE('Message Sent');

    end;

    [Scope('Internal')]
    procedure SendSMS1(PhoneNo: Text; MessageText: Text; var MessageID: Text[250]; MessageLength: Integer): Boolean
    begin
        SMSSetup.GET;
        IF SMSSetup."Enable Agile SMS Gateway" THEN BEGIN
            EXIT(SendAgileSMS(PhoneNo, MessageText, MessageID, MessageLength))
        END ELSE BEGIN
            EXIT(SendSparrowSMS(PhoneNo, MessageText, MessageID));
        END;
    end;

    local procedure SendAgileSMS(PhoneNo: Text; MessageText: Text; var MessageID: Text[250]; MessageLength: Integer) ReturnValue: Boolean
    var
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        encoding: DotNet Encoding;
        result: DotNet String;
        resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        JsonConvert: DotNet JsonConvert;
        null: DotNet Object;
        Window: Dialog;
        data: Text;
        statusCode: Text;
        statusText: Text;
        ResponseCode: Code[10];
    begin
        SMSSetup.TESTFIELD("Agile Base URL");
        SMSSetup.TESTFIELD("Agile User Name");
        SMSSetup.TESTFIELD("Agile Password Key");
        SMSSetup.TESTFIELD("Agile SMS Length (1st)");
        SMSSetup.TESTFIELD("Agile SMS Length (2nd & above)");
        SMSSetup.TESTFIELD("SMS Length (1st) Unicode");
        SMSSetup.TESTFIELD("SMS Length (2nd & above) Unico");

        IF GUIALLOWED THEN
            Window.OPEN(Text000);

        data := '{"clientCode":"' + SMSSetup."Agile Client Code" + '","';
        data += 'mobileNumber":"' + PhoneNo + '","';
        data += 'textMessage":"' + MessageText + '","';
        data += 'messageLength":"' + FORMAT(CalculateMessageLength(MessageText)) + '"}';

        stringContent := stringContent.StringContent(data, encoding.UTF8, 'application/json');


        ReturnValue := CallRESTWebService1(SMSSetup."Agile Base URL",
                                                           SMSSetup."Agile Method",
                                                           FORMAT(SMSSetup."Agile RESTMethod"),
                                                           stringContent,
                                                           HttpResponseMessage);
        IF GUIALLOWED THEN
            Window.CLOSE;

        IF NOT ReturnValue THEN
            EXIT;

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;

        MessageID := result;

        separator := ',';
        resultParts := result.Split(separator.ToCharArray());
        statusCode := FORMAT(result);
        ResponseCode := COPYSTR(statusCode, STRPOS(statusCode, 'response_code') + 16, 3);

        EXIT(TRUE);
    end;

    local procedure SendSparrowSMS(PhoneNo: Text; MessageText: Text; var MessageID: Text[250]) ReturnValue: Boolean
    var
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        encoding: DotNet Encoding;
        result: DotNet String;
        resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        JsonConvert: DotNet JsonConvert;
        null: DotNet Object;
        Window: Dialog;
        data: Text;
        statusCode: Text;
        statusText: Text;
        ResponseCode: Code[10];
    begin
        IF SMSSetup."User Name" = '' THEN
            EXIT;
        SMSSetup.TESTFIELD("User Name");
        SMSSetup.TESTFIELD("Password Key");
        SMSSetup.TESTFIELD("SMS Text Length");

        IF GUIALLOWED THEN
            Window.OPEN(Text000);

        data := 'token=' + SMSSetup.Token;
        data += '&username=' + SMSSetup."User Name";
        data += '&password=' + SMSSetup.GetPassword;
        data += '&from=' + SMSSetup.Identity;
        data += '&to=' + PhoneNo;
        data += '&text=' + COPYSTR(MessageText, 1, SMSSetup."SMS Text Length");

        stringContent := stringContent.StringContent(data, encoding.UTF8, 'application/x-www-form-urlencoded');


        ReturnValue := CallRESTWebService(SMSSetup."Base URL",
                                                           SMSSetup.Method,
                                                           FORMAT(SMSSetup.RESTMethod),
                                                           stringContent,
                                                           HttpResponseMessage);
        IF GUIALLOWED THEN
            Window.CLOSE;

        IF NOT ReturnValue THEN
            EXIT;

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        //MESSAGE('result--->'+FORMAT(result));

        separator := ',';
        resultParts := result.Split(separator.ToCharArray());
        statusCode := FORMAT(result);
        ResponseCode := COPYSTR(statusCode, STRPOS(statusCode, 'response_code') + 16, 3);

        IF (ResponseCode = '200') THEN BEGIN
            EXIT(TRUE);
        END
        ELSE BEGIN
            EXIT(FALSE);
        END;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure CallRESTWebService1(BaseUrl: Text; Method: Text; RestMethod: Text; var HttpContent: DotNet HttpContent; var HttpResponseMessage: DotNet HttpResponseMessage)
    var
        HttpClient: DotNet HttpClient;
        Uri: DotNet Uri;
        HttpClientHandler: DotNet HttpClientHandler;
        NetCredential: DotNet NetworkCredential;
    begin
        HttpClientHandler := HttpClientHandler.HttpClientHandler;

        //add httpclienthandler to httpclient:
        IF SMSSetup."Enable Agile SMS Gateway" THEN BEGIN
            HttpClientHandler.Credentials := NetCredential.NetworkCredential(SMSSetup."Agile User Name", SMSSetup."Agile Password Key");
            HttpClient := HttpClient.HttpClient(HttpClientHandler)
        END ELSE BEGIN
            HttpClient := HttpClient.HttpClient();
        END;

        HttpClient.BaseAddress := Uri.Uri(BaseUrl);

        CASE RestMethod OF
            'GET':
                HttpResponseMessage := HttpClient.GetAsync(Method).Result;
            'POST':
                BEGIN
                    IF SMSSetup."Enable Agile SMS Gateway" THEN
                        HttpResponseMessage := HttpClient.PostAsync('Microsoft.NAV.sendSMSviaAgileGateway', HttpContent).Result
                    ELSE
                        HttpResponseMessage := HttpClient.PostAsync(Method, HttpContent).Result;
                END;
            'PUT':
                HttpResponseMessage := HttpClient.PutAsync(Method, HttpContent).Result;
            'DELETE':
                HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        END;

        HttpResponseMessage.EnsureSuccessStatusCode();
    end;

    [Scope('Internal')]
    procedure PopUpForTestSMS()
    var
        PageBuilderSMSDetails: FilterPageBuilder;
        SMSDetails: Record "60001";
        MobileNo: Text;
        MessageText: Text;
        MessageID: Text;
        MessageLength: Integer;
    begin
        //IF NOT CONFIRM('Do you want to send test sms?',FALSE) THEN
        //EXIT;
        CLEAR(SMSDetails);
        SMSSetup.GET;
        /*PageBuilderSMSDetails.ADDRECORD('Send Test SMS',SMSDetails);
        PageBuilderSMSDetails.ADDFIELD('Send Test SMS',SMSDetails."Mobile Number");
        PageBuilderSMSDetails.ADDFIELD('Send Test SMS',SMSDetails."Message Text");
        IF PageBuilderSMSDetails.RUNMODAL THEN BEGIN
          SMSDetails.SETVIEW(PageBuilderSMSDetails.GETVIEW('Send Test SMS'));
        
          IF SMSDetails.GETFILTER("Mobile Number") ='' THEN
            ERROR('Please type mobile no. for test');
          IF SMSDetails.GETFILTER("Message Text") = '' THEN
            MessageText := 'Testing SMS'
          ELSE
            MessageText := SMSDetails.GETFILTER("Message Text");
            */
        InsertSMSDetail(0, '', '9841851411', 'Test the SMS process.');
        //END;

    end;

    local procedure CalculateMessageLength(TextMessage: Text): Integer
    var
        AsciiBytesCount: Integer;
        UnicodeBytesCount: Integer;
        Encoding: DotNet Encoding;
    begin
        SMSSetup.GET;
        AsciiBytesCount := Encoding.ASCII.GetByteCount(TextMessage);
        UnicodeBytesCount := Encoding.Unicode.GetByteCount(TextMessage);
        IF AsciiBytesCount <> UnicodeBytesCount THEN BEGIN
            IF AsciiBytesCount <= SMSSetup."SMS Length (1st) Unicode" THEN
                EXIT(1)
            ELSE
                EXIT(1 + ROUND(((AsciiBytesCount - SMSSetup."SMS Length (1st) Unicode") / SMSSetup."SMS Length (2nd & above) Unico"), 1, '>'));
        END ELSE BEGIN
            IF AsciiBytesCount <= SMSSetup."Agile SMS Length (1st)" THEN
                EXIT(1)
            ELSE
                EXIT(1 + ROUND(((AsciiBytesCount - SMSSetup."Agile SMS Length (1st)") / SMSSetup."Agile SMS Length (2nd & above)"), 1, '>'));
        END;
    end;

    [Scope('Internal')]
    procedure InsertSMSDetail(MessageType: Option Bill,Job,Birthday,"Service Reminder","Revised Job",KAM,"Service Booking","Service Booking Reminder","Credit Bill","Credit Bill Due Date Reminder","Credit Bill Due Date Crossed Reminder","EMI Due Reminder","Credit Bill Follow up","Finance Charge Memo","BG Expiry 7 Days","BG Expiry 15 Days","BG Expiry 30 Days","Post Receipt","LC Expiry 7 Days","LC Expiry 15 Days","LC Expiry 30 Days","OTP Code"; DocumentNo: Code[20]; MobileNumber: Text; TextMessage: Text)
    var
        SMSTemplate: Record "33020257";
        SMSDetails: Record "33020258";
        EntryNo: Integer;
        SMSWebService: Codeunit "50002";
        MessageID: Text[250];
    begin
        SMSSetup.GET;

        SMSDetails.RESET;
        IF SMSDetails.FINDLAST THEN
            EntryNo := SMSDetails."Entry No." + 1
        ELSE
            EntryNo := 1;

        SMSDetails.INIT;
        SMSDetails."Entry No." := EntryNo;
        SMSDetails."Mobile Number" := MobileNumber;
        SMSDetails."Creation Date" := CURRENTDATETIME;
        SMSDetails."Message Type" := MessageType;
        SMSDetails.Status := SMSDetails.Status::New;
        SMSDetails."Document No." := DocumentNo;
        SMSDetails.Company := COMPANYNAME;
        SMSDetails."Message Text" := COPYSTR(TextMessage, 1, 250);
        IF SMSSetup."Enable Agile SMS Gateway" THEN
            SMSDetails."Message Length" := CalculateMessageLength(TextMessage);
        SMSDetails.INSERT;

        IF SendSMS1(MobileNumber, TextMessage, MessageID, SMSDetails."Message Length") THEN BEGIN
            SMSDetails.MessageID := MessageID;
            SMSDetails.Status := SMSDetails.Status::Processed;
            SMSDetails.MODIFY(TRUE);
            MESSAGE('SMS Sent !!')
        END ELSE BEGIN
            SMSDetails.MessageID := MessageID;
            SMSDetails.Status := SMSDetails.Status::Failed;
            SMSDetails.MODIFY(TRUE);
            MESSAGE('Sending SMS Failed !!');
        END;
    end;

    [Scope('Internal')]
    procedure SendCustomerDueNotificationBeforeSevenDays()
    var
        SMSTemplate: Record "33020257";
        SMSDetails: Record "33020258";
        SMSSetup: Record "50006";
        VehicleFinanceHeader: Record "33020062";
        MessageText: Text[250];
        VehicleFinanceLine: Record "33020063";
        Customer: Record "18";
        EntryNo: Integer;
        SMSWebService: Codeunit "50002";
    begin
        SMSTemplate.RESET;
        SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Customer Due Notification 1");
        IF NOT SMSTemplate.FINDFIRST THEN
            EXIT;
        VehicleFinanceHeader.RESET;
        //VehicleFinanceHeader.SETRANGE("Loan No.", 'LO-000001');
        VehicleFinanceHeader.SETRANGE("Loan Disbursed", TRUE);
        VehicleFinanceHeader.SETRANGE(Approved, TRUE);
        IF VehicleFinanceHeader.FINDFIRST THEN
            REPEAT
                VehicleFinanceLine.RESET;
                VehicleFinanceLine.SETRANGE("Loan No.", VehicleFinanceHeader."Loan No.");
                VehicleFinanceLine.SETRANGE("EMI Mature Date", CALCDATE('-CM'), CALCDATE('CM'));
                IF VehicleFinanceLine.FINDFIRST THEN BEGIN
                    SMSSetup.GET;
                    SMSSetup.TESTFIELD("Customer Due Notification 1");
                    IF SMSSetup."Customer Due Notification 1" = (VehicleFinanceLine."EMI Mature Date" - WORKDATE) THEN BEGIN
                        Customer.GET(VehicleFinanceHeader."Customer No.");
                        IF Customer."Mobile No." <> '' THEN BEGIN
                            MessageText := STRSUBSTNO(SMSTemplate."Message Text", VehicleFinanceHeader."Total Due as of Today", VehicleFinanceLine."EMI Mature Date");
                            SMSDetails.RESET;
                            IF SMSDetails.FINDLAST THEN
                                EntryNo := SMSDetails."Entry No." + 1
                            ELSE
                                EntryNo := 1;
                            SMSDetails.INIT;
                            SMSDetails."Entry No." := EntryNo;
                            SMSDetails."Mobile Number" := Customer."Mobile No.";
                            SMSDetails."Creation Date" := CURRENTDATETIME;
                            SMSDetails."Message Type" := SMSTemplate.Type;
                            SMSDetails.Status := SMSDetails.Status::New;
                            SMSDetails."Document No." := VehicleFinanceHeader."Vehicle No.";
                            SMSDetails."Message Text" := COPYSTR(MessageText, 1, 25);
                            //IF SMSSetup."Enable Agile SMS Gateway" THEN
                            //SMSDetails."Message Length" := CalculateMessageLength(MessageText);
                            SMSDetails.INSERT;

                            IF SMSWebService.SendSMS1(Customer."Mobile No.", MessageText, MessageID, SMSDetails."Message Length") THEN BEGIN
                                SMSDetails.MessageID := MessageID;
                                SMSDetails.Status := SMSDetails.Status::Processed;
                                SMSDetails.MODIFY(TRUE);
                                MESSAGE('SMS Sent.');
                            END ELSE BEGIN
                                SMSDetails.MessageID := MessageID;
                                SMSDetails.Status := SMSDetails.Status::Failed;
                                SMSDetails.MODIFY(TRUE);
                                MESSAGE('Sending SMS Failed.');
                            END;
                        END;
                    END;
                END;
            UNTIL VehicleFinanceHeader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SendCustomerDueNotificationBeforeThreeDays()
    var
        SMSSetup: Record "50006";
        SMSDetails: Record "33020258";
        SMSTemplate: Record "33020257";
        VehicleFinanceheader: Record "33020062";
        VehicleFinanceLine: Record "33020063";
        Customer: Record "18";
        EntryNo: Integer;
        SMSWebService: Codeunit "50002";
        MessageText: Text[250];
    begin
        SMSTemplate.RESET;
        SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Customer Due Notification 2");
        IF NOT SMSTemplate.FINDFIRST THEN
            EXIT;
        VehicleFinanceheader.RESET;
        VehicleFinanceheader.SETRANGE("Loan Disbursed", TRUE);
        VehicleFinanceheader.SETRANGE(Approved, TRUE);
        //VehicleFinanceheader.SETRANGE("Loan No.", 'LO-000002');
        IF VehicleFinanceheader.FINDFIRST THEN
            REPEAT
                VehicleFinanceLine.RESET;
                VehicleFinanceLine.SETRANGE("Loan No.", VehicleFinanceheader."Loan No.");
                VehicleFinanceLine.SETRANGE("EMI Mature Date", CALCDATE('-CM'), CALCDATE('CM'));
                IF VehicleFinanceLine.FINDFIRST THEN BEGIN
                    SMSSetup.GET;
                    SMSSetup.TESTFIELD("Customer Due Notification 2");
                    IF SMSSetup."Customer Due Notification 2" = (VehicleFinanceLine."EMI Mature Date" - WORKDATE) THEN BEGIN
                        Customer.GET(VehicleFinanceheader."Customer No.");
                        IF Customer."Mobile No." <> '' THEN BEGIN
                            MessageText := STRSUBSTNO(SMSTemplate."Message Text", VehicleFinanceheader."Total Due as of Today", VehicleFinanceLine."EMI Mature Date");
                            SMSDetails.RESET;
                            IF SMSDetails.FINDLAST THEN
                                EntryNo := SMSDetails."Entry No." + 1
                            ELSE
                                EntryNo := 1;
                            SMSDetails.INIT;
                            SMSDetails."Entry No." := EntryNo;
                            SMSDetails."Mobile Number" := Customer."Mobile No.";
                            SMSDetails."Creation Date" := CURRENTDATETIME;
                            SMSDetails."Message Type" := SMSTemplate.Type;
                            SMSDetails.Status := SMSDetails.Status::New;
                            SMSDetails."Document No." := VehicleFinanceheader."Vehicle No.";
                            SMSDetails."Message Text" := COPYSTR(MessageText, 1, 25);
                            IF SMSSetup."Enable Agile SMS Gateway" THEN
                                SMSDetails."Message Length" := CalculateMessageLength(MessageText);
                            SMSDetails.INSERT;

                            IF SMSWebService.SendSMS1(Customer."Mobile No.", MessageText, MessageID, SMSDetails."Message Length") THEN BEGIN
                                SMSDetails.MessageID := MessageID;
                                SMSDetails.Status := SMSDetails.Status::Processed;
                                SMSDetails.MODIFY(TRUE);
                            END ELSE BEGIN
                                SMSDetails.MessageID := MessageID;
                                SMSDetails.Status := SMSDetails.Status::Failed;
                                SMSDetails.MODIFY(TRUE);
                            END;
                        END;
                    END;
                END;
            UNTIL VehicleFinanceheader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SendInsuranceExpiryNotification()
    var
        SMSSetup: Record "50006";
        SMSDetails: Record "33020258";
        SMSTemplate: Record "33020257";
        VehicleFinanceheader: Record "33020062";
        VehicleFinanceLine: Record "33020063";
        Customer: Record "18";
        EntryNo: Integer;
        SMSWebService: Codeunit "50002";
        MessageText: Text[1024];
        MessageBody1: Text[1024];
    begin
        SMSTemplate.RESET;
        SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Insurance Expiry Notification");
        IF NOT SMSTemplate.FINDFIRST THEN
            EXIT;
        VehicleFinanceheader.RESET;
        VehicleFinanceheader.SETRANGE("Loan Disbursed", TRUE);
        VehicleFinanceheader.SETRANGE(Approved, TRUE);
        //VehicleFinanceheader.SETRANGE("Loan No.", 'LO-000001');
        VehicleFinanceheader.SETFILTER("Insurance Expiry Date", '>%1', WORKDATE);
        IF VehicleFinanceheader.FINDFIRST THEN
            REPEAT
                SMSSetup.GET;
                SMSSetup.TESTFIELD("Insurance Expiry Notification");
                IF SMSSetup."Insurance Expiry Notification" = (VehicleFinanceheader."Insurance Expiry Date" - WORKDATE) THEN BEGIN
                    Customer.GET(VehicleFinanceheader."Customer No.");
                    IF Customer."Mobile No." <> '' THEN BEGIN
                        MessageBody1 := SMSTemplate."Message Text" + SMSTemplate."Message Text 2";
                        MessageText := STRSUBSTNO(MessageBody1, VehicleFinanceheader."Vehicle No.", VehicleFinanceheader."Insurance Expiry Date");
                        SMSDetails.RESET;
                        IF SMSDetails.FINDLAST THEN
                            EntryNo := SMSDetails."Entry No." + 1
                        ELSE
                            EntryNo := 1;
                        SMSDetails.INIT;
                        SMSDetails."Entry No." := EntryNo;
                        SMSDetails."Mobile Number" := Customer."Mobile No.";
                        SMSDetails."Creation Date" := CURRENTDATETIME;
                        SMSDetails."Message Type" := SMSTemplate.Type;
                        SMSDetails.Status := SMSDetails.Status::New;
                        SMSDetails."Document No." := VehicleFinanceheader."Vehicle No.";
                        SMSDetails."Message Text" := COPYSTR(MessageText, 1, 25);
                        IF SMSSetup."Enable Agile SMS Gateway" THEN
                            SMSDetails."Message Length" := CalculateMessageLength(MessageText);
                        SMSDetails.INSERT;

                        IF SMSWebService.SendSMS1(Customer."Mobile No.", MessageText, MessageID, SMSDetails."Message Length") THEN BEGIN
                            SMSDetails.MessageID := MessageID;
                            SMSDetails.Status := SMSDetails.Status::Processed;
                            SMSDetails.MODIFY(TRUE);
                            MESSAGE('SMS Sent.');
                        END ELSE BEGIN
                            SMSDetails.MessageID := MessageID;
                            SMSDetails.Status := SMSDetails.Status::Failed;
                            SMSDetails.MODIFY(TRUE);
                            MESSAGE('Sending SMS failed.');
                        END;
                    END;
                END;
            UNTIL VehicleFinanceheader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SendCustomerDueNotificationAfterThreeDays()
    var
        SMSSetup: Record "50006";
        SMSDetails: Record "33020258";
        SMSTemplate: Record "33020257";
        VehicleFinanceheader: Record "33020062";
        VehicleFinanceLine: Record "33020063";
        Customer: Record "18";
        EntryNo: Integer;
        SMSWebService: Codeunit "50002";
        MessageText: Text[250];
    begin
        SMSTemplate.RESET;
        SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Customer Due Notification 3");
        IF NOT SMSTemplate.FINDFIRST THEN
            EXIT;
        VehicleFinanceheader.RESET;
        VehicleFinanceheader.SETRANGE("Loan Disbursed", TRUE);
        VehicleFinanceheader.SETRANGE(Approved, TRUE);
        //VehicleFinanceheader.SETRANGE("Loan No.", 'LO-000001');
        IF VehicleFinanceheader.FINDFIRST THEN
            REPEAT
                VehicleFinanceLine.RESET;
                VehicleFinanceLine.SETRANGE("Loan No.", VehicleFinanceheader."Loan No.");
                VehicleFinanceLine.SETRANGE("Line Cleared", FALSE);
                IF VehicleFinanceLine.FINDSET THEN
                    REPEAT
                        SMSSetup.GET;
                        SMSSetup.TESTFIELD("Customer Due Notification 3");
                        IF SMSSetup."Customer Due Notification 3" = (WORKDATE - VehicleFinanceLine."EMI Mature Date") THEN BEGIN// AND (VehicleFinanceLine."Line Cleared" = FALSE) THEN BEGIN
                            Customer.GET(VehicleFinanceheader."Customer No.");
                            IF Customer."Mobile No." <> '' THEN BEGIN
                                MessageText := STRSUBSTNO(SMSTemplate."Message Text", VehicleFinanceheader."Total Due as of Today", VehicleFinanceLine."EMI Mature Date");
                                SMSDetails.RESET;
                                IF SMSDetails.FINDLAST THEN
                                    EntryNo := SMSDetails."Entry No." + 1
                                ELSE
                                    EntryNo := 1;
                                SMSDetails.INIT;
                                SMSDetails."Entry No." := EntryNo;
                                SMSDetails."Mobile Number" := Customer."Mobile No.";
                                SMSDetails."Creation Date" := CURRENTDATETIME;
                                SMSDetails."Message Type" := SMSTemplate.Type;
                                SMSDetails."Document No." := VehicleFinanceheader."Vehicle No.";
                                SMSDetails."Message Text" := COPYSTR(MessageText, 1, 25);
                                IF SMSSetup."Enable Agile SMS Gateway" THEN
                                    SMSDetails."Message Length" := CalculateMessageLength(MessageText);
                                SMSDetails.INSERT;

                                IF SMSWebService.SendSMS1(Customer."Mobile No.", MessageText, MessageID, SMSDetails."Message Length") THEN BEGIN
                                    SMSDetails.MessageID := MessageID;
                                    SMSDetails.Status := SMSDetails.Status::Processed;
                                    SMSDetails.MODIFY(TRUE);
                                    MESSAGE('SMS Sent.');
                                END ELSE BEGIN
                                    SMSDetails.MessageID := MessageID;
                                    SMSDetails.Status := SMSDetails.Status::Failed;
                                    SMSDetails.MODIFY(TRUE);
                                    MESSAGE('Sending SMS failed.');
                                END;
                            END;
                        END;
                    UNTIL VehicleFinanceLine.NEXT = 0;
            UNTIL VehicleFinanceheader.NEXT = 0;
    end;
}

