page 33020133 "Capitalize Loan"
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
                field(CapitalizationAmount; CapitalizationAmount)
                {
                    Caption = 'Capitalization Amount';

                    trigger OnValidate()
                    begin
                        IF NewInterestRate <> "Interest Rate" THEN
                            ERROR('You cannot change prepayment amount if interest rate is changed.');
                    end;
                }
                field(NewInterestRate; NewInterestRate)
                {
                    Caption = 'New Interest Rate';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        IF NewInterestRate <> "Interest Rate" THEN
                            CapitalizationAmount := 0;
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
                action("Capitalize Loan")
                {
                    Caption = 'Capitalize Loan';
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
                        CLEAR(CalculateEMI);
                        CalculateEMI.CalculateDueAndNRV(Rec, DocumentDate);
                        COMMIT;
                        CurrPage.UPDATE;

                        VehFinHeader.RESET;
                        VehFinHeader.SETFILTER("Loan No.", LoanNoFilter);
                        IF VehFinHeader.FINDSET THEN
                            REPEAT
                                InstallmentNo := 0;
                                IF VehFinHeader.Closed THEN
                                    ERROR(Text0001, VehFinHeader."Loan No.");
                                IsRescheduled := CalculateEMI.RescheduleTenure(-CapitalizationAmount, NewInterestRate, VehFinHeader."Loan No.", ReasonText, DocumentDate, CheckofBank, CheckNo, BankAccount, TRUE);
                                IF IsRescheduled THEN BEGIN
                                    VFLine.SETRANGE("Loan No.", VehFinHeader."Loan No.");
                                    IF VFLine.FINDFIRST THEN BEGIN
                                        VehFinHeader."Tenure in Months" := VFLine.COUNT;
                                        VehFinHeader."Loan Amount" := VehFinHeader."Loan Amount" + CapitalizationAmount;
                                        IF NewInterestRate <> 0 THEN BEGIN
                                            VehFinHeader."Interest Rate" := NewInterestRate;
                                            VehFinHeader."Penalty %" := NewInterestRate + VFSetup."Penalty % - Interest %";
                                        END;
                                        VehFinHeader.MODIFY;
                                    END;
                                END;
                            UNTIL VehFinHeader.NEXT = 0;

                        IF IsRescheduled THEN BEGIN
                            MESSAGE('Loan capitalized successfully. Please post rescheduling jounrnal entry for accounting effects.');
                            CurrPage.CLOSE;
                            CashRcptRec.RESET;
                            CashRcptRec.SETRANGE("Loan File No.", "Loan No.");
                            IF CashRcptRec.FINDFIRST THEN
                                PAGE.RUN(PAGE::"Cash Receipt Journal", CashRcptRec); //Min 11.11.2020 immediatly run cash receipt after loan capitalize
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LoanNoFilter := "Loan No.";
        CapitalizationAmount := "Total Due as of Today";
        NewInterestRate := "Interest Rate";
    end;

    trigger OnOpenPage()
    begin
        DocumentDate := WORKDATE;
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
        LoanNoFilter: Text[250];
        Text0001: Label 'The loan file %1 is already closed. You can not make any changes on this file.';
        CapitalizationAmount: Decimal;
        Text0002: Label 'The loan file %1 has outstanding dues. You can not reschedule this loan file.';
        DocumentDate: Date;
        CheckNo: Code[20];
        BankAccount: Code[20];
        CheckofBank: Text[50];
        CashRcptJnl: Page "255";
        CashRcptRec: Record "81";
}

