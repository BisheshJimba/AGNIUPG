codeunit 25006213 "Sign Management"
{
    // 
    // 02.05.2017 EB.P7
    //   Created


    trigger OnRun()
    begin
    end;

    var
        SaveFileDialogTitleMsg: Label 'Save PDF file';
        SaveFileDialogFilterMsg: Label 'PDF Files (*.pdf)|*.pdf';
        ReportAsPdfFileNameMsg: Label '%1 %2 %3.pdf', Comment = '%1 = Document Type %2 = Invoice No.';
        SignedDocLinkLbl: Label 'Signed Document';

    [Scope('Internal')]
    procedure CallSignAndPrintPageService(var Rec: Record "25006145")
    var
        ServLine: Record "25006146";
        DocMgt: Codeunit "25006000";
        DocReport: Record "25006011";
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
        AttachmentFileName: Text[150];
        DocumentMailing: Codeunit "260";
        FileManagement: Codeunit "419";
        PreviewAndSign: Page "25006242";
        ServiceHeader: Record "25006145";
        RepSelect: Record "25006011";
        RepCount: Integer;
        TimeStampForFileName: Text;
    begin
        Rec.SETRANGE("Document Type", Rec."Document Type");
        Rec.SETRANGE("No.", Rec."No.");
        RepSelect.RESET;
        DocMgt.PrintCurrentDoc(3, 3, 1, RepSelect);
        RepSelect.SETRANGE("Customer Signature", TRUE);
        RepCount := RepSelect.COUNT;
        IF RepCount = 0 THEN
            EXIT;

        IF RepCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", RepSelect) <> ACTION::LookupOK THEN
                EXIT;
        END ELSE
            RepSelect.FINDFIRST;

        TimeStampForFileName := GetTimeStampForFileName;
        AttachmentFilePath := DocMgt.SaveServiceHeaderReportAsPdf(Rec, RepSelect."Report ID");
        AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg, 'Service Order', Rec."No.", TimeStampForFileName);
        COMMIT;

        PreviewAndSign.SetValues('Service Order', Rec."No.", AttachmentFilePath, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'CUSTOMER');
        IF PreviewAndSign.RUNMODAL = ACTION::OK THEN BEGIN
            IF ServiceHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
                ServiceHeader."Customer Signature Text" := PreviewAndSign.GetName();
                ServiceHeader.MODIFY;
                COMMIT;
            END;
        END;
        IF RepSelect."Employee Signature" THEN BEGIN
            CLEAR(PreviewAndSign);
            PreviewAndSign.SetValues('Service Order', Rec."No.", AttachmentFilePath, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'EMPLOYEE');
            IF PreviewAndSign.RUNMODAL = ACTION::OK THEN BEGIN
                IF ServiceHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
                    ServiceHeader."Employee Signature Text" := PreviewAndSign.GetName();
                    ServiceHeader.MODIFY;
                    COMMIT;
                END;
            END;
        END;

        AttachmentFilePath := DocMgt.SaveServiceHeaderReportAsPdf(Rec, RepSelect."Report ID");
        AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg, 'Service Order', Rec."No.", TimeStampForFileName);
        ServiceHeader.ADDLINK(SaveToFile(AttachmentFilePath, AttachmentFileName), AttachmentFileName);//SignedDocLinkLbl
        FileManagement.DownloadHandler(AttachmentFilePath, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);


        IF ServiceHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
            CLEAR(ServiceHeader."Customer Signature Image");
            CLEAR(ServiceHeader."Customer Signature Text");
            CLEAR(ServiceHeader."Employee Signature Image");
            CLEAR(ServiceHeader."Employee Signature Text");
            ServiceHeader.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure CallSignAndPrintPageSales(var Rec: Record "36")
    var
        ServLine: Record "37";
        DocMgt: Codeunit "25006000";
        DocReport: Record "25006011";
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
        AttachmentFileName: Text[150];
        DocumentMailing: Codeunit "260";
        FileManagement: Codeunit "419";
        PreviewAndSign: Page "25006242";
        SalesHeader: Record "36";
        RepSelect: Record "25006011";
        RepCount: Integer;
        TimeStampForFileName: Text;
    begin
        Rec.SETRANGE("Document Type", Rec."Document Type");
        Rec.SETRANGE("No.", Rec."No.");
        RepSelect.RESET;
        DocMgt.PrintCurrentDoc(Rec."Document Profile", 1, 1, RepSelect);
        RepSelect.SETRANGE("Customer Signature", TRUE);
        RepCount := RepSelect.COUNT;
        IF RepCount = 0 THEN
            EXIT;

        IF RepCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", RepSelect) <> ACTION::LookupOK THEN
                EXIT;
        END ELSE
            RepSelect.FINDFIRST;

        TimeStampForFileName := GetTimeStampForFileName;
        AttachmentFilePath := DocMgt.SaveSalesHeaderReportAsPdf(Rec, RepSelect."Report ID");
        AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg, 'Sales Order', Rec."No.", TimeStampForFileName);
        COMMIT;

        PreviewAndSign.SetValues('Sales Order', Rec."No.", AttachmentFilePath, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'CUSTOMER');
        IF PreviewAndSign.RUNMODAL = ACTION::OK THEN BEGIN
            IF SalesHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
                SalesHeader."Customer Signature Text" := PreviewAndSign.GetName();
                SalesHeader.MODIFY;
                COMMIT;
            END;
        END;
        IF RepSelect."Employee Signature" THEN BEGIN
            CLEAR(PreviewAndSign);
            PreviewAndSign.SetValues('Sales Order', Rec."No.", AttachmentFilePath, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'EMPLOYEE');
            IF PreviewAndSign.RUNMODAL = ACTION::OK THEN BEGIN
                IF SalesHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
                    SalesHeader."Employee Signature Text" := PreviewAndSign.GetName();
                    SalesHeader.MODIFY;
                    COMMIT;
                END;
            END;
        END;


        AttachmentFilePath := DocMgt.SaveSalesHeaderReportAsPdf(Rec, RepSelect."Report ID");
        AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg, 'Sales Order', Rec."No.", TimeStampForFileName);
        SalesHeader.ADDLINK(SaveToFile(AttachmentFilePath, AttachmentFileName), AttachmentFileName);//SignedDocLinkLbl
        FileManagement.DownloadHandler(AttachmentFilePath, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);


        IF SalesHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
            CLEAR(SalesHeader."Customer Signature Image");
            CLEAR(SalesHeader."Customer Signature Text");
            CLEAR(SalesHeader."Employee Signature Image");
            CLEAR(SalesHeader."Employee Signature Text");
            SalesHeader.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure CallSignPageService(var Rec: Record "25006145")
    var
        ServLine: Record "25006146";
        DocMgt: Codeunit "25006000";
        DocReport: Record "25006011";
        CustomReportSelection: Record "9657";
        AttachmentFilePath: Text[250];
        AttachmentFileName: Text[150];
        DocumentMailing: Codeunit "260";
        FileManagement: Codeunit "419";
        PreviewAndSign: Page "25006242";
        ServiceHeader: Record "25006145";
        RepSelect: Record "25006011";
        RepCount: Integer;
        TimeStampForFileName: Text;
    begin
        Rec.SETRANGE("Document Type", Rec."Document Type");
        Rec.SETRANGE("No.", Rec."No.");
        RepSelect.RESET;
        DocMgt.PrintCurrentDoc(3, 3, 1, RepSelect);
        RepSelect.SETRANGE("Customer Signature", TRUE);
        RepCount := RepSelect.COUNT;
        IF RepCount = 0 THEN
            EXIT;

        IF RepCount > 1 THEN BEGIN
            IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection", RepSelect) <> ACTION::LookupOK THEN
                EXIT;
        END ELSE
            RepSelect.FINDFIRST;

        TimeStampForFileName := GetTimeStampForFileName;
        AttachmentFilePath := DocMgt.SaveServiceHeaderReportAsPdf(Rec, RepSelect."Report ID");
        AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg, 'Service Order', Rec."No.", TimeStampForFileName);
        COMMIT;

        PreviewAndSign.SetValues('Service Order', Rec."No.", AttachmentFilePath, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'CUSTOMER');
        IF PreviewAndSign.RUNMODAL = ACTION::OK THEN BEGIN
            IF ServiceHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
                ServiceHeader."Customer Signature Text" := PreviewAndSign.GetName();
                ServiceHeader.MODIFY;
                COMMIT;
            END;
        END;
        IF RepSelect."Employee Signature" THEN BEGIN
            CLEAR(PreviewAndSign);
            PreviewAndSign.SetValues('Service Order', Rec."No.", AttachmentFilePath, AttachmentFileName, SaveFileDialogTitleMsg, SaveFileDialogFilterMsg, 'EMPLOYEE');
            IF PreviewAndSign.RUNMODAL = ACTION::OK THEN BEGIN
                IF ServiceHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
                    ServiceHeader."Employee Signature Text" := PreviewAndSign.GetName();
                    ServiceHeader.MODIFY;
                    COMMIT;
                END;
            END;
        END;

        AttachmentFilePath := DocMgt.SaveServiceHeaderReportAsPdf(Rec, RepSelect."Report ID");
        AttachmentFileName := STRSUBSTNO(ReportAsPdfFileNameMsg, 'Service Order', Rec."No.", TimeStampForFileName);
        ServiceHeader.ADDLINK(SaveToFile(AttachmentFilePath, AttachmentFileName), AttachmentFileName);//SignedDocLinkLbl
        //FileManagement.DownloadHandler(AttachmentFilePath,SaveFileDialogTitleMsg,'',SaveFileDialogFilterMsg,AttachmentFileName);


        IF ServiceHeader.GET(Rec."Document Type", Rec."No.") THEN BEGIN
            CLEAR(ServiceHeader."Customer Signature Image");
            CLEAR(ServiceHeader."Customer Signature Text");
            CLEAR(ServiceHeader."Employee Signature Image");
            CLEAR(ServiceHeader."Employee Signature Text");
            ServiceHeader.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure SetDocumentSignature(DocumentType: Code[20]; DocumentNo: Code[20]; Signature: Text; SignatureType: Code[20])
    var
        ServiceHeader: Record "25006145";
        OStream: OutStream;
        MemoryStream: DotNet MemoryStream;
        Bytes: DotNet Array;
        Convert: DotNet Convert;
        Img: Text;
        SalesHeader: Record "36";
    begin
        CASE DocumentType OF
            'SERVICE ORDER':
                BEGIN
                    IF ServiceHeader.GET(ServiceHeader."Document Type"::Order, DocumentNo) THEN BEGIN
                        Bytes := Convert.FromBase64String(Signature);
                        MemoryStream := MemoryStream.MemoryStream(Bytes);
                        IF SignatureType = 'EMPLOYEE' THEN
                            ServiceHeader."Employee Signature Image".CREATEOUTSTREAM(OStream)
                        ELSE
                            ServiceHeader."Customer Signature Image".CREATEOUTSTREAM(OStream);
                        MemoryStream.WriteTo(OStream);
                        ServiceHeader.MODIFY;
                    END;
                END;
            'SALES ORDER':
                BEGIN
                    IF SalesHeader.GET(SalesHeader."Document Type"::Order, DocumentNo) THEN BEGIN
                        Bytes := Convert.FromBase64String(Signature);
                        MemoryStream := MemoryStream.MemoryStream(Bytes);
                        IF SignatureType = 'EMPLOYEE' THEN
                            SalesHeader."Employee Signature Image".CREATEOUTSTREAM(OStream)
                        ELSE
                            SalesHeader."Customer Signature Image".CREATEOUTSTREAM(OStream);
                        MemoryStream.WriteTo(OStream);
                        SalesHeader.MODIFY;
                    END;
                END;
        END
    end;

    [Scope('Internal')]
    procedure ClearDocumentSignature(DocumentType: Code[20]; DocumentNo: Code[20]; Signature: Text; SignatureType: Code[20])
    var
        ServiceHeader: Record "25006145";
        OStream: OutStream;
        MemoryStream: DotNet MemoryStream;
        Bytes: DotNet Array;
        Convert: DotNet Convert;
        Img: Text;
        SalesHeader: Record "36";
    begin
        CASE DocumentType OF
            'SERVICE ORDER':
                BEGIN
                    IF ServiceHeader.GET(ServiceHeader."Document Type"::Order, DocumentNo) THEN BEGIN
                        ServiceHeader.CALCFIELDS("Employee Signature Image", "Customer Signature Image");
                        IF SignatureType = 'EMPLOYEE' THEN
                            CLEAR(ServiceHeader."Employee Signature Image")
                        ELSE
                            CLEAR(ServiceHeader."Customer Signature Image");
                        ServiceHeader.MODIFY;
                    END;
                END;
            'SALES ORDER':
                BEGIN
                    IF SalesHeader.GET(SalesHeader."Document Type"::Order, DocumentNo) THEN BEGIN
                        SalesHeader.CALCFIELDS("Employee Signature Image", "Customer Signature Image");
                        IF SignatureType = 'EMPLOYEE' THEN
                            CLEAR(SalesHeader."Employee Signature Image")
                        ELSE
                            CLEAR(SalesHeader."Customer Signature Image");
                        SalesHeader.MODIFY;
                    END;
                END;
        END
    end;

    local procedure SaveToFile(ServerFilePath: Text; ClientFileName: Text) ClientFilePath: Text
    var
        FileManagement: Codeunit "419";
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        IF UserSetup."Signed Document Path" <> '' THEN BEGIN
            ClientFilePath := UserSetup."Signed Document Path" + ClientFileName;
            //FileManagement.DownloadToFile(ServerFilePath,ClientFilePath);
            FileManagement.CopyServerFile(ServerFilePath, ClientFilePath, TRUE);
        END;
    end;

    local procedure GetTimeStampForFileName(): Text
    begin
        EXIT(FORMAT(CURRENTDATETIME, 0, '<Year,2><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2><Thousands,3>'));
    end;

    [Scope('Internal')]
    procedure GetBlobSize(SignatureDataStream: InStream): Integer
    var
        Length: Integer;
        BytesRead: Integer;
        Variable: Char;
    begin
        REPEAT
            BytesRead := SignatureDataStream.READ(Variable);
            Length += BytesRead;
        UNTIL BytesRead = 0;
        EXIT(Length);
    end;
}

