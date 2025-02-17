page 33020083 "Reschedule EMI"
{
    SourceTable = Table33020062;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                field(LoanFilter; LoanNoFilter)
                {
                    Caption = 'Loan No. Filter';
                    Editable = false;
                    QuickEntry = false;
                }
            }
            group("Old Parameters")
            {
                field("Loan Amount"; "Loan Amount")
                {
                    QuickEntry = false;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    Editable = false;
                    QuickEntry = false;
                }
                field("Tenure in Months"; "Tenure in Months")
                {
                    Editable = false;
                    QuickEntry = false;
                }
            }
            group("Rescheduling Parameters")
            {
                field("Document Date"; DocumentDate)
                {
                }
                field(StartingInstallmentNo; StartingInstallmentNo)
                {
                    Caption = 'Starting from Installment No.';
                    Editable = true;
                    QuickEntry = false;
                }
                field(NewEffectiveDate; NewEffectiveDate)
                {
                    Caption = 'New EMI Start Date';
                    Editable = true;
                    QuickEntry = false;
                }
                field(NewPrincipal; NewPrincipal)
                {
                    Editable = false;
                }
                field(NewTenure; NewTenure)
                {

                    trigger OnValidate()
                    begin
                        IF PrepaymentAmount <> 0 THEN BEGIN
                            IF "Tenure in Months" <> NewTenure THEN
                                ERROR('Prepayment Amount must be zero if Tenure is changed.');
                        END;
                    end;
                }
                field("New Interest Rate"; NewInterestRate)
                {

                    trigger OnValidate()
                    begin
                        IF NewInterestRate <> "Interest Rate" THEN
                            PrepaymentAmount := 0;
                    end;
                }
                field("Prepayment Amount"; PrepaymentAmount)
                {

                    trigger OnValidate()
                    begin
                        IF NewInterestRate <> "Interest Rate" THEN
                            ERROR('You cannot change prepayment amount if interest rate is changed.');
                        NewPrincipal := GetNewPrincipal("Loan No.", PrepaymentAmount);
                        IF PrepaymentAmount <> 0 THEN BEGIN
                            IF "Tenure in Months" <> NewTenure THEN
                                ERROR('Prepayment Amount must be zero if Tenure is changed.');
                        END;
                    end;
                }
                field(ReasonText; ReasonText)
                {
                    Caption = 'Reason for Rescheduling';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102159021>")
            {
                Caption = 'Reschedule';
                action("Reschedule Loan")
                {
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        VehFinHeader: Record "33020062";
                        VehReschedule: Page "33020083";
                        IsRescheduled: Boolean;
                        InstallmentNo: Integer;
                    begin
                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                            IF (StartingInstallmentNo = 0) OR (NewInterestRate = 0) OR (NewPrincipal = 0) OR (NewTenure = 0)
                               OR (ReasonText = '') OR (NewEffectiveDate = 0D) OR (DocumentDate = 0D) THEN
                                ERROR('All fields are mandatory for rescheduling for Hire Purchase.');
                        END ELSE BEGIN
                            IF (StartingInstallmentNo = 0) OR (NewInterestRate = 0) OR (NewPrincipal = 0) OR (NewTenure = 0)
                               OR (ReasonText = '') OR (NewEffectiveDate = 0D) OR (DocumentDate = 0D) OR (BankAccount = '') THEN
                                ERROR('All fields are mandatory for rescheduling.');
                        END;

                        CLEAR(CalculateEMI);
                        CalculateEMI.CalculateDueAndNRV(Rec, DocumentDate);
                        COMMIT;
                        CurrPage.UPDATE;


                        IF NewInterestRate = "Interest Rate" THEN BEGIN
                            IF "Total Due" < NewPrincipal THEN
                                ERROR('Prepayment Amount cannot be greater than Total Due.');

                            IF "Total Due as of Today" <> 0 THEN
                                ERROR('There are outstanding dues for this Loan. Please clear dues before you proceed for EMI Rescheduling.');
                        END;

                        VehFinHeader.RESET;
                        VehFinHeader.SETFILTER("Loan No.", LoanNoFilter);
                        IF VehFinHeader.FINDSET THEN
                            REPEAT
                                InstallmentNo := 0;
                                IF VehFinHeader.Closed THEN
                                    ERROR(Text0001, VehFinHeader."Loan No.");
                                //IF CalculateEMI.PartialPaymentExists(VehFinHeader."Loan No.",InstallmentNo) THEN
                                //ERROR('Re-Schedule cannot be done.Partial Payment Exists for Loan Document %1 on Installment %2.',VehFinHeader."Loan No.",InstallmentNo);
                                IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                                    IsRescheduled :=
                                      CalculateEMI.RescheduleEMI(VehFinHeader."Loan No.", StartingInstallmentNo,
                                                                  NewInterestRate, NewPrincipal, NewTenure, NewEffectiveDate, ReasonText, DocumentDate, CheckofBank, CheckNo, BankAccount, PrepaymentAmount)
                                ELSE
                                    IsRescheduled :=
                                      CalculateEMI_VF.RescheduleEMI(VehFinHeader."Loan No.", StartingInstallmentNo,
                                                                  NewInterestRate, NewPrincipal, NewTenure, NewEffectiveDate, ReasonText);
                            UNTIL VehFinHeader.NEXT = 0;
                        IF IsRescheduled THEN
                            MESSAGE('Loan rescheduled successfully. Please post rescheduling jounrnal entry for accounting effects.');
                        CurrPage.CLOSE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF NOT VariableInitiated THEN BEGIN
            LoanNoFilter := "Loan No.";
            NewInterestRate := "Interest Rate";
            NewTenure := "Tenure in Months";
            GetNewParametersForRescheduleEMI("Loan No.", StartingInstallmentNo, NewEffectiveDate, NewPrincipal);
            VariableInitiated := TRUE;
        END;
    end;

    trigger OnOpenPage()
    begin
        DocumentDate := WORKDATE;
    end;

    var
        VFSetup: Record "33020064";
        CalculateEMI: Codeunit "33020062";
        CalculateEMI_VF: Codeunit "33020065";
        NewPrincipal: Decimal;
        NewInterestRate: Decimal;
        NewTenure: Decimal;
        StartingInstallmentNo: Integer;
        NewEffectiveDate: Date;
        ReasonText: Text[100];
        LoanNoFilter: Text[250];
        Text0001: Label 'The loan file %1 is already closed. You can not make any changes on this file.';
        PrepaymentAmount: Decimal;
        DocumentDate: Date;
        CheckNo: Code[20];
        BankAccount: Code[20];
        CheckofBank: Text[50];
        VariableInitiated: Boolean;
}

