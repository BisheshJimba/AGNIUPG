page 25006404 "Send SMS Message"
{
    DataCaptionExpression = '';
    PageType = Worksheet;
    SourceTable = Table2000000026;

    layout
    {
        area(content)
        {
            field("Phone No."; PhoneNo)
            {
                Caption = 'Phone No.';
            }
            field("SMS Message"; MessageText)
            {
                Caption = 'Message Body';
                MultiLine = true;
            }
            field("Salesperson Code"; SalespersonCode)
            {
                Caption = 'Salesperson Code';
                Editable = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send SMS")
            {
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF PhoneNo = '' THEN
                        ERROR(FillPhoneNoErr);

                    IF MessageText = '' THEN
                        ERROR(FillMessageErr);

                    IF SalespersonCode = '' THEN
                        ERROR(NoSalespersonCode);

                    SMSManagement.SetContactNo(ContactNo);
                    SMSManagement.SetSalespersonCode(SalespersonCode);
                    SMSManagement.SetDocumentNo := DocumentNo;
                    SMSManagement.SetDocumentType := DocumentType;
                    SMSManagement.AddSMSToQueue(PhoneNo, MessageText);
                    MESSAGE(SmsQueuedMsg);
                end;
            }
        }
    }

    var
        PhoneNo: Text[50];
        MessageText: Text[160];
        ContactNo: Code[20];
        SalespersonCode: Code[10];
        SMSManagement: Codeunit "25006400";
        SmsQueuedMsg: Label 'SMS Message sent.';
        FillPhoneNoErr: Label 'Please fill in recipient Phone No.';
        FillMessageErr: Label 'Message body is empty.';
        NoSalespersonCode: Label 'Please set up Salesperson code.';
        DocumentType: Option;
        DocumentNo: Code[20];

    [Scope('Internal')]
    procedure SetPhoneNo(PhoneNoToSet: Text[50])
    begin
        PhoneNo := PhoneNoToSet;
    end;

    [Scope('Internal')]
    procedure SetMessageBody(MessageBodyToSet: Text[160])
    begin
        MessageText := MessageBodyToSet;
    end;

    [Scope('Internal')]
    procedure SetContactNo(ContactNoToSet: Code[20])
    begin
        ContactNo := ContactNoToSet;
    end;

    [Scope('Internal')]
    procedure SetSalespersonCode(SalespersonCodeToSet: Code[10])
    begin
        SalespersonCode := SalespersonCodeToSet;
    end;

    [Scope('Internal')]
    procedure SetDocumentNo(DocumentNoToSet: Code[20])
    begin
        DocumentNo := DocumentNoToSet;
    end;

    [Scope('Internal')]
    procedure SetDocumentType(DocumentTypeToSet: Option)
    begin
        DocumentType := DocumentTypeToSet;
    end;
}

