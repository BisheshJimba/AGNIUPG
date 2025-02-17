page 25006242 "Preview And Sign"
{
    // 
    // 02.05.2017 EB.P7
    //   Created

    Caption = 'Preview And Sign';
    PageType = StandardDialog;
    SourceTable = Table9500;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field("Attachment Name"; AttachmentFileName)
            {
                Caption = 'Preview';
                Editable = false;

                trigger OnAssistEdit()
                var
                    MailManagement: Codeunit "9520";
                begin
                    //MailManagement.DownloadPdfAttachment(EmailItem);
                    FileManagement.DownloadHandler(AttachmentFilePath, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);
                end;
            }
            label(SignatureCaption)
            {
                CaptionClass = '3,' + SignatureCaption;
                Caption = 'SignatureCaption';
            }
            usercontrol(TouchSign; "EB.TouchSign.Web")
            {

                trigger ControlAddInReady()
                begin
                    CurrPage.TouchSign.RecieveSetDocumentNo(DocumentType, DocumentNo);
                end;
            }
            field(SignatureName; SignatureName)
            {
                Caption = 'Name';
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        SignatureCaption := 'test';
    end;

    trigger OnOpenPage()
    var
        OrigMailBodyText: Text;
    begin
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ServiceHeader: Record "25006145";
        SalesHeader: Record "36";
        InStream: InStream;
    begin
        IF CloseAction = ACTION::OK THEN
            CASE DocumentType OF
                'SERVICE ORDER':
                    BEGIN
                        IF ServiceHeader.GET(ServiceHeader."Document Type"::Order, DocumentNo) THEN BEGIN
                            ServiceHeader.CALCFIELDS("Employee Signature Image", "Customer Signature Image");
                            IF SignatureType = 'EMPLOYEE' THEN BEGIN
                                ServiceHeader."Employee Signature Image".CREATEINSTREAM(InStream);
                                IF SignManagement.GetBlobSize(InStream) < 1000 THEN
                                    ERROR(SignatureFieldIsEmptyTxt)
                            END ELSE BEGIN
                                ServiceHeader."Customer Signature Image".CREATEINSTREAM(InStream);
                                IF SignManagement.GetBlobSize(InStream) < 1000 THEN
                                    ERROR(SignatureFieldIsEmptyTxt)
                            END;
                        END;
                    END;
                'SALES ORDER':
                    BEGIN
                        IF SalesHeader.GET(SalesHeader."Document Type"::Order, DocumentNo) THEN BEGIN
                            SalesHeader.CALCFIELDS("Employee Signature Image", "Customer Signature Image");
                            IF SignatureType = 'EMPLOYEE' THEN BEGIN
                                SalesHeader."Employee Signature Image".CREATEINSTREAM(InStream);
                                IF SignManagement.GetBlobSize(InStream) < 1000 THEN
                                    ERROR(SignatureFieldIsEmptyTxt)
                            END ELSE BEGIN
                                SalesHeader."Customer Signature Image".CREATEINSTREAM(InStream);
                                IF SignManagement.GetBlobSize(InStream) < 1000 THEN
                                    ERROR(SignatureFieldIsEmptyTxt)
                            END;
                        END;
                    END;
            END
    end;

    var
        AttachmentFilePath: Text[250];
        AttachmentFileName: Text[150];
        SaveFileDialogTitleMsg: Text;
        SaveFileDialogFilterMsg: Text;
        FileManagement: Codeunit "419";
        DocumentNo: Code[20];
        DocumentType: Code[20];
        SignManagement: Codeunit "25006213";
        SignatureName: Text[250];
        SignatureType: Code[20];
        SignatureCaption: Text;
        CustSignatureCaptionLbl: Label 'Customer Signature:';
        EmplSignatureCaptionLbl: Label 'Witness Signature:';
        SignatureFieldIsEmptyTxt: Label 'Signature field is empty. Please write a signature.';

    [Scope('Internal')]
    procedure SetValues(DocumentTypeToSet: Code[20]; DocumentNoToSet: Code[20]; AttachmentFilePathPar: Text[250]; AttachmentFileNamePar: Text[150]; SaveFileDialogTitleMsgPar: Text; SaveFileDialogFilterMsgPar: Text; SignatureTypePar: Code[20])
    begin
        DocumentType := DocumentTypeToSet;
        DocumentNo := DocumentNoToSet;
        AttachmentFileName := AttachmentFileNamePar;
        AttachmentFilePath := AttachmentFilePathPar;
        SaveFileDialogTitleMsg := SaveFileDialogTitleMsgPar;
        SaveFileDialogFilterMsg := SaveFileDialogFilterMsgPar;
        SignatureType := SignatureTypePar;

        IF SignatureType = 'CUSTOMER' THEN
            SignatureCaption := CustSignatureCaptionLbl
        ELSE
            SignatureCaption := EmplSignatureCaptionLbl;
    end;

    [Scope('Internal')]
    procedure "TouchSign::RecieveTouchSignData"(RecievedDocumentType: Code[20]; RecievedDocumentNo: Code[20]; SignImg: Text)
    var
        Img: Text;
    begin
        SignManagement.SetDocumentSignature(RecievedDocumentType, RecievedDocumentNo, SignImg, SignatureType);
    end;

    [Scope('Internal')]
    procedure "TouchSign::RecieveClearSignData"(RecievedDocumentType: Code[20]; RecievedDocumentNo: Code[20]; SignImg: Text)
    var
        Img: Text;
    begin
        SignManagement.ClearDocumentSignature(RecievedDocumentType, RecievedDocumentNo, SignImg, SignatureType);
    end;

    [Scope('Internal')]
    procedure GetName(): Text[250]
    begin
        EXIT(SignatureName);
    end;
}

