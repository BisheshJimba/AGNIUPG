page 33020126 "Reschedule Tenure"
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
                }
            }
            group("Old Parameters")
            {
                field("Loan Amount"; "Loan Amount")
                {
                }
                field("Total Due"; "Total Due")
                {
                }
                field("Interest Rate"; "Interest Rate")
                {
                    Editable = false;
                }
                field("Tenure in Months"; "Tenure in Months")
                {
                    Editable = false;
                }
            }
            group("Rescheduling Parameters")
            {
                field(DocumentDate; DocumentDate)
                {
                    Caption = 'Document Date';
                }
                field(PrepaymentAmount; PrepaymentAmount)
                {
                    Caption = 'Prepayment Amount';

                    trigger OnValidate()
                    begin
                        IF NewInterestRate <> "Interest Rate" THEN
                            ERROR('You cannot change prepayment amount if interest rate is changed.');
                    end;
                }
                field(NewInterestRate; NewInterestRate)
                {
                    Caption = 'New Interest Rate';

                    trigger OnValidate()
                    begin
                        IF NewInterestRate <> "Interest Rate" THEN
                            PrepaymentAmount := 0;
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
                action("Reschedule Tenure")
                {
                    Caption = 'Reschedule Tenure';
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
                        CalculateEMI: Codeunit "33020062";
                        CalculateEMI_VF: Codeunit "33020065";
                        VFLine: Record "33020063";
                        InstallmentNo: Integer;
                    begin
                        IF (NewInterestRate = 0) //or (PrepaymentAmount <= 0)
                           OR (ReasonText = '') OR (DocumentDate = 0D) THEN
                            ERROR('All fields are mandatory for rescheduling.');


                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                            CLEAR(CalculateEMI);
                            CalculateEMI.CalculateDueAndNRV(Rec, DocumentDate);
                        END
                        ELSE BEGIN
                            CLEAR(CalculateEMI_VF);
                            CalculateEMI_VF.CalculateDueAndNRV(Rec, DocumentDate);
                        END;
                        COMMIT;

                        CurrPage.UPDATE;

                        //{
                        IF NewInterestRate = "Interest Rate" THEN
                            IF "Total Due as of Today" <> 0 THEN
                                ERROR('There are outstanding dues for this Loan. Please clear dues before you proceed for Tenure Rescheduling.');
                        //}
                        IF "Total Due" < PrepaymentAmount THEN
                            ERROR('Prepayment Amount cannot be greater than Total Due.');


                        VehFinHeader.RESET;
                        VehFinHeader.SETFILTER("Loan No.", LoanNoFilter);
                        IF VehFinHeader.FINDSET THEN
                            REPEAT
                                InstallmentNo := 0;
                                IF VehFinHeader.Closed THEN
                                    ERROR(Text0001, VehFinHeader."Loan No.");


                                // {
                                IF NewInterestRate = "Interest Rate" THEN
                                    IF ROUND(VehFinHeader."Total Due as of Today", 1, '=') <> 0 THEN
                                        ERROR(Text0002, VehFinHeader."Loan No.");
                                // }

                                IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                                    IsRescheduled := CalculateEMI.RescheduleTenure(PrepaymentAmount, NewInterestRate, VehFinHeader."Loan No.", ReasonText, DocumentDate, CheckofBank, CheckNo, BankAccount, FALSE);
                                IF IsRescheduled THEN BEGIN
                                    VFLine.SETRANGE("Loan No.", VehFinHeader."Loan No.");
                                    IF VFLine.FINDFIRST THEN BEGIN
                                        VehFinHeader."Tenure in Months" := VFLine.COUNT;
                                        IF NewInterestRate <> 0 THEN BEGIN
                                            VehFinHeader."Interest Rate" := NewInterestRate;
                                            VehFinHeader."Penalty %" := NewInterestRate + VFSetup."Penalty % - Interest %";
                                        END;
                                        VehFinHeader.MODIFY;
                                    END;
                                END;
                            UNTIL VehFinHeader.NEXT = 0;

                        IF IsRescheduled THEN BEGIN
                            MESSAGE('Loan rescheduled successfully. Please post rescheduling jounrnal entry for accounting effects.');
                            CurrPage.CLOSE;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LoanNoFilter := "Loan No.";
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
        Text0002: Label 'The loan file %1 has outstanding dues. You can not reschedule this loan file.';
        DocumentDate: Date;
        CheckNo: Code[20];
        BankAccount: Code[20];
        CheckofBank: Text[50];
}

