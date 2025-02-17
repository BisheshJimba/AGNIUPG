codeunit 25006324 "Vehicle Order Promising"
{
    // Agni
    // ***CP 28/07/2013 Vehicle reservation entry not created ... because not used in Agni Inc. Location code is not copied
    // from sales order to vehicle requisition worksheet.
    // ***SM 14/06/2013 to pass variant code to requisition line from sales line


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure CreateReqLine(var SalesLine: Record "37")
    var
        ReqLine: Record "246";
        NewLineNo: Integer;
        VehOrderPromSetup: Record "25006394";
        ModelVersion: Record "27";
        VehicleAlreadyExists: Label 'The Vehicle with Chasis No. %1 has already been order promised.';
        ReqLine2: Record "246";
        PurchLine: Record "39";
    begin
        VehOrderPromSetup.GET;

        //***SM 01-08-2013 to check whether the vehicle has already been order promised or not
        ReqLine2.RESET;
        ReqLine2.SETRANGE("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
        IF ReqLine2.FINDFIRST THEN BEGIN
            SalesLine.CALCFIELDS(VIN);
            ERROR(VehicleAlreadyExists, SalesLine.VIN);
        END ELSE BEGIN
            PurchLine.RESET;
            PurchLine.SETRANGE("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
            IF PurchLine.FINDFIRST THEN BEGIN
                SalesLine.CALCFIELDS(VIN);
                ERROR(VehicleAlreadyExists, SalesLine.VIN);
            END;
        END;
        //***SM 01-08-2013 to check whether the vehicle has already been order promised or not

        NewLineNo := 0;
        ReqLine.LOCKTABLE;
        ReqLine.SETRANGE("Worksheet Template Name", VehOrderPromSetup."Order Promising Template");
        ReqLine.SETRANGE("Journal Batch Name", VehOrderPromSetup."Order Promising Worksheet");
        IF ReqLine.FINDLAST THEN
            NewLineNo := ReqLine."Line No.";
        NewLineNo += 10000;



        ReqLine.INIT;
        ReqLine."Worksheet Template Name" := VehOrderPromSetup."Order Promising Template";
        ReqLine."Journal Batch Name" := VehOrderPromSetup."Order Promising Worksheet";
        ReqLine."Document Profile" := ReqLine."Document Profile"::"Vehicles Trade";
        ReqLine."Line No." := NewLineNo;
        ReqLine.Type := ReqLine.Type::Item;
        ReqLine."Vehicle Assembly ID" := SalesLine."Vehicle Assembly ID";
        ReqLine."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        ReqLine."Vehicle Accounting Cycle No." := SalesLine."Vehicle Accounting Cycle No.";
        ReqLine.VALIDATE("No.", SalesLine."No.");
        ReqLine.Description := SalesLine.Description;
        ReqLine."Description 2" := SalesLine."Description 2";
        //ReqLine."Location Code" := SalesLine."Location Code";
        ReqLine.Quantity := SalesLine.Quantity;
        ReqLine."Make Code" := SalesLine."Make Code";
        ReqLine."Model Code" := SalesLine."Model Code";
        ReqLine."Model Version No." := SalesLine."Model Version No.";
        ReqLine."Variant Code" := SalesLine."Variant Code";  //SM 14/06/2013 to pass variant code to requisition line from sales line
        ReqLine."Accept Action Message" := TRUE;
        ReqLine."Requester ID" := USERID;
        ReqLine."Location Code" := SalesLine."Location Code";

        IF ModelVersion.GET(SalesLine."No.") THEN
            ReqLine."Vendor No." := ModelVersion."Vendor No.";

        ReqLine.INSERT;

        // CreateReservation(SalesLine,ReqLine);
    end;

    [Scope('Internal')]
    procedure CreateReservation(var SalesLine: Record "37"; var ReqLine: Record "246")
    var
        ReservEntry: Record "25006392";
        ReservMgt: Codeunit "25006300";
        ReserveSalesLine: Codeunit "25006317";
        ReservQty: Decimal;
    begin
        ReservMgt.SetReqLine(ReqLine);
        ReservEntry."Source Type" := DATABASE::"Sales Line";
        ReserveSalesLine.CreateReservationSetFrom(
            DATABASE::"Requisition Line", 0,
            ReqLine."Worksheet Template Name",
            ReqLine."Journal Batch Name", ReqLine."Line No.",
            ReqLine."Location Code");
        ReserveSalesLine.CreateReservation(
            SalesLine,
            ReqLine.Description);
    end;

    [Scope('Internal')]
    procedure CreateReqLineTO(var SalesLine: Record "5741")
    var
        ReqLine: Record "246";
        NewLineNo: Integer;
        VehOrderPromSetup: Record "25006394";
        VehicleAlreadyExists: Label 'The Vehicle with Chasis No. %1 has already been order promised.';
        ReqLine2: Record "246";
        PurchLine: Record "39";
    begin
        VehOrderPromSetup.GET;
        //***SM 01-08-2013 to check whether the vehicle has already been order promised or not
        ReqLine2.RESET;
        ReqLine2.SETRANGE("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
        IF ReqLine2.FINDFIRST THEN BEGIN
            SalesLine.CALCFIELDS(VIN);
            ERROR(VehicleAlreadyExists, SalesLine.VIN);
        END ELSE BEGIN
            PurchLine.RESET;
            PurchLine.SETRANGE("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
            IF PurchLine.FINDFIRST THEN BEGIN
                SalesLine.CALCFIELDS(VIN);
                ERROR(VehicleAlreadyExists, SalesLine.VIN);
            END;
        END;
        //***SM 01-08-2013 to check whether the vehicle has already been order promised or not

        NewLineNo := 0;
        ReqLine.LOCKTABLE;
        ReqLine.SETRANGE("Worksheet Template Name", VehOrderPromSetup."Order Promising Template");
        ReqLine.SETRANGE("Journal Batch Name", VehOrderPromSetup."Order Promising Worksheet");
        IF ReqLine.FINDLAST THEN
            NewLineNo := ReqLine."Line No.";
        NewLineNo += 10000;

        ReqLine.INIT;
        ReqLine."Worksheet Template Name" := VehOrderPromSetup."Order Promising Template";
        ReqLine."Journal Batch Name" := VehOrderPromSetup."Order Promising Worksheet";
        ReqLine."Document Profile" := ReqLine."Document Profile"::"Vehicles Trade";
        ReqLine."Line No." := NewLineNo;
        ReqLine.Type := ReqLine.Type::Item;
        ReqLine.VALIDATE("No.", SalesLine."Item No.");
        ReqLine.Description := SalesLine.Description;
        ReqLine."Description 2" := SalesLine."Description 2";
        //ReqLine."Location Code" := SalesLine."Location Code";
        ReqLine.Quantity := SalesLine.Quantity;
        ReqLine."Make Code" := SalesLine."Make Code";
        ReqLine."Model Code" := SalesLine."Model Code";
        ReqLine."Model Version No." := SalesLine."Model Version No.";
        ReqLine."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        ReqLine."Vehicle Accounting Cycle No." := SalesLine."Vehicle Accounting Cycle No.";
        ReqLine."Variant Code" := SalesLine."Variant Code";  //SM 14/06/2013 to pass variant code to requisition line from sales line
        ReqLine."Vehicle Assembly ID" := SalesLine."Vehicle Assembly ID";
        ReqLine."Accept Action Message" := TRUE;
        ReqLine."Requester ID" := USERID;
        ReqLine."Location Code" := SalesLine."Transfer-to Code";
        ReqLine."Order Promising Date" := TODAY;
        ReqLine.INSERT;

        // CreateReservation(SalesLine,ReqLine);
    end;
}

