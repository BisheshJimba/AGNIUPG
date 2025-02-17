page 33020130 "Bulk Reschedule EMI"
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
                    QuickEntry = false;
                }
            }
            group("Rescheduling Parameters")
            {
                field("New Interest Rate"; NewInterestRate)
                {
                }
                field(ReasonText; ReasonText)
                {
                    Caption = 'Reason for Rescheduling';
                }
                field("Document Date"; DocumentDate)
                {
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
                        ErrorLoanFiles: Text;
                        InstallmentNo: Integer;
                    begin
                        VFSetup.GET;
                        IF VFSetup."Policy Type" <> VFSetup."Policy Type"::"Hire Purchase" THEN
                            EXIT;
                        IF (NewInterestRate = 0) OR (ReasonText = '') OR (DocumentDate = 0D) THEN
                            ERROR('All fields are mandatory for rescheduling for Hire Purchase.');


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
                                    /* IF CalculateEMI.PartialPaymentExists(VehFinHeader."Loan No.",InstallmentNo) THEN BEGIN
                                        IF ErrorLoanFiles = '' THEN
                                          ErrorLoanFiles := VehFinHeader."Loan No."
                                        ELSE
                                          ErrorLoanFiles += '|' + VehFinHeader."Loan No.";

                                     END
                                     ELSE BEGIN  */
                                    StartingInstallmentNo := 0;
                                    NewEffectiveDate := 0D;
                                    NewPrincipal := 0;
                                    VehFinHeader.GetNewParametersForRescheduleEMI(VehFinHeader."Loan No.", StartingInstallmentNo, NewEffectiveDate, NewPrincipal);
                                    IsRescheduled :=
                                      CalculateEMI.RescheduleEMI(VehFinHeader."Loan No.", StartingInstallmentNo,
                                                                  NewInterestRate, NewPrincipal, VehFinHeader."Tenure in Months", NewEffectiveDate, ReasonText, DocumentDate, '', '', '', 0)
                                END;
                            //END;

                            UNTIL VehFinHeader.NEXT = 0;

                        IF ErrorLoanFiles <> '' THEN
                            ErrorText := STRSUBSTNO(Text0002, ErrorLoanFiles);

                        IF IsRescheduled THEN
                            MESSAGE('Loan rescheduled successfully.\' +
                                    '\' + ErrorText);
                        CurrPage.CLOSE;

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
        DocumentDate := WORKDATE;
    end;

    var
        VFSetup: Record "33020064";
        CalculateEMI: Codeunit "33020062";
        NewInterestRate: Decimal;
        ReasonText: Text[100];
        LoanNoFilter: Text;
        Text0001: Label 'The loan file %1 is already closed. You can not make any changes on this file.';
        DocumentDate: Date;
        Text0002: Label 'There are partial payment for following Loan files. Please clear dues before you proceed for EMI Rescheduling.\%1';
        ErrorText: Text;
        NewPrincipal: Decimal;
        StartingInstallmentNo: Integer;
        NewEffectiveDate: Date;
}

