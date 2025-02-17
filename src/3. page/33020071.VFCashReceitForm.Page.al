page 33020071 "VF Cash Receit Form"
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
                    Caption = 'Check No.';
                }
                field("Temp Check Bank Account"; "Temp Check Bank Account")
                {
                    Caption = 'Check of Bank';
                }
                field("Bank Account"; BankAccount)
                {
                    TableRelation = "Bank Account";
                }
                field("Payment Description"; "Temp Payment Description")
                {
                }
                field("Wave Penalty"; "Wave Penalty")
                {
                    Editable = NOT IsHirePurchase;
                    Visible = NOT IsHirePurchase;

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
                    Editable = NOT IsHirePurchase;
                    Visible = NOT IsHirePurchase;
                }
                field("Clear Loan"; ClearLoan)
                {
                    Visible = IsHirePurchase;

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
                field("Other Amount Due"; "Other Amount Due")
                {
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
                }
                field("Total Due"; "Total Due")
                {
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
                action("Process Receipt")
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
                    begin
                        VFSetup.GET;
                        RecVehFHeader.RESET;
                        RecVehFHeader.SETCURRENTKEY("Transfered Loan No.");
                        RecVehFHeader.SETRANGE("Transfered Loan No.", "Application No.");
                        IF NOT RecVehFHeader.FINDFIRST THEN
                            TESTFIELD(Approved); //june 14, 2016
                                                 //TESTFIELD("Loan Disbursed");
                        CALCFIELDS("Last Payment Date");
                        "Payment Received Date" := "Payment Receipt Date";

                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                            CLEAR(CalculateEMI);
                            CalculateEMI.CalculateDueAndNRV(Rec, "Payment Receipt Date");
                        END
                        ELSE BEGIN
                            CLEAR(CalculateEMI_VF);
                            CalculateEMI_VF.CalculateDueAndNRV(Rec, "Payment Receipt Date");
                        END;
                        COMMIT;

                        IF BankAccount = '' THEN
                            ERROR('Bank Account can not be blank.');
                        IF ("Payment Received Date" = 0D) THEN
                            ERROR('Payment Received Date can not be blank.');

                        IF ("Payment Received Date" < "Last Payment Date") THEN
                            ERROR('Payment Received Date can not be earlier than Last Payment Date. Last payment was received on %1.', "Last Payment Date");

                        IF PaymentAmount <= 0 THEN
                            ERROR('Payment amount can not be 0 or less');

                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                            IF NOT ClearLoan THEN BEGIN
                                IF NOT "Wave Penalty" THEN BEGIN
                                    IF ROUND(PaymentAmount, 1, '>') > ROUND(("Principal Due" + "Interest Due" + "Penalty Due"), 1, '>') THEN
                                        ERROR('Payment Amount can not exceed Total Outstanding Due.');
                                END ELSE BEGIN
                                    IF ROUND(PaymentAmount, 1, '>') > ROUND(("Principal Due"), 1, '>') THEN
                                        ERROR('Payment Amount can not exceed Total Outstanding Due.');
                                END;
                            END;
                        END;

                        GenJnlLine.SETRANGE("VF Loan File No.", "Loan No.");
                        IF GenJnlLine.FINDFIRST THEN
                            ERROR('You can not process cash receipt for this loan file. '
                                    + 'There are unposted Journal Lines in Batch Name: %1. Please post those journal line before creating new cash'
                                    + ' receipt', GenJnlLine."Journal Batch Name");

                        OK := CONFIRM('Do you want to create Cash Receipt Journals for this loan?');
                        IF OK THEN BEGIN
                            CALCFIELDS(VIN);
                            CLEAR(lPendingAmt);
                            CLEAR(lPostedAmt);
                            lPendingAmt := PaymentAmount;
                            CLEAR(PenaltyFlag);
                            CLEAR(Flag);
                            IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                                ProcessPaymentJournal
                            ELSE
                                CreatePaymentJournal;
                            //COMMIT;
                            CurrPage.SETSELECTIONFILTER(VehicleFinanceHeader);
                            REPORT.RUN(50045, FALSE, TRUE, VehicleFinanceHeader);

                            VFSetup.GET;
                            "Temp Cash Receipt No." := NoSeriesMngt.GetNextNo(VFSetup."Cash Receipt No.", "Payment Receipt Date", TRUE);
                            //COMMIT;

                            MESSAGE(Text0001);
                            CurrPage.CLOSE;
                        END;
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
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                            CLEAR(CalculateEMI);
                            CalculateEMI.CalculateDueAndNRV(Rec, "Payment Receipt Date");
                        END
                        ELSE BEGIN
                            CLEAR(CalculateEMI_VF);
                            CalculateEMI_VF.CalculateDueAndNRV(Rec, "Payment Receipt Date");
                        END;
                        COMMIT;
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
            TempVFRec.TESTFIELD("Loan Disbursed");
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
        VehicleFinanceLines.RESET;
        VehicleFinanceLines.SETCURRENTKEY("Loan No.", "Installment No.");
        VehicleFinanceLines.SETRANGE("Loan No.", "Loan No.");
        VehicleFinanceLines.SETRANGE("Line Cleared", FALSE);
        IF VehicleFinanceLines.FINDFIRST THEN BEGIN
            NewNoSeries := TRUE;
            VFSetup.GET;
            //Bank or Cash debit
            CreateVFJournal_HP.SetClearLoan(ClearLoan);
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::"Bank Account", BankAccount
              , 'Cash receipt against Loan Due of ' + "Loan No.",
              ROUND(PaymentAmount, 0.01, '='), "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code",
              "Shortcut Dimension 2 Code", VehicleFinanceLines."Installment No.", VFPostingType::Principal, FALSE, TRUE,
              "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description", "Shortcut Dimension 3 Code");
            IF PaymentAmount > 0 THEN BEGIN

                REPEAT
                    IF VehicleFinanceLines."EMI Mature Date" <= "Payment Receipt Date" THEN
                        ProcessPenalty;
                UNTIL NextInstallmentAvailable(VehicleFinanceLines) = FALSE;

                VehicleFinanceLines.RESET;
                VehicleFinanceLines.SETCURRENTKEY("Loan No.", "Installment No.");
                VehicleFinanceLines.SETRANGE("Loan No.", "Loan No.");
                VehicleFinanceLines.SETRANGE("Line Cleared", FALSE);
                IF VehicleFinanceLines.FINDFIRST THEN BEGIN
                    REPEAT
                        IF VehicleFinanceLines."EMI Mature Date" <= "Payment Receipt Date" THEN
                            ProcessInterest;
                    UNTIL NextInstallmentAvailable(VehicleFinanceLines) = FALSE;
                END;

                IF ClearLoan THEN BEGIN
                    ProcessInterestDueDefered;
                END;

                VehicleFinanceLines.RESET;
                VehicleFinanceLines.SETCURRENTKEY("Loan No.", "Installment No.");
                VehicleFinanceLines.SETRANGE("Loan No.", "Loan No.");
                VehicleFinanceLines.SETRANGE("Line Cleared", FALSE);
                IF VehicleFinanceLines.FINDFIRST THEN BEGIN
                    REPEAT
                        ProcessPrincipal;
                    UNTIL NextInstallmentAvailable(VehicleFinanceLines) = FALSE;
                END;

            END;
        END;
        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
            CalculateEMI.AvoidRounding("Loan No.", "Temp Cash Receipt No.")
        ELSE
            CalculateEMI_VF.AvoidRounding("Loan No.", "Temp Cash Receipt No.")
    end;

    [Scope('Internal')]
    procedure ProcessPenalty()
    var
        AvailableforPenalty: Decimal;
    begin
        IF NOT VehicleFinanceLines."Wave Penalty" THEN BEGIN
            AvailableforPenalty := 0;
            //VehicleFinanceLines.CALCFIELDS("Penalty Paid");
            IF PaymentAmount < (VehicleFinanceLines."Calculated Penalty") THEN
                AvailableforPenalty := PaymentAmount
            ELSE
                AvailableforPenalty := (VehicleFinanceLines."Calculated Penalty");
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(ClearLoan);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::"G/L Account", VFSetup."Penalty Posting Account"
              , 'Cash receipt against Penalty Due of ' + "Loan No.",
              ROUND(-AvailableforPenalty, 0.01, '=')
              , "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code",
              "Shortcut Dimension 2 Code", VehicleFinanceLines."Installment No."
              , VFPostingType::Penalty, FALSE, FALSE, "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description",
              "Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - AvailableforPenalty, 1, '=');
        END;
    end;

    [Scope('Internal')]
    procedure ProcessInterest()
    var
        AvailableforInterest: Decimal;
    begin
        AvailableforInterest := 0;
        VehicleFinanceLines.CALCFIELDS("Interest Paid");
        IF (PaymentAmount < (VehicleFinanceLines."Calculated Interest" - VehicleFinanceLines."Interest Paid")) THEN
            AvailableforInterest := PaymentAmount
        ELSE
            AvailableforInterest := (VehicleFinanceLines."Calculated Interest" - VehicleFinanceLines."Interest Paid");
        IF AvailableforInterest > 0 THEN BEGIN
            CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
            CreateVFJournal_HP.SetClearLoan(ClearLoan);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::"G/L Account", VFSetup."Interest Posting Account"
              , 'Cash receipt against Interest Due of ' + "Loan No.",
              ROUND(-AvailableforInterest, 0.01, '=')
              , "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
              VehicleFinanceLines."Installment No.", VFPostingType::Interest, FALSE, FALSE,
              "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description", "Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - AvailableforInterest, 1, '=');
        END;
    end;

    [Scope('Internal')]
    procedure ProcessInterestDueDefered()
    var
        AvailableforInterest: Decimal;
        VehicleFinanceLines: Record "33020063";
    begin
        AvailableforInterest := ROUND("Interest Due Defered", 0.01, '=');
        IF AvailableforInterest > 0 THEN BEGIN
            VehicleFinanceLines.RESET;
            VehicleFinanceLines.SETCURRENTKEY("Loan No.", "Installment No.");
            VehicleFinanceLines.SETRANGE("Loan No.", "Loan No.");
            VehicleFinanceLines.SETRANGE("Line Cleared", FALSE);
            VehicleFinanceLines.SETFILTER("EMI Mature Date", '>%1', "Payment Receipt Date");
            IF VehicleFinanceLines.FINDFIRST THEN BEGIN
                CreateVFJournal_HP.SetReceiptType(ReceiptType::Installment);
                CreateVFJournal_HP.SetClearLoan(ClearLoan);
                CreateVFJournal_HP.LoanApproval("Payment Receipt Date", AccountType::"G/L Account", VFSetup."Interest Posting Account"
                  , 'Cash receipt against Interest Due of ' + "Loan No.",
                  ROUND(-AvailableforInterest, 0.01, '=')
                  , "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                  VehicleFinanceLines."Installment No.", VFPostingType::Interest, FALSE, FALSE,
                  "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description", "Shortcut Dimension 3 Code");
                PaymentAmount := ROUND(PaymentAmount - AvailableforInterest, 1, '=');
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ProcessPrincipal()
    var
        AvailableforPrincipal: Decimal;
        Installment: Integer;
    begin
        AvailableforPrincipal := 0;
        VehicleFinanceLines.CALCFIELDS("Principal Paid");
        IF (PaymentAmount < (VehicleFinanceLines."Calculated Principal" - VehicleFinanceLines."Principal Paid")) THEN
            AvailableforPrincipal := PaymentAmount
        ELSE
            AvailableforPrincipal := (VehicleFinanceLines."Calculated Principal" - VehicleFinanceLines."Principal Paid");
        IF AvailableforPrincipal > 0 THEN BEGIN
            CreateVFJournal_HP.SetClearLoan(ClearLoan);
            CreateVFJournal_HP.LoanApproval(TODAY, AccountType::Customer, "Customer No."
              , STRSUBSTNO('Principal against due of %1 Inst No %2', "Loan No.", VehicleFinanceLines."Installment No."),
              ROUND(-AvailableforPrincipal, 0.01, '=')
              , "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", VehicleFinanceLines."Installment No."
              , VFPostingType::Principal, FALSE, FALSE, "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description",
              "Shortcut Dimension 3 Code");
        END;
        PaymentAmount := ROUND(PaymentAmount - AvailableforPrincipal, 1, '=');
    end;

    [Scope('Internal')]
    procedure NextInstallmentAvailable(var VehicleFinanceLines: Record "33020063"): Boolean
    begin
        IF PaymentAmount > 0 THEN
            IF VehicleFinanceLines.NEXT <> 0 THEN BEGIN
                EXIT(TRUE);
            END;
        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure CreatePaymentJournal()
    var
        AvailableforInterest: Decimal;
        Installment: Integer;
        AvailableforPenalty: Decimal;
        NewSeries: Boolean;
    begin
        VehicleFinanceLines.SETRANGE("Loan No.", "Loan No.");
        VehicleFinanceLines.SETRANGE("Line Cleared", FALSE);

        IF VehicleFinanceLines.FINDFIRST THEN BEGIN
            NewNoSeries := TRUE;
            VFSetup.GET;
            //Bank or Cash debit
            CreateVFJournal_VF.LoanApproval(TODAY, AccountType::"Bank Account", BankAccount
              , 'Cash receipt against Loan Due of ' + "Loan No.",
              ROUND(PaymentAmount, 0.01, '='), "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code",
              "Shortcut Dimension 2 Code", VehicleFinanceLines."Installment No.", VFPostingType::Principal, FALSE, TRUE,
              "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description", "Shortcut Dimension 3 Code");

            //penalty income
            IF NOT "Wave Penalty" THEN BEGIN
                AvailableforPenalty := 0;
                IF PaymentAmount < PenaltyReceived THEN
                    AvailableforPenalty := PaymentAmount
                ELSE
                    AvailableforPenalty := PenaltyReceived;
                CreateVFJournal_VF.LoanApproval(TODAY, AccountType::"G/L Account", VFSetup."Penalty Posting Account"
                  , 'Cash receipt against Penalty Due of ' + "Loan No.",
                  ROUND(-AvailableforPenalty, 0.01, '=')
                  , "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code",
                  "Shortcut Dimension 2 Code", VehicleFinanceLines."Installment No."
                  , VFPostingType::Penalty, FALSE, FALSE, "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description",
                  "Shortcut Dimension 3 Code");
                PaymentAmount := ROUND(PaymentAmount - PenaltyReceived, 1, '=');
            END;

            //interest income
            AvailableforInterest := 0;
            IF (PaymentAmount < "Interest Due") THEN
                AvailableforInterest := PaymentAmount
            ELSE
                AvailableforInterest := "Interest Due";
            IF AvailableforInterest > 0 THEN
                CreateVFJournal_VF.LoanApproval(TODAY, AccountType::"G/L Account", VFSetup."Interest Posting Account"
                  , 'Cash receipt against Interest Due of ' + "Loan No.",
                  ROUND(-AvailableforInterest, 0.01, '=')
                  , "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
                  VehicleFinanceLines."Installment No.", VFPostingType::Interest, FALSE, FALSE,
                  "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description", "Shortcut Dimension 3 Code");
            PaymentAmount := ROUND(PaymentAmount - "Interest Due", 1, '=');
        END;

        //principal income
        Installment := VehicleFinanceLines."Installment No.";
        WHILE (PaymentAmount > 1) DO BEGIN
            VFLine2.RESET;
            VFLine2.SETRANGE("Loan No.", "Loan No.");
            VFLine2.SETRANGE("Installment No.", Installment);
            IF VFLine2.FINDFIRST THEN BEGIN
                VFLine2.CALCFIELDS("Principal Paid");
                IF PaymentAmount > (VFLine2."Calculated Principal" - VFLine2."Principal Paid") THEN BEGIN
                    CreateVFJournal_VF.LoanApproval(TODAY, AccountType::Customer, "Customer No."
                      , STRSUBSTNO('Principal against due of %1 Inst No %2', "Loan No.", Installment),
                      ROUND(-(VFLine2."Calculated Principal" - VFLine2."Principal Paid"), 0.01, '=')
                      , "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", Installment
                      , VFPostingType::Principal, FALSE, FALSE, "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description",
                      "Shortcut Dimension 3 Code");
                END ELSE
                    CreateVFJournal_VF.LoanApproval(TODAY, AccountType::Customer, "Customer No."
                      , STRSUBSTNO('Principal against due of %1 Inst No %2', "Loan No.", Installment),
                      ROUND(-PaymentAmount, 0.01, '=')
                      , "Loan No.", VIN, 'DEFAULT', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", Installment
                      , VFPostingType::Principal, FALSE, FALSE, "Payment Received Date", FALSE, "Temp Cash Receipt No.", "Temp Payment Description",
                      "Shortcut Dimension 3 Code");

                PaymentAmount := ROUND(PaymentAmount - (VFLine2."Calculated Principal" - VFLine2."Principal Paid"), 1, '=');
                Installment += 1;
            END;
        END;
        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
            CalculateEMI.AvoidRounding("Loan No.", "Temp Cash Receipt No.")
        ELSE
            CalculateEMI_VF.AvoidRounding("Loan No.", "Temp Cash Receipt No.")
    end;
}

