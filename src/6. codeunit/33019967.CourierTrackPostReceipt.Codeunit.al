codeunit 33019967 "Courier Track. Post Receipt"
{
    TableNo = 33019987;

    trigger OnRun()
    begin
        GlobalCourierTracHdr.COPY(Rec);

        Window.OPEN(Text33019961);
        Window.UPDATE(1, STRSUBSTNO('%1,%2', Rec."Document Type", Rec."No."));

        //Checking for receiver. if same user is trying to receive the courier then show error.
        GlobalCTPostCheckDoc.CheckShipper(GlobalCourierTracHdr);

        //Checking Header for Shipment.
        GlobalCTPostCheckDoc.CheckShipment(GlobalCourierTracHdr);

        //Checking Shipment details for cancellation.
        GlobalCTPostCheckDoc.CheckShipCanelled(GlobalCourierTracHdr);

        //Checking Header for empty fields.
        GlobalCTPostCheckDoc.CheckCTHdr(GlobalCourierTracHdr);
        GlobalCTPostCheckDoc.CheckCTLineRcpt(GlobalCourierTracHdr);

        //Inserting Courier Tracking Shipment.
        insertReceipt(GlobalCourierTracHdr);

        //Insert Courier Tracking Ledger Entry.
        insertCTLedger(GlobalCourierTracHdr);

        //Update Courier Tracking Shipment Ledger entry to complete.
        updateShipLedgEntry(GlobalCourierTracHdr);

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
        GlobalCourierTrackRcptHdr: Record "33019991";
        GlobalCourierTrackRcptLine: Record "33019992";
        GlobalReceiptNo: Code[20];
        Window: Dialog;
        Text33019961: Label 'Posting #1######################';

    [Scope('Internal')]
    procedure insertReceipt(ParmCourierTrackHdr1: Record "33019987")
    var
        LocalCourierTrackLine: Record "33019988";
        LocalCourierTrackRcptHdr2: Record "33019991";
        LocalCourierTrackRcptLine2: Record "33019992";
        LocalPostingType: Option Shipment,Receipt,Return;
    begin
        GlobalReceiptNo := GlobalCTGetNoSeries.getReceiptNo(ParmCourierTrackHdr1);
        LocalCourierTrackRcptHdr2.INIT;
        LocalCourierTrackRcptHdr2."No." := GlobalReceiptNo;
        LocalCourierTrackRcptHdr2."Transfer From Code" := ParmCourierTrackHdr1."Transfer From Code";
        LocalCourierTrackRcptHdr2."Transfer To Code" := ParmCourierTrackHdr1."Transfer To Code";
        LocalCourierTrackRcptHdr2."Transfer From Department" := ParmCourierTrackHdr1."Transfer From Department";
        LocalCourierTrackRcptHdr2."Transfer To Department" := ParmCourierTrackHdr1."Transfer To Department";
        LocalCourierTrackRcptHdr2."Posting Date" := TODAY;
        LocalCourierTrackRcptHdr2."Document Date" := ParmCourierTrackHdr1."Document Date";
        LocalCourierTrackRcptHdr2."Transfer From Name" := ParmCourierTrackHdr1."Transfer From Name";
        LocalCourierTrackRcptHdr2."Transfer From Address" := ParmCourierTrackHdr1."Transfer From Address";
        LocalCourierTrackRcptHdr2."Transfer From Address 2" := ParmCourierTrackHdr1."Transfer From Address 2";
        LocalCourierTrackRcptHdr2."Transfer From Post Code" := ParmCourierTrackHdr1."Transfer From Post Code";
        LocalCourierTrackRcptHdr2."Transfer From Contact" := ParmCourierTrackHdr1."Transfer From Contact";
        LocalCourierTrackRcptHdr2."Shipment Date" := ParmCourierTrackHdr1."Shipment Date";
        LocalCourierTrackRcptHdr2."Shipment Method Code" := ParmCourierTrackHdr1."Shipment Method Code";
        LocalCourierTrackRcptHdr2."Shipping Agent Code" := ParmCourierTrackHdr1."Shipping Agent Code";
        LocalCourierTrackRcptHdr2."Shipping Time" := ParmCourierTrackHdr1."Shipping Time";
        LocalCourierTrackRcptHdr2."Transfer To Name" := ParmCourierTrackHdr1."Transfer To Name";
        LocalCourierTrackRcptHdr2."Transfer To Address" := ParmCourierTrackHdr1."Transfer To Address";
        LocalCourierTrackRcptHdr2."Transfer To Address 2" := ParmCourierTrackHdr1."Transfer To Address 2";
        LocalCourierTrackRcptHdr2."Transfer To Post Code" := ParmCourierTrackHdr1."Transfer To Post Code";
        LocalCourierTrackRcptHdr2."Transfer To Contact" := ParmCourierTrackHdr1."Transfer To Contact";
        LocalCourierTrackRcptHdr2."Receipt Date" := ParmCourierTrackHdr1."Receipt Date";
        LocalCourierTrackRcptHdr2."Transaction Type" := ParmCourierTrackHdr1."Transaction Type";
        LocalCourierTrackRcptHdr2."Transport Method" := ParmCourierTrackHdr1."Transport Method";
        LocalCourierTrackRcptHdr2."CT No." := ParmCourierTrackHdr1."CT No.";
        LocalCourierTrackRcptHdr2.Insurance := ParmCourierTrackHdr1.Insurance;
        LocalCourierTrackRcptHdr2."User ID" := USERID;
        LocalCourierTrackRcptHdr2."Responsibility Center" := ParmCourierTrackHdr1."Responsibility Center";
        LocalCourierTrackRcptHdr2."Transfer No." := ParmCourierTrackHdr1."No.";
        LocalCourierTrackRcptHdr2.INSERT;

        //Inserting Courier Tracking Receipt Lines.
        LocalCourierTrackLine.RESET;
        LocalCourierTrackLine.SETRANGE("Document Type", ParmCourierTrackHdr1."Document Type");
        LocalCourierTrackLine.SETRANGE("Document No.", ParmCourierTrackHdr1."No.");
        IF LocalCourierTrackLine.FIND('-') THEN BEGIN
            REPEAT
                LocalCourierTrackRcptLine2.INIT;
                LocalCourierTrackRcptLine2."Document No." := GlobalReceiptNo;
                LocalCourierTrackRcptLine2."Line No." := LocalCourierTrackLine."Line No.";
                LocalCourierTrackRcptLine2."POD No." := LocalCourierTrackLine."POD No.";
                LocalCourierTrackRcptLine2."AWB No." := LocalCourierTrackLine."AWB No.";
                LocalCourierTrackRcptLine2."Packet No." := LocalCourierTrackLine."Packet No.";
                LocalCourierTrackRcptLine2.Description := LocalCourierTrackLine.Description;
                LocalCourierTrackRcptLine2."Packet Type" := LocalCourierTrackLine."Packet Type";
                LocalCourierTrackRcptLine2.Weight := LocalCourierTrackLine.Weight;
                LocalCourierTrackRcptLine2.Rate := LocalCourierTrackLine.Rate;
                LocalCourierTrackRcptLine2.Amount := LocalCourierTrackLine.Amount;
                LocalCourierTrackRcptLine2."Unit of Measure" := LocalCourierTrackLine."Unit of Measure";
                LocalCourierTrackRcptLine2.Quantity := LocalCourierTrackLine.Quantity;
                LocalCourierTrackRcptLine2."Quantity Received" := LocalCourierTrackLine."Quantity To Receive";
                LocalCourierTrackRcptLine2.Condition := LocalCourierTrackLine.Condition;
                LocalCourierTrackRcptLine2.INSERT;
            UNTIL LocalCourierTrackLine.NEXT = 0;
        END;

        //Update No. Series Lines with Last Shipment No.
        LocalPostingType := LocalPostingType::Receipt;
        GlobalCTGetNoSeries.updateNoSeries(ParmCourierTrackHdr1, LocalPostingType, ParmCourierTrackHdr1."Posting Date", GlobalReceiptNo);
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
                GlobalCourierLedgEntry."Document No." := GlobalReceiptNo;
                GlobalCourierLedgEntry."Document Type" := GlobalCourierLedgEntry."Document Type"::Receipt;
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
                GlobalCourierLedgEntry."Quantity Received" := LocalCourierTrackLine3."Quantity To Receive";
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
        GlobalCTRegister."Document No." := GlobalReceiptNo;
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
    procedure postAndPrint(ParmCourTrackHdr3: Record "33019987")
    begin
        GlobalCourierTracHdr.COPY(ParmCourTrackHdr3);

        Window.OPEN(Text33019961);
        Window.UPDATE(1, STRSUBSTNO('%1,%2', ParmCourTrackHdr3."Document Type", ParmCourTrackHdr3."No."));

        //Checking Header for Shipment.
        GlobalCTPostCheckDoc.CheckShipment(GlobalCourierTracHdr);

        //Checking Shipment details for cancellation.
        GlobalCTPostCheckDoc.CheckShipCanelled(GlobalCourierTracHdr);

        //Checking Header for empty fields.
        GlobalCTPostCheckDoc.CheckCTHdr(GlobalCourierTracHdr);
        GlobalCTPostCheckDoc.CheckCTLineRcpt(GlobalCourierTracHdr);

        //Inserting Courier Tracking Shipment.
        insertReceipt(GlobalCourierTracHdr);

        //Insert Courier Tracking Ledger Entry.
        insertCTLedger(GlobalCourierTracHdr);

        //Update Courier Tracking Shipment Ledger entry to complete.
        updateShipLedgEntry(GlobalCourierTracHdr);

        Window.CLOSE;

        //Deleting all records.
        deleteAfterPosting(GlobalCourierTracHdr);

        //Here call report to print Receipt.
        printDocument(GlobalReceiptNo);
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
        //Updating the shipment lines complete after receiving.
        CourTrackLedgEntry3.RESET;
        CourTrackLedgEntry3.SETRANGE("Source Doc. No.", ParmCourTrackHdr5."No.");
        CourTrackLedgEntry3.SETRANGE("Document Date", ParmCourTrackHdr5."Document Date");
        CourTrackLedgEntry3.SETFILTER("Document Type", 'Shipment');
        IF CourTrackLedgEntry3.FIND('-') THEN BEGIN
            REPEAT
                CourTrackLedgEntry3.Complete := TRUE;
                CourTrackLedgEntry3.MODIFY;
            UNTIL CourTrackLedgEntry3.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure printDocument(ParmReceiptNo: Code[20])
    var
        LocalCourTrackRecptHdr2: Record "33019991";
    begin
        //Printing Receipt Document.
        LocalCourTrackRecptHdr2.RESET;
        LocalCourTrackRecptHdr2.SETRANGE("No.", ParmReceiptNo);
        REPORT.RUN(33019974, FALSE, TRUE, LocalCourTrackRecptHdr2);
    end;
}

