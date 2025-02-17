codeunit 33020512 "IRD Web Service Mgt."
{
    //  data += '&seller_pan=' + '302956542';
    //  data += '&buyer_pan=' + '123456789';
    //  data += '&buyer_name=' + 'testsoft';
    //  data += '&fiscal_year=' + '2074.075';
    //  data += '&invoice_number=' + InvoiceNumber;
    //  data += '&invoice_date=' + '2074.06.29';
    //  data += '&total_sales=' + '1000';
    //  data += '&taxable_sales_vat=' + '1000';
    //  data += '&vat=' + '130';
    //  data += '&excisable_amount=' + '0';
    //  data += '&excise=' + '0';
    //  data += '&taxable_sales_hst=' + '0';
    //  data += '&hst=' + '0';
    //  data += '&amount_for_esf=' + '0';
    //  data += '&esf=' + '0';
    //  data += '&export_sales=' + '0';
    //  data += '&tax_exempted_sales=' + '0';
    //  data += '&isrealtime=' + 'true';


    trigger OnRun()
    begin
        ReversalEntry.SetHideDialog(TRUE);

        ReversalEntry.ReverseTransaction(1);
    end;

    var
        Text000: Label 'Sending Data...';
        Text001: Label 'Sending Data failed!\Statuscode: %1\Description: %2';
        Error100: Label 'API credential does not match.';
        Error101: Label 'Bill Already Exists.';
        Error102: Label 'Exception while saving bill details.';
        Error103: Label 'Unknown exceptions.';
        Error104: Label 'Invalid Bill Model.';
        Error105: Label 'Bill Not Found.';
        CError100: Label 'API credential does not match.';
        CError101: Label 'Bill does not exists.';
        CError102: Label 'Exception while saving credit note details.';
        CError103: Label 'Unknown exceptions.';
        CError104: Label 'Invalid Bill Model.';
        CError105: Label 'Bill does not exists (for Sales Return)';
        CompanyInfo: Record "79";
        ReversalEntry: Record "179";

    [Scope('Internal')]
    procedure PushBill(SellerPan: Text; BuyerPan: Text; BuyerName: Text; FiscalYear: Text; InvoiceNumber: Text; InvoiceDate: Text; TotalSales: Decimal; TaxableSalesVAT: Decimal; VAT: Decimal; ExcisableAmount: Decimal; Excise: Decimal; TaxableSalesHST: Decimal; HST: Decimal; AmountForESF: Decimal; ESF: Decimal; ExportSales: Decimal; TaxExemptedSales: Decimal; IsRealTime: Boolean; PostingDatetime: DateTime; var ResponseMessage: Text) ReturnValue: Boolean
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
        data: Text;
        statusCode: Text;
        statusText: Text;
        ResponseCode: Code[10];
        PhoneNo: Text;
        MessageText: Text;
        Success: Boolean;
        ErrorMessage: Text;
    begin
        IF IsAlphanumeric(BuyerPan) THEN
            BuyerPan := '';
        CompanyInfo.GET;
        CreateJsonRequest(data, 'username', CompanyInfo."CBMS Username", 1, 1);
        CreateJsonRequest(data, 'password', CompanyInfo."CBMS Password", 1, 0);
        CreateJsonRequest(data, 'seller_pan', SellerPan, 1, 0);
        CreateJsonRequest(data, 'buyer_pan', BuyerPan, 1, 0);
        CreateJsonRequest(data, 'buyer_name', BuyerName, 1, 0);
        CreateJsonRequest(data, 'fiscal_year', FiscalYear, 1, 0);
        CreateJsonRequest(data, 'invoice_number', InvoiceNumber, 1, 0);
        CreateJsonRequest(data, 'invoice_date', InvoiceDate, 1, 0);
        CreateJsonRequest(data, 'total_sales', FORMAT(TotalSales, 0, 2), 2, 0);
        CreateJsonRequest(data, 'taxable_sales_vat', FORMAT(TaxableSalesVAT, 0, 2), 2, 0);
        CreateJsonRequest(data, 'vat', FORMAT(VAT, 0, 2), 2, 0);
        CreateJsonRequest(data, 'excisable_amount', FORMAT(ExcisableAmount, 0, 2), 2, 0);
        CreateJsonRequest(data, 'excise', FORMAT(Excise, 0, 2), 2, 0);
        CreateJsonRequest(data, 'taxable_sales_hst', FORMAT(TaxableSalesHST, 0, 2), 2, 0);
        CreateJsonRequest(data, 'hst', FORMAT(HST, 0, 2), 2, 0);
        CreateJsonRequest(data, 'amount_for_esf', FORMAT(AmountForESF, 0, 2), 2, 0);
        CreateJsonRequest(data, 'esf', FORMAT(ESF, 0, 2), 2, 0);
        CreateJsonRequest(data, 'export_sales', FORMAT(ExportSales, 0, 2), 2, 0);
        CreateJsonRequest(data, 'tax_exempted_sales', FORMAT(TaxExemptedSales, 0, 2), 2, 0);
        IF IsRealTime THEN
            CreateJsonRequest(data, 'isrealtime', 'true', 2, 0)
        ELSE
            CreateJsonRequest(data, 'isrealtime', 'false', 2, 0);
        CreateJsonRequest(data, 'datetimeClient', FORMAT(PostingDatetime, 0, 9), 1, 2);
        stringContent := stringContent.StringContent(data, encoding.UTF8, 'application/json');



        ReturnValue := CallRESTBillWebService(CompanyInfo."CBMS Base URL",
                                                           'POST',
                                                           'POST',
                                                           stringContent,
                                                           HttpResponseMessage);

        IF NOT ReturnValue THEN
            EXIT(FALSE);

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        CLEAR(ErrorMessage);
        Success := IsSuccess(result.ToString, ErrorMessage);
        ResponseMessage := result.ToString + ' : ' + ErrorMessage;  //to record response received from CBMS in invoice materialized view
        IF Success THEN
            EXIT(TRUE)
        ELSE
            MESSAGE(ErrorMessage);
        EXIT(FALSE);
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure CallRESTBillWebService(BaseUrl: Text; Method: Text; RestMethod: Text; var HttpContent: DotNet HttpContent; var HttpResponseMessage: DotNet HttpResponseMessage)
    var
        HttpClient: DotNet HttpClient;
        Uri: DotNet Uri;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseUrl);
        HttpClient.Timeout(2000);

        CASE RestMethod OF
            'GET':
                HttpResponseMessage := HttpClient.GetAsync(Method).Result;
            'POST':
                HttpResponseMessage := HttpClient.PostAsync('api/bill', HttpContent).Result;
            'PUT':
                HttpResponseMessage := HttpClient.PutAsync(Method, HttpContent).Result;
            'DELETE':
                HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        END;

        HttpResponseMessage.EnsureSuccessStatusCode()
    end;

    local procedure IsSuccess(ResponseCode: Text; var ErrorMessage: Text): Boolean
    begin
        CASE ResponseCode OF
            '100':
                ErrorMessage := Error100;
            '101':
                //ErrorMessage := Error101;
                EXIT(TRUE);
            '102':
                ErrorMessage := Error102;
            '103':
                ErrorMessage := Error103;
            '104':
                ErrorMessage := Error104;
            '105':
                ErrorMessage := Error105;
            '200':
                EXIT(TRUE);
            ELSE
                ErrorMessage := ResponseCode;
        END;
    end;

    [Scope('Internal')]
    procedure PushCreditBill(SellerPan: Text; BuyerPan: Text; BuyerName: Text; FiscalYear: Text; Ref_InvoiceNumber: Text; ReturnDate: Text; ReturnDocumentNo: Text; TotalSales: Decimal; TaxableSalesVAT: Decimal; VAT: Decimal; ExcisableAmount: Decimal; Excise: Decimal; TaxableSalesHST: Decimal; HST: Decimal; AmountForESF: Decimal; ESF: Decimal; ExportSales: Decimal; TaxExemptedSales: Decimal; IsRealTime: Boolean; PostingDatetime: DateTime; ReasonForReturn: Text; var ResponseMessage: Text) ReturnValue: Boolean
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
        data: Text;
        statusCode: Text;
        statusText: Text;
        ResponseCode: Code[10];
        PhoneNo: Text;
        MessageText: Text;
        Success: Boolean;
        ErrorMessage: Text;
    begin
        IF IsAlphanumeric(BuyerPan) THEN
            BuyerPan := '';
        CompanyInfo.GET;
        CreateJsonRequest(data, 'username', CompanyInfo."CBMS Username", 1, 1);
        CreateJsonRequest(data, 'password', CompanyInfo."CBMS Password", 1, 0);
        CreateJsonRequest(data, 'seller_pan', SellerPan, 1, 0);
        CreateJsonRequest(data, 'buyer_pan', BuyerPan, 1, 0);
        CreateJsonRequest(data, 'fiscal_year', FiscalYear, 1, 0);
        CreateJsonRequest(data, 'buyer_name', BuyerName, 1, 0);
        CreateJsonRequest(data, 'ref_invoice_number', Ref_InvoiceNumber, 1, 0);
        CreateJsonRequest(data, 'credit_note_number', ReturnDocumentNo, 1, 0);
        CreateJsonRequest(data, 'credit_note_date', ReturnDate, 1, 0);
        CreateJsonRequest(data, 'reason_for_return', ReasonForReturn, 1, 0);
        CreateJsonRequest(data, 'total_sales', FORMAT(TotalSales, 0, 2), 2, 0);
        CreateJsonRequest(data, 'taxable_sales_vat', FORMAT(TaxableSalesVAT, 0, 2), 2, 0);
        CreateJsonRequest(data, 'vat', FORMAT(VAT, 0, 2), 2, 0);
        CreateJsonRequest(data, 'excisable_amount', FORMAT(ExcisableAmount, 0, 2), 2, 0);
        CreateJsonRequest(data, 'excise', FORMAT(Excise, 0, 2), 2, 0);
        CreateJsonRequest(data, 'taxable_sales_hst', FORMAT(TaxableSalesHST, 0, 2), 2, 0);
        CreateJsonRequest(data, 'hst', FORMAT(HST, 0, 2), 2, 0);
        CreateJsonRequest(data, 'amount_for_esf', FORMAT(AmountForESF, 0, 2), 2, 0);
        CreateJsonRequest(data, 'esf', FORMAT(ESF, 0, 2), 2, 0);
        CreateJsonRequest(data, 'export_sales', FORMAT(ExportSales, 0, 2), 2, 0);
        CreateJsonRequest(data, 'tax_exempted_sales', FORMAT(TaxExemptedSales, 0, 2), 2, 0);
        IF IsRealTime THEN
            CreateJsonRequest(data, 'isrealtime', 'true', 2, 0)
        ELSE
            CreateJsonRequest(data, 'isrealtime', 'false', 2, 0);
        CreateJsonRequest(data, 'datetimeClient', FORMAT(PostingDatetime, 0, 9), 1, 2);

        stringContent := stringContent.StringContent(data, encoding.UTF8, 'application/json');


        ReturnValue := CallRESTCreditBillWebService(CompanyInfo."CBMS Base URL",
                                                           'POST',
                                                           'POST',
                                                           stringContent,
                                                           HttpResponseMessage);

        IF NOT ReturnValue THEN
            EXIT(FALSE);

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
        CLEAR(ErrorMessage);
        Success := IsSuccessCredit(result.ToString, ErrorMessage);
        ResponseMessage := result.ToString + ' : ' + ErrorMessage;  //to record response received from CBMS in invoice materialized view
        IF Success THEN
            EXIT(TRUE)
        ELSE
            IF result.ToString = '101' THEN
                EXIT(TRUE);
        MESSAGE(ErrorMessage);
        EXIT(FALSE);
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure CallRESTCreditBillWebService(BaseUrl: Text; Method: Text; RestMethod: Text; var HttpContent: DotNet HttpContent; var HttpResponseMessage: DotNet HttpResponseMessage)
    var
        HttpClient: DotNet HttpClient;
        Uri: DotNet Uri;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseUrl);
        HttpClient.Timeout(2000);

        CASE RestMethod OF
            'GET':
                HttpResponseMessage := HttpClient.GetAsync(Method).Result;
            'POST':
                HttpResponseMessage := HttpClient.PostAsync('api/billreturn', HttpContent).Result;
            'PUT':
                HttpResponseMessage := HttpClient.PutAsync(Method, HttpContent).Result;
            'DELETE':
                HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        END;

        HttpResponseMessage.EnsureSuccessStatusCode();
    end;

    local procedure IsSuccessCredit(ResponseCode: Text; var ErrorMessage: Text): Boolean
    begin
        CASE ResponseCode OF
            '100':
                ErrorMessage := CError100;
            '101':
                // ErrorMessage := CError101;
                EXIT(TRUE); //happens if reg no is not found and already synced data to be synced
            '102':
                ErrorMessage := CError102;
            '103':
                ErrorMessage := CError103;
            '104':
                ErrorMessage := CError104;
            '105':
                ErrorMessage := CError105;
            '200':
                EXIT(TRUE);
            ELSE
                ErrorMessage := ResponseCode;
        END;
    end;

    [Scope('Internal')]
    procedure GetSetup(): Boolean
    begin
        CompanyInfo.GET;
        EXIT((CompanyInfo."CBMS Base URL" <> '') AND
             (CompanyInfo."CBMS Username" <> '') AND
             (CompanyInfo."CBMS Password" <> ''))
    end;

    [Scope('Internal')]
    procedure IsAlphanumeric(VATNo: Text[30]): Boolean
    var
        IntLoop: Integer;
        Char: Code[30];
    begin
        Char := '';
        FOR IntLoop := 1 TO STRLEN(VATNo) DO BEGIN
            Char := COPYSTR(VATNo, IntLoop, 1);
            IF Char IN ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '.'] THEN BEGIN
                EXIT(TRUE)
            END;
        END;
        EXIT(FALSE)
    end;

    local procedure CreateJsonRequest(var dataVar: Text; DataItem: Text; DataValue: Text; DataType: Option " ",Text,Decimal; ParameterSequence: Option " ",First,Last)
    var
        DataItemLength: Integer;
    begin
        BEGIN
            DataItemLength := STRLEN(DataItem);
            CASE ParameterSequence OF
                ParameterSequence::First:
                    dataVar := '{' + CreateJsonObject(DataItem, DataValue, DataType) + ',';
                ParameterSequence::" ":
                    dataVar += CreateJsonObject(DataItem, DataValue, DataType) + ',';
                ParameterSequence::Last:
                    dataVar += CreateJsonObject(DataItem, DataValue, DataType) + '}';
            END;
        END;
    end;

    local procedure CreateJsonObject(DataItem: Text; DataValue: Text; DataType: Option "  ",Text,Decimal): Text
    begin
        BEGIN
            CASE DataType OF
                DataType::Text:
                    EXIT('"' + DataItem + '" : ' + '"' + DataValue + '"');
                DataType::Decimal:
                    EXIT('"' + DataItem + '" : ' + DataValue);
            END;
        END;

    end;
}

