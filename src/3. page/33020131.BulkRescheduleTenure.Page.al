page 33020131 "Bulk Reschedule Tenure"
{

    layout
    {
        area(content)
        {
            group(Filters)
            {
                field(LoanFilter; LoanNoFilter)
                {
                    Caption = 'Loan No. Filter';
                }
            }
            group("Rescheduling Parameters")
            {
                field(NewInterestRate; NewInterestRate)
                {
                    Caption = 'New Interest Rate';
                }
                field(DocumentDate; DocumentDate)
                {
                    Caption = 'Document Date';
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
                        IF (NewInterestRate = 0)
                           OR (ReasonText = '') OR (DocumentDate = 0D) THEN
                            ERROR('All fields are mandatory for rescheduling.');

                        VehFinHeader.RESET;
                        VehFinHeader.SETFILTER("Loan No.", LoanNoFilter);
                        IF VehFinHeader.FINDSET THEN
                            REPEAT
                                CLEAR(CalculateEMI);
                                CalculateEMI.CalculateDueAndNRV(VehFinHeader, DocumentDate);
                                COMMIT;
                            UNTIL VehFinHeader.NEXT = 0;

                        VehFinHeader.RESET;
                        VehFinHeader.SETFILTER("Loan No.", LoanNoFilter);
                        IF VehFinHeader.FINDSET THEN
                            REPEAT
                                IF NOT VehFinHeader.Closed THEN BEGIN
                                    InstallmentNo := 0;
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

    trigger OnOpenPage()
    begin
        VFSetup.GET;
        IF VFSetup."Policy Type" <> VFSetup."Policy Type"::"Hire Purchase" THEN
            ERROR('You do not have permission to run this on %1 Company.', COMPANYNAME);
    end;

    var
        VFSetup: Record "33020064";
        CalculateEMI: Codeunit "33020062";
        NewPrincipal: Decimal;
        NewInterestRate: Decimal;
        NewTenure: Decimal;
        StartingInstallmentNo: Integer;
        NewEffectiveDate: Date;
        ReasonText: Text[100];
        LoanNoFilter: Text;
        Text0001: Label 'The loan file %1 is already closed. You can not make any changes on this file.';
        PrepaymentAmount: Decimal;
        Text0002: Label 'The loan file %1 has outstanding dues. You can not reschedule this loan file.';
        DocumentDate: Date;
        CheckNo: Code[20];
        BankAccount: Code[20];
        CheckofBank: Text[50];
}

