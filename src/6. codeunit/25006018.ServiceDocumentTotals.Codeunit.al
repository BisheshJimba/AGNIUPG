codeunit 25006018 "Service Document Totals"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure CalculateServiceHeaderTotals(var ServiceHeader: Record "25006145"; var VATAmount: Decimal; ServiceLine: Record "25006146")
    begin
        IF ServiceHeader.GET(ServiceLine."Document Type", ServiceLine."Document No.") THEN BEGIN
            ServiceHeader.CALCFIELDS(Amount, "Amount Including VAT");
            VATAmount := ServiceHeader."Amount Including VAT" - ServiceHeader.Amount;
        END;
    end;
}

