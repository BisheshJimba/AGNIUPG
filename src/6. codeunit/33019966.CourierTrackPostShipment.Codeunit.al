codeunit 33019966 "Courier Track. Post Shipment"
{
    TableNo = 33019987;

    trigger OnRun()
    begin
        GlobalCourierTracHdr.COPY(Rec);

        Window.OPEN(Text33019961);
        Window.UPDATE(1, STRSUBSTNO('%1,%2', Rec."Document Type", Rec."No."));

        //Checking for twice shipping.
        GlobalCTPostCheckDoc.CheckShipped(GlobalCourierTracHdr);

        //Checking Header for empty fields.
        GlobalCTPostCheckDoc.CheckCTHdr(GlobalCourierTracHdr);
        GlobalCTPostCheckDoc.CheckCTLineShip(GlobalCourierTracHdr);

        //Inserting Courier Tracking Shipment.
        insertShipment(GlobalCourierTracHdr);

        //Insert Courier Tracking Ledger Entry.
        insertCTLedger(GlobalCourierTracHdr);

        //Changing Document status and updating records for tracing shipment.
        changeStatus(GlobalCourierTracHdr);

        Window.CLOSE;
    end;

    var
        GlobalCTPostCheckDoc: Codeunit "33019971";
        GlobalCTGetNoSeries: Codeunit "33019970";
        GlobalCourierTracHdr: Record "33019987";
        GlobalCourierLedgEntry: Record "33019993";
        GlobalCourierLedgEntry2: Record "33019993";
        GlobalCTRegister: Record "33019969";
        GlobalCourierTrackShipHdr: Record "33019989";
        GlobalCourierTrackShipLine: Record "33019990";
        GlobalShipmentNo: Code[20];
        Window: Dialog;
        Text33019961: Label 'Posting #1######################';

    [Scope('Internal')]
    procedure insertShipment(ParmCourierTrackHdr1: Record "33019987")
    var
        LocalCourierTrackLine: Record "33019988";
        LocalCourierTrackShipHdr2: Record "33019989";
        LocalCourierTrackShipLine2: Record "33019990";
        LocalPostingType: Option Shipment,Receipt,Return;
    begin
        GlobalShipmentNo := GlobalCTGetNoSeries.getShipmentNo(ParmCourierTrackHdr1);
        LocalCourierTrackShipHdr2.INIT;
        LocalCourierTrackShipHdr2."No." := GlobalShipmentNo;
        LocalCourierTrackShipHdr2."Transfer From Code" := ParmCourierTrackHdr1."Transfer From Code";
        LocalCourierTrackShipHdr2."Transfer To Code" := ParmCourierTrackHdr1."Transfer To Code";
        LocalCourierTrackShipHdr2."Transfer From Department" := ParmCourierTrackHdr1."Transfer From Department";
        LocalCourierTrackShipHdr2."Transfer To Department" := ParmCourierTrackHdr1."Transfer To Department";
        LocalCourierTrackShipHdr2."Posting Date" := TODAY;
        LocalCourierTrackShipHdr2."Document Date" := ParmCourierTrackHdr1."Document Date";
        LocalCourierTrackShipHdr2."Transfer From Name" := ParmCourierTrackHdr1."Transfer From Name";
        LocalCourierTrackShipHdr2."Transfer From Address" := ParmCourierTrackHdr1."Transfer From Address";
        LocalCourierTrackShipHdr2."Transfer From Address 2" := ParmCourierTrackHdr1."Transfer From Address 2";
        LocalCourierTrackShipHdr2."Transfer From Post Code" := ParmCourierTrackHdr1."Transfer From Post Code";
        LocalCourierTrackShipHdr2."Transfer From Contact" := ParmCourierTrackHdr1."Transfer From Contact";
        LocalCourierTrackShipHdr2."Shipment Date" := ParmCourierTrackHdr1."Shipment Date";
        LocalCourierTrackShipHdr2."Shipment Method Code" := ParmCourierTrackHdr1."Shipment Method Code";
        LocalCourierTrackShipHdr2."Shipping Agent Code" := ParmCourierTrackHdr1."Shipping Agent Code";
        LocalCourierTrackShipHdr2."Shipping Time" := ParmCourierTrackHdr1."Shipping Time";
        LocalCourierTrackShipHdr2."Transfer To Name" := ParmCourierTrackHdr1."Transfer To Name";
        LocalCourierTrackShipHdr2."Transfer To Address" := ParmCourierTrackHdr1."Transfer To Address";
        LocalCourierTrackShipHdr2."Transfer To Address 2" := ParmCourierTrackHdr1."Transfer To Address 2";
        LocalCourierTrackShipHdr2."Transfer To Post Code" := ParmCourierTrackHdr1."Transfer To Post Code";
        LocalCourierTrackShipHdr2."Transfer To Contact" := ParmCourierTrackHdr1."Transfer To Contact";
        LocalCourierTrackShipHdr2."Receipt Date" := ParmCourierTrackHdr1."Receipt Date";
        LocalCourierTrackShipHdr2."Transaction Type" := ParmCourierTrackHdr1."Transaction Type";
        LocalCourierTrackShipHdr2."Transport Method" := ParmCourierTrackHdr1."Transport Method";
        LocalCourierTrackShipHdr2."CT No." := ParmCourierTrackHdr1."CT No.";
        LocalCourierTrackShipHdr2.Insurance := ParmCourierTrackHdr1.Insurance;
        LocalCourierTrackShipHdr2."User ID" := USERID;
        LocalCourierTrackShipHdr2."Responsibility Center" := ParmCourierTrackHdr1."Responsibility Center";
        LocalCourierTrackShipHdr2."Transfer No." := ParmCourierTrackHdr1."No.";
        LocalCourierTrackShipHdr2.INSERT;

        //Inserting Courier Tracking Shipment Lines.
        LocalCourierTrackLine.RESET;
        LocalCourierTrackLine.SETRANGE("Document Type", ParmCourierTrackHdr1."Document Type");
        LocalCourierTrackLine.SETRANGE("Document No.", ParmCourierTrackHdr1."No.");
        IF LocalCourierTrackLine.FIND('-') THEN BEGIN
            REPEAT
                LocalCourierTrackShipLine2.INIT;
                LocalCourierTrackShipLine2."Document No." := GlobalShipmentNo;
                LocalCourierTrackShipLine2."Line No." := LocalCourierTrackLine."Line No.";
                LocalCourierTrackShipLine2."POD No." := LocalCourierTrackLine."POD No.";
                LocalCourierTrackShipLine2."AWB No." := LocalCourierTrackLine."AWB No.";
                LocalCourierTrackShipLine2."Packet No." := LocalCourierTrackLine."Packet No.";
                LocalCourierTrackShipLine2.Description := LocalCourierTrackLine.Description;
                LocalCourierTrackShipLine2."Packet Type" := LocalCourierTrackLine."Packet Type";
                LocalCourierTrackShipLine2.Weight := LocalCourierTrackLine.Weight;
                LocalCourierTrackShipLine2.Rate := LocalCourierTrackLine.Rate;
                LocalCourierTrackShipLine2.Amount := LocalCourierTrackLine.Amount;
                LocalCourierTrackShipLine2."Unit of Measure" := LocalCourierTrackLine."Unit of Measure";
                LocalCourierTrackShipLine2.Quantity := LocalCourierTrackLine.Quantity;
                LocalCourierTrackShipLine2."Quantity Shipped" := LocalCourierTrackLine."Quantity To Ship";
                LocalCourierTrackShipLine2.INSERT;
            UNTIL LocalCourierTrackLine.NEXT = 0;
        END;

        //Update No. Series Lines with Last Shipment No.
        LocalPostingType := LocalPostingType::Shipment;
        GlobalCTGetNoSeries.updateNoSeries(ParmCourierTrackHdr1, LocalPostingType, ParmCourierTrackHdr1."Posting Date", GlobalShipmentNo);
    end;

    [Scope('Internal')]
    procedure insertCTLedger(ParmCourierTrackHdr2: Record "33019987")
    var
        LocalCourierTrackLine3: Record "33019988";
        LocalFrmLedgEntryNo: Integer;
        LocalToLedgEntryNo: Integer;
    begin
        LocalCourierTrackLine3.RESET;
        LocalCourierTrackLine3.SETRANGE("Document Type", ParmCourierTrackHdr2."Document Type");
        LocalCourierTrackLine3.SETRANGE("Document No.", ParmCourierTrackHdr2."No.");
        IF LocalCourierTrackLine3.FIND('-') THEN BEGIN
            REPEAT
                GlobalCourierLedgEntry.INIT;
                GlobalCourierLedgEntry."Entry No." := getLedEntryNo + 1;
                GlobalCourierLedgEntry."Document No." := GlobalShipmentNo;
                GlobalCourierLedgEntry."Document Type" := GlobalCourierLedgEntry."Document Type"::Shipment;
                GlobalCourierLedgEntry."Posting Date" := TODAY;
                GlobalCourierLedgEntry."Document Date" := ParmCourierTrackHdr2."Document Date";
                GlobalCourierLedgEntry."Receipt Date" := ParmCourierTrackHdr2."Receipt Date";
                GlobalCourierLedgEntry."Shipment Date" := ParmCourierTrackHdr2."Shipment Date";
                GlobalCourierLedgEntry."Shipment Agent Code" := ParmCourierTrackHdr2."Shipping Agent Code";
                GlobalCourierLedgEntry."Shipment Method Code" := ParmCourierTrackHdr2."Shipment Method Code";
                GlobalCourierLedgEntry."Transfer From Code" := ParmCourierTrackHdr2."Transfer From Code";
                GlobalCourierLedgEntry."Transfer To Code" := ParmCourierTrackHdr2."Transfer To Code";
                GlobalCourierLedgEntry."Transfer From Department" := ParmCourierTrackHdr2."Transfer From Department";
                GlobalCourierLedgEntry."Transfer To Department" := ParmCourierTrackHdr2."Transfer To Department";
                GlobalCourierLedgEntry."Source Code" := ParmCourierTrackHdr2."Source Code";
                GlobalCourierLedgEntry."Source Doc. No." := ParmCourierTrackHdr2."No.";
                GlobalCourierLedgEntry.Complete := FALSE;
                GlobalCourierLedgEntry."POD No." := LocalCourierTrackLine3."POD No.";
                GlobalCourierLedgEntry."AWB No." := LocalCourierTrackLine3."AWB No.";
                GlobalCourierLedgEntry."Packet No." := LocalCourierTrackLine3."Packet No.";
                GlobalCourierLedgEntry.Description := LocalCourierTrackLine3.Description;
                GlobalCourierLedgEntry."Packet Type" := LocalCourierTrackLine3."Packet Type";
                GlobalCourierLedgEntry.Weight := LocalCourierTrackLine3.Weight;
                GlobalCourierLedgEntry.Rate := LocalCourierTrackLine3.Rate;
                GlobalCourierLedgEntry.Amount := LocalCourierTrackLine3.Amount;
                GlobalCourierLedgEntry.Quantity := LocalCourierTrackLine3.Quantity;
                GlobalCourierLedgEntry."Quantity Shipped" := LocalCourierTrackLine3."Quantity To Ship";
                GlobalCourierLedgEntry."User ID" := USERID;
                GlobalCourierLedgEntry."CT No." := ParmCourierTrackHdr2."CT No.";
                GlobalCourierLedgEntry.INSERT;
                IF (LocalFrmLedgEntryNo = 0) THEN
                    LocalFrmLedgEntryNo := GlobalCourierLedgEntry."Entry No.";
                LocalToLedgEntryNo := GlobalCourierLedgEntry."Entry No.";
            UNTIL LocalCourierTrackLine3.NEXT = 0;
        END;

        //Copying the ledger records.
        GlobalCourierLedgEntry2.COPY(GlobalCourierLedgEntry);

        //Insert Courier Register entry.
        insertCTRegister(GlobalCourierLedgEntry2, LocalFrmLedgEntryNo, LocalToLedgEntryNo);
    end;

    [Scope('Internal')]
    procedure insertCTRegister(ParmCTLedgEntry2: Record "33019993"; ParmFromEntryNo: Integer; ParmToEntryNo: Integer)
    begin
        GlobalCTRegister.INIT;
        GlobalCTRegister."Entry No." := getRegEntryNo + 1;
        GlobalCTRegister."Document No." := GlobalShipmentNo;
        GlobalCTRegister."Creation Date" := TODAY;
        GlobalCTRegister."Source Code" := ParmCTLedgEntry2."Source Code";
        GlobalCTRegister."User ID" := USERID;
        GlobalCTRegister."From Entry No." := ParmFromEntryNo;
        GlobalCTRegister."To Entry No." := ParmToEntryNo;
        GlobalCTRegister."Entry From" := GlobalCTRegister."Entry From"::Courier;
        GlobalCTRegister.INSERT;
    end;

    [Scope('Internal')]
    procedure getLedEntryNo(): Integer
    var
        LocalCTLedgEntry3: Record "33019993";
    begin
        LocalCTLedgEntry3.RESET;
        IF LocalCTLedgEntry3.FIND('+') THEN
            EXIT(LocalCTLedgEntry3."Entry No.");
    end;

    [Scope('Internal')]
    procedure getRegEntryNo(): Integer
    var
        LocalCTRegister2: Record "33019969";
    begin
        LocalCTRegister2.RESET;
        IF LocalCTRegister2.FIND('+') THEN
            EXIT(LocalCTRegister2."Entry No.");
    end;

    [Scope('Internal')]
    procedure changeStatus(ParmCourTrackHdr: Record "33019987")
    begin
        ParmCourTrackHdr.Status := ParmCourTrackHdr.Status::Released;
        ParmCourTrackHdr.Shipped := TRUE;
        ParmCourTrackHdr.MODIFY;
    end;

    [Scope('Internal')]
    procedure postAndPrint(ParmCourTrackHdr: Record "33019987")
    begin
        GlobalCourierTracHdr.COPY(ParmCourTrackHdr);

        Window.OPEN(Text33019961);
        Window.UPDATE(1, STRSUBSTNO('%1,%2', ParmCourTrackHdr."Document Type", ParmCourTrackHdr."No."));

        //Checking Header for empty fields.
        GlobalCTPostCheckDoc.CheckCTHdr(GlobalCourierTracHdr);
        GlobalCTPostCheckDoc.CheckCTLineShip(GlobalCourierTracHdr);

        //Inserting Courier Tracking Shipment.
        insertShipment(GlobalCourierTracHdr);

        //Insert Courier Tracking Ledger Entry.
        insertCTLedger(GlobalCourierTracHdr);

        //Changing Document status.
        changeStatus(GlobalCourierTracHdr);

        Window.CLOSE;

        //Here call report to print shipment.
        printDocument(GlobalShipmentNo);
        COMMIT;
    end;

    [Scope('Internal')]
    procedure printDocument(ParmShipmentNo: Code[20])
    var
        LocalCourTrackShipHdr2: Record "33019989";
    begin
        //Printing Shipment document.
        LocalCourTrackShipHdr2.RESET;
        LocalCourTrackShipHdr2.SETRANGE("No.", ParmShipmentNo);
        REPORT.RUN(33019973, FALSE, TRUE, LocalCourTrackShipHdr2);
    end;
}

