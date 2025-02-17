page 33019814 "NCHL-NPI Entries"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019814;
    SourceTableView = SORTING(Entry No.)
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("NCHL-NPI Batch ID"; "NCHL-NPI Batch ID")
                {
                }
                field("NCHL-NPI Txn ID"; "NCHL-NPI Txn ID")
                {
                }
                field("Transaction Type"; "Transaction Type")
                {
                }
                field("Sync. Status"; "Sync. Status")
                {
                }
                field("Status Code"; "Status Code")
                {
                }
                field("Status Description"; "Status Description")
                {
                }
                field("Transaction Response"; "Transaction Response")
                {
                    Editable = false;
                }
                field("Batch ID Series"; "Batch ID Series")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Payment Date"; "Payment Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("Batch ID"; "Batch ID")
                {
                }
                field("End to End ID"; "End to End ID")
                {
                }
                field("Debit Amount"; "Debit Amount")
                {
                }
                field("Credit Amount"; "Credit Amount")
                {
                }
                field("Transaction Charge Amount"; "Transaction Charge Amount")
                {
                }
                field("Voucher Count"; "Voucher Count")
                {
                }
                field("Batch Count"; "Batch Count")
                {
                }
                field("Batch Currency"; "Batch Currency")
                {
                }
                field("Category Purpose"; "Category Purpose")
                {
                }
                field(Agent; Agent)
                {
                }
                field(Branch; Branch)
                {
                }
                field(Name; Name)
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Bank Account No."; "Bank Account No.")
                {
                }
                field("Account Name"; "Account Name")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field(Address; Address)
                {
                }
                field(Phone; Phone)
                {
                }
                field(Mobile; Mobile)
                {
                }
                field(Email; Email)
                {
                }
                field("App ID"; "App ID")
                {
                }
                field("App ID Group"; "App ID Group")
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
                field("Registration Year"; "Registration Year")
                {
                }
                field("Instance IDs"; "Instance IDs")
                {
                }
                field("Company Codes"; "Company Codes")
                {
                }
                field("Registration Serial"; "Registration Serial")
                {
                }
                field("Ref Id"; "Ref Id")
                {
                }
                field("CIT Office Code"; "CIT Office Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Send to NCHL-NPI")
            {
                Caption = 'Send to NCHL-NPI';
                action("Generate and Send OTP")
                {
                    Image = CreateSerialNo;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = OTPActionVisible;

                    trigger OnAction()
                    var
                        NCHLNPISetup: Record "33019810";
                        NCHLNPIEntry: Record "33019814";
                        OTP: Code[10];
                        OTPAssigned: Boolean;
                    begin
                        NCHLNPISetup.GET;
                        IF NOT NCHLNPISetup."Use OTP Authentication" THEN
                            EXIT;
                        OTPAssigned := FALSE;
                        NCHLNPISetup.TESTFIELD("OTP Character Length");
                        NCHLNPISetup.TESTFIELD("Notification Gateway Method");
                        OTP := CIPSIntegrationMgt.GenerateOTP(NCHLNPISetup."OTP Character Length");

                        NCHLNPIEntry.RESET;
                        NCHLNPIEntry.SETRANGE("OTP Code", OTP);
                        IF NCHLNPIEntry.FINDFIRST THEN
                            ERROR('OTP code %1 already generated and assigned for document no. %2', OTP, NCHLNPIEntry."Document No.");

                        NCHLNPIEntry.RESET;
                        NCHLNPIEntry.SETRANGE("Document No.", "Document No.");
                        NCHLNPIEntry.SETRANGE("Sync. Status", NCHLNPIEntry."Sync. Status"::" ");
                        IF NCHLNPIEntry.FINDFIRST THEN
                            REPEAT
                                NCHLNPIEntry."OTP Code" := OTP;
                                NCHLNPIEntry."OTP Generated Date Time" := CURRENTDATETIME; //Sameer - pass otp generated date time
                                NCHLNPIEntry.MODIFY;
                                OTPAssigned := TRUE;
                            UNTIL NCHLNPIEntry.NEXT = 0;
                        IF OTPAssigned THEN
                            CIPSIntegrationMgt.SendOTP(OTP, USERID, "Document No.");
                    end;
                }
                action("Resend OTP")
                {
                    Image = RefreshText;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = OTPActionVisible;

                    trigger OnAction()
                    var
                        NCHLNPISetup: Record "33019810";
                        NCHLNPIEntry: Record "33019814";
                        OTP: Code[10];
                        OTPAssigned: Boolean;
                    begin
                        NCHLNPISetup.GET;
                        IF NOT NCHLNPISetup."Use OTP Authentication" THEN
                            EXIT;
                        OTPAssigned := FALSE;
                        NCHLNPISetup.TESTFIELD("OTP Character Length");
                        NCHLNPISetup.TESTFIELD("Notification Gateway Method");
                        OTP := CIPSIntegrationMgt.GenerateOTP(NCHLNPISetup."OTP Character Length");

                        NCHLNPIEntry.RESET;
                        NCHLNPIEntry.SETRANGE("OTP Code", OTP);
                        IF NCHLNPIEntry.FINDFIRST THEN
                            ERROR('OTP code %1 already generated and assigned for document no. %2', OTP, NCHLNPIEntry."Document No.");


                        NCHLNPIEntry.RESET;
                        NCHLNPIEntry.SETRANGE("Document No.", "Document No.");
                        NCHLNPIEntry.SETRANGE("Sync. Status", NCHLNPIEntry."Sync. Status"::" ");
                        IF NCHLNPIEntry.FINDFIRST THEN
                            REPEAT
                                NCHLNPIEntry."OTP Code" := OTP;
                                NCHLNPIEntry."OTP Generated Date Time" := CURRENTDATETIME; //Sameer - pass otp generated date time
                                NCHLNPIEntry.MODIFY;
                                OTPAssigned := TRUE;
                            UNTIL NCHLNPIEntry.NEXT = 0;
                        IF OTPAssigned THEN
                            CIPSIntegrationMgt.SendOTP(OTP, USERID, "Document No.");
                    end;
                }
                action("Post Real Time (CIPS)")
                {
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = IsVisible;

                    trigger OnAction()
                    var
                        NCHLNPIEntry: Record "33019814";
                    begin
                        IF NOT CONFIRM('Do you want to post the entries to NCHL-NPI system ?', FALSE) THEN
                            EXIT;

                        IF "Sync. Status" = "Sync. Status"::Cancelled THEN
                            ERROR(CancelledErrMsg);

                        TESTFIELD("Transaction Type", "Transaction Type"::"Real Time");

                        //NPI-DOCS1.00
                        NCHLNPIEntry.RESET;
                        NCHLNPIEntry.SETRANGE("Document No.", "Document No.");
                        NCHLNPIEntry.SETRANGE(Type, NCHLNPIEntry.Type::Creditor);
                        NCHLNPIEntry.FINDFIRST;

                        IF NCHLNPIEntry."Payment Types" = NCHLNPIEntry."Payment Types"::Custom THEN BEGIN
                            CIPSIntegrationMgt.StarNonRealTimeCIPSIntegrationPAYDetail(NCHLNPIEntry."Document No.", FALSE); //for custom
                            CIPSIntegrationMgt.StarNonRealTimeCIPSIntegrationPAYLodgeAndPAY(NCHLNPIEntry."Document No.");
                        END ELSE
                            IF (NCHLNPIEntry."Payment Types" = NCHLNPIEntry."Payment Types"::IRD) OR (NCHLNPIEntry."Payment Types" = NCHLNPIEntry."Payment Types"::CIT) THEN BEGIN
                                CIPSIntegrationMgt.StarNonRealTimeCIPSIntegrationIRDLodgel(Rec."Document No.", FALSE);
                            END ELSE BEGIN
                                CIPSIntegrationMgt.StartRealTimeCIPSIntegration("Document No.");
                                CIPSIntegrationMgt.GetTransactionDate("Document No."); //Min to get transaction date,time
                            END;

                        CIPSIntegrationMgt.GetTransactionDate("Document No."); //Min to get transaction date,time
                        //CurrPage.UPDATE;
                    end;
                }
                action("Post Non Real Time (NCHL-IPS)")
                {
                    Image = PostedPayment;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = IsVisible;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM('Do you want to post the entries to NCHL-NPI system ?', FALSE) THEN
                            EXIT;
                        IF "Sync. Status" = "Sync. Status"::Cancelled THEN
                            ERROR(CancelledErrMsg);
                        TESTFIELD("Transaction Type", "Transaction Type"::"Non-Real Time");

                        IF "Payment Types" = "Payment Types"::" " THEN BEGIN
                            CIPSIntegrationMgt.StarNonRealTimeCIPSIntegration("Document No.");
                            CIPSIntegrationMgt.GetTransactionDate("Document No."); //Min to get transaction date,time
                        END ELSE
                            IF "Payment Types" = "Payment Types"::Custom THEN BEGIN
                                CIPSIntegrationMgt.StarNonRealTimeCIPSIntegrationPAYDetail(Rec."Document No.", FALSE); //for custom
                                CIPSIntegrationMgt.StarNonRealTimeCIPSIntegrationPAYLodgeAndPAY(Rec."Document No.");
                            END ELSE
                                IF ("Payment Types" = "Payment Types"::IRD) OR ("Payment Types" = "Payment Types"::CIT) THEN BEGIN
                                    CIPSIntegrationMgt.StarNonRealTimeCIPSIntegrationIRDLodgel(Rec."Document No.", FALSE);
                                END;
                    end;
                }
            }
            group("Bank Information")
            {
                Caption = 'Bank Information';
                action("Bank Account Validation")
                {
                    Image = ValidateEmailLoggingSetup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ResponseMessage: Text;
                        AccMatchPercent: Code[10];
                        ResponseCode: Code[10];
                    begin
                        IF CIPSWebServiceMgt.CheckBankAccountValidation(Agent, "Bank Account No.", Name) THEN BEGIN
                            CIPSWebServiceMgt.GetBankAccountValidationResponse(ResponseCode, ResponseMessage, AccMatchPercent);
                            MESSAGE('Account is applicable for IPS.\Account Match Percentage : %1\Response Message : %2',
                                     AccMatchPercent, ResponseMessage);
                        END ELSE BEGIN
                            CIPSWebServiceMgt.GetBankAccountValidationResponse(ResponseCode, ResponseMessage, AccMatchPercent);
                            MESSAGE('Account is not valid. Response code does not indicate success.\Account Match Percentage : %1\Response Message : %2',
                                    AccMatchPercent, ResponseMessage);
                        END;
                    end;
                }
            }
            group("Get NCHL-NPI Update")
            {
                Caption = 'Get NCHL-NPI Update';
                action("Get Transaction Update Response")
                {
                    Image = UpdateXML;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IF "Sync. Status" = "Sync. Status"::Cancelled THEN
                            ERROR(CancelledErrMsg);
                        CIPSIntegrationMgt.UpdateCIPSTransaction(Rec)
                    end;
                }
                action("Process Response Update")
                {
                    Image = "Report";
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Report 50097;
                }
                action(UpdateBankAccInfoFromBankSetup)
                {
                    Caption = 'Update Bank Account Info From Bank Setup';
                    Image = "1099Form";

                    trigger OnAction()
                    var
                        BankAccount: Record "270";
                    begin
                        IF NOT CONFIRM('Do you want to update bank account information from bank account?', FALSE) THEN
                            EXIT;
                        IF "Sync. Status" <> "Sync. Status"::" " THEN
                            EXIT;

                        IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                            BankAccount.GET("Account No.");
                            Agent := BankAccount."Bank ID";
                            Branch := BankAccount."Bank Branch No.";
                            Address := BankAccount.Address;
                            Phone := BankAccount."Phone No.";
                            Mobile := BankAccount."Phone No.";
                            Email := BankAccount."E-Mail";
                            Name := BankAccount."Bank Account Name";
                            "Bank Name" := BankAccount."Bank Name";
                            MODIFY;
                        END;
                    end;
                }
            }
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                var
                    Navigate: Page "344";
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
            action(Cancel)
            {
                Image = CancelledEntries;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'The action will cancel the initiation of sending data to NCHL-NPI';

                trigger OnAction()
                begin
                    IF NOT CONFIRM('Do you want to cancel entries to send to NCHL-NPI system?\Once cancelled it cannot be reopened.', FALSE) THEN
                        EXIT;
                    CIPSIntegrationMgt.CancelNCHLNPIPost("Document No.");
                end;
            }
            action("Transaction Report")
            {
                Image = Reconcile;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Report 50098;
            }
            action("Notify Receiver from Mail")
            {
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    NPIEntry: Record "33019814";
                begin
                    IF NOT CONFIRM('Do you want to send email notification to receiver about the transaction?', FALSE) THEN
                        EXIT;
                    NPIEntry.RESET;
                    NPIEntry.SETRANGE("Document No.", "Document No.");
                    NPIEntry.SETRANGE("Batch ID", "Batch ID");
                    NPIEntry.SETRANGE(Type, NPIEntry.Type::Creditor);
                    IF NPIEntry.FINDFIRST THEN
                        CIPSIntegrationMgt.SendBalanceTransferMailNotification(NPIEntry);
                end;
            }
            action("Payment E-Receipt")
            {
                Image = ElectronicPayment;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NPIEntry: Record "33019814";
                begin
                    IF "Sync. Status" <> "Sync. Status"::Completed THEN
                        ERROR('Transaction is not complete. Unable to print payment E-receipt.');
                    NPIEntry.RESET;
                    NPIEntry.SETRANGE("Document No.", "Document No.");
                    NPIEntry.SETRANGE("Posting Date", "Posting Date");
                    IF NPIEntry.FINDFIRST THEN
                        REPORT.RUN(REPORT::"Payment E-Receipt", TRUE, FALSE, NPIEntry);
                end;
            }
            action("Get Status")
            {
                Image = VoucherDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = true;

                trigger OnAction()
                var
                    NCHL: Codeunit "33019810";
                    NCHLL: Codeunit "33019811";
                    JSONResponseText: DotNet String;
                    txt: Text;
                begin
                    txt := NCHL.setReportingBody(Rec);
                    IF Rec."Transaction Type" = Rec."Transaction Type"::"Non-Real Time" THEN
                        NCHLL.getReportBatchIdWise(txt, JSONResponseText, FALSE)
                    ELSE
                        NCHLL.getReportBatchIdWise(txt, JSONResponseText, TRUE);

                    NCHL.parseReporting(JSONResponseText, Rec."Document No.");
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetVisibleProperty
    end;

    trigger OnAfterGetRecord()
    begin
        SetVisibleProperty
    end;

    trigger OnOpenPage()
    begin
        SETFILTER("Sync. Status", '<>%1', "Sync. Status"::Cancelled);
    end;

    var
        CIPSWebServiceMgt: Codeunit "33019811";
        CIPSIntegrationMgt: Codeunit "33019810";
        CIPSBankList: Page "33019815";
        TempCIPSBankAccount: Record "33019814";
        IsVisible: Boolean;
        CancelledErrMsg: Label 'The selected entries is not valid for NCHL-NPI. The status has been cancelled.';
        SourceName: Text;
        OTPActionVisible: Boolean;

    local procedure SetVisibleProperty()
    var
        NCHLNPISetup: Record "33019810";
    begin
        IF "Document No." = '***' THEN
            IsVisible := FALSE
        ELSE
            IsVisible := TRUE;

        NCHLNPISetup.GET;
        IF NCHLNPISetup."Use OTP Authentication" THEN
            OTPActionVisible := TRUE
        ELSE
            OTPActionVisible := FALSE;
    end;
}

