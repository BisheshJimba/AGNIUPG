page 33020075 "Change Interest Percentage"
{
    PageType = Card;
    SourceTable = Table33020062;

    layout
    {
        area(content)
        {
            field("Loan No."; "Loan No.")
            {
                Enabled = false;
            }
            field("Customer No."; "Customer No.")
            {
                Editable = false;
            }
            field("Loan Amount"; "Loan Amount")
            {
                Editable = false;
            }
            field("Pending Principal Amount"; "Pending Principal Amount")
            {
                Caption = 'Pending Principal Amount';
                Editable = false;
            }
            field("Tenure in Months"; "Tenure in Months")
            {
                Editable = false;
            }
            field(unCompletedInstallment; unCompletedInstallment)
            {
                Caption = 'No of Incomplete Installments';
                Editable = false;
            }
            field("Interest Rate"; "Interest Rate")
            {
                Editable = false;
            }
            field("New Interest Percentage"; NewInterestPercentage)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Change Interest Rate")
            {
                Caption = 'Change Interest Rate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF "Pending Principal Amount" <= 0 THEN
                        ERROR('Pending Principal Amount must be greater than Zero');
                    IF NewInterestPercentage <= 0 THEN
                        ERROR('New interest rate must be greater than Zero');

                    ok := CONFIRM('Do you want to recalculate with new interest rate ?');
                    IF ok THEN BEGIN
                        CalculateEMI.CalculateEMI("Pending Principal Amount", NewInterestPercentage, unCompletedInstallment, "Loan No.", TRUE);

                    END;
                end;
            }
            action(Calculate)
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CLEAR(RecalculateAmount);
                    CLEAR(unCompletedInstallment);
                    lrecVFLines.SETRANGE(lrecVFLines."Loan No.", "Loan No.");
                    IF lrecVFLines.FINDFIRST THEN
                        REPEAT
                            RecalculateAmount += lrecVFLines."Principal Paid";
                        UNTIL lrecVFLines.NEXT = 0;
                    //MESSAGE(FORMAT("Loan Amount"));
                    //MESSAGE(FORMAT(RecalculateAmount));
                    "Pending Principal Amount" := "Loan Amount" - RecalculateAmount;

                    lrecVFLines.SETRANGE(lrecVFLines."Loan No.", "Loan No.");
                    lrecVFLines.SETRANGE(lrecVFLines."Line Cleared", TRUE);
                    IF lrecVFLines.FINDFIRST THEN
                        REPEAT
                            unCompletedInstallment += 1;
                        UNTIL lrecVFLines.NEXT = 0;
                    unCompletedInstallment := "Tenure in Months" - unCompletedInstallment;
                end;
            }
        }
    }

    var
        NewInterestPercentage: Decimal;
        "Pending Principal Amount": Decimal;
        lrecVFLines: Record "33020063";
        RecalculateAmount: Decimal;
        ok: Boolean;
        CalculateEMI: Codeunit "33020062";
        unCompletedInstallment: Integer;
}

