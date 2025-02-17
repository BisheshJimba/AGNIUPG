codeunit 33019968 "Courier Track. Post Return"
{
    TableNo = 33019987;

    trigger OnRun()
    begin
        GlobalCourierTracHdr.COPY(Rec);

        Window.OPEN(Text33019961);
        Window.UPDATE(1, STRSUBSTNO('%1,%2', Rec."Document Type", Rec."No."));

        //Inserting Courier Tracking Shipment.
        insertReturn(GlobalCourierTracHdr);

        //Insert Courier Tracking Ledger Entry.
        insertCTLedger(GlobalCourierTracHdr);

        //Update Courier Tracking Shipment Ledger entry to complete.
        updateShipLedgEntry(GlobalCourierTracHdr);

        //Void Courier Shipment Details.
        voidShipment(GlobalCourierTracHdr);

        Window.CLOSE;

        //Deleting all records.
        deleteAfterPosting(GlobalCourierTracHdr);
    end;

    var
        GlobalCTPostCheckDoc: Codeunit "33019971";
        GlobalCTGetNoSeries: Codeunit "33019970";
        GlobalCourierTracHdr: Record "33019987";
        GlobalCourierLedgEntry: Record "33019993";
        GlobalCourierLedgEntry2: Record "33019993";
        GlobalCTRegister: Record "33019969";
        GlobalCourierTrackRetShipHdr: Record "33019994";
        GlobalCourierTrackRetShipLine: Record "33019995";
        GlobalRetShipNo: Code[20];
        Window: Dialog;
        Text33019961: Label 'Posting #1######################';

    [Scope('Internal')]
    procedure insertReturn(ParmCourierTrackHdr1: Record "33019987")
    var
        LocalCourierTrackLine: Record "33019988";
        LocalCourierTrackRetShipHdr2: Record "33019994";
        LocalCourierTrackRetShipLine2: Record "33019995";
        LocalPostingType: Option Shipment,Receipt,Return;
    begin
        GlobalRetShipNo := GlobalCTGetNoSeries.getReturnShipNo(ParmCourierTrackHdr1);
        LocalCourierTrackRetShipHdr2.INIT;
        LocalCourierTrackRetShipHdr2."No." := GlobalRetShipNo;
        LocalCourierTrackRetShipHdr2."Transfer From Code" := ParmCourierTrackHdr1."Transfer From Code";
        LocalCourierTrackRetShipHdr2."Transfer To Code" := ParmCourierTrackHdr1."Transfer To Code";
        LocalCourierTrackRetShipHdr2."Transfer From Department" := ParmCourierTrackHdr1."Transfer From Department";
        LocalCourierTrackRetShipHdr2."Transfer To Department" := ParmCourierTrackHdr1."Transfer To Department";
        LocalCourierTrackRetShipHdr2."Posting Date" := TODAY;
        LocalCourierTrackRetShipHdr2."Document Date" := ParmCourierTrackHdr1."Document Date";
        LocalCourierTrackRetShipHdr2."Return Date" := ParmCourierTrackHdr1."Returned Date";
        LocalCourierTrackRetShipHdr2."Transfer From Name" := ParmCourierTrackHdr1."Transfer From Name";
        LocalCourierTrackRetShipHdr2."Transfer From Address" := ParmCourierTrackHdr1."Transfer From Address";
        LocalCourierTrackRetShipHdr2."Transfer From Address 2" := ParmCourierTrackHdr1."Transfer From Address 2";
        LocalCourierTrackRetShipHdr2."Transfer From Post Code" := ParmCourierTrackHdr1."Transfer From Post Code";
        LocalCourierTrackRetShipHdr2."Transfer From Contact" := ParmCourierTrackHdr1."Transfer From Contact";
        LocalCourierTrackRetShipHdr2."Shipment Date" := ParmCourierTrackHdr1."Shipment Date";
        LocalCourierTrackRetShipHdr2."Shipment Method Code" := ParmCourierTrackHdr1."Shipment Method Code";
        LocalCourierTrackRetShipHdr2."Shipping Agent Code" := ParmCourierTrackHdr1."Shipping Agent Code";
        LocalCourierTrackRetShipHdr2."Shipping Time" := ParmCourierTrackHdr1."Shipping Time";
        LocalCourierTrackRetShipHdr2."Transfer To Name" := ParmCourierTrackHdr1."Transfer To Name";
        LocalCourierTrackRetShipHdr2."Transfer To Address" := ParmCourierTrackHdr1."Transfer To Address";
        LocalCourierTrackRetShipHdr2."Transfer To Address 2" := ParmCourierTrackHdr1."Transfer To Address 2";
        LocalCourierTrackRetShipHdr2."Transfer To Post Code" := ParmCourierTrackHdr1."Transfer To Post Code";
        LocalCourierTrackRetShipHdr2."Transfer To Contact" := ParmCourierTrackHdr1."Transfer To Contact";
        LocalCourierTrackRetShipHdr2."Receipt Date" := ParmCourierTrackHdr1."Receipt Date";
        LocalCourierTrackRetShipHdr2."Transaction Type" := ParmCourierTrackHdr1."Transaction Type";
        LocalCourierTrackRetShipHdr2."Transport Method" := ParmCourierTrackHdr1."Transport Method";
        LocalCourierTrackRetShipHdr2."CT No." := ParmCourierTrackHdr1."CT No.";
        LocalCourierTrackRetShipHdr2.Insurance := ParmCourierTrackHdr1.Insurance;
        LocalCourierTrackRetShipHdr2."User ID" := USERID;
        LocalCourierTrackRetShipHdr2."Responsibility Center" := ParmCourierTrackHdr1."Responsibility Center";
        LocalCourierTrackRetShipHdr2."Return No." := ParmCourierTrackHdr1."No.";
        LocalCourierTrackRetShipHdr2.INSERT;

        //Inserting Courier Tracking Receipt Lines.
        LocalCourierTrackLine.RESET;
        LocalCourierTrackLine.SETRANGE("Document Type", ParmCourierTrackHdr1."Document Type");
        LocalCourierTrackLine.SETRANGE("Document No.", ParmCourierTrackHdr1."No.");
        IF LocalCourierTrackLine.FIND('-') THEN BEGIN
            REPEAT
                LocalCourierTrackRetShipLine2.INIT;
                LocalCourierTrackRetShipLine2."Document No." := GlobalRetShipNo;
                LocalCourierTrackRetShipLine2."Line No." := LocalCourierTrackLine."Line No.";
                LocalCourierTrackRetShipLine2."POD No." := LocalCourierTrackLine."POD No.";
                LocalCourierTrackRetShipLine2."AWB No." := LocalCourierTrackLine."AWB No.";
                LocalCourierTrackRetShipLine2."Packet No." := LocalCourierTrackLine."Packet No.";
                LocalCourierTrackRetShipLine2.Description := LocalCourierTrackLine.Description;
                LocalCourierTrackRetShipLine2."Packet Type" := LocalCourierTrackLine."Packet Type";
                LocalCourierTrackRetShipLine2.Weight := LocalCourierTrackLine.Weight;
                LocalCourierTrackRetShipLine2.Rate := LocalCourierTrackLine.Rate;
                LocalCourierTrackRetShipLine2.Amount := LocalCourierTrackLine.Amount;
                LocalCourierTrackRetShipLine2."Unit of Measure" := LocalCourierTrackLine."Unit of Measure";
                LocalCourierTrackRetShipLine2.Quantity := LocalCourierTrackLine.Quantity;
                LocalCourierTrackRetShipLine2."Quantity Returned" := LocalCourierTrackLine."Quantity To Return";
                LocalCourierTrackRetShipLine2.INSERT;
            UNTIL LocalCourierTrackLine.NEXT = 0;
        END;

        //Update No. Series Lines with Last Shipment No.
        LocalPostingType := LocalPostingType::Receipt;
        GlobalCTGetNoSeries.updateNoSeries(ParmCourierTrackHdr1, LocalPostingType, ParmCourierTrackHdr1."Posting Date", GlobalRetShipNo);
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
                GlobalCourierLedgEntry."Document No." := GlobalRetShipNo;
                GlobalCourierLedgEntry."Document Type" := GlobalCourierLedgEntry."Document Type"::Return;
                GlobalCourierLedgEntry."Posting Date" := TODAY;
                GlobalCourierLedgEntry."Document Date" := ParmCourierTrackHdr2."Document Date";
                GlobalCourierLedgEntry."Receipt Date" := ParmCourierTrackHdr2."Receipt Date";
                GlobalCourierLedgEntry."Shipment Date" := ParmCourierTrackHdr2."Shipment Date";
                GlobalCourierLedgEntry."Returned Date" := ParmCourierTrackHdr2."Returned Date";
                GlobalCourierLedgEntry."Shipment Agent Code" := ParmCourierTrackHdr2."Shipping Agent Code";
                GlobalCourierLedgEntry."Shipment Method Code" := ParmCourierTrackHdr2."Shipment Method Code";
                GlobalCourierLedgEntry."Transfer From Code" := ParmCourierTrackHdr2."Transfer From Code";
                GlobalCourierLedgEntry."Transfer To Code" := ParmCourierTrackHdr2."Transfer To Code";
                GlobalCourierLedgEntry."Transfer From Department" := ParmCourierTrackHdr2."Transfer From Department";
                GlobalCourierLedgEntry."Transfer To Department" := ParmCourierTrackHdr2."Transfer To Department";
                GlobalCourierLedgEntry."Source Code" := ParmCourierTrackHdr2."Source Code";
                GlobalCourierLedgEntry."Source Doc. No." := ParmCourierTrackHdr2."No.";
                GlobalCourierLedgEntry.Complete := TRUE;
                GlobalCourierLedgEntry."POD No." := LocalCourierTrackLine3."POD No.";
                GlobalCourierLedgEntry."AWB No." := LocalCourierTrackLine3."AWB No.";
                GlobalCourierLedgEntry."Packet No." := LocalCourierTrackLine3."Packet No.";
                GlobalCourierLedgEntry.Description := LocalCourierTrackLine3.Description;
                GlobalCourierLedgEntry."Packet Type" := LocalCourierTrackLine3."Packet Type";
                GlobalCourierLedgEntry.Weight := LocalCourierTrackLine3.Weight;
                GlobalCourierLedgEntry.Rate := LocalCourierTrackLine3.Rate;
                GlobalCourierLedgEntry.Amount := LocalCourierTrackLine3.Amount;
                GlobalCourierLedgEntry.Quantity := LocalCourierTrackLine3.Quantity;
                GlobalCourierLedgEntry."Quantity Returned" := LocalCourierTrackLine3."Quantity To Return";
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
        GlobalCTRegister."Document No." := GlobalRetShipNo;
        GlobalCTRegister."Creation Date" := TODAY;
        GlobalCTRegister."Source Code" := ParmCTLedgEntry2."Source Code";
        GlobalCTRegister."User ID" := USERID;
        GlobalCTRegister."From Entry No." := ParmFromEntryNo;
        GlobalCTRegister."To Entry No." := ParmToEntryNo;
        GlobalCTRegister."Entry From" := GlobalCTRegister."Entry From"::Courier;
        GlobalCTRegister.INSERT;
    end;

    [Scope('Internal')]
    procedure voidShipment(ParmCourTrackHdr6: Record "33019987")
    var
        LocalCourShipHdr: Record "33019989";
    begin
        //Voiding the Shipment according to Applies To Entry No and shipment date.
        LocalCourShipHdr.RESET;
        LocalCourShipHdr.SETRANGE("Transfer No.", ParmCourTrackHdr6."Applies To Entry");
        LocalCourShipHdr.SETRANGE("Shipment Date", ParmCourTrackHdr6."Shipment Date");
        IF LocalCourShipHdr.FIND('-') THEN BEGIN
            LocalCourShipHdr.Void := TRUE;
            LocalCourShipHdr.MODIFY;
        END;
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
    procedure postAndPrint(ParmCourTrackHdr3: Record "33019987")
    begin
        GlobalCourierTracHdr.COPY(ParmCourTrackHdr3);

        Window.OPEN(Text33019961);
        Window.UPDATE(1, STRSUBSTNO('%1,%2', ParmCourTrackHdr3."Document Type", ParmCourTrackHdr3."No."));

        //Inserting Courier Tracking Shipment.
        insertReturn(GlobalCourierTracHdr);

        //Insert Courier Tracking Ledger Entry.
        insertCTLedger(GlobalCourierTracHdr);

        //Update Courier Tracking Shipment Ledger entry to complete.
        updateShipLedgEntry(GlobalCourierTracHdr);

        Window.CLOSE;

        //Deleting all records.
        deleteAfterPosting(GlobalCourierTracHdr);

        //Here call report to print Receipt.
        printDocument(GlobalRetShipNo);
        COMMIT;
    end;

    [Scope('Internal')]
    procedure deleteAfterPosting(ParmCourTrackHdr4: Record "33019987")
    var
        LocalCourTrackLine4: Record "33019988";
    begin
        ParmCourTrackHdr4.DELETEALL;
        LocalCourTrackLine4.RESET;
        LocalCourTrackLine4.SETRANGE("Document Type", ParmCourTrackHdr4."Document Type");
        LocalCourTrackLine4.SETRANGE("Document No.", ParmCourTrackHdr4."No.");
        IF LocalCourTrackLine4.FIND('-') THEN
            LocalCourTrackLine4.DELETEALL;
    end;

    [Scope('Internal')]
    procedure updateShipLedgEntry(ParmCourTrackHdr5: Record "33019987")
    var
        CourTrackLedgEntry3: Record "33019993";
    begin
        //Updating the shipment lines incomplete and cancelled after receiving.
        CourTrackLedgEntry3.RESET;
        CourTrackLedgEntry3.SETRANGE("Source Doc. No.", ParmCourTrackHdr5."Applies To Entry");
        CourTrackLedgEntry3.SETRANGE("Shipment Date", ParmCourTrackHdr5."Shipment Date");
        CourTrackLedgEntry3.SETFILTER("Document Type", 'Shipment');
        IF CourTrackLedgEntry3.FIND('-') THEN BEGIN
            REPEAT
                CourTrackLedgEntry3."Canelled Shipment" := TRUE;
                CourTrackLedgEntry3.MODIFY;
            UNTIL CourTrackLedgEntry3.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure printDocument(ParmRetShipNo: Code[20])
    var
        LocalCourTrackRetShipHdr2: Record "33019994";
    begin
        //Printing Return Shipment Document.
        LocalCourTrackRetShipHdr2.RESET;
        LocalCourTrackRetShipHdr2.SETRANGE("No.", ParmRetShipNo);
        REPORT.RUN(33019978, FALSE, TRUE, LocalCourTrackRetShipHdr2);
    end;
}

