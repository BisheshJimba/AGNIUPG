codeunit 25006302 "Vehicle Warranty Mgt."
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure CreateWarrantyLines(var SalesInvLine: Record "113")
    var
        WarrantyUsage: Record "25006038";
        VehicleWarranty: Record "25006036";
        SalesSetup: Record "311";
        SalesInvHeader: Record "112";
    begin
        SalesSetup.RESET;

        WarrantyUsage.RESET;

        SalesSetup.GET;
        IF NOT SalesSetup."Vehicle Warranty on Sales" THEN
            EXIT;

        VehicleWarranty.RESET;
        VehicleWarranty.SETRANGE("Vehicle Serial No.", SalesInvLine."Vehicle Serial No.");
        IF VehicleWarranty.FINDFIRST THEN
            EXIT;

        SalesInvHeader.GET(SalesInvLine."Document No.");

        WarrantyUsage.RESET;
        WarrantyUsage.SETFILTER("Make Code", '%1|%2', '', SalesInvLine."Make Code");
        WarrantyUsage.SETFILTER("Model Code", '%1|%2', '', SalesInvLine."Model Code");
        WarrantyUsage.SETFILTER("Model Version No.", '%1|%2', '', SalesInvLine."Model Version No.");
        WarrantyUsage.SETFILTER("Vehicle Status Code", '%1|%2', '', SalesInvLine."Vehicle Status Code");
        IF WarrantyUsage.FINDSET THEN
            REPEAT
                VehicleWarranty.INIT;
                VehicleWarranty."Vehicle Serial No." := SalesInvLine."Vehicle Serial No.";
                VehicleWarranty."No." := '';
                VehicleWarranty.INSERT(TRUE);
                VehicleWarranty."Warranty Type Code" := WarrantyUsage."Warranty Type Code";
                VehicleWarranty."Starting Date" := SalesInvHeader."Document Date";
                VehicleWarranty."Term Date Formula" := WarrantyUsage."Term Date Formula";
                VehicleWarranty."Kilometrage Limit" := WarrantyUsage."Kilometrage Limit";
                VehicleWarranty."Spare Warranty" := WarrantyUsage."Spare Warranty";
                VehicleWarranty.Item := WarrantyUsage.Item;
                VehicleWarranty.MODIFY;
            UNTIL WarrantyUsage.NEXT = 0;
    end;
}

