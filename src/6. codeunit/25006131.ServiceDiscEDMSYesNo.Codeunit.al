codeunit 25006131 "Service-Disc. EDMS (Yes/No)"
{
    TableNo = 25006146;

    trigger OnRun()
    begin
        ServLine.COPY(Rec);
        IF CONFIRM(Text000, FALSE) THEN
            SalesCalcDisc.RUN(ServLine);
        Rec := ServLine;
    end;

    var
        Text000: Label 'Do you want to calculate the invoice discount?';
        ServLine: Record "25006146";
        SalesCalcDisc: Codeunit "25006130";
}

