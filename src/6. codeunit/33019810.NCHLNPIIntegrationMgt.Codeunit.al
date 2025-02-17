codeunit 33019810 "NCHL-NPI Integration Mgt."
{
    Permissions = TableData 454 = rimd,
                  TableData 33019810 = r,
                  TableData 33019811 = r,
                  TableData 33019812 = r,
                  TableData 33019813 = r,
                  TableData 33019814 = rim;
    TableNo = 33019814;

    trigger OnRun()
    begin
        IF UpdateTransaction THEN
            UpdateCIPSTransaction(NCHLNPIEntry);
    end;

    var
        CIPSSetup: Record "33019810";
        Comma: Label ',';
        OpenCurlyBracket: Label '{';
        CloseCurlyBracket: Label '}';
        InnerOpenCurlyBracket: Label '{';
        InnerCloseCurlyBracket: Label '}';
        cipsBatchDetail: Label '"cipsBatchDetail":';
        batchId: Label '"batchId":';
        batchAmount: Label '"batchAmount":';
        batchCount: Label '"batchCount":';
        batchCrncy: Label '"batchCrncy":';
        categoryPurpose: Label '"categoryPurpose":';
        debtorAgent: Label '"debtorAgent":';
        debtorBranch: Label '"debtorBranch":';
        debtorName: Label '"debtorName":';
        debtorAccount: Label '"debtorAccount":';
        debtorIdType: Label '"debtorIdType":';
        debtorIdValue: Label '"debtorIdValue":';
        debtorAddress: Label '"debtorAddress":';
        debtorPhone: Label '"debtorPhone":';
        debtorMobile: Label '"debtorMobile":';
        debtorEmail: Label '"debtorEmail":';
        cipsTransactionDetailList: Label '"cipsTransactionDetailList":';
        instructionId: Label '"instructionId":';
        endToEndId: Label '"endToEndId":';
        creditamount: Label '"amount":';
        creditorAgent: Label '"creditorAgent":';
        creditorBranch: Label '"creditorBranch":';
        creditorName: Label '"creditorName":';
        creditorAccount: Label '"creditorAccount":';
        creditorIdType: Label '"creditorIdType":';
        creditorIdValue: Label '"creditorIdValue":';
        creditorAddress: Label '"creditorAddress":';
        creditorPhone: Label '"creditorPhone":';
        creditorMobile: Label '"creditorMobile":';
        creditorEmail: Label '"creditorEmail":';
        addenda1: Label '"addenda1":';
        addenda2: Label '"addenda2":';
        addenda3: Label '"addenda3":';
        addenda4: Label '"addenda3":';
        NoSeries: Record "308";
        NCHLNPIEntry: Record "33019814";
        NoSeriesMgt2: array[10] of Codeunit "396";
        CIPSWebService: Codeunit "33019811";
        token: Label '"token":';
        CurrCode: Code[10];
        nchlIpsBatchDetail: Label '"nchlIpsBatchDetail":';
        nchlIpsTransactionDetailList: Label '"nchlIpsTransactionDetailList":';
        OnusOffusTransErr: Label 'You cannot post a transaction between same banks and different banks in single voucher. Please create different vouchers and post to integrate with NCHL NPI E-payment system. ';
        OnlyOnePaymentBankAllowedErr: Label 'You can only pay from only one bank in one voucher.';
        AmountZeroErr: Label 'You cannot send approval request with zero amount in line no. %1.';
        InconsistentErr: Label 'Please check the total debit amount and total credit amount before sending approval request. Total Debit Amount: %1 and Total Credit Amount: %2.';
        SendApprovalRequestConfirm: Label 'Do you want to send the approval request?';
        ApprovalRequestSentMsg: Label 'Document has been sent for the approval.';
        CancelApprovalRequestConfirm: Label 'Do you want to cancel the approval request?';
        ApprovalRequestCancelledMsg: Label 'The approval request for the document has been cancelled.';
        ApproveJournalrequestConfirm: Label 'Do you want to approve the document?';
        JournalApprovedMsg: Label 'The document has been approved.';
        RejectJournalConfirm: Label 'Do you want to reject the document?';
        JournalRejectedMsg: Label 'The document has been rejected.';
        PerDayTransactionLimitExceededErr: Label 'The payment limit for the selected date has exceeded than the allowed limit %1 by the amount %2.';
        PerTransactionLimitExceedErr: Label 'The transaction limit has exceeded than the allowed limit %1 by the amount %2.';
        LastDocNo: Code[20];
        LastDocumentNo: Code[20];
        BatchIDSeries: Code[20];
        LastBatchID: Code[20];
        UpdateTransaction: Boolean;
        IsRealTime: Boolean;
        SplitEntry: Boolean;
        PostingNoSeriesNo: Integer;
        NoOfPostingNoSeries: Integer;
        cipsBatchResponseText: Label 'cipsBatchResponse';
        cipsTxnResponseListText: Label 'cipsTxnResponseList';
        OTPPageBuilder: FilterPageBuilder;
        OTPText: Label 'Enter OTP';
        EnteredOTP: Code[10];
        OTP: Code[10];
        ReceiverName: Text;
        SenderName: Text;
        DebitAmount: Decimal;
        Description: Text;
        VendorName: Text;
        ApproverCCMail: Text;
        SenderCCMail: Text;
        "----DOC---": ;
        appID: Label '"appId":';
        refID: Label '"refId":';
        remarks: Label '"remarks":';
        freeText1: Label '"freeText1":';
        freeText2: Label '"freeText2":';
        freeCode1: Label '"freeCode1":';
        freeCode2: Label '"freeCode2":';
        cipsTransactionDetail: Label '"cipsTransactionDetail":';
        dataText: Label 'data';
        responseResult: Label 'responseResult';
        GLSetup: Record "98";
        amountToBePaid: Decimal;
        instanceId: Text;
        companyCode: Text;
        postEntryNo: Text;
        freeText1lbl: Label 'freeText1';
        freeText2lbl: Label 'freeText2';
        freeCode1lbl: Label 'freeCode1';
        freeCode2lbl: Label 'freeCode2';
        addenda3lbl: Label 'addenda3';
        addenda4lbl: Label 'addenda4';
        amount: Label '"amount":';
        instanceIdlbl: Label 'instanceId';
        compantNamelbl: Label 'companyName';
        officeCodelbl: Label 'officeCode';
        amountToBePaidlbl: Label 'amountToBePaid';
        taxAmountlbl: Label 'taxAmount';
        respDes: Label 'responseDescription';
        companycodeLbl: Label 'companyCode';
        nchlIpsTransactionDetail: Label '"nchlIpsTransactionDetail":';
        postEntryNolbl: Label 'postEntryNo';
        responseCodelbl: Label 'responseCode';
        responseDescriptionlbl: Label 'responseDescription';
        batchAmt: Decimal;
        trascationID: Label '"transactionId":';
        realTime: Label '"realTime":';

    [Scope('Internal')]
    procedure CheckCIPSSetup()
    var
        MyRecRef: RecordRef;
        i: Integer;
        FieldReference: FieldRef;
    begin
        CIPSSetup.GET;
        CIPSSetup.TESTFIELD("Base URL");
        CIPSSetup.TESTFIELD("Username (Basic Auth.)");
        CIPSSetup.TESTFIELD("Username (User Auth.)");
        CIPSSetup.TESTFIELD("Password (Basic Auth.)");
        CIPSSetup.TESTFIELD("Password (User Auth.)");
        CIPSSetup.TESTFIELD("Access Token Validity");
        CIPSSetup.TESTFIELD("Refresh Token Validity");
        CIPSSetup.TESTFIELD("Success Status Code");
        CIPSSetup.TESTFIELD("Rest Method");
        CIPSSetup.TESTFIELD("Certificate Path");
        CIPSSetup.TESTFIELD("Certificate Password");
        CIPSSetup.TESTFIELD("Hash Algorithm");
        CIPSSetup.TESTFIELD("Alt. Code (Bank Validation)");
        CIPSSetup.TESTFIELD("Alt. Match % (Bank Validation)");
    end;

    [Scope('Internal')]
    procedure CIPSEnabled(): Boolean
    begin
        CIPSSetup.GET;
        EXIT(
        (CIPSSetup."Base URL" <> '') AND
        (CIPSSetup."Username (Basic Auth.)" <> '') AND
        (CIPSSetup."Username (User Auth.)" <> '') AND
        (CIPSSetup."Password (Basic Auth.)" <> '') AND
        (CIPSSetup."Password (User Auth.)" <> '') AND
        (FORMAT(CIPSSetup."Access Token Validity") <> '') AND
        (CIPSSetup."Success Status Code" <> '')
        )
    end;

    [Scope('Internal')]
    procedure NCHLNPIIntegrationEnabled(): Boolean
    var
        CompanyInfo: Record "79";
    begin
        CompanyInfo.GET;
        EXIT(CompanyInfo."Enable NCHL-NPI Integration");
    end;

    [Scope('Internal')]
    procedure CheckNPIConditions(var GenJnlLine: Record "81"; IsRealTime: Boolean; var SplitJnlLine: Boolean; var CreditorAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; var CreditorAccountNo: Code[20]): Boolean
    var
        SourceCodeSetup: Record "242";
        NPIGenJnlLine: Record "81";
        IsValidAccount: Boolean;
        PrevBankId: Code[10];
        CurrBankId: Code[10];
        OffUsApplicable: Boolean;
        CIPSTransactionSetup: Record "33019813";
        IsOnUsSameBank: Boolean;
        IsOffusInterBank: Boolean;
        BatchLineCount: Integer;
        CategoryPurposeCode: Code[30];
        BankAcc: Record "270";
        VendorBankAccount: Record "288";
        PerTransactionErrMsg: Label 'Transaction Amount cannot be greater than as per %1 %2 %3 in line no. %4.';
        CreditorGenJnl: Record "81";
        BankID: Code[10];
        BranchId: Text;
        AccName: Text;
        BankAccNo: Code[30];
        IDType: Code[10];
        IDValue: Text;
        Address: Text;
        Phone: Text;
        Mobile: Text;
        Email: Text;
        Employee: Record "5200";
        VoucherCount: Integer;
        BankName: Text[100];
        SenderBankID: Code[20];
        ReceiverBankID: Code[20];
        Vendor: Record "23";
        EmployeeBankAccount: Record "14125604";
        CustomerBankAccount: Record "287";
    begin
        IF NOT IsRealTime THEN BEGIN
            SenderBankID := '';
            ReceiverBankID := '';
            NPIGenJnlLine.RESET;
            NPIGenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
            NPIGenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
            NPIGenJnlLine.SETRANGE("Document No.", GenJnlLine."Document No.");
            NPIGenJnlLine.SETFILTER("Credit Amount", '<>%1', 0);
            NPIGenJnlLine.SETRANGE("Account Type", GenJnlLine."Account Type"::"Bank Account");
            IF NPIGenJnlLine.FINDFIRST THEN BEGIN
                IF BankAcc.GET(NPIGenJnlLine."Account No.") THEN
                    SenderBankID := BankAcc."Bank ID";
            END;

            NPIGenJnlLine.RESET;
            NPIGenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
            NPIGenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
            NPIGenJnlLine.SETRANGE("Document No.", GenJnlLine."Document No.");
            NPIGenJnlLine.SETFILTER("Debit Amount", '<>%1', 0);
            IF NPIGenJnlLine.FINDFIRST THEN BEGIN
                REPEAT
                    IF Vendor.GET(NPIGenJnlLine."Account No.") THEN
                        ReceiverBankID := '';
                    IF VendorBankAccount.GET(Vendor."No.", NPIGenJnlLine."Bank Account Code") THEN
                        ReceiverBankID := VendorBankAccount."Bank ID";
                    IF NPIGenJnlLine."Payment Types" <> NPIGenJnlLine."Payment Types"::IRD THEN BEGIN //IRD
                        IF ReceiverBankID = SenderBankID THEN
                            ERROR('Only Inter bank transactions are allowed in non-real time or NCHL IPS transaction.');
                    END;
                UNTIL NPIGenJnlLine.NEXT = 0;
            END;
        END;


        IsValidAccount := FALSE;
        NPIGenJnlLine.RESET;
        NPIGenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        NPIGenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
        NPIGenJnlLine.SETRANGE("Document No.", GenJnlLine."Document No.");
        IF NPIGenJnlLine.FINDFIRST THEN BEGIN
            VoucherCount := NPIGenJnlLine.COUNT;
            REPEAT
                BankID := '';
                BranchId := '';
                AccName := '';
                BankAccNo := '';
                IsValidAccount := FALSE;
                SplitJnlLine := FALSE;
                NPIGenJnlLine.TESTFIELD("CIPS Category Purpose");
                NPIGenJnlLine.TESTFIELD(Status, NPIGenJnlLine.Status::Approved);
                CategoryPurposeCode := NPIGenJnlLine."CIPS Category Purpose";

                //check bank account details based on account type
                CASE NPIGenJnlLine."Account Type" OF
                    NPIGenJnlLine."Account Type"::Vendor:
                        BEGIN
                            Vendor.GET(NPIGenJnlLine."Account No.");
                            //NPI-DOCS1.00
                            IF Vendor."App Id" <> '' THEN BEGIN
                                NPIGenJnlLine.TESTFIELD("Registration Year"); //PAY1.0
                                NPIGenJnlLine.TESTFIELD("Registration No.");
                                NPIGenJnlLine.TESTFIELD("Registration Serial");
                                //NPIGenJnlLine.TESTFIELD("Custom Office");//PAY1.0
                            END ELSE BEGIN
                                //NPI-DOCS1.00
                                NPIGenJnlLine.TESTFIELD("Bank Account Code");
                                IF VendorBankAccount.GET(NPIGenJnlLine."Account No.", NPIGenJnlLine."Bank Account Code") THEN BEGIN
                                    VendorBankAccount.TESTFIELD(Name);
                                    VendorBankAccount.TESTFIELD("Bank Account No.");
                                    VendorBankAccount.TESTFIELD("Bank ID");
                                END;
                            END;
                        END;
                    NPIGenJnlLine."Account Type"::"Bank Account":
                        BEGIN
                            BankAcc.GET(NPIGenJnlLine."Account No.");
                            BankAcc.TESTFIELD("Bank Account Name");
                            BankAcc.TESTFIELD("Bank Account No.");
                            BankAcc.TESTFIELD("Bank ID");
                        END;
                    NPIGenJnlLine."Account Type"::Customer:
                        BEGIN //Cus
                            IF CustomerBankAccount.GET(NPIGenJnlLine."Account No.", NPIGenJnlLine."Bank Account Code") THEN BEGIN
                                CustomerBankAccount.TESTFIELD("Bank Account Name");
                                CustomerBankAccount.TESTFIELD("Bank Account No.");
                                CustomerBankAccount.TESTFIELD("Bank ID");
                            END;
                        END; //Cus
                    NPIGenJnlLine."Account Type"::"G/L Account":
                        BEGIN
                            // NPIGenJnlLine.TESTFIELD("Document Class");
                            // NPIGenJnlLine.TESTFIELD("Document Subclass");
                            IF (NPIGenJnlLine."Payment Types" = NPIGenJnlLine."Payment Types"::" ") THEN BEGIN //IRD
                                NPIGenJnlLine.TESTFIELD("Document Class");
                                NPIGenJnlLine.TESTFIELD("Document Subclass");
                            END ELSE
                                IF NPIGenJnlLine."Payment Types" = NPIGenJnlLine."Payment Types"::CIT THEN BEGIN
                                    NPIGenJnlLine.TESTFIELD("Ref Id"); //CIT
                                    NPIGenJnlLine.TESTFIELD("Office Code");
                                END ELSE
                                    IF NPIGenJnlLine."Payment Types" = NPIGenJnlLine."Payment Types"::IRD THEN
                                        NPIGenJnlLine.TESTFIELD("Ref Id"); //IRD
                            CASE NPIGenJnlLine."Document Class" OF
                                NPIGenJnlLine."Document Class"::Vendor:
                                    BEGIN
                                        NPIGenJnlLine.TESTFIELD("Bank Account Code");
                                        IF VendorBankAccount.GET(NPIGenJnlLine."Document Subclass", NPIGenJnlLine."Bank Account Code") THEN BEGIN
                                            VendorBankAccount.TESTFIELD(Name);
                                            VendorBankAccount.TESTFIELD("Bank Account No.");
                                            VendorBankAccount.TESTFIELD("Bank ID");
                                        END;
                                    END;
                                /*NPIGenJnlLine."Document Class"::Employee: BEGIN
                                  Employee.GET(NPIGenJnlLine."Document SubClass");
                                  Employee.TESTFIELD("Bank Account No.");
                                  Employee.TESTFIELD("Bank ID");
                                END;*/
                                NPIGenJnlLine."Document Class"::Employee:
                                    BEGIN
                                        IF EmployeeBankAccount.GET(NPIGenJnlLine."Document Subclass", NPIGenJnlLine."Bank Account Code") THEN BEGIN
                                            EmployeeBankAccount.TESTFIELD(Name);
                                            EmployeeBankAccount.TESTFIELD("Bank Account No.");
                                            EmployeeBankAccount.TESTFIELD("Bank ID");
                                        END;
                                    END;
                            END;
                        END;
                END;

                //check bank account validation
                GetBankAccountDetails(NPIGenJnlLine, BankID, BranchId, AccName, BankAccNo, IDType, IDValue, Address, Phone, Mobile, Email, BankName);
                IF (BankID <> '') AND (BankAccNo <> '') AND (AccName <> '') THEN BEGIN
                    CLEAR(CIPSWebService);
                    IF CIPSWebService.CheckBankAccountValidation(BankID, BankAccNo, AccName) THEN
                        IsValidAccount := TRUE;
                END;
                IF (NPIGenJnlLine."Bal. Account Type" IN [NPIGenJnlLine."Bal. Account Type"::Vendor, NPIGenJnlLine."Bal. Account Type"::"Bank Account"])
                      AND (NPIGenJnlLine."Bal. Account No." <> '') THEN BEGIN
                    GetBalanceAccountBankAccountDetails(NPIGenJnlLine, BankID, BranchId, AccName, BankAccNo, IDType, IDValue, Address, Phone, Mobile, Email, BankName);
                    IF (BankID <> '') AND (BankAccNo <> '') AND (AccName <> '') THEN BEGIN
                        CLEAR(CIPSWebService);
                        IF CIPSWebService.CheckBankAccountValidation(BankID, BankAccNo, AccName) THEN
                            IsValidAccount := TRUE;
                    END;
                END;

                //check whether on-us or off-us
                CurrBankId := BankID;
                IF (CurrBankId = BankID) AND (CurrBankId = PrevBankId) THEN BEGIN  //Is currbankid = bankid necessary as it is always assigned same??
                    IsOnUsSameBank := TRUE;
                    IsOffusInterBank := FALSE;
                END ELSE
                    IF (CurrBankId <> '') AND (CurrBankId <> PrevBankId) THEN BEGIN
                        IsOnUsSameBank := FALSE;
                        IsOffusInterBank := TRUE;
                    END;

                //Not to allow posting of on us and off us transactions in single voucher
                IF IsOnUsSameBank AND IsOffusInterBank THEN
                    ERROR(OnusOffusTransErr);

                IF NPIGenJnlLine."Debit Amount" <> 0 THEN BEGIN
                    BatchLineCount += 1;  //batch count
                END;

                //checking real time for splitting records in cips transaction entry while post
                IF IsRealTime AND (VoucherCount > 2) THEN BEGIN
                    SplitJnlLine := TRUE;
                END;
                /*
                //check per transaction amount
                IF IsRealTime THEN BEGIN
                  IF IsOnUsSameBank THEN BEGIN
                     CIPSTransactionSetup.GET(CIPSTransactionSetup."Integration Type"::"Real Time",
                                              CIPSTransactionSetup."Transaction Type"::"On-Us (Same Bank)",  //notice this
                                              NPIGenJnlLine."CIPS Category Purpose");
                     IF NPIGenJnlLine."Debit Amount" > CIPSTransactionSetup."Per Transaction Amount" THEN
                       ERROR(PerTransactionErrMsg,CIPSTransactionSetup.TABLECAPTION,CIPSTransactionSetup.FIELDCAPTION("Per Transaction Amount"),
                              CIPSTransactionSetup."Per Transaction Amount",NPIGenJnlLine."Line No.");
                  END ELSE BEGIN
                     CIPSTransactionSetup.GET(CIPSTransactionSetup."Integration Type"::"Real Time",
                                              CIPSTransactionSetup."Transaction Type"::"Off-Us (Inter Bank)", //notice this
                                              NPIGenJnlLine."CIPS Category Purpose");
                     IF NPIGenJnlLine."Debit Amount" > CIPSTransactionSetup."Per Transaction Amount" THEN
                       ERROR(PerTransactionErrMsg,CIPSTransactionSetup.TABLECAPTION,CIPSTransactionSetup.FIELDCAPTION("Per Transaction Amount"),
                              CIPSTransactionSetup."Per Transaction Amount",NPIGenJnlLine."Line No.");
                  END;
                END ELSE BEGIN
                  CIPSTransactionSetup.GET(CIPSTransactionSetup."Integration Type"::"Non-Real Time",
                                              CIPSTransactionSetup."Transaction Type"::"Off-Us (Inter Bank)", //notice this
                                              NPIGenJnlLine."CIPS Category Purpose");
                     IF NPIGenJnlLine."Debit Amount" > CIPSTransactionSetup."Per Transaction Amount" THEN
                       ERROR(PerTransactionErrMsg,CIPSTransactionSetup.TABLECAPTION,CIPSTransactionSetup.FIELDCAPTION("Per Transaction Amount"),
                              CIPSTransactionSetup."Per Transaction Amount",NPIGenJnlLine."Line No.");
                END;
                */
                PrevBankId := CurrBankId;
                IF (NPIGenJnlLine."Payment Types" = NPIGenJnlLine."Payment Types"::IRD) OR (NPIGenJnlLine."Payment Types" = NPIGenJnlLine."Payment Types"::CIT) THEN //IRD
                    IsValidAccount := TRUE; //CIT
            UNTIL NPIGenJnlLine.NEXT = 0;

            REPEAT
                //check per transaction amount
                IF IsRealTime THEN BEGIN
                    IF IsOnUsSameBank THEN BEGIN
                        CIPSTransactionSetup.GET(CIPSTransactionSetup."Integration Type"::"Real Time",
                                                 CIPSTransactionSetup."Transaction Type"::"On-Us (Same Bank)",  //notice this
                                                 NPIGenJnlLine."CIPS Category Purpose");
                        IF NPIGenJnlLine."Debit Amount" > CIPSTransactionSetup."Per Transaction Amount" THEN
                            ERROR(PerTransactionErrMsg, CIPSTransactionSetup.TABLECAPTION, CIPSTransactionSetup.FIELDCAPTION("Per Transaction Amount"),
                                   CIPSTransactionSetup."Per Transaction Amount", NPIGenJnlLine."Line No.");
                    END ELSE BEGIN
                        CIPSTransactionSetup.GET(CIPSTransactionSetup."Integration Type"::"Real Time",
                                                 CIPSTransactionSetup."Transaction Type"::"Off-Us (Inter Bank)", //notice this
                                                 NPIGenJnlLine."CIPS Category Purpose");
                        IF NPIGenJnlLine."Debit Amount" > CIPSTransactionSetup."Per Transaction Amount" THEN
                            ERROR(PerTransactionErrMsg, CIPSTransactionSetup.TABLECAPTION, CIPSTransactionSetup.FIELDCAPTION("Per Transaction Amount"),
                                   CIPSTransactionSetup."Per Transaction Amount", NPIGenJnlLine."Line No.");
                    END;
                END ELSE BEGIN
                    CIPSTransactionSetup.GET(CIPSTransactionSetup."Integration Type"::"Non-Real Time",
                                                CIPSTransactionSetup."Transaction Type"::"Off-Us (Inter Bank)", //notice this
                                                NPIGenJnlLine."CIPS Category Purpose");
                    IF NPIGenJnlLine."Debit Amount" > CIPSTransactionSetup."Per Transaction Amount" THEN
                        ERROR(PerTransactionErrMsg, CIPSTransactionSetup.TABLECAPTION, CIPSTransactionSetup.FIELDCAPTION("Per Transaction Amount"),
                               CIPSTransactionSetup."Per Transaction Amount", NPIGenJnlLine."Line No.");
                END;
            UNTIL NPIGenJnlLine.NEXT = 0;

        END;
        //only different bank account no. transfer allowed in non-real time
        IF (NOT IsRealTime) AND IsOnUsSameBank THEN
            ERROR('Only Inter bank transactions are allowed in non-real time or NCHL IPS transaction.');

        //batch count check for real time (on-us and off-us both)  not needed as of now
        /*IF IsRealTime AND (IsOffusInterBank OR IsOnUsSameBank) THEN BEGIN
          CIPSTransactionSetup.RESET;
          CIPSTransactionSetup.SETRANGE("Integration Type",CIPSTransactionSetup."Integration Type"::"Real Time");
          CIPSTransactionSetup.SETRANGE("Category Purpose",CategoryPurposeCode);
          IF IsOffusInterBank THEN
            CIPSTransactionSetup.SETRANGE("Transaction Type",CIPSTransactionSetup."Transaction Type"::"Off-Us (Inter Bank)");
          IF IsOnUsSameBank THEN
           CIPSTransactionSetup.SETRANGE("Transaction Type",CIPSTransactionSetup."Transaction Type"::"On-Us (Same Bank)");
          IF CIPSTransactionSetup.FINDFIRST THEN BEGIN
            IF BatchLineCount > CIPSTransactionSetup."Transaction per Batch" THEN
              ERROR('Only one debit line allowed in real time');
          END;
        
        
        END;*/

        //get creditor info if split entry is true
        IF SplitJnlLine THEN BEGIN
            CreditorGenJnl.RESET;
            CreditorGenJnl.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
            CreditorGenJnl.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
            CreditorGenJnl.SETRANGE("Document No.", GenJnlLine."Document No.");
            CreditorGenJnl.SETFILTER("Credit Amount", '>%1', 0);
            IF CreditorGenJnl.FINDFIRST THEN BEGIN
                CreditorAccountType := CreditorGenJnl."Account Type";
                CreditorAccountNo := CreditorGenJnl."Account No.";
            END;
        END;

        //batch count check for non-real time (only off-us)
        IF (NOT IsRealTime) AND IsOffusInterBank THEN BEGIN
            CIPSTransactionSetup.RESET;
            CIPSTransactionSetup.SETRANGE("Integration Type", CIPSTransactionSetup."Integration Type"::"Non-Real Time");
            CIPSTransactionSetup.SETRANGE("Category Purpose", CategoryPurposeCode);
            CIPSTransactionSetup.SETRANGE("Transaction Type", CIPSTransactionSetup."Transaction Type"::"Off-Us (Inter Bank)");
            IF CIPSTransactionSetup.FINDFIRST THEN BEGIN
                IF BatchLineCount > CIPSTransactionSetup."Transaction per Batch" THEN
                    ERROR('Only %1 debit line allowed in non-real time', CIPSTransactionSetup."Transaction per Batch");
            END;
        END;

        EXIT(IsValidAccount);

    end;

    [Scope('Internal')]
    procedure GetBankAccountDetails(GenJnlLine: Record "81"; var Agent: Code[20]; var Branch: Text; var Name: Text; var BankAccountNo: Code[30]; var IDType: Code[10]; var IDValue: Text; var Address: Text; var Phone: Text; var Mobile: Text; var Email: Text; var BankName: Text[100])
    var
        VendorBankAccount: Record "288";
        CustomerBankAccount: Record "287";
        Vendor: Record "23";
        Customer: Record "18";
        BankAccount: Record "270";
        Employee: Record "5200";
        EmployeeBankAccount: Record "14125604";
    begin
        CASE GenJnlLine."Account Type" OF
            GenJnlLine."Account Type"::Vendor:
                BEGIN
                    Vendor.GET(GenJnlLine."Account No.");
                    IF VendorBankAccount.GET(Vendor."No.", "Bank Account Code") THEN BEGIN
                        BankAccountNo := VendorBankAccount."Bank Account No.";
                        Agent := VendorBankAccount."Bank ID";
                        Branch := VendorBankAccount."Bank Branch No.";
                        Name := VendorBankAccount.Name;
                        BankName := VendorBankAccount."Bank Name";
                    END;
                    Address := Vendor.Address;
                    Phone := Vendor."Phone No.";
                    Mobile := Vendor."Phone No.";
                    Email := Vendor."E-Mail";
                END;
            GenJnlLine."Account Type"::Customer:
                BEGIN //Cus
                    Customer.GET(GenJnlLine."Account No.");
                    IF CustomerBankAccount.GET(GenJnlLine."Account No.", "Bank Account Code") THEN BEGIN
                        BankAccountNo := CustomerBankAccount."Bank Account No.";
                        Agent := CustomerBankAccount."Bank ID";
                        Branch := CustomerBankAccount."Bank Branch No.";
                        Name := CustomerBankAccount."Bank Account Name";
                        BankName := CustomerBankAccount.Name;
                    END;
                    Address := Customer.Address;
                    Phone := Customer."Phone No.";
                    Mobile := Customer."Phone No.";
                    Email := Customer."E-Mail";
                END; //Cus
            GenJnlLine."Account Type"::"Bank Account":
                BEGIN
                    BankAccount.GET(GenJnlLine."Account No.");
                    BankAccountNo := BankAccount."Bank Account No.";
                    Agent := BankAccount."Bank ID";
                    Branch := BankAccount."Bank Branch No.";
                    Address := BankAccount.Address;
                    Phone := BankAccount."Phone No.";
                    Mobile := BankAccount."Phone No.";
                    Email := BankAccount."E-Mail";
                    Name := BankAccount."Bank Account Name";
                    BankName := BankAccount."Bank Name";
                    CASE "Document Class" OF
                        "Document Class"::Vendor:
                            BEGIN
                                Vendor.GET("Document Subclass");
                                IF VendorBankAccount.GET(Vendor."No.", "Bank Account Code") THEN BEGIN
                                    BankAccountNo := VendorBankAccount."Bank Account No.";
                                    Agent := VendorBankAccount."Bank ID";
                                    Branch := VendorBankAccount."Bank Branch No.";
                                    Name := VendorBankAccount.Name;
                                    BankName := VendorBankAccount."Bank Name";
                                END;
                                Address := Vendor.Address;
                                Phone := Vendor."Phone No.";
                                Mobile := Vendor."Phone No.";
                                Email := Vendor."E-Mail";
                            END;


                    /*"Document Class"::Employee:BEGIN
                      Employee.GET("Document SubClass");
                      BankAccountNo := Employee."Bank Account No.";
                      Agent := Employee."Bank ID";
                      Branch := Employee."Bank Branch No.";
                      Address := Employee.Address;
                      Phone := Employee."Phone No.";
                      Mobile := Employee."Phone No.";
                      Email := Employee."E-Mail";
                      Name := Employee.FullName;
                      BankName := Employee."Bank Name";
                    END;*/
                    END;
                END;
            GenJnlLine."Account Type"::"G/L Account":
                BEGIN
                    CASE "Document Class" OF
                        "Document Class"::Vendor:
                            BEGIN
                                Vendor.GET("Document Subclass");
                                IF VendorBankAccount.GET(Vendor."No.", "Bank Account Code") THEN BEGIN
                                    BankAccountNo := VendorBankAccount."Bank Account No.";
                                    Agent := VendorBankAccount."Bank ID";
                                    Branch := VendorBankAccount."Bank Branch No.";
                                    Name := VendorBankAccount.Name;
                                    BankName := VendorBankAccount."Bank Name";
                                END;
                                Address := Vendor.Address;
                                Phone := Vendor."Phone No.";
                                Mobile := Vendor."Phone No.";
                                Email := Vendor."E-Mail";
                            END;
                        /*"Document Class"::Employee:BEGIN
                          Employee.GET("Document SubClass");
                          BankAccountNo := Employee."Bank Account No.";
                          Agent := Employee."Bank ID";
                          Branch := Employee."Bank Branch No.";
                          Address := Employee.Address;
                          Phone := Employee."Phone No.";
                          Mobile := Employee."Phone No.";
                          Email := Employee."E-Mail";
                          Name := Employee.FullName;
                          BankName := Employee."Bank Name";
                        END;*/
                        "Document Class"::Employee:
                            BEGIN
                                Employee.GET("Document Subclass");
                                IF EmployeeBankAccount.GET(Employee."No.", "Bank Account Code") THEN BEGIN
                                    BankAccountNo := EmployeeBankAccount."Bank Account No.";
                                    Agent := EmployeeBankAccount."Bank ID";
                                    Branch := EmployeeBankAccount."Bank Branch No.";
                                    Name := EmployeeBankAccount.Name;
                                    BankName := EmployeeBankAccount."Bank Name";
                                END;
                                Address := Employee.Address;
                                Phone := Employee."Phone No.";
                                Mobile := Employee."Phone No.";
                                //  Email := Employee."E-Mail";
                            END;
                    END;
                END;
        END;
        //SL1.0
        /* IF "Is From Sugg Vendor" THEN BEGIN
          IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
             BankAccount.GET("Account No.");
             BankAccountNo := BankAccount."Bank Account No.";
             Agent := BankAccount."Bank ID";
             Branch := BankAccount."Bank Branch No.";
             Address := BankAccount.Address;
             Phone := BankAccount."Phone No.";
             Mobile := BankAccount."Phone No.";
             Email := BankAccount."E-Mail";
             Name := BankAccount."Bank Account Name";
             BankName := BankAccount."Bank Name";
          END
          ELSE IF "Account Type" = "Account Type"::Vendor THEN BEGIN
           Vendor.GET("Account No.");
           IF VendorBankAccount.GET(Vendor."No.","Bank Account Code") THEN BEGIN
             BankAccountNo := VendorBankAccount."Bank Account No.";
             Agent := VendorBankAccount."Bank ID";
             Branch := VendorBankAccount."Bank Branch No.";
             Name := VendorBankAccount.Name;
             BankName := VendorBankAccount."Bank Name";
           END;
           Address := Vendor.Address;
           Phone := Vendor."Phone No.";
           Mobile := Vendor."Phone No.";
           Email := Vendor."E-Mail";
          END;
         END;
         */
        //SL1.0

    end;

    [Scope('Internal')]
    procedure GetBalanceAccountBankAccountDetails(GenJnlLine: Record "81"; var Agent: Code[20]; var Branch: Text; var Name: Text; var BankAccountNo: Code[30]; var IDType: Code[10]; var IDValue: Text; var Address: Text; var Phone: Text; var Mobile: Text; var Email: Text; var BankName: Text)
    var
        VendorBankAccount: Record "288";
        CustomerBankAccount: Record "287";
        Vendor: Record "23";
        Customer: Record "18";
        BankAccount: Record "270";
    begin
        CASE GenJnlLine."Bal. Account Type" OF
            GenJnlLine."Bal. Account Type"::Vendor:
                BEGIN
                    Vendor.GET(GenJnlLine."Bal. Account No.");
                    IF VendorBankAccount.GET(Vendor."No.", "Bank Account Code") THEN BEGIN
                        BankAccountNo := VendorBankAccount."Bank Account No.";
                        Agent := VendorBankAccount."Bank ID";
                        Branch := VendorBankAccount."Bank Branch No.";
                        BankName := VendorBankAccount."Bank Name";
                    END;
                    Address := Vendor.Address;
                    Phone := Vendor."Phone No.";
                    Mobile := Vendor."Phone No.";
                    Email := Vendor."E-Mail";
                    Name := Vendor.Name;
                    //IDType := Vendor."VAT Registration No."; for passport no. / citizenship no
                    //IDValue := Vendor."VAT Registration No.";
                END;
            GenJnlLine."Bal. Account Type"::"Bank Account":
                BEGIN
                    BankAccount.GET(GenJnlLine."Bal. Account No.");
                    BankAccountNo := BankAccount."Bank Account No.";
                    Agent := BankAccount."Bank ID";
                    Branch := BankAccount."Bank Branch No.";
                    Address := BankAccount.Address;
                    Phone := BankAccount."Phone No.";
                    Mobile := BankAccount."Phone No.";
                    Email := BankAccount."E-Mail";
                    Name := BankAccount."Bank Account Name";
                    BankName := BankAccount."Bank Name";
                    //IDType := Vendor."VAT Registration No."; for passport no. / citizenship no
                    //IDValue := Vendor."VAT Registration No.";
                END;
        END;
    end;

    [Scope('Internal')]
    procedure GetCIPSBatchID(PostedDocumentNo: Code[20]; PostingDate: Date; CreateError: Boolean; IsRealTime: Boolean): Code[20]
    var
        CIPSTransactionEntry: Record "33019814";
        CIPSSetup: Record "33019810";
        NoSeriesMgt: Codeunit "396";
        DocumentNo: Code[20];
        Text000: Label 'You must specify %1.';
    begin
        CIPSSetup.GET;
        IF IsRealTime THEN
            CIPSSetup.TESTFIELD("Real Time Batch ID Series")
        ELSE
            CIPSSetup.TESTFIELD("Non-Real Time Batch ID Series");

        CIPSTransactionEntry.RESET;
        CIPSTransactionEntry.SETCURRENTKEY("Batch ID Series");
        CIPSTransactionEntry.SETRANGE("Document No.", PostedDocumentNo);
        IF IsRealTime THEN
            CIPSTransactionEntry.SETRANGE("Batch ID Series", CIPSSetup."Real Time Batch ID Series")
        ELSE
            CIPSTransactionEntry.SETRANGE("Batch ID Series", CIPSSetup."Non-Real Time Batch ID Series");
        IF NOT CIPSTransactionEntry.FINDLAST THEN BEGIN
            IF IsRealTime THEN
                DocumentNo := NoSeriesMgt.GetNextNo(CIPSSetup."Real Time Batch ID Series", PostingDate, TRUE)
            ELSE
                DocumentNo := NoSeriesMgt.GetNextNo(CIPSSetup."Non-Real Time Batch ID Series", PostingDate, TRUE);
        END ELSE BEGIN
            DocumentNo := INCSTR(CIPSTransactionEntry."Batch ID");
        END;
        IF (DocumentNo = '') AND CreateError THEN
            ERROR(Text000, CIPSTransactionEntry.FIELDCAPTION("Batch ID"));
        EXIT(DocumentNo);
    end;

    local procedure GetDebtorAgentDetail(DocumentNo: Code[20]; var Agent: Text; var Name: Text; var BankAccNo: Text)
    var
        CIPSEntry: Record "33019814";
    begin
        CIPSEntry.RESET;
        CIPSEntry.SETRANGE("Document No.", DocumentNo);
        CIPSEntry.SETRANGE(Type, CIPSEntry.Type::Debtor);
        IF CIPSEntry.FINDFIRST THEN BEGIN
            Agent := CIPSEntry.Agent;
            Name := CIPSEntry.Name;
            BankAccNo := CIPSEntry."Bank Account No.";
        END ELSE BEGIN
            Agent := '';
            Name := '';
            BankAccNo := '';
        END;
    end;

    [Scope('Internal')]
    procedure GetCreditorBankAccountDetails(NewCreditorAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; NewCreditorAccountNo: Code[20]; var Agent: Code[10]; var Branch: Text; var Name: Text; var BankAccountNo: Code[30]; var IDType: Code[10]; var IDValue: Text; var Address: Text; var Phone: Text; var Mobile: Text; var Email: Text)
    var
        VendorBankAccount: Record "288";
        CustomerBankAccount: Record "287";
        Vendor: Record "23";
        Customer: Record "18";
        BankAccount: Record "270";
    begin
        CASE NewCreditorAccountType OF
            NewCreditorAccountType::Vendor:
                BEGIN
                END;
            NewCreditorAccountType::"Bank Account":
                BEGIN
                    BankAccount.GET(NewCreditorAccountNo);
                    BankAccountNo := BankAccount."Bank Account No.";
                    Agent := BankAccount."Bank ID";
                    Branch := BankAccount."Bank Branch No.";
                    Address := BankAccount.Address;
                    Phone := BankAccount."Phone No.";
                    Mobile := BankAccount."Phone No.";
                    Email := BankAccount."E-Mail";
                    Name := BankAccount."Bank Account Name";
                END;
        END;
    end;

    [Scope('Internal')]
    procedure InsertCIPSTransactionEntry(GenJnlLine: Record "81"; IsRealTime: Boolean; SplitIPSEntry: Boolean; CreditorAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; CreditorAccountNo: Code[20])
    var
        EntryNo: Integer;
        CIPSTransactionEntry: Record "33019814";
        LineNo: Integer;
        CompanyInfo: Record "79";
        GLSetup: Record "98";
        BalanceEntry: Record "33019814";
        CreditorGenJnl: Record "81";
        BatchID: Code[20];
        NCHLNPICategoryPurpose: Record "33019812";
        CIPSGenJnlLine: Record "81";
        InsertedCIPSTransEntry: Record "33019814";
    begin
        CompanyInfo.GET;
        IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
            EXIT;

        CIPSSetup.GET;
        CIPSSetup.TESTFIELD("Real Time Batch ID Series");

        GLSetup.GET;
        IF GenJnlLine."Currency Code" = '' THEN
            CurrCode := GLSetup."LCY Code"
        ELSE
            CurrCode := GenJnlLine."Currency Code";

        CIPSTransactionEntry.RESET;
        IF NOT CIPSTransactionEntry.FINDLAST THEN
            EntryNo := 1
        ELSE
            EntryNo := CIPSTransactionEntry."Entry No." + 1;


        //for getting line no. for cips transaction detail
        IF GenJnlLine."Debit Amount" > 0 THEN BEGIN
            CIPSTransactionEntry.RESET;
            CIPSTransactionEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
            CIPSTransactionEntry.SETRANGE(Type, CIPSTransactionEntry.Type::Creditor);
            IF NOT CIPSTransactionEntry.FINDLAST THEN
                LineNo := 1
            ELSE
                LineNo += CIPSTransactionEntry."Line No." + 1;
        END;

        CIPSTransactionEntry.INIT;
        CIPSTransactionEntry."Entry No." := EntryNo;
        CIPSTransactionEntry."Posting Date" := GenJnlLine."Posting Date";
        CIPSTransactionEntry."Document No." := GenJnlLine."Document No.";
        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") AND ("Document Class" <> "Document Class"::" ") THEN BEGIN
            CASE "Document Class" OF
                "Document Class"::Vendor:
                    BEGIN
                        CIPSTransactionEntry."Account Type" := CIPSTransactionEntry."Account Type"::Vendor;
                        CIPSTransactionEntry."Account No." := "Document Subclass";
                    END;
            /*"Document Class"::Employee : BEGIN
              CIPSTransactionEntry."Account Type"  := CIPSTransactionEntry."Account Type"::Employee;
              CIPSTransactionEntry."Account No." := "Document SubClass";
            END;*/
            END;
        END ELSE BEGIN
            CIPSTransactionEntry."Account Type" := GenJnlLine."Account Type";
            CIPSTransactionEntry."Account No." := GenJnlLine."Account No.";
        END;
        CIPSTransactionEntry."Batch Currency" := CurrCode;
        CIPSTransactionEntry."Category Purpose" := "CIPS Category Purpose";
        CIPSTransactionEntry."End to End ID" := GenJnlLine."External Document No.";
        IF GenJnlLine."Debit Amount" <> 0 THEN BEGIN
            CIPSTransactionEntry.Type := CIPSTransactionEntry.Type::Creditor;
            CIPSTransactionEntry."Debit Amount" := GenJnlLine."Debit Amount";
            CIPSTransactionEntry."Line No." := LineNo;
        END ELSE BEGIN
            CIPSTransactionEntry.Type := CIPSTransactionEntry.Type::Debtor;
            CIPSTransactionEntry."Credit Amount" := GenJnlLine."Credit Amount";
        END;
        GetBankAccountDetails(GenJnlLine, CIPSTransactionEntry.Agent, CIPSTransactionEntry.Branch, CIPSTransactionEntry.Name,
                              CIPSTransactionEntry."Bank Account No.", CIPSTransactionEntry."ID Type", CIPSTransactionEntry."ID Value",
                              CIPSTransactionEntry.Address, CIPSTransactionEntry.Phone, CIPSTransactionEntry.Mobile, CIPSTransactionEntry.Email,
                              CIPSTransactionEntry."Bank Name");
        IF IsRealTime THEN BEGIN
            CIPSTransactionEntry."Transaction Type" := CIPSTransactionEntry."Transaction Type"::"Real Time";
            CIPSTransactionEntry."Batch ID Series" := CIPSSetup."Real Time Batch ID Series";
            CIPSTransactionEntry."Batch ID" := GetCIPSBatchID(CIPSTransactionEntry."Document No.", CIPSTransactionEntry."Posting Date", FALSE, TRUE);
        END ELSE BEGIN
            CIPSTransactionEntry."Transaction Type" := CIPSTransactionEntry."Transaction Type"::"Non-Real Time";
            CIPSTransactionEntry."Batch ID Series" := CIPSSetup."Non-Real Time Batch ID Series";
            CIPSTransactionEntry."Batch ID" := GetCIPSBatchID(CIPSTransactionEntry."Document No.", CIPSTransactionEntry."Posting Date", FALSE, FALSE);
        END;
        CIPSTransactionEntry."Ref Id" := "Ref Id"; //IRD
        CIPSTransactionEntry."CIT Office Code" := "Office Code"; //CIT
        CIPSTransactionEntry.INSERT;

        //insert another line for Bal. Account
        IF GenJnlLine."Bal. Account No." <> '' THEN BEGIN
            BalanceEntry.RESET;
            BalanceEntry.INIT;
            BalanceEntry."Entry No." := EntryNo + 1;
            BalanceEntry."Posting Date" := GenJnlLine."Posting Date";
            BalanceEntry."Document No." := GenJnlLine."Document No.";
            BalanceEntry."Account Type" := GenJnlLine."Bal. Account Type";
            BalanceEntry."Account No." := GenJnlLine."Bal. Account No.";
            BalanceEntry."Batch Currency" := CurrCode;
            BalanceEntry."Category Purpose" := "CIPS Category Purpose";
            BalanceEntry."End to End ID" := GenJnlLine."External Document No.";
            IF CIPSTransactionEntry.Type = CIPSTransactionEntry.Type::Creditor THEN BEGIN  //opposite case
                BalanceEntry.Type := BalanceEntry.Type::Debtor;
                BalanceEntry."Credit Amount" := CIPSTransactionEntry."Debit Amount";
            END ELSE BEGIN
                BalanceEntry.Type := BalanceEntry.Type::Creditor;
                BalanceEntry."Debit Amount" := CIPSTransactionEntry."Credit Amount"; //opposite case
                BalanceEntry."Line No." := LineNo;
            END;
            GetBalanceAccountBankAccountDetails(GenJnlLine, BalanceEntry.Agent, BalanceEntry.Branch, BalanceEntry.Name,
                                  BalanceEntry."Bank Account No.", BalanceEntry."ID Type", BalanceEntry."ID Value",
                                  BalanceEntry.Address, BalanceEntry.Phone, BalanceEntry.Mobile, BalanceEntry.Email, CIPSTransactionEntry."Bank Name");
            IF IsRealTime THEN BEGIN
                BalanceEntry."Transaction Type" := BalanceEntry."Transaction Type"::"Real Time";
                IF NOT SplitIPSEntry THEN
                    BalanceEntry."Batch ID" := CIPSTransactionEntry."Batch ID"
            END ELSE BEGIN
                BalanceEntry."Transaction Type" := BalanceEntry."Transaction Type"::"Non-Real Time";
                IF BalanceEntry.Type = BalanceEntry.Type::Creditor THEN BEGIN
                    IF IsRealTime THEN
                        BalanceEntry."Batch ID Series" := CIPSSetup."Real Time Batch ID Series"
                    ELSE
                        BalanceEntry."Batch ID Series" := CIPSSetup."Non-Real Time Batch ID Series";
                    BalanceEntry."Batch ID" := GetCIPSBatchID(BalanceEntry."Document No.", BalanceEntry."Posting Date", FALSE, FALSE);
                END;
            END;
            BalanceEntry.INSERT;
        END;

    end;

    [Scope('Internal')]
    procedure PrepareRealTimeCreditLine(CIPSCreditEntry: Record "33019814"): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        CIPSCreditEntry.CALCFIELDS("Batch Count");
        data := OpenCurlyBracket;
        data += cipsBatchDetail + InnerOpenCurlyBracket;
        data += batchId + '"' + "Batch ID" + '"' + Comma;
        data += batchAmount + '"' + RemoveComma(FORMAT(CIPSCreditEntry."Credit Amount")) + '"' + Comma;
        data += batchCount + '"' + FORMAT(CIPSCreditEntry."Batch Count") + '"' + Comma;
        data += batchCrncy + '"' + "Batch Currency" + '"' + Comma;
        data += categoryPurpose + '"' + "Category Purpose" + '"' + Comma;
        data += debtorAgent + '"' + Agent + '"' + Comma;
        data += debtorBranch + '"' + Branch + '"' + Comma;
        data += debtorName + '"' + Name + '"' + Comma;
        data += debtorAccount + '"' + "Bank Account No." + '"' + Comma;
        data += debtorIdType + '"' + "ID Type" + '"' + Comma;
        data += debtorIdValue + '"' + "ID Value" + '"' + Comma;
        data += debtorAddress + '"' + Address + '"' + Comma;
        data += debtorPhone + '"' + Phone + '"' + Comma;
        data += debtorMobile + '"' + Mobile + '"' + Comma;
        data += debtorEmail + '"' + Email + '"';
        data += CloseCurlyBracket + Comma;
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure PrepareRealTimeDebitLine(CIPSDebitEntry: Record "33019814"): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        //data := cipsTransactionDetailList + '[{';
        data := '{';
        data += instructionId + '"' + "Batch ID" + '-' + FORMAT(CIPSDebitEntry."Line No.") + '"' + Comma;
        data += endToEndId + '"' + CIPSDebitEntry."Document No." + '"' + Comma;
        data += creditamount + '"' + RemoveComma(FORMAT(CIPSDebitEntry."Debit Amount")) + '"' + Comma;
        data += creditorAgent + '"' + Agent + '"' + Comma;
        data += creditorBranch + '"' + Branch + '"' + Comma;
        data += creditorName + '"' + Name + '"' + Comma;
        data += creditorAccount + '"' + "Bank Account No." + '"' + Comma;
        data += creditorIdType + '"' + "ID Type" + '"' + Comma;
        data += creditorIdValue + '"' + "ID Value" + '"' + Comma;
        data += creditorAddress + '"' + Address + '"' + Comma;
        data += creditorPhone + '"' + Phone + '"' + Comma;
        data += creditorMobile + '"' + Mobile + '"' + Comma;
        data += creditorEmail + '"' + Email + '"' + Comma;
        data += addenda1 + '"' + FORMAT("Addenda 1") + '"' + Comma;
        data += addenda2 + '"' + FORMAT("Addenda 2") + '"' + Comma;
        data += addenda3 + '"' + "Addenda 3" + '"' + Comma;
        data += addenda4 + '"' + "Addenda 4" + '"';
        data += '}';
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure PrepareOffTimeCreditLine(CIPSCreditEntry: Record "33019814"; BatchIDCode: Code[20]): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        CIPSCreditEntry.CALCFIELDS("Batch Count");
        data := OpenCurlyBracket;
        data += nchlIpsBatchDetail + InnerOpenCurlyBracket;
        data += batchId + '"' + BatchIDCode + '"' + Comma;
        data += batchAmount + '"' + RemoveComma(FORMAT(CIPSCreditEntry."Credit Amount")) + '"' + Comma;
        data += batchCount + '"' + FORMAT(CIPSCreditEntry."Batch Count") + '"' + Comma;
        data += batchCrncy + '"' + "Batch Currency" + '"' + Comma;
        data += categoryPurpose + '"' + "Category Purpose" + '"' + Comma;
        data += debtorAgent + '"' + Agent + '"' + Comma;
        data += debtorBranch + '"' + Branch + '"' + Comma;
        data += debtorName + '"' + Name + '"' + Comma;
        data += debtorAccount + '"' + "Bank Account No." + '"' + Comma;
        data += debtorIdType + '"' + "ID Type" + '"' + Comma;
        data += debtorIdValue + '"' + "ID Value" + '"' + Comma;
        data += debtorAddress + '"' + Address + '"' + Comma;
        data += debtorPhone + '"' + Phone + '"' + Comma;
        data += debtorMobile + '"' + Mobile + '"' + Comma;
        data += debtorEmail + '"' + Email + '"';
        data += CloseCurlyBracket + Comma;
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure PrepareOffTimeDebitLine(CIPSDebitEntry: Record "33019814"): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        //data := nchlIpsTransactionDetailList + '[{';
        data := '{';
        data += instructionId + '"' + "Batch ID" + '-' + FORMAT(CIPSDebitEntry."Line No.") + '"' + Comma;
        data += endToEndId + '"' + CIPSDebitEntry."Document No." + '"' + Comma;
        data += creditamount + '"' + RemoveComma(FORMAT(CIPSDebitEntry."Debit Amount")) + '"' + Comma;
        data += creditorAgent + '"' + Agent + '"' + Comma;
        data += creditorBranch + '"' + Branch + '"' + Comma;
        data += creditorName + '"' + Name + '"' + Comma;
        data += creditorAccount + '"' + "Bank Account No." + '"' + Comma;
        data += creditorIdType + '"' + "ID Type" + '"' + Comma;
        data += creditorIdValue + '"' + "ID Value" + '"' + Comma;
        data += creditorAddress + '"' + Address + '"' + Comma;
        data += creditorPhone + '"' + Phone + '"' + Comma;
        data += creditorMobile + '"' + Mobile + '"' + Comma;
        data += creditorEmail + '"' + Email + '"' + Comma;
        data += addenda1 + '"' + FORMAT("Addenda 1") + '"' + Comma;
        data += addenda2 + '"' + FORMAT("Addenda 2") + '"' + Comma;
        data += addenda3 + '"' + "Addenda 3" + '"' + Comma;
        data += addenda4 + '"' + "Addenda 4" + '"';
        data += '}';
        //data += '}]' + Comma;
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure StartRealTimeCIPSIntegration(BatchNo: Code[20])
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        FinalTransString: Text;
        Debtor: Record "33019814";
        ResponseCode: Text;
        CurrBatchID: Code[20];
        PrevBatchID: Code[20];
        BatchCIPSEntry: Record "33019814";
        BatchCountInt: Integer;
        AgentSame: Boolean;
        JSONResponseText: DotNet String;
        VoucherCount: Integer;
        OTP: Code[10];
        NPIEntry: Record "33019814";
    begin
        IF CIPSEnabled AND NCHLNPIIntegrationEnabled THEN BEGIN
            CIPSSetup.GET;
            CheckCIPSSetup;
            OTP := '';
            CIPSEntry.RESET;
            CIPSEntry.SETRANGE("Document No.", BatchNo);
            CIPSEntry.FINDFIRST;
            CIPSEntry.CALCFIELDS("Batch Count");
            CIPSEntry.CALCFIELDS("Voucher Count");
            BatchCountInt := CIPSEntry."Batch Count";
            VoucherCount := CIPSEntry."Voucher Count";
            IF CIPSSetup."Use OTP Authentication" THEN BEGIN
                IF CIPSEntry."OTP Code" = '' THEN
                    ERROR('Please send otp for authentication.');
                OTP := CIPSEntry."OTP Code";
                CLEAR(OTPPageBuilder);
                OTPPageBuilder.ADDRECORD(OTPText, NPIEntry);
                OTPPageBuilder.ADDFIELD(OTPText, NPIEntry."OTP Code");
                OTPPageBuilder.RUNMODAL;
                NPIEntry.SETVIEW(OTPPageBuilder.GETVIEW(OTPText));
                EnteredOTP := NPIEntry.GETFILTER("OTP Code");
                IF EnteredOTP <> OTP THEN
                    ERROR('Entered OTP does not reconcile with generated OTP.');

                IF ClearOTPAfterExpired(BatchNo, EnteredOTP) THEN BEGIN   //Sameer to clear OTP Code after expiration
                    MESSAGE('OTP Expired.Please Generate new OTP for the Document No %1.', BatchNo);
                    EXIT;
                END;
            END;
            IF VoucherCount > 1 THEN BEGIN
                CIPSEntry.RESET;
                CIPSEntry.SETRANGE("Document No.", BatchNo);
                CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Real Time");
                CIPSEntry.SETRANGE(Type, CIPSEntry.Type::Creditor);
                IF CIPSEntry.FINDFIRST THEN
                    REPEAT
                        //get debtor info
                        Debtor.RESET;
                        Debtor.SETRANGE("Batch ID", CIPSEntry."Batch ID");
                        Debtor.SETRANGE(Type, Debtor.Type::Debtor);
                        Debtor.SETRANGE("Transaction Type", CIPSEntry."Transaction Type");
                        Debtor.FINDFIRST;
                        DebitData := PrepareRealTimeCreditLine(Debtor);
                        BatchString := CIPSWebService.BatchString(Debtor."Batch ID", Debtor.Agent, Debtor.Branch,
                                                                  Debtor."Bank Account No.", RemoveComma(FORMAT(Debtor."Credit Amount")),
                                                                  Debtor."Batch Currency", '', TRUE);

                        //creditor line
                        CreditData := PrepareRealTimeDebitLine(CIPSEntry);
                        TransactionString := CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                RemoveComma(FORMAT(CIPSEntry."Debit Amount")));

                        FinalTransString := TransactionString;
                        MessageDigestToken := token;
                        MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + FinalTransString + Comma
                                                                                + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';
                        JsonTransactionDetailString := cipsTransactionDetailList + '[' + CreditData + ']' + Comma;
                        FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
                        MESSAGE(FORMAT(FinalData)); //13
                        CIPSWebService.PushRealTimeVoucher(FinalData, JSONResponseText);
                        MESSAGE(JSONResponseText.ToString);
                        InsertNCHLLog(JSONResponseText, Debtor."Document No.", FinalData);//23
                        ParsePostNCHLNPIJsonResponse(JSONResponseText, CIPSEntry."Batch ID", TRUE);

                    UNTIL CIPSEntry.NEXT = 0;

            END ELSE BEGIN // only batch count is 1
                CIPSEntry.RESET;
                CIPSEntry.SETRANGE("Document No.", BatchNo);
                CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Real Time");
                IF CIPSEntry.FINDFIRST THEN
                    REPEAT
                        IF CIPSEntry.Type = CIPSEntry.Type::Debtor THEN BEGIN
                            DebitData := PrepareRealTimeCreditLine(CIPSEntry);
                            BatchString := CIPSWebService.BatchString(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                                    CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Credit Amount")),
                                                                    CIPSEntry."Batch Currency", '', TRUE);
                        END ELSE
                            IF CIPSEntry.Type = CIPSEntry.Type::Creditor THEN BEGIN
                                CreditData := PrepareRealTimeDebitLine(CIPSEntry);
                                TransactionString := CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                      CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                      RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                            END;
                    UNTIL CIPSEntry.NEXT = 0;
                FinalTransString := TransactionString;
                MessageDigestToken := token;
                MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + FinalTransString + Comma +
                                                                        CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

                JsonTransactionDetailString := cipsTransactionDetailList + '[' + CreditData + ']' + Comma;
                FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
                MESSAGE(FORMAT(FinalData)); //13
                CIPSWebService.PushRealTimeVoucher(FinalData, JSONResponseText);
                MESSAGE(JSONResponseText.ToString);
                InsertNCHLLog(JSONResponseText, Debtor."Document No.", FinalData);//23
                ParsePostNCHLNPIJsonResponse(JSONResponseText, CIPSEntry."Batch ID", TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure StarNonRealTimeCIPSIntegration(BatchNo: Code[20])
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        Debtor: Record "33019814";
        ResponseCode: Text;
        JSONResponseText: DotNet String;
        BatchCountInt: Integer;
        NPIEntry: Record "33019814";
    begin
        IF CIPSEnabled THEN BEGIN
            CIPSSetup.GET;
            CheckCIPSSetup;


            CIPSEntry.RESET;
            CIPSEntry.SETRANGE("Document No.", BatchNo);
            CIPSEntry.FINDFIRST;
            CIPSEntry.CALCFIELDS("Batch Count");
            BatchCountInt := CIPSEntry."Batch Count";

            IF CIPSSetup."Use OTP Authentication" THEN BEGIN
                IF CIPSEntry."OTP Code" = '' THEN
                    ERROR('Please send otp for authentication.');
                OTP := CIPSEntry."OTP Code";
                CLEAR(OTPPageBuilder);
                OTPPageBuilder.ADDRECORD(OTPText, NPIEntry);
                OTPPageBuilder.ADDFIELD(OTPText, NPIEntry."OTP Code");
                OTPPageBuilder.RUNMODAL;
                NPIEntry.SETVIEW(OTPPageBuilder.GETVIEW(OTPText));
                EnteredOTP := NPIEntry.GETFILTER("OTP Code");
                IF EnteredOTP <> OTP THEN
                    ERROR('Entered OTP does not reconcile with assigned OTP.');

                IF ClearOTPAfterExpired(BatchNo, EnteredOTP) THEN BEGIN   //Sameer to clear OTP Code after expiration
                    MESSAGE('OTP Expired.Please Generate new OTP for the Document No %1.', BatchNo);
                    EXIT;
                END;

            END;

            CIPSEntry.RESET;
            CIPSEntry.SETCURRENTKEY("Document No.", "Posting Date");
            CIPSEntry.SETRANGE("Document No.", BatchNo);
            CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Non-Real Time");
            IF CIPSEntry.FINDFIRST THEN
                REPEAT
                    IF CIPSEntry."Credit Amount" > 0 THEN BEGIN
                        DebitData := PrepareOffTimeCreditLine(CIPSEntry, CIPSEntry."Batch ID"); //to pass same batch ID
                        BatchString := CIPSWebService.BatchString(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                                  CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Credit Amount")), CIPSEntry."Batch Currency",
                                                                  CIPSEntry."Category Purpose", FALSE);
                    END;
                    IF CIPSEntry."Debit Amount" > 0 THEN BEGIN
                        IF count_int = 2 THEN BEGIN
                            CreditData := PrepareOffTimeDebitLine(CIPSEntry);
                            TransactionString := CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                  CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                  RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                        END ELSE BEGIN
                            //concatenate multiple credit line data
                            IF CreditData = '' THEN
                                CreditData := PrepareOffTimeDebitLine(CIPSEntry)
                            ELSE
                                CreditData += Comma + PrepareOffTimeDebitLine(CIPSEntry);

                            //concatenate multiple transaction detail
                            IF TransactionString = '' THEN BEGIN
                                TransactionString := CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                     CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                     RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                            END ELSE BEGIN
                                TransactionString += Comma + CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                    CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                    RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                            END;

                        END;
                    END;
                UNTIL CIPSEntry.NEXT = 0;

            MessageDigestToken := token;
            MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + TransactionString + Comma
                                                                    + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';
            JsonTransactionDetailString := nchlIpsTransactionDetailList + '[' + CreditData + ']' + Comma;
            FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
            //MESSAGE(FinalData);
            CIPSWebService.PushNonRealTimeTimeVoucher(FinalData, JSONResponseText);
            InsertNCHLLog(JSONResponseText, BatchNo, FinalData);//23
            ParsePostNCHLNPIJsonResponse(JSONResponseText, BatchNo, FALSE);
        END;
    end;

    [Scope('Internal')]
    procedure UpdateCIPSTransaction(CIPSTransactionEntry: Record "33019814")
    var
        RequestMessage: Text;
        IsRealTime: Boolean;
        StatusCode: Text;
        StatusDescription: Text[250];
        JSONResponseText: DotNet String;
    begin
        RequestMessage := '';
        StatusCode := '';
        StatusDescription := '';
        //IF "Sync. Status" = "Sync. Status"::Completed THEN
        //EXIT;
        IF "Transaction Type" = "Transaction Type"::"Real Time" THEN
            IsRealTime := TRUE
        ELSE
            IsRealTime := FALSE;
        CASE CIPSTransactionEntry.Type OF
            CIPSTransactionEntry.Type::Debtor:
                BEGIN
                    RequestMessage := OpenCurlyBracket;
                    RequestMessage += batchId + '"' + "Batch ID" + '"';
                    RequestMessage += CloseCurlyBracket;
                    CIPSWebService.GetTransactionUpdateFromReportingAPIs(RequestMessage, IsRealTime, CIPSTransactionEntry.Type, JSONResponseText);
                    ParseJsonResponseArrayAndUpdateTransaction(JSONResponseText, CIPSTransactionEntry);
                    IF (CIPSTransactionEntry."Sync. Status" <> CIPSTransactionEntry."Sync. Status"::Completed) AND (CIPSTransactionEntry."Transaction Charge Amount" <> 0) THEN
                        CIPSTransactionEntry."Transaction Charge Amount" := 0;
                    CIPSTransactionEntry.MODIFY(TRUE); //value will be changed in above function so modify
                END;
            CIPSTransactionEntry.Type::Creditor:
                BEGIN
                    RequestMessage := OpenCurlyBracket;
                    RequestMessage += batchId + '"' + "Batch ID" + '"' + Comma;
                    RequestMessage += instructionId + '"' + "Batch ID" + '-' + FORMAT(CIPSTransactionEntry."Line No.") + '"';
                    RequestMessage += CloseCurlyBracket;
                    CIPSWebService.GetTransactionUpdateFromReportingAPIs(RequestMessage, IsRealTime, CIPSTransactionEntry.Type, JSONResponseText);
                    ParseJsonResponseArrayAndUpdateTransaction(JSONResponseText, CIPSTransactionEntry);
                    IF (CIPSTransactionEntry."Sync. Status" <> CIPSTransactionEntry."Sync. Status"::Completed) AND (CIPSTransactionEntry."Transaction Charge Amount" <> 0) THEN
                        CIPSTransactionEntry."Transaction Charge Amount" := 0;
                    CIPSTransactionEntry.MODIFY(TRUE); //value will be changed in above function so modify
                END;
        END;
    end;

    local procedure RemoveComma(StringValue: Text): Text
    begin
        EXIT(DELCHR(StringValue, '=', Comma));
    end;

    [Scope('Internal')]
    procedure ParseJsonResponseArrayAndUpdateTransaction(JSONResponseText: DotNet String; var NCHLNPIEntry: Record "33019814")
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
        debitStatus: Label 'debitStatus';
        debitReasonDesc: Label 'debitReasonDesc';
        batchChargeAmount: Label 'batchChargeAmount';
        txnResponse: Label 'txnResponse';
        creditStatus: Label 'creditStatus';
        chargeAmount: Label 'chargeAmount';
        creditReasonDesc: Label 'reasonDesc';
        NCHLNPICategoryPurpose: Record "33019812";
        TxnChargeAmt: Decimal;
        NCHLNPISetup: Record "33019810";
        JObject: DotNet JObject;
        NCHLNPIWS: Codeunit "33019811";
        ipsBatchId: Label 'ipsBatchId';
        ipsTxnId: Label 'ipsTxnId';
        ACTC: Label 'ACTC';
        ACSP: Label 'ACSP';
        ACSC: Label 'ACSC';
        RJCT: Label 'RJCT';
        ACTCText: Label 'Accepted Technical Validation';
        ACSPText: Label 'Accepted Settlement In Process';
        ACSCText: Label 'Accepted Settlement Completed';
        RJCTText: Label 'Credit Rejected';
        recDate: Label 'recDate';
        PaymentDate: Date;
        txtMyDate: Text;
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        /*PrefixArray := PrefixArray.CreateInstance(GETDOTNETTYPE(JSONResponseText),250);
        StringReader := StringReader.StringReader(JSONResponseText);
        JsonTextReader := JsonTextReader.JsonTextReader(StringReader);
        ActualLineNumber := 1;
        TempLineNumber := 0;
        TempPostingExchField.DELETEALL;
        WHILE JsonTextReader.Read DO BEGIN
          CASE TRUE OF
            JsonTextReader.TokenType.CompareTo(JSonToken.StartObject) = 0 : TempLineNumber += 1;
        
            JsonTextReader.TokenType.CompareTo(JSonToken.StartArray) = 0 : BEGIN
              InArray[JsonTextReader.Depth + 1] := TRUE;
              ColumnNo := 0;
              ArrayDepth += 1;
            END;
            JsonTextReader.TokenType.CompareTo(JSonToken.StartConstructor) = 0 : BEGIN
            END;
        
            JsonTextReader.TokenType.CompareTo(JSonToken.PropertyName) = 0 : BEGIN
              PrefixArray.SetValue(JsonTextReader.Value,JsonTextReader.Depth - ArrayDepth);
              IF JsonTextReader.Depth > 1 THEN BEGIN
                //PrefixString := PrefixString.Join('.',PrefixArray,0,JsonTextReader.Depth - ArrayDepth);
                PrefixString := PrefixString.Join('',PrefixArray,0,JsonTextReader.Depth - ArrayDepth);
                IF PrefixString.Length > 0 THEN
                  PropertyName := PrefixString.ToString + '.' + FORMAT(JsonTextReader.Value,0,9)
                ELSE
                  PropertyName := FORMAT(JsonTextReader.Value,0,9);
              END ELSE PropertyName := FORMAT(JsonTextReader.Value,0,9);
            END;
        
            (JsonTextReader.TokenType.CompareTo(JSonToken.String) = 0) OR
            (JsonTextReader.TokenType.CompareTo(JSonToken.Integer) = 0) OR
            (JsonTextReader.TokenType.CompareTo(JSonToken.Float) = 0) OR
            (JsonTextReader.TokenType.CompareTo(JSonToken.Boolean) = 0) OR
            (JsonTextReader.TokenType.CompareTo(JSonToken.Date) = 0) OR
            (JsonTextReader.TokenType.CompareTo(JSonToken.Bytes) = 0) :
            BEGIN
              //NewValue := FORMAT(JsonTextReader.Value,0,9);
              TempPostingExchField."Data Exch. No." := JsonTextReader.Depth;
              TempPostingExchField."Line No." := ActualLineNumber;
              TempPostingExchField."Column No." := ColumnNo;
              TempPostingExchField."Node ID" := PropertyName;
              TempPostingExchField.Value := FORMAT(JsonTextReader.Value,0,9);
              TempPostingExchField."Data Exch. Line Def Code" := JsonTextReader.TokenType.ToString;
              TempPostingExchField.INSERT;
            END;
        
            JsonTextReader.TokenType.CompareTo(JSonToken.EndConstructor) = 0 : BEGIN
               LineNo += 1;
            END;
        
            JsonTextReader.TokenType.CompareTo(JSonToken.EndArray) = 0 :BEGIN
              InArray[JsonTextReader.Depth + 1] := FALSE;
              ArrayDepth -= 1;
            END;
        
            JsonTextReader.TokenType.CompareTo(JSonToken.EndObject) = 0 :BEGIN
              TempLineNumber -=1;
              IF TempLineNumber = 0 THEN BEGIN
                ActualLineNumber += 1;
              END;
              IF JsonTextReader.Depth > 0 THEN
                IF InArray[JsonTextReader.Depth] THEN
                  ColumnNo += 1;
            END;
          END;
        END;
        
        //update response from parsed data from table data exchange table
        CIPSSetup.GET;
        CIPSSetup.TESTFIELD("Success Status Code");
        NCHLNPICategoryPurpose.GET(NCHLNPIEntry."Category Purpose");
        
        TempPostingExchField.RESET;
        IF TempPostingExchField.FINDFIRST THEN REPEAT
          IF (NCHLNPIEntry.Type = NCHLNPIEntry.Type::Debtor) THEN BEGIN
            IF TempPostingExchField."Node ID" = debitStatus THEN
              NCHLNPIEntry."Status Code" := TempPostingExchField.Value;
        
            IF TempPostingExchField."Node ID" = debitReasonDesc THEN
              NCHLNPIEntry."Status Description" := TempPostingExchField.Value;
        
            IF (TempPostingExchField."Node ID" = txnResponse)  THEN
              NCHLNPIEntry."Transaction Response" := TempPostingExchField.Value;
        
            IF CIPSSetup."Success Status Code" = NCHLNPIEntry."Status Code" THEN
              NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
            ELSE
              NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";
        
            IF (TempPostingExchField."Node ID" = batchChargeAmount) AND
               (NCHLNPICategoryPurpose."Charge Bearer" = NCHLNPICategoryPurpose."Charge Bearer"::Sender) THEN BEGIN
        
               EVALUATE(TxnChargeAmt,TempPostingExchField.Value);
        
               NCHLNPIEntry."Transaction Charge Amount" := TxnChargeAmt;
            END;
          END ELSE IF NCHLNPIEntry.Type = NCHLNPIEntry.Type::Creditor THEN BEGIN
            IF TempPostingExchField."Node ID" = creditStatus THEN
              NCHLNPIEntry."Status Code" := TempPostingExchField.Value;
        
            IF TempPostingExchField."Node ID" = creditReasonDesc THEN
              NCHLNPIEntry."Status Description" := TempPostingExchField.Value;
        
            IF (TempPostingExchField."Node ID" = txnResponse)  THEN
              NCHLNPIEntry."Transaction Response" := TempPostingExchField.Value;
        
            IF CIPSSetup."Success Status Code" = NCHLNPIEntry."Status Code" THEN
              NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
            ELSE
              NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";
            IF (TempPostingExchField."Node ID" = chargeAmount) AND
               (NCHLNPICategoryPurpose."Charge Bearer" = NCHLNPICategoryPurpose."Charge Bearer"::Receiver) THEN BEGIN
        
               EVALUATE(TxnChargeAmt,TempPostingExchField.Value);
        
               NCHLNPIEntry."Transaction Charge Amount" := TxnChargeAmt;
            END;
          END;
        UNTIL TempPostingExchField.NEXT = 0;*/

        CLEAR(NCHLNPIWS);
        NCHLNPISetup.GET;
        NCHLNPISetup.TESTFIELD("Success Status Code");
        NCHLNPICategoryPurpose.GET(NCHLNPIEntry."Category Purpose");
        JObject := JObject.Parse(JSONResponseText);
        IF NCHLNPIEntry.Type = NCHLNPIEntry.Type::Debtor THEN BEGIN
            NCHLNPIEntry."NCHL-NPI Batch ID" := FORMAT(JObject.GetValue(ipsBatchId));
            NCHLNPIEntry."NCHL-NPI Txn ID" := FORMAT(JObject.GetValue(ipsTxnId));
            NCHLNPIEntry."Status Code" := FORMAT(JObject.GetValue(debitStatus));
            NCHLNPIEntry."Status Description" := FORMAT(JObject.GetValue(debitReasonDesc));
            NCHLNPIEntry."Transaction Response" := FORMAT(JObject.GetValue(txnResponse));
            txtMyDate := FORMAT(JObject.GetValue(recDate)); //Min ** For access payment date from NCHL.
            EVALUATE(Day, COPYSTR(txtMyDate, 9, 2));
            EVALUATE(Month, COPYSTR(txtMyDate, 6, 2));
            EVALUATE(Year, COPYSTR(txtMyDate, 1, 4));
            NCHLNPIEntry."Payment Date" := DMY2DATE(Day, Month, Year);//>>
            IF NCHLNPISetup."Success Status Code" = NCHLNPIEntry."Status Code" THEN
                NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
            ELSE
                NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";

            IF NCHLNPICategoryPurpose."Charge Bearer" = NCHLNPICategoryPurpose."Charge Bearer"::Sender THEN BEGIN
                NCHLNPIEntry."Transaction Charge Amount" := NCHLNPIWS.GetValueAsInteger(JObject, batchChargeAmount);
            END;
            NCHLNPIEntry.MODIFY(TRUE);
        END ELSE
            IF NCHLNPIEntry.Type = NCHLNPIEntry.Type::Creditor THEN BEGIN
                NCHLNPIEntry."NCHL-NPI Batch ID" := FORMAT(JObject.GetValue(ipsBatchId));
                NCHLNPIEntry."NCHL-NPI Txn ID" := FORMAT(JObject.GetValue(ipsTxnId));
                NCHLNPIEntry."Status Code" := FORMAT(JObject.GetValue(creditStatus));
                NCHLNPIEntry."Status Description" := FORMAT(JObject.GetValue(creditReasonDesc));
                NCHLNPIEntry."Transaction Response" := FORMAT(JObject.GetValue(txnResponse));
                txtMyDate := FORMAT(JObject.GetValue(recDate));//Min ** For access payment date from NCHL.
                EVALUATE(Day, COPYSTR(txtMyDate, 9, 2));
                EVALUATE(Month, COPYSTR(txtMyDate, 6, 2));
                EVALUATE(Year, COPYSTR(txtMyDate, 1, 4));
                NCHLNPIEntry."Payment Date" := DMY2DATE(Day, Month, Year);//>>
                CASE NCHLNPIEntry."Status Code" OF
                    ACTC:
                        BEGIN
                            NCHLNPIEntry."Status Description" := ACTCText;
                            NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";
                        END;
                    ACSP:
                        BEGIN
                            NCHLNPIEntry."Status Description" := ACSPText;
                            NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";
                        END;
                    ACSC:
                        BEGIN
                            NCHLNPIEntry."Status Description" := ACSCText;
                            NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed;
                        END;
                    RJCT:
                        BEGIN
                            NCHLNPIEntry."Status Description" := RJCTText;
                            NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";
                        END;
                    NCHLNPISetup."Success Status Code":
                        BEGIN
                            NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed;
                        END;
                    ELSE
                        NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";
                END;

                IF NCHLNPICategoryPurpose."Charge Bearer" = NCHLNPICategoryPurpose."Charge Bearer"::Receiver THEN BEGIN
                    EVALUATE(TxnChargeAmt, FORMAT(JObject.GetValue(chargeAmount)));
                    NCHLNPIEntry."Transaction Charge Amount" := TxnChargeAmt;
                END;
                NCHLNPIEntry.MODIFY(TRUE);
                IF (NCHLNPIEntry."Sync. Status" = NCHLNPIEntry."Sync. Status"::Completed) AND (NOT NCHLNPIEntry."Balance Transfer Notified") THEN
                    SendBalanceTransferMailNotification(NCHLNPIEntry);

            END;

    end;

    [Scope('Internal')]
    procedure SetUpdateCIPSTransactionBool(NewUpdateTransaction: Boolean; NewNCHLNPIEntry: Record "33019814")
    begin
        UpdateTransaction := NewUpdateTransaction;
        NCHLNPIEntry := NewNCHLNPIEntry
    end;

    [Scope('Internal')]
    procedure SendJournalApprovalRequest(TemplateName: Code[10]; BatchName: Code[10]; DocumentNo: Code[20])
    var
        GenJnlLine: Record "81";
        ApprovalEntry: Record "454";
        NCHLNPIApprovalWorkflow: Record "33019815";
        NCHLNPIWorkflowUserGroups: Record "33019816";
        TotalDebitAmt: Decimal;
        TotalCreditAmt: Decimal;
        EntryNo: Integer;
        ApprovalEntry2: Record "454";
        GLEntry: Record "17";
        DimMgt: Codeunit "408";
        TableID: array[10] of Integer;
        AccNo: array[10] of Code[20];
        VendPostingGr: Record "93";
        BankAccPostingGr: Record "277";
        Bank: Record "270";
        NCHLNPIEntry: Record "33019814";
        SenderName: Text;
        ReceiverName: Text;
        Vendor: Record "23";
    begin
        IF NOT CONFIRM(SendApprovalRequestConfirm, FALSE) THEN
            EXIT;

        TotalDebitAmt := 0;
        TotalCreditAmt := 0;

        CIPSSetup.GET;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
        GenJnlLine.SETRANGE("Document No.", DocumentNo);
        IF GenJnlLine.FINDFIRST THEN
            REPEAT
                GenJnlLine.TESTFIELD(Status, GenJnlLine.Status::Open);
                IF GenJnlLine."Debit Amount" > 0 THEN
                    IF GenJnlLine."Debit Amount" > CIPSSetup."Per Transaction Limit" THEN
                        ERROR(PerTransactionLimitExceedErr, CIPSSetup."Per Transaction Limit", GenJnlLine."Debit Amount" - CIPSSetup."Per Transaction Limit");

                IF GenJnlLine.Amount = 0 THEN
                    ERROR(AmountZeroErr, GenJnlLine."Line No.");
                GenJnlLine.TESTFIELD("CIPS Category Purpose");
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                    //NPI-DOCS1.00
                    Vendor.GET(GenJnlLine."Account No.");
                    IF Vendor."App Id" <> '' THEN BEGIN
                        GenJnlLine.TESTFIELD("Registration No.");
                        GenJnlLine.TESTFIELD("Registration Year");
                    END ELSE
                        //NPI-DOCS1.00
                        GenJnlLine.TESTFIELD("Bank Account Code");
                END;
                IF GenJnlLine."Bal. Account No." = '' THEN BEGIN
                    IF GenJnlLine."Amount (LCY)" > 0 THEN
                        TotalDebitAmt += GenJnlLine."Amount (LCY)"
                    ELSE
                        TotalCreditAmt += GenJnlLine."Amount (LCY)";
                END
                ELSE BEGIN
                    TotalDebitAmt += GenJnlLine."Amount (LCY)";
                    TotalCreditAmt += GenJnlLine."Amount (LCY)" * -1;
                END;


                //check dimension >>
                IF (GenJnlLine."Account Type" IN [
                   GenJnlLine."Account Type"::Vendor, GenJnlLine."Account Type"::"Bank Account",
                   GenJnlLine."Account Type"::"G/L Account"]) THEN BEGIN
                    TableID[1] := DimMgt.TypeToTableID1(GenJnlLine."Account Type");
                    AccNo[1] := GenJnlLine."Account No.";
                    IF NOT DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") THEN
                        ERROR(DimMgt.GetDimValuePostingErr);

                    CASE GenJnlLine."Account Type" OF
                        GenJnlLine."Account Type"::"Bank Account":
                            BEGIN
                                Bank.GET(GenJnlLine."Account No.");
                                BankAccPostingGr.GET(Bank."Bank Acc. Posting Group");
                                TableID[1] := DimMgt.TypeToTableID1(GenJnlLine."Account Type"::"G/L Account");
                                AccNo[1] := BankAccPostingGr."G/L Bank Account No.";
                                IF NOT DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") THEN
                                    ERROR(DimMgt.GetDimValuePostingErr);
                            END;
                        GenJnlLine."Account Type"::Vendor:
                            BEGIN
                                VendPostingGr.GET(GenJnlLine."Posting Group");
                                TableID[1] := DimMgt.TypeToTableID1(GenJnlLine."Account Type"::"G/L Account");
                                AccNo[1] := VendPostingGr."Payables Account";
                                IF NOT DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") THEN
                                    ERROR(DimMgt.GetDimValuePostingErr);
                            END;
                    END;
                END;
            //check dimension <<
            UNTIL GenJnlLine.NEXT = 0;


        NCHLNPIEntry.RESET;
        NCHLNPIEntry.SETRANGE("Source Code", GenJnlLine."Source Code");
        NCHLNPIEntry.SETRANGE("Posting Date", TODAY);
        NCHLNPIEntry.CALCSUMS("Credit Amount");
        IF NCHLNPIEntry."Credit Amount" + TotalCreditAmt > CIPSSetup."Per Day Total Trans. Limit" THEN
            ERROR(PerDayTransactionLimitExceededErr, CIPSSetup."Per Day Total Trans. Limit", (NCHLNPIEntry."Credit Amount" + TotalCreditAmt -
                   CIPSSetup."Per Day Total Trans. Limit"));

        IF TotalDebitAmt <> ABS(TotalCreditAmt) THEN
            ERROR(InconsistentErr, TotalDebitAmt, TotalCreditAmt);

        IF TotalCreditAmt <> 0 THEN BEGIN  //ankur
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
            GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
            GenJnlLine.SETRANGE("Document No.", DocumentNo);
            //GenJnlLine.SETFILTER("Credit Amount",'<>%1',0);
            IF GenJnlLine.FINDFIRST THEN BEGIN
                SenderName := GetSenderName(DocumentNo, TemplateName, BatchName);
                ReceiverName := GetReceiverName(DocumentNo, TemplateName, BatchName);

                NCHLNPIApprovalWorkflow.RESET;
                NCHLNPIApprovalWorkflow.SETRANGE("Source Code", GenJnlLine."Source Code");
                NCHLNPIApprovalWorkflow.FINDFIRST;
                NCHLNPIWorkflowUserGroups.SETCURRENTKEY(Sequence);
                NCHLNPIWorkflowUserGroups.RESET;
                NCHLNPIWorkflowUserGroups.SETRANGE("Approval Code", NCHLNPIApprovalWorkflow.Code);
                IF NCHLNPIWorkflowUserGroups.FINDFIRST THEN BEGIN
                    REPEAT
                        ApprovalEntry.RESET;
                        IF ApprovalEntry.FINDLAST THEN
                            EntryNo := ApprovalEntry."Entry No." + 1
                        ELSE
                            EntryNo := 1;

                        ApprovalEntry.INIT;
                        ApprovalEntry."Entry No." := EntryNo;
                        ApprovalEntry."Table ID" := DATABASE::"Gen. Journal Line";
                        ApprovalEntry."Document Type" := ApprovalEntry."Document Type"::" ";
                        ApprovalEntry."Document No." := GenJnlLine."Document No.";
                        ApprovalEntry."Sequence No." := NCHLNPIWorkflowUserGroups.Sequence;
                        ApprovalEntry."Approval Code" := NCHLNPIApprovalWorkflow.Code;
                        ApprovalEntry."Sender ID" := USERID;
                        ApprovalEntry."Approver ID" := NCHLNPIWorkflowUserGroups."User ID";

                        ApprovalEntry2.RESET;
                        ApprovalEntry2.SETRANGE("Document No.", DocumentNo);
                        ApprovalEntry2.SETRANGE(Status, ApprovalEntry2.Status::Open);
                        IF ApprovalEntry2.FINDFIRST THEN BEGIN
                            ApprovalEntry2.SETRANGE("Sequence No.", ApprovalEntry."Sequence No.");
                            IF ApprovalEntry2.FINDFIRST THEN
                                ApprovalEntry.Status := ApprovalEntry2.Status
                            ELSE
                                ApprovalEntry.Status := ApprovalEntry.Status::Created
                        END ELSE
                            ApprovalEntry.Status := ApprovalEntry.Status::Open;

                        ApprovalEntry."Date-Time Sent for Approval" := CURRENTDATETIME;
                        ApprovalEntry.Amount := GenJnlLine.Amount;
                        //ApprovalEntry.Amount := GenJnlLine."Credit Amount";
                        ApprovalEntry."Amount (LCY)" := GenJnlLine."Credit Amount";
                        ApprovalEntry."Record ID to Approve" := GenJnlLine.RECORDID;
                        ApprovalEntry."Journal Template Name" := GenJnlLine."Journal Template Name";
                        ApprovalEntry."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                        ApprovalEntry."Sender Name" := SenderName;
                        ApprovalEntry."Receiver Name" := ReceiverName;
                        ApprovalEntry.INSERT;
                    UNTIL NCHLNPIWorkflowUserGroups.NEXT = 0;
                END;
            END;
        END;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
        GenJnlLine.SETRANGE("Document No.", DocumentNo);
        GenJnlLine.MODIFYALL(Status, GenJnlLine.Status::"Pending Approval");
        SendApprovalWorkflowMailNotification(1, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.");
        MESSAGE(ApprovalRequestSentMsg);
    end;

    [Scope('Internal')]
    procedure CancelJournalApprovalRequest(TemplateName: Code[10]; BatchName: Code[10]; DocumentNo: Code[20])
    var
        GenJnlLine: Record "81";
        ApprovalEntry: Record "454";
    begin
        IF NOT CONFIRM(CancelApprovalRequestConfirm, FALSE) THEN
            EXIT;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
        GenJnlLine.SETRANGE("Document No.", DocumentNo);
        IF GenJnlLine.FINDFIRST THEN
            GenJnlLine.TESTFIELD(Status, GenJnlLine.Status::"Pending Approval");
        GenJnlLine.MODIFYALL(Status, GenJnlLine.Status::Open);

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Journal Template Name", TemplateName);
        ApprovalEntry.SETRANGE("Journal Batch Name", BatchName);
        ApprovalEntry.SETRANGE("Document No.", DocumentNo);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        IF ApprovalEntry.FINDFIRST THEN
            REPEAT
                ApprovalEntry.Status := ApprovalEntry.Status::Canceled;
                ApprovalEntry.MODIFY(TRUE);
            UNTIL ApprovalEntry.NEXT = 0;

        MESSAGE(ApprovalRequestCancelledMsg);
    end;

    [Scope('Internal')]
    procedure ApproveJournalApprovalRequest(TemplateName: Code[10]; BatchName: Code[10]; DocumentNo: Code[20])
    var
        GenJnlLine: Record "81";
        ApprovalEntry: Record "454";
        ApprovalEntry2: Record "454";
    begin
        IF NOT CONFIRM(ApproveJournalrequestConfirm, FALSE) THEN
            EXIT;

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Journal Template Name", TemplateName);
        ApprovalEntry.SETRANGE("Journal Batch Name", BatchName);
        ApprovalEntry.SETRANGE("Document No.", DocumentNo);
        ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Approver ID", USERID);
        IF ApprovalEntry.FINDFIRST THEN
            REPEAT
                ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                ApprovalEntry.MODIFY(TRUE);
            UNTIL ApprovalEntry.NEXT = 0;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
        GenJnlLine.SETRANGE("Document No.", DocumentNo);
        IF GenJnlLine.FINDFIRST THEN
            GenJnlLine.TESTFIELD(Status, GenJnlLine.Status::"Pending Approval");

        ApprovalEntry2.RESET;
        ApprovalEntry2.SETRANGE("Journal Template Name", TemplateName);
        ApprovalEntry2.SETRANGE("Journal Batch Name", BatchName);
        ApprovalEntry2.SETRANGE("Document No.", ApprovalEntry."Document No.");
        ApprovalEntry2.SETFILTER("Sequence No.", '>=%1', ApprovalEntry."Sequence No.");
        ApprovalEntry2.SETRANGE(Status, ApprovalEntry2.Status::Created);
        IF NOT ApprovalEntry2.FINDFIRST THEN BEGIN
            GenJnlLine.MODIFYALL(Status, GenJnlLine.Status::Approved);
            SendApprovalWorkflowMailNotification(2, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.");
        END ELSE BEGIN
            ApprovalEntry2.Status := ApprovalEntry2.Status::Open;
            ApprovalEntry2.MODIFY(TRUE);
            //get approver and sender email of previous sequence.
            SenderCCMail := GetUserIDEmail(ApprovalEntry."Sender ID");
            ApproverCCMail := GetUserIDEmail(ApprovalEntry."Approver ID");
            SendApprovalWorkflowMailNotification(1, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.");
        END;

        MESSAGE(JournalApprovedMsg);
    end;

    [Scope('Internal')]
    procedure RejectJournalApprovalRequest(TemplateName: Code[10]; BatchName: Code[10]; DocumentNo: Code[20])
    var
        GenJnlLine: Record "81";
        ApprovalEntry: Record "454";
    begin
        IF NOT CONFIRM(RejectJournalConfirm, FALSE) THEN
            EXIT;

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", TemplateName);
        GenJnlLine.SETRANGE("Journal Batch Name", BatchName);
        GenJnlLine.SETRANGE("Document No.", DocumentNo);
        IF GenJnlLine.FINDFIRST THEN
            GenJnlLine.TESTFIELD(Status, GenJnlLine.Status::"Pending Approval");
        GenJnlLine.MODIFYALL(Status, GenJnlLine.Status::Open);

        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Journal Template Name", TemplateName);
        ApprovalEntry.SETRANGE("Journal Batch Name", BatchName);
        ApprovalEntry.SETRANGE("Document No.", DocumentNo);
        ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Approver ID", USERID);
        IF ApprovalEntry.FINDFIRST THEN
            REPEAT
                ApprovalEntry.Status := ApprovalEntry.Status::Rejected;
                ApprovalEntry.MODIFY(TRUE);
                SendApprovalWorkflowMailNotification(3, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.");
            UNTIL ApprovalEntry.NEXT = 0;

        MESSAGE(JournalRejectedMsg);
    end;

    [Scope('Internal')]
    procedure SendApprovalWorkflowMailNotification(EventType: Option " ","Approval Request",Approved,Rejected; JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20])
    var
        SMTPMail: Codeunit "400";
        SMTPMailSetup: Record "409";
        MessageText: Text;
        ReceipientEmail: Text;
        Employee: Record "5200";
        ApprovalEntry: Record "454";
        EmpNotFind: Label 'Employee with user id %1 could not be found in employees. Please link the nav login id with employee.';
        MailSubject: Label 'Connect-IPS Payment Approval from NAV ERP System';
        SalutationText: Label 'Dear %1';
        Salutation: Text;
        Sir: Label 'Sir';
        Mam: Label 'Mam';
        ApprovalReqEmailMsg: Label 'Please approve the document no. %1 for making payment through connect-IPS.';
        ApprovedMailMsg: Label 'Document no. %1 has been approved for making payment through connect-IPS. You can go ahead with completing the payment transaction.';
        RejectedMailMsg: Label 'Document no. %1 has been rejected for making payment through connect-IPS. Please verify the document properly and send it';
        Regards: Label 'Regards,';
        MailSent: Boolean;
        MailApplicable: Boolean;
        FooterName: Text;
        ThankingYou: Label 'Thanking You,';
        FooterText: Text;
        SMSApplicable: Boolean;
        BothApplicable: Boolean;
        NCHLNPISetup: Record "33019810";
        SMSWebService: Codeunit "50002";
        MobilePhoneNo: Text;
        MessageID: Text;
    begin
        CLEAR(SMTPMail);
        CLEAR(SMSApplicable);
        CLEAR(MailApplicable);
        CLEAR(BothApplicable);
        SMTPMailSetup.GET;
        NCHLNPISetup.GET;
        CASE NCHLNPISetup."Notification Gateway Method" OF
            NCHLNPISetup."Notification Gateway Method"::Both:
                BEGIN
                    MailApplicable := TRUE;
                    SMSApplicable := TRUE;
                    BothApplicable := TRUE;
                END;
            NCHLNPISetup."Notification Gateway Method"::"E-Mail":
                MailApplicable := TRUE;
            NCHLNPISetup."Notification Gateway Method"::SMS:
                SMSApplicable := TRUE;
        END;

        CASE EventType OF
            EventType::"Approval Request":
                BEGIN
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
                    ApprovalEntry.SETRANGE("Journal Template Name", JournalTemplateName);
                    ApprovalEntry.SETRANGE("Journal Batch Name", JournalBatchName);
                    ApprovalEntry.SETRANGE("Document No.", DocumentNo);
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        Employee.RESET;
                        Employee.SETRANGE("User ID", ApprovalEntry."Approver ID");
                        IF NOT Employee.FINDFIRST THEN
                            ERROR(EmpNotFind, ApprovalEntry."Approver ID")
                        ELSE BEGIN
                            IF BothApplicable OR MailApplicable THEN
                                Employee.TESTFIELD("Company E-Mail");
                            IF SMSApplicable THEN BEGIN
                                IF (Employee."Mobile Phone No.1" = '') AND (Employee."Mobile Phone No.2" = '') THEN BEGIN
                                    Employee.TESTFIELD("Mobile Phone No.1");
                                    Employee.TESTFIELD("Mobile Phone No.2");
                                END;

                            END;
                            Employee.TESTFIELD(Gender);
                            IF Employee.Gender = Employee.Gender::Male THEN
                                Salutation := STRSUBSTNO(SalutationText, Sir)
                            ELSE
                                Salutation := STRSUBSTNO(SalutationText, Mam);

                            ReceipientEmail := Employee."Company E-Mail";

                            MessageText := ApprovalReqEmailMsg;
                            FooterName := ApprovalEntry."Sender ID";
                            MailApplicable := TRUE;
                        END;
                    END;
                END;
            EventType::Approved:
                BEGIN
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
                    ApprovalEntry.SETRANGE("Journal Template Name", JournalTemplateName);
                    ApprovalEntry.SETRANGE("Journal Batch Name", JournalBatchName);
                    ApprovalEntry.SETRANGE("Document No.", DocumentNo);
                    ApprovalEntry.SETRANGE("Approver ID", USERID);
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        Employee.RESET;
                        Employee.SETRANGE("User ID", ApprovalEntry."Sender ID");
                        IF NOT Employee.FINDFIRST THEN
                            ERROR(EmpNotFind, ApprovalEntry."Sender ID")
                        ELSE BEGIN
                            IF BothApplicable OR MailApplicable THEN
                                Employee.TESTFIELD("Company E-Mail");
                            IF SMSApplicable THEN BEGIN
                                IF (Employee."Mobile Phone No.1" = '') AND (Employee."Mobile Phone No.2" = '') THEN BEGIN
                                    Employee.TESTFIELD("Mobile Phone No.1");
                                    Employee.TESTFIELD("Mobile Phone No.2");
                                END;
                            END;
                            Employee.TESTFIELD(Gender);
                            Salutation := STRSUBSTNO(SalutationText, Employee.FullName);
                            ReceipientEmail := Employee."Company E-Mail";
                            MessageText := STRSUBSTNO(ApprovedMailMsg, DocumentNo);
                            FooterText := Regards;
                            FooterName := ApprovalEntry."Approver ID";
                            MailApplicable := TRUE;
                        END;
                    END;
                END;
            EventType::Rejected:
                BEGIN
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Gen. Journal Line");
                    ApprovalEntry.SETRANGE("Journal Template Name", JournalTemplateName);
                    ApprovalEntry.SETRANGE("Journal Batch Name", JournalBatchName);
                    ApprovalEntry.SETRANGE("Document No.", DocumentNo);
                    ApprovalEntry.SETRANGE("Approver ID", USERID);
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Rejected);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        Employee.RESET;
                        Employee.SETRANGE("User ID", ApprovalEntry."Sender ID");
                        IF NOT Employee.FINDFIRST THEN
                            ERROR(EmpNotFind, ApprovalEntry."Sender ID")
                        ELSE BEGIN
                            IF BothApplicable OR MailApplicable THEN
                                Employee.TESTFIELD("Company E-Mail");
                            IF SMSApplicable THEN BEGIN
                                IF (Employee."Mobile Phone No.1" = '') AND (Employee."Mobile Phone No.2" = '') THEN BEGIN
                                    Employee.TESTFIELD("Mobile Phone No.1");
                                    Employee.TESTFIELD("Mobile Phone No.2");
                                END;
                                IF (Employee."Mobile Phone No.1" = '') AND (Employee."Mobile Phone No.2" <> '') THEN
                                    MobilePhoneNo := Employee."Mobile Phone No.2"
                                ELSE
                                    IF (Employee."Mobile Phone No.2" = '') AND (Employee."Mobile Phone No.1" <> '') THEN
                                        MobilePhoneNo := Employee."Mobile Phone No.1";

                                IF MobilePhoneNo = '' THEN
                                    ERROR('Mobile Phone No. could not be found for SMS.');
                            END;
                            Employee.TESTFIELD(Gender);
                            Salutation := STRSUBSTNO(SalutationText, Employee.FullName);
                            ReceipientEmail := Employee."Company E-Mail";
                            MessageText := STRSUBSTNO(RejectedMailMsg, DocumentNo);
                            FooterText := Regards;
                            FooterName := ApprovalEntry."Approver ID";
                            MailApplicable := TRUE;
                        END;
                    END;
                END;
        END;

        IF MailApplicable OR BothApplicable THEN BEGIN
            SMTPMail.CreateMessage(ApprovalEntry."Sender ID", SMTPMailSetup."User ID", ReceipientEmail, MailSubject, '', TRUE);
            IF SenderCCMail <> '' THEN
                SMTPMail.AddCC(SenderCCMail);
            IF ApproverCCMail <> '' THEN
                SMTPMail.AddCC(ApproverCCMail);
            SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
            SMTPMail.AppendBody(Salutation);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(MessageText);
            SMTPMail.AppendBody('<br><br><br>');
            SMTPMail.AppendBody(CreateEmailBody(DocumentNo, JournalTemplateName, JournalBatchName));
            SMTPMail.AppendBody(FooterText);
            SMTPMail.AppendBody('<br>');
            SMTPMail.AppendBody(FooterName);
            SMTPMail.Send;
        END ELSE
            IF SMSApplicable THEN BEGIN
                CLEAR(SMSWebService);
                SMSWebService.SendSMS(MobilePhoneNo, MessageText, MessageID)
            END ELSE
                IF BothApplicable THEN BEGIN
                    SMTPMail.CreateMessage(ApprovalEntry."Sender ID", SMTPMailSetup."User ID", ReceipientEmail, MailSubject, '', TRUE);
                    IF SenderCCMail <> '' THEN
                        SMTPMail.AddCC(SenderCCMail);
                    IF ApproverCCMail <> '' THEN
                        SMTPMail.AddCC(ApproverCCMail);
                    SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
                    SMTPMail.AppendBody(Salutation);
                    SMTPMail.AppendBody('<br><br>');
                    SMTPMail.AppendBody(MessageText);
                    SMTPMail.AppendBody('<br><br><br>');
                    SMTPMail.AppendBody(CreateEmailBody(DocumentNo, JournalTemplateName, JournalBatchName));
                    SMTPMail.AppendBody(FooterText);
                    SMTPMail.AppendBody('<br>');
                    SMTPMail.AppendBody(FooterName);
                    SMTPMail.Send;

                    CLEAR(SMSWebService);
                    SMSWebService.SendSMS(MobilePhoneNo, MessageText, MessageID);
                END;
    end;

    [Scope('Internal')]
    procedure PostNCHLNPIEntry(var GenJnlLine: Record "81")
    var
        NCHLNPIJnl: Record "81";
        EntryNo: Integer;
        CreditorGenJnl: Record "81";
        CreditorAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        CreditorAccountNo: Code[20];
        DebitGenJnl: Record "81";
        TempGenJnlLine: Record "81" temporary;
        LineNo: Integer;
        LoopCount: Integer;
    begin

        GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJnlLine.FINDSET(TRUE, FALSE);
        NCHLNPIEntry.LOCKTABLE;

        //clear variables

        LastDocNo := '';
        LastDocumentNo := '';
        LastBatchID := '';
        BatchIDSeries := '';
        PostingNoSeriesNo := 0;
        NoOfPostingNoSeries := 0;
        CLEAR(NoSeriesMgt2);

        //find last entry no.
        NCHLNPIEntry.RESET;
        IF NCHLNPIEntry.FINDLAST THEN
            EntryNo := NCHLNPIEntry."Entry No." + 1
        ELSE
            EntryNo := 1;

        IF NOT GenJnlLine."Is From Sugg Vendor" THEN BEGIN
            //perform required operations
            IF NOT SplitEntry THEN BEGIN
                REPEAT
                    CLEAR(NCHLNPIEntry);
                    InitCIPSTransactionEntry(GenJnlLine, NCHLNPIEntry, IsRealTime, SplitEntry);
                    CheckDocumentNo(GenJnlLine, NCHLNPIEntry);
                    NCHLNPIEntry."Entry No." := EntryNo;
                    IF NCHLNPIEntry.Type = NCHLNPIEntry.Type::Creditor THEN
                        NCHLNPIEntry."Instruction ID" := NCHLNPIEntry."Batch ID" + '-' + FORMAT(NCHLNPIEntry."Line No.");
                    NCHLNPIEntry.INSERT(TRUE);
                    EntryNo += 1;
                UNTIL GenJnlLine.NEXT = 0;
            END ELSE BEGIN  //for jnl split case
                            //REPEAT
                            //get nav creditor
                CreditorGenJnl.RESET;
                CreditorGenJnl.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                CreditorGenJnl.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                CreditorGenJnl.SETRANGE("Document No.", GenJnlLine."Pre-Assigned No.");
                CreditorGenJnl.SETFILTER("Credit Amount", '>%1', 0);
                IF CreditorGenJnl.FINDFIRST THEN BEGIN
                    CreditorAccountType := CreditorGenJnl."Account Type";
                    CreditorAccountNo := CreditorGenJnl."Account No.";
                END;

                //get last line no.
                DebitGenJnl.RESET;
                DebitGenJnl.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                DebitGenJnl.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                IF DebitGenJnl.FINDLAST THEN
                    LineNo := DebitGenJnl."Line No." + 10000
                ELSE
                    LineNo := 10000;

                //get nav debtor and pass to temp. gen jnl for processing
                DebitGenJnl.RESET;
                DebitGenJnl.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                DebitGenJnl.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                DebitGenJnl.SETRANGE("Document No.", GenJnlLine."Pre-Assigned No.");
                DebitGenJnl.SETFILTER("Debit Amount", '>%1', 0);
                IF DebitGenJnl.FINDFIRST THEN BEGIN
                    REPEAT
                        //debit line
                        LoopCount += 1;
                        TempGenJnlLine := DebitGenJnl;
                        TempGenJnlLine."Document No." := 'NCHLNPI-' + FORMAT(LoopCount);
                        TempGenJnlLine.INSERT;

                        //insert temp gen jnl with same credit amount as debit gen jnl amount
                        TempGenJnlLine.INIT;
                        TempGenJnlLine."Journal Template Name" := DebitGenJnl."Journal Template Name";
                        TempGenJnlLine."Journal Batch Name" := DebitGenJnl."Journal Batch Name";
                        TempGenJnlLine."Line No." := LineNo;
                        TempGenJnlLine."Document Type" := DebitGenJnl."Document Type";
                        TempGenJnlLine."Document No." := 'NCHLNPI-' + FORMAT(LoopCount);
                        TempGenJnlLine."Document Date" := DebitGenJnl."Document Date";
                        TempGenJnlLine."Posting Date" := DebitGenJnl."Posting Date";
                        TempGenJnlLine.VALIDATE("Account Type", CreditorAccountType);
                        TempGenJnlLine.VALIDATE("Account No.", CreditorAccountNo);
                        TempGenJnlLine.VALIDATE("Credit Amount", DebitGenJnl."Debit Amount");
                        TempGenJnlLine."CIPS Category Purpose" := DebitGenJnl."CIPS Category Purpose";
                        TempGenJnlLine."Registration Year" := DebitGenJnl."Registration Year"; //PAY1.0
                        TempGenJnlLine."Registration No." := DebitGenJnl."Registration No.";
                        TempGenJnlLine."Registration Serial" := DebitGenJnl."Registration Serial";
                        TempGenJnlLine."Payment Types" := DebitGenJnl."Payment Types"; //PAY1.0
                        TempGenJnlLine."Ref Id" := DebitGenJnl."Ref Id"; //IRD
                        TempGenJnlLine."Office Code" := DebitGenJnl."Office Code"; //CIT
                        TempGenJnlLine.INSERT;
                        LineNo += 10000;
                    UNTIL DebitGenJnl.NEXT = 0;
                END;
                //insert to NCHL-NPI Entry
                TempGenJnlLine.SETCURRENTKEY("Document No.");
                IF TempGenJnlLine.FINDFIRST THEN
                    REPEAT
                        CLEAR(NCHLNPIEntry);
                        InitCIPSTransactionEntry(TempGenJnlLine, NCHLNPIEntry, IsRealTime, SplitEntry);
                        CheckDocumentNo(TempGenJnlLine, NCHLNPIEntry);
                        NCHLNPIEntry."Document No." := GenJnlLine."Document No.";
                        NCHLNPIEntry."Entry No." := EntryNo;
                        IF NCHLNPIEntry.Type = NCHLNPIEntry.Type::Creditor THEN
                            NCHLNPIEntry."Instruction ID" := NCHLNPIEntry."Batch ID" + '-' + FORMAT(NCHLNPIEntry."Line No.");
                        NCHLNPIEntry.INSERT(TRUE);
                        EntryNo += 1;
                    UNTIL TempGenJnlLine.NEXT = 0;
                //UNTIL NEXT = 0;
            END;
        END ELSE BEGIN //SL1.0 for single line entry
            REPEAT
                InitCIPSTransactionEntrySplitDebit(GenJnlLine, NCHLNPIEntry, IsRealTime, SplitEntry);
                CheckDocumentNo(GenJnlLine, NCHLNPIEntry);
                NCHLNPIEntry."Entry No." := EntryNo;
                IF NCHLNPIEntry.Type = NCHLNPIEntry.Type::Creditor THEN
                    NCHLNPIEntry."Instruction ID" := NCHLNPIEntry."Batch ID" + '-' + FORMAT(NCHLNPIEntry."Line No.");
                NCHLNPIEntry.INSERT(TRUE);
                EntryNo += 1;
                InitCIPSTransactionEntrySplitCredit(GenJnlLine, NCHLNPIEntry, IsRealTime, SplitEntry, EntryNo);
                EntryNo += 1;
            UNTIL GenJnlLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure InitCIPSTransactionEntry(GenJnlLine: Record "81"; var CIPSTransactionEntry: Record "33019814"; IsRealTime: Boolean; SplitIPSEntry: Boolean)
    var
        EntryNo: Integer;
        LineNo: Integer;
        CompanyInfo: Record "79";
        GLSetup: Record "98";
        BalanceEntry: Record "33019814";
        CreditorGenJnl: Record "81";
        BatchID: Code[20];
        NCHLNPICategoryPurpose: Record "33019812";
        CIPSGenJnlLine: Record "81";
        InsertedCIPSTransEntry: Record "33019814";
        Vendor: Record "23";
        Employee: Record "5200";
        BankAcc: Record "270";
        NCHLSetup: Record "33019810";
    begin
        CIPSSetup.GET;
        GLSetup.GET;
        IF GenJnlLine."Currency Code" = '' THEN
            CurrCode := GLSetup."LCY Code"
        ELSE
            CurrCode := GenJnlLine."Currency Code";

        //for getting line no. for cips transaction detail
        IF GenJnlLine."Debit Amount" > 0 THEN BEGIN
            CIPSTransactionEntry.RESET;
            CIPSTransactionEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
            CIPSTransactionEntry.SETRANGE(Type, CIPSTransactionEntry.Type::Creditor);
            IF NOT CIPSTransactionEntry.FINDLAST THEN
                LineNo := 1
            ELSE
                LineNo += CIPSTransactionEntry."Line No." + 1;
        END;

        CIPSTransactionEntry.INIT;
        CIPSTransactionEntry."Posting Date" := GenJnlLine."Posting Date";
        CIPSTransactionEntry."Document No." := GenJnlLine."Document No.";
        CIPSTransactionEntry."Batch ID" := GenJnlLine."Document No."; //Batch ID will be changed when inserted
        CIPSTransactionEntry."Source Code" := GenJnlLine."Source Code";
        //NPI-DOCS1.00
        CIPSTransactionEntry."Registration No." := "Registration No.";
        CIPSTransactionEntry."Registration Year" := "Registration Year";
        CIPSTransactionEntry."Registration Serial" := "Registration Serial"; //PAY1.0
        CIPSTransactionEntry."Payment Types" := "Payment Types"; //PAY1.0
                                                                 //NPI-DOCS1.00
        CIPSTransactionEntry."Ref Id" := "Ref Id"; //IRD
        CIPSTransactionEntry."Office Code" := "Office Code"; //CIT
        NCHLSetup.GET;
        IF "Payment Types" = "Payment Types"::IRD THEN BEGIN //IRD
            NCHLSetup.TESTFIELD("APP ID IRD");
            CIPSTransactionEntry."App ID" := NCHLSetup."APP ID IRD";
        END ELSE
            IF "Payment Types" = "Payment Types"::CIT THEN BEGIN
                // NCHLSetup.TESTFIELD("APP ID CIT");
                CIPSTransactionEntry."App ID" := NCHLSetup."APP ID CIT"; //CIT
            END;
        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account") AND ("Document Class" <> "Document Class"::" ") THEN BEGIN
            CASE "Document Class" OF
                "Document Class"::Vendor:
                    BEGIN
                        CIPSTransactionEntry."Account Type" := CIPSTransactionEntry."Account Type"::Vendor;
                        CIPSTransactionEntry."Account No." := "Document Subclass";
                        Vendor.GET("Document Subclass");
                        CIPSTransactionEntry."Account Name" := Vendor.Name;
                        //NPI-DOCS1.00
                        CIPSTransactionEntry."App ID" := Vendor."App Id";
                        CIPSTransactionEntry."App Group" := Vendor."List of Custom";
                        CIPSTransactionEntry."Custom Office" := Vendor."List of Custom";//PAY1.0
                                                                                        //NPI-DOCS1.00
                    END;
            /*"Document Class"::Employee : BEGIN
              CIPSTransactionEntry."Account Type"  := CIPSTransactionEntry."Account Type"::Employee;
              CIPSTransactionEntry."Account No." := "Document SubClass";
              Employee.GET("Document SubClass");
              CIPSTransactionEntry."Account Name" := Employee.FullName;
            END;*/
            END;
        END ELSE BEGIN
            CIPSTransactionEntry."Account Type" := GenJnlLine."Account Type";
            CIPSTransactionEntry."Account No." := GenJnlLine."Account No.";
            IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                Vendor.GET(GenJnlLine."Account No.");
                CIPSTransactionEntry."Account Name" := Vendor.Name;
                //NPI-DOCS1.00
                CIPSTransactionEntry."App ID" := Vendor."List of Custom";
                CIPSTransactionEntry."App Group" := Vendor."App Group"; //pay1.0
                CIPSTransactionEntry."Custom Office" := Vendor."List of Custom"; //pay1.0
                                                                                 //NPI-DOCS1.00
            END ELSE
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account" THEN BEGIN
                    BankAcc.GET(GenJnlLine."Account No.");
                    IF BankAcc."Bank Name" <> '' THEN
                        CIPSTransactionEntry."Account Name" := BankAcc."Bank Name"
                    ELSE
                        CIPSTransactionEntry."Account Name" := BankAcc.Name;
                END;
        END;
        CIPSTransactionEntry."Batch Currency" := CurrCode;
        CIPSTransactionEntry."Category Purpose" := "CIPS Category Purpose";
        CIPSTransactionEntry."End to End ID" := GenJnlLine."External Document No.";
        IF GenJnlLine."Debit Amount" <> 0 THEN BEGIN
            CIPSTransactionEntry.Type := CIPSTransactionEntry.Type::Creditor;
            CIPSTransactionEntry."Debit Amount" := GenJnlLine."Debit Amount";
            CIPSTransactionEntry."Line No." := LineNo;
        END ELSE BEGIN
            CIPSTransactionEntry.Type := CIPSTransactionEntry.Type::Debtor;
            CIPSTransactionEntry."Credit Amount" := GenJnlLine."Credit Amount";
        END;
        GetBankAccountDetails(GenJnlLine, CIPSTransactionEntry.Agent, CIPSTransactionEntry.Branch, CIPSTransactionEntry.Name,
                              CIPSTransactionEntry."Bank Account No.", CIPSTransactionEntry."ID Type", CIPSTransactionEntry."ID Value",
                              CIPSTransactionEntry.Address, CIPSTransactionEntry.Phone, CIPSTransactionEntry.Mobile, CIPSTransactionEntry.Email,
                              CIPSTransactionEntry."Bank Name");
        IF IsRealTime THEN BEGIN
            CIPSTransactionEntry."Transaction Type" := CIPSTransactionEntry."Transaction Type"::"Real Time";
            CIPSTransactionEntry."Batch ID Series" := CIPSSetup."Real Time Batch ID Series";
        END ELSE BEGIN
            CIPSTransactionEntry."Transaction Type" := CIPSTransactionEntry."Transaction Type"::"Non-Real Time";
            CIPSTransactionEntry."Batch ID Series" := CIPSSetup."Non-Real Time Batch ID Series";
        END;
        //
        //

    end;

    local procedure CheckDocumentNo(GenJnlLine: Record "81"; var NCHLNPIEntry: Record "33019814")
    var
        Text025: Label 'A maximum of %1 posting batch ID series can be used in each journal.';
    begin
        CIPSSetup.GET;
        IF GenJnlLine."Document No." = LastDocNo THEN BEGIN
            NCHLNPIEntry."Batch ID" := LastDocumentNo;
        END ELSE BEGIN
            IF IsRealTime THEN
                BatchIDSeries := CIPSSetup."Real Time Batch ID Series"
            ELSE
                BatchIDSeries := CIPSSetup."Non-Real Time Batch ID Series";

            IF NOT NoSeries.GET(BatchIDSeries) THEN BEGIN
                NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                IF NoOfPostingNoSeries > ARRAYLEN(NoSeriesMgt2) THEN
                    ERROR(
                      Text025,
                      ARRAYLEN(NoSeriesMgt2));
                NoSeries.Code := BatchIDSeries;
                NoSeries.Description := FORMAT(NoOfPostingNoSeries);
                NoSeries.INSERT;
            END;
            LastDocNo := GenJnlLine."Document No.";
            NCHLNPIEntry."Batch ID" :=
              NoSeriesMgt2[1].GetNextNo(BatchIDSeries, GenJnlLine."Posting Date", TRUE);
            LastDocumentNo := NCHLNPIEntry."Batch ID"
        END;
    end;

    [Scope('Internal')]
    procedure SetConditions(NewIsRealTime: Boolean; NewSplitEntry: Boolean)
    begin
        IsRealTime := NewIsRealTime;
        SplitEntry := NewSplitEntry;
    end;

    local procedure ParsePostNCHLNPIJsonResponse(FullJSONResponseText: DotNet String; BatchId: Code[20]; IsRealTime: Boolean)
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseCode: Label 'responseCode';
        responseMessage: Label 'responseMessage';
        debitStatus: Label 'debitStatus';
        creditStatus: Label 'creditStatus';
        instructionId: Label 'instructionId';
        batchIdText: Label 'batchId';
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        //MESSAGE(MainJToke.ToString);

        cipsBatchResponse := MainJToke.SelectToken(cipsBatchResponseText);
        NCHLNPIWS.TryParse(cipsBatchResponse.ToString, cipsBatchResponse);

        cipsTxnResponseList := MainJToke.SelectToken(cipsTxnResponseListText);
        JArray := JArray.Parse(cipsTxnResponseList.ToString);
        JObject := JObject.JObject;

        CIPSSetup.GET;

        NCHLNPIEntry.RESET;
        IF IsRealTime THEN
            NCHLNPIEntry.SETRANGE("Batch ID", BatchId)
        ELSE
            NCHLNPIEntry.SETRANGE("Document No.", BatchId);
        IF NCHLNPIEntry.FINDFIRST THEN
            REPEAT
                IF (NCHLNPIEntry.Type = NCHLNPIEntry.Type::Debtor) AND (NCHLNPIEntry."Batch ID" = NCHLNPIWS.GetValueAsText(cipsBatchResponse, batchIdText)) THEN BEGIN
                    NCHLNPIEntry."Status Code" := NCHLNPIWS.GetValueAsText(cipsBatchResponse, responseCode);
                    NCHLNPIEntry."Status Description" := NCHLNPIWS.GetValueAsText(cipsBatchResponse, responseMessage);
                    NCHLNPIEntry."Transaction Response" := NCHLNPIWS.GetValueAsText(cipsBatchResponse, debitStatus);
                    IF CIPSSetup."Success Status Code" = NCHLNPIEntry."Status Code" THEN
                        NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
                    ELSE
                        NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";
                    NCHLNPIEntry.MODIFY(TRUE);
                END ELSE
                    IF NCHLNPIEntry.Type = NCHLNPIEntry.Type::Creditor THEN BEGIN
                        FOREACH JObject IN JArray DO BEGIN
                            IF NCHLNPIEntry."Instruction ID" = FORMAT(JObject.GetValue(instructionId)) THEN BEGIN
                                NCHLNPIEntry."Status Code" := FORMAT(JObject.GetValue(responseCode));
                                NCHLNPIEntry."Status Description" := FORMAT(JObject.GetValue(responseMessage));
                                NCHLNPIEntry."Transaction Response" := FORMAT(JObject.GetValue(creditStatus));
                                IF CIPSSetup."Success Status Code" = NCHLNPIEntry."Status Code" THEN
                                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
                                ELSE
                                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::"Sync In Progress";
                                NCHLNPIEntry.MODIFY(TRUE);

                                IF NCHLNPIEntry."Sync. Status" = NCHLNPIEntry."Sync. Status"::Completed THEN
                                    SendBalanceTransferMailNotification(NCHLNPIEntry);
                            END;
                        END;
                    END;
            UNTIL NCHLNPIEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CancelNCHLNPIPost(DocumentNo: Code[20])
    var
        NCHLNPIEntry: Record "33019814";
    begin
        NCHLNPIEntry.RESET;
        NCHLNPIEntry.SETRANGE("Document No.", DocumentNo);
        IF NCHLNPIEntry.FINDFIRST THEN
            REPEAT
                NCHLNPIEntry.TESTFIELD("Sync. Status", NCHLNPIEntry."Sync. Status"::" ");
                NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Cancelled;
                NCHLNPIEntry.MODIFY(TRUE);
            UNTIL NCHLNPIEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SendTransactionMailNotification()
    var
        NCHLNPIEntry: Record "33019814";
        SMTPMailSetup: Record "409";
        SMTPMail: Codeunit "400";
        MessageText: Label 'Please find the NCHL-NPI transaction report in the attached file.';
        HeaderText: Label 'Dear Concern,';
        Regards: Label 'Regards';
        Footer: Label 'NAV ERP System';
        CompanyInfo: Record "79";
        NCHLNPITransactionReport: Report "33019812";
        FilePath: Text;
        FileMgt: Codeunit "419";
        FileName: Text;
    begin
        CompanyInfo.GET;
        IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
            EXIT;
        CLEAR(SMTPMail);
        SMTPMailSetup.GET;

        NCHLNPIEntry.RESET;
        NCHLNPIEntry.SETRANGE("Posting Date", TODAY);
        FileName := 'Transaction Report';
        FilePath := FileMgt.ServerTempFileName('pdf');
        REPORT.SAVEASPDF(60302, FilePath, NCHLNPIEntry);
        SMTPMail.CreateMessage('SRT', SMTPMailSetup."User ID", 'sulav.thapaliya@agile.com.np', 'Test Mail', '', TRUE);
        SMTPMail.AppendBody(HeaderText);
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody(MessageText);
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody(Regards);
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody(Footer);
        SMTPMail.AddAttachment(FilePath, FileName + '.pdf');
        SMTPMail.TrySend;
    end;

    [Scope('Internal')]
    procedure SendUserChangeRequestApproval(NCHLNPIApprovalWorkflow: Record "33019815")
    var
        SMTPMail: Codeunit "400";
        SMTPMailSetup: Record "409";
        ApprovalUserGroup: Record "33019816";
        MessageText: Label 'Request to change approver for NCHL-NPI %1. Please find the below details.';
        HeaderText: Label 'Dear All Concerned,';
        Regards: Label 'Regards';
        Footer: Label 'NAV ERP System';
        MailMessage: Text;
        EmailBodyText: Text;
        i: Integer;
        MailApplicable: Boolean;
        Employee: Record "5200";
        NCHLNPISetup: Record "33019810";
    begin
        EmailBodyText := '';
        i := 0;
        MailApplicable := FALSE;
        NCHLNPISetup.GET;
        NCHLNPISetup.TESTFIELD("User Change Approver Email");
        EmailBodyText := '<table border="1">';
        EmailBodyText += '<tr>';
        EmailBodyText += STRSUBSTNO('<td>%1</td>', 'Current User ID');
        EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup.FIELDCAPTION("New User ID"));
        EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup.FIELDCAPTION(Sequence));
        EmailBodyText += '</tr>';
        ApprovalUserGroup.RESET;
        ApprovalUserGroup.SETRANGE("Approval Code", NCHLNPIApprovalWorkflow.Code);
        ApprovalUserGroup.SETFILTER("New User ID", '<>%1', '');
        IF ApprovalUserGroup.FINDFIRST THEN
            REPEAT
                i += 1;
                EmailBodyText += '<tr>';
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup."User ID");
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup."New User ID");
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup.Sequence);
                EmailBodyText += '</tr>';
                IF i = ApprovalUserGroup.COUNT THEN
                    EmailBodyText += '</table>';
                MailApplicable := TRUE;
            UNTIL ApprovalUserGroup.NEXT = 0;

        IF MailApplicable THEN BEGIN
            Employee.RESET;
            Employee.SETRANGE("User ID", USERID);
            Employee.FINDFIRST;
            Employee.TESTFIELD("Company E-Mail");

            MailMessage := STRSUBSTNO(MessageText, NCHLNPIApprovalWorkflow.Description);
            SMTPMailSetup.GET;
            SMTPMail.CreateMessage(Employee.FullName, SMTPMailSetup."User ID", NCHLNPISetup."User Change Approver Email", 'Approver User Change Request Approver', '', TRUE);
            SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
            SMTPMail.AppendBody(HeaderText);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(MailMessage);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(EmailBodyText);
            SMTPMail.AppendBody('<br><br><br>');
            SMTPMail.AppendBody(Regards);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(Footer);
            SMTPMail.Send;
        END ELSE
            MESSAGE('Not Applicable.');
    end;

    [Scope('Internal')]
    procedure ApproveUserChangeRequest(NCHLNPIApprovalWorkflow: Record "33019815")
    var
        SMTPMail: Codeunit "400";
        SMTPMailSetup: Record "409";
        ApprovalUserGroup: Record "33019816";
        MessageText: Label 'Approver for NCHL-NPI %1 has been changed. Please find the below details.';
        HeaderText: Label 'Dear All Concerned,';
        Regards: Label 'Regards';
        Footer: Label 'NAV ERP System';
        MailMessage: Text;
        EmailBodyText: Text;
        i: Integer;
        MailApplicable: Boolean;
        UserSetup: Record "91";
    begin
        EmailBodyText := '';
        i := 0;
        MailApplicable := FALSE;
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Can Approve NCHL-NPI User");

        EmailBodyText := '<table border="1">';
        EmailBodyText += '<tr>';
        EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup.FIELDCAPTION("Old User ID"));
        EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup.FIELDCAPTION("New User ID"));
        EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup.FIELDCAPTION(Sequence));
        EmailBodyText += '</tr>';
        ApprovalUserGroup.RESET;
        ApprovalUserGroup.SETRANGE("Approval Code", NCHLNPIApprovalWorkflow.Code);
        ApprovalUserGroup.SETFILTER("New User ID", '<>%1', '');
        IF ApprovalUserGroup.FINDFIRST THEN
            REPEAT
                i += 1;
                ApprovalUserGroup."Old User ID" := ApprovalUserGroup."User ID";
                ApprovalUserGroup."User ID" := ApprovalUserGroup."New User ID";
                ApprovalUserGroup."New User ID" := '';
                ApprovalUserGroup.MODIFY;
                EmailBodyText += '<tr>';
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup."Old User ID");
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup."User ID");
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalUserGroup.Sequence);
                EmailBodyText += '</tr>';
                IF i = ApprovalUserGroup.COUNT THEN
                    EmailBodyText += '</table>';
                MailApplicable := TRUE;
            UNTIL ApprovalUserGroup.NEXT = 0;

        IF MailApplicable THEN BEGIN
            MailMessage := STRSUBSTNO(MessageText, NCHLNPIApprovalWorkflow.Description);
            SMTPMailSetup.GET;
            SMTPMail.CreateMessage('Approver user', SMTPMailSetup."User ID", 'sulav.thapaliya@agile.com.np', 'Approver User Change Request Approver', '', TRUE);
            SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
            SMTPMail.AppendBody(HeaderText);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(MailMessage);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(EmailBodyText);
            SMTPMail.AppendBody('<br><br><br>');
            SMTPMail.AppendBody(Regards);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(Footer);
            SMTPMail.Send;
        END ELSE
            MESSAGE('Not Applicable.');
    end;

    [Scope('Internal')]
    procedure SendBalanceTransferMailNotification(var NCHLNPIEntry: Record "33019814")
    var
        SMTPMail: Codeunit "400";
        SMTPMailSetup: Record "409";
        ReceipientEmail: Text;
        ReceiverName: Text;
        MailSent: Boolean;
        MailApplicable: Boolean;
        FooterName: Text;
        FooterText: Text;
        VendorBankAccount: Record "288";
        Employee: Record "5200";
        Greetings: Label 'Greetings!';
        Vendor: Record "23";
        NCHLNPISetup: Record "33019810";
        MailMessage: Text;
        EmailBodyText: Text;
        Dear: Label 'Dear %1,';
        SinglLineBreak: Label '<br>';
        DoubleLineBreak: Label '<br><br>';
        TripleLineBreak: Label '<br><br><br>';
        Regards: Label 'Regards,';
        CompanyInfo: Record "79";
        SystemNameText: Label 'MICROSOFT DYNAMICS NAV ERP SYSTEM';
        BankAcc: Record "270";
        Body: Label 'The payment has been made from Microsoft Dynamics NAV ERP system using Connect-IPS as per the bank details provided. Please find the transaction details.';
        FileName: Text;
        FileDirectory: Text;
        FileMgt: Codeunit "419";
    begin
        IF NCHLNPIEntry."Sync. Status" <> NCHLNPIEntry."Sync. Status"::Completed THEN
            EXIT;

        IF NCHLNPIEntry.Type = NCHLNPIEntry.Type::Debtor THEN
            EXIT;

        NCHLNPISetup.GET;
        IF NOT NCHLNPISetup."Notify Receiver via Email" THEN
            EXIT;

        SMTPMailSetup.GET;
        CompanyInfo.GET;
        CLEAR(SMTPMail);
        ReceipientEmail := '';
        ReceiverName := '';
        FileName := '';
        FileDirectory := '';
        //get receipient email
        IF NCHLNPIEntry."Account Type" = NCHLNPIEntry."Account Type"::Employee THEN BEGIN
            Employee.GET(NCHLNPIEntry."Account No.");
            ReceiverName := Employee.FullName;
            IF (Employee."Company E-Mail" = '') AND (Employee."Company E-Mail" <> '') THEN
                ReceipientEmail := Employee."Company E-Mail"
            ELSE
                IF Employee."Company E-Mail" <> '' THEN
                    ReceipientEmail := Employee."Company E-Mail";
        END ELSE
            IF NCHLNPIEntry."Account Type" = NCHLNPIEntry."Account Type"::Vendor THEN BEGIN
                Vendor.GET(NCHLNPIEntry."Account No.");
                ReceiverName := Vendor.Name;
                VendorBankAccount.RESET;
                VendorBankAccount.SETRANGE("Vendor No.", NCHLNPIEntry."Account No.");
                VendorBankAccount.SETRANGE("Bank Account No.", NCHLNPIEntry."Bank Account No.");
                VendorBankAccount.SETFILTER("E-Mail", '<>%1', '');
                IF VendorBankAccount.FINDFIRST THEN BEGIN
                    ReceipientEmail := VendorBankAccount."E-Mail";
                END;
            END ELSE
                IF NCHLNPIEntry."Account Type" = NCHLNPIEntry."Account Type"::"Bank Account" THEN BEGIN
                    BankAcc.GET(NCHLNPIEntry."Account No.");
                    ReceipientEmail := BankAcc."E-Mail";
                    ReceiverName := BankAcc.Name;
                END;

        IF ReceipientEmail = '' THEN
            EXIT;

        FileName := STRSUBSTNO('Payment E-Receipt %1', NCHLNPIEntry."Batch ID");
        FileDirectory := FileMgt.ServerTempFileName('pdf');
        REPORT.SAVEASPDF(REPORT::"Payment E-Receipt", FileDirectory, NCHLNPIEntry);


        SMTPMail.CreateMessage('Account Credited', SMTPMailSetup."User ID", ReceipientEmail, 'Amount Received', '', TRUE);
        IF NCHLNPISetup."User Change Approver Email" <> '' THEN
            SMTPMail.AddCC(NCHLNPISetup."User Change Approver Email");
        SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
        SMTPMail.AppendBody(STRSUBSTNO(Dear, UPPERCASE(ReceiverName)));
        SMTPMail.AppendBody(SinglLineBreak);
        SMTPMail.AppendBody(Greetings);
        SMTPMail.AppendBody(DoubleLineBreak);
        SMTPMail.AppendBody(Body);
        SMTPMail.AppendBody(SinglLineBreak);
        SMTPMail.AppendBody(STRSUBSTNO('Bank Name : %1', NCHLNPIEntry."Bank Name"));
        SMTPMail.AppendBody(SinglLineBreak);
        SMTPMail.AppendBody(STRSUBSTNO('Bank Acc. No. : %1', NCHLNPIEntry."Bank Account No."));
        SMTPMail.AppendBody(SinglLineBreak);
        SMTPMail.AppendBody(STRSUBSTNO('Account Name : %1', NCHLNPIEntry.Name));
        SMTPMail.AppendBody(SinglLineBreak);
        SMTPMail.AppendBody(STRSUBSTNO('Amount : %1', NCHLNPIEntry."Debit Amount"));
        SMTPMail.AppendBody(TripleLineBreak);
        SMTPMail.AppendBody(Regards);
        SMTPMail.AppendBody(SinglLineBreak);
        SMTPMail.AppendBody(UPPERCASE(CompanyInfo.Name));
        SMTPMail.AppendBody(SinglLineBreak);
        SMTPMail.AppendBody(UPPERCASE(SystemNameText));
        SMTPMail.AddAttachment(FileDirectory, FileName + '.pdf');
        IF SMTPMail.TrySend THEN BEGIN
            NCHLNPIEntry."Balance Transfer Notified" := TRUE;
            NCHLNPIEntry.MODIFY(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure GenerateOTP(len: Integer) OTP: Code[10]
    var
        AllowedChar: Text;
        i: Integer;
    begin
        OTP := '';
        FOR i := 1 TO len DO
            OTP += FORMAT(RANDOM(i) MOD len);

        EXIT(OTP);
    end;

    [Scope('Internal')]
    procedure SendOTP(OTP: Code[10]; OTPUserID: Code[50]; DocumentNo: Code[20])
    var
        NCHLNPISetup: Record "33019810";
        Employee: Record "5200";
        SMTPMail: Codeunit "400";
        SMTPMailSetup: Record "409";
    begin
        CLEAR(SMTPMail);
        SMTPMailSetup.GET;
        NCHLNPISetup.GET;
        Employee.RESET;
        Employee.SETRANGE("User ID", OTPUserID);
        IF NOT Employee.FINDFIRST THEN
            ERROR('%1 is not linked with employee data', OTPUserID);
        Employee.TESTFIELD("Company E-Mail");
        SMTPMail.CreateMessage('NAV-NPI ERP', SMTPMailSetup."User ID", Employee."Company E-Mail", 'OTP for NAV-NPI Payments', '', TRUE);
        SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
        SMTPMail.AppendBody(STRSUBSTNO('Kindly use passcode for NAV-NPI authentication Document No. %1', DocumentNo));
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody(STRSUBSTNO('OTP Code : %1', OTP));
        IF SMTPMail.TrySend THEN
            MESSAGE('OTP Send to mail address %1', Employee."Company E-Mail");
    end;

    local procedure CreateEmailBody(DocumentNo: Code[20]; JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Text
    var
        EmailBodyText: Text;
        DocNo: Label 'Document No : %1';
        ApprovalDescription: Label 'Description : %1';
        ApprovalDebitAmount: Label 'Debit Amount : %1';
        ApprovalReceiver: Label 'Receiver Name : %1';
        ApprovalVendorName: Label 'Vendor Name : %1';
        ApprovalSenderName: Label 'Sender Name : %1';
        GenJnLine: Record "81";
        VendorBankAccount: Record "288";
        GenJnLine1: Record "81";
        BankAccount: Record "270";
    begin
        //get sender name
        CLEAR(SenderName);
        GenJnLine1.RESET;
        GenJnLine1.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJnLine1.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJnLine1.SETRANGE("Document No.", DocumentNo);
        GenJnLine1.SETFILTER("Credit Amount", '<>%1', 0);
        IF GenJnLine1.FINDSET(FALSE, FALSE) THEN BEGIN
            IF BankAccount.GET(GenJnLine1."Account No.") THEN BEGIN
                IF SenderName = '' THEN
                    SenderName := BankAccount."Bank Account Name";
            END;
        END;


        //prepare email body
        GenJnLine.RESET;
        GenJnLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJnLine.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJnLine.SETRANGE("Document No.", DocumentNo);
        GenJnLine.SETFILTER("Debit Amount", '<>%1', 0);


        EmailBodyText += '<table border="1">';
        EmailBodyText += '<tr>';
        EmailBodyText += STRSUBSTNO('<th>%1</th>', GenJnLine.FIELDCAPTION("Document No."));
        EmailBodyText += STRSUBSTNO('<th>%1</th>', GenJnLine.FIELDCAPTION(Description));
        EmailBodyText += STRSUBSTNO('<th>%1</th>', GenJnLine.FIELDCAPTION("Debit Amount"));
        EmailBodyText += STRSUBSTNO('<th>%1</th>', 'Receiver Name');
        EmailBodyText += STRSUBSTNO('<th>%1</th>', 'Sender Name');
        EmailBodyText += STRSUBSTNO('<th>%1</th>', 'Vendor Name');
        EmailBodyText += '</tr>';


        IF GenJnLine.FINDSET(FALSE, FALSE) THEN
            REPEAT
                CLEAR(DebitAmount);
                CLEAR(Description);
                CLEAR(ReceiverName);
                CLEAR(VendorName);
                DebitAmount := GenJnLine."Debit Amount";
                Description := GenJnLine.Description;
                IF GenJnLine."Account Type" = GenJnLine."Account Type"::"Bank Account" THEN BEGIN
                    IF BankAccount.GET(GenJnLine."Account No.") THEN
                        ReceiverName := BankAccount.Name;
                END
                ELSE
                    IF VendorBankAccount.GET(GenJnLine."Account No.", GenJnLine."Bank Account Code") THEN
                        ReceiverName := VendorBankAccount.Name;
                VendorName := GenJnLine.Description;


                EmailBodyText += '<tr>';
                EmailBodyText += STRSUBSTNO('<td>%1</td>', DocumentNo);
                EmailBodyText += STRSUBSTNO('<td>%1</td>', Description);
                EmailBodyText += STRSUBSTNO('<td>%1</td>', DebitAmount);
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ReceiverName);
                EmailBodyText += STRSUBSTNO('<td>%1</td>', SenderName);
                EmailBodyText += STRSUBSTNO('<td>%1</td>', VendorName);
                EmailBodyText += '</tr>';
            UNTIL GenJnLine.NEXT = 0;
        EmailBodyText += '</table>';
        EXIT(EmailBodyText);
    end;

    local procedure ClearOTPAfterExpired(DocumentNo: Code[20]; EnteredOTP: Code[10]): Boolean
    var
        OTP: Code[10];
        CIPSEntry1: Record "33019814";
        OTPDuration: Decimal;
        Hours: Decimal;
        Days: Decimal;
        Minutes: Decimal;
    begin
        CIPSEntry1.RESET;
        CIPSEntry1.SETRANGE("Document No.", DocumentNo);
        CIPSEntry1.SETRANGE("OTP Code", EnteredOTP);
        IF CIPSEntry1.FINDFIRST THEN BEGIN
            REPEAT
                CLEAR(OTPDuration);
                CLEAR(Hours);
                CLEAR(Days);
                CLEAR(Minutes);
                OTPDuration := CURRENTDATETIME - CIPSEntry1."OTP Generated Date Time";
                OTPDuration := OTPDuration / 1000;
                Days := ROUND((OTPDuration / 86400), 1, '<');
                Hours := ROUND(((OTPDuration - (Days * 86400)) / 3600), 1, '<');
                Minutes := ROUND(((OTPDuration - (Days * 86400) - (Hours * 3600)) / 60), 1, '<');
                IF Days <> 0 THEN BEGIN
                    CLEAR(CIPSEntry1."OTP Code");
                    CLEAR(CIPSEntry1."OTP Generated Date Time");
                    CIPSEntry1.MODIFY;
                END;

                IF STRPOS(FORMAT(CIPSSetup."OTP Expiry Period"), 'hour') > 0 THEN BEGIN
                    IF FORMAT(Hours) > FORMAT(CIPSSetup."OTP Expiry Period") THEN BEGIN
                        CLEAR(CIPSEntry1."OTP Code");
                        CLEAR(CIPSEntry1."OTP Generated Date Time");
                        CIPSEntry1.MODIFY;
                    END;
                END ELSE BEGIN
                    IF STRPOS(FORMAT(CIPSSetup."OTP Expiry Period"), 'minutes') > 0 THEN
                        IF FORMAT(Minutes) > FORMAT(CIPSSetup."OTP Expiry Period") THEN BEGIN
                            CLEAR(CIPSEntry1."OTP Code");
                            CLEAR(CIPSEntry1."OTP Generated Date Time");
                            CIPSEntry1.MODIFY;
                        END;
                END;
            UNTIL CIPSEntry1.NEXT = 0;
            IF CIPSEntry1."OTP Code" = '' THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    end;

    [Scope('Internal')]
    procedure GetSenderName(DocumentNo: Code[20]; JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Text
    var
        SenderName: Text;
        GenJnLine1: Record "81";
        BankAccount: Record "270";
    begin
        CLEAR(SenderName);
        GenJnLine1.RESET;
        GenJnLine1.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJnLine1.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJnLine1.SETRANGE("Document No.", DocumentNo);
        GenJnLine1.SETFILTER("Credit Amount", '<>%1', 0);
        IF GenJnLine1.FINDSET(FALSE, FALSE) THEN BEGIN
            IF BankAccount.GET(GenJnLine1."Account No.") THEN BEGIN
                IF SenderName = '' THEN
                    SenderName := BankAccount."Bank Account Name";
            END;
        END;
        EXIT(SenderName);
    end;

    [Scope('Internal')]
    procedure GetReceiverName(DocumentNo: Code[20]; JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Text
    var
        ReceiverName: Text;
        GenJnLine: Record "81";
        VendorBankAccount: Record "288";
        BankAccount: Record "270";
    begin
        CLEAR(ReceiverName);

        //prepare email body
        GenJnLine.RESET;
        GenJnLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJnLine.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJnLine.SETRANGE("Document No.", DocumentNo);
        GenJnLine.SETFILTER("Debit Amount", '<>%1', 0);
        IF GenJnLine.FINDSET(FALSE, FALSE) THEN
            REPEAT
                IF VendorBankAccount.GET(GenJnLine."Account No.", GenJnLine."Bank Account Code") THEN BEGIN
                    IF ReceiverName = '' THEN
                        ReceiverName := VendorBankAccount.Name
                    ELSE
                        IF STRPOS(ReceiverName, VendorBankAccount.Name) = 0 THEN
                            ReceiverName += ',' + VendorBankAccount.Name;
                END;
                IF GenJnLine."Account Type" = GenJnLine."Account Type"::"Bank Account" THEN BEGIN     //AnkurPun(05/19/22)
                    IF BankAccount.GET(GenJnLine."Account No.") THEN BEGIN
                        IF ReceiverName = '' THEN
                            ReceiverName := BankAccount.Name
                        ELSE
                            IF STRPOS(ReceiverName, BankAccount.Name) = 0 THEN
                                ReceiverName += ',' + BankAccount.Name;
                    END;
                END;
            UNTIL GenJnLine.NEXT = 0;
        EXIT(ReceiverName);
    end;

    [Scope('Internal')]
    procedure GetUserIDEmail(UserID: Text): Text
    var
        Employee: Record "5200";
    begin
        Employee.RESET;
        Employee.SETRANGE("User ID", UserID);
        IF Employee.FINDFIRST THEN
            EXIT(Employee."Company E-Mail")
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure GetTransactionDate(DocumentNo: Code[20])
    var
        NCHLEntry: Record "33019814";
    begin
        NCHLEntry.RESET;
        NCHLEntry.SETRANGE("Document No.", DocumentNo);
        IF NCHLEntry.FINDFIRST THEN
            REPEAT
                NCHLEntry."Transaction Date" := TODAY;
                NCHLEntry."Transaction Time" := TIME;
                NCHLEntry.MODIFY;
            UNTIL NCHLEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure StartRealTimeCIPSIntegration1(BatchNo: Code[20])
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        Debtor: Record "33019814";
        ResponseCode: Text;
        CurrBatchID: Code[20];
        PrevBatchID: Code[20];
        BatchCIPSEntry: Record "33019814";
        BatchCountInt: Integer;
        AgentSame: Boolean;
        JSONResponseText: DotNet String;
        VoucherCount: Integer;
        OTP: Code[10];
        NPIEntry: Record "33019814";
        FinalTransString: Text;
    begin
        IF CIPSEnabled AND NCHLNPIIntegrationEnabled THEN BEGIN
            CIPSSetup.GET;
            CheckCIPSSetup;
            OTP := '';
            CIPSEntry.RESET;
            CIPSEntry.SETRANGE("Document No.", BatchNo);
            CIPSEntry.FINDFIRST;
            CIPSEntry.CALCFIELDS("Batch Count");
            CIPSEntry.CALCFIELDS("Voucher Count");
            BatchCountInt := CIPSEntry."Batch Count";
            VoucherCount := CIPSEntry."Voucher Count";
            IF CIPSSetup."Use OTP Authentication" THEN BEGIN
                IF CIPSEntry."OTP Code" = '' THEN
                    ERROR('Please send otp for authentication.');
                OTP := CIPSEntry."OTP Code";
                CLEAR(OTPPageBuilder);
                OTPPageBuilder.ADDRECORD(OTPText, NPIEntry);
                OTPPageBuilder.ADDFIELD(OTPText, NPIEntry."OTP Code");
                OTPPageBuilder.RUNMODAL;
                NPIEntry.SETVIEW(OTPPageBuilder.GETVIEW(OTPText));
                EnteredOTP := NPIEntry.GETFILTER("OTP Code");
                IF EnteredOTP <> OTP THEN
                    ERROR('Entered OTP does not reconcile with generated OTP.');

                IF ClearOTPAfterExpired(BatchNo, EnteredOTP) THEN BEGIN   //Sameer to clear OTP Code after expiration
                    MESSAGE('OTP Expired.Please Generate new OTP for the Document No %1.', BatchNo);
                    EXIT;
                END;
            END;
            IF VoucherCount > 1 THEN BEGIN
                CIPSEntry.RESET;
                CIPSEntry.SETRANGE("Document No.", BatchNo);
                CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Real Time");
                CIPSEntry.SETRANGE(Type, CIPSEntry.Type::Creditor);
                IF CIPSEntry.FINDFIRST THEN
                    REPEAT
                        //get debtor info
                        Debtor.RESET;
                        Debtor.SETRANGE("Batch ID", CIPSEntry."Batch ID");
                        Debtor.SETRANGE(Type, Debtor.Type::Debtor);
                        Debtor.SETRANGE("Transaction Type", CIPSEntry."Transaction Type");
                        Debtor.FINDFIRST;
                        DebitData := PrepareRealTimeCreditLine(Debtor);
                        BatchString := CIPSWebService.BatchString(Debtor."Batch ID", Debtor.Agent, Debtor.Branch,
                                                                  Debtor."Bank Account No.", RemoveComma(FORMAT(Debtor."Credit Amount")),
                                                                  Debtor."Batch Currency", '', TRUE);

                        //creditor line
                        CreditData := PrepareRealTimeDebitLine(CIPSEntry);
                        TransactionString := CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                RemoveComma(FORMAT(CIPSEntry."Debit Amount")));

                        FinalTransString := TransactionString;
                        MessageDigestToken := token;
                        MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + FinalTransString + Comma
                                                                                + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';
                        JsonTransactionDetailString := cipsTransactionDetailList + '[' + CreditData + ']' + Comma;
                        FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
                        CIPSWebService.PushRealTimeVoucher(FinalData, JSONResponseText);
                        MESSAGE(JSONResponseText.ToString);
                        ParsePostNCHLNPIJsonResponse(JSONResponseText, CIPSEntry."Batch ID", TRUE);
                    UNTIL CIPSEntry.NEXT = 0;

            END ELSE BEGIN // only batch count is 1
                CIPSEntry.RESET;
                CIPSEntry.SETRANGE("Document No.", BatchNo);
                CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Real Time");
                IF CIPSEntry.FINDFIRST THEN
                    REPEAT
                        IF CIPSEntry.Type = CIPSEntry.Type::Debtor THEN BEGIN
                            DebitData := PrepareRealTimeCreditLine(CIPSEntry);
                            BatchString := CIPSWebService.BatchString(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                                    CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Credit Amount")),
                                                                    CIPSEntry."Batch Currency", '', TRUE);
                        END ELSE
                            IF CIPSEntry.Type = CIPSEntry.Type::Creditor THEN BEGIN
                                CreditData := PrepareRealTimeDebitLine(CIPSEntry);
                                TransactionString := CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                      CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                      RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                            END;
                    UNTIL CIPSEntry.NEXT = 0;
                FinalTransString := TransactionString;
                MessageDigestToken := token;
                MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + FinalTransString + Comma +
                                                                        CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

                JsonTransactionDetailString := cipsTransactionDetailList + '[' + CreditData + ']' + Comma;
                FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
                MESSAGE(FinalData);
                CIPSWebService.PushRealTimeVoucher(FinalData, JSONResponseText);
                MESSAGE(JSONResponseText.ToString);
                ParsePostNCHLNPIJsonResponse(JSONResponseText, CIPSEntry."Batch ID", TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure StarNonRealTimeCIPSIntegration1(BatchNo: Code[20])
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        FinalTransString: Text;
        Debtor: Record "33019814";
        ResponseCode: Text;
        CurrBatchID: Code[20];
        PrevBatchID: Code[20];
        BatchCIPSEntry: Record "33019814";
        BatchCountInt: Integer;
        AgentSame: Boolean;
        JSONResponseText: DotNet String;
        VoucherCount: Integer;
        OTP: Code[10];
        NPIEntry: Record "33019814";
    begin
        IF CIPSEnabled THEN BEGIN
            CIPSSetup.GET;
            CheckCIPSSetup;


            CIPSEntry.RESET;
            CIPSEntry.SETRANGE("Document No.", BatchNo);
            CIPSEntry.FINDFIRST;
            CIPSEntry.CALCFIELDS("Batch Count");
            BatchCountInt := CIPSEntry."Batch Count";

            IF CIPSSetup."Use OTP Authentication" THEN BEGIN
                IF CIPSEntry."OTP Code" = '' THEN
                    ERROR('Please send otp for authentication.');
                OTP := CIPSEntry."OTP Code";
                CLEAR(OTPPageBuilder);
                OTPPageBuilder.ADDRECORD(OTPText, NPIEntry);
                OTPPageBuilder.ADDFIELD(OTPText, NPIEntry."OTP Code");
                OTPPageBuilder.RUNMODAL;
                NPIEntry.SETVIEW(OTPPageBuilder.GETVIEW(OTPText));
                EnteredOTP := NPIEntry.GETFILTER("OTP Code");
                IF EnteredOTP <> OTP THEN
                    ERROR('Entered OTP does not reconcile with assigned OTP.');

                IF ClearOTPAfterExpired(BatchNo, EnteredOTP) THEN BEGIN   //Sameer to clear OTP Code after expiration
                    MESSAGE('OTP Expired.Please Generate new OTP for the Document No %1.', BatchNo);
                    EXIT;
                END;

            END;

            CIPSEntry.RESET;
            CIPSEntry.SETCURRENTKEY("Document No.", "Posting Date");
            CIPSEntry.SETRANGE("Document No.", BatchNo);
            CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Non-Real Time");
            IF CIPSEntry.FINDFIRST THEN
                REPEAT
                    IF CIPSEntry."Credit Amount" > 0 THEN BEGIN
                        DebitData := PrepareOffTimeCreditLine(CIPSEntry, CIPSEntry."Batch ID"); //to pass same batch ID
                        BatchString := CIPSWebService.BatchString(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                                  CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Credit Amount")), CIPSEntry."Batch Currency",
                                                                  CIPSEntry."Category Purpose", FALSE);
                    END;
                    IF CIPSEntry."Debit Amount" > 0 THEN BEGIN
                        IF count_int = 2 THEN BEGIN
                            CreditData := PrepareOffTimeDebitLine(CIPSEntry);
                            TransactionString := CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                  CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                  RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                        END ELSE BEGIN
                            //concatenate multiple credit line data
                            IF CreditData = '' THEN
                                CreditData := PrepareOffTimeDebitLine(CIPSEntry)
                            ELSE
                                CreditData += Comma + PrepareOffTimeDebitLine(CIPSEntry);

                            //concatenate multiple transaction detail
                            IF TransactionString = '' THEN BEGIN
                                TransactionString := CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                     CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                     RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                            END ELSE BEGIN
                                TransactionString += Comma + CIPSWebService.TransactionString(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                    CIPSEntry.Agent, CIPSEntry.Branch, CIPSEntry."Bank Account No.",
                                                                                    RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                            END;

                        END;
                    END;
                UNTIL CIPSEntry.NEXT = 0;

            MessageDigestToken := token;
            MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + TransactionString + Comma
                                                                    + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';
            JsonTransactionDetailString := nchlIpsTransactionDetailList + '[' + CreditData + ']' + Comma;
            FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
            MESSAGE(FinalData);
            CIPSWebService.PushNonRealTimeTimeVoucher(FinalData, JSONResponseText);
            ParsePostNCHLNPIJsonResponse(JSONResponseText, BatchNo, FALSE);
        END;
    end;

    [Scope('Internal')]
    procedure UpdateCIPSTransaction1(CIPSTransactionEntry: Record "33019814")
    var
        RequestMessage: Text;
        IsRealTime: Boolean;
        StatusCode: Text[250];
        JSONResponseText: DotNet String;
        StatusDescription: Text[250];
    begin
        RequestMessage := '';
        StatusCode := '';
        StatusDescription := '';
        //IF "Sync. Status" = "Sync. Status"::Completed THEN
        //EXIT;
        IF "Transaction Type" = "Transaction Type"::"Real Time" THEN
            IsRealTime := TRUE
        ELSE
            IsRealTime := FALSE;
        CASE CIPSTransactionEntry.Type OF
            CIPSTransactionEntry.Type::Debtor:
                BEGIN
                    RequestMessage := OpenCurlyBracket;
                    RequestMessage += batchId + '"' + "Batch ID" + '"';
                    RequestMessage += CloseCurlyBracket;
                    CIPSWebService.GetTransactionUpdate(RequestMessage, IsRealTime, CIPSTransactionEntry.Type, JSONResponseText);
                    ParseJsonResponseArrayAndUpdateTransaction(JSONResponseText, CIPSTransactionEntry);
                    IF (CIPSTransactionEntry."Sync. Status" <> CIPSTransactionEntry."Sync. Status"::Completed) AND (CIPSTransactionEntry."Transaction Charge Amount" <> 0) THEN
                        CIPSTransactionEntry."Transaction Charge Amount" := 0;
                    CIPSTransactionEntry.MODIFY(TRUE); //value will be changed in above function so modify
                END;
            CIPSTransactionEntry.Type::Creditor:
                BEGIN
                    RequestMessage := OpenCurlyBracket;
                    RequestMessage += batchId + '"' + "Batch ID" + '"' + Comma;
                    RequestMessage += instructionId + '"' + "Batch ID" + '-' + FORMAT(CIPSTransactionEntry."Line No.") + '"';
                    RequestMessage += CloseCurlyBracket;
                    CIPSWebService.GetTransactionUpdateFromReportingAPIs(RequestMessage, IsRealTime, CIPSTransactionEntry.Type, JSONResponseText);
                    ParseJsonResponseArrayAndUpdateTransaction(JSONResponseText, CIPSTransactionEntry);
                    IF (CIPSTransactionEntry."Sync. Status" <> CIPSTransactionEntry."Sync. Status"::Completed) AND (CIPSTransactionEntry."Transaction Charge Amount" <> 0) THEN
                        CIPSTransactionEntry."Transaction Charge Amount" := 0;
                    CIPSTransactionEntry.MODIFY(TRUE); //value will be changed in above function so modify
                END;
        END;
    end;

    [Scope('Internal')]
    procedure SendEmailPaymentNCHL(GenJnlLine: Record "81")
    var
        SmtpMailSetup: Record "409";
        SMTPMail: Codeunit "400";
        CompanyInfo: Record "79";
        UserSetup: Record "91";
        Filename: Text;
        FileManagement: Codeunit "419";
        ReciverEmail: Text;
        Vendor: Record "23";
        Customer: Record "18";
        Employee: Record "5200";
    begin
        CLEAR(SMTPMail);  //sandeep 22-nov-2021
        CLEAR(SmtpMailSetup);
        SmtpMailSetup.GET;
        ReciverEmail := '';
        //posted DATE2DMY AND docno
        GenJnlLine.RESET;
        //NCHLEntry.SETRANGE("Posting Date",'03.03.21');
        GenJnlLine.SETRANGE("Document No.", GenJnlLine."Document No.");
        IF GenJnlLine.FINDFIRST THEN BEGIN
            IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                Vendor.RESET;
                Vendor.SETRANGE("Bank Account", GenJnlLine."Account No.");
                IF Vendor.FINDFIRST THEN
                    ReciverEmail := Vendor."E-Mail";
            END;
            IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
                Customer.RESET;
                Customer.SETRANGE("Bank Account No.", GenJnlLine."Account No.");
                IF Customer.FINDFIRST THEN
                    ReciverEmail := Customer."E-Mail";
            END;
            IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account" THEN BEGIN
                Employee.RESET;
                Employee.SETRANGE("Bank Account No.", GenJnlLine."Account No.");
                IF Employee.FINDFIRST THEN
                    ReciverEmail := Employee."Personal E-Mail";
            END;
        END;
        Filename := FileManagement.ServerTempFileName('pdf');
        REPORT.SAVEASPDF(25006144, Filename, GenJnlLine);

        SMTPMail.CreateMessage(CompanyInfo.Name, SmtpMailSetup."User ID", ReciverEmail
        , 'NCHL E-Recipt Mail', '', TRUE);
        SMTPMail.AddAttachment(Filename, FORMAT(NCHLNPIEntry."Entry No.") + '.pdf');
        SMTPMail.AppendBody('Dear Sir/Madam');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('E-Recipt');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('<HR>');
        SMTPMail.AppendBody('Thank You');
        SMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure SendEmailPaymentNCHL1(GenJnlLine: Record "81")
    var
        SmtpMailSetup: Record "409";
        SMTPMail: Codeunit "400";
        CompanyInfo: Record "79";
        UserSetup: Record "91";
        Filename: Text;
        FileManagement: Codeunit "419";
        ReciverEmail: Text;
        Vendor: Record "23";
        Customer: Record "18";
        Employee: Record "5200";
    begin
        CLEAR(SMTPMail);
        CLEAR(SmtpMailSetup);
        SmtpMailSetup.GET;
        ReciverEmail := '';
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Document No.", GenJnlLine."Document No.");
        IF GenJnlLine.FINDFIRST THEN
            REPEAT
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET(GenJnlLine."Account No.") THEN //venodr no and account matches
                        ReciverEmail := Vendor."E-Mail";
                END;
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
                    IF Customer.GET(GenJnlLine."Account No.") THEN
                        ReciverEmail := Customer."E-Mail";
                END;
                IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account" THEN BEGIN
                    IF Employee.GET(GenJnlLine."Account No.") THEN
                        ReciverEmail := Employee."Personal E-Mail";
                END;
            UNTIL GenJnlLine.NEXT = 0;
        //END;

        Filename := FileManagement.ServerTempFileName('pdf');
        //REPORT.SAVEASPDF(50096,Filename,GenJnlLine);
        REPORT.SAVEASPDF(25006144, Filename, GenJnlLine);

        SMTPMail.CreateMessage(CompanyInfo.Name, SmtpMailSetup."User ID", ReciverEmail
        , 'E-Recipt Mail', '', TRUE);
        SMTPMail.AddAttachment(Filename, FORMAT(GenJnlLine.Narration) + '.pdf');
        SMTPMail.AppendBody('Dear Sir/Madam');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('E-Recipt');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('<HR>');
        SMTPMail.AppendBody('Thank You');
        SMTPMail.Send;
    end;

    local procedure "--DOCS---"()
    begin
    end;

    [Scope('Internal')]
    procedure PrepareRealTimeCreditLineFromJournalForGetDetails(GenJournalLine: Record "81"): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
        BankAccount: Record "270";
    begin
        GenJournalLine.TESTFIELD("Account Type", GenJournalLine."Account Type"::"Bank Account");
        BankAccount.GET(GenJournalLine."Account No.");
        //CALCFIELDS("Batch Count");
        data := OpenCurlyBracket;
        data += cipsBatchDetail + InnerOpenCurlyBracket;
        data += batchId + '"' + GenJournalLine."Document No." + '"' + Comma;
        data += batchAmount + '"' + FORMAT(0) + '"' + Comma;
        data += batchCount + '"' + FORMAT(1) + '"' + Comma;
        data += batchCrncy + '"' + GetCurrencyLCY(GenJournalLine."Currency Code") + '"' + Comma;
        data += categoryPurpose + '"' + "CIPS Category Purpose" + '"' + Comma;
        data += debtorAgent + '"' + BankAccount."Bank ID" + '"' + Comma;
        data += debtorBranch + '"' + BankAccount."Bank Branch No." + '"' + Comma;
        data += debtorName + '"' + BankAccount.Name + '"' + Comma;
        data += debtorAccount + '"' + BankAccount."Bank Account No." + '"' + Comma;
        data += debtorIdType + '"' + '' + '"' + Comma;
        data += debtorIdValue + '"' + '' + '"' + Comma;
        data += debtorAddress + '"' + BankAccount.Address + '"' + Comma;
        data += debtorPhone + '"' + BankAccount."Phone No." + '"' + Comma;
        data += debtorMobile + '"' + BankAccount."Phone No." + '"' + Comma;
        data += debtorEmail + '"' + BankAccount."E-Mail" + '"';
        data += CloseCurlyBracket + Comma;
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure GetDetailsFromDepartmentofCustom(GenJnlTemplateCode: Code[10]; GenJnlBatchCode: Code[10]; DocumentNo: Code[20])
    var
        DebitData: Text;
        CreditData: Text;
        GenJournalLine: Record "81";
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        FinalTransString: Text;
        JsonTransactionDetailString: Text;
        JSONResponseText: DotNet String;
        Agent: Code[20];
        Branch: Text;
        Name: Text;
        BankAccountNo: Code[30];
        IDType: Code[10];
        IDValue: Text;
        Address: Text;
        Phone: Text;
        Mobile: Text;
        Email: Text;
        BankName: Text[100];
    begin
        IF CIPSEnabled AND NCHLNPIIntegrationEnabled THEN BEGIN
            CIPSSetup.GET;
            CheckCIPSSetup;

            GenJournalLine.RESET;
            GenJournalLine.SETRANGE("Journal Template Name", GenJnlTemplateCode);
            GenJournalLine.SETRANGE("Journal Batch Name", GenJnlBatchCode);
            GenJournalLine.SETRANGE("Document No.", DocumentNo);
            IF GenJournalLine.FINDFIRST THEN
                REPEAT
                    IF GenJournalLine."Credit Amount" > 0 THEN BEGIN
                        DebitData := PrepareRealTimeCreditLineFromJournalForGetDetails(GenJournalLine);
                        GetBankAccountDetails(GenJournalLine, Agent, Branch, Name, BankAccountNo, IDType, IDValue, Address, Phone, Mobile, Email, BankName);
                        BatchString := CIPSWebService.BatchString(GenJournalLine."Document No.", Agent, Branch,
                                                                BankAccountNo, FORMAT(0),
                                                                GetCurrencyLCY(GenJournalLine."Currency Code"), '', TRUE);
                    END ELSE
                        IF GenJournalLine."Debit Amount" > 0 THEN BEGIN
                            CreditData := PrepareRealTimeDebitLineDepartmentofCustom(GenJournalLine."Document No.", GenJournalLine."Line No.", 0,
                                                                                       GenJournalLine."Account Type", GenJournalLine."Account No.", GenJournalLine."Registration No.",
                                                                                          GenJournalLine."Registration Year", 'M', '', '', '');
                            TransactionString := CIPSWebService.TransactionStringDepartmentofCustom(GenJournalLine."Document No." + '-' + FORMAT(GenJournalLine."Line No."),
                                                                                  GetAppDetails(GenJournalLine."Account Type", GenJournalLine."Account No."),
                                                                                    GenJournalLine."Registration No.", GenJournalLine."Registration Year");
                        END;
                UNTIL GenJournalLine.NEXT = 0;

            FinalTransString := TransactionString;
            MessageDigestToken := token;
            MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + FinalTransString + Comma +
                                                                    CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

            JsonTransactionDetailString := cipsTransactionDetail + CreditData + Comma;
            FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
            //MESSAGE(FinalData);
            CIPSWebService.PushGetDetailsDOC(FinalData, JSONResponseText);
            //MESSAGE(JSONResponseText.ToString);
            //ParseGetDetailsDOCJsonResponse(JSONResponseText,amountToBePaid,instanceId,companyCode,postEntryNo);
            //MESSAGE(FORMAT(amountToBePaid)+' : '+instanceId+' : '+companyCode+' : '+postEntryNo);
        END;
    end;

    local procedure GetAppDetails(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]): Code[20]
    var
        Vendor: Record "23";
    begin
        CASE AccountType OF
            AccountType::Vendor:
                BEGIN
                    Vendor.GET(AccountNo);
                    EXIT(Vendor."App Id");
                END;
        END;
    end;

    local procedure GetCurrencyLCY(CurrencyCode: Code[10]): Code[10]
    begin
        IF CurrencyCode = '' THEN BEGIN
            GLSetup.GET;
            GLSetup.TESTFIELD("LCY Code");
            CurrencyCode := GLSetup."LCY Code";
        END;
        EXIT(CurrencyCode);
    end;

    [Scope('Internal')]
    procedure PrepareRealTimeCreditLineFromCIPSEntrylForGetDetails(NCHLNPIEntry: Record "33019814"): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
        BankAccount: Record "270";
    begin
        NCHLNPIEntry.TESTFIELD("Account Type", "Account Type"::"Bank Account");
        BankAccount.GET("Account No.");
        NCHLNPIEntry.CALCFIELDS("Batch Count");
        data := OpenCurlyBracket;
        data += cipsBatchDetail + InnerOpenCurlyBracket;
        data += batchId + '"' + "Batch ID" + '"' + Comma;
        data += batchAmount + '"' + RemoveComma(FORMAT(NCHLNPIEntry."Credit Amount")) + '"' + Comma;
        data += batchCount + '"' + FORMAT(NCHLNPIEntry."Batch Count") + '"' + Comma;
        data += batchCrncy + '"' + GetCurrencyLCY(CurrCode) + '"' + Comma;
        data += categoryPurpose + '"' + "Category Purpose" + '"' + Comma;
        data += debtorAgent + '"' + BankAccount."Bank ID" + '"' + Comma;
        data += debtorBranch + '"' + BankAccount."Bank Branch No." + '"' + Comma;
        data += debtorName + '"' + BankAccount.Name + '"' + Comma;
        data += debtorAccount + '"' + BankAccount."Bank Account No." + '"' + Comma;
        data += debtorIdType + '"' + '' + '"' + Comma;
        data += debtorIdValue + '"' + '' + '"' + Comma;
        data += debtorAddress + '"' + BankAccount.Address + '"' + Comma;
        data += debtorPhone + '"' + BankAccount."Phone No." + '"' + Comma;
        data += debtorMobile + '"' + BankAccount."Phone No." + '"' + Comma;
        data += debtorEmail + '"' + BankAccount."E-Mail" + '"';
        data += CloseCurlyBracket + Comma;
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure PrepareRealTimeDebitLineDepartmentofCustom(DocumentNo: Code[20]; LineNo: Integer; DebitAmt: Decimal; AccountType: Option; AccountNo: Code[20]; RegistrationNo: Code[35]; RegistrationYear: Code[4]; RegistrationSerial: Text; CompanyCode: Text; InstanceId: Text; PostEntryId: Text): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
        Vendor: Record "23";
    begin
        data := '{';
        data += instructionId + '"' + DocumentNo + '-' + FORMAT(LineNo) + '"' + Comma;
        //data += endToEndId + '"' + DocumentNo + '"' + Comma;
        data += endToEndId + '"DOC Payment"' + Comma;
        data += creditamount + '"' + RemoveComma(FORMAT(DebitAmt)) + '"' + Comma;
        data += appID + '"' + GetAppDetails(AccountType, AccountNo) + '"' + Comma;
        data += refID + '"' + RegistrationNo + '"' + Comma;
        data += addenda3 + '"' + RegistrationYear + '"' + Comma;
        data += freeText1 + '"' + RegistrationSerial + '"' + Comma;
        data += freeText2 + '"' + CompanyCode + '"' + Comma;
        data += freeCode1 + '"' + InstanceId + '"' + Comma;
        data += freeCode2 + '"' + PostEntryId + '"';
        data += '}';
        MESSAGE(data);
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure GetDetailsFromDepartmentofCustomCIPSEntry(BatchNo: Code[20])
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        FinalTransString: Text;
        Debtor: Record "33019814";
        ResponseCode: Text;
        CurrBatchID: Code[20];
        PrevBatchID: Code[20];
        BatchCIPSEntry: Record "33019814";
        BatchCountInt: Integer;
        AgentSame: Boolean;
        JSONResponseText: DotNet String;
        VoucherCount: Integer;
        NPIEntry: Record "33019814";
    begin
        IF CIPSEnabled AND NCHLNPIIntegrationEnabled THEN BEGIN
            CIPSSetup.GET;
            CheckCIPSSetup;
            OTP := '';
            CIPSEntry.RESET;
            CIPSEntry.SETRANGE("Document No.", BatchNo);
            CIPSEntry.FINDFIRST;
            CIPSEntry.CALCFIELDS("Batch Count");
            CIPSEntry.CALCFIELDS("Voucher Count");
            BatchCountInt := CIPSEntry."Batch Count";
            VoucherCount := CIPSEntry."Voucher Count";
            IF CIPSSetup."Use OTP Authentication" THEN BEGIN
                IF CIPSEntry."OTP Code" = '' THEN
                    ERROR('Please send otp for authentication.');
                OTP := CIPSEntry."OTP Code";
                CLEAR(OTPPageBuilder);
                OTPPageBuilder.ADDRECORD(OTPText, NPIEntry);
                OTPPageBuilder.ADDFIELD(OTPText, NPIEntry."OTP Code");
                OTPPageBuilder.RUNMODAL;
                NPIEntry.SETVIEW(OTPPageBuilder.GETVIEW(OTPText));
                EnteredOTP := NPIEntry.GETFILTER("OTP Code");
                IF EnteredOTP <> OTP THEN
                    ERROR('Entered OTP does not reconcile with assigned OTP.');

                IF ClearOTPAfterExpired(BatchNo, EnteredOTP) THEN BEGIN   //Sameer to clear OTP Code after expiration
                    MESSAGE('OTP Expired.Please Generate new OTP for the Document No %1.', BatchNo);
                    EXIT;
                END;
            END;
            IF VoucherCount > 1 THEN BEGIN
                CIPSEntry.RESET;
                CIPSEntry.SETRANGE("Document No.", BatchNo);
                CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Real Time");
                CIPSEntry.SETRANGE(Type, CIPSEntry.Type::Creditor);
                IF CIPSEntry.FINDFIRST THEN
                    REPEAT
                        //get debtor info
                        Debtor.RESET;
                        Debtor.SETRANGE("Batch ID", CIPSEntry."Batch ID");
                        Debtor.SETRANGE(Type, Debtor.Type::Debtor);
                        Debtor.SETRANGE("Transaction Type", CIPSEntry."Transaction Type");
                        Debtor.FINDFIRST;
                        DebitData := PrepareRealTimeCreditLineFromCIPSEntrylForGetDetails(Debtor);
                        BatchString := CIPSWebService.BatchString(Debtor."Batch ID", Debtor.Agent, Debtor.Branch,
                                                                  Debtor."Bank Account No.", RemoveComma(FORMAT(Debtor."Credit Amount")),
                                                                  Debtor."Batch Currency", '', TRUE);

                        //creditor line
                        CreditData := PrepareRealTimeDebitLineDepartmentofCustom(CIPSEntry."Batch ID", CIPSEntry."Line No.", CIPSEntry."Debit Amount",
                                                                                           CIPSEntry."Account Type", CIPSEntry."Account No.", CIPSEntry."Registration No.",
                                                                                            CIPSEntry."Registration Year", 'M', '', '', '');

                        TransactionString := CIPSWebService.TransactionStringDepartmentofCustom(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                              GetAppDetails(CIPSEntry."Account Type", CIPSEntry."Account No."),
                                                                                CIPSEntry."Registration No.", CIPSEntry."Registration Year");

                        FinalTransString := TransactionString;
                        MessageDigestToken := token;
                        MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + FinalTransString + Comma
                                                                                + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';
                        JsonTransactionDetailString := cipsTransactionDetail + CreditData + Comma;
                        FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
                        CIPSWebService.PushGetDetailsDOC(FinalData, JSONResponseText);
                        //MESSAGE(JSONResponseText.ToString);
                        ParseGetDetailsDOCJsonResponse(JSONResponseText, amountToBePaid, instanceId, companyCode, postEntryNo);
                        CIPSEntry."Instance IDs" := instanceId;
                        CIPSEntry."Company Codes" := companyCode;
                        CIPSEntry.MODIFY;
                    UNTIL CIPSEntry.NEXT = 0;

            END ELSE BEGIN // only batch count is 1
                CIPSEntry.RESET;
                CIPSEntry.SETRANGE("Document No.", BatchNo);
                CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Real Time");
                IF CIPSEntry.FINDFIRST THEN
                    REPEAT
                        IF CIPSEntry.Type = CIPSEntry.Type::Debtor THEN BEGIN
                            DebitData := PrepareRealTimeCreditLineFromCIPSEntrylForGetDetails(CIPSEntry);
                            BatchString := CIPSWebService.BatchString(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                                    CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Credit Amount")),
                                                                    CIPSEntry."Batch Currency", '', TRUE);
                        END ELSE
                            IF CIPSEntry.Type = CIPSEntry.Type::Creditor THEN BEGIN
                                CreditData := PrepareRealTimeDebitLineDepartmentofCustom(CIPSEntry."Batch ID", CIPSEntry."Line No.", CIPSEntry."Debit Amount",
                                                                                                    CIPSEntry."Account Type", CIPSEntry."Account No.", CIPSEntry."Registration No.",
                                                                                                      CIPSEntry."Registration Year", 'M', '', '', '');

                                TransactionString := CIPSWebService.TransactionStringDepartmentofCustom(CIPSEntry."Batch ID" + '-' + FORMAT(CIPSEntry."Line No."),
                                                                                    GetAppDetails(CIPSEntry."Account Type", CIPSEntry."Account No."),
                                                                                      CIPSEntry."Registration No.", CIPSEntry."Registration Year");
                            END;
                    UNTIL CIPSEntry.NEXT = 0;
                FinalTransString := TransactionString;
                MessageDigestToken := token;
                MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + FinalTransString + Comma +
                                                                        CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

                JsonTransactionDetailString := cipsTransactionDetail + CreditData + Comma;
                FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
                CIPSWebService.PushGetDetailsDOC(FinalData, JSONResponseText);
                //MESSAGE(FinalData); //SM
                //MESSAGE(JSONResponseText.ToString); //SM
                ParseGetDetailsDOCJsonResponse(JSONResponseText, amountToBePaid, instanceId, companyCode, postEntryNo);
                CIPSEntry."Instance IDs" := instanceId;
                CIPSEntry."Company Codes" := companyCode;
                CIPSEntry.MODIFY;
                LodgeConfirmBillPay(BatchNo, amountToBePaid, instanceId, companyCode, postEntryNo, DebitData, TransactionString, BatchString);
            END;
        END;
    end;

    local procedure ParseGetDetailsDOCJsonResponse(FullJSONResponseText: DotNet String; var amountToBePaid: Decimal; var instanceId: Text; var companyCode: Text; var postEntryNo: Text)
    var
        MainJToke: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseCode: Label 'responseCode';
        responseMessage: Label 'responseDescription';
        debitStatus: Label 'debitStatus';
        creditStatus: Label 'creditStatus';
        instructionId: Label 'instructionId';
        batchIdText: Label 'batchId';
        dataResponse: DotNet JToken;
        amountToBePaidTxt: Label 'amountToBePaid';
        instanceIdTxt: Label 'instanceId';
        companyCodeTxt: Label 'companyCode';
        postEntryNoTxt: Label 'postEntryNo';
    begin
        ClearDOCDetails;
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        dataResponse := MainJToke.SelectToken(dataText);
        IF NCHLNPIWS.TryParse(dataResponse.ToString, dataResponse) THEN BEGIN

            CIPSSetup.GET;

            IF CIPSSetup."Success Status Code" = NCHLNPIWS.GetValueAsText(dataResponse, responseCode) THEN BEGIN
                amountToBePaid := NCHLNPIWS.GetValueAsDecimal(dataResponse, amountToBePaidTxt);
                instanceId := NCHLNPIWS.GetValueAsText(dataResponse, instanceIdTxt);
                companyCode := NCHLNPIWS.GetValueAsText(dataResponse, companyCodeTxt);
                postEntryNo := NCHLNPIWS.GetValueAsText(dataResponse, postEntryNoTxt);
            END;
        END;
    end;

    local procedure ClearDOCDetails()
    begin
        amountToBePaid := 0;
        instanceId := '';
        companyCode := '';
        postEntryNo := '';
    end;

    local procedure LodgeConfirmBillPay(DocumentNo: Code[20]; amountToBePaid: Decimal; instanceId: Text; companyCode: Text; postEntryNo: Text; DebitData: Text; TransactionString: Text; BatchString: Text)
    var
        CIPSEntry: Record "33019814";
        CreditData: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        FinalTransString: Text;
        JSONResponseText: DotNet String;
        JsonTransactionDetailString: Text;
        APIType: Option "Lodge Bill","Confirm Bill";
    begin
        CIPSEntry.RESET;
        CIPSEntry.SETRANGE("Document No.", DocumentNo);
        CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Real Time");
        CIPSEntry.SETRANGE(Type, CIPSEntry.Type::Creditor);
        IF CIPSEntry.FINDFIRST THEN BEGIN
            CreditData := PrepareRealTimeDebitLineDepartmentofCustom(CIPSEntry."Batch ID", CIPSEntry."Line No.", CIPSEntry."Debit Amount",
                                                                                      CIPSEntry."Account Type", CIPSEntry."Account No.", CIPSEntry."Registration No.",
                                                                                        CIPSEntry."Registration Year", 'M', companyCode, instanceId, postEntryNo);

            FinalTransString := TransactionString;
            MessageDigestToken := token;
            MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + FinalTransString + Comma +
                                                                    CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

            JsonTransactionDetailString := cipsTransactionDetail + CreditData + Comma;
            FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
            //MESSAGE('Lodge Bill --->'+ FinalData); //SM
            CIPSWebService.PushLodgeConfirmBill(FinalData, JSONResponseText, 0);
            MESSAGE(JSONResponseText);
            IF ParseLodgeBillJsonResponse(JSONResponseText) THEN
                CIPSWebService.PushLodgeConfirmBill(FinalData, JSONResponseText, 1);

            ParseConfirmBillJsonResponse(JSONResponseText, DocumentNo);
        END;
    end;

    local procedure ParseLodgeBillJsonResponse(FullJSONResponseText: DotNet String): Boolean
    var
        MainJToke: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseResultTxt: Label 'responseResult';
        responseMessageTxt: Label 'responseDescription';
        responseResult: DotNet JToken;
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        responseResult := MainJToke.SelectToken(responseResultTxt);
        MESSAGE(FullJSONResponseText);
        NCHLNPIWS.TryParse(responseResult.ToString, responseResult);

        EXIT(CIPSSetup."Success Status Code" = NCHLNPIWS.GetValueAsText(responseResult, responseResultTxt));
    end;

    local procedure ParseConfirmBillJsonResponse(FullJSONResponseText: DotNet String; BatchID: Code[20])
    var
        MainJToke: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseResultTxt: Label 'responseResult';
        responseMessageTxt: Label 'responseDescription';
        responseResult: DotNet JToken;
        CIPSEntry: Record "33019814";
        responseCode: Label 'responseCode';
        responseMessage: Label 'responseDescription';
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        responseResult := MainJToke.SelectToken(responseResultTxt);
        NCHLNPIWS.TryParse(responseResult.ToString, responseResult);

        NCHLNPIWS.GetValueAsText(responseResult, responseResultTxt);

        CIPSEntry.RESET;
        CIPSEntry.SETRANGE("Document No.", BatchID);
        CIPSEntry.SETRANGE("Transaction Type", CIPSEntry."Transaction Type"::"Real Time");
        IF CIPSEntry.FINDSET THEN
            REPEAT
                CIPSEntry."Status Code" := NCHLNPIWS.GetValueAsText(responseResult, responseCode);
                CIPSEntry."Status Description" := NCHLNPIWS.GetValueAsText(responseResult, responseMessage);
                CIPSEntry."Transaction Response" := CIPSEntry."Status Code";
                IF CIPSSetup."Success Status Code" = CIPSEntry."Status Code" THEN
                    CIPSEntry."Sync. Status" := CIPSEntry."Sync. Status"::Completed
                ELSE
                    CIPSEntry."Sync. Status" := CIPSEntry."Sync. Status"::"Sync In Progress";
                CIPSEntry.MODIFY(TRUE);
            UNTIL CIPSEntry.NEXT = 0;
    end;

    local procedure InsertNCHLLog(JsonResponse: DotNet String; DocNo: Code[20]; result: Text)
    var
        NCHLLog: Record "33019809";
    begin
        NCHLLog.INIT();
        NCHLLog."API Body" := COPYSTR(result, 1, 250);
        //NCHLLog."API Password" := Password;
        NCHLLog.Response := COPYSTR(JsonResponse, 1, 250);
        NCHLLog."Response 2" := COPYSTR(result, 251, 250);
        NCHLLog."Document No." := DocNo;
        NCHLLog."Create Date Time" := CURRENTDATETIME;
        NCHLLog.INSERT();
        COMMIT;
    end;

    [Scope('Internal')]
    procedure InitCIPSTransactionEntrySplitDebit(GenJnlLine: Record "81"; var CIPSTransactionEntry: Record "33019814"; IsRealTime: Boolean; SplitIPSEntry: Boolean)
    var
        EntryNo: Integer;
        LineNo: Integer;
        CompanyInfo: Record "79";
        GLSetup: Record "98";
        BalanceEntry: Record "33019814";
        CreditorGenJnl: Record "81";
        BatchID: Code[20];
        NCHLNPICategoryPurpose: Record "33019812";
        CIPSGenJnlLine: Record "81";
        InsertedCIPSTransEntry: Record "33019814";
        Vendor: Record "23";
        Employee: Record "5200";
        BankAcc: Record "270";
        VendBank: Record "288";
    begin
        CIPSSetup.GET;
        GLSetup.GET;
        IF GenJnlLine."Currency Code" = '' THEN
            CurrCode := GLSetup."LCY Code"
        ELSE
            CurrCode := GenJnlLine."Currency Code";

        //for getting line no. for cips transaction detail
        //for debit amount
        CIPSTransactionEntry.RESET;
        CIPSTransactionEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
        CIPSTransactionEntry.SETRANGE(Type, CIPSTransactionEntry.Type::Creditor);
        IF NOT CIPSTransactionEntry.FINDLAST THEN
            LineNo := 1
        ELSE
            LineNo += CIPSTransactionEntry."Line No." + 1;


        CIPSTransactionEntry.INIT;
        CIPSTransactionEntry."Posting Date" := GenJnlLine."Posting Date";
        CIPSTransactionEntry."Document No." := GenJnlLine."Document No.";
        CIPSTransactionEntry."Batch ID" := GenJnlLine."Document No."; //Batch ID will be changed when inserted
        CIPSTransactionEntry."Source Code" := GenJnlLine."Source Code";
        //NPI-DOCS1.00
        CIPSTransactionEntry."Registration No." := "Registration No.";
        CIPSTransactionEntry."Registration Year" := "Registration Year";
        //NPI-DOCS1.00

        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN BEGIN
            CIPSTransactionEntry."Account Type" := CIPSTransactionEntry."Account Type"::Vendor;
            CIPSTransactionEntry."Account No." := GenJnlLine."Account No.";
            Vendor.GET(GenJnlLine."Account No.");
            VendBank.RESET;
            VendBank.SETRANGE("Vendor No.", GenJnlLine."Account No.");
            IF VendBank.FINDFIRST THEN
                CIPSTransactionEntry."Bank Account No." := VendBank."Bank Account No.";

            CIPSTransactionEntry."Account Name" := Vendor.Name;
            //NPI-DOCS1.00
            CIPSTransactionEntry."App ID" := Vendor."List of Custom";
            CIPSTransactionEntry."App Group" := Vendor."List of Custom";
            //NPI-DOCS1.00
        END ELSE
            IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"Bank Account" THEN BEGIN
                CIPSTransactionEntry."Account Type" := CIPSTransactionEntry."Account Type"::"Bank Account";
                CIPSTransactionEntry."Account No." := GenJnlLine."Account No.";
                BankAcc.RESET;
                BankAcc.SETRANGE("No.", GenJnlLine."Account No.");
                IF BankAcc.FINDFIRST THEN
                    CIPSTransactionEntry."Bank Account No." := BankAcc."Bank Account No.";
                CIPSTransactionEntry."Account Name" := BankAcc.Name;
            END;



        CIPSTransactionEntry."Batch Currency" := CurrCode;
        CIPSTransactionEntry."Category Purpose" := "CIPS Category Purpose";
        CIPSTransactionEntry."End to End ID" := GenJnlLine."External Document No.";
        CIPSTransactionEntry.Type := CIPSTransactionEntry.Type::Creditor;
        CIPSTransactionEntry."Debit Amount" := GenJnlLine.Amount;
        CIPSTransactionEntry."Line No." := LineNo;

        GetBankAccountDetails(GenJnlLine, CIPSTransactionEntry.Agent, CIPSTransactionEntry.Branch, CIPSTransactionEntry.Name,
                              CIPSTransactionEntry."Bank Account No.", CIPSTransactionEntry."ID Type", CIPSTransactionEntry."ID Value",
                              CIPSTransactionEntry.Address, CIPSTransactionEntry.Phone, CIPSTransactionEntry.Mobile, CIPSTransactionEntry.Email,
                              CIPSTransactionEntry."Bank Name");
        IF IsRealTime THEN BEGIN
            CIPSTransactionEntry."Transaction Type" := CIPSTransactionEntry."Transaction Type"::"Real Time";
            CIPSTransactionEntry."Batch ID Series" := CIPSSetup."Real Time Batch ID Series";
        END ELSE BEGIN
            CIPSTransactionEntry."Transaction Type" := CIPSTransactionEntry."Transaction Type"::"Non-Real Time";
            CIPSTransactionEntry."Batch ID Series" := CIPSSetup."Non-Real Time Batch ID Series";
        END;
    end;

    [Scope('Internal')]
    procedure InitCIPSTransactionEntrySplitCredit(GenJnlLine: Record "81"; var CIPSTransactionEntry: Record "33019814"; IsRealTime: Boolean; SplitIPSEntry: Boolean; _entryNo: BigInteger)
    var
        EntryNo: Integer;
        LineNo: Integer;
        CompanyInfo: Record "79";
        GLSetup: Record "98";
        BalanceEntry: Record "33019814";
        CreditorGenJnl: Record "81";
        BatchID: Code[20];
        NCHLNPICategoryPurpose: Record "33019812";
        CIPSGenJnlLine: Record "81";
        InsertedCIPSTransEntry: Record "33019814";
        Vendor: Record "23";
        Employee: Record "5200";
        BankAcc: Record "270";
        VendBankAcc: Record "288";
    begin
        CIPSSetup.GET;
        GLSetup.GET;
        IF GenJnlLine."Currency Code" = '' THEN
            CurrCode := GLSetup."LCY Code"
        ELSE
            CurrCode := GenJnlLine."Currency Code";

        //for getting line no. for cips transaction detail
        //for debit amount
        CLEAR(CIPSTransactionEntry);
        CIPSTransactionEntry.RESET;
        CIPSTransactionEntry.SETRANGE("Document No.", GenJnlLine."Document No.");
        CIPSTransactionEntry.SETRANGE(Type, CIPSTransactionEntry.Type::Debtor);
        IF CIPSTransactionEntry.FINDLAST THEN
            LineNo += CIPSTransactionEntry."Line No." + 1
        ELSE
            LineNo := 1;



        CIPSTransactionEntry.INIT;
        CIPSTransactionEntry."Posting Date" := GenJnlLine."Posting Date";
        CIPSTransactionEntry."Document No." := GenJnlLine."Document No.";
        CIPSTransactionEntry."Batch ID" := GenJnlLine."Document No."; //Batch ID will be changed when inserted
        CIPSTransactionEntry."Source Code" := GenJnlLine."Source Code";
        CIPSTransactionEntry."Account No." := GenJnlLine."Bal. Account No.";
        //NPI-DOCS1.00
        CIPSTransactionEntry."Registration No." := "Registration No.";
        CIPSTransactionEntry."Registration Year" := "Registration Year";
        //NPI-DOCS1.00
        //IF ("Account Type" = "Account Type"::"G/L Account") AND ("Document Class" <> "Document Class"::" ") THEN BEGIN
        IF (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor) AND (GenJnlLine."Bal. Account No." <> '') THEN BEGIN

            VendBankAcc.RESET;
            VendBankAcc.SETRANGE("Vendor No.", GenJnlLine."Bal. Account No.");
            IF VendBankAcc.FINDFIRST THEN
                CIPSTransactionEntry."Account Type" := CIPSTransactionEntry."Account Type"::Vendor;

            CIPSTransactionEntry."Bank Account No." := VendBankAcc."Bank Account No.";
            Vendor.GET(GenJnlLine."Bal. Account No.");
            CIPSTransactionEntry."Account Name" := Vendor.Name;
            //NPI-DOCS1.00
            CIPSTransactionEntry."App ID" := Vendor."List of Custom";
            CIPSTransactionEntry."App Group" := Vendor."List of Custom";
            //NPI-DOCS1.00


        END ELSE
            IF (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account") AND (GenJnlLine."Bal. Account No." <> '') THEN BEGIN
                CIPSTransactionEntry."Account Type" := CIPSTransactionEntry."Account Type"::"Bank Account";
                BankAcc.GET(GenJnlLine."Bal. Account No.");
                CIPSTransactionEntry."Bank Account No." := BankAcc."Bank Account No.";
                CIPSTransactionEntry."Account Name" := BankAcc.Name;
            END;


        CIPSTransactionEntry."Batch Currency" := CurrCode;
        CIPSTransactionEntry."Category Purpose" := "CIPS Category Purpose";
        CIPSTransactionEntry."End to End ID" := GenJnlLine."External Document No.";
        CIPSTransactionEntry.Type := CIPSTransactionEntry.Type::Debtor;
        CIPSTransactionEntry."Credit Amount" := GenJnlLine.Amount;
        CIPSTransactionEntry."Line No." := LineNo;

        GetBankAccountDetailsforSingleLine(GenJnlLine, CIPSTransactionEntry.Agent, CIPSTransactionEntry.Branch, CIPSTransactionEntry.Name,
                              CIPSTransactionEntry."Bank Account No.", CIPSTransactionEntry."ID Type", CIPSTransactionEntry."ID Value",
                              CIPSTransactionEntry.Address, CIPSTransactionEntry.Phone, CIPSTransactionEntry.Mobile, CIPSTransactionEntry.Email,
                              CIPSTransactionEntry."Bank Name");
        IF IsRealTime THEN BEGIN
            CIPSTransactionEntry."Transaction Type" := CIPSTransactionEntry."Transaction Type"::"Real Time";
            CIPSTransactionEntry."Batch ID Series" := CIPSSetup."Real Time Batch ID Series";
        END ELSE BEGIN
            CIPSTransactionEntry."Transaction Type" := CIPSTransactionEntry."Transaction Type"::"Non-Real Time";
            CIPSTransactionEntry."Batch ID Series" := CIPSSetup."Non-Real Time Batch ID Series";
        END;
        CIPSTransactionEntry."Entry No." := _entryNo;
        CheckDocumentNo(GenJnlLine, NCHLNPIEntry);
        CIPSTransactionEntry.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure GetBankAccountDetailsforSingleLine(GenJnlLine: Record "81"; var Agent: Code[20]; var Branch: Text; var Name: Text; var BankAccountNo: Code[30]; var IDType: Code[10]; var IDValue: Text; var Address: Text; var Phone: Text; var Mobile: Text; var Email: Text; var BankName: Text[100])
    var
        VendorBankAccount: Record "288";
        CustomerBankAccount: Record "287";
        Vendor: Record "23";
        Customer: Record "18";
        BankAccount: Record "270";
        Employee: Record "5200";
        EmployeeBankAccount: Record "14125604";
    begin
        //SL1.0
        IF "Is From Sugg Vendor" THEN BEGIN
            IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account" THEN BEGIN
                BankAccount.GET(GenJnlLine."Bal. Account No.");
                BankAccountNo := BankAccount."Bank Account No.";
                Agent := BankAccount."Bank ID";
                Branch := BankAccount."Bank Branch No.";
                Address := BankAccount.Address;
                Phone := BankAccount."Phone No.";
                Mobile := BankAccount."Phone No.";
                Email := BankAccount."E-Mail";
                Name := BankAccount."Bank Account Name";
                BankName := BankAccount."Bank Name";
            END
            ELSE
                IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::Vendor THEN BEGIN
                    Vendor.GET(GenJnlLine."Bal. Account No.");
                    IF VendorBankAccount.GET(Vendor."No.", "Bank Account Code") THEN BEGIN
                        BankAccountNo := VendorBankAccount."Bank Account No.";
                        Agent := VendorBankAccount."Bank ID";
                        Branch := VendorBankAccount."Bank Branch No.";
                        Name := VendorBankAccount.Name;
                        BankName := VendorBankAccount."Bank Name";
                    END;
                    Address := Vendor.Address;
                    Phone := Vendor."Phone No.";
                    Mobile := Vendor."Phone No.";
                    Email := Vendor."E-Mail";
                END;
        END;
        //SL1.0
    end;

    local procedure "*********************Custom*********************"()
    begin
    end;

    [Scope('Internal')]
    procedure StarNonRealTimeCIPSIntegrationPAYDetail(BatchNo: Code[20]; isLodge: Boolean)
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        Debtor: Record "33019814";
        ResponseCode: Text;
        JSONResponseText: DotNet String;
        BatchCountInt: Integer;
        NPIEntry: Record "33019814";
    begin
        //23IF CIPSEnabled THEN BEGIN


        CIPSSetup.GET;
        CheckCIPSSetup;


        CIPSEntry.RESET;
        CIPSEntry.SETRANGE("Document No.", BatchNo);
        CIPSEntry.FINDFIRST;
        CIPSEntry.CALCFIELDS("Batch Count");
        BatchCountInt := CIPSEntry."Batch Count";


        CIPSEntry.RESET;
        CIPSEntry.SETCURRENTKEY("Document No.", "Posting Date");
        CIPSEntry.SETRANGE("Document No.", BatchNo);
        //  CIPSEntry.SETRANGE("Transaction Type",CIPSEntry."Transaction Type"::"Non-Real Time"); //can be either.
        IF CIPSEntry.FINDFIRST THEN
            REPEAT


                IF CIPSEntry."Credit Amount" > 0 THEN BEGIN
                    DebitData := PrepareOffTimeCreditLinePAYDetail(CIPSEntry, CIPSEntry."Batch ID", TRUE); //to pass same batch ID
                    BatchString := CIPSWebService.BatchStringPAY(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                              CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Credit Amount")), CIPSEntry."Batch Currency",
                                                              CIPSEntry."Category Purpose", FALSE);
                END;
                IF CIPSEntry."Debit Amount" > 0 THEN BEGIN
                    CreditData := PrepareOffTimeDebitLinePAYDetail(CIPSEntry, TRUE);
                    TransactionString := CIPSWebService.transactionStringPay(CIPSEntry."Instruction ID", CIPSEntry."App ID", CIPSEntry."Registration No.");
                END;


            UNTIL CIPSEntry.NEXT = 0;

        MessageDigestToken := token;
        MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + TransactionString + Comma
                                                                + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

        // JsonTransactionDetailString := cipsTransactionDetail + '[' + CreditData + ']' + Comma;
        IF CIPSEntry."Transaction Type" = CIPSEntry."Transaction Type"::"Non-Real Time" THEN BEGIN
            //JsonTransactionDetailString := nchlIpsTransactionDetail  + CreditData  + Comma; //for details keep same
            JsonTransactionDetailString := cipsTransactionDetail + CreditData + Comma; //for details keep same

            FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
            //MESSAGE(FinalData);
            CIPSWebService.postNCHLDetailsOfPAY(FinalData, JSONResponseText, FALSE);
            CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'DOC DETAILS');
            // MESSAGE(FinalData);
        END
        ELSE
            IF CIPSEntry."Transaction Type" = CIPSEntry."Transaction Type"::"Real Time" THEN BEGIN
                JsonTransactionDetailString := cipsTransactionDetail + CreditData + Comma;
                FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
                MESSAGE(FinalData);

                CIPSWebService.postNCHLDetailsOfPAY(FinalData, JSONResponseText, TRUE);
                CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'DOC DETAILS');

            END;

        //MESSAGE(FinalData);
        //82 MESSAGE(JSONResponseText);
        ParsePostNCHLNPIJsonResponsePAYDetails(JSONResponseText, CIPSEntry."Document No.", FALSE);
    end;

    [Scope('Internal')]
    procedure PrepareOffTimeCreditLinePAYDetail(CIPSCreditEntry: Record "33019814"; BatchIDCode: Code[20]; isDetails: Boolean): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        CIPSCreditEntry.CALCFIELDS("Batch Count");
        data := OpenCurlyBracket;
        IF CIPSCreditEntry."Transaction Type" = CIPSCreditEntry."Transaction Type"::"Real Time" THEN
            data += cipsBatchDetail + InnerOpenCurlyBracket
        ELSE
            //data += cipsBatchDetail + InnerOpenCurlyBracket; //for now keep same on both
            data += nchlIpsBatchDetail + InnerOpenCurlyBracket;

        IF isDetails THEN BEGIN
            data := '';
            data := OpenCurlyBracket;
            data += cipsBatchDetail + InnerOpenCurlyBracket
        END;


        data += batchId + '"' + BatchIDCode + '"' + Comma;
        data += batchAmount + '"' + RemoveComma(FORMAT(CIPSCreditEntry."Credit Amount")) + '"' + Comma;
        data += batchCount + '"' + FORMAT(CIPSCreditEntry."Batch Count") + '"' + Comma;
        data += batchCrncy + '"' + "Batch Currency" + '"' + Comma;
        data += categoryPurpose + '"' + "Category Purpose" + '"' + Comma;
        data += debtorAgent + '"' + Agent + '"' + Comma;
        data += debtorBranch + '"' + Branch + '"' + Comma;
        data += debtorName + '"' + Name + '"' + Comma;
        data += debtorAccount + '"' + "Bank Account No." + '"' + Comma;
        data += debtorIdType + '"' + "ID Type" + '"' + Comma;
        data += debtorIdValue + '"' + "ID Value" + '"' + Comma;
        data += debtorAddress + '"' + Address + '"' + Comma;
        data += debtorPhone + '"' + Phone + '"' + Comma;
        data += debtorMobile + '"' + Mobile + '"' + Comma;
        data += debtorEmail + '"' + Email + '"';
        data += CloseCurlyBracket + Comma;
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure PrepareOffTimeDebitLinePAYDetail(CIPSDebitEntry: Record "33019814"; isDetails: Boolean): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        IF CIPSDebitEntry."Transaction Type" = CIPSDebitEntry."Transaction Type"::"Real Time" THEN
            data := cipsTransactionDetail //'[{';
        ELSE
            //data := cipsTransactionDetail; //'[{'; //for now keep samew
            data := nchlIpsTransactionDetail;
        IF isDetails THEN
            data := cipsTransactionDetail;
        data := '{';
        data += instructionId + '"' + "Batch ID" + '-' + FORMAT(CIPSDebitEntry."Line No.") + '"' + Comma;
        data += endToEndId + '"' + CIPSDebitEntry."Document No." + '"' + Comma;
        data += creditamount + '"' + RemoveComma(FORMAT(CIPSDebitEntry."Debit Amount")) + '"' + Comma;
        data += appID + '"' + "App ID" + '"' + Comma;
        data += refID + '"' + "Registration No." + '"' + Comma;
        data += addenda3 + '"' + "Registration Year" + '"' + Comma;
        data += freeText1 + '"' + "Registration Serial" + '"' + Comma;
        data += freeText2 + '"' + "Company Code" + '"' + Comma; //82
        data += freeCode1 + '"' + "Instance Id" + '"' + Comma;
        data += freeCode2 + '"' + "Free Code 2" + '"';

        data += '}';
        //data += '}]' + Comma;
        EXIT(data);
    end;

    local procedure ParsePostNCHLNPIJsonResponsePAY(FullJSONResponseText: DotNet String; BatchId: Code[20]; IsRealTime: Boolean)
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseCode: Label 'responseCode';
        responseMessage: Label 'responseMessage';
        debitStatus: Label 'debitStatus';
        creditStatus: Label 'creditStatus';
        instructionId: Label 'instructionId';
        batchIdText: Label 'batchId';
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);


        cipsTxnResponseList := MainJToke.SelectToken('cipsTransactionDetail');
        JArray := JArray.Parse(cipsTxnResponseList.ToString);
        JObject := JObject.JObject;

        CIPSSetup.GET;

        NCHLNPIEntry.RESET;
        IF IsRealTime THEN
            NCHLNPIEntry.SETRANGE("Batch ID", BatchId)
        ELSE
            NCHLNPIEntry.SETRANGE("Document No.", BatchId);
        IF NCHLNPIEntry.FINDFIRST THEN
            REPEAT
                NCHLNPIEntry."Free Text 1" := FORMAT(JObject.GetValue(freeText1lbl));
                NCHLNPIEntry."Free Text 2" := FORMAT(JObject.GetValue(freeText2lbl));
                NCHLNPIEntry."Free Code 1" := FORMAT(JObject.GetValue(freeCode1lbl));
                NCHLNPIEntry."Free Code 2" := FORMAT(JObject.GetValue(freeCode2lbl));
                NCHLNPIEntry."Addenda 3" := FORMAT(JObject.GetValue(addenda3lbl));
                NCHLNPIEntry."Addenda 4" := FORMAT(JObject.GetValue(addenda4lbl));
                NCHLNPIEntry.MODIFY;
            UNTIL NCHLNPIEntry.NEXT = 0;



        //4.3.2023
    end;

    local procedure ParsePostNCHLNPIJsonResponsePAYDetails(FullJSONResponseText: DotNet String; BatchId: Code[20]; IsRealTime: Boolean)
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseCode: Label 'responseCode';
        responseMessage: Label 'responseMessage';
        debitStatus: Label 'debitStatus';
        creditStatus: Label 'creditStatus';
        instructionId: Label 'instructionId';
        batchIdText: Label 'batchId';
        lArray: Text;
        JMainObj: DotNet JObject;
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        JMainObj := JMainObj.Parse(FORMAT(FullJSONResponseText));
        //Also chek response code here

        lArray := JMainObj.SelectToken('data').ToString;


        JObject := JObject.Parse(lArray);

        CIPSSetup.GET;

        NCHLNPIEntry.RESET;
        //IF IsRealTime THEN
        // NCHLNPIEntry.SETRANGE("Batch ID",BatchId)
        //ELSE
        NCHLNPIEntry.SETRANGE("Document No.", BatchId);
        //NCHLNPIEntry.SETFILTER("Registration No.",'<>%1','');
        IF NCHLNPIEntry.FINDSET THEN
            REPEAT
                NCHLNPIEntry."Instance Id" := FORMAT(JObject.GetValue(instanceIdlbl));
                //NCHLNPIEntry."Company Name" := COPYSTR(FORMAT(JObject.GetValue(respDes)),1,50);
                NCHLNPIEntry."Company Code" := FORMAT(JObject.GetValue(companycodeLbl));

                NCHLNPIEntry."Company Name" := FORMAT(JObject.GetValue(compantNamelbl));
                NCHLNPIEntry."Office Code" := FORMAT(JObject.GetValue(officeCodelbl));
                NCHLNPIEntry."Amount To Be Paid" := FORMAT(JObject.GetValue(amountToBePaidlbl));
                NCHLNPIEntry."Free Code 2" := FORMAT(JObject.GetValue(postEntryNolbl));
                NCHLNPIEntry.MODIFY;
            UNTIL NCHLNPIEntry.NEXT = 0;


        //4.3.2023
    end;

    local procedure "*******Lodge***********"()
    begin
    end;

    [Scope('Internal')]
    procedure StarNonRealTimeCIPSIntegrationPAYLodgeAndPAY(BatchNo: Code[20])
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        Debtor: Record "33019814";
        ResponseCode: Text;
        JSONResponseText: DotNet String;
        BatchCountInt: Integer;
        NPIEntry: Record "33019814";
    begin
        CIPSSetup.GET;
        CheckCIPSSetup;


        CIPSEntry.RESET;
        CIPSEntry.SETRANGE("Document No.", BatchNo);
        CIPSEntry.FINDFIRST;
        CIPSEntry.CALCFIELDS("Batch Count");
        BatchCountInt := CIPSEntry."Batch Count";


        CIPSEntry.RESET;
        CIPSEntry.SETCURRENTKEY("Document No.", "Posting Date");
        CIPSEntry.SETRANGE("Document No.", BatchNo);
        // CIPSEntry.SETRANGE("Transaction Type",CIPSEntry."Transaction Type"::"Non-Real Time"); //can be any in both
        IF CIPSEntry.FINDFIRST THEN
            REPEAT
                IF (CIPSEntry.Lodge) AND (CIPSEntry.Confirmed) THEN
                    ERROR('Documnet has been already lodged and confirmed.');

                IF CIPSEntry."Credit Amount" > 0 THEN BEGIN
                    DebitData := PrepareOffTimeCreditLinePAYLodgeAndPAY(CIPSEntry, CIPSEntry."Batch ID"); //to pass same batch ID
                    BatchString := CIPSWebService.BatchStringPAY(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                              CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Amount To Be Paid")), CIPSEntry."Batch Currency",
                                                              CIPSEntry."Category Purpose", FALSE);

                    //amount check
                    IF CIPSEntry."Amount To Be Paid" <> '' THEN BEGIN
                        IF CIPSEntry."Amount To Be Paid" <> FORMAT(RemoveComma(FORMAT(CIPSEntry."Credit Amount"))) THEN
                            ERROR('The amount to be paid Rs %1 in custom and amount Rs %2 is not matching.', CIPSEntry."Amount To Be Paid", RemoveComma(FORMAT(CIPSEntry."Credit Amount")));
                    END;
                END;
                IF CIPSEntry."Debit Amount" > 0 THEN BEGIN
                    CreditData := PrepareOffTimeDebitLinePAYLodgeAndPAY(CIPSEntry);
                    TransactionString := CIPSWebService.transactionStringPay(CIPSEntry."Instruction ID", CIPSEntry."App ID", CIPSEntry."Registration No.");
                    IF CIPSEntry."Amount To Be Paid" <> '' THEN BEGIN
                        IF CIPSEntry."Amount To Be Paid" <> FORMAT(RemoveComma(FORMAT(CIPSEntry."Debit Amount"))) THEN
                            ERROR('The amount to be paid Rs %1 in custom and amount Rs %2 is not matching.', CIPSEntry."Amount To Be Paid", RemoveComma(FORMAT(CIPSEntry."Debit Amount")));
                    END;

                END;

            UNTIL CIPSEntry.NEXT = 0;

        MessageDigestToken := token; //look
        MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + TransactionString + Comma
                                                                + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

        // JsonTransactionDetailString := cipsTransactionDetail + '[' + CreditData + ']' + Comma;
        IF CIPSEntry."Transaction Type" = CIPSEntry."Transaction Type"::"Non-Real Time" THEN BEGIN

            JsonTransactionDetailString := nchlIpsTransactionDetail + CreditData + Comma;
            FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
            //  MESSAGE(FinalData);
            //82

            //lodge
            CIPSWebService.postNCHLLodgeBillPAY(FinalData, JSONResponseText, FALSE);
            CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'DOC LODGE');
            ParsePostNCHLNPIJsonResponsePAYLodge(JSONResponseText, CIPSEntry."Document No.", FALSE);
            //lodge

            CLEAR(JSONResponseText);
            //confirm
            CIPSWebService.postNCHLFinalPAY(FinalData, JSONResponseText, FALSE);
            CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'DOC BILL PAY');

            ParsePostNCHLNPIJsonResponsePAYLodgeConfirm(JSONResponseText, CIPSEntry."Document No.", FALSE);


        END ELSE
            IF CIPSEntry."Transaction Type" = CIPSEntry."Transaction Type"::"Real Time" THEN BEGIN
                JsonTransactionDetailString := cipsTransactionDetail + CreditData + Comma;
                FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
                // MESSAGE(FinalData);
                //82

                //lodge
                CIPSWebService.postNCHLLodgeBillPAY(FinalData, JSONResponseText, TRUE);
                CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'DOC LODGE');

                ParsePostNCHLNPIJsonResponsePAYLodge(JSONResponseText, CIPSEntry."Document No.", FALSE);
                //lodge

                CLEAR(JSONResponseText);

                //confirm
                CIPSWebService.postNCHLFinalPAY(FinalData, JSONResponseText, TRUE);
                CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'DOC BILL PAY');

                ParsePostNCHLNPIJsonResponsePAYLodgeConfirm(JSONResponseText, CIPSEntry."Document No.", FALSE);


            END;
    end;

    [Scope('Internal')]
    procedure PrepareOffTimeCreditLinePAYLodgeAndPAY(CIPSCreditEntry: Record "33019814"; BatchIDCode: Code[20]): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        CIPSCreditEntry.CALCFIELDS("Batch Count");
        data := OpenCurlyBracket;
        // data += cipsBatchDetail + InnerOpenCurlyBracket; nchlIpsBatchDetail
        IF CIPSCreditEntry."Transaction Type" = CIPSCreditEntry."Transaction Type"::"Non-Real Time" THEN
            data += nchlIpsBatchDetail + InnerOpenCurlyBracket
        ELSE
            IF CIPSCreditEntry."Transaction Type" = CIPSCreditEntry."Transaction Type"::"Real Time" THEN
                data += cipsBatchDetail + InnerOpenCurlyBracket;

        data += batchId + '"' + BatchIDCode + '"' + Comma;
        data += batchAmount + '"' + RemoveComma(FORMAT("Amount To Be Paid")) + '"' + Comma;
        data += batchCount + '"' + FORMAT(CIPSCreditEntry."Batch Count") + '"' + Comma;
        data += batchCrncy + '"' + "Batch Currency" + '"' + Comma;
        data += categoryPurpose + '"' + "Category Purpose" + '"' + Comma;
        data += debtorAgent + '"' + Agent + '"' + Comma;
        data += debtorBranch + '"' + Branch + '"' + Comma;
        data += debtorName + '"' + Name + '"' + Comma;
        data += debtorAccount + '"' + "Bank Account No." + '"' + Comma;
        data += debtorIdType + '"' + "ID Type" + '"' + Comma;
        data += debtorIdValue + '"' + "ID Value" + '"' + Comma;
        data += debtorAddress + '"' + Address + '"' + Comma;
        data += debtorPhone + '"' + Phone + '"' + Comma;
        data += debtorMobile + '"' + Mobile + '"' + Comma;
        data += debtorEmail + '"' + Email + '"';
        data += CloseCurlyBracket + Comma;
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure PrepareOffTimeDebitLinePAYLodgeAndPAY(CIPSDebitEntry: Record "33019814"): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        // data := cipsTransactionDetail;  //'[{';
        data += '{';
        data += instructionId + '"' + "Batch ID" + '-' + FORMAT(CIPSDebitEntry."Line No.") + '"' + Comma;
        data += endToEndId + '"' + CIPSDebitEntry."Document No." + '"' + Comma;
        data += amount + '"' + RemoveComma(FORMAT("Amount To Be Paid")) + '"' + Comma;
        data += appID + '"' + "App ID" + '"' + Comma;
        data += refID + '"' + "Registration No." + '"' + Comma;
        data += addenda3 + '"' + "Registration Year" + '"' + Comma;
        data += freeText1 + '"' + "Registration Serial" + '"' + Comma;
        data += freeText2 + '"' + "Company Code" + '"' + Comma;
        data += freeCode1 + '"' + "Instance Id" + '"' + Comma;
        data += freeCode2 + '"' + "Free Code 2" + '"';

        data += '}';
        //data += '}]' + Comma;
        EXIT(data);
    end;

    local procedure ParsePostNCHLNPIJsonResponsePAYLodge(FullJSONResponseText: DotNet String; BatchId: Code[20]; IsRealTime: Boolean)
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseCode: Label 'responseCode';
        responseMessage: Label 'responseMessage';
        debitStatus: Label 'debitStatus';
        creditStatus: Label 'creditStatus';
        instructionId: Label 'instructionId';
        batchIdText: Label 'batchId';
        lArray: Text;
        JMainObj: DotNet JObject;
        IsLodge: Boolean;
    begin
        MESSAGE(FORMAT(FullJSONResponseText));
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        JMainObj := JMainObj.Parse(FORMAT(FullJSONResponseText));
        //Also chek response code here

        lArray := JMainObj.SelectToken('responseResult').ToString;


        JObject := JObject.Parse(lArray);

        CLEAR(IsLodge);

        IF FORMAT(JObject.GetValue(responseCode)) = '000' THEN
            IsLodge := TRUE;


        CIPSSetup.GET;
        IF IsLodge THEN BEGIN
            NCHLNPIEntry.RESET;
            IF IsRealTime THEN
                NCHLNPIEntry.SETRANGE("Batch ID", BatchId)
            ELSE
                NCHLNPIEntry.SETRANGE("Document No.", BatchId);
            IF NCHLNPIEntry.FINDFIRST THEN
                REPEAT
                    NCHLNPIEntry.Lodge := IsLodge;
                    NCHLNPIEntry.MODIFY;
                UNTIL NCHLNPIEntry.NEXT = 0;
        END;



        //4.3.2023
    end;

    local procedure "***********************Confirm*************"()
    begin
    end;

    [Scope('Internal')]
    procedure ParsePostNCHLNPIJsonResponsePAYLodgeConfirm(FullJSONResponseText: DotNet String; BatchId: Code[20]; IsRealTime: Boolean)
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseCode: Label 'responseCode';
        responseMessage: Label 'responseMessage';
        debitStatus: Label 'debitStatus';
        creditStatus: Label 'creditStatus';
        instructionId: Label 'instructionId';
        batchIdText: Label 'batchId';
        lArray: Text;
        JMainObj: DotNet JObject;
        IsConfirm: Boolean;
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        JMainObj := JMainObj.Parse(FORMAT(FullJSONResponseText));
        //Also chek response code here

        lArray := JMainObj.SelectToken('responseResult').ToString;


        JObject := JObject.Parse(lArray);

        CLEAR(IsConfirm);

        IF FORMAT(JObject.GetValue(responseCodelbl)) = '000' THEN
            IsConfirm := TRUE;


        CIPSSetup.GET;

        NCHLNPIEntry.RESET;
        IF IsRealTime THEN
            NCHLNPIEntry.SETRANGE("Batch ID", BatchId)
        ELSE
            NCHLNPIEntry.SETRANGE("Document No.", BatchId);
        IF NCHLNPIEntry.FINDFIRST THEN
            REPEAT
                NCHLNPIEntry.Confirmed := IsConfirm;
                NCHLNPIEntry."Status Description" := FORMAT(JObject.GetValue(responseDescriptionlbl));
                IF FORMAT(JObject.GetValue(responseCodelbl)) = '000' THEN
                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
                ELSE
                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::" ";
                NCHLNPIEntry.MODIFY;
            UNTIL NCHLNPIEntry.NEXT = 0;


        //4.3.2023
    end;

    local procedure "**************IRD CIT**********"()
    begin
    end;

    [Scope('Internal')]
    procedure StarNonRealTimeCIPSIntegrationIRDLodgel(BatchNo: Code[20]; isLodge: Boolean)
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        Debtor: Record "33019814";
        ResponseCode: Text;
        JSONResponseText: DotNet String;
        BatchCountInt: Integer;
        NPIEntry: Record "33019814";
    begin
        CIPSSetup.GET;
        CheckCIPSSetup;


        CIPSEntry.RESET;
        CIPSEntry.SETRANGE("Document No.", BatchNo);
        CIPSEntry.FINDFIRST;
        CIPSEntry.CALCFIELDS("Batch Count");
        BatchCountInt := CIPSEntry."Batch Count";


        CIPSEntry.RESET;
        CIPSEntry.SETCURRENTKEY("Document No.", "Posting Date");
        CIPSEntry.SETRANGE("Document No.", BatchNo);
        // CIPSEntry.SETRANGE("Transaction Type",CIPSEntry."Transaction Type"::"Non-Real Time");
        IF CIPSEntry.FINDFIRST THEN
            REPEAT


                IF CIPSEntry."Credit Amount" > 0 THEN BEGIN
                    DebitData := PrepareOffTimeCreditLinePAYDetail(CIPSEntry, CIPSEntry."Batch ID", FALSE); //to pass same batch ID
                    BatchString := CIPSWebService.BatchStringPAY(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                              CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Credit Amount")), CIPSEntry."Batch Currency",
                                                              CIPSEntry."Category Purpose", FALSE);
                END;
                IF CIPSEntry."Debit Amount" > 0 THEN BEGIN
                    CreditData := PrepareOffTimeDebitLineIRDLodge(CIPSEntry, ABS(CIPSEntry."Debit Amount")); //IRD
                    TransactionString := CIPSWebService.transactionStringPay(CIPSEntry."Instruction ID", CIPSEntry."App ID", CIPSEntry."Ref Id"); //IRD
                END;


            UNTIL CIPSEntry.NEXT = 0;

        MessageDigestToken := token;
        MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + TransactionString + Comma
                                                                + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

        //JsonTransactionDetailString := cipsTransactionDetail  + CreditData  + Comma;
        JsonTransactionDetailString := CreditData + Comma;

        FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
        //82 MESSAGE(FinalData);
        IF CIPSEntry."Transaction Type" = CIPSEntry."Transaction Type"::"Real Time" THEN BEGIN
            MESSAGE(FinalData);

            CIPSWebService.postNCHLIRDLodge(FinalData, JSONResponseText, TRUE); //IRD lodge
            CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'PAYMENT LODGE');
            ParsePostNCHLNPIJsonResponseIRDLodge(JSONResponseText, CIPSEntry."Document No.", TRUE);
            CIPSWebService.postNCHLIRDBillPAY(StarNonRealTimeCIPSIntegrationConfirm(CIPSEntry."Document No.", FALSE), JSONResponseText, TRUE);//IRD confirm
            CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'PAYMENT BILL PAY');
            parseConfirm(JSONResponseText, CIPSEntry."Document No.", TRUE);

        END ELSE BEGIN
            CIPSWebService.postNCHLIRDLodge(FinalData, JSONResponseText, FALSE); //lodge
                                                                                 // MESSAGE(FinalData);
                                                                                 //EXIT;
                                                                                 // MESSAGE(FORMAT(JSONResponseText));
            CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'PAYMENT LODGE');
            ParsePostNCHLNPIJsonResponseIRDLodge(JSONResponseText, CIPSEntry."Document No.", FALSE); //parse lets not parse for now
            CIPSWebService.postNCHLIRDBillPAY(FinalData, JSONResponseText, FALSE); //confirm
            CIPSWebService.insertIntoLog(FORMAT(JSONResponseText), CIPSEntry."Document No.", 'PAYMENT BILL PAY');
            parseConfirm(JSONResponseText, CIPSEntry."Document No.", TRUE);

        END;
        //82
        //  CIPSWebService.postNCHLIRDStatus(statusIRDVerify(NCHLNPIEntry),JSONResponseText,TRUE); //IRD status check
        // parseStatus(JSONResponseText,NCHLNPIEntry."Document No.",TRUE); //we should look into it
    end;

    [Scope('Internal')]
    procedure PrepareOffTimeDebitLineIRDLodge(CIPSDebitEntry: Record "33019814"; Amt: Decimal): Text
    var
        data: Text;
        FileMgt: Codeunit "419";
    begin
        IF CIPSDebitEntry."Transaction Type" = CIPSDebitEntry."Transaction Type"::"Real Time" THEN
            data := cipsTransactionDetail  //'[{';
        ELSE
            data := nchlIpsTransactionDetail;

        //IF NOT CIPSDebitEntry.Lodge THEN BEGIN
        // data := '';
        //data := cipsTransactionDetail; //'[{';
        //END;

        data += '{';
        data += instructionId + '"' + "Batch ID" + '-' + FORMAT(CIPSDebitEntry."Line No.") + '"' + Comma;
        data += endToEndId + '"' + CIPSDebitEntry."Document No." + '"' + Comma;
        data += creditamount + '"' + RemoveComma(FORMAT(Amt)) + '"' + Comma;
        IF NOT Lodge THEN
            data += appID + '"' + "App ID" + '"' + Comma
        ELSE
            data += appID + '"' + "Response App Id" + '"' + Comma;

        data += refID + '"' + "Ref Id" + '"';
        IF CIPSDebitEntry."Payment Types" = CIPSDebitEntry."Payment Types"::CIT THEN
            data += Comma + freeCode2 + '"' + "Office Code" + '"';
        data += '}';
        //data += '}]' + Comma;
        EXIT(data);
    end;

    local procedure ParsePostNCHLNPIJsonResponseIRDLodge(FullJSONResponseText: DotNet String; BatchId: Code[20]; IsRealTime: Boolean)
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        responseCode: Label 'responseCode';
        responseMessage: Label 'responseMessage';
        debitStatus: Label 'debitStatus';
        creditStatus: Label 'creditStatus';
        instructionId: Label 'instructionId';
        batchIdText: Label 'batchId';
        lArray: Text;
        JMainObj: DotNet JObject;
        IsLodge: Boolean;
        lArray1: Text;
        JMainObj1: DotNet JObject;
        JObject1: DotNet JObject;
        lArray2: Text;
        JMainObj2: DotNet JObject;
        JObject2: DotNet JObject;
        AppIDResponse: Text;
    begin
        MESSAGE(FORMAT(FullJSONResponseText));
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        JMainObj := JMainObj.Parse(FORMAT(FullJSONResponseText));
        //Also chek response code here

        lArray := JMainObj.SelectToken('responseResult').ToString;


        JObject := JObject.Parse(lArray);

        CLEAR(IsLodge);

        IF FORMAT(JObject.GetValue(responseCode)) = '000' THEN
            IsLodge := TRUE;

        IF NOT IsRealTime THEN BEGIN
            lArray1 := JMainObj.SelectToken('nchlIpsBatchDetail').ToString;
            lArray2 := JMainObj.SelectToken('nchlIpsTransactionDetail').ToString;
        END ELSE BEGIN
            lArray1 := JMainObj.SelectToken('cipsBatchDetail').ToString;
            lArray2 := JMainObj.SelectToken('cipsTransactionDetail').ToString;
        END;

        JObject1 := JObject1.Parse(lArray1);
        EVALUATE(batchAmt, FORMAT(JObject1.GetValue('batchAmount')));

        JObject2 := JObject2.Parse(lArray2);
        AppIDResponse := '';
        AppIDResponse := FORMAT(JObject2.GetValue('appId'));


        CIPSSetup.GET;
        IF IsLodge THEN BEGIN
            NCHLNPIEntry.RESET;
            NCHLNPIEntry.SETRANGE("Document No.", BatchId);
            IF NCHLNPIEntry.FINDFIRST THEN
                REPEAT
                    NCHLNPIEntry."Response App Id" := AppIDResponse;
                    NCHLNPIEntry.Lodge := IsLodge;
                    IF NCHLNPIEntry."Payment Types" = NCHLNPIEntry."Payment Types"::CIT THEN BEGIN

                        IF NCHLNPIEntry."Debit Amount" <> 0 THEN BEGIN
                            NCHLNPIEntry."Original Amount" := NCHLNPIEntry."Debit Amount";
                            NCHLNPIEntry."Debit Amount" := batchAmt
                        END ELSE BEGIN
                            NCHLNPIEntry."Original Amount" := NCHLNPIEntry."Credit Amount";
                            NCHLNPIEntry."Credit Amount" := batchAmt
                        END;
                    END;

                    NCHLNPIEntry.MODIFY;
                UNTIL NCHLNPIEntry.NEXT = 0;
        END;
        COMMIT;
    end;

    [Scope('Internal')]
    procedure statusIRDVerify(NCHLEntry: Record "33019814") data: Text
    begin
        data := '{';
        data += instructionId + '"' + "Batch ID" + '-' + FORMAT(1) + '"' + Comma;
        data += batchId + '"' + "Batch ID" + '"' + Comma;
        data += trascationID + '"' + NCHLEntry."Account Name" + '"' + Comma; //trasaction id
        IF NCHLNPIEntry."Transaction Type" = NCHLEntry."Transaction Type"::"Real Time" THEN
            data += realTime + 'true'
        ELSE
            data += realTime + 'false';

        data += '}';
        MESSAGE(data);
        IF data <> '' THEN
            EXIT(data);
    end;

    local procedure parseStatus(FullJSONResponseText: DotNet String; BatchId: Code[20]; IsRealTime: Boolean)
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        lArray: Text;
        JMainObj: DotNet JObject;
        IsConfirm: Boolean;
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        JMainObj := JMainObj.Parse(FORMAT(FullJSONResponseText));
        //Also chek response code here

        lArray := JMainObj.SelectToken('responseResult').ToString;


        JObject := JObject.Parse(lArray);

        CLEAR(IsConfirm);

        IF FORMAT(JObject.GetValue(responseCodelbl)) = '000' THEN
            IsConfirm := TRUE;


        CIPSSetup.GET;

        NCHLNPIEntry.RESET;
        IF IsRealTime THEN
            NCHLNPIEntry.SETRANGE("Batch ID", BatchId)
        ELSE
            NCHLNPIEntry.SETRANGE("Document No.", BatchId);
        IF NCHLNPIEntry.FINDFIRST THEN
            REPEAT
                NCHLNPIEntry.Confirmed := IsConfirm;
                NCHLNPIEntry."Status Description" := FORMAT(JObject.GetValue(responseDescriptionlbl));
                IF FORMAT(JObject.GetValue(responseCodelbl)) = '000' THEN
                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
                ELSE
                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::" ";
                NCHLNPIEntry.MODIFY;
            UNTIL NCHLNPIEntry.NEXT = 0;
    end;

    local procedure parseConfirm(FullJSONResponseText: DotNet String; BatchId: Code[20]; IsRealTime: Boolean)
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        lArray: Text;
        JMainObj: DotNet JObject;
        IsConfirm: Boolean;
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        JMainObj := JMainObj.Parse(FORMAT(FullJSONResponseText));
        //Also chek response code here

        lArray := JMainObj.SelectToken('responseResult').ToString;


        JObject := JObject.Parse(lArray);

        CLEAR(IsConfirm);

        IF FORMAT(JObject.GetValue(responseCodelbl)) = '000' THEN
            IsConfirm := TRUE;


        CIPSSetup.GET;

        NCHLNPIEntry.RESET;
        //IF IsRealTime THEN
        //NCHLNPIEntry.SETRANGE("Batch ID",BatchId)
        //ELSE
        NCHLNPIEntry.SETRANGE("Document No.", BatchId);
        IF NCHLNPIEntry.FINDFIRST THEN
            REPEAT
                NCHLNPIEntry.Confirmed := IsConfirm;
                NCHLNPIEntry."Status Description" := FORMAT(JObject.GetValue(responseDescriptionlbl));
                IF FORMAT(JObject.GetValue(responseCodelbl)) = '000' THEN
                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
                ELSE
                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::" ";
                NCHLNPIEntry.MODIFY;
            UNTIL NCHLNPIEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure parseReporting(FullJSONResponseText: DotNet String; BatchId: Code[20])
    var
        MainJToke: DotNet JToken;
        cipsBatchResponse: DotNet JToken;
        cipsTxnResponseList: DotNet JToken;
        JObject: DotNet JObject;
        JValue: DotNet JValue;
        JArray: DotNet JArray;
        NCHLNPIWS: Codeunit "33019811";
        lArray: Text;
        JMainObj: DotNet JObject;
        IsConfirm: Boolean;
        dbtrsn: Label 'debitReasonDesc';
    begin
        MainJToke := MainJToke.Parse(FullJSONResponseText);

        JMainObj := JMainObj.Parse(FORMAT(FullJSONResponseText));


        IF FORMAT(JMainObj.GetValue(dbtrsn)) = 'SUCCESS' THEN
            IsConfirm := TRUE;


        CIPSSetup.GET;

        NCHLNPIEntry.RESET;
        NCHLNPIEntry.SETRANGE("Document No.", BatchId);
        IF NCHLNPIEntry.FINDFIRST THEN
            REPEAT

                NCHLNPIEntry."Status Description" := FORMAT(JMainObj.GetValue(dbtrsn));
                IF IsConfirm THEN
                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::Completed
                ELSE
                    NCHLNPIEntry."Sync. Status" := NCHLNPIEntry."Sync. Status"::" ";
                NCHLNPIEntry.MODIFY;
            UNTIL NCHLNPIEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure setReportingBody(NCHLNPI: Record "33019814"): Text
    var
        batchId: Label '"batchId":';
        coln: Label '"';
        data: Text;
    begin
        data := '{';
        data += batchId;
        data += coln + NCHLNPI."Batch ID" + coln;
        data += '}';
        EXIT(data);
    end;

    [Scope('Internal')]
    procedure StarNonRealTimeCIPSIntegrationConfirm(BatchNo: Code[20]; isLodge: Boolean): Text
    var
        CIPSEntry: Record "33019814";
        DebitData: Text;
        CreditData: Text;
        TransactionString: Text;
        BatchString: Text;
        MessageDigestToken: Text;
        FinalData: Text;
        CurrCode: Code[10];
        JsonTransactionDetailString: Text;
        count_int: Integer;
        Debtor: Record "33019814";
        ResponseCode: Text;
        JSONResponseText: DotNet String;
        BatchCountInt: Integer;
        NPIEntry: Record "33019814";
    begin
        CIPSSetup.GET;
        CheckCIPSSetup;


        CIPSEntry.RESET;
        CIPSEntry.SETRANGE("Document No.", BatchNo);
        CIPSEntry.FINDFIRST;
        CIPSEntry.CALCFIELDS("Batch Count");
        BatchCountInt := CIPSEntry."Batch Count";


        CIPSEntry.RESET;
        CIPSEntry.SETCURRENTKEY("Document No.", "Posting Date");
        CIPSEntry.SETRANGE("Document No.", BatchNo);
        // CIPSEntry.SETRANGE("Transaction Type",CIPSEntry."Transaction Type"::"Non-Real Time");
        IF CIPSEntry.FINDFIRST THEN
            REPEAT


                IF CIPSEntry."Credit Amount" > 0 THEN BEGIN
                    DebitData := PrepareOffTimeCreditLinePAYDetail(CIPSEntry, CIPSEntry."Batch ID", FALSE); //to pass same batch ID
                    BatchString := CIPSWebService.BatchStringPAY(CIPSEntry."Batch ID", CIPSEntry.Agent, CIPSEntry.Branch,
                                                              CIPSEntry."Bank Account No.", RemoveComma(FORMAT(CIPSEntry."Credit Amount")), CIPSEntry."Batch Currency",
                                                              CIPSEntry."Category Purpose", FALSE);
                END;
                IF CIPSEntry."Debit Amount" > 0 THEN BEGIN
                    CreditData := PrepareOffTimeDebitLineIRDLodge(CIPSEntry, ABS(CIPSEntry."Debit Amount")); //IRD
                    TransactionString := CIPSWebService.transactionStringPay(CIPSEntry."Instruction ID", CIPSEntry."Response App Id", CIPSEntry."Ref Id"); //IRD
                END;


            UNTIL CIPSEntry.NEXT = 0;

        MessageDigestToken := token;
        MessageDigestToken += '"' + CIPSWebService.getSignature(BatchString + Comma + TransactionString + Comma
                                                                + CIPSSetup."Username (User Auth.)", CIPSSetup."Certificate Path") + '"';

        //JsonTransactionDetailString := cipsTransactionDetail  + CreditData  + Comma;
        JsonTransactionDetailString := CreditData + Comma;

        FinalData := DebitData + JsonTransactionDetailString + MessageDigestToken + CloseCurlyBracket;
        EXIT(FinalData);
    end;
}

