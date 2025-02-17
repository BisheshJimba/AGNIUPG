codeunit 25006123 "Serv-Quote to Order (Y/N) EDMS"
{
    TableNo = 25006145;

    trigger OnRun()
    begin
        Rec.TESTFIELD("Document Type", Rec."Document Type"::Quote);
        IF GUIALLOWED THEN
            IF NOT CONFIRM(Text000, FALSE) THEN
                EXIT;

        IF (Rec."Document Type" = Rec."Document Type"::Quote) THEN
            IF CheckCustomerCreated(TRUE) AND CheckVehicleCreated(TRUE) THEN
                Rec.GET(Rec."Document Type"::Quote, Rec."No.")
            ELSE
                EXIT;

        ServQuoteToOrder.RUN(Rec);
        ServQuoteToOrder.GetSalesOrderHeader(ServHeader2);
        COMMIT;
        MESSAGE(Text001, Rec."No.", ServHeader2."No.");
    end;

    var
        Text000: Label 'Do you want to convert the quote to an order?';
        Text001: Label 'Quote %1 has been changed to order %2.';
        ServHeader2: Record "25006145";
        ServQuoteToOrder: Codeunit "25006124";
}

