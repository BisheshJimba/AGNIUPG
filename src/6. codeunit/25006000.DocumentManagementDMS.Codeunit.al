codeunit 25006000 DocumentManagementDMS
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified GetDefaultItemFlow(), Usert Profile Setup to Branch Profile Setup
    // 
    // 24.08.2014 EDMS P7
    //   * Added function IsWebClientSession
    // 
    // 26.06.2013 EDMS P8
    //   * Added function WriteBigTextToFile
    // 
    // 10.01.2008. EDMS P2
    //   * Added functions:
    //               ServiceSplitLine
    //               ServiceCopyDimensions
    //               ServiceGetNewLineNo
    // 
    // 04.10.2007. EDMS P2
    //   * Addded function ShowVehicleComment
    // 
    // 31.08.2007. EDMS P2
    //   * Added code in function "fSL_SetType_LineType(VAR recSalesLine : Record "Sales Line")"
    // 
    // 27.08.2007. EDMS P2
    //   * Added functions
    //      SelectSalesInvDocReport
    //      SelectShipmentDocReport
    //      SelectCrMemoDocReport
    //      SelectReturnReceiptDocReport
    //      SelectPurchHdrDocReport
    //      SelectTransferDocReport
    //      SelectPurchInvDocReport
    //      SelectRetShipmentDocReport
    //      SelectPurchCrMemoDocReport
    //      SelectPurchRcptDocReport
    //      SelectPostServDocReport
    //      SelectPostServRetDocReport
    //      SelectExportSalesHdr
    //      SelectExportSalesInvHdr
    //      SelectImportPurchHdr
    //      fPrintCurrentDoc
    //      ChooseExcelReport
    // 
    // 27.07.2007. EDMS P2
    //   * Added function ShowCustomerComments

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        bDocItemStatFrmOpen: Boolean;
        cuSingleInstanceMgt: Codeunit "25006001";
        cuWorkplaceMgt: Codeunit "25006002";
        recWorkplace: Record "25006067";
        EDMS001: Label 'Customer %1 comment lines: %2';
        EDMS002: Label 'Vehicle %1 comment lines: %2';
        Text004: Label 'The parameter %1 is out of the valid range.\';
        Text008: Label '<Color>';
        Text009: Label 'Valid range: 0..16777215';
        ServiceScheduleMgt: Codeunit "25006201";
        UserSetup: Record "91";
        ServerSaveAsPdfFailedErr: Label 'Cannot open the document because it is empty or cannot be created.';
        DocumentMailing: Codeunit "260";
        Text010: Label 'Service Order';
        Text011: Label 'Sales %1';
        ReportAsPdfFileNameMsg: Label 'Purchase %1 %2.pdf', Comment = '%1 = Document Type %2 = Invoice No.';
        Text012: Label 'Purchase %1';
        EmailSubjectCapTxt: Label '%1 - %2 %3', Comment = '%1 = Vendor Name. %2 = Document Type %3 = Document No.';

    [Scope('Internal')]
    procedure GetDMSVersion(): Text[80]
    var
        "Object": Record "2000000001";
    begin
        EXIT('Elva DMS Add-On version 10.00.04');
    end;

    [EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterGetApplicationVersion', '', false, false)]
    local procedure AddDMSVersionOnAfterGetApplicationVersion(var AppVersion: Text[80])
    begin
        AppVersion += '; ' + GetDMSVersion;
    end;

    [Scope('Internal')]
    procedure DocSetItemStatFrmOpen(bNewValue: Boolean)
    begin
        bDocItemStatFrmOpen := bNewValue;
    end;

    [Scope('Internal')]
    procedure DocGetItemStatFrmOpen(): Boolean
    begin
        EXIT(bDocItemStatFrmOpen);
    end;

    [Scope('Internal')]
    procedure SL_SetType_LineType(var recSalesLine: Record "37")
    begin
        CASE "Line Type" OF
            "Line Type"::" ":
                BEGIN
                    recSalesLine.VALIDATE(Type, recSalesLine.Type::" ");
                END;
            "Line Type"::"G/L Account":
                BEGIN
                    recSalesLine.VALIDATE(Type, recSalesLine.Type::"G/L Account");
                END;
            "Line Type"::Item:
                BEGIN
                    recSalesLine.VALIDATE(Type, recSalesLine.Type::Item);
                END;
            "Line Type"::Labor:
                BEGIN
                    recSalesLine.VALIDATE(Type, recSalesLine.Type::"G/L Account");
                END;
            "Line Type"::"Ext. Service":
                BEGIN
                    recSalesLine.VALIDATE(Type, recSalesLine.Type::"G/L Account");
                END;
            "Line Type"::Vehicle:
                BEGIN
                    recSalesLine.VALIDATE(Type, recSalesLine.Type::Item);
                END;
            "Line Type"::"Charge (Item)":
                BEGIN
                    recSalesLine.VALIDATE(Type, recSalesLine.Type::"Charge (Item)");
                END;
            //31.08.2007. EDMS P2 >>
            "Line Type"::"Fixed Asset":
                BEGIN
                    recSalesLine.VALIDATE(Type, recSalesLine.Type::"Fixed Asset");
                END;
        //31.08.2007. EDMS P2 <<

        END;
    end;

    [Scope('Internal')]
    procedure PL_SetType_LineType(var recPurchLine: Record "39")
    begin
        CASE "Line Type" OF
            "Line Type"::" ":
                BEGIN
                    recPurchLine.VALIDATE(Type, recPurchLine.Type::" ");
                END;
            "Line Type"::Vehicle:
                BEGIN
                    recPurchLine.VALIDATE(Type, recPurchLine.Type::Item);
                END;
            "Line Type"::"2":
                BEGIN
                    recPurchLine.VALIDATE(Type, recPurchLine.Type::Item);
                END;
            "Line Type"::Item:
                BEGIN
                    recPurchLine.VALIDATE(Type, recPurchLine.Type::Item);
                END;
            "Line Type"::"Charge (Item)":
                BEGIN
                    recPurchLine.VALIDATE(Type, recPurchLine.Type::"Charge (Item)");
                END;
            "Line Type"::"G/L Account":
                BEGIN
                    recPurchLine.VALIDATE(Type, recPurchLine.Type::"G/L Account");
                END;
        END;
    end;

    [Scope('Internal')]
    procedure GetDefaultItemFlow(): Code[10]
    var
        codWorkplaceCode: Code[10];
    begin
        codWorkplaceCode := cuWorkplaceMgt.CurrProfileID;
        IF codWorkplaceCode <> '' THEN BEGIN
            CLEAR(recWorkplace);
            IF recWorkplace.GET(codWorkplaceCode) THEN BEGIN
                EXIT(recWorkplace."Default Deal Type Code");
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SelectSalesDocReport(var recRepSelect: Record "25006011"; recSalesHeader: Record "36"; var SalesLine: Record "37"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        recSalesHeader.SETRANGE("Document Type", recSalesHeader."Document Type");
        recSalesHeader.SETRANGE("No.", recSalesHeader."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN BEGIN
                IF recRepSelect."Take From Lines" THEN BEGIN
                    IF SendAsEmail THEN
                        EmailSalesLineDocument(SalesLine, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, SalesLine);
                END ELSE BEGIN
                    IF SendAsEmail THEN
                        EmailSalesHeaderDocument(recSalesHeader, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, recSalesHeader);
                END;
            END;
        END ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                IF recRepSelect."Take From Lines" THEN BEGIN
                    IF SendAsEmail THEN
                        EmailSalesLineDocument(SalesLine, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, SalesLine);
                END ELSE BEGIN
                    IF SendAsEmail THEN
                        EmailSalesHeaderDocument(recSalesHeader, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, recSalesHeader);
                END;
            END;
    end;

    [Scope('Internal')]
    procedure SelectSalesInvDocReport(var recRepSelect: Record "25006011"; recSalesInvHeader: Record "112")
    var
        intCount: Integer;
    begin
        recSalesInvHeader.SETRANGE("No.", recSalesInvHeader."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, recSalesInvHeader);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, recSalesInvHeader);
            END;
    end;

    [Scope('Internal')]
    procedure SelectShipmentDocReport(var recRepSelect: Record "25006011"; SalesShipmentHdr: Record "110")
    var
        intCount: Integer;
    begin
        SalesShipmentHdr.SETRANGE("No.", SalesShipmentHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, SalesShipmentHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, SalesShipmentHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectCrMemoDocReport(var recRepSelect: Record "25006011"; SalesCrMemoHdr: Record "114")
    var
        intCount: Integer;
    begin
        SalesCrMemoHdr.SETRANGE("No.", SalesCrMemoHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, SalesCrMemoHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, SalesCrMemoHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectReturnReceiptDocReport(var recRepSelect: Record "25006011"; ReturnReceiptHdr: Record "6660")
    var
        intCount: Integer;
    begin
        ReturnReceiptHdr.SETRANGE("No.", ReturnReceiptHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, ReturnReceiptHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, ReturnReceiptHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectPurchHdrDocReport(var recRepSelect: Record "25006011"; PurchHdr: Record "38"; var PurchLine: Record "39"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        PurchHdr.SETRANGE("Document Type", PurchHdr."Document Type");
        PurchHdr.SETRANGE("No.", PurchHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN BEGIN
                IF recRepSelect."Take From Lines" THEN BEGIN
                    IF SendAsEmail THEN
                        EmailPurchaseLineDocument(PurchLine, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchLine);
                END ELSE BEGIN
                    IF SendAsEmail THEN
                        EmailPurchaseHeaderDocument(PurchHdr, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchHdr);
                END;
            END;
        END ELSE BEGIN
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                IF recRepSelect."Take From Lines" THEN BEGIN
                    IF SendAsEmail THEN
                        EmailPurchaseLineDocument(PurchLine, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchLine);
                END ELSE BEGIN
                    IF SendAsEmail THEN
                        EmailPurchaseHeaderDocument(PurchHdr, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchHdr);
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SelectTransferDocReport(var recRepSelect: Record "25006011"; TransferHdr: Record "5740")
    var
        intCount: Integer;
    begin
        TransferHdr.SETRANGE("No.", TransferHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, TransferHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, TransferHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectPurchInvDocReport(var recRepSelect: Record "25006011"; PurchInvHdr: Record "122")
    var
        intCount: Integer;
    begin
        PurchInvHdr.SETRANGE("No.", PurchInvHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchInvHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchInvHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectRetShipmentDocReport(var recRepSelect: Record "25006011"; RetShipmentHdr: Record "6650")
    var
        intCount: Integer;
    begin
        RetShipmentHdr.SETRANGE("No.", RetShipmentHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, RetShipmentHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, RetShipmentHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectPurchCrMemoDocReport(var recRepSelect: Record "25006011"; PurchCrMemoHdr: Record "124")
    var
        intCount: Integer;
    begin
        PurchCrMemoHdr.SETRANGE("No.", PurchCrMemoHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchCrMemoHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchCrMemoHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectPurchRcptDocReport(var recRepSelect: Record "25006011"; PurchRcptHdr: Record "120")
    var
        intCount: Integer;
    begin
        PurchRcptHdr.SETRANGE("No.", PurchRcptHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchRcptHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PurchRcptHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectServDocReport(var recRepSelect: Record "25006011"; recServHeader: Record "25006145"; var ServLines: Record "25006146"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        recServHeader.SETRANGE("Document Type", recServHeader."Document Type");
        recServHeader.SETRANGE("No.", recServHeader."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN BEGIN
                IF recRepSelect."Take From Lines" THEN BEGIN
                    IF SendAsEmail THEN
                        EmailServiceLineDocument(ServLines, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, ServLines);
                END ELSE BEGIN
                    IF SendAsEmail THEN
                        EmailServiceHeaderDocument(recServHeader, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, recServHeader);
                END;
            END;
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                IF recRepSelect."Take From Lines" THEN BEGIN
                    IF SendAsEmail THEN
                        EmailServiceLineDocument(ServLines, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, ServLines);
                END ELSE BEGIN
                    IF SendAsEmail THEN
                        EmailServiceHeaderDocument(recServHeader, recRepSelect."Report ID")
                    ELSE
                        REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, recServHeader);
                END;
            END;
    end;

    [Scope('Internal')]
    procedure SelectPostServDocReport(var recRepSelect: Record "25006011"; PostServHdr: Record "25006149")
    var
        intCount: Integer;
    begin
        PostServHdr.SETRANGE("No.", PostServHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PostServHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PostServHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectPostServRetDocReport(var recRepSelect: Record "25006011"; PostServRetHdr: Record "25006154")
    var
        intCount: Integer;
    begin
        PostServRetHdr.SETRANGE("No.", PostServRetHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PostServRetHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, PostServRetHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectExportSalesHdr(var DataExchangeSelect: Record "25006051"; SalesHdr: Record "36"; var SalesLine: Record "37")
    var
        intCount: Integer;
    begin
        SalesHdr.SETRANGE("Document Type", SalesHdr."Document Type");
        SalesHdr.SETRANGE("No.", SalesHdr."No.");
        intCount := DataExchangeSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Data Exch. Reports-Selection", DataExchangeSelect) = ACTION::LookupOK THEN BEGIN
                IF DataExchangeSelect."Take From Lines" THEN
                    REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, SalesLine)
                ELSE
                    REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, SalesHdr);
            END;
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                DataExchangeSelect.FINDFIRST;
                IF DataExchangeSelect."Take From Lines" THEN
                    REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, SalesLine)
                ELSE
                    REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, SalesHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectExportSalesInvHdr(var DataExchangeSelect: Record "25006051"; SalesInvHdr: Record "112")
    var
        intCount: Integer;
    begin
        SalesInvHdr.SETRANGE("No.", SalesInvHdr."No.");
        intCount := DataExchangeSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Data Exch. Reports-Selection", DataExchangeSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, SalesInvHdr);
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                DataExchangeSelect.FINDFIRST;
                REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, SalesInvHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectImportPurchHdr(var DataExchangeSelect: Record "25006051"; PurchaseHdr: Record "38"; var PurchLine: Record "39")
    var
        intCount: Integer;
    begin
        PurchaseHdr.SETRANGE("Document Type", PurchaseHdr."Document Type");
        PurchaseHdr.SETRANGE("No.", PurchaseHdr."No.");
        intCount := DataExchangeSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Data Exch. Reports-Selection", DataExchangeSelect) = ACTION::LookupOK THEN BEGIN
                IF DataExchangeSelect."Take From Lines" THEN
                    REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, PurchLine)
                ELSE
                    REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, PurchaseHdr);
            END;
        END
        ELSE
            IF intCount = 1 THEN BEGIN
                DataExchangeSelect.FINDFIRST;
                IF DataExchangeSelect."Take From Lines" THEN
                    REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, PurchLine)
                ELSE
                    REPORT.RUNMODAL(DataExchangeSelect."Report ID", TRUE, FALSE, PurchaseHdr);
            END;
    end;

    [Scope('Internal')]
    procedure SelectContractDocReport(var recRepSelect: Record "25006011"; Contract: Record "25006016")
    var
        intCount: Integer;
    begin
        Contract.SETRANGE("Contract Type", Contract."Contract Type");
        Contract.SETRANGE("Contract No.", Contract."Contract No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", recRepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, Contract);
        END ELSE
            IF intCount = 1 THEN BEGIN
                recRepSelect.FINDFIRST;
                REPORT.RUNMODAL(recRepSelect."Report ID", TRUE, FALSE, Contract)
            END;
    end;

    [Scope('Internal')]
    procedure SelectProcessChklistDocReport(var RepSelect: Record "25006011"; ProcessChecklistHeader: Record "25006025")
    var
        intCount: Integer;
    begin
        ProcessChecklistHeader.SETRANGE("No.", ProcessChecklistHeader."No.");
        intCount := RepSelect.COUNT;
        IF intCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", RepSelect) = ACTION::LookupOK THEN
                REPORT.RUNMODAL(RepSelect."Report ID", TRUE, FALSE, ProcessChecklistHeader);
        END ELSE
            IF intCount = 1 THEN BEGIN
                RepSelect.FINDFIRST;
                REPORT.RUNMODAL(RepSelect."Report ID", TRUE, FALSE, ProcessChecklistHeader)
            END;
    end;

    [Scope('Internal')]
    procedure PrintCurrentDoc(DocumentProfile: Option ,"Spare Parts Trade","Vehicles Trade",Service; DocumentKind: Integer; DocumentType: Integer; var recRepSelect: Record "25006011")
    begin
        recRepSelect.RESET;
        CASE DocumentProfile OF
            DocumentProfile::"Vehicles Trade":
                recRepSelect.SETRANGE("Document Profile", recRepSelect."Document Profile"::"Vehicles Trade");
            DocumentProfile::"Spare Parts Trade":
                recRepSelect.SETRANGE("Document Profile", recRepSelect."Document Profile"::"Spare Parts Trade");
            DocumentProfile::Service:
                recRepSelect.SETRANGE("Document Profile", recRepSelect."Document Profile"::Service);
        END;

        CASE DocumentKind OF
            1:
                recRepSelect.SETRANGE("Document Functional Type", recRepSelect."Document Functional Type"::Sale);
            2:
                recRepSelect.SETRANGE("Document Functional Type", recRepSelect."Document Functional Type"::Purchase);
            3:
                recRepSelect.SETRANGE("Document Functional Type", recRepSelect."Document Functional Type"::Service);
        END;

        CASE DocumentType OF
            0:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::Quote);
            1:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::Order);
            2:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::Invoice);
            3:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Credit Memo");
            4:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Blanket Order");
            5:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Return Order");
            6:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::Shipment);
            7:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::Transfer);
            8:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Posted Order");
            9:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Posted Invoice");
            10:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Posted Credit Memo");
            11:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Posted Return Order");
            12:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Posted Shipment");
            13:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::Contract);
            14:
                recRepSelect.SETRANGE("Document Type", recRepSelect."Document Type"::"Process Checklist");

        END;
    end;

    [Scope('Internal')]
    procedure ChooseExcelReport(DocumentProfile: Option ,"Spare Parts Trade","Vehicles Trade",Service; DocumentKind: Integer; DocumentType: Integer; var DataExchangeSelect: Record "25006051")
    begin
        DataExchangeSelect.RESET;
        CASE DocumentProfile OF
            DocumentProfile::"Vehicles Trade":
                DataExchangeSelect.SETRANGE("Document Profile", DataExchangeSelect."Document Profile"::"Vehicles Trade");
            DocumentProfile::"Spare Parts Trade":
                DataExchangeSelect.SETRANGE("Document Profile", DataExchangeSelect."Document Profile"::"Spare Parts Trade");
            DocumentProfile::Service:
                DataExchangeSelect.SETRANGE("Document Profile", DataExchangeSelect."Document Profile"::Service);
        END;

        CASE DocumentKind OF
            0:
                DataExchangeSelect.SETRANGE("Document Functional Type", DataExchangeSelect."Document Functional Type"::Sale);
            1:
                DataExchangeSelect.SETRANGE("Document Functional Type", DataExchangeSelect."Document Functional Type"::Purchase);
            2:
                DataExchangeSelect.SETRANGE("Document Functional Type", DataExchangeSelect."Document Functional Type"::Service);
        END;

        CASE DocumentType OF
            0:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::Quote);
            1:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::Order);
            2:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::Invoice);
            3:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::"Credit Memo");
            4:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::"Blanket Order");
            5:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::"Return Order");
            6:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::Shipment);
            7:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::Transfer);
            8:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::"Posted Order");
            9:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::"Posted Invoice");
            10:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::"Posted Credit Memo");
            11:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::"Posted Return Order");
            12:
                DataExchangeSelect.SETRANGE("Document Type", DataExchangeSelect."Document Type"::"Posted Shipment");
        END;
    end;

    [Scope('Internal')]
    procedure ShowCustomerComments(CustomerNo: Code[20])
    var
        CommentLine: Record "97";
        Customer: Record "18";
        Comment: Text[1000];
        i: Integer;
    begin
        CommentLine.RESET;
        CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::Customer);
        CommentLine.SETRANGE("No.", CustomerNo);
        i := 0;
        Comment := '\';
        IF CommentLine.FINDFIRST THEN BEGIN
            REPEAT
                i += 1;
                IF i < 4 THEN
                    Comment += '       ' + CommentLine.Comment + '\'
                ELSE
                    Comment += '       ' + '...';
            UNTIL (CommentLine.NEXT = 0) OR (i = 4);
        END
        ELSE
            EXIT;
        Customer.GET(CustomerNo);
        IF Comment <> '\' THEN
            MESSAGE(STRSUBSTNO(EDMS001, Customer.Name, Comment));
    end;

    [Scope('Internal')]
    procedure ShowVehicleComments(VehicleSerialNo: Code[20])
    var
        CommentLine: Record "25006148";
        Vehicle: Record "25006005";
        Comment: Text[1000];
        i: Integer;
    begin
        CommentLine.RESET;
        CommentLine.SETRANGE(Type, CommentLine.Type::Vehicle);
        CommentLine.SETRANGE("No.", VehicleSerialNo);
        i := 0;
        Comment := '\';
        IF CommentLine.FINDFIRST THEN BEGIN
            REPEAT
                i += 1;
                IF i < 4 THEN
                    Comment += '       ' + CommentLine.Comment + '\'
                ELSE
                    Comment += '       ' + '...';
            UNTIL (CommentLine.NEXT = 0) OR (i = 4);
        END
        ELSE
            EXIT;
        Vehicle.GET(VehicleSerialNo);
        IF Comment <> '\' THEN
            MESSAGE(STRSUBSTNO(EDMS002, Vehicle.VIN, Comment));
    end;

    [Scope('Internal')]
    procedure ServiceSplitLine(var ServLine: Record "25006146"; LineQty: Integer): Integer
    var
        OldServLine: Record "25006146";
        SplitQuantity: Decimal;
        SplitHours: Decimal;
        OldQuantity: Decimal;
        OldHours: Decimal;
        NewQuantity: Decimal;
        NewHours: Decimal;
        NewLineNo: Integer;
        CurrentLineNo: Integer;
        NextLineStep: Integer;
        LineQtyAtBegin: Integer;
    begin
        IF LineQty < 2 THEN
            EXIT;
        LineQtyAtBegin := LineQty;
        ServLine.TESTFIELD(Type, ServLine.Type::Labor);

        OldServLine := ServLine;
        NewLineNo := ServLine."Line No.";

        OldQuantity := OldServLine.Quantity;
        OldHours := ServLine."Standard Time";
        NewQuantity := OldQuantity / LineQty;
        NewHours := OldHours / LineQty;

        NextLineStep := ServiceGetNewLineNo(ServLine, LineQty);

        ServLine.GET(OldServLine."Document Type", OldServLine."Document No.", OldServLine."Line No.");
        ServLine.VALIDATE("Standard Time", NewHours);
        ServLine.VALIDATE(Quantity, NewQuantity);
        ServLine.Split := TRUE;
        ServLine.MODIFY;

        SplitQuantity := ServLine.Quantity;
        SplitHours := ServLine."Standard Time";

        REPEAT
            NewLineNo := NewLineNo + NextLineStep;
            ServLine."Line No." := NewLineNo;
            ServLine.INSERT;
            IF LineQty <> 2 THEN BEGIN
                ServLine.VALIDATE("Standard Time", NewHours);
                ServLine.VALIDATE(Quantity, NewQuantity);
                SplitQuantity += ServLine.Quantity;
                SplitHours += ServLine."Standard Time";
            END ELSE BEGIN
                ServLine.VALIDATE("Standard Time", OldHours - SplitHours);
                ServLine.VALIDATE(Quantity, OldQuantity - SplitQuantity);
            END;
            ServLine.MODIFY;
            ServLine.GET(OldServLine."Document Type", OldServLine."Document No.", OldServLine."Line No.");
            //  ServiceCopyDimensions(ServLine, NewLineNo);//30.10.2012 EDMS
            LineQty -= 1;
        UNTIL LineQty = 1;
        ServiceScheduleMgt.AdjustAllocEntryByShare(OldServLine, ROUND(100 / LineQtyAtBegin));// P8

        EXIT(NewLineNo);
    end;

    [Scope('Internal')]
    procedure ServiceGetNewLineNo(ServLine: Record "25006146"; LineQty: Integer): Integer
    var
        ServLine2: Record "25006146";
        CurrentNo: Integer;
    begin
        CurrentNo := ServLine."Line No.";
        ServLine2.RESET;
        ServLine2.SETRANGE("Document Type", ServLine."Document Type");
        ServLine2.SETRANGE("Document No.", ServLine."Document No.");
        IF ServLine2.FINDFIRST THEN
            REPEAT
                IF ServLine2."Line No." = ServLine."Line No." THEN BEGIN
                    IF ServLine2.NEXT = 0 THEN
                        EXIT(10000)
                    ELSE
                        EXIT(ROUND((ServLine2."Line No." - CurrentNo) / LineQty, 1))
                END;
            UNTIL ServLine2.NEXT = 0;
        EXIT(10000);
    end;

    [Scope('Internal')]
    procedure Color2Blue(Color: Integer): Integer
    begin
        IF NOT (Color IN [0 .. 16777215]) THEN
            ERROR(STRSUBSTNO(Text004 + Text009, Text008));

        EXIT(ROUND(Color / 65536, 1, '<'));
    end;

    [Scope('Internal')]
    procedure Color2Green(Color: Integer): Integer
    begin
        IF NOT (Color IN [0 .. 16777215]) THEN
            ERROR(STRSUBSTNO(Text004 + Text009, Text008));

        EXIT(ROUND((Color - Color2Blue(Color) * 65536) / 256, 1, '<'));
    end;

    [Scope('Internal')]
    procedure Color2Red(Color: Integer): Integer
    begin
        IF NOT (Color IN [0 .. 16777215]) THEN
            ERROR(STRSUBSTNO(Text004 + Text009, Text008));

        EXIT(ROUND(Color - Color2Blue(Color) * 65536 - Color2Green(Color) * 256, 1, '<'));
    end;

    [Scope('Internal')]
    procedure IsASCII(TextPar: Text[1024]; StartPos: Integer; EndPos: Integer) RetValue: Boolean
    var
        CurrPos: Integer;
    begin
        RetValue := TRUE;
        IF StartPos < EndPos THEN BEGIN
            CurrPos := StartPos;
            REPEAT
                IF TextPar[CurrPos] > 127 THEN
                    RetValue := FALSE;
                CurrPos += 1;
            UNTIL CurrPos > EndPos;
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure WriteBigTextToFile(var TextPar: BigText; LogFileName: Text[1024]): Boolean
    var
        LogFile: File;
        OutStream: OutStream;
        InStream: InStream;
        TextTmp: Text[1024];
        tempData: Record "99008535" temporary;
        BText: BigText;
        CRLF: Text[2];
        CR: Char;
        LF: Char;
    begin
        // returns either is written or not
        IF NOT UserSetup.GET(USERID) THEN
            EXIT(FALSE);

        IF LogFileName = '' THEN
            EXIT(FALSE);

        IF LogFile.OPEN(LogFileName) THEN BEGIN
            LogFile.CREATEINSTREAM(InStream);
            BText.READ(InStream); /// Why in RTC it does not work?
            InStream.READTEXT(TextTmp);
            LogFile.CLOSE;
        END;
        IF NOT LogFile.CREATE(LogFileName) THEN
            EXIT(FALSE);
        LogFile.CREATEOUTSTREAM(OutStream);

        BText.WRITE(OutStream);
        CR := 13;
        CRLF := FORMAT(CR);
        TextTmp := 'Log info at:' + FORMAT(CURRENTDATETIME) + ':';
        OutStream.WRITETEXT(TextTmp);
        OutStream.WRITETEXT(CRLF);
        TextPar.WRITE(OutStream);
        OutStream.WRITETEXT(CRLF);
        LogFile.CLOSE;

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure IsWebClientSession(): Boolean
    var
        ActiveSession: Record "2000000110";
    begin
        ActiveSession.SETRANGE("User ID", USERID);
        ActiveSession.SETFILTER("Session ID", FORMAT(SESSIONID));
        ActiveSession.SETRANGE("Client Type", ActiveSession."Client Type"::"Web Client");
        IF NOT ActiveSession.FINDFIRST THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure SaveServiceHeaderReportAsPdf(var ServiceHeader: Record "25006145"; ReportId: Integer): Text[250]
    var
        FileManagement: Codeunit "419";
        ServerAttachmentFilePath: Text;
    begin
        ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        REPORT.SAVEASPDF(ReportId, ServerAttachmentFilePath, ServiceHeader);
        IF NOT EXISTS(ServerAttachmentFilePath) THEN
            ERROR(ServerSaveAsPdfFailedErr);

        EXIT(ServerAttachmentFilePath);
    end;

    [Scope('Internal')]
    procedure SaveServiceLineReportAsPdf(var ServiceLine: Record "25006146"; ReportId: Integer): Text[250]
    var
        FileManagement: Codeunit "419";
        ServerAttachmentFilePath: Text;
    begin
        ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        REPORT.SAVEASPDF(ReportId, ServerAttachmentFilePath, ServiceLine);
        IF NOT EXISTS(ServerAttachmentFilePath) THEN
            ERROR(ServerSaveAsPdfFailedErr);

        EXIT(ServerAttachmentFilePath);
    end;

    [Scope('Internal')]
    procedure EmailServiceHeaderDocument(var ServiceHeader: Record "25006145"; ReportID: Integer)
    var
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SaveServiceHeaderReportAsPdf(ServiceHeader, ReportID);
        COMMIT;
        //Upgrade 2017 >>
        //DocumentMailing.EmailFile(AttachmentFilePath,'',ServiceHeader."No.",ServiceHeader."Sell-to Customer No.",Text010,FALSE,CustomReportSelection);
        DocumentMailing.EmailFile(AttachmentFilePath, '', '', ServiceHeader."No.", GetToAddressFromCustomer(ServiceHeader."Sell-to Customer No."), Text010, FALSE, CustomReportSelection.Usage::"S.Order");
        //Upgrade 2017 <<
    end;

    [Scope('Internal')]
    procedure EmailServiceLineDocument(var ServiceLine: Record "25006146"; ReportID: Integer)
    var
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SaveServiceLineReportAsPdf(ServiceLine, ReportID);
        COMMIT;
        //Upgrade 2017 >>
        //DocumentMailing.EmailFile(AttachmentFilePath,'',ServiceLine."Document No.",ServiceLine."Sell-to Customer No.",Text010,FALSE,CustomReportSelection);
        DocumentMailing.EmailFile(AttachmentFilePath, '', '', ServiceLine."Document No.", GetToAddressFromCustomer(ServiceLine."Sell-to Customer No."), Text010, FALSE, CustomReportSelection.Usage::"S.Order");
        //Upgrade 2017 <<
    end;

    [Scope('Internal')]
    procedure SaveSalesHeaderReportAsPdf(var SalesHeader: Record "36"; ReportId: Integer): Text[250]
    var
        FileManagement: Codeunit "419";
        ServerAttachmentFilePath: Text;
    begin
        ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        REPORT.SAVEASPDF(ReportId, ServerAttachmentFilePath, SalesHeader);
        IF NOT EXISTS(ServerAttachmentFilePath) THEN
            ERROR(ServerSaveAsPdfFailedErr);

        EXIT(ServerAttachmentFilePath);
    end;

    [Scope('Internal')]
    procedure EmailSalesHeaderDocument(var SalesHeader: Record "36"; ReportID: Integer)
    var
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SaveSalesHeaderReportAsPdf(SalesHeader, ReportID);
        COMMIT;
        //Upgrade 2017 >>
        //DocumentMailing.EmailFile(AttachmentFilePath,'',SalesHeader."No.",SalesHeader."Sell-to Customer No.",STRSUBSTNO(Text011,FORMAT(SalesHeader."Document Type")),FALSE,CustomReportSelection);
        DocumentMailing.EmailFile(AttachmentFilePath, '', '', SalesHeader."No.", GetToAddressFromCustomer(SalesHeader."Sell-to Customer No."), Text010, FALSE, CustomReportSelection.Usage::"S.Invoice");
        //Upgrade 2017 <<
    end;

    [Scope('Internal')]
    procedure SaveSalesLineReportAsPdf(var SalesLine: Record "37"; ReportId: Integer): Text[250]
    var
        FileManagement: Codeunit "419";
        ServerAttachmentFilePath: Text;
    begin
        ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        REPORT.SAVEASPDF(ReportId, ServerAttachmentFilePath, SalesLine);
        IF NOT EXISTS(ServerAttachmentFilePath) THEN
            ERROR(ServerSaveAsPdfFailedErr);

        EXIT(ServerAttachmentFilePath);
    end;

    [Scope('Internal')]
    procedure EmailSalesLineDocument(var SalesLine: Record "37"; ReportID: Integer)
    var
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SaveSalesLineReportAsPdf(SalesLine, ReportID);
        COMMIT;
        //Upgrade 2017 >>
        //DocumentMailing.EmailFile(AttachmentFilePath,'',SalesLine."Document No.",SalesLine."Sell-to Customer No.",STRSUBSTNO(Text011,FORMAT(SalesLine."Document Type")),FALSE,CustomReportSelection);
        DocumentMailing.EmailFile(AttachmentFilePath, '', '', SalesLine."Document No.", GetToAddressFromCustomer(SalesLine."Sell-to Customer No."), Text010, FALSE, CustomReportSelection.Usage::"S.Invoice");
        //Upgrade 2017 <<
    end;

    [Scope('Internal')]
    procedure SavePurchaseLineReportAsPdf(var PurchaseLine: Record "39"; ReportId: Integer): Text[250]
    var
        FileManagement: Codeunit "419";
        ServerAttachmentFilePath: Text;
    begin
        ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        REPORT.SAVEASPDF(ReportId, ServerAttachmentFilePath, PurchaseLine);
        IF NOT EXISTS(ServerAttachmentFilePath) THEN
            ERROR(ServerSaveAsPdfFailedErr);

        EXIT(ServerAttachmentFilePath);
    end;

    [Scope('Internal')]
    procedure EmailPurchaseLineDocument(var PurchaseLine: Record "39"; ReportID: Integer)
    var
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SavePurchaseLineReportAsPdf(PurchaseLine, ReportID);
        COMMIT;
        EmailFileToVendor(AttachmentFilePath, '', PurchaseLine."Document No.", PurchaseLine."Buy-from Vendor No.", STRSUBSTNO(Text012, FORMAT(PurchaseLine."Document Type")), FALSE, CustomReportSelection);
    end;

    [Scope('Internal')]
    procedure SavePurchaseHeaderReportAsPdf(var PurchaseHeader: Record "38"; ReportId: Integer): Text[250]
    var
        FileManagement: Codeunit "419";
        ServerAttachmentFilePath: Text;
    begin
        ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        REPORT.SAVEASPDF(ReportId, ServerAttachmentFilePath, PurchaseHeader);
        IF NOT EXISTS(ServerAttachmentFilePath) THEN
            ERROR(ServerSaveAsPdfFailedErr);

        EXIT(ServerAttachmentFilePath);
    end;

    [Scope('Internal')]
    procedure EmailPurchaseHeaderDocument(var PurchaseHeader: Record "38"; ReportID: Integer)
    var
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SavePurchaseHeaderReportAsPdf(PurchaseHeader, ReportID);
        COMMIT;
        EmailFileToVendor(AttachmentFilePath, '', PurchaseHeader."No.", PurchaseHeader."Buy-from Vendor No.", STRSUBSTNO(Text012, FORMAT(PurchaseHeader."Document Type")), FALSE, CustomReportSelection);
    end;

    [Scope('Internal')]
    procedure EmailFileToVendor(AttachmentFilePath: Text[250]; AttachmentFileName: Text[250]; PostedDocNo: Code[20]; SendEmaillToVendNo: Code[20]; EmailDocName: Text[150]; HideDialog: Boolean; CustomReportSelection: Record "9657")
    var
        TempEmailItem: Record "9500" temporary;
        CompanyInformation: Record "79";
    begin
        IF AttachmentFileName = '' THEN
            AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg, EmailDocName, PostedDocNo);
        CompanyInformation.GET;
        IF CustomReportSelection."Send To Email" <> '' THEN
            TempEmailItem."Send to" := CustomReportSelection."Send To Email"
        ELSE
            TempEmailItem."Send to" := GetToAddressFromCustomer(SendEmaillToVendNo);
        TempEmailItem.Subject := COPYSTR(
            STRSUBSTNO(
              EmailSubjectCapTxt, CompanyInformation.Name, EmailDocName, PostedDocNo), 1,
            MAXSTRLEN(TempEmailItem.Subject));
        TempEmailItem."Attachment File Path" := AttachmentFilePath;
        TempEmailItem."Attachment Name" := AttachmentFileName;
        TempEmailItem.Send(HideDialog);
    end;

    local procedure GetToAddressFromCustomer(VendorNo: Code[20]): Text[250]
    var
        Vendor: Record "23";
        ToAddress: Text;
    begin
        IF Vendor.GET(VendorNo) THEN
            ToAddress := Vendor."E-Mail";

        EXIT(ToAddress);
    end;
}

