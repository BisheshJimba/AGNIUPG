page 33020127 "Nominee Cash Receipt Form"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Reschedule,Category5_caption,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = Table33020062;

    layout
    {
        area(content)
        {
            group(Payment)
            {
                field("Payment Receipt Date"; "Payment Receipt Date")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CLEAR(CalculateEMI);
                        CalculateEMI.CalculateDueAndNRV(Rec, "Payment Receipt Date");
                        COMMIT;
                    end;
                }
                field("Payment Date"; PaymentDate)
                {
                    Caption = 'Posting Date';
                    Editable = false;
                }
                field("Temp Payment Amount"; "Temp Payment Amount")
                {
                    Caption = 'Payment Amount';
                    Editable = NOT CLEARLOAN;

                    trigger OnValidate()
                    begin
                        PaymentAmount := "Temp Payment Amount";
                    end;
                }
                field("Temp Payment Method"; "Temp Payment Method")
                {
                    Caption = 'Payment Method';

                    trigger OnValidate()
                    begin
                        PaymentAmount := "Temp Payment Amount";
                    end;
                }
                field("Temp Check No."; "Temp Check No.")
                {
                    Caption = 'Cheque No.';
                }
                field("Temp Check Bank Account"; "Temp Check Bank Account")
                {
                    Caption = 'Cheque of Bank';
                }
                field("Bank Account"; BankAccount)
                {
                    TableRelation = "Bank Account";
                }
                field("Payment Description"; "Temp Payment Description")
                {
                }
                field("Trace ID/Ref ID"; "Temp Trace ID/Ref ID")
                {
                }
                field("Wave Penalty"; "Wave Penalty")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        IF NOT "Wave Penalty" THEN
                            PenaltyReceived := ROUND("Penalty Due", 0.01, '=')
                        ELSE
                            PenaltyReceived := 0;
                    end;
                }
                field(PenaltyReceived; PenaltyReceived)
                {
                    Caption = 'Penalty Received';
                    Visible = false;
                }
                field("Clear Loan"; ClearLoan)
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        IF ClearLoan THEN BEGIN
                            "Temp Payment Amount" := ROUND("Total Due", 0.01, '=');
                            PaymentAmount := ROUND("Temp Payment Amount", 0.01, '=');
                        END
                        ELSE BEGIN
                            "Temp Payment Amount" := 0;
                            PaymentAmount := 0;
                        END;
                    end;
                }
            }
            group(General)
            {
                Visible = false;
                field("Temp Cash Receipt No."; "Temp Cash Receipt No.")
                {
                    Caption = 'Receipt No.';
                    Editable = false;
                }
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                }
                field("Loan No."; "Loan No.")
                {
                    Editable = false;
                }
                field("Vehicle Regd. No."; "Vehicle Regd. No.")
                {
                    Editable = false;
                }
                field(Rejected; Rejected)
                {
                    Editable = false;
                }
            }
            group(Dues)
            {
                Visible = true;
                field("Due Principal"; "Due Principal")
                {
                }
                field("Interest Due"; "Interest Due")
                {
                }
                field("Penalty Due"; "Penalty Due")
                {
                }
                field("Insurance Due"; "Insurance Due")
                {
                }
                field("Interest Due on Insurance"; "Interest Due on Insurance")
                {
                }
                field("Other Amount Due"; "Other Amount Due")
                {
                }
                field("Interest Due on CAD"; "Interest Due on CAD")
                {
                    Editable = false;
                }
                field("Total Due as of Today"; "Total Due as of Today")
                {
                    Caption = 'Total Due As on Calc Date';
                }
                field("Due Installment as of Today"; "Due Installment as of Today")
                {
                    Caption = 'Due Installment';
                }
                field("Total Int. Due to clear Loan"; "Total Int. Due to clear Loan")
                {
                    Enabled = false;
                    Visible = false;
                }
                field("Total Due"; "Total Due")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102159026>")
            {
                Caption = 'Function';
                action("Post Receipt")
                {
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        lVehicleFinanceLines: Record "33020063";
                        lPostedAmt: Decimal;
                        lPendingAmt: Decimal;
                        BankAmount: Decimal;
                        RecVehFHeader: Record "33020062";
                        UserSetup: Record "91";
                    begin
                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                            IF "Temp Payment Description" = '' THEN
                                ERROR('Payment Description must have value.');
                            IF "Temp Trace ID/Ref ID" = '' THEN
                                ERROR('Trace ID/Ref ID must have value.');           //Oct 11, 2017
                        END;
                        RecVehFHeader.RESET;
                        RecVehFHeader.SETCURRENTKEY("Transfered Loan No.");
                        RecVehFHeader.SETRANGE("Transfered Loan No.", "Application No.");
                        IF NOT RecVehFHeader.FINDFIRST THEN
                            // TESTFIELD("Loan Disbursed");
                            TESTFIELD(Approved);
                        CALCFIELDS("Last Payment Date");
                        "Payment Received Date" := "Payment Receipt Date";

                        CLEAR(CalculateEMI);
                        CalculateEMI.CalculateDueAndNRV(Rec, "Payment Receipt Date");
                        COMMIT;

                        IF BankAccount = '' THEN
                            ERROR('Bank Account can not be blank.');
                        IF ("Payment Received Date" = 0D) THEN
                            ERROR('Payment Received Date can not be blank.');

                        IF ("Payment Received Date" < "Last Payment Date") THEN
                            ERROR('Payment Received Date can not be earlier than Last Payment Date. Last payment was received on %1.', "Last Payment Date");

                        IF PaymentAmount <= 0 THEN
                            ERROR('Payment amount can not be 0 or less');


                        GenJnlLine.SETRANGE("VF Loan File No.", "Loan No.");
                        IF GenJnlLine.FINDFIRST THEN
                            ERROR('You can not process cash receipt for this loan file. '
                                    + 'There are unposted Journal Lines in Batch Name: %1. Please post those journal line before creating new cash'
                                    + ' receipt', GenJnlLine."Journal Batch Name");


                        UserSetup.GET(USERID);
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", VFSetup."VF Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", UserSetup."VF Posting Batch");
                        IF GenJnlLine.FINDFIRST THEN
                            ERROR(Text0002, VFSetup."VF Journal Template Name", UserSetup."VF Posting Batch");

                        CALCFIELDS(VIN);
                        PostReceiptOnly := TRUE; //SRT Sept 19th 2019  requiring print when
                        ProcessPaymentJournal;

                        "Temp Cash Receipt No." := NoSeriesMngt.GetNextNo(VFSetup."Cash Receipt No.", "Payment Receipt Date", TRUE);

                        CurrPage.CLOSE;
                    end;
                }
                action("Post & Print Receipt")
                {
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        lVehicleFinanceLines: Record "33020063";
                        lPostedAmt: Decimal;
                        lPendingAmt: Decimal;
                        BankAmount: Decimal;
                        RecVehFHeader: Record "33020062";
                        UserSetup: Record "91";
                    begin
                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                            IF "Temp Payment Description" = '' THEN
                                ERROR('Payment Description must have value.');
                            IF "Temp Trace ID/Ref ID" = '' THEN
                                ERROR('Trace ID/Ref ID must have value.');           //Oct 11, 2017
                        END;
                        RecVehFHeader.RESET;
                        RecVehFHeader.SETCURRENTKEY("Transfered Loan No.");
                        RecVehFHeader.SETRANGE("Transfered Loan No.", "Application No.");
                        IF NOT RecVehFHeader.FINDFIRST THEN
                            // TESTFIELD("Loan Disbursed");
                            TESTFIELD(Approved);
                        CALCFIELDS("Last Payment Date");
                        "Payment Received Date" := "Payment Receipt Date";

                        CLEAR(CalculateEMI);
                        CalculateEMI.CalculateDueAndNRV(Rec, "Payment Receipt Date");
                        COMMIT;

                        IF BankAccount = '' THEN
                            ERROR('Bank Account can not be blank.');
                        IF ("Payment Received Date" = 0D) THEN
                            ERROR('Payment Received Date can not be blank.');

                        IF ("Payment Received Date" < "Last Payment Date") THEN
                            ERROR('Payment Received Date can not be earlier than Last Payment Date. Last payment was received on %1.', "Last Payment Date");

                        IF PaymentAmount <= 0 THEN
                            ERROR('Payment amount can not be 0 or less');


                        GenJnlLine.SETRANGE("VF Loan File No.", "Loan No.");
                        IF GenJnlLine.FINDFIRST THEN
                            ERROR('You can not process cash receipt for this loan file. '
                                    + 'There are unposted Journal Lines in Batch Name: %1. Please post those journal line before creating new cash'
                                    + ' receipt', GenJnlLine."Journal Batch Name");


                        UserSetup.GET(USERID);
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", VFSetup."VF Journal Template Name");
                        GenJnlLine.SETRANGE("Journal Batch Name", UserSetup."VF Posting Batch");
                        IF GenJnlLine.FINDFIRST THEN
                            ERROR(Text0002, VFSetup."VF Journal Template Name", UserSetup."VF Posting Batch");

                        CALCFIELDS(VIN);
                        PostReceiptOnly := FALSE; //SRT Sept 19th 2019  to use for posting only when not requiring print
                        ProcessPaymentJournal;

                        "Temp Cash Receipt No." := NoSeriesMngt.GetNextNo(VFSetup."Cash Receipt No.", "Payment Receipt Date", TRUE);

                        CurrPage.CLOSE;
                    end;
                }
                action("Calculate Current Due")
                {
                    Image = CalculateInvoiceDiscount;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CLEAR(CalculateEMI);
                        CalculateEMI.CalculateDueAndNRV(Rec, "Payment Receipt Date");
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        WavePenalty := FALSE;
        PaymentDate := TODAY;
        VFSetup.GET;
        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Vehicle Finance" THEN BEGIN
            "Wave Penalty" := TRUE;
            WavePenalty := TRUE;
            //PenaltyReceived := 0;
        END;

        IsHirePurchase := VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase";
        TempVFRec.SETRANGE("Loan No.", "Loan No.");
        IF TempVFRec.FINDFIRST THEN BEGIN
            //TempVFRec.TESTFIELD("Loan Disbursed");
            TempVFRec.TESTFIELD(Approved);
            TempVFRec."Temp Cash Receipt No." := NoSeriesMngt.TryGetNextNo(VFSetup."Cash Receipt No.", TODAY);
            TempVFRec."Temp Payment Amount" := PaymentAmount;
            TempVFRec."Temp Payment Method" := PaymentMethod;
            TempVFRec."Payment Receipt Date" := TODAY;
            TempVFRec.MODIFY;
            IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                CLEAR(CalculateEMI);
                CalculateEMI.CalculateDueAndNRV(TempVFRec, TODAY);
            END
            ELSE BEGIN
                CLEAR(CalculateEMI_VF);
                CalculateEMI_VF.CalculateDueAndNRV(TempVFRec, TODAY);
                IF WavePenalty = TRUE THEN
                    PenaltyReceived := 0
                ELSE
                    PenaltyReceived := TempVFRec."Penalty Due";
            END;

            COMMIT;
            //CurrPage.UPDATE;
        END;
    end;

    var
        PaymentAmount: Decimal;
        "Payment Description": Text[50];
        PaymentDate: Date;
        PaymentMethod: Option Cash,Check;
        BankAccount: Code[20];
        OK: Boolean;
        VFSetup: Record "33020064";
        CreateVFJournal_HP: Codeunit "33020063";
        CreateVFJournal_VF: Codeunit "33020066";
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        VFPostingType: Option " ",Principal,Interest,Penalty,"Service Charge","Other Charge";
        VFLines: Record "33020063";
        "Wave Penalty": Boolean;
        NewNoSeries: Boolean;
        "Payment Received Date": Date;
        Flag: Boolean;
        InterestAmount: Decimal;
        PenaltyFlag: Boolean;
        TotalAmountDueAsOnDay: Decimal;
        VarPAmpunt: Decimal;
        PendingInterest: Decimal;
        VehicleFinanceLines: Record "33020063";
        VFLine2: Record "33020063";
        CalculateEMI: Codeunit "33020062";
        CalculateEMI_VF: Codeunit "33020065";
        PenaltyReceived: Decimal;
        VehicleFinanceHeader: Record "33020062";
        NoSeriesMngt: Codeunit "396";
        TempVFRec: Record "33020062";
        Text0001: Label 'Cash receipt journals have been created. Please post the journal to apply payment to the Loan File.';
        "Payment Receipt Date": Date;
        GenJnlLine: Record "81";
        ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit;
        [InDataSet]
        ClearLoan: Boolean;
        [InDataSet]
        IsHirePurchase: Boolean;
        WavePenalty: Boolean;
        Text0002: Label 'Unposted Lines already exists in Template %1, Batch %2.';
        PostReceiptOnly: Boolean;

    [Scope('Internal')]
    procedure CalculateInterestRate(VFHeader: Record "33020062"; VFLine: Record "33020063"): Decimal
    begin
    end;

    [Scope('Internal')]
    procedure CalculatePanalty1(VFHeader: Record "33020062"; VFLine1: Record "33020063"): Decimal
    begin
    end;

    [Scope('Internal')]
    procedure TotalAmountDueAsOnDate(lVFLine: Record "33020063"): Decimal
    var
        PenaltyAmount: Decimal;
        InterestAmount: Decimal;
        PrincipalAmount: Decimal;
    begin
    end;

    [Scope('Internal')]
    procedure Penaltycal(VFinHrd: Record "33020062"; VFinLine: Record "33020063"): Decimal
    begin
    end;

    [Scope('Internal')]
    procedure ProcessPaymentJournal()
    var
        NewSeries: Boolean;
    begin
        NewNoSeries := FALSE;
        VFSetup.GET;
        //Bank or Cash debit
        CreateVFJournal_HP.SetClearLoan(ClearLoan);
        CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
        CreateVFJournal_HP.SetTraceID("Temp Trace ID/Ref ID");      //Oct 11 2017

        CreateVFJournal_HP.LoanApproval(TODAY, AccountType::"Bank Account", BankAccount
          , 'Cash receipt against Loan Due of ' + "Loan No.",
          ROUND(PaymentAmount, 0.01, '='), "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code",
          "Shortcut Dimension 2 Code", 0, VFPostingType::" ", FALSE, TRUE,
          "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description", "Shortcut Dimension 3 Code");
        CreateVFJournal_HP.LoanApproval(TODAY, AccountType::Customer, "Nominee Account No."
          , 'Cash receipt against Loan Due of ' + "Loan No.",
          -ROUND(PaymentAmount, 0.01, '='), "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code",
          "Shortcut Dimension 2 Code", 0, VFPostingType::" ", FALSE, NewNoSeries,
          "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description", "Shortcut Dimension 3 Code");

        CalculateEMI.AvoidRounding("Loan No.", "Temp Cash Receipt No.");

        PostPaymentJournal;
    end;

    [Scope('Internal')]
    procedure PostPaymentJournal()
    var
        GenJnlBatchPost: Codeunit "233";
        GenJnlLine: Record "81";
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", VFSetup."VF Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", UserSetup."VF Posting Batch");
        IF GenJnlLine.FINDFIRST THEN BEGIN
            COMMIT;
            IF NOT PostReceiptOnly THEN  //SRT Sept 19th 2019
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print", GenJnlLine)
            ELSE  //SRT Sept 19th 2019
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnlLine);  //SRT Sept 19th 2019
        END;
    end;

    [Scope('Internal')]
    procedure OpenLoanFiles(NomineeAccountNo: Code[20])
    var
        ApprovedVehicleFinanceList: Page "33020068";
        VFHeader: Record "33020062";
    begin
        VFHeader.RESET;
        VFHeader.SETRANGE("Nominee Account No.", NomineeAccountNo);
        VFHeader.SETRANGE(Approved, TRUE);
        VFHeader.SETRANGE(Closed, FALSE);
        VFHeader.SETRANGE("Loan Disbursed", TRUE);
        ApprovedVehicleFinanceList.SETTABLEVIEW(VFHeader);
        ApprovedVehicleFinanceList.RUN;
    end;
}

