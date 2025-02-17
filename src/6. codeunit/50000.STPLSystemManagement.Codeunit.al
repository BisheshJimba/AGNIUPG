codeunit 50000 "STPL System Management"
{
    Permissions = TableData 309 = rm;
    TableNo = 45;

    trigger OnRun()
    begin
        //TDS2.00
        TDSEntry.SETRANGE("Entry No.", Rec."From TDS Entry No.", Rec."To TDS Entry No.");
        PAGE.RUN(PAGE::"TDS Entries", TDSEntry);
        //TDS2.00
    end;

    var
        ResponsibilityCenter: Record "5714";
        AccountabilityCenter: Record "33019846";
        TDSEntry: Record "33019850";
        GeneralLedgSetup: Record "98";
        UserSetup: Record "91";
        TableModificationErr: Label '%1 cannot be modified because %2 exists for %3 %4.';
        ChangeRecordTxt: Label 'the record';
        Text007: Label 'You cannot change %1 because there are one or more %2 for this %3.';
        SalesSetup: Record "311";
        Customer: Record "18";
        RoundUpGL: Code[20];
        ChangeCompanyRecord: Boolean;
        NewCompanyName: Text[30];

    [Scope('Internal')]
    procedure createNepaliCalender()
    var
        EngNepCalender3: Record "33020302";
    begin
        //Creates Nepali Calender.
    end;

    [Scope('Internal')]
    procedure getNepaliDate(PrmEngDate: Date): Code[10]
    var
        LocalEngNepCalender: Record "33020302";
        Text0000: Label 'Cannot find the equivalant Nepali Date! Please contact your system administrator.';
    begin
        LocalEngNepCalender.RESET;
        LocalEngNepCalender.SETRANGE("English Date", PrmEngDate);
        IF LocalEngNepCalender.FIND('-') THEN
            EXIT(LocalEngNepCalender."Nepali Date");
    end;

    [Scope('Internal')]
    procedure getEngDate(PrmNepDate: Code[20]): Date
    var
        LocalEngNepCalender2: Record "33020302";
        Text001: Label 'Cannot find equivalant English Date! Please contact your system administrator.';
    begin
        LocalEngNepCalender2.RESET;
        LocalEngNepCalender2.SETRANGE("Nepali Date", PrmNepDate);
        IF LocalEngNepCalender2.FIND('-') THEN
            EXIT(LocalEngNepCalender2."English Date");
    end;

    [Scope('Internal')]
    procedure GetEnglishFiscalYear(PostingDate: Date): Text[30]
    var
        AccountingPeriod: Record "50";
    begin
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETRANGE("Starting Date", 0D, PostingDate);
        IF AccountingPeriod.FINDLAST THEN BEGIN
            AccountingPeriod.VerifyAndSetNepaliFiscalyear(PostingDate);
            EXIT(AccountingPeriod."English Fiscal Year");
        END;
    end;

    [Scope('Internal')]
    procedure getCurrentFiscalYear(EngDate: Date): Code[10]
    var
        EnglishNepaliDate: Record "33020302";
    begin
        EnglishNepaliDate.RESET;
        EnglishNepaliDate.SETRANGE("English Date", EngDate);
        IF EnglishNepaliDate.FIND('-') THEN
            EXIT(EnglishNepaliDate."Fiscal Year");
    end;

    [Scope('Internal')]
    procedure getCurrentMonth(EngDate: Date): Integer
    var
        EnglishNepaliDate: Record "33020302";
    begin
        EnglishNepaliDate.RESET;
        EnglishNepaliDate.SETRANGE("English Date", EngDate);
        IF EnglishNepaliDate.FIND('-') THEN
            EXIT(EnglishNepaliDate."Nepali Month");
    end;

    [Scope('Internal')]
    procedure getVoucherFileNo(PrmFileStore: Integer)
    begin
    end;

    [Scope('Internal')]
    procedure getProcVarFieldName(TableNo: Integer; FieldNo: Integer): Code[50]
    var
        RetValue: Text[50];
    begin
        //Returns vendor no. or vendor name as per the selection.
        /*VendSelnSetup.RESET;
        VendSelnSetup.SETRANGE("Table No.",TableNo);
        VendSelnSetup.SETRANGE("Field No.",FieldNo);
        IF VendSelnSetup.FIND('-') THEN
          EXIT(VendSelnSetup."Vendor Name");*/

    end;

    [Scope('Internal')]
    procedure getVariableField(TableNo: Integer; FieldNo: Integer): Text[80]
    var
        VarFieldSetup: Record "33020335";
    begin
        //Returns field name.
        VarFieldSetup.RESET;
        VarFieldSetup.SETRANGE(VarFieldSetup."Table No.", TableNo);
        VarFieldSetup.SETRANGE(VarFieldSetup."Field No.", FieldNo);
        IF VarFieldSetup.FIND('-') THEN
            EXIT(VarFieldSetup."Field Name");
    end;

    [Scope('Internal')]
    procedure getLocWiseNoSeries("Document Profile": Option Purchase,Sales,Service,Transfer; "Document Type": Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note"): Code[10]
    var
        Location: Record "14";
        UserSetup: Record "91";
        GLSetup: Record "98";
    begin
        // yuran@agile BEGIN >> Returns Posting No. Series for current User as per Responsibility Center, Document Profile, Document Type
        UserSetup.GET(USERID);
        GLSetup.GET;
        IF NOT GLSetup."Use Accountability Center" THEN BEGIN
            IF ResponsibilityCenter.GET(UserSetup."Default Responsibility Center") THEN BEGIN
                CASE "Document Profile" OF
                    "Document Profile"::Purchase:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    EXIT(ResponsibilityCenter."Purch. Quote Nos.");
                                "Document Type"::"Blanket Order":
                                    EXIT(ResponsibilityCenter."Purch. Blanket Order Nos.");
                                "Document Type"::Order:
                                    EXIT(ResponsibilityCenter."Purch. Order Nos.");
                                "Document Type"::"Return Order":
                                    EXIT(ResponsibilityCenter."Purch. Return Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(ResponsibilityCenter."Purch. Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(ResponsibilityCenter."Purch. Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(ResponsibilityCenter."Purch. Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(ResponsibilityCenter."Purch. Posted Credit Memo Nos.");
                                "Document Type"::"Posted Receipt":
                                    EXIT(ResponsibilityCenter."Purch. Posted Receipt Nos.");
                                "Document Type"::"Posted Return Shipment":
                                    EXIT(ResponsibilityCenter."Purch. Ptd. Return Shpt. Nos.");
                                "Document Type"::"Posted Prepmt. Inv.":
                                    EXIT(ResponsibilityCenter."Purch. Posted Prept. Inv. Nos.");
                                "Document Type"::"Posted Prepmt. Cr. Memo":
                                    EXIT(ResponsibilityCenter."Purch. Ptd. Prept. Cr. M. Nos.");

                            END;
                        END;
                    "Document Profile"::Sales:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    EXIT(ResponsibilityCenter."Sales Quote Nos.");
                                "Document Type"::"Blanket Order":
                                    EXIT(ResponsibilityCenter."Sales Blanket Order Nos.");
                                "Document Type"::Order:
                                    EXIT(ResponsibilityCenter."Sales Order Nos.");
                                "Document Type"::"Return Order":
                                    EXIT(ResponsibilityCenter."Sales Return Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(ResponsibilityCenter."Sales Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(ResponsibilityCenter."Sales Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(ResponsibilityCenter."Sales Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(ResponsibilityCenter."Sales Posted Credit Memo Nos.");
                                "Document Type"::"Posted Shipment":
                                    EXIT(ResponsibilityCenter."Sales Posted Shipment Nos.");
                                "Document Type"::"Posted Return Receipt":
                                    EXIT(ResponsibilityCenter."Sales Ptd. Return Receipt Nos.");
                                "Document Type"::"Posted Debit Note":
                                    EXIT(ResponsibilityCenter."Sales Posted Debit Note Nos.");
                                "Document Type"::"Posted Prepmt. Inv.":
                                    EXIT(ResponsibilityCenter."Sales Posted Prepmt. Inv. Nos.");
                                "Document Type"::"Posted Prepmt. Cr. Memo":
                                    EXIT(ResponsibilityCenter."Sales Ptd. Prept. Cr. M. Nos.");

                            END;

                        END;
                    "Document Profile"::Service:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Booking:
                                    EXIT(ResponsibilityCenter."Serv. Booking Nos.");
                                "Document Type"::"Posted Order":
                                    EXIT(ResponsibilityCenter."Serv. Posted Order Nos.");
                                "Document Type"::Order:
                                    EXIT(ResponsibilityCenter."Serv. Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(ResponsibilityCenter."Serv. Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(ResponsibilityCenter."Serv. Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(ResponsibilityCenter."Serv. Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(ResponsibilityCenter."Serv. Posted Credit Memo Nos.");
                                "Document Type"::Quote:
                                    EXIT(ResponsibilityCenter."Serv. Quote Nos.");

                            END;
                        END;
                    "Document Profile"::Transfer:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Order:
                                    EXIT(ResponsibilityCenter."Trans. Order Nos.");
                                "Document Type"::"Posted Receipt":
                                    EXIT(ResponsibilityCenter."Posted Transfer Rcpt. Nos.");
                                "Document Type"::"Posted Shipment":
                                    EXIT(ResponsibilityCenter."Posted Transfer Shpt. Nos.");
                            END;
                        END;
                END;
            END;
        END
        ELSE BEGIN
            IF AccountabilityCenter.GET(UserSetup."Default Accountability Center") THEN BEGIN
                CASE "Document Profile" OF
                    "Document Profile"::Purchase:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    EXIT(AccountabilityCenter."Purch. Quote Nos.");
                                "Document Type"::"Blanket Order":
                                    EXIT(AccountabilityCenter."Purch. Blanket Order Nos.");
                                "Document Type"::Order:
                                    EXIT(AccountabilityCenter."Purch. Order Nos.");
                                "Document Type"::"Return Order":
                                    EXIT(AccountabilityCenter."Purch. Return Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(AccountabilityCenter."Purch. Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(AccountabilityCenter."Purch. Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(AccountabilityCenter."Purch. Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(AccountabilityCenter."Purch. Posted Credit Memo Nos.");
                                "Document Type"::"Posted Receipt":
                                    EXIT(AccountabilityCenter."Purch. Posted Receipt Nos.");
                                "Document Type"::"Posted Return Shipment":
                                    EXIT(AccountabilityCenter."Purch. Ptd. Return Shpt. Nos.");
                                "Document Type"::"Posted Prepmt. Inv.":
                                    EXIT(AccountabilityCenter."Purch. Posted Prept. Inv. Nos.");
                                "Document Type"::"Posted Prepmt. Cr. Memo":
                                    EXIT(AccountabilityCenter."Purch. Ptd. Prept. Cr. M. Nos.");

                            END;
                        END;
                    "Document Profile"::Sales:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    EXIT(AccountabilityCenter."Sales Quote Nos.");
                                "Document Type"::"Blanket Order":
                                    EXIT(AccountabilityCenter."Sales Blanket Order Nos.");
                                "Document Type"::Order:
                                    EXIT(AccountabilityCenter."Sales Order Nos.");
                                "Document Type"::"Return Order":
                                    EXIT(AccountabilityCenter."Sales Return Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(AccountabilityCenter."Sales Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(AccountabilityCenter."Sales Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(AccountabilityCenter."Sales Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(AccountabilityCenter."Sales Posted Credit Memo Nos.");
                                "Document Type"::"Posted Shipment":
                                    EXIT(AccountabilityCenter."Sales Posted Shipment Nos.");
                                "Document Type"::"Posted Return Receipt":
                                    EXIT(AccountabilityCenter."Sales Ptd. Return Receipt Nos.");
                                "Document Type"::"Posted Debit Note":
                                    EXIT(AccountabilityCenter."Sales Posted Debit Note Nos.");
                                "Document Type"::"Posted Prepmt. Inv.":
                                    EXIT(AccountabilityCenter."Sales Posted Prepmt. Inv. Nos.");
                                "Document Type"::"Posted Prepmt. Cr. Memo":
                                    EXIT(AccountabilityCenter."Sales Ptd. Prept. Cr. M. Nos.");
                            END;

                        END;
                    "Document Profile"::Service:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Booking:
                                    EXIT(AccountabilityCenter."Serv. Booking Nos.");
                                "Document Type"::"Posted Order":
                                    EXIT(AccountabilityCenter."Serv. Posted Order Nos.");
                                "Document Type"::Order:
                                    EXIT(AccountabilityCenter."Serv. Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(AccountabilityCenter."Serv. Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(AccountabilityCenter."Serv. Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(AccountabilityCenter."Serv. Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(AccountabilityCenter."Serv. Posted Credit Memo Nos.");
                                "Document Type"::Quote:
                                    EXIT(AccountabilityCenter."Serv. Quote Nos.");

                            END;
                        END;
                    "Document Profile"::Transfer:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Order:
                                    EXIT(AccountabilityCenter."Trans. Order Nos.");
                                "Document Type"::"Posted Receipt":
                                    EXIT(AccountabilityCenter."Posted Transfer Rcpt. Nos.");
                                "Document Type"::"Posted Shipment":
                                    EXIT(AccountabilityCenter."Posted Transfer Shpt. Nos.");
                            END;
                        END;
                END;
            END;

        END;
    end;

    [Scope('Internal')]
    procedure changeUserProfile()
    var
        UserSetup: Record "91";
        UserProfileSetup: Record "25006067";
        UserPersonalization: Record "2000000073";
    begin
    end;

    [Scope('Internal')]
    procedure getCustCompNo(): Code[10]
    var
        Location: Record "14";
        UserSetup: Record "91";
        GLSetup: Record "98";
    begin
        UserSetup.GET(USERID);
        GLSetup.GET;
        IF AccountabilityCenter.GET(UserSetup."Default Accountability Center") THEN
            EXIT(AccountabilityCenter."Customer Complain Nos.");
    end;

    [Scope('Internal')]
    procedure SyncMasterData(TableID: Integer; PrimaryKey: Code[20]; NoSeries: Code[10])
    var
        Customer: Record "18";
        CompanyRec: Record "2000000006";
        NoSeriesLine: Record "309";
    begin
        CompanyRec.RESET;
        CompanyRec.SETFILTER(Name, '<>%1', COMPANYNAME);
        IF CompanyRec.FINDSET THEN
            REPEAT
                NoSeriesLine.LOCKTABLE;
                NoSeriesLine.CHANGECOMPANY(CompanyRec.Name);
                NoSeriesLine.RESET;
                NoSeriesLine.SETCURRENTKEY("Series Code", "Starting Date");
                NoSeriesLine.SETRANGE("Series Code", NoSeries);
                NoSeriesLine.SETRANGE("Starting Date", 0D, WORKDATE);
                NoSeriesLine.SETRANGE(Open, TRUE);
                IF NoSeriesLine.FINDLAST THEN BEGIN
                    NoSeriesLine."Last No. Used" := PrimaryKey;
                    NoSeriesLine."Last Date Used" := WORKDATE;
                    NoSeriesLine.MODIFY;
                END;
                CLEAR(NoSeriesLine);
            UNTIL CompanyRec.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetVFCaption(TableNo: Integer; FieldNo: Integer; LanguageCode: Code[10]): Text[30]
    var
        VFUsage: Record "33020517";
        VF: Record "33020503";
    begin
        IF VFUsage.GET(TableNo, FieldNo) THEN BEGIN
            IF VF.GET(VFUsage."Variable Field Code") THEN BEGIN
                EXIT(COPYSTR(VF.Code, 1, 20));
            END;
        END;
        EXIT('');
    end;

    [Scope('Internal')]
    procedure getVariableFieldPRM(TableNo: Integer; FieldNo: Integer): Text[80]
    var
        VarFieldSetup: Record "33020517";
    begin
        //Returns field name.
        VarFieldSetup.RESET;
        VarFieldSetup.SETRANGE(VarFieldSetup."Table No.", TableNo);
        VarFieldSetup.SETRANGE(VarFieldSetup."Field No.", FieldNo);
        IF VarFieldSetup.FIND('-') THEN
            EXIT(VarFieldSetup."Variable Field Code");
    end;

    [Scope('Internal')]
    procedure GetMembershipNo(): Code[10]
    var
        Location: Record "14";
        UserSetup: Record "91";
        GLSetup: Record "98";
    begin
        //**SM 09 26 2013 to get membership no.
        UserSetup.GET(USERID);
        GLSetup.GET;
        IF AccountabilityCenter.GET(UserSetup."Default Accountability Center") THEN
            EXIT(AccountabilityCenter."Membership Nos.");
    end;

    [Scope('Internal')]
    procedure GetNoOfRecords(TableID: Integer)
    var
        CountRec: Integer;
    begin
    end;

    [Scope('Internal')]
    procedure InsertRegisterInvoice(TableID: Integer; DocumentNo: Code[20])
    var
        AccountingPeriod: Record "50";
        RegisterofInvoiceNoSeries: Record "33020293";
        SalesInvHeader: Record "112";
        SalesCrMemoheader: Record "114";
    begin

        CASE TableID OF
            DATABASE::"Sales Invoice Header":
                BEGIN
                    IF NOT SalesInvHeader.GET(DocumentNo) THEN
                        EXIT;
                    CLEAR(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INIT;
                    RegisterofInvoiceNoSeries."Table ID" := DATABASE::"Sales Invoice Header";
                    RegisterofInvoiceNoSeries."Document Type" := RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice";
                    RegisterofInvoiceNoSeries."Bill No" := SalesInvHeader."No.";
                    RegisterofInvoiceNoSeries."Fiscal Year" := GetNepaliFiscalYear(SalesInvHeader."Posting Date");
                    RegisterofInvoiceNoSeries."Bill Date" := SalesInvHeader."Posting Date";
                    RegisterofInvoiceNoSeries."Posting Time" := SalesInvHeader."Posting Time";
                    RegisterofInvoiceNoSeries."Source Type" := RegisterofInvoiceNoSeries."Source Type"::Customer;
                    RegisterofInvoiceNoSeries."Customer Code" := SalesInvHeader."Bill-to Customer No.";
                    RegisterofInvoiceNoSeries."Source Code" := SalesInvHeader."Source Code";
                    RegisterofInvoiceNoSeries."Customer Name" := SalesInvHeader."Bill-to Name";
                    RegisterofInvoiceNoSeries."VAT Registration No." := SalesInvHeader."VAT Registration No.";

                    CalculateInvoiceTotals(DATABASE::"Sales Invoice Header", SalesInvHeader."No.",
                          RegisterofInvoiceNoSeries.Amount, RegisterofInvoiceNoSeries.Discount, RegisterofInvoiceNoSeries."Taxable Amount",
                          RegisterofInvoiceNoSeries."TAX Amount", RegisterofInvoiceNoSeries."Total Amount");

                    RegisterofInvoiceNoSeries."Entered By" := SalesInvHeader."User ID";
                    RegisterofInvoiceNoSeries."Is BIll Printed" := SalesInvHeader."No. Printed" > 0;
                    RegisterofInvoiceNoSeries."Is Bill Active" := TRUE;
                    RegisterofInvoiceNoSeries."Printed By" := SalesInvHeader."Tax Invoice Printed By";
                    RegisterofInvoiceNoSeries."Accountability Center" := SalesInvHeader."Accountability Center";
                    SetSyncStatus(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INSERT;
                END;

            DATABASE::"Sales Cr.Memo Header":
                BEGIN
                    IF NOT SalesCrMemoheader.GET(DocumentNo) THEN
                        EXIT;
                    CLEAR(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INIT;
                    RegisterofInvoiceNoSeries."Table ID" := DATABASE::"Sales Cr.Memo Header";
                    RegisterofInvoiceNoSeries."Document Type" := RegisterofInvoiceNoSeries."Document Type"::"Sales Credit Memo";
                    RegisterofInvoiceNoSeries."Bill No" := SalesCrMemoheader."No.";
                    RegisterofInvoiceNoSeries."Fiscal Year" := GetNepaliFiscalYear(SalesCrMemoheader."Posting Date");
                    RegisterofInvoiceNoSeries."Bill Date" := SalesCrMemoheader."Posting Date";
                    RegisterofInvoiceNoSeries."Posting Time" := SalesCrMemoheader."Posting Time";
                    RegisterofInvoiceNoSeries."Source Type" := RegisterofInvoiceNoSeries."Source Type"::Customer;
                    RegisterofInvoiceNoSeries."Customer Code" := SalesCrMemoheader."Bill-to Customer No.";
                    RegisterofInvoiceNoSeries."Source Code" := SalesCrMemoheader."Source Code";
                    RegisterofInvoiceNoSeries."Customer Name" := SalesCrMemoheader."Bill-to Name";
                    RegisterofInvoiceNoSeries."VAT Registration No." := SalesCrMemoheader."VAT Registration No.";

                    CalculateInvoiceTotals(DATABASE::"Sales Cr.Memo Header", SalesCrMemoheader."No.",
                          RegisterofInvoiceNoSeries.Amount, RegisterofInvoiceNoSeries.Discount, RegisterofInvoiceNoSeries."Taxable Amount",
                          RegisterofInvoiceNoSeries."TAX Amount", RegisterofInvoiceNoSeries."Total Amount");

                    RegisterofInvoiceNoSeries."Entered By" := SalesCrMemoheader."User ID";
                    RegisterofInvoiceNoSeries."Is BIll Printed" := SalesCrMemoheader."No. Printed" > 0;
                    RegisterofInvoiceNoSeries."Is Bill Active" := TRUE;
                    RegisterofInvoiceNoSeries."Printed By" := SalesCrMemoheader."Printed By";
                    RegisterofInvoiceNoSeries."Accountability Center" := SalesCrMemoheader."Accountability Center";
                    SetSyncStatus(RegisterofInvoiceNoSeries);
                    RegisterofInvoiceNoSeries.INSERT;
                    SetInActiveInvoices(DocumentNo);
                END;

        END;
    end;

    [Scope('Internal')]
    procedure GetNepaliFiscalYear(PostingDate: Date): Text[30]
    var
        AccountingPeriod: Record "50";
    begin
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETRANGE("Starting Date", 0D, PostingDate);
        IF AccountingPeriod.FINDLAST THEN BEGIN
            AccountingPeriod.VerifyAndSetNepaliFiscalyear(PostingDate);
            EXIT(AccountingPeriod."Nepali Fiscal Year");
        END;
    end;

    [Scope('Internal')]
    procedure CalculateInvoiceTotals(TableNo: Integer; DocumentNo: Code[20]; var TotalSubTotal: Decimal; var TotalInvDiscAmount: Decimal; var TotalTaxableAmount: Decimal; var TotalAmountVAT: Decimal; var TotalAmountInclVAT: Decimal)
    var
        Currency: Record "4";
        SalesInvHeader: Record "112";
        SalesInvLine: Record "113";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
    begin

        TotalSubTotal := 0;
        TotalInvDiscAmount := 0;
        TotalTaxableAmount := 0;
        TotalAmountVAT := 0;
        TotalAmountInclVAT := 0;
        CASE TableNo OF
            DATABASE::"Sales Invoice Header":
                BEGIN
                    IF NOT SalesInvHeader.GET(DocumentNo) THEN
                        EXIT;
                    SalesInvLine.RESET;
                    SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
                    IF SalesInvLine.FINDSET THEN
                        REPEAT
                            IF SalesInvHeader."Currency Code" = '' THEN
                                Currency.InitRoundingPrecision
                            ELSE BEGIN
                                SalesInvHeader.TESTFIELD("Currency Factor");
                                Currency.GET(SalesInvHeader."Currency Code");
                                Currency.TESTFIELD("Amount Rounding Precision");
                            END;
                            TotalSubTotal += ROUND(SalesInvLine.Quantity * SalesInvLine."Unit Price", Currency."Amount Rounding Precision");
                            TotalInvDiscAmount += SalesInvLine."Line Discount Amount";
                            /*TotalInvDiscAmount :=
                            ROUND(
                              ROUND(SalesInvLine.Quantity * SalesInvLine."Unit Price",Currency."Amount Rounding Precision") *
                              SalesInvLine."Line Discount %" / 100,Currency."Amount Rounding Precision");
                             */
                            TotalInvDiscAmount += SalesInvLine."Inv. Discount Amount";
                            IF SalesInvLine."VAT %" > 0 THEN
                                TotalTaxableAmount += SalesInvLine.Amount;
                            TotalAmountVAT += SalesInvLine."Amount Including VAT" - SalesInvLine.Amount;
                            TotalAmountInclVAT += SalesInvLine."Amount Including VAT";
                        UNTIL SalesInvLine.NEXT = 0;
                END;

            DATABASE::"Sales Cr.Memo Header":
                BEGIN
                    IF NOT SalesCrMemoHeader.GET(DocumentNo) THEN
                        EXIT;
                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                    IF SalesCrMemoLine.FINDSET THEN
                        REPEAT
                            IF SalesCrMemoHeader."Currency Code" = '' THEN
                                Currency.InitRoundingPrecision
                            ELSE BEGIN
                                SalesCrMemoHeader.TESTFIELD("Currency Factor");
                                Currency.GET(SalesCrMemoHeader."Currency Code");
                                Currency.TESTFIELD("Amount Rounding Precision");
                            END;
                            TotalSubTotal += ROUND(SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Price", Currency."Amount Rounding Precision");
                            TotalInvDiscAmount += SalesCrMemoLine."Line Discount Amount";
                            TotalInvDiscAmount += SalesCrMemoLine."Inv. Discount Amount";
                            IF SalesCrMemoLine."VAT %" > 0 THEN
                                TotalTaxableAmount += SalesCrMemoLine.Amount;
                            TotalAmountVAT += SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount;
                            TotalAmountInclVAT += SalesCrMemoLine."Amount Including VAT";
                        UNTIL SalesCrMemoLine.NEXT = 0;
                END;

        END;

    end;

    [Scope('Internal')]
    procedure SetInActiveInvoices(DocumentNo: Code[20])
    var
        SalesInvHeader: Record "112";
        SalesCrMemoLine: Record "115";
        ValueEntry: Record "5802";
        RegisterofInvoiceNoSeries: Record "33020293";
    begin
        /*
        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE("Document No.",DocumentNo);
        SalesCrMemoLine.SETFILTER(Quantity,'<>0');
        SalesCrMemoLine.SETFILTER("Appl.-from Item Entry",'<>0');
        IF SalesCrMemoLine.FINDSET THEN REPEAT
          ValueEntry.RESET;
          ValueEntry.SETRANGE("Item Ledger Entry No.",SalesCrMemoLine."Appl.-from Item Entry");
          ValueEntry.SETRANGE("Item Ledger Entry Type",ValueEntry."Item Ledger Entry Type"::Sale);
          ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
          IF ValueEntry.FINDFIRST THEN BEGIN
            IF SalesInvHeader.GET(ValueEntry."Document No.") THEN BEGIN
              RegisterofInvoiceNoSeries.RESET;
              RegisterofInvoiceNoSeries.SETRANGE("Table ID",DATABASE::"Sales Invoice Header");
              RegisterofInvoiceNoSeries.SETRANGE("Document Type",RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
              RegisterofInvoiceNoSeries.SETRANGE("Document No.",ValueEntry."Document No.");
              RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year",GetNepaliFiscalYear(SalesInvHeader."Posting Date"));
              IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                RegisterofInvoiceNoSeries.Active := FALSE;
                RegisterofInvoiceNoSeries.MODIFY;
              END;
            END;
          END;
        UNTIL SalesCrMemoLine.NEXT = 0;
        */

        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE("Document No.", DocumentNo);
        SalesCrMemoLine.SETFILTER(Quantity, '<>0');
        IF SalesCrMemoLine.FINDSET THEN
            REPEAT
                RegisterofInvoiceNoSeries.RESET;
                RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
                RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
                RegisterofInvoiceNoSeries.SETRANGE("Bill No", SalesCrMemoLine."Returned Invoice No.");
                //RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year",GetNepaliFiscalYear(SalesInvHeader."Posting Date"));
                IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                    RegisterofInvoiceNoSeries."Is Bill Active" := FALSE;
                    RegisterofInvoiceNoSeries.MODIFY;
                END;
            UNTIL SalesCrMemoLine.NEXT = 0;

    end;

    [Scope('Internal')]
    procedure ModifySalesInvPrintInformation(var SalesInvoiceHeader: Record "112")
    var
        RegisterofInvoiceNoSeries: Record "33020293";
        AccountingPeriod: Record "50";
    begin
        IF SalesInvoiceHeader."No. Printed" = 1 THEN BEGIN
            SalesInvoiceHeader."Tax Invoice Printed By" := USERID;
            RegisterofInvoiceNoSeries.RESET;
            RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
            RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
            RegisterofInvoiceNoSeries.SETRANGE("Bill No", SalesInvoiceHeader."No.");
            RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year", GetNepaliFiscalYear(SalesInvoiceHeader."Posting Date"));
            IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                RegisterofInvoiceNoSeries."Is BIll Printed" := TRUE;
                RegisterofInvoiceNoSeries."Printed By" := USERID;
                RegisterofInvoiceNoSeries.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CheckSalesHeaderOnSalesPost(SalesHeader: Record "36")
    var
        SalesSetup: Record "311";
    begin
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Exact Cost Reversing Mandatory");
    end;

    [Scope('Internal')]
    procedure CheckSalesLineOnSalesPost(SalesHeader: Record "36")
    var
        SalesLine: Record "37";
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER(Quantity, '<>0');
        IF SalesLine.FINDSET THEN
            REPEAT
                IF SalesLine."Document Type" IN [SalesLine."Document Type"::"Return Order", SalesLine."Document Type"::"Credit Memo"] THEN
                    SalesLine.TESTFIELD("Return Reason Code");
            UNTIL SalesLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ModifySalesCrInvPrintInformati(var SalesCrMemoHeader: Record "114")
    var
        RegisterofInvoiceNoSeries: Record "33020293";
        AccountingPeriod: Record "50";
    begin
        IF SalesCrMemoHeader."No. Printed" = 1 THEN BEGIN
            SalesCrMemoHeader."Printed By" := USERID;
            RegisterofInvoiceNoSeries.RESET;
            RegisterofInvoiceNoSeries.SETRANGE("Table ID", DATABASE::"Sales Invoice Header");
            RegisterofInvoiceNoSeries.SETRANGE("Document Type", RegisterofInvoiceNoSeries."Document Type"::"Sales Invoice");
            RegisterofInvoiceNoSeries.SETRANGE("Bill No", SalesCrMemoHeader."No.");
            RegisterofInvoiceNoSeries.SETRANGE("Fiscal Year", GetNepaliFiscalYear(SalesCrMemoHeader."Posting Date"));
            IF RegisterofInvoiceNoSeries.FINDFIRST THEN BEGIN
                RegisterofInvoiceNoSeries."Is BIll Printed" := TRUE;
                RegisterofInvoiceNoSeries."Printed By" := USERID;
                RegisterofInvoiceNoSeries.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CheckDuplicateVATRegNo(TableNo: Integer; VATRegNo: Text[30]; VendCustNo: Code[20])
    var
        Customer: Record "18";
        Vendor: Record "23";
        Text001: Label 'VAT Registration No. %1 is already used for Customer %2.';
        Text002: Label 'VAT Registration No. %1 is already used for Vendor %2.';
    begin
        IF TableNo = DATABASE::Customer THEN BEGIN
            Customer.SETCURRENTKEY("VAT Registration No.");
            Customer.RESET;
            Customer.SETRANGE("VAT Registration No.", VATRegNo);
            Customer.SETFILTER("No.", '<>%1', VendCustNo);
            Customer.SETRANGE(Blocked, Customer.Blocked::" ");
            IF Customer.FINDFIRST THEN
                ERROR(Text001, VATRegNo, Customer."No.");
        END ELSE
            IF TableNo = DATABASE::Vendor THEN BEGIN
                Vendor.SETCURRENTKEY("VAT Registration No.");
                Vendor.RESET;
                Vendor.SETRANGE("VAT Registration No.", VATRegNo);
                Vendor.SETFILTER("No.", '<>%1', VendCustNo);
                Vendor.SETRANGE(Blocked, Vendor.Blocked::" ");
                IF Vendor.FINDFIRST THEN
                    ERROR(Text001, VATRegNo, Vendor."No.");

            END;
    end;

    [Scope('Internal')]
    procedure getLocWiseImpOrdNoSeries("Document Profile": Option Purchase,Sales,Service,Transfer; "Document Type": Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note"): Code[10]
    var
        Location: Record "14";
        UserSetup: Record "91";
        GLSetup: Record "98";
    begin
        UserSetup.GET(USERID);
        GLSetup.GET;
        IF NOT GLSetup."Use Accountability Center" THEN BEGIN
            IF ResponsibilityCenter.GET(UserSetup."Default Responsibility Center") THEN BEGIN
                CASE "Document Profile" OF
                    "Document Profile"::Purchase:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    EXIT(ResponsibilityCenter."Purch. Quote Nos.");
                                "Document Type"::"Blanket Order":
                                    EXIT(ResponsibilityCenter."Purch. Blanket Order Nos.");
                                "Document Type"::Order:
                                    EXIT(ResponsibilityCenter."Purch. Order Nos.");
                                "Document Type"::"Return Order":
                                    EXIT(ResponsibilityCenter."Purch. Return Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(ResponsibilityCenter."Purch. Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(ResponsibilityCenter."Purch. Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(ResponsibilityCenter."Purch. Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(ResponsibilityCenter."Purch. Posted Credit Memo Nos.");
                                "Document Type"::"Posted Receipt":
                                    EXIT(ResponsibilityCenter."Purch. Posted Receipt Nos.");
                                "Document Type"::"Posted Return Shipment":
                                    EXIT(ResponsibilityCenter."Purch. Ptd. Return Shpt. Nos.");
                                "Document Type"::"Posted Prepmt. Inv.":
                                    EXIT(ResponsibilityCenter."Purch. Posted Prept. Inv. Nos.");
                                "Document Type"::"Posted Prepmt. Cr. Memo":
                                    EXIT(ResponsibilityCenter."Purch. Ptd. Prept. Cr. M. Nos.");

                            END;
                        END;
                    "Document Profile"::Sales:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    EXIT(ResponsibilityCenter."Sales Quote Nos.");
                                "Document Type"::"Blanket Order":
                                    EXIT(ResponsibilityCenter."Sales Blanket Order Nos.");
                                "Document Type"::Order:
                                    EXIT(ResponsibilityCenter."Sales Order Nos.");
                                "Document Type"::"Return Order":
                                    EXIT(ResponsibilityCenter."Sales Return Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(ResponsibilityCenter."Sales Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(ResponsibilityCenter."Sales Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(ResponsibilityCenter."Sales Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(ResponsibilityCenter."Sales Posted Credit Memo Nos.");
                                "Document Type"::"Posted Shipment":
                                    EXIT(ResponsibilityCenter."Sales Posted Shipment Nos.");
                                "Document Type"::"Posted Return Receipt":
                                    EXIT(ResponsibilityCenter."Sales Ptd. Return Receipt Nos.");
                                "Document Type"::"Posted Debit Note":
                                    EXIT(ResponsibilityCenter."Sales Posted Debit Note Nos.");
                                "Document Type"::"Posted Prepmt. Inv.":
                                    EXIT(ResponsibilityCenter."Sales Posted Prepmt. Inv. Nos.");
                                "Document Type"::"Posted Prepmt. Cr. Memo":
                                    EXIT(ResponsibilityCenter."Sales Ptd. Prept. Cr. M. Nos.");

                            END;

                        END;
                    "Document Profile"::Service:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Booking:
                                    EXIT(ResponsibilityCenter."Serv. Booking Nos.");
                                "Document Type"::"Posted Order":
                                    EXIT(ResponsibilityCenter."Serv. Posted Order Nos.");
                                "Document Type"::Order:
                                    EXIT(ResponsibilityCenter."Serv. Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(ResponsibilityCenter."Serv. Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(ResponsibilityCenter."Serv. Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(ResponsibilityCenter."Serv. Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(ResponsibilityCenter."Serv. Posted Credit Memo Nos.");
                                "Document Type"::Quote:
                                    EXIT(ResponsibilityCenter."Serv. Quote Nos.");

                            END;
                        END;
                    "Document Profile"::Transfer:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Order:
                                    EXIT(ResponsibilityCenter."Trans. Order Nos.");
                                "Document Type"::"Posted Receipt":
                                    EXIT(ResponsibilityCenter."Posted Transfer Rcpt. Nos.");
                                "Document Type"::"Posted Shipment":
                                    EXIT(ResponsibilityCenter."Posted Transfer Shpt. Nos.");
                            END;
                        END;
                END;
            END;
        END
        ELSE BEGIN
            IF AccountabilityCenter.GET(UserSetup."Default Accountability Center") THEN BEGIN
                CASE "Document Profile" OF
                    "Document Profile"::Purchase:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    EXIT(AccountabilityCenter."Purch. Quote Nos.");
                                "Document Type"::"Blanket Order":
                                    EXIT(AccountabilityCenter."Purch. Blanket Order Nos.");
                                "Document Type"::Order:
                                    EXIT(AccountabilityCenter."Import Purch. Order Nos.");
                                "Document Type"::"Return Order":
                                    EXIT(AccountabilityCenter."Import Purch. Ret. Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(AccountabilityCenter."Import Purch. Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(AccountabilityCenter."Import Purch. Posted Inv Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(AccountabilityCenter."Import Purch. Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(AccountabilityCenter."Import Purch. Posted Cr.Nos.");
                                "Document Type"::"Posted Receipt":
                                    EXIT(AccountabilityCenter."Import Purch. Posted Rcpt Nos.");
                                "Document Type"::"Posted Return Shipment":
                                    EXIT(AccountabilityCenter."Import Posted Purch. Ret. Nos.");
                                "Document Type"::"Posted Prepmt. Inv.":
                                    EXIT(AccountabilityCenter."Purch. Posted Prept. Inv. Nos.");
                                "Document Type"::"Posted Prepmt. Cr. Memo":
                                    EXIT(AccountabilityCenter."Purch. Ptd. Prept. Cr. M. Nos.");

                            END;
                        END;
                    "Document Profile"::Sales:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Quote:
                                    EXIT(AccountabilityCenter."Sales Quote Nos.");
                                "Document Type"::"Blanket Order":
                                    EXIT(AccountabilityCenter."Sales Blanket Order Nos.");
                                "Document Type"::Order:
                                    EXIT(AccountabilityCenter."Sales Order Nos.");
                                "Document Type"::"Return Order":
                                    EXIT(AccountabilityCenter."Sales Return Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(AccountabilityCenter."Sales Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(AccountabilityCenter."Sales Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(AccountabilityCenter."Sales Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(AccountabilityCenter."Sales Posted Credit Memo Nos.");
                                "Document Type"::"Posted Shipment":
                                    EXIT(AccountabilityCenter."Sales Posted Shipment Nos.");
                                "Document Type"::"Posted Return Receipt":
                                    EXIT(AccountabilityCenter."Sales Ptd. Return Receipt Nos.");
                                "Document Type"::"Posted Debit Note":
                                    EXIT(AccountabilityCenter."Sales Posted Debit Note Nos.");
                                "Document Type"::"Posted Prepmt. Inv.":
                                    EXIT(AccountabilityCenter."Sales Posted Prepmt. Inv. Nos.");
                                "Document Type"::"Posted Prepmt. Cr. Memo":
                                    EXIT(AccountabilityCenter."Sales Ptd. Prept. Cr. M. Nos.");
                            END;

                        END;
                    "Document Profile"::Service:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Booking:
                                    EXIT(AccountabilityCenter."Serv. Booking Nos.");
                                "Document Type"::"Posted Order":
                                    EXIT(AccountabilityCenter."Serv. Posted Order Nos.");
                                "Document Type"::Order:
                                    EXIT(AccountabilityCenter."Serv. Order Nos.");
                                "Document Type"::Invoice:
                                    EXIT(AccountabilityCenter."Serv. Invoice Nos.");
                                "Document Type"::"Posted Invoice":
                                    EXIT(AccountabilityCenter."Serv. Posted Invoice Nos.");
                                "Document Type"::"Credit Memo":
                                    EXIT(AccountabilityCenter."Serv. Credit Memo Nos.");
                                "Document Type"::"Posted Credit Memo":
                                    EXIT(AccountabilityCenter."Serv. Posted Credit Memo Nos.");
                                "Document Type"::Quote:
                                    EXIT(AccountabilityCenter."Serv. Quote Nos.");

                            END;
                        END;
                    "Document Profile"::Transfer:
                        BEGIN
                            CASE "Document Type" OF
                                "Document Type"::Order:
                                    EXIT(AccountabilityCenter."Trans. Order Nos.");
                                "Document Type"::"Posted Receipt":
                                    EXIT(AccountabilityCenter."Posted Transfer Rcpt. Nos.");
                                "Document Type"::"Posted Shipment":
                                    EXIT(AccountabilityCenter."Posted Transfer Shpt. Nos.");
                            END;
                        END;
                END;
            END;

        END;
    end;

    [Scope('Internal')]
    procedure CheckReturnAmtQtyEditable(): Boolean
    begin
        GeneralLedgSetup.GET;
        EXIT(NOT GeneralLedgSetup."Exact Return Amount Mandatory");
    end;

    [Scope('Internal')]
    procedure CheckReturnAmtWithInvoiceDocument(TableID: Integer; DocumentNo: Code[20])
    var
        PurchHdr: Record "38";
        PurchLine: Record "39";
        PurchInvHdr: Record "122";
        ReturnErr: Label 'Amount %1 must be equal in invoice %2 and return order %3.';
        SalesHdr: Record "36";
        SalesLine: Record "37";
        SalesInvHdr: Record "112";
        ServiceHdr: Record "5900";
        ServiceLine: Record "5902";
        ServiceInvHdr: Record "5992";
        AmountIncVat: Decimal;
        SalesInvLine: Record "113";
        CustomerPostingGroup: Record "92";
        InvRoundAmt: Decimal;
        PurchInvline: Record "123";
    begin
        GeneralLedgSetup.GET;
        CASE TableID OF
            DATABASE::"Purchase Header":
                BEGIN
                    PurchHdr.RESET;
                    PurchHdr.SETRANGE("No.", DocumentNo);
                    IF PurchHdr.FINDFIRST THEN BEGIN
                        PurchLine.RESET;
                        PurchLine.SETRANGE("Document No.", PurchHdr."No.");
                        PurchLine.SETFILTER("Returned Document No.", '<>%1', '');
                        IF PurchLine.FINDFIRST THEN BEGIN
                            PurchInvHdr.RESET;
                            PurchInvHdr.SETRANGE("No.", PurchLine."Returned Document No.");
                            IF PurchInvHdr.FINDFIRST THEN BEGIN
                                PurchInvHdr.CALCFIELDS(Amount);
                                PurchInvHdr.CALCFIELDS("Amount Including VAT");
                                PurchHdr.CALCFIELDS(Amount);
                                PurchHdr.CALCFIELDS("Amount Including VAT");
                                IF (ABS(PurchInvHdr.Amount - PurchHdr.Amount) > GeneralLedgSetup."Return Tolerance") OR (ABS(PurchInvHdr."Amount Including VAT" - PurchHdr."Amount Including VAT") > GeneralLedgSetup."Return Tolerance") THEN
                                    ERROR(ReturnErr, PurchInvHdr."Amount Including VAT", PurchLine."Returned Document No.", PurchHdr."No.");
                            END;
                        END;
                    END;
                END;
            DATABASE::"Sales Header":
                BEGIN
                    SalesHdr.RESET;
                    SalesHdr.SETRANGE("No.", DocumentNo);
                    IF SalesHdr.FINDFIRST THEN BEGIN
                        SalesLine.RESET;
                        SalesLine.SETRANGE("Document No.", SalesHdr."No.");
                        SalesLine.SETFILTER("Returned Invoice No.", '<>%1', '');
                        IF SalesLine.FINDFIRST THEN BEGIN
                            SalesInvHdr.RESET;
                            SalesInvHdr.SETRANGE("No.", SalesLine."Returned Invoice No.");
                            IF SalesInvHdr.FINDFIRST THEN BEGIN
                                SalesHdr.CALCFIELDS(Amount);
                                SalesHdr.CALCFIELDS("Amount Including VAT");
                                SalesInvHdr.CALCFIELDS(Amount);
                                SalesInvHdr.CALCFIELDS("Amount Including VAT");
                                // MIN 10/31/19 >>
                                SalesSetup.GET;
                                IF SalesSetup."Invoice Rounding" THEN BEGIN
                                    Customer.RESET;
                                    Customer.SETRANGE("No.", SalesInvHdr."Sell-to Customer No.");
                                    IF Customer.FINDFIRST THEN BEGIN
                                        CustomerPostingGroup.RESET;
                                        CustomerPostingGroup.SETRANGE(Code, Customer."Customer Posting Group");
                                        IF CustomerPostingGroup.FINDFIRST THEN
                                            RoundUpGL := CustomerPostingGroup."Invoice Rounding Account";
                                    END;
                                    IF RoundUpGL <> '' THEN BEGIN

                                        SalesInvLine.RESET;
                                        SalesInvLine.SETRANGE("Document No.", SalesInvHdr."No.");
                                        SalesInvLine.SETRANGE("No.", RoundUpGL);
                                        IF SalesInvLine.FINDFIRST THEN;
                                        IF ((ABS(SalesInvHdr.Amount - SalesHdr.Amount) - ABS(SalesInvLine.Amount) > GeneralLedgSetup."Return Tolerance") OR
                                         (ABS(SalesInvHdr."Amount Including VAT" - SalesHdr."Amount Including VAT") - ABS(SalesInvLine."Amount Including VAT") > GeneralLedgSetup."Return Tolerance")) THEN
                                            ERROR(ReturnErr, SalesInvHdr."Amount Including VAT", SalesLine."Returned Invoice No.", SalesHdr."No.");
                                    END;
                                END ELSE BEGIN
                                    IF (ABS(SalesInvHdr.Amount - SalesHdr.Amount) > GeneralLedgSetup."Return Tolerance") OR (ABS(SalesInvHdr."Amount Including VAT" - SalesHdr."Amount Including VAT") > GeneralLedgSetup."Return Tolerance") THEN
                                        ERROR(ReturnErr, SalesInvHdr."Amount Including VAT", SalesLine."Returned Invoice No.", SalesHdr."No.");
                                END;


                                /*IF (ABS(SalesInvHdr.Amount - SalesHdr.Amount) > GeneralLedgSetup."Return Tolerance") OR (ABS(SalesInvHdr."Amount Including VAT" - SalesHdr."Amount Including VAT") > GeneralLedgSetup."Return Tolerance") THEN
                                  ERROR(ReturnErr,SalesInvHdr."Amount Including VAT",SalesLine."Returned Invoice No.",SalesHdr."No.");*/
                                //<< MIN 10/31/19
                            END;
                        END;
                    END;
                END;
        /*
         DATABASE::"Service Header" : BEGIN
          ServiceHdr.RESET;
          ServiceHdr.SETRANGE("No.",DocumentNo);
          IF ServiceHdr.FINDFIRST THEN BEGIN
            ServiceLine.RESET;
            ServiceLine.SETRANGE("Document No.",ServiceHdr."No.");
            IF ServiceLine.FINDFIRST THEN BEGIN
              AmountIncVat := 0;
              REPEAT
                AmountIncVat += ServiceLine."Amount Including VAT";
              UNTIL ServiceLine.NEXT = 0;
              ServiceInvHdr.RESET;
              ServiceInvHdr.SETRANGE("No.",ServiceLine."Returned Document No.");
              IF ServiceInvHdr.FINDFIRST THEN BEGIN
                ServiceInvHdr.CALCFIELDS("Amount Including VAT");
                IF ServiceInvHdr."Amount Including VAT" <> AmountIncVat THEN
                  ERROR(ReturnErr,ServiceInvHdr."Amount Including VAT",ServiceLine."Returned Document No.",AmountIncVat);
              END;
            END;
          END;
        END;
       */
        END;

    end;

    [Scope('Internal')]
    procedure CopyPurchInvHeaderToPurchLine(var FromPurchLine: Record "39"; PurchInvHeaderNo: Code[20])
    begin
        FromPurchLine."Returned Document No." := PurchInvHeaderNo;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnItemModify_DMS(var Rec: Record "27"; var xRec: Record "27"; RunTrigger: Boolean)
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Update Posting Groups" THEN BEGIN
            IF Rec."Gen. Prod. Posting Group" <> xRec."Gen. Prod. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Item, DATABASE::"Item Ledger Entry", Rec.FIELDNAME("Gen. Prod. Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."Inventory Posting Group" <> xRec."Inventory Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Item, DATABASE::"Item Ledger Entry", Rec.FIELDNAME("Inventory Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."VAT Prod. Posting Group" <> xRec."VAT Prod. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Item, DATABASE::"Item Ledger Entry", Rec.FIELDNAME("VAT Prod. Posting Group"), Rec."No.", Rec."No.");
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 23, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnVendorModify_DMS(var Rec: Record "23"; var xRec: Record "23"; RunTrigger: Boolean)
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Update Posting Groups" THEN BEGIN
            IF Rec."Gen. Bus. Posting Group" <> xRec."Gen. Bus. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Vendor, DATABASE::"Vendor Ledger Entry", Rec.FIELDNAME("Gen. Bus. Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."Vendor Posting Group" <> xRec."Vendor Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Vendor, DATABASE::"Vendor Ledger Entry", Rec.FIELDNAME("Vendor Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."VAT Bus. Posting Group" <> xRec."VAT Bus. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Vendor, DATABASE::"Vendor Ledger Entry", Rec.FIELDNAME("VAT Bus. Posting Group"), Rec."No.", Rec."No.");
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnCustomerModify_DMS(var Rec: Record "18"; var xRec: Record "18"; RunTrigger: Boolean)
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Update Posting Groups" THEN BEGIN
            IF Rec."Gen. Bus. Posting Group" <> xRec."Gen. Bus. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Customer, DATABASE::"Cust. Ledger Entry", Rec.FIELDNAME("Gen. Bus. Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."Customer Posting Group" <> xRec."Customer Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Customer, DATABASE::"Cust. Ledger Entry", Rec.FIELDNAME("Customer Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."VAT Bus. Posting Group" <> xRec."VAT Bus. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::Customer, DATABASE::"Cust. Ledger Entry", Rec.FIELDNAME("VAT Bus. Posting Group"), Rec."No.", Rec."No.");
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 5600, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnFixedAssetsModify_DMS(var Rec: Record "5600"; var xRec: Record "5600"; RunTrigger: Boolean)
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Update Posting Groups" THEN BEGIN
            IF Rec."FA Posting Group" <> xRec."FA Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::"Fixed Asset", DATABASE::"FA Ledger Entry", Rec.FIELDNAME("FA Posting Group"), Rec."No.", Rec."No.");
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 15, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnGLAccountModify_DMS(var Rec: Record "15"; var xRec: Record "15"; RunTrigger: Boolean)
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Update Posting Groups" THEN BEGIN
            IF Rec."Gen. Bus. Posting Group" <> xRec."Gen. Bus. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::"G/L Account", DATABASE::"G/L Entry", Rec.FIELDNAME("Gen. Bus. Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."Gen. Prod. Posting Group" <> xRec."Gen. Prod. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::"G/L Account", DATABASE::"G/L Entry", Rec.FIELDNAME("Gen. Prod. Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."VAT Bus. Posting Group" <> xRec."VAT Bus. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::"G/L Account", DATABASE::"G/L Entry", Rec.FIELDNAME("VAT Bus. Posting Group"), Rec."No.", Rec."No.");
            END;

            IF Rec."VAT Prod. Posting Group" <> xRec."VAT Prod. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::"G/L Account", DATABASE::"G/L Entry", Rec.FIELDNAME("VAT Prod. Posting Group"), Rec."No.", Rec."No.");
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 270, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnBankAccountModify_DMS(var Rec: Record "270"; var xRec: Record "270"; RunTrigger: Boolean)
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Update Posting Groups" THEN BEGIN
            IF Rec."Bank Acc. Posting Group" <> xRec."Bank Acc. Posting Group" THEN BEGIN
                TestLedgerEntryExist(DATABASE::"Bank Account", DATABASE::"Bank Account Ledger Entry", Rec.FIELDNAME("Bank Acc. Posting Group"), Rec."No.", Rec."No.");
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 14, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnLocationRename_DMS(var Rec: Record "14"; var xRec: Record "14"; RunTrigger: Boolean)
    begin
        IF Rec.Code <> xRec.Code THEN BEGIN
            TestLedgerEntryExist(DATABASE::Location, DATABASE::"Item Ledger Entry", Rec.FIELDNAME(Code), xRec.Code, Rec.Code);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 5813, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnInventoryPostingSetupModify_DMS(var Rec: Record "5813"; var xRec: Record "5813"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Inventory Posting Setup", DATABASE::"Value Entry", ChangeRecordTxt, Rec."Location Code", Rec."Invt. Posting Group Code");
    end;

    [EventSubscriber(ObjectType::Table, 5813, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnInventoryPostingSetupDelete_DMS(var Rec: Record "5813"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Inventory Posting Setup", DATABASE::"Value Entry", ChangeRecordTxt, Rec."Location Code", Rec."Invt. Posting Group Code");
    end;

    [EventSubscriber(ObjectType::Table, 5813, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnInventoryPostingSetupRename_DMS(var Rec: Record "5813"; var xRec: Record "5813"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Inventory Posting Setup", DATABASE::"Value Entry", ChangeRecordTxt, xRec."Location Code", xRec."Invt. Posting Group Code");
    end;

    [EventSubscriber(ObjectType::Table, 252, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnGenPostingSetupModify_DMS(var Rec: Record "252"; var xRec: Record "252"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"General Posting Setup", DATABASE::"Value Entry", ChangeRecordTxt, Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group");
    end;

    [EventSubscriber(ObjectType::Table, 252, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnGenPostingSetupDelete_DMS(var Rec: Record "252"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"General Posting Setup", DATABASE::"Value Entry", ChangeRecordTxt, Rec."Gen. Bus. Posting Group", Rec."Gen. Prod. Posting Group");
    end;

    [EventSubscriber(ObjectType::Table, 252, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnGenPostingSetupRename_DMS(var Rec: Record "252"; var xRec: Record "252"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"General Posting Setup", DATABASE::"Value Entry", ChangeRecordTxt, xRec."Gen. Bus. Posting Group", xRec."Gen. Prod. Posting Group");
    end;

    [EventSubscriber(ObjectType::Table, 325, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnVATPostingSetupModify_DMS(var Rec: Record "325"; var xRec: Record "325"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"VAT Posting Setup", DATABASE::"VAT Entry", ChangeRecordTxt, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
    end;

    [EventSubscriber(ObjectType::Table, 325, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnVATPostingSetupDelete_DMS(var Rec: Record "325"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"VAT Posting Setup", DATABASE::"VAT Entry", ChangeRecordTxt, Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group");
    end;

    [EventSubscriber(ObjectType::Table, 325, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnVATPostingSetupRename_DMS(var Rec: Record "325"; var xRec: Record "325"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"VAT Posting Setup", DATABASE::"VAT Entry", ChangeRecordTxt, xRec."VAT Bus. Posting Group", xRec."VAT Prod. Posting Group");
    end;

    [EventSubscriber(ObjectType::Table, 92, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnCustPostingGroupModify_DMS(var Rec: Record "92"; var xRec: Record "92"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Customer Posting Group", DATABASE::"Cust. Ledger Entry", ChangeRecordTxt, Rec.Code, Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 92, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnCustPostingGroupDelete_DMS(var Rec: Record "92"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Customer Posting Group", DATABASE::"Cust. Ledger Entry", ChangeRecordTxt, Rec.Code, Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 92, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnCustPostingGroupRename_DMS(var Rec: Record "92"; var xRec: Record "92"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Customer Posting Group", DATABASE::"Cust. Ledger Entry", ChangeRecordTxt, xRec.Code, xRec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 93, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnVendPostingGroupModify_DMS(var Rec: Record "93"; var xRec: Record "93"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Vendor Posting Group", DATABASE::"Vendor Ledger Entry", ChangeRecordTxt, Rec.Code, Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 93, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnVendPostingGroupDelete_DMS(var Rec: Record "93"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Vendor Posting Group", DATABASE::"Vendor Ledger Entry", ChangeRecordTxt, Rec.Code, Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 93, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnVendPostingGroupRename_DMS(var Rec: Record "93"; var xRec: Record "93"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Vendor Posting Group", DATABASE::"Vendor Ledger Entry", ChangeRecordTxt, xRec.Code, xRec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 277, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnBankPostingGroupModify_DMS(var Rec: Record "277"; var xRec: Record "277"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Bank Account Posting Group", DATABASE::"Bank Account Ledger Entry", ChangeRecordTxt, Rec.Code, Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 277, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBankPostingGroupDelete_DMS(var Rec: Record "277"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Bank Account Posting Group", DATABASE::"Bank Account Ledger Entry", ChangeRecordTxt, Rec.Code, Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 277, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnBankPostingGroupRename_DMS(var Rec: Record "277"; var xRec: Record "277"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"Bank Account Posting Group", DATABASE::"Bank Account Ledger Entry", ChangeRecordTxt, xRec.Code, xRec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 5606, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnFAPostingGroupModify_DMS(var Rec: Record "5606"; var xRec: Record "5606"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"FA Posting Group", DATABASE::"FA Ledger Entry", ChangeRecordTxt, Rec.Code, Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 5606, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnFAPostingGroupDelete_DMS(var Rec: Record "5606"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"FA Posting Group", DATABASE::"FA Ledger Entry", ChangeRecordTxt, Rec.Code, Rec.Code);
    end;

    [EventSubscriber(ObjectType::Table, 5606, 'OnBeforeRenameEvent', '', false, false)]
    local procedure OnFAPostingGroupRename_DMS(var Rec: Record "5606"; var xRec: Record "5606"; RunTrigger: Boolean)
    begin
        TestLedgerEntryExist(DATABASE::"FA Posting Group", DATABASE::"FA Ledger Entry", ChangeRecordTxt, xRec.Code, xRec.Code);
    end;

    [Scope('Internal')]
    procedure TestLedgerEntryExist(MasterTableID: Integer; LedgEntryTableID: Integer; CurrentFieldName: Text[250]; PrimaryKey1: Code[20]; PrimaryKey2: Code[20])
    var
        Item: Record "27";
        Vendor: Record "23";
        Customer: Record "18";
        FixedAsset: Record "5600";
        GLAccount: Record "15";
        BankAccount: Record "270";
        Resource: Record "156";
        Location: Record "14";
        InventoryPostingSetup: Record "5813";
        GenPostingSetup: Record "252";
        VATPostingSetup: Record "325";
        CustomerPostingGroup: Record "92";
        VendorPostingGroup: Record "93";
        BankAccountPostingGroup: Record "277";
        FAPostingGroup: Record "5606";
        ItemLedgEntry: Record "32";
        VendorLedgEntry: Record "25";
        CustomerLedgEntry: Record "21";
        FALedgEntry: Record "5601";
        GLEntry: Record "17";
        BankAccLedgEntry: Record "271";
        ResLedgEntry: Record "203";
        ValueEntry: Record "5802";
        VATEntry: Record "254";
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Update Posting Groups" THEN BEGIN
            CASE MasterTableID OF
                DATABASE::Item:
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Item Ledger Entry" THEN BEGIN
                            ItemLedgEntry.SETCURRENTKEY("Item No.");
                            ItemLedgEntry.SETRANGE("Item No.", PrimaryKey1);
                            IF NOT ItemLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, ItemLedgEntry.TABLECAPTION, Item.TABLECAPTION);
                        END;
                    END;
                DATABASE::Vendor:
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Vendor Ledger Entry" THEN BEGIN
                            VendorLedgEntry.SETCURRENTKEY("Vendor No.");
                            VendorLedgEntry.SETRANGE("Vendor No.", PrimaryKey1);
                            IF NOT VendorLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, VendorLedgEntry.TABLECAPTION, Vendor.TABLECAPTION);
                        END;
                    END;

                DATABASE::Customer:
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Cust. Ledger Entry" THEN BEGIN
                            CustomerLedgEntry.SETCURRENTKEY("Customer No.");
                            CustomerLedgEntry.SETRANGE("Customer No.", PrimaryKey1);
                            IF NOT CustomerLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, CustomerLedgEntry.TABLECAPTION, Customer.TABLECAPTION);
                        END;
                    END;

                DATABASE::"Fixed Asset":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"FA Ledger Entry" THEN BEGIN
                            FALedgEntry.SETCURRENTKEY("FA No.");
                            FALedgEntry.SETRANGE("FA No.", PrimaryKey1);
                            IF NOT FALedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, FALedgEntry.TABLECAPTION, FixedAsset.TABLECAPTION);
                        END;
                    END;
                DATABASE::"G/L Account":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"G/L Entry" THEN BEGIN
                            GLEntry.SETCURRENTKEY("G/L Account No.");
                            GLEntry.SETRANGE("G/L Account No.", PrimaryKey1);
                            IF NOT GLEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, GLEntry.TABLECAPTION, GLAccount.TABLECAPTION);
                        END;
                    END;
                DATABASE::"Bank Account":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Bank Account Ledger Entry" THEN BEGIN
                            BankAccLedgEntry.SETCURRENTKEY("Bank Account No.");
                            BankAccLedgEntry.SETRANGE("Bank Account No.", PrimaryKey1);
                            IF NOT BankAccLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, BankAccLedgEntry.TABLECAPTION, BankAccount.TABLECAPTION);
                        END;
                    END;
                DATABASE::Resource:
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Res. Ledger Entry" THEN BEGIN
                            ResLedgEntry.SETCURRENTKEY("Resource No.");
                            ResLedgEntry.SETRANGE("Resource No.", PrimaryKey1);
                            IF NOT ResLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, ResLedgEntry.TABLECAPTION, Resource.TABLECAPTION);
                        END;
                    END;
                DATABASE::Location:
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Item Ledger Entry" THEN BEGIN
                            ItemLedgEntry.SETCURRENTKEY("Location Code");
                            ItemLedgEntry.SETRANGE("Location Code", PrimaryKey1);
                            IF NOT ItemLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, ItemLedgEntry.TABLECAPTION, Location.TABLECAPTION);
                        END;
                    END;
                DATABASE::"Inventory Posting Setup":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Value Entry" THEN BEGIN
                            ValueEntry.SETCURRENTKEY("Location Code");
                            ValueEntry.SETRANGE("Location Code", PrimaryKey1);
                            ValueEntry.SETRANGE("Inventory Posting Group", PrimaryKey2);
                            IF NOT ValueEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, ValueEntry.TABLECAPTION, InventoryPostingSetup.TABLECAPTION);
                        END;
                    END;

                DATABASE::"General Posting Setup":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Value Entry" THEN BEGIN
                            ValueEntry.SETRANGE("Gen. Bus. Posting Group", PrimaryKey1);
                            ValueEntry.SETRANGE("Gen. Prod. Posting Group", PrimaryKey2);
                            IF NOT ValueEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, ValueEntry.TABLECAPTION, GenPostingSetup.TABLECAPTION);
                        END;
                    END;

                DATABASE::"VAT Posting Setup":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"VAT Entry" THEN BEGIN
                            VATEntry.SETRANGE("VAT Bus. Posting Group", PrimaryKey1);
                            VATEntry.SETRANGE("VAT Prod. Posting Group", PrimaryKey2);
                            IF NOT VATEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, VATEntry.TABLECAPTION, VATPostingSetup.TABLECAPTION);
                        END;
                    END;
                DATABASE::"Customer Posting Group":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Cust. Ledger Entry" THEN BEGIN
                            CustomerLedgEntry.SETRANGE("Customer Posting Group", PrimaryKey1);
                            IF NOT CustomerLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, CustomerLedgEntry.TABLECAPTION, CustomerPostingGroup.TABLECAPTION);
                        END;
                    END;
                DATABASE::"Vendor Posting Group":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Vendor Ledger Entry" THEN BEGIN
                            VendorLedgEntry.SETRANGE("Vendor Posting Group", PrimaryKey1);
                            IF NOT VendorLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, VendorLedgEntry.TABLECAPTION, VendorPostingGroup.TABLECAPTION);
                        END;
                    END;
                DATABASE::"Bank Account Posting Group":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"Bank Account Ledger Entry" THEN BEGIN
                            BankAccLedgEntry.SETRANGE("Bank Acc. Posting Group", PrimaryKey1);
                            IF NOT BankAccLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, BankAccLedgEntry.TABLECAPTION, BankAccountPostingGroup.TABLECAPTION);
                        END;
                    END;
                DATABASE::"FA Posting Group":
                    BEGIN
                        IF LedgEntryTableID = DATABASE::"FA Ledger Entry" THEN BEGIN
                            FALedgEntry.SETRANGE("FA Posting Group", PrimaryKey1);
                            IF NOT FALedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, FALedgEntry.TABLECAPTION, FAPostingGroup.TABLECAPTION);
                        END;
                    END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SetSyncStatus(var InvoiceMaterializeView: Record "33020293")
    var
        CBMSMgt: Codeunit "33020513";
        ReturnedDocNo: Code[20];
    begin
        IF CBMSMgt.Enabled THEN BEGIN
            IF InvoiceMaterializeView."Document Type" = InvoiceMaterializeView."Document Type"::"Sales Credit Memo" THEN BEGIN
                IF CBMSMgt.RealTimeEnabled THEN
                    InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::"Sync In Progress"
                ELSE
                    InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::Pending;
            END
            ELSE
                IF InvoiceMaterializeView."Document Type" = InvoiceMaterializeView."Document Type"::"Sales Invoice" THEN BEGIN
                    IF CBMSMgt.RealTimeEnabled THEN
                        InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::"Sync In Progress"
                    ELSE
                        InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::Pending;
                END;
        END
        ELSE BEGIN
            InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::"Not Valid";
        END;
    end;

    [Scope('Internal')]
    procedure OnAfterCopyTransferHeaderToTransShptHeader(TransferHdr: Record "5740"; var TransferShptHdr: Record "5744")
    begin
        TransferShptHdr."Shipped By User" := USERID;
        TransferShptHdr."User ID" := TransferHdr."Assigned User ID";
    end;

    [Scope('Internal')]
    procedure OnAfterCopyTransferHeaderToTransRcptHeader(TransferHdr: Record "5740"; var TransRcptHdr: Record "5746")
    begin
        TransRcptHdr."Received By User" := USERID;
        TransRcptHdr."User ID" := TransferHdr."Assigned User ID";
    end;

    [Scope('Internal')]
    procedure InsertSMSDetail(MessageType: Option Bill,Job,Birthday,"Service Reminder","Revised Job",KAM,"Service Booking","Service Booking Reminder","Credit Bill","Credit Bill Due Date Reminder","Credit Bill Due Date Crossed Reminder","EMI Due Reminder","Credit Bill Follow up","Apporximate Estimate"; DocumentNo: Code[20]; MobileNumber: Text; TextMessage: Text)
    var
        SMSTemplate: Record "33020257";
        SMSDetails: Record "33020258";
        EntryNo: Integer;
        SMSWebService: Codeunit "50002";
        MessageID: Text[250];
    begin
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
        SMSDetails.INSERT;

        IF SMSWebService.SendSMS(MobileNumber, TextMessage, MessageID) THEN BEGIN
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
    procedure UpdateInvoiceRoundingLineInReturnOrder(SalesHdr: Record "36")
    var
        SalesInvLine: Record "113";
        SalesLine: Record "37";
        ReturnedDocNo: Code[20];
        LineNo: Integer;
    begin
        CLEAR(ReturnedDocNo);
        CLEAR(LineNo);
        IF NOT (SalesHdr."Document Type" IN [SalesHdr."Document Type"::"Credit Memo", SalesHdr."Document Type"::"Return Order"]) THEN
            EXIT;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document No.", SalesHdr."No.");
        SalesLine.SETFILTER("Returned Invoice No.", '<>%1', '');
        IF SalesLine.FINDFIRST THEN
            ReturnedDocNo := SalesLine."Returned Invoice No.";

        SalesInvLine.RESET;
        SalesInvLine.SETRANGE("Document No.", ReturnedDocNo);
        SalesInvLine.SETFILTER(Description, 'Invoice Rounding');
        IF SalesInvLine.FINDFIRST THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document No.", SalesHdr."No.");
            IF SalesLine.FINDLAST THEN
                LineNo := SalesLine."Line No." + 1000;


            SalesLine.RESET;
            SalesLine.SETRANGE("Document No.", SalesHdr."No.");
            SalesLine.SETFILTER(Description, 'Invoice Rounding');
            IF NOT SalesLine.FINDFIRST THEN BEGIN
                SalesLine.INIT;
                SalesLine.TRANSFERFIELDS(SalesInvLine);
                SalesLine."Document No." := SalesHdr."No.";
                SalesLine."Document Type" := SalesHdr."Document Type";
                SalesLine."Line No." := LineNo;
                SalesLine."Returned Invoice No." := ReturnedDocNo;
                SalesLine.INSERT(TRUE);
            END ELSE
                EXIT;
        END;
    end;

    [Scope('Internal')]
    procedure GetVehicleInsuranceDetails(VehSerialNo: Code[20]; InsuranceActivity_: Option "New Policy","Body Addition","Value Addition",Renewal,Cancellation,Passenger; var VehicleInsurance: Record "25006033"): Boolean
    begin
        VehicleInsurance.RESET;
        VehicleInsurance.SETRANGE("Vehicle Serial No.", VehSerialNo);
        IF InsuranceActivity_ = InsuranceActivity_::"New Policy" THEN
            VehicleInsurance.SETFILTER("Insurance Activity", '%1|%2', VehicleInsurance."Insurance Activity"::"New Policy", VehicleInsurance."Insurance Activity"::Renewal)
        ELSE
            VehicleInsurance.SETRANGE("Insurance Activity", InsuranceActivity_);

        VehicleInsurance.SETRANGE(Cancelled, FALSE);
        //VehicleInsurance.SETFILTER(VehicleInsurance."Ending Date",'>=%1',TODAY);
        IF VehicleInsurance.FINDLAST THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure LookupVehicleInsurance(VehSerialNo: Code[20]; InsuranceActivity_: Option "New Policy","Body Addition","Value Addition",Renewal,Cancellation,Passenger)
    var
        VehicleInsurance: Record "25006033";
    begin
        VehicleInsurance.RESET;
        VehicleInsurance.SETRANGE("Vehicle Serial No.", VehSerialNo);
        IF InsuranceActivity_ = InsuranceActivity_::"New Policy" THEN
            VehicleInsurance.SETFILTER("Insurance Activity", '%1|%2', VehicleInsurance."Insurance Activity"::"New Policy", VehicleInsurance."Insurance Activity"::Renewal)
        ELSE
            VehicleInsurance.SETRANGE("Insurance Activity", InsuranceActivity_);

        VehicleInsurance.SETRANGE(Cancelled, FALSE);
        //VehicleInsurance.SETFILTER(VehicleInsurance."Ending Date",'>=%1',TODAY);
        IF VehicleInsurance.FINDLAST THEN
            PAGE.RUN(PAGE::"Vehicle Insurance", VehicleInsurance)
    end;

    [Scope('Internal')]
    procedure InserRescheduleSMS(DocumentProfile: Option " ","Spare Parts Trade","Vehicles Trade",Service,"Battery Sales"; "Code": Code[20]; MessageType: Option Bill,Job,Birthday,"Service Reminder","Revised Job",KAM,"Service Booking","Service Booking Reminder","Credit Bill","Credit Bill Due Date Reminder","Credit Bill Due Date Crossed Reminder","EMI Due Reminder","Credit Bill Follow up","IT Alert",Anniversary,"Employee Birthday","Battery Recharge","Battery Replace","Battery Others","Reschedule VF"; MobileNo: Code[50]; CompanyName: Text[100]; TextField1: Text[100]; TextField2: Text[250]; RescheduleDate: Date; Amount: Decimal; Percent: Decimal)
    var
        SMSTemplates: Record "33020257";
        SMSDetails: Record "33020258";
        SMSDetailsRec: Record "33020258";
        Contact: Record "5050";
        Text000: Label 'There is no SMS Templates for Document Profile %1 and Message Type %2.';
        MessageText: Text[250];
        InsertRecord: Boolean;
    begin
        IF NOT SendSMS THEN
            EXIT;
        IF (MobileNo <> '') AND (STRLEN(MobileNo) < 20) THEN BEGIN

            SMSTemplates.RESET;
            SMSTemplates.CHANGECOMPANY(CompanyName); //ZM Sep 27, 2016
            SMSTemplates.SETRANGE("Document Profile", DocumentProfile);
            IF MessageType = 20 THEN
                SMSTemplates.SETRANGE(Type, SMSTemplates.Type::"Reschedule EMI");
            IF MessageType = 21 THEN
                SMSTemplates.SETRANGE(Type, SMSTemplates.Type::"Reschedule Tenure");

            IF SMSTemplates.FINDSET THEN
                REPEAT
                    IF (STRLEN(SMSDetails."Message Text") + STRLEN(SMSTemplates."Message Text")) <= 250 THEN
                        MessageText += SMSTemplates."Message Text";
                    IF MessageType = 20 THEN
                        MessageText := COPYSTR(STRSUBSTNO(MessageText, TextField2, Percent, RescheduleDate, ROUND(Amount, 0.01, '=')), 1, 250);
                    IF MessageType = 21 THEN
                        MessageText := COPYSTR(STRSUBSTNO(MessageText, TextField2, Percent, RescheduleDate, Amount), 1, 250);

                UNTIL SMSTemplates.NEXT = 0;

            IF (MessageText <> '') AND (STRLEN(MessageText) <= 250) THEN BEGIN
                CLEAR(SMSDetails);
                SMSDetails.LOCKTABLE;
                SMSDetails.CHANGECOMPANY('Sipradi Trading Pvt. Ltd.');
                IF SMSDetails.FINDLAST THEN
                    SMSDetails."Entry No." += 1
                ELSE
                    SMSDetails."Entry No." := 1;
                SMSDetails.LOCKTABLE;
                SMSDetails.INIT;
                SMSDetails."Message Text" := MessageText;
                SMSDetails."Mobile Number" := MobileNo;
                SMSDetails."Creation Date" := CURRENTDATETIME;
                SMSDetails."Message Type" := SMSTemplates.Type;
                SMSDetails.Status := SMSDetails.Status::New;
                SMSDetails."Last Modified Date" := CURRENTDATETIME;
                SMSDetails.Company := CompanyName;
                //SMSDetails.Amount := Amount;
                SMSDetails."Location Code" := TextField1;
                SMSDetails."Document No." := Code;
                SMSDetails.Scheduled := TRUE;
                //SMSDetails.INSERT;
                SMSDetails.INSERT(TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SendSMS(): Boolean
    var
        SalesSetup: Record "311";
    begin
        IF ChangeCompanyRecord THEN BEGIN
            SalesSetup.CHANGECOMPANY(NewCompanyName);
        END;

        SalesSetup.GET;
        EXIT(SalesSetup."Activate SMS System");
    end;

    [Scope('Internal')]
    procedure insertPurchaseOrderFromProcument(Procument: Record "130415")
    var
        PurchaseHeader: Record "38";
        Vend: Record "130416";
    begin
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE("Procument Memo No.", "Memo No.");
        IF PurchaseHeader.FINDFIRST THEN
            PAGE.RUN(PAGE::"Purchase Order", PurchaseHeader)
        ELSE BEGIN
            PurchaseHeader.INIT;
            PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Order);
            PurchaseHeader.INSERT(TRUE);
            PurchaseHeader."Procument Memo No." := "Memo No.";
            Vend.RESET;
            Vend.SETRANGE("Memo No.", "Memo No.");
            Vend.SETRANGE(Selected, TRUE);
            IF Vend.FINDFIRST THEN
                PurchaseHeader.VALIDATE("Buy-from Vendor No.", Vend."Vendor Code");
            PurchaseHeader.VALIDATE("Posting Date", TODAY);
            PurchaseHeader.MODIFY;
            PAGE.RUN(PAGE::"Purchase Order", PurchaseHeader);
        END;
    end;

    [Scope('Internal')]
    procedure insertIntoServiceLedger(Vehi: Record "25006005"; KM: Decimal)
    var
        ServLedgEntry: Record "25006167";
    begin
        IF KM = 0 THEN
            ERROR('KM must have value');
        ServLedgEntry.INIT;
        IF ServLedgEntry.FINDLAST THEN
            ServLedgEntry."Entry No." += 1
        ELSE
            ServLedgEntry."Entry No." := 1;
        ServLedgEntry."Entry Type" := ServLedgEntry."Entry Type"::Usage;
        ServLedgEntry."For Km" := TRUE;
        ServLedgEntry."Vehicle Serial No." := Vehi."Serial No.";
        ServLedgEntry.VIN := Vehi.VIN;
        ServLedgEntry."Make Code" := Vehi."Make Code";
        ServLedgEntry."Model Code" := Vehi."Model Code";
        ServLedgEntry."Model Version No." := Vehi."Model Version No.";
        ServLedgEntry."Posting Date" := TODAY;
        ServLedgEntry.Kilometrage := KM;
        ServLedgEntry.Description := 'To decrease KM';
        ServLedgEntry."Document No." := '';
        ServLedgEntry."Payment Method Code" := '';
        ServLedgEntry.Amount := 0;
        ServLedgEntry."Amount (LCY)" := 0;
        ServLedgEntry."Amount Including VAT" := 0;
        ServLedgEntry."Unit Price" := 0;
        ServLedgEntry."Unit Cost" := 0;
        ServLedgEntry.Quantity := 0;
        ServLedgEntry.INSERT;

        Vehi."Previous KM" := Vehi.Kilometrage;
        Vehi.Kilometrage := KM;
        Vehi."Updated By" := USERID;
        Vehi.MODIFY;
    end;

    [Scope('Internal')]
    procedure isBAW(): Boolean
    var
        CompInfo: Record "79";
    begin
        CompInfo.GET;
        EXIT(CompInfo."Balaju Auto Works");
    end;

    [Scope('Internal')]
    procedure SendEmailForRejectApplicant(EmailAddress: Text[100])
    var
        SenderName: Text[90];
        SenderAddress: Text[30];
        Dear: Text[50];
        Subject: Text[100];
        MessageText: Text[700];
        EmailBody: Text[1024];
        SmtpMail: Codeunit "400";
        SMTP: Record "409";
        EmailTemp: Record "25006294";
        EmailMsg: Record "25006293";
        MsgText: Text;
    begin
        /*CLEAR(MsgText);
        SMTP.GET;
        MsgText := 'You are Rejected';
        SenderAddress := SMTP."User ID";
        SenderName := '';
        Dear := 'Dear Sir/Madam,';
        Subject := 'Application Rejected';
        
        EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:16px">';
        EmailBody := EmailBody + Dear +'<br><br>';
        EmailBody := EmailBody + MsgText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
               + SenderName;
        SmtpMail.CreateMessage(SenderName,SenderAddress,EmailAddress,Subject,EmailBody,TRUE);
        SmtpMail.Send();
        */

    end;

    [Scope('Internal')]
    procedure SendEmailForShortlistApplicant(EmailAddress: Text[100])
    var
        SenderName: Text[90];
        SenderAddress: Text[30];
        Dear: Text[50];
        Subject: Text[100];
        MessageText: Text[700];
        EmailBody: Text[1024];
        SmtpMail: Codeunit "400";
        SMTP: Record "409";
        EmailTemp: Record "25006294";
        EmailMsg: Record "25006293";
        MsgText: Text;
    begin
        /*CLEAR(MsgText);
        SMTP.GET;
        MsgText := 'You are ShortListed';
        SenderAddress := SMTP."User ID";
        SenderName := '';
        Dear := 'Dear Sir/Madam,';
        Subject := 'Application ShortListed';
        
        EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:16px">';
        EmailBody := EmailBody + Dear +'<br><br>';
        EmailBody := EmailBody + MsgText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
               + SenderName;
        SmtpMail.CreateMessage(SenderName,SenderAddress,EmailAddress,Subject,EmailBody,TRUE);
        SmtpMail.Send();
        */

    end;

    [Scope('Internal')]
    procedure CreateFALogEntry(FANo: Code[20]; TravelDate: Date; EmployeeNo: Code[20]; TravelTime: Time; OdometerOpening: Decimal; TravelType: Option; FromDes: Text[70]; ToDes: Text[70]; DriverName: Text[70]; TotalTripDis: Decimal; FuelQuantity: Decimal; MemoNo: Code[20]; MaintainanceCost: Decimal; GatePassNo: Code[20]; Purpose: Text[250])
    var
        FALogEntry: Record "33020799";
        EntryNo: Integer;
        Usersetup: Record "91";
        Employee: Record "5200";
    begin
        FALogEntry.RESET;
        FALogEntry.LOCKTABLE;
        IF FALogEntry.FINDLAST THEN;
        EntryNo := FALogEntry."Entry No.";
        EntryNo := EntryNo + 1;

        FALogEntry.INIT;
        FALogEntry."Entry No." := EntryNo;
        FALogEntry."Fixed Asset No." := FANo;
        FALogEntry."Travel Date" := TravelDate;
        FALogEntry."Travel Time" := TravelTime;
        FALogEntry."Travel Type" := TravelType;
        FALogEntry."Employee No" := EmployeeNo;
        IF Employee.GET(EmployeeNo) THEN
            FALogEntry."Request by Employee Name" := Employee."Full Name";
        FALogEntry."From Destination" := FromDes;
        FALogEntry."To Destination" := ToDes;
        FALogEntry.Purpose := Purpose;
        FALogEntry."Driver Name" := DriverName;
        FALogEntry."Total Trip Distance" := TotalTripDis;
        FALogEntry."Fuel Quantity" := FuelQuantity;
        FALogEntry."Gatepass No." := GatePassNo;
        FALogEntry."Memo No." := MemoNo;
        FALogEntry."Odometer Opening" := OdometerOpening;
        FALogEntry."Maitainance Cost" := MaintainanceCost;
        IF Usersetup.GET(USERID) THEN
            FALogEntry."Enter by User Name" := Usersetup."User ID";

        FALogEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure CreateGatePass(DocumentType: Option " ",Admin,"Spare Parts Trade","Vehicle Trade","Vehicle Service"; ExtDocType: Option " ","FA Transfer",Repair,"Transfer Order",Invoice,"Trail/Demo","Closed Job","Vehicle Trial"; ExtDocNo: Code[20]; SellTocust: Text[100]; BillToCust: Text[100])
    var
        GatepassHeader: Record "50004";
        GatepassLine: Record "50005";
        GatepassPage: Page "50002";
        Text000: Label 'Document cannot be identified for gatepass. Please issue Gatepass Manually.';
        ServHdrEDMS: Record "25006145";
        ServiceArc: Record "25006169";
    begin
        GatepassHeader.RESET;
        GatepassHeader.SETCURRENTKEY("External Document No.");
        GatepassHeader.SETRANGE("External Document No.", ExtDocNo);
        GatepassHeader.SETRANGE("External Document Type", ExtDocType);
        IF NOT GatepassHeader.FINDFIRST THEN BEGIN
            GatepassHeader.INIT;
            GatepassHeader."Document Type" := DocumentType;
            GatepassHeader."External Document Type" := ExtDocType;
            GatepassHeader."External Document No." := ExtDocNo;
            GatepassHeader.Person := SellTocust;
            GatepassHeader.Owner := BillToCust;
            ServHdrEDMS.RESET;
            ServHdrEDMS.SETRANGE("No.", ExtDocNo);
            IF ServHdrEDMS.FINDFIRST THEN BEGIN
                GatepassHeader."Vehicle Registration No." := ServHdrEDMS."Vehicle Registration No.";
                GatepassHeader.Kilometer := ServHdrEDMS.Kilometrage;
            END ELSE BEGIN
                ServiceArc.RESET;
                ServiceArc.SETRANGE("No.", GatepassHeader."External Document No.");
                IF ServiceArc.FINDFIRST THEN BEGIN
                    GatepassHeader."Vehicle Registration No." := ServiceArc."Vehicle Registration No.";
                    GatepassHeader.Kilometer := ServiceArc.Kilometrage;
                END
            END;
            GatepassHeader.Destination := 'Out';
            GatepassHeader.VALIDATE("Issued Date", TODAY);
            GatepassHeader.INSERT(TRUE);
        END;
        GatepassPage.SETRECORD(GatepassHeader);
        GatepassPage.RUN;
    end;

    [Scope('Internal')]
    procedure CheckPipelineCust(CustNo: Code[20]): Boolean
    var
        Customer: Record "18";
    begin
        IF Customer.GET(CustNo) THEN
            IF Customer."Skip PipeLine" THEN
                EXIT(FALSE);
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure getLocWiseNoSeriesForDocFromDealer("Document Profile": Option Purchase,Sales,Service,Transfer; "Document Type": Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note"; LocationCode: Code[10]): Code[10]
    var
        Location: Record "14";
        UserSetup: Record "91";
        GLSetup: Record "98";
    begin
        IF AccountabilityCenter.GET(LocationCode) THEN BEGIN
            CASE "Document Profile" OF
                "Document Profile"::Sales:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                EXIT(AccountabilityCenter."Sales Quote Nos.");
                            "Document Type"::"Blanket Order":
                                EXIT(AccountabilityCenter."Sales Blanket Order Nos.");
                            "Document Type"::Order:
                                EXIT(AccountabilityCenter."Sales Order Nos.");
                            "Document Type"::"Return Order":
                                EXIT(AccountabilityCenter."Sales Return Order Nos.");
                            "Document Type"::Invoice:
                                EXIT(AccountabilityCenter."Sales Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                EXIT(AccountabilityCenter."Sales Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                EXIT(AccountabilityCenter."Sales Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                EXIT(AccountabilityCenter."Sales Posted Credit Memo Nos.");
                            "Document Type"::"Posted Shipment":
                                EXIT(AccountabilityCenter."Sales Posted Shipment Nos.");
                            "Document Type"::"Posted Return Receipt":
                                EXIT(AccountabilityCenter."Sales Ptd. Return Receipt Nos.");
                            "Document Type"::"Posted Debit Note":
                                EXIT(AccountabilityCenter."Sales Posted Debit Note Nos.");
                            "Document Type"::"Posted Prepmt. Inv.":
                                EXIT(AccountabilityCenter."Sales Posted Prepmt. Inv. Nos.");
                            "Document Type"::"Posted Prepmt. Cr. Memo":
                                EXIT(AccountabilityCenter."Sales Ptd. Prept. Cr. M. Nos.");
                        END;

                    END;
                "Document Profile"::Service:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Booking:
                                EXIT(AccountabilityCenter."Serv. Booking Nos.");
                            "Document Type"::"Posted Order":
                                EXIT(AccountabilityCenter."Serv. Posted Order Nos.");
                            "Document Type"::Order:
                                EXIT(AccountabilityCenter."Serv. Order Nos.");
                            "Document Type"::Invoice:
                                EXIT(AccountabilityCenter."Serv. Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                EXIT(AccountabilityCenter."Serv. Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                EXIT(AccountabilityCenter."Serv. Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                EXIT(AccountabilityCenter."Serv. Posted Credit Memo Nos.");
                            "Document Type"::Quote:
                                EXIT(AccountabilityCenter."Serv. Quote Nos.");

                        END;
                    END;
                "Document Profile"::Transfer:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Order:
                                EXIT(AccountabilityCenter."Trans. Order Nos.");
                            "Document Type"::"Posted Receipt":
                                EXIT(AccountabilityCenter."Posted Transfer Rcpt. Nos.");
                            "Document Type"::"Posted Shipment":
                                EXIT(AccountabilityCenter."Posted Transfer Shpt. Nos.");
                        END;
                    END;
            END;
        END;
    end;
}

