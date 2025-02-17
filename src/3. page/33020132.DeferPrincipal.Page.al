page 33020132 "Defer Principal"
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
                field(NoOfInstallments; NoOfInstallments)
                {
                    Caption = 'No. of Installments';
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
                        IsDiffered: Boolean;
                        InstallmentNo: Integer;
                        VFLine: Record "33020063";
                        linecount: Integer;
                    begin
                        IF (StartingInstallmentNo = 0) OR (NoOfInstallments = 0)
                           OR (ReasonText = '') OR (DocumentDate = 0D) THEN
                            ERROR('All fields are mandatory for differing principal for Hire Purchase.');

                        CLEAR(CalculateEMI);
                        CalculateEMI.CalculateDueAndNRV(Rec, DocumentDate);
                        COMMIT;
                        CurrPage.UPDATE;

                        VFLine.RESET;
                        VFLine.SETRANGE("Loan No.", LoanNoFilter);
                        IF VFLine.FINDSET THEN
                            linecount := VFLine.COUNT;

                        IF (StartingInstallmentNo > linecount) OR (StartingInstallmentNo < 1) OR ((StartingInstallmentNo + NoOfInstallments - 1) > linecount) THEN
                            ERROR('Invalid Starting Installment No. or No. of Installments Parameter, Please check and correct');

                        VehFinHeader.RESET;
                        VehFinHeader.SETFILTER("Loan No.", LoanNoFilter);
                        IF VehFinHeader.FINDSET THEN
                            REPEAT
                                IF VehFinHeader.Closed THEN
                                    ERROR(Text0001, VehFinHeader."Loan No.");
                                IsDiffered := CalculateEMI.DifferPrincipal(VehFinHeader."Loan No.", StartingInstallmentNo, StartingInstallmentNo + NoOfInstallments - 1)
                            UNTIL VehFinHeader.NEXT = 0;
                        IF IsDiffered THEN
                            MESSAGE('Loan rescheduled successfully. Please check the loan file to see the effects.');
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
        StartingInstallmentNo: Integer;
        NoOfInstallments: Integer;
        ReasonText: Text[100];
        LoanNoFilter: Text[250];
        Text0001: Label 'The loan file %1 is already closed. You can not make any changes on this file.';
        DocumentDate: Date;
        VariableInitiated: Boolean;
}

