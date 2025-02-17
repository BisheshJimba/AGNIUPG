codeunit 33020513 "IRD CBMS Mgt."
{
    TableNo = 33020293;

    trigger OnRun()
    var
        SalesInvoiceHeader: Record "112";
        SalesCrMemoHeader: Record "114";
    begin
        InvoiceMaterializedView := Rec;
        IF InvoiceMaterializedView."Document Type" = InvoiceMaterializedView."Document Type"::"Sales Invoice" THEN BEGIN
            IF NOT SalesInvoiceHeader.GET(InvoiceMaterializedView."Bill No") THEN
                EXIT;
            PushBill;
        END
        ELSE
            IF InvoiceMaterializedView."Document Type" = InvoiceMaterializedView."Document Type"::"Sales Credit Memo" THEN BEGIN
                IF NOT SalesCrMemoHeader.GET(InvoiceMaterializedView."Bill No") THEN
                    EXIT;
                PushCreditBill;
            END;
        Rec := InvoiceMaterializedView;
        COMMIT;
    end;

    var
        InvoiceMaterializedView: Record "33020293";
        CompanyInfo: Record "79";
        TotalSalesAmount: Decimal;
        TotalTaxableAmount: Decimal;
        TotalNonTaxableAmount: Decimal;
        TotalVATAmount: Decimal;
        BillType: Option Invoice,"Credit Memo";
        RealTimeTransaction: Boolean;

    [Scope('Internal')]
    procedure PushBill()
    var
        CompanyInformation: Record "79";
        BillUpdateinIRD: Boolean;
        IRDWebService: Codeunit "33020512";
        IRDMgt: Codeunit "50000";
        NepaliDate: Text;
        ResponseMessage: Text;
    begin
        CompanyInformation.GET;
        IF NOT InvoiceMaterializedView.MODIFY THEN
            EXIT;
        NepaliDate := IRDMgt.getNepaliDate(InvoiceMaterializedView."Bill Date");
        BillUpdateinIRD := IRDWebService.PushBill(
                CompanyInformation."VAT Registration No.",
                InvoiceMaterializedView."VAT Registration No.",
                InvoiceMaterializedView."Customer Name",
                InvoiceMaterializedView."Fiscal Year",
                InvoiceMaterializedView."Bill No",
                ReplaceString(FORMAT(NepaliDate), '/', '.'),
                InvoiceMaterializedView."Taxable Amount" + InvoiceMaterializedView."TAX Amount",
                InvoiceMaterializedView."Taxable Amount",
                InvoiceMaterializedView."TAX Amount",
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                InvoiceMaterializedView."Non Taxable Amount", RealTimeTransaction, CREATEDATETIME(InvoiceMaterializedView."Bill Date", InvoiceMaterializedView."Posting Time"), ResponseMessage);
        IF BillUpdateinIRD THEN BEGIN
            InvoiceMaterializedView."Sync Status" := InvoiceMaterializedView."Sync Status"::"Sync Completed";
            InvoiceMaterializedView."Sync with IRD" := TRUE;
            InvoiceMaterializedView."Synced Date" := TODAY;
            InvoiceMaterializedView."Synced Time" := TIME;
            InvoiceMaterializedView."Is Realtime" := RealTimeTransaction;
            InvoiceMaterializedView."CBMS Sync. Response" := '200 : Success';
            InvoiceMaterializedView.MODIFY;
        END ELSE BEGIN
            InvoiceMaterializedView."CBMS Sync. Response" := ResponseMessage;
            InvoiceMaterializedView.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure PushCreditBill()
    var
        CompanyInformation: Record "79";
        SalesCrMemoLine: Record "115";
        SalesInvoiceHeader: Record "112";
        ReturnReason: Record "6635";
        BillUpdateinIRD: Boolean;
        IRDWebService: Codeunit "33020512";
        ReturnedDocNo: Code[20];
        ReturnReasonDesc: Text;
        NepaliDate: Text;
        IRDMgt: Codeunit "50000";
        ResponseMessage: Text;
    begin
        CompanyInformation.GET;
        IF NOT InvoiceMaterializedView.MODIFY THEN
            EXIT;
        ReturnedDocNo := '';
        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE("Document No.", InvoiceMaterializedView."Bill No");
        SalesCrMemoLine.SETFILTER("Returned Invoice No.", '<>%1', '');
        IF SalesCrMemoLine.FINDFIRST THEN BEGIN
            ReturnReasonDesc := SalesCrMemoLine."Return Reason Code";
            CLEAR(ReturnReason);
            IF ReturnReason.GET(SalesCrMemoLine."Return Reason Code") THEN
                ReturnReasonDesc := ReturnReason.Description;
            ReturnedDocNo := SalesCrMemoLine."Returned Invoice No.";
            IF SalesInvoiceHeader.GET(ReturnedDocNo) THEN BEGIN
                NepaliDate := IRDMgt.getNepaliDate(InvoiceMaterializedView."Bill Date");
                BillUpdateinIRD := IRDWebService.PushCreditBill(
                        CompanyInformation."VAT Registration No.",
                        InvoiceMaterializedView."VAT Registration No.",
                        InvoiceMaterializedView."Customer Name",
                        InvoiceMaterializedView."Fiscal Year",
                        ReturnedDocNo,
                        ReplaceString(FORMAT(NepaliDate), '/', '.'),
                        InvoiceMaterializedView."Bill No",
                        InvoiceMaterializedView."Taxable Amount" + InvoiceMaterializedView."TAX Amount",
                        InvoiceMaterializedView."Taxable Amount",
                        InvoiceMaterializedView."TAX Amount",
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        InvoiceMaterializedView."Non Taxable Amount", RealTimeTransaction, CREATEDATETIME(InvoiceMaterializedView."Bill Date", InvoiceMaterializedView."Posting Time"),
                        ReturnReasonDesc, ResponseMessage);
                IF BillUpdateinIRD THEN BEGIN
                    InvoiceMaterializedView."Sync Status" := InvoiceMaterializedView."Sync Status"::"Sync Completed";
                    InvoiceMaterializedView."Sync with IRD" := TRUE;
                    InvoiceMaterializedView."Synced Date" := TODAY;
                    InvoiceMaterializedView."Synced Time" := TIME;
                    InvoiceMaterializedView."Is Realtime" := RealTimeTransaction;
                    InvoiceMaterializedView."CBMS Sync. Response" := '200 : Success';
                    InvoiceMaterializedView.MODIFY;
                END ELSE BEGIN
                    InvoiceMaterializedView."CBMS Sync. Response" := ResponseMessage;
                    InvoiceMaterializedView.MODIFY;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure PushBatchBill(var InvoiceMaterializedView: Record "33020293")
    var
        PushInvoices: Codeunit "33020513";
    begin
        IF InvoiceMaterializedView.FINDFIRST THEN
            REPEAT
                IF InvoiceMaterializedView."Sync Status" = InvoiceMaterializedView."Sync Status"::"Sync In Progress" THEN BEGIN
                    CLEAR(PushInvoices);
                    IF PushInvoices.RUN(InvoiceMaterializedView) THEN;
                END;
            UNTIL InvoiceMaterializedView.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SetRealTime()
    begin
        RealTimeTransaction := RealTimeEnabled;
    end;

    [Scope('Internal')]
    procedure Enabled(): Boolean
    begin
        CompanyInfo.GET;
        EXIT((CompanyInfo."CBMS Base URL" <> '') AND
             (CompanyInfo."CBMS Username" <> '') AND
             (CompanyInfo."CBMS Password" <> ''))
    end;

    [Scope('Internal')]
    procedure RealTimeEnabled(): Boolean
    begin
        CompanyInfo.GET;
        EXIT(CompanyInfo."Enable CBMS Realtime Sync");
    end;

    [Scope('Internal')]
    procedure StartRealTimeCBMSIntegration(var SalesHeader: Record "36"; var SalesInvHeader: Record "112"; var SalesCrMemoHeader: Record "114")
    var
        PushInvoices: Codeunit "33020513";
        SalesData: Record "33020293";
    begin
        IF SalesHeader.Invoice THEN BEGIN
            IF SalesInvHeader."No." <> '' THEN BEGIN
                CLEAR(PushInvoices);
                IF PushInvoices.Enabled THEN BEGIN
                    IF PushInvoices.RealTimeEnabled THEN BEGIN
                        PushInvoices.SetRealTime;
                        SalesData.RESET;
                        SalesData.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
                        SalesData.SETRANGE("Document Type", SalesData."Document Type"::"Sales Invoice");
                        SalesData.SETRANGE("Bill No", SalesInvHeader."No.");
                        IF SalesData.FINDLAST THEN BEGIN
                            COMMIT;
                            IF NOT PushInvoices.RUN(SalesData) THEN;
                        END;
                    END;
                END;
            END
            ELSE
                IF SalesCrMemoHeader."No." <> '' THEN BEGIN
                    CLEAR(PushInvoices);
                    IF PushInvoices.Enabled THEN BEGIN
                        IF PushInvoices.RealTimeEnabled THEN BEGIN
                            PushInvoices.SetRealTime;
                            SalesData.RESET;
                            SalesData.SETRANGE("Table ID", DATABASE::"Sales Cr.Memo Header");
                            SalesData.SETRANGE("Document Type", SalesData."Document Type"::"Sales Credit Memo");
                            SalesData.SETRANGE("Bill No", SalesCrMemoHeader."No.");
                            IF SalesData.FINDLAST THEN BEGIN
                                COMMIT;
                                IF NOT PushInvoices.RUN(SalesData) THEN;
                            END;
                        END;
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure StartBatchCBMSIntegration(var InvoiceMaterializeView: Record "33020293")
    var
        PushInvoices: Codeunit "33020513";
        SalesInvoiceHeader: Record "112";
        SalesCrMemoHeader: Record "114";
        ReturnedDocNo: Code[20];
    begin
        IF (InvoiceMaterializeView."Sync Status" = InvoiceMaterializeView."Sync Status"::"Sync In Progress") OR
            (InvoiceMaterializeView."Sync Status" = InvoiceMaterializeView."Sync Status"::Pending)
        THEN BEGIN
            IF InvoiceMaterializeView."Document Type" = InvoiceMaterializeView."Document Type"::"Sales Invoice" THEN BEGIN
                IF SalesInvoiceHeader.GET(InvoiceMaterializeView."Bill No") THEN BEGIN
                    CLEAR(PushInvoices);
                    IF PushInvoices.Enabled THEN BEGIN
                        COMMIT;
                        IF NOT PushInvoices.RUN(InvoiceMaterializeView) THEN;
                    END;
                END;
            END
            ELSE
                IF InvoiceMaterializeView."Document Type" = InvoiceMaterializeView."Document Type"::"Sales Credit Memo" THEN BEGIN
                    IF SalesCrMemoHeader.GET(InvoiceMaterializeView."Bill No") THEN BEGIN
                        CLEAR(PushInvoices);
                        IF PushInvoices.Enabled THEN BEGIN
                            COMMIT;
                            IF NOT PushInvoices.RUN(InvoiceMaterializeView) THEN;
                        END;
                    END;
                END
        END;
    end;

    [Scope('Internal')]
    procedure SendDataForSync(var InvoiceMaterializeView: Record "33020293"; NewStatus: Option "Not Valid","Pending Approval","Sync In Progress","Sync Completed")
    var
        NewInvoiceMaterializeView: Record "33020293";
    begin
        IF InvoiceMaterializeView.FINDSET THEN
            REPEAT
                IF InvoiceMaterializeView."Sync Status" IN [InvoiceMaterializeView."Sync Status"::"Sync In Progress", InvoiceMaterializeView."Sync Status"::Pending] THEN BEGIN
                    NewInvoiceMaterializeView := InvoiceMaterializeView;
                    NewInvoiceMaterializeView."Sync Status" := NewStatus;
                    NewInvoiceMaterializeView.MODIFY;
                END;
            UNTIL InvoiceMaterializeView.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetAmounts(BillType: Option Invoice,"Credit Memo"; BillNo: Code[20])
    var
        SalesInvoiceLine: Record "113";
        SalesCrMemoLine: Record "115";
    begin
        TotalSalesAmount := 0;
        TotalTaxableAmount := 0;
        TotalNonTaxableAmount := 0;
        TotalVATAmount := 0;
        CASE BillType OF
            BillType::Invoice:
                BEGIN
                    SalesInvoiceLine.RESET;
                    SalesInvoiceLine.SETRANGE("Document No.", BillNo);
                    IF SalesInvoiceLine.FINDFIRST THEN BEGIN
                        TotalSalesAmount += SalesInvoiceLine.Amount;
                        IF SalesInvoiceLine."VAT %" = 0 THEN BEGIN
                            TotalNonTaxableAmount += SalesInvoiceLine.Amount;
                        END
                        ELSE BEGIN
                            TotalTaxableAmount += SalesInvoiceLine.Amount;
                            TotalVATAmount += ROUND((SalesInvoiceLine.Amount * SalesInvoiceLine."VAT %" / 100), 0.01);
                        END;
                    END;
                END;
            BillType::"Credit Memo":
                BEGIN
                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE("Document No.", BillNo);
                    IF SalesCrMemoLine.FINDFIRST THEN BEGIN
                        TotalSalesAmount += SalesCrMemoLine.Amount;
                        IF SalesCrMemoLine."VAT %" = 0 THEN BEGIN
                            TotalNonTaxableAmount += SalesCrMemoLine.Amount;
                        END
                        ELSE BEGIN
                            TotalTaxableAmount += SalesCrMemoLine.Amount;
                            TotalVATAmount += ROUND((SalesCrMemoLine.Amount * SalesCrMemoLine."VAT %" / 100), 0.01);
                        END;
                    END;
                END;
        END;
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    begin
        WHILE STRPOS(String, FindWhat) > 0 DO
            String := DELSTR(String, STRPOS(String, FindWhat)) + ReplaceWith + COPYSTR(String, STRPOS(String, FindWhat) + STRLEN(FindWhat));
        NewString := String;
        EXIT(NewString);
    end;
}

