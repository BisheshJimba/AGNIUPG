codeunit 25006871 "Service Booking to Order (Y/N)"
{
    TableNo = 25006145;

    trigger OnRun()
    var
        ServiceOrder: Record "25006145";
    begin
        ServiceBookingToOrderYN(Rec, ServiceOrder);
    end;

    var
        Text000: Label 'Do you want to convert the booking to an order?';
        Text001: Label 'Booking %1 has been changed to order %2.';
        ServHeader2: Record "25006145";
        ServBookingToOrder: Codeunit "25006872";

    [Scope('Internal')]
    procedure ServiceBookingToOrderYN(var ServiceBooking: Record "25006145"; var ServiceOrder: Record "25006145"): Boolean
    begin
        ServiceBooking.TESTFIELD("Document Type", ServiceBooking."Document Type"::Booking);
        IF GUIALLOWED THEN
            IF NOT CONFIRM(Text000, FALSE) THEN
                EXIT(FALSE);

        IF (ServiceBooking."Document Type" = ServiceBooking."Document Type"::Booking) THEN
            IF CheckCustomerCreated(TRUE) AND CheckVehicleCreated(TRUE) THEN
                ServiceBooking.GET(ServiceBooking."Document Type"::Booking, ServiceBooking."No.")
            ELSE
                EXIT(FALSE);

        ServBookingToOrder.RUN(ServiceBooking);
        ServBookingToOrder.GetSalesOrderHeader(ServiceOrder);
        COMMIT;
        MESSAGE(Text001, ServiceBooking."No.", ServiceOrder."No.");

        EXIT(TRUE);
    end;
}

