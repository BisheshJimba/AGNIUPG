codeunit 33019962 "Admin. User Interface - Mngt."
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure getLastVisitKmVeh(ParmVehicleNo: Code[20]): Decimal
    var
        LocalFuelLedgEntry: Record "33019965";
    begin
        LocalFuelLedgEntry.RESET;
        LocalFuelLedgEntry.SETRANGE(VIN, ParmVehicleNo);
        LocalFuelLedgEntry.SETRANGE(Void, FALSE);
        IF LocalFuelLedgEntry.FIND('+') THEN
            EXIT(LocalFuelLedgEntry."Vehicle Last Visit KM");
    end;

    [Scope('Internal')]
    procedure getLastFilledFuelLitreVeh(ParmVehicleNo: Code[20]): Decimal
    var
        LocalFuelLedgEntry2: Record "33019965";
    begin
        LocalFuelLedgEntry2.RESET;
        LocalFuelLedgEntry2.SETRANGE(VIN, ParmVehicleNo);
        LocalFuelLedgEntry2.SETRANGE(Void, FALSE);
        IF LocalFuelLedgEntry2.FIND('+') THEN
            EXIT(LocalFuelLedgEntry2.Quantity);
    end;

    [Scope('Internal')]
    procedure getStockQty(ParmFuelType: Option " ",Diesel,Petrol,Kerosene,Mobile,"Engine Oil",Others): Decimal
    var
        LocalItemLedgerEntry: Record "32";
    begin
        //Code here to check for fuel in stock according to Fuel Type.
    end;

    [Scope('Internal')]
    procedure getPetrolPump(ParmVehicleNo: Code[20]): Code[20]
    var
        LocalFuelLedgEntry3: Record "33019965";
    begin
        LocalFuelLedgEntry3.RESET;
        LocalFuelLedgEntry3.SETRANGE(VIN, ParmVehicleNo);
        LocalFuelLedgEntry3.SETRANGE(Void, FALSE);
        IF LocalFuelLedgEntry3.FIND('+') THEN
            EXIT(LocalFuelLedgEntry3."Petrol Pump");
    end;

    [Scope('Internal')]
    procedure getLastVisitKmStaff(ParmVehicleNo: Code[20]): Decimal
    var
        LocalFuelLedgEntry4: Record "33019965";
    begin
        LocalFuelLedgEntry4.RESET;
        LocalFuelLedgEntry4.SETRANGE("Staff No.", ParmVehicleNo);
        LocalFuelLedgEntry4.SETRANGE(Void, FALSE);
        IF LocalFuelLedgEntry4.FIND('+') THEN
            EXIT(LocalFuelLedgEntry4."Vehicle Last Visit KM");
    end;

    [Scope('Internal')]
    procedure getLastFilledFuelLitreStaff(ParmVehicleNo: Code[20]): Decimal
    var
        LocalFuelLedgEntry5: Record "33019965";
    begin
        LocalFuelLedgEntry5.RESET;
        LocalFuelLedgEntry5.SETRANGE("Staff No.", ParmVehicleNo);
        LocalFuelLedgEntry5.SETRANGE(Void, FALSE);
        IF LocalFuelLedgEntry5.FIND('+') THEN
            EXIT(LocalFuelLedgEntry5.Quantity);
    end;
}

