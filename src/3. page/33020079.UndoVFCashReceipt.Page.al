page 33020079 "Undo VF Cash Receipt"
{

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Loan No."; LoanNo)
                {
                    TableRelation = "Vehicle Finance Header"."Loan No.";
                }
                field("Receipt No."; ReceiptNo)
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
                action("Undo Receipt")
                {
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF (ReceiptNo = '') OR (LoanNo = '') THEN
                            ERROR('There is nothing to undo.');

                        VFPaymentLine.RESET;
                        VFPaymentLine.SETRANGE("Loan No.", LoanNo);
                        VFPaymentLine.SETRANGE("G/L Receipt No.", ReceiptNo);
                        IF VFPaymentLine.FINDFIRST THEN
                            LastPaymentDate := VFPaymentLine."Payment Date"
                        ELSE
                            EXIT;

                        VFPaymentLine.RESET;
                        VFPaymentLine.SETRANGE("Loan No.", LoanNo);
                        VFPaymentLine.SETFILTER("Payment Date", '>%1', LastPaymentDate);
                        IF VFPaymentLine.FINDFIRST THEN
                            ERROR('There are other entries posted to this loan file. Please undo Receipt %1 before processing undo for receipt %2.',
                                  VFPaymentLine."G/L Receipt No.", ReceiptNo);


                        VFLine.CALCFIELDS("Last Receipt No.");
                        VFLine.SETRANGE("Loan No.", LoanNo);
                        VFLine.SETRANGE("Last Receipt No.", ReceiptNo);
                        IF VFLine.FINDFIRST THEN
                            REPEAT
                                VFLine."Line Cleared" := FALSE;
                                VFLine."Last Payment Date" := 0D;
                                VFLine.MODIFY;
                            UNTIL VFLine.NEXT = 0;

                        VFPaymentLine.RESET;
                        VFPaymentLine.SETRANGE("Loan No.", LoanNo);
                        VFPaymentLine.SETRANGE("G/L Receipt No.", ReceiptNo);
                        IF VFPaymentLine.FINDFIRST THEN
                            VFPaymentLine.DELETEALL;

                        RearrangePrincipal(LoanNo);
                        MESSAGE('Updo receipt posted successfully.');
                    end;
                }
            }
        }
    }

    var
        ReceiptNo: Code[20];
        LoanNo: Code[20];
        VFPaymentLine: Record "33020072";
        VFLine: Record "33020063";
        LastPaymentDate: Date;
        VFRec: Record "33020062";
        PrincipalPaidTotal: Decimal;

    [Scope('Internal')]
    procedure RearrangePrincipal(LoanNos: Code[20])
    var
        VFline2: Record "33020063";
    begin
        VFRec.GET(LoanNos);
        CLEAR(PrincipalPaidTotal);
        VFLine.RESET;
        VFLine.SETRANGE("Loan No.", LoanNo);
        IF VFLine.FINDFIRST THEN BEGIN
            REPEAT
                VFline2.RESET;
                VFline2.SETRANGE("Loan No.", LoanNo);
                VFline2.SETFILTER("Installment No.", '%1..%2', 1, VFLine."Installment No.");
                IF VFline2.FINDFIRST THEN BEGIN
                    PrincipalPaidTotal := 0;
                    REPEAT
                        VFline2.CALCFIELDS("Principal Paid");
                        PrincipalPaidTotal += VFline2."Principal Paid";
                    UNTIL VFline2.NEXT = 0;
                END;
                VFLine."Remaining Principal Amount" := VFRec."Loan Amount" - PrincipalPaidTotal;
                VFLine.MODIFY;
            UNTIL VFLine.NEXT = 0;
        END;
    end;
}

