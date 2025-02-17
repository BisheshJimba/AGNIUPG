codeunit 33020501 "Payroll-Post (Yes/No)"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    TableNo = 33020510;

    trigger OnRun()
    begin
        SalaryHeader.COPY(Rec);
        Code;
        Rec := SalaryHeader;
    end;

    var
        SalaryHeader: Record "33020510";
        PayrollPost: Codeunit "33020500";

    local procedure "Code"()
    var
        Text001: Label 'Do you want to post the Salary Plan?';
    begin
        IF NOT CONFIRM(Text001, TRUE) THEN
            EXIT;
        PayrollPost.RUN(SalaryHeader);
        COMMIT;
    end;
}

