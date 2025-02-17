codeunit 33019811 "NCHL-NPI Web Service Mgt."
{
    Permissions = TableData 17 = rm,
                  TableData 33019810 = rm;

    trigger OnRun()
    begin
    end;

    var
        CIPSSetup: Record "33019810";
        MemoryStream: DotNet MemoryStream;
        baseurl: Label 'baseurl';
        path: Label 'path';
        restmethod: Label 'restmethod';
        contenttype: Label 'Content-Type';
        username: Label 'username';
        password: Label 'password';
        grant_type: Label 'grant_type';
        httpcontent: Label 'httpcontent';
        CIPSIntegrationMgt: Codeunit "33019810";
        Comma: Label ',';
        ContentTypeText: Label 'application/x-www-form-urlencoded';
        AccessToken: Label 'access_token';
        RefreshToken: Label 'refresh_token';
        Ampersand: Label '&';
        equals: Label '=';
        CIPSIntegrationService: Record "33019811";
        JsonFormat: Label 'application/json';
        Bearer: Label 'Bearer';
        RefreshTokenGeneratedDuration: Duration;
        AccessTokenGeneratedDuration: Duration;
        Authorization: Label 'Authorization';
        data: Text;
        GeneratedAccessToken: Text;
        OpenCurlyBracket: Label '{';
        CloseCurlyBracket: Label '}';
        bankId: Label '"bankId":';
        accountId: Label '"accountId":';
        accountName: Label '"accountName":';
        NoPrivateKeyErr: Label 'There is no private key in the certificate. Please contact the system administrator.';
        responseCodeText: Label 'responseCode';
        matchPercentage: Label 'matchPercentate';
        responseMessage: Label 'responseMessage';
        Slash: Label '/';
        BankAccValidationResponseCode: Code[10];
        BankAccValidationMatchPercent: Code[10];
        BankAccValidationResponseMessageTxt: Text;

    [TryFunction]
    [Scope('Internal')]
    procedure GetCIPSBankList()
    var
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
    begin
        CIPSSetup.GET;
        CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::"CIPS Bank List");
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, CIPSIntegrationService."Service Name");
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        ParseCIPSBankDetails(result.ToString);
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure GetCIPSBankBranchList(BankIDCode: Code[20])
    var
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        URLPath: Label 'api/getbranchlist';
    begin
        CIPSSetup.GET;
        CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::"CIPS Bank List");
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, URLPath + Slash + BankIDCode);
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"::GET));
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        ParseCIPSBankBranchDetails(result.ToString);
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure GetCIPSChargeList()
    var
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        ChargeListPath: Label 'api/getcipschargelist/MER-1-APP-3';
    begin
        CIPSSetup.GET;
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, ChargeListPath);
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"::GET));
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        ParseCIPSBankChargeDetails(result.ToString);
    end;

    [Scope('Internal')]
    procedure CheckBankAccountValidation(PassedBankId: Code[10]; PassedAccountId: Code[20]; PassedAccountName: Text[140]) IsValidAccount: Boolean
    var
        ValidatingData: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        JToken: DotNet JToken;
        JSONResponseText: DotNet String;
        ResponseCode: Text;
        AccMatchPercentage: Text;
    begin
        CIPSSetup.GET;
        CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::"Bank Account Validation");

        ValidatingData := OpenCurlyBracket;
        ValidatingData += bankId + '"' + PassedBankId + '"' + Comma;
        ValidatingData += accountId + '"' + PassedAccountId + '"' + Comma;
        ValidatingData += accountName + '"' + PassedAccountName + '"';
        ValidatingData += CloseCurlyBracket;
        GeneratedAccessToken := GetAccessToken;
        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);

        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, CIPSIntegrationService."Service Name");
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        Parameters.Add(httpcontent, stringContent);
        CallRESTO2Auth(Parameters, HttpResponseMessage);

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
        TryParse(JSONResponseText, JToken);
        //MESSAGE(result.ToString);
        ResponseCode := GetValueAsText(JToken, responseCodeText);
        AccMatchPercentage := GetValueAsText(JToken, matchPercentage);
        BankAccValidationResponseMessageTxt := GetValueAsText(JToken, responseMessage);
        BankAccValidationMatchPercent := AccMatchPercentage;
        BankAccValidationResponseCode := ResponseCode;
        IF ResponseCode = CIPSSetup."Success Status Code" THEN
            EXIT(TRUE)
        ELSE
            IF (ResponseCode = CIPSSetup."Alt. Code (Bank Validation)") AND (AccMatchPercentage > FORMAT(CIPSSetup."Alt. Match % (Bank Validation)")) THEN //if response is 999 and match percentage is >60 then
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure GetBankAccountValidationResponse(var responseCode: Code[10]; var responseMessage: Text; var MatchPercentage: Code[10])
    begin
        responseCode := BankAccValidationResponseCode;
        responseMessage := BankAccValidationResponseMessageTxt;
        MatchPercentage := BankAccValidationMatchPercent;
    end;

    [Scope('Internal')]
    procedure PushRealTimeVoucher(FinalData: Text; var JSONResponseText: DotNet String) ReturnValue: Boolean
    var
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        encoding: DotNet Encoding;
        result: DotNet String;
        resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        null: DotNet Object;
        Window: Dialog;
        statusCode: Text;
        statusText: Text;
        PhoneNo: Text;
        MessageText: Text;
        Success: Boolean;
        ErrorMessage: Text;
        Parameters: DotNet Dictionary_Of_T_U;
        JToken: DotNet JToken;
    begin
        CIPSSetup.GET;
        CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::CIPS);
        stringContent := stringContent.StringContent(FinalData, encoding.UTF8, JsonFormat);

        GeneratedAccessToken := GetAccessToken; //value will be used in callrestoauth2 function

        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, CIPSIntegrationService."Service Name");
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(password, CIPSSetup."Password (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        Parameters.Add(contenttype, JsonFormat);
        Parameters.Add(httpcontent, stringContent);

        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
        //MESSAGE(result.ToString);
    end;

    [Scope('Internal')]
    procedure PushNonRealTimeTimeVoucher(FinalData: Text; var JSONResponseText: DotNet String) ReturnValue: Boolean
    var
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        encoding: DotNet Encoding;
        result: DotNet String;
        resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        null: DotNet Object;
        Window: Dialog;
        statusCode: Text;
        statusText: Text;
        PhoneNo: Text;
        MessageText: Text;
        Success: Boolean;
        ErrorMessage: Text;
        Parameters: DotNet Dictionary_Of_T_U;
        JToken: DotNet JToken;
    begin
        CIPSSetup.GET;
        CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::NCHLIPS);
        stringContent := stringContent.StringContent(FinalData, encoding.UTF8, JsonFormat);

        GeneratedAccessToken := GetAccessToken; //value will be used in callrestoauth2 function

        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, CIPSIntegrationService."Service Name");
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(password, CIPSSetup."Password (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        Parameters.Add(contenttype, JsonFormat);
        Parameters.Add(httpcontent, stringContent);

        CallRESTO2Auth(Parameters, HttpResponseMessage);

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        //MESSAGE(result.ToString);
        JSONResponseText := result.ToString;
    end;

    [Scope('Internal')]
    procedure GetAccessToken() AccessToken: Text
    var
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        HttpResponseMessage: DotNet HttpResponseMessage;
        data: Text;
        Parameters: DotNet Dictionary_Of_T_U;
        result: DotNet String;
        CIPSIntegrationService: Record "33019811";
        GrantTypeText: Text;
        JSONResponseText: DotNet String;
        JToken: DotNet JToken;
    begin
        IF CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::"Access Token") AND (CIPSIntegrationService."Service Name" <> '') THEN BEGIN

            CIPSIntegrationMgt.CheckCIPSSetup;

            CLEAR(GrantTypeText);
            CLEAR(data);

            //check token generated
            CIPSSetup.GET;
            IF FORMAT(CIPSSetup."Refresh Token Generated On") <> '' THEN BEGIN
                RefreshTokenGeneratedDuration := CURRENTDATETIME - CIPSSetup."Refresh Token Generated On";
                IF RefreshTokenGeneratedDuration > CIPSSetup."Refresh Token Validity" THEN
                    GrantTypeText := Ampersand + grant_type + equals + password
                ELSE BEGIN
                    GrantTypeText := Ampersand + grant_type + equals + RefreshToken;
                    GrantTypeText += Ampersand + RefreshToken + equals + CIPSSetup."Refresh Token"
                END;
            END ELSE
                GrantTypeText := Ampersand + grant_type + equals + password;


            //combine data string
            data := username + equals + CIPSSetup."Username (User Auth.)";
            data += Ampersand + password + equals + CIPSSetup."Password (User Auth.)";
            data += GrantTypeText;
            stringContent := stringContent.StringContent(data, encoding.UTF8, ContentTypeText);

            //add parameters
            Parameters := Parameters.Dictionary();
            Parameters.Add(baseurl, CIPSSetup."Base URL");
            Parameters.Add(path, CIPSIntegrationService."Service Name");
            Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
            Parameters.Add(contenttype, ContentTypeText);
            Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
            Parameters.Add(password, CIPSSetup."Password (Basic Auth.)");
            IF RefreshTokenGeneratedDuration < CIPSSetup."Refresh Token Validity" THEN BEGIN
                Parameters.Add(grant_type, RefreshToken);
                Parameters.Add(RefreshToken, CIPSSetup."Refresh Token");
            END ELSE
                Parameters.Add(grant_type, password);
            Parameters.Add(httpcontent, stringContent);

            CallRESTGenerateAccessToken(Parameters, HttpResponseMessage);
            result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
            ParseJsonResponse(result.ToString);
            //MESSAGE(ExtractAccessToken(result.ToString));

            /*JSONResponseText := result.ToString;
            CLEAR(JToken);
            TryParse(result.ToString,JToken);
            CIPSSetup."Refresh Token" := GetValueAsText(JToken,RefreshToken);
            CIPSSetup."Access Token" := GetValueAsText(JToken,AccessToken);
            CIPSSetup."Refresh Token Generated On" := CURRENTDATETIME;
            CIPSSetup."Access Token Generated On" := CURRENTDATETIME;
            CIPSSetup.MODIFY;*/
            EXIT(CIPSSetup."Access Token");


        END;

    end;

    [Scope('Internal')]
    procedure CallRESTGenerateAccessToken(var Parameters: DotNet Dictionary_Of_T_U; var HttpResponseMessage: DotNet HttpResponseMessage): Boolean
    var
        HttpContent: DotNet HttpContent;
        HttpClient: DotNet HttpClient;
        AuthHeaderValue: DotNet AuthenticationHeaderValue;
        EntityTagHeaderValue: DotNet EntityTagHeaderValue;
        Uri: DotNet Uri;
        bytes: DotNet Array;
        Encoding: DotNet Encoding;
        Convert: DotNet Convert;
        HttpRequestMessage: DotNet HttpRequestMessage;
        HttpMethod: DotNet HttpMethod;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(FORMAT(Parameters.Item('baseurl')));

        HttpRequestMessage :=
          HttpRequestMessage.HttpRequestMessage(HttpMethod.HttpMethod(UPPERCASE(FORMAT(Parameters.Item('restmethod')))),
                                                FORMAT(Parameters.Item('path')));
        ;

        IF Parameters.ContainsKey('accept') THEN
            HttpRequestMessage.Headers.Add('Accept', FORMAT(Parameters.Item('accept')));


        IF Parameters.ContainsKey('content-type') THEN
            HttpRequestMessage.Headers.Add('content-type', FORMAT(Parameters.Item('content-type')));

        IF Parameters.ContainsKey('username') THEN BEGIN
            bytes := Encoding.ASCII.GetBytes(STRSUBSTNO('%1:%2', FORMAT(Parameters.Item('username')), FORMAT(Parameters.Item('password'))));
            AuthHeaderValue := AuthHeaderValue.AuthenticationHeaderValue('Basic', Convert.ToBase64String(bytes));
            HttpRequestMessage.Headers.Authorization := AuthHeaderValue;
        END;

        //IF Parameters.ContainsKey('Data') THEN;
        IF Parameters.ContainsKey('httpcontent') THEN
            HttpRequestMessage.Content := Parameters.Item('httpcontent');

        //HttpResponseMessage := HttpClient.SendAsync(HttpRequestMessage).Result; //usisng try catch before cating the error
        trySendAsync(HttpResponseMessage, HttpRequestMessage, FORMAT(Parameters.Item('baseurl')));

        IF FORMAT(HttpResponseMessage) <> '' THEN
            InsertNCHLLog(FORMAT(HttpClient.BaseAddress), FORMAT(Parameters.Item('restmethod')), 'Basic', '', FORMAT(Parameters.Item('username')), FORMAT(Parameters.Item('password')), FORMAT(HttpResponseMessage), '',
                FORMAT(Parameters.Item('restmethod')))
        ELSE
            InsertNCHLLog(FORMAT(HttpClient.BaseAddress), FORMAT(Parameters.Item('restmethod')), 'Basic', '', FORMAT(Parameters.Item('username')), FORMAT(Parameters.Item('password')), GETLASTERRORTEXT, '',
               FORMAT(Parameters.Item('restmethod')));
        EXIT(HttpResponseMessage.IsSuccessStatusCode);
    end;

    [Scope('Internal')]
    procedure CallRESTO2Auth(var Parameters: DotNet Dictionary_Of_T_U; var HttpResponseMessage: DotNet HttpResponseMessage): Boolean
    var
        HttpClient: DotNet HttpClient;
        AuthHeaderValue: DotNet AuthenticationHeaderValue;
        EntityTagHeaderValue: DotNet EntityTagHeaderValue;
        Uri: DotNet Uri;
        bytes: DotNet Array;
        Encoding: DotNet Encoding;
        Convert: DotNet Convert;
        HttpRequestMessage: DotNet HttpRequestMessage;
        HttpMethod: DotNet HttpMethod;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(FORMAT(Parameters.Item('baseurl')));

        HttpRequestMessage :=
          HttpRequestMessage.HttpRequestMessage(HttpMethod.HttpMethod(UPPERCASE(FORMAT(Parameters.Item('restmethod')))),
                                                FORMAT(Parameters.Item('path')));
        ;

        IF Parameters.ContainsKey('accept') THEN
            HttpRequestMessage.Headers.Add('Accept', FORMAT(Parameters.Item('accept')));


        IF Parameters.ContainsKey('content-type') THEN
            HttpRequestMessage.Headers.Add('content-type', FORMAT(Parameters.Item('content-type')));

        IF Parameters.ContainsKey('username') THEN BEGIN
            AuthHeaderValue := AuthHeaderValue.AuthenticationHeaderValue('Bearer', GeneratedAccessToken);
            HttpRequestMessage.Headers.Authorization := AuthHeaderValue;
        END;

        IF Parameters.ContainsKey('httpcontent') THEN
            HttpRequestMessage.Content := Parameters.Item('httpcontent');

        //MESSAGE(FORMAT(HttpRequestMessage));
        //HttpResponseMessage := HttpClient.SendAsync(HttpRequestMessage).Result;
        trySendAsync(HttpResponseMessage, HttpRequestMessage, FORMAT(Parameters.Item('baseurl')));


        IF FORMAT(HttpResponseMessage) <> '' THEN BEGIN
            IF Parameters.ContainsKey('httpcontent') THEN
                InsertNCHLLog(FORMAT(HttpClient.BaseAddress), FORMAT(Parameters.Item('restmethod')), 'Token Bearer', FORMAT(Parameters.Item('httpcontent')), '', '',
                FORMAT(HttpResponseMessage), GeneratedAccessToken, FORMAT(Parameters.Item('restmethod')))
            ELSE
                InsertNCHLLog(FORMAT(HttpClient.BaseAddress), FORMAT(Parameters.Item('restmethod')), 'Token Bearer', '', '', '',
                 FORMAT(HttpResponseMessage), GeneratedAccessToken, FORMAT(Parameters.Item('restmethod')));
        END ELSE
            InsertNCHLLog(FORMAT(HttpClient.BaseAddress), FORMAT(Parameters.Item('restmethod')), 'Token Bearer', FORMAT(Parameters.Item('httpcontent')), '', '',
                GETLASTERRORTEXT, GeneratedAccessToken, FORMAT(Parameters.Item('restmethod')));

        EXIT(HttpResponseMessage.IsSuccessStatusCode);
    end;

    [Scope('Internal')]
    procedure BatchString(BatchID: Code[20]; DebtorAgent: Text; DebtorBranch: Text; DebtorAccount: Text; BatchAmount: Text; BatchCurrency: Code[10]; CategoryPurpose: Code[10]; IsRealTime: Boolean): Text
    begin
        IF IsRealTime THEN
            EXIT(BatchID + Comma + DebtorAgent + Comma + DebtorBranch + Comma + DebtorAccount + Comma + FORMAT(BatchAmount) + Comma + BatchCurrency)
        ELSE
            EXIT(BatchID + Comma + DebtorAgent + Comma + DebtorBranch + Comma + DebtorAccount + Comma + FORMAT(BatchAmount) + Comma + BatchCurrency + Comma + CategoryPurpose)
    end;

    [Scope('Internal')]
    procedure TransactionString(InstructionID: Code[30]; CreditorAgent: Text; CreditorBranch: Text; CreditorAccount: Text; TransactionAmount: Text): Text
    begin
        EXIT(InstructionID + Comma + CreditorAgent + Comma + CreditorBranch + Comma + CreditorAccount + Comma + FORMAT(TransactionAmount));
    end;

    [Scope('Internal')]
    procedure ExtractAccessToken(JSONResponseText: DotNet String) AccessToken: Text
    var
        JToken: DotNet JToken;
    begin
        TryParse(JSONResponseText, JToken);
        CIPSSetup.GET;
        CIPSSetup."Refresh Token" := GetValueAsText(JToken, RefreshToken);
        CIPSSetup."Access Token" := GetValueAsText(JToken, AccessToken);
        CIPSSetup."Refresh Token Generated On" := CURRENTDATETIME;
        CIPSSetup."Access Token Generated On" := CURRENTDATETIME;
        CIPSSetup.MODIFY;
        AccessToken := GetValueAsText(JToken, AccessToken);
        EXIT(AccessToken);
    end;

    [Scope('Internal')]
    procedure GetTransactionUpdateFromReportingAPIs(RequestMessage: Text; IsRealTimeTransaction: Boolean; EntryType: Option " ",Debtor,Creditor; var result: DotNet String)
    var
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        JSONResponseText: DotNet String;
        ResponseCode: Text;
        getcipstxnlistbybatchid: Label 'api/getcipstxnlistbybatchid';
        getnchlipstxnlistbybatchid: Label 'api/getnchlipstxnlistbybatchid';
        getcipstxnbyinstructionid: Label 'api/getcipstxnbyinstructionid';
        getnchlipstxnlistbyinstructionid: Label 'api/getnchlipstxnlistbyinstructionid';
        PathText: Text;
        creditStatusText: Label 'creditStatus';
        reasonDescText: Label 'reasonDesc';
        debitStatusText: Label 'debitStatus';
        debitReasonDescText: Label 'debitReasonDesc';
        txnResponseText: Label 'txnResponse';
        [RunOnClient]
        JToken: DotNet JToken;
    begin
        PathText := '';
        CIPSSetup.GET;
        GeneratedAccessToken := GetAccessToken;
        stringContent := stringContent.StringContent(RequestMessage, encoding.UTF8, JsonFormat);
        //MESSAGE(RequestMessage);
        IF IsRealTimeTransaction THEN BEGIN
            IF EntryType = EntryType::Debtor THEN
                PathText := getcipstxnlistbybatchid
            ELSE
                IF EntryType = EntryType::Creditor THEN
                    PathText := getcipstxnbyinstructionid
        END ELSE BEGIN
            IF EntryType = EntryType::Debtor THEN
                PathText := getnchlipstxnlistbybatchid
            ELSE
                IF EntryType = EntryType::Creditor THEN
                    PathText := getnchlipstxnlistbyinstructionid
        END;

        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, PathText);
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        Parameters.Add(httpcontent, stringContent);
        CallRESTO2Auth(Parameters, HttpResponseMessage);

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
        //MESSAGE(result.ToString);
        //ParseJsonResponseArray(result.ToString);
    end;

    local procedure "--Parse Json Values--"()
    begin
    end;

    [Scope('Internal')]
    procedure ParseJsonResponse(JSONResponseText: DotNet String)
    var
        JToken: DotNet JToken;
    begin
        TryParse(JSONResponseText, JToken);
        CIPSSetup.GET;
        IF RefreshTokenGeneratedDuration > CIPSSetup."Refresh Token Validity" THEN BEGIN
            CIPSSetup."Refresh Token" := GetValueAsText(JToken, RefreshToken);
            CIPSSetup."Refresh Token Generated On" := CURRENTDATETIME;
        END;
        CIPSSetup."Access Token" := GetValueAsText(JToken, AccessToken);
        CIPSSetup."Access Token Generated On" := CURRENTDATETIME;
        IF CIPSSetup.MODIFY THEN;
        GeneratedAccessToken := GetValueAsText(JToken, AccessToken);
    end;

    [Scope('Internal')]
    procedure GetValueAsText(var JObject: DotNet JObject; PropertyName: Text) ReturnValue: Text
    begin
        ReturnValue := JObject.GetValue(PropertyName).ToString;
    end;

    [Scope('Internal')]
    procedure GetValueAsInteger(JObject: DotNet JObject; PropertyName: Text) ReturnValue: Integer
    var
        DotNetInteger: DotNet Int32;
    begin
        ReturnValue := DotNetInteger.Parse(JObject.GetValue(PropertyName).ToString);
    end;

    [Scope('Internal')]
    procedure GetValueAsDecimal(JObject: DotNet JObject; PropertyName: Text) ReturnValue: Decimal
    var
        DotNetDecimal: DotNet Decimal;
        CultureInfo: DotNet CultureInfo;
    begin
        ReturnValue := DotNetDecimal.Parse(JObject.GetValue(PropertyName).ToString, CultureInfo.InvariantCulture);
    end;

    [Scope('Internal')]
    procedure GetValueAsDate(JObject: DotNet JObject; PropertyName: Text) ReturnValue: Date
    var
        DotNetDateTime: DotNet DateTime;
        CultureInfo: DotNet CultureInfo;
    begin
        DotNetDateTime := JObject.GetValue(PropertyName).ToObject(GETDOTNETTYPE(DotNetDateTime));
        ReturnValue := DT2DATE(DotNetDateTime);
    end;

    [Scope('Internal')]
    procedure GetValueAsTime(JObject: DotNet JObject; PropertyName: Text) ReturnValue: Time
    var
        DotNetDateTime: DotNet DateTime;
        CultureInfo: DotNet CultureInfo;
    begin
        DotNetDateTime := JObject.GetValue(PropertyName).ToObject(GETDOTNETTYPE(DotNetDateTime));
        ReturnValue := DT2TIME(DotNetDateTime);
    end;

    [Scope('Internal')]
    procedure GetValueAsDateTime(JObject: DotNet JObject; PropertyName: Text) ReturnValue: DateTime
    var
        DotNetDateTime: DotNet DateTime;
        CultureInfo: DotNet CultureInfo;
    begin
        DotNetDateTime := JObject.GetValue(PropertyName).ToObject(GETDOTNETTYPE(DotNetDateTime));
        ReturnValue := DotNetDateTime;
    end;

    [Scope('Internal')]
    procedure GetValueAsBoolean(JObject: DotNet JObject; PropertyName: Text) ReturnValue: Boolean
    var
        DotNetBoolean: DotNet Boolean;
    begin
        ReturnValue := DotNetBoolean.Parse(JObject.GetValue(PropertyName).ToString);
    end;

    [Scope('Internal')]
    procedure GetODataErrorMessage(ErrorObject: DotNet JToken) ReturnValue: Text
    var
        JToken: DotNet JToken;
    begin
        JToken := ErrorObject.SelectToken('$.[''odata.error''].[''message'']');
        ReturnValue := GetValueAsText(JToken, 'value');
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure TryParse(json: Text; var JToken: DotNet JToken)
    begin
        JToken := JToken.Parse(json);
    end;

    local procedure "---Parse Json Values--"()
    begin
    end;

    [Scope('Internal')]
    procedure getSignature(rawdata: Text; publicKeyLocation: Text) TokenString: Text
    var
        Encoding: DotNet Encoding;
        SignedData: DotNet Array;
        buffer: DotNet Array;
        hashAlgorithm: DotNet HashAlgorithm;
        SHA256: DotNet ;
        HashValue: DotNet Array;
        Convert: DotNet Convert;
    begin
        buffer := Encoding.Default.GetBytes(rawdata);
        hashAlgorithm := SHA256.Create;
        HashValue := hashAlgorithm.ComputeHash(buffer);
        signContent(HashValue, publicKeyLocation, SignedData);
        TokenString := Convert.ToBase64String(SignedData);
        EXIT(TokenString);
    end;

    local procedure signContent(hashValue: DotNet Array; publicKeyLocation: Text; var SignedData: DotNet Array)
    var
        "----Signing Data------": Integer;
        publicCert: DotNet X509Certificate2;
        privateCert: DotNet X509Certificate2;
        X509KeyStorageFlags: DotNet X509KeyStorageFlags;
        store: DotNet X509Store;
        storeLocation: DotNet StoreLocation;
        openFlags: DotNet OpenFlags;
        x509Certificate: DotNet X509Certificate2;
        "key": DotNet ;
        HashAlgorithmName: DotNet ;
        RSASignaturePadding: DotNet ;
    begin
        CIPSSetup.GET;

        publicCert := publicCert.X509Certificate2(CIPSSetup."Certificate Path", CIPSSetup."Certificate Password", X509KeyStorageFlags.MachineKeySet);
        privateCert := privateCert.X509Certificate2(CIPSSetup."Certificate Path", CIPSSetup."Certificate Password", X509KeyStorageFlags.MachineKeySet);

        store := store.X509Store(storeLocation.CurrentUser);
        store.Open(openFlags.ReadOnly);
        x509Certificate := x509Certificate.X509Certificate2;
        FOREACH x509Certificate IN store.Certificates DO BEGIN
            IF x509Certificate.GetCertHashString = publicCert.GetCertHashString THEN
                privateCert := x509Certificate;
        END;

        IF NOT privateCert.HasPrivateKey THEN
            ERROR(NoPrivateKeyErr);

        key := privateCert.PrivateKey;
        SignedData := key.SignHash(hashValue, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
    end;

    [Scope('Internal')]
    procedure ParseJsonResponseArray(JSONResponseText: DotNet String)
    var
        JSonToken: DotNet JsonToken;
        [RunOnClient]
        PrefixArray: DotNet Array;
        PrefixString: DotNet String;
        [RunOnClient]
        StringReader: DotNet StringReader;
        JsonTextReader: DotNet JsonTextReader;
        PropertyName: Text;
        ColumnNo: Integer;
        InArray: array[250] of Boolean;
        ArrayDepth: Integer;
        ActualLineNumber: Integer;
        TempLineNumber: Integer;
        LineNo: Integer;
        TempPostingExchField: Record "1221";
    begin
        PrefixArray := PrefixArray.CreateInstance(GETDOTNETTYPE(JSONResponseText), 250);
        StringReader := StringReader.StringReader(JSONResponseText);
        JsonTextReader := JsonTextReader.JsonTextReader(StringReader);
        ActualLineNumber := 1;
        TempLineNumber := 0;
        TempPostingExchField.DELETEALL;
        WHILE JsonTextReader.Read DO BEGIN
            CASE TRUE OF
                JsonTextReader.TokenType.CompareTo(JSonToken.StartObject) = 0:
                    TempLineNumber += 1;

                JsonTextReader.TokenType.CompareTo(JSonToken.StartArray) = 0:
                    BEGIN
                        InArray[JsonTextReader.Depth + 1] := TRUE;
                        ColumnNo := 0;
                        ArrayDepth += 1;
                    END;
                JsonTextReader.TokenType.CompareTo(JSonToken.StartConstructor) = 0:
                    BEGIN
                    END;

                JsonTextReader.TokenType.CompareTo(JSonToken.PropertyName) = 0:
                    BEGIN
                        PrefixArray.SetValue(JsonTextReader.Value, JsonTextReader.Depth - ArrayDepth);
                        IF JsonTextReader.Depth > 1 THEN BEGIN
                            //PrefixString := PrefixString.Join('.',PrefixArray,0,JsonTextReader.Depth - ArrayDepth);
                            PrefixString := PrefixString.Join('', PrefixArray, 0, JsonTextReader.Depth - ArrayDepth);
                            IF PrefixString.Length > 0 THEN
                                PropertyName := PrefixString.ToString + '.' + FORMAT(JsonTextReader.Value, 0, 9)
                            //PropertyName := FORMAT(JsonTextReader.Value,0,9)
                            ELSE
                                PropertyName := FORMAT(JsonTextReader.Value, 0, 9);
                        END ELSE
                            PropertyName := FORMAT(JsonTextReader.Value, 0, 9);
                    END;

                (JsonTextReader.TokenType.CompareTo(JSonToken.String) = 0) OR
                (JsonTextReader.TokenType.CompareTo(JSonToken.Integer) = 0) OR
                (JsonTextReader.TokenType.CompareTo(JSonToken.Float) = 0) OR
                (JsonTextReader.TokenType.CompareTo(JSonToken.Boolean) = 0) OR
                (JsonTextReader.TokenType.CompareTo(JSonToken.Date) = 0) OR
                (JsonTextReader.TokenType.CompareTo(JSonToken.Bytes) = 0):
                    BEGIN
                        //NewValue := FORMAT(JsonTextReader.Value,0,9);
                        TempPostingExchField."Data Exch. No." := JsonTextReader.Depth;
                        TempPostingExchField."Line No." := ActualLineNumber;
                        TempPostingExchField."Column No." := ColumnNo;
                        TempPostingExchField."Node ID" := PropertyName;
                        TempPostingExchField.Value := FORMAT(JsonTextReader.Value, 0, 9);
                        TempPostingExchField."Data Exch. Line Def Code" := JsonTextReader.TokenType.ToString;
                        IF NOT TempPostingExchField.INSERT THEN BEGIN
                            //TODO
                        END;
                    END;

                JsonTextReader.TokenType.CompareTo(JSonToken.EndConstructor) = 0:
                    BEGIN
                        LineNo += 1;
                    END;

                JsonTextReader.TokenType.CompareTo(JSonToken.EndArray) = 0:
                    BEGIN
                        InArray[JsonTextReader.Depth + 1] := FALSE;
                        ArrayDepth -= 1;
                    END;

                JsonTextReader.TokenType.CompareTo(JSonToken.EndObject) = 0:
                    BEGIN
                        TempLineNumber -= 1;
                        IF TempLineNumber = 0 THEN BEGIN
                            ActualLineNumber += 1;
                        END;
                        IF JsonTextReader.Depth > 0 THEN
                            IF InArray[JsonTextReader.Depth] THEN
                                ColumnNo += 1;
                    END;
            END;
        END;
    end;

    local procedure ParseCIPSBankDetails(JSONResponseText: DotNet String)
    var
        JToken: DotNet JsonToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        i: Integer;
        TempCIPSBankAccount: Record "33019814";
        bankId: Label 'bankId';
        branchName: Label 'branchName';
        ArrayString: Text;
        bankName: Label 'bankName';
        EntryNo: Integer;
    begin
        JArray := JArray.Parse(JSONResponseText);
        JObject := JObject.JObject();

        TempCIPSBankAccount.RESET;
        IF TempCIPSBankAccount.FINDLAST THEN
            EntryNo := TempCIPSBankAccount."Entry No." + 1
        ELSE
            EntryNo := 1;

        FOREACH JObject IN JArray DO BEGIN
            //IF bankId <> FORMAT(JObject.GetValue(bankId)) THEN
            // ERROR('Could not find a token with key %1',bankId);

            TempCIPSBankAccount.INIT;
            TempCIPSBankAccount."Entry No." := EntryNo;
            TempCIPSBankAccount.Agent := FORMAT(JObject.GetValue(bankId));
            TempCIPSBankAccount.Name := FORMAT(JObject.GetValue(bankName));
            TempCIPSBankAccount."End to End ID" := 'CIPSBANKLISTS';
            TempCIPSBankAccount.INSERT;
            EntryNo += 1;
        END;
    end;

    local procedure ParseCIPSBankBranchDetails(JSONResponseText: DotNet String)
    var
        JToken: DotNet JsonToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        i: Integer;
        TempCIPSBankAccount: Record "33019814";
        bankId: Label 'bankId';
        branchName: Label 'branchName';
        ArrayString: Text;
        branchId: Label 'branchId';
        EntryNo: Integer;
        LineNo: Integer;
    begin
        JArray := JArray.Parse(JSONResponseText);
        JObject := JObject.JObject();

        TempCIPSBankAccount.RESET;
        IF TempCIPSBankAccount.FINDLAST THEN
            EntryNo := TempCIPSBankAccount."Entry No." + 1
        ELSE
            EntryNo := 1;

        FOREACH JObject IN JArray DO BEGIN
            TempCIPSBankAccount.INIT;
            TempCIPSBankAccount."Entry No." := EntryNo;
            TempCIPSBankAccount.Branch := FORMAT(JObject.GetValue(branchId));
            TempCIPSBankAccount.Agent := FORMAT(JObject.GetValue(bankId));
            TempCIPSBankAccount.Name := FORMAT(JObject.GetValue(branchName));
            TempCIPSBankAccount."End to End ID" := 'CIPSBANKLISTS';
            //  EVALUATE(LineNo,TempCIPSBankAccount.Branch);
            //  TempCIPSBankAccount."Line No." := LineNo;
            TempCIPSBankAccount.INSERT;
            EntryNo += 1;
        END;
    end;

    local procedure ParseCIPSBankChargeDetails(JSONResponseText: DotNet String)
    var
        JToken: DotNet JsonToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        i: Integer;
        TempCIPSBankAccount: Record "33019814";
        scheme: Label 'scheme';
        currency: Label 'currency';
        ArrayString: Text;
        maxAmt: Label 'maxAmt';
        EntryNo: Integer;
        minChargeAmt: Label 'minChargeAmt';
        maxChargeAmt: Label 'maxChargeAmt';
        percent: Label 'percent';
        DecimalValue: Decimal;
    begin
        JArray := JArray.Parse(JSONResponseText);
        JObject := JObject.JObject();

        TempCIPSBankAccount.RESET;
        IF TempCIPSBankAccount.FINDLAST THEN
            EntryNo := TempCIPSBankAccount."Entry No." + 1
        ELSE
            EntryNo := 1;

        FOREACH JObject IN JArray DO BEGIN

            TempCIPSBankAccount.INIT;
            TempCIPSBankAccount."Entry No." := EntryNo;
            TempCIPSBankAccount."Document No." := FORMAT(JObject.GetValue(scheme));
            TempCIPSBankAccount."Batch Currency" := FORMAT(JObject.GetValue(currency));
            EVALUATE(DecimalValue, FORMAT(JObject.GetValue(maxAmt)));
            TempCIPSBankAccount."Transaction Charge Amount" := DecimalValue;
            EVALUATE(DecimalValue, FORMAT(JObject.GetValue(maxChargeAmt)));
            TempCIPSBankAccount."Debit Amount" := DecimalValue;
            EVALUATE(DecimalValue, FORMAT(JObject.GetValue(minChargeAmt)));
            TempCIPSBankAccount."Credit Amount" := DecimalValue;
            TempCIPSBankAccount."Category Purpose" := FORMAT(JObject.GetValue(percent));
            TempCIPSBankAccount."End to End ID" := 'CIPSBANKLISTS';
            TempCIPSBankAccount.INSERT;
            EntryNo += 1;
        END;
    end;

    [Scope('Internal')]
    procedure GetTransactionUpdate(RequestMessage: Text; IsRealTimeTransaction: Boolean; EntryType: Option ,Debtor,"Creditor "; var Result: DotNet String)
    var
        Parameters: DotNet Dictionary_Of_T_U;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        JSONResponseText: DotNet String;
        ResponseCode: Text;
        JToken: DotNet JToken;
        getcipstxnlistbybatchid: Label 'api/getcipstxnlistbybatchid';
        getnchlipstxnlistbybatchid: Label 'api/getnchlipstxnlistbybatchid';
        getcipstxnbyinstructionid: Label 'api/getcipstxnbyinstructionid';
        getnchlipstxnlistbyinstructionid: Label 'vapi/getnchlipstxnlistbyinstructionid';
        creditStatusText: Label 'creditStatus';
        reasonDescText: Label 'reasonDesc';
        debitStatusText: Label 'debitStatus';
        debitReasonDescText: Label 'debitReasonDesc';
        txnResponseText: Label 'txnResponse';
        PathText: Text;
        HttpResponseMessage: DotNet HttpResponseMessage;
    begin
        PathText := '';
        CIPSSetup.GET;
        GeneratedAccessToken := GetAccessToken;
        stringContent := stringContent.StringContent(RequestMessage, encoding.UTF8, JsonFormat);
        MESSAGE(RequestMessage);
        IF IsRealTimeTransaction THEN BEGIN
            IF EntryType = EntryType::Debtor THEN
                PathText := getcipstxnlistbybatchid
            ELSE
                IF EntryType = EntryType::"Creditor " THEN
                    PathText := getcipstxnbyinstructionid
        END ELSE BEGIN
            IF EntryType = EntryType::Debtor THEN
                PathText := getnchlipstxnlistbybatchid
            ELSE
                IF EntryType = EntryType::"Creditor " THEN
                    PathText := getnchlipstxnlistbyinstructionid
        END;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, PathText);
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        Parameters.Add(httpcontent, stringContent);
        CallRESTO2Auth(Parameters, HttpResponseMessage);

        Result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := Result.ToString;
        MESSAGE(Result.ToString);
        ParseJsonResponseArray(Result.ToString);
    end;

    local procedure "---DepartmentofCustom---"()
    begin
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure GetCIPSAppList()
    var
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
    begin
        CIPSSetup.GET;
        CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::"CIPS App List");
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, CIPSIntegrationService."Service Name");
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        ParseCIPSAppIDs(result.ToString);
    end;

    local procedure ParseCIPSAppIDs(JSONResponseText: DotNet String)
    var
        JToken: DotNet JsonToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        i: Integer;
        TempCIPSBankAccount: Record "33019814";
        ArrayString: Text;
        EntryNo: Integer;
        appID: Label 'appId';
        appName: Label 'appName';
    begin
        JArray := JArray.Parse(JSONResponseText);
        JObject := JObject.JObject();

        TempCIPSBankAccount.RESET;
        IF TempCIPSBankAccount.FINDLAST THEN
            EntryNo := TempCIPSBankAccount."Entry No." + 1
        ELSE
            EntryNo := 1;

        FOREACH JObject IN JArray DO BEGIN
            TempCIPSBankAccount.INIT;
            TempCIPSBankAccount."Entry No." := EntryNo;
            TempCIPSBankAccount.Agent := FORMAT(JObject.GetValue(appID));
            TempCIPSBankAccount.Name := FORMAT(JObject.GetValue(appName));
            TempCIPSBankAccount."End to End ID" := 'CIPSAPPLISTS';
            TempCIPSBankAccount.INSERT;
            EntryNo += 1;
        END;
    end;

    [Scope('Internal')]
    procedure TransactionStringDepartmentofCustom(InstructionID: Code[30]; AppID: Code[20]; RefID: Code[35]; RegYear: Code[10]): Text
    begin
        EXIT(InstructionID + Comma + AppID + Comma + RefID);
    end;

    [Scope('Internal')]
    procedure PushGetDetailsDOC(FinalData: Text; var JSONResponseText: DotNet String) ReturnValue: Boolean
    var
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        encoding: DotNet Encoding;
        result: DotNet String;
        resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        null: DotNet Object;
        Window: Dialog;
        statusCode: Text;
        statusText: Text;
        PhoneNo: Text;
        MessageText: Text;
        Success: Boolean;
        ErrorMessage: Text;
        Parameters: DotNet Dictionary_Of_T_U;
        JToken: DotNet JToken;
    begin
        CIPSSetup.GET;
        CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::"DOC Details");
        stringContent := stringContent.StringContent(FinalData, encoding.UTF8, JsonFormat);

        GeneratedAccessToken := GetAccessToken; //value will be used in callrestoauth2 function

        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, CIPSIntegrationService."Service Name");
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(password, CIPSSetup."Password (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        Parameters.Add(contenttype, JsonFormat);
        Parameters.Add(httpcontent, stringContent);

        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
        //MESSAGE(result.ToString);
    end;

    [Scope('Internal')]
    procedure PushLodgeConfirmBill(FinalData: Text; var JSONResponseText: DotNet String; APIType: Option "Lodge Bill","Confirm Bill") ReturnValue: Boolean
    var
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        encoding: DotNet Encoding;
        result: DotNet String;
        resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        null: DotNet Object;
        Window: Dialog;
        statusCode: Text;
        statusText: Text;
        PhoneNo: Text;
        MessageText: Text;
        Success: Boolean;
        ErrorMessage: Text;
        Parameters: DotNet Dictionary_Of_T_U;
        JToken: DotNet JToken;
    begin
        CIPSSetup.GET;
        IF APIType = APIType::"Lodge Bill" THEN
            CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::"Realtime Lodge Bill")
        ELSE
            CIPSIntegrationService.GET(CIPSIntegrationService."Service Type"::"Realtime Confirm Bill");

        stringContent := stringContent.StringContent(FinalData, encoding.UTF8, JsonFormat);

        GeneratedAccessToken := GetAccessToken; //value will be used in callrestoauth2 function

        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, CIPSSetup."Base URL");
        Parameters.Add(path, CIPSIntegrationService."Service Name");
        Parameters.Add(username, CIPSSetup."Username (Basic Auth.)");
        Parameters.Add(password, CIPSSetup."Password (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(CIPSSetup."Rest Method"));
        Parameters.Add(contenttype, JsonFormat);
        Parameters.Add(httpcontent, stringContent);

        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
        //MESSAGE(result.ToString);
    end;

    local procedure InsertNCHLLog(UriObj: Text; Authentiction: Text; CredentailType: Text; Paramters: Text; UserName: Text; Password: Text; Response: Text; token: Text; Method: Text)
    var
        NCHLLog: Record "33019809";
    begin
        /* NCHLLog.INIT();
         NCHLLog.VALIDATE("API URL", UriObj);
         NCHLLog."API Authentication" := Authentiction;
         NCHLLog."API Credential Type" := CredentailType;
         NCHLLog."API Body" := COPYSTR(Paramters, 1, 250);
         NCHLLog."API UserName" := UserName;
         //NCHLLog."API Password" := Password;
         NCHLLog.Token := token;
         NCHLLog.Response := COPYSTR(Response, 1, 250);
         NCHLLog."Response 2" := COPYSTR(Response, 251, 250);
         NCHLLog."API Method" := Method;
         NCHLLog."Create Date Time" := CURRENTDATETIME;
         NCHLLog.INSERT();
         COMMIT;
         */

    end;

    [TryFunction]
    local procedure trySendAsync(var HttpResponseMessage: DotNet HttpResponseMessage; HttpRequestMessage: DotNet HttpRequestMessage; BaseUri: Text)
    var
        HttpClient: DotNet HttpClient;
        Uri: DotNet Uri;
        Parameters: DotNet Dictionary_Of_T_U;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseUri);
        HttpResponseMessage := HttpClient.SendAsync(HttpRequestMessage).Result;
    end;

    local procedure ">>*************************NCHL Custom****************<<"()
    begin
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure getListOfCategory()
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
        category: Label '{"category":"GOVT"}';
    begin
        NCHLSetup.GET;
        NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::Category);
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        stringContent := stringContent.StringContent(category, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent); //sending body
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        parseNCHLCategory(result.ToString);
    end;

    local procedure parseNCHLCategory(JSONResponseText: DotNet String)
    var
        JToken: DotNet JsonToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        i: Integer;
        TempCustomOffice: Record "33019814";
        ArrayString: Text;
        EntryNo: Integer;
        "code": Label 'code';
        labelText: Label 'labelText';
        JMainObject: DotNet JObject;
        ArrayText: DotNet String;
        lArray: Text;
    begin
        JMainObject := JMainObject.Parse(FORMAT(JSONResponseText));

        lArray := JMainObject.SelectToken('data').ToString;
        JArray := JArray.Parse(lArray);

        //MESSAGE(FORMAT(JArray));

        JObject := JObject.JObject;

        TempCustomOffice.RESET;
        IF TempCustomOffice.FINDLAST THEN
            EntryNo := TempCustomOffice."Entry No." + 1
        ELSE
            EntryNo := 1;

        FOREACH JObject IN JArray DO BEGIN
            TempCustomOffice.INIT;
            TempCustomOffice."Entry No." := EntryNo;
            TempCustomOffice.Agent := FORMAT(JObject.GetValue(code));
            TempCustomOffice.Name := FORMAT(JObject.GetValue(labelText));
            TempCustomOffice."End to End ID" := 'TEMPCATEGORY';
            TempCustomOffice.INSERT;
            EntryNo += 1;
        END;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure getListOfApps(_Category: Code[20])
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
        category: Label '{"category":"%1"}';
        str: Text;
    begin
        NCHLSetup.GET;
        NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"CIPS App List");
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        str := STRSUBSTNO(category, _Category);

        stringContent := stringContent.StringContent(str, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent); //sending body
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        parseNCHLApps(result.ToString);
    end;

    local procedure parseNCHLApps(JSONResponseText: DotNet String)
    var
        JToken: DotNet JsonToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        i: Integer;
        TempCustomOffice: Record "33019814";
        ArrayString: Text;
        EntryNo: Integer;
        appId: Label 'appId';
        appGroup: Label 'appGroup';
        JMainObject: DotNet JObject;
        ArrayText: DotNet String;
        lArray: Text;
        labelText: Label 'labelText';
    begin
        JMainObject := JMainObject.Parse(FORMAT(JSONResponseText));

        lArray := JMainObject.SelectToken('data').ToString;
        JArray := JArray.Parse(lArray);

        //MESSAGE(FORMAT(JArray));

        JObject := JObject.JObject;

        TempCustomOffice.RESET;
        IF TempCustomOffice.FINDLAST THEN
            EntryNo := TempCustomOffice."Entry No." + 1
        ELSE
            EntryNo := 1;

        FOREACH JObject IN JArray DO BEGIN
            TempCustomOffice.INIT;
            TempCustomOffice."Entry No." := EntryNo;
            TempCustomOffice.Agent := FORMAT(JObject.GetValue(appId));
            TempCustomOffice.Name := FORMAT(JObject.GetValue(appGroup));
            TempCustomOffice."Bank Name" := FORMAT(JObject.GetValue(labelText));
            TempCustomOffice."End to End ID" := 'TEMPAPPS';
            TempCustomOffice.INSERT;
            EntryNo += 1;
        END;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure getListOfCustom(_appId: Code[20]; _appGroup: Code[20])
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
        category: Label '{"fieldName": "appId","appGroup": "%1"}';
    begin
        NCHLSetup.GET;
        NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Custom Office");
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        ValidatingData := STRSUBSTNO(category, _appGroup);

        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent); //sending body
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        parseNCHLCustomOffice(result.ToString);
    end;

    local procedure parseNCHLCustomOffice(JSONResponseText: DotNet String)
    var
        JToken: DotNet JsonToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        i: Integer;
        TempCustomOffice: Record "33019814";
        ArrayString: Text;
        EntryNo: Integer;
        value: Label 'value';
        option: Label 'option';
        JMainObject: DotNet JObject;
        ArrayText: DotNet String;
        lArray: Text;
        labelText: Label 'labelText';
    begin
        JMainObject := JMainObject.Parse(FORMAT(JSONResponseText));

        lArray := JMainObject.SelectToken('data').ToString;
        JArray := JArray.Parse(lArray);

        //MESSAGE(FORMAT(JArray));

        JObject := JObject.JObject;

        TempCustomOffice.RESET;
        IF TempCustomOffice.FINDLAST THEN
            EntryNo := TempCustomOffice."Entry No." + 1
        ELSE
            EntryNo := 1;

        FOREACH JObject IN JArray DO BEGIN
            TempCustomOffice.INIT;
            TempCustomOffice."Entry No." := EntryNo;
            TempCustomOffice.Agent := FORMAT(JObject.GetValue(value));
            TempCustomOffice.Name := FORMAT(JObject.GetValue(option));
            TempCustomOffice."End to End ID" := 'TEMPCUSTOMOFFICE';
            TempCustomOffice.INSERT;
            EntryNo += 1;
        END;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure getListOfRegistrationSerial()
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
        category: Label '{"fieldName":"freeText1","appGroup": "167"}';
    begin
        NCHLSetup.GET;
        NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Redg Serial");
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        ValidatingData := STRSUBSTNO(category);

        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent); //sending body
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        parseNCHLRegistrationSerial(result.ToString);
    end;

    local procedure parseNCHLRegistrationSerial(JSONResponseText: DotNet String)
    var
        JToken: DotNet JsonToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        i: Integer;
        TempCustomOffice: Record "33019814";
        ArrayString: Text;
        EntryNo: Integer;
        value: Label 'value';
        option: Label 'option';
        JMainObject: DotNet JObject;
        ArrayText: DotNet String;
        lArray: Text;
    begin
        JMainObject := JMainObject.Parse(FORMAT(JSONResponseText));

        lArray := JMainObject.SelectToken('data').ToString;
        JArray := JArray.Parse(lArray);

        //MESSAGE(FORMAT(JArray));

        JObject := JObject.JObject;

        TempCustomOffice.RESET;
        IF TempCustomOffice.FINDLAST THEN
            EntryNo := TempCustomOffice."Entry No." + 1
        ELSE
            EntryNo := 1;

        FOREACH JObject IN JArray DO BEGIN
            TempCustomOffice.INIT;
            TempCustomOffice."Entry No." := EntryNo;
            TempCustomOffice.Agent := FORMAT(JObject.GetValue(value));
            TempCustomOffice.Name := FORMAT(JObject.GetValue(option));
            TempCustomOffice."End to End ID" := 'TEMPREDGSERIAL';
            TempCustomOffice.INSERT;
            EntryNo += 1;
        END;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure postNCHLDetailsOfPAY(strText: Text; var JSONResponseText: DotNet String; isRealTime: Boolean)
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
        category: Label '{"fieldName":"freeText1","appGroup": "167"}';
    begin
        NCHLSetup.GET;
        IF isRealTime THEN
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"DOC Details")
        ELSE
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"DOC Details");

        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        ValidatingData := STRSUBSTNO(strText);

        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent); //sending body
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        //MESSAGE(FORMAT(result));//82
        JSONResponseText := result.ToString;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure postNCHLFinalPAY(strText: Text; var JSONResponseText: DotNet String; isRealtime: Boolean)
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
        category: Label '{"fieldName":"freeText1","appGroup": "167"}';
    begin
        NCHLSetup.GET; //confirm
        IF isRealtime THEN
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Realtime Confirm Bill")
        ELSE
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Non Real Confirm");

        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        ValidatingData := STRSUBSTNO(strText);

        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent); //sending body
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure postNCHLLodgeBillPAY(strText: Text; var JSONResponseText: DotNet String; isRealTime: Boolean)
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
        category: Label '{"fieldName":"freeText1","appGroup": "167"}';
    begin
        NCHLSetup.GET;
        IF isRealTime THEN
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Realtime Lodge Bill")
        ELSE
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Non Real Lodge Bill");
        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        ValidatingData := STRSUBSTNO(strText);
        //82MESSAGE(ValidatingData);

        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent); //sending body
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
    end;

    [Scope('Internal')]
    procedure BatchStringPAY(BatchID: Code[20]; DebtorAgent: Text; DebtorBranch: Text; DebtorAccount: Text; BatchAmount: Text; BatchCurrency: Code[10]; CategoryPurpose: Code[10]; IsRealTime: Boolean): Text
    begin
        IF IsRealTime THEN
            EXIT(BatchID + Comma + DebtorAgent + Comma + DebtorBranch + Comma + DebtorAccount + Comma + FORMAT(BatchAmount))
        ELSE
            EXIT(BatchID + Comma + DebtorAgent + Comma + DebtorBranch + Comma + DebtorAccount + Comma + FORMAT(BatchAmount) + Comma + BatchCurrency)
    end;

    [Scope('Internal')]
    procedure transactionStringPay(instructionId: Code[20]; AppId: Code[20]; RefId: Code[20]): Text
    begin
        EXIT(instructionId + Comma + AppId + Comma + RefId);
    end;

    local procedure "******IRD*************"()
    begin
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure postNCHLIRDLodge(strText: Text; var JSONResponseText: DotNet String; isRealTime: Boolean)
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
        category: Label '{"fieldName":"freeText1","appGroup": "167"}';
    begin
        NCHLSetup.GET;
        IF isRealTime THEN
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Realtime Lodge Bill")
        ELSE
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Non Real Lodge Bill");

        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary();
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));


        ValidatingData := STRSUBSTNO(strText);
        //MESSAGE(ValidatingData);

        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent); //sending body
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
        //parseNCHLDetailsPAYNPI(result.ToString);
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure postNCHLIRDBillPAY(strText: Text; var JSONResponseText: DotNet String; isRealTime: Boolean)
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
    begin
        NCHLSetup.GET;
        IF isRealTime THEN
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Realtime Confirm Bill")
        ELSE
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Non Real Confirm");

        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary;
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        ValidatingData := STRSUBSTNO(strText);
        //82
        MESSAGE(strText);
        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent);
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure postNCHLIRDStatus(strText: Text; var JSONResponseText: DotNet String; isRealTime: Boolean)
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
    begin
        NCHLSetup.GET;

        NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::Status);

        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary;
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        ValidatingData := STRSUBSTNO(strText);
        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent);
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
    end;

    [Scope('Internal')]
    procedure insertIntoLog(Response: Text; Doc: Code[20]; typ: Code[20])
    var
        NCHLLog: Record "33019809";
        OutStr: OutStream;
    begin
        NCHLLog.INIT;
        NCHLLog."API UserName" := Doc;
        //NCHLLog."API Body" := COPYSTR(Response,1,249);
        //NCHLLog.Response := COPYSTR(Response,249,STRLEN(Response)-1);
        NCHLLog."Response Blob".CREATEOUTSTREAM(OutStr);
        OutStr.WRITE(FORMAT(Response));
        NCHLLog.Response := typ;
        NCHLLog.INSERT;
        COMMIT;
    end;

    [Scope('Internal')]
    procedure getReportBatchIdWise(strText: Text; var JSONResponseText: DotNet String; IsRealTime: Boolean)
    var
        NCHLSetup: Record "33019810";
        NCHLIntegrationService: Record "33019811";
        GeneratedAccessToken: Text;
        result: DotNet String;
        Parameters: DotNet Dictionary_Of_T_U;
        HttpResponseMessage: DotNet HttpResponseMessage;
        stringContent: DotNet StringContent;
        encoding: DotNet Encoding;
        ValidatingData: Text;
    begin
        NCHLSetup.GET;
        IF IsRealTime THEN
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"Realtime Report")
        ELSE
            NCHLIntegrationService.GET(NCHLIntegrationService."Service Type"::"NonRealtime Report");

        GeneratedAccessToken := GetAccessToken;
        Parameters := Parameters.Dictionary;
        Parameters.Add(baseurl, NCHLSetup."Base URL");
        Parameters.Add(path, NCHLIntegrationService."Service Name");
        Parameters.Add(username, NCHLSetup."Username (Basic Auth.)");
        Parameters.Add(restmethod, FORMAT(NCHLSetup."Rest Method"));

        ValidatingData := STRSUBSTNO(strText);
        stringContent := stringContent.StringContent(ValidatingData, encoding.UTF8, JsonFormat);
        Parameters.Add(httpcontent, stringContent);
        CallRESTO2Auth(Parameters, HttpResponseMessage);
        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        JSONResponseText := result.ToString;
        MESSAGE(FORMAT(JSONResponseText));
    end;
}

