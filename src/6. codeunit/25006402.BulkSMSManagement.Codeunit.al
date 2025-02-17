codeunit 25006402 "BulkSMS Management"
{

    trigger OnRun()
    var
        ResponseData: Text;
        ResponseStatus: Text;
    begin
    end;

    var
        Username: Text[50];
        Password: Text[50];
        Msisdn: Text[30];
        RequestUrlSendSMS: Text;
        RequestPort: Text[6];
        Repliable: Integer;
        SenderId: Text;
        SMSManagement: Codeunit "25006400";
        ServicesURL: Text[50];

    local procedure RequestData(Url: Text; Body: BigText; var ResponseText: BigText) RequestStatus: Boolean
    var
        WebRequest: DotNet HttpWebRequest;
        WebResponse: DotNet HttpWebResponse;
        RequestDetails: Text;
    begin
        IF Request(Url, Body, ResponseText) THEN
            RequestStatus := TRUE
        ELSE
            RequestStatus := FALSE;
    end;

    [TryFunction]
    local procedure Request(Url: Text; Body: BigText; var ResponseText: BigText)
    var
        WebRequest: DotNet HttpWebRequest;
        WebResponse: DotNet HttpWebResponse;
        RequestDetails: Text;
    begin

        WebRequest := WebRequest.Create(Url);
        WebRequest.ContentType := 'application/x-www-form-urlencoded';
        WebRequest.Method := 'POST';

        SetRequestText(WebRequest, Body);
        WebResponse := WebRequest.GetResponse();
        GetResponseText(WebResponse, ResponseText);
    end;

    local procedure GetResponseText(WebResponse: DotNet HttpWebResponse; var ResponseText: BigText): Boolean
    var
        ResponseStream: DotNet Stream;
        StreamReader: DotNet StreamReader;
    begin
        CLEAR(ResponseText);
        ResponseStream := WebResponse.GetResponseStream();
        StreamReader := StreamReader.StreamReader(ResponseStream);
        ResponseText.ADDTEXT(StreamReader.ReadToEnd());
    end;

    local procedure SetRequestText(var WebRequest: DotNet HttpWebRequest; RequestText: BigText)
    var
        RequestStream: DotNet Stream;
        Bytes: DotNet Array;
        Encoding: DotNet Encoding;
    begin
        Bytes := Encoding.ASCII.GetBytes(RequestText);
        WebRequest.ContentLength := Bytes.Length;
        RequestStream := WebRequest.GetRequestStream();
        RequestStream.Write(Bytes, 0, Bytes.Length);
    end;

    [Scope('Internal')]
    procedure SetPrerequisites(UsernameToSet: Text[30]; PasswordToSet: Text[30]; ServicesURLToSet: Text[50])
    begin
        Username := UsernameToSet;
        Password := PasswordToSet;
        ServicesURL := ServicesURLToSet;
    end;

    local procedure UrlEncode(Text: Text) Result: Text
    var
        HttpUtility: DotNet HttpUtility;
    begin
        Text := DELCHR(Text, '<>', ' ');
        Result := HttpUtility.UrlEncode(Text);
    end;

    [Scope('Internal')]
    procedure RequestSendSMS(PhoneNo: Text[20]; Message: Text; SourceId: Integer; var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
    begin
        RequestUrl := ServicesURL + '/submission/send_sms/2/2.0';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'msisdn=%4&' +
          'source_id=%5&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%6&' +
          'sender=%7', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), UrlEncode(PhoneNo), FORMAT(SourceId), Repliable, UrlEncode(SenderId)));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;

    [Scope('Internal')]
    procedure RequestSendSMSBatch(SourceId: Integer; BatchData: BigText; Message: Text; var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
        cr: Char;
    begin
        RequestUrl := ServicesURL + '/submission/send_sms/2/2.0';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'source_id=%4&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%5&' +
          'sender=%6&' +
          'msisdn=', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), FORMAT(SourceId), Repliable, UrlEncode(SenderId)));

        RequestBody.ADDTEXT(BatchData);

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;

    [Scope('Internal')]
    procedure RequestSendMultipleSMS(SourceId: Integer; BatchData: BigText; var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
        cr: Char;
    begin
        RequestUrl := ServicesURL + '/submission/send_batch/1/1.0';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2&' +
          'source_id=%3&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%4&' +
          'sender=%5&' +
          'batch_data=', UrlEncode(Username), UrlEncode(Password), FORMAT(SourceId), Repliable, UrlEncode(SenderId)));

        RequestBody.ADDTEXT(BatchData);

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;

    [Scope('Internal')]
    procedure RequestSendSMSQuote(PhoneNo: Text[20]; Message: Text; SourceId: Integer; var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
    begin
        RequestUrl := ServicesURL + '/submission/quote_sms/2/2.0';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'msisdn=%4&' +
          'source_id=%5&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%6&' +
          'sender=%7', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), UrlEncode(PhoneNo), FORMAT(SourceId), Repliable, UrlEncode(SenderId)));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;

    [Scope('Internal')]
    procedure RequestSendSMSBatchQuote(SourceId: Integer; BatchData: BigText; Message: Text; var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
        cr: Char;
    begin
        RequestUrl := ServicesURL + '/submission/quote_sms/2/2.0';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'source_id=%4&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%5&' +
          'sender=%6&' +
          'msisdn=', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), FORMAT(SourceId), Repliable, UrlEncode(SenderId)));

        RequestBody.ADDTEXT(BatchData);

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;

    [Scope('Internal')]
    procedure RequestQuote(PhoneNo: Text[20]; Message: Text; var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
    begin
        RequestUrl := ServicesURL + '/submission/quote_sms/2/2.0';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'msisdn=%4&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), UrlEncode(PhoneNo)));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 0, 0);
    end;

    [Scope('Internal')]
    procedure RequestReport(SourceId: Integer; BatchId: Text[20]; PhoneNo: Text[20]; var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
        ResponseStatus: Text;
        ResponseText: Text;
    begin
        PhoneNo := DELCHR(PhoneNo, '=', '+');
        RequestUrl := ServicesURL + '/status_reports/get_report/2/2.0';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2&' +
          'batch_id=%3&' +
          'msisdn=%4', UrlEncode(Username), UrlEncode(Password), UrlEncode(BatchId), UrlEncode(PhoneNo)));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;

    [Scope('Internal')]
    procedure RequestCredits(var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
        ResponseStatus: Text;
        ResponseText: Text;
    begin
        RequestUrl := ServicesURL + '/user/get_credits/1/1.1';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2', UrlEncode(Username), UrlEncode(Password)));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 0, 0);

        ResponseData.GETSUBTEXT(ResponseText, 1, 250);
        ResponseStatus := COPYSTR(ResponseText, 1, 19);
        IF ResponseStatus = '0|Results to follow' THEN BEGIN
            ResponseText := DELSTR(ResponseText, 1, 19);
            ResponseText := DELCHR(ResponseText, '<>', ' ');
            ResponseText := ClearText(ResponseText);
            ResponseText := DELCHR(ResponseText, '<>', ' ');
        END;
    end;

    [Scope('Internal')]
    procedure RequestReplays(LastRetrievedMessage: Integer; var ResponseData: BigText) RequestStatus: Boolean
    var
        RequestBody: BigText;
        RequestUrl: Text[250];
        ResponseStatus: Text;
    begin
        RequestUrl := ServicesURL + '/reception/get_inbox/1/1.1';
        RequestBody.ADDTEXT(STRSUBSTNO(
          'username=%1&' +
          'password=%2&' +
          'last_retrieved_id=%3', UrlEncode(Username), UrlEncode(Password), LastRetrievedMessage));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 0, 0);
    end;

    [Scope('Internal')]
    procedure SetRepliable(RepliableToSet: Boolean)
    begin
        IF RepliableToSet THEN BEGIN
            Repliable := 1;
            SenderId := '';
        END ELSE BEGIN
            Repliable := 0;
        END;
    end;

    [Scope('Internal')]
    procedure SetSenderId(SenderIdToSet: Text)
    begin
        IF SenderIdToSet <> '' THEN BEGIN
            SenderId := SenderIdToSet;
            Repliable := 0;
        END;
    end;

    [TryFunction]
    local procedure TryGetResponseField(ResponseText: Text; FieldNo: Integer; var FieldText: Text)
    var
        WorkingString: Text;
    begin

        WorkingString := CONVERTSTR(ResponseText, ',', ' ');
        WorkingString := CONVERTSTR(WorkingString, '|', ',');
        FieldText := SELECTSTR(FieldNo, WorkingString);

        FieldText := ClearText(FieldText);
    end;

    [Scope('Internal')]
    procedure GetResponseField(ResponseText: Text; FieldNo: Integer) ReturnText: Text
    begin
        IF NOT TryGetResponseField(ResponseText, FieldNo, ReturnText) THEN ReturnText := '';
    end;

    [Scope('Internal')]
    procedure ClearText(TextToClear: Text): Text
    var
        cr: Char;
        lf: Char;
        tab: Char;
    begin
        cr := 13;
        lf := 10;
        tab := 9;
        TextToClear := DELCHR(TextToClear, '=', FORMAT(cr));
        TextToClear := DELCHR(TextToClear, '=', FORMAT(lf));
        TextToClear := DELCHR(TextToClear, '=', FORMAT(tab));
        EXIT(TextToClear)
    end;
}

