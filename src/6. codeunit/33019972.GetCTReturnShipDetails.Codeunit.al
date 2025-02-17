codeunit 33019972 "Get CT - Return Ship. Details"
{
    // Might need to check with Posting date also. Else Transfer no. series need to be changed yearly.


    trigger OnRun()
    begin
    end;

    var
        GlobalCourTrackHdr: Record "33019987";
        GlobalCourTrackLine: Record "33019988";
        GlobalCourTrackShipHdr: Record "33019989";
        GlobalCourTrackShipLine: Record "33019990";
        Text33019961: Label 'Imported successfully!';
        GlobalCourTrackRcptHdr: Record "33019991";
        Text33019962: Label 'This Shipment No. - %1, has been received. You cannot use Return Shipment for received courier(s). Please follow normal Courier Shipment process. ';

    [Scope('Internal')]
    procedure insertCTShipmentDetails(ParmApplyToEntry: Code[20]; ParmDocDate: Date; ParmReturnReason: Code[10])
    begin
        //Checking for receipt of the shipment. If has received then donot process show message.
        checkReceiptDetail(ParmApplyToEntry, ParmDocDate);

        //Setting filters and inserting records.
        GlobalCourTrackShipHdr.RESET;
        GlobalCourTrackShipHdr.SETRANGE("Transfer No.", ParmApplyToEntry);
        GlobalCourTrackShipHdr.SETRANGE("Document Date", ParmDocDate);
        IF GlobalCourTrackShipHdr.FIND('-') THEN BEGIN
            GlobalCourTrackHdr.INIT;
            GlobalCourTrackHdr."Document Type" := GlobalCourTrackHdr."Document Type"::Return;
            GlobalCourTrackHdr."Transfer From Code" := GlobalCourTrackShipHdr."Transfer From Code";
            GlobalCourTrackHdr."Transfer To Code" := GlobalCourTrackShipHdr."Transfer To Code";
            GlobalCourTrackHdr."Transfer From Department" := GlobalCourTrackShipHdr."Transfer From Department";
            GlobalCourTrackHdr."Transfer To Department" := GlobalCourTrackShipHdr."Transfer To Department";
            GlobalCourTrackHdr."Posting Date" := TODAY;
            GlobalCourTrackHdr."Document Date" := TODAY;
            GlobalCourTrackHdr."Returned Date" := TODAY;
            GlobalCourTrackHdr."Transfer From Name" := GlobalCourTrackShipHdr."Transfer From Name";
            GlobalCourTrackHdr."Transfer From Address" := GlobalCourTrackShipHdr."Transfer From Address";
            GlobalCourTrackHdr."Transfer From Address 2" := GlobalCourTrackShipHdr."Transfer From Address 2";
            GlobalCourTrackHdr."Transfer From Post Code" := GlobalCourTrackShipHdr."Transfer From Post Code";
            GlobalCourTrackHdr."Transfer From Contact" := GlobalCourTrackShipHdr."Transfer From Contact";
            GlobalCourTrackHdr."Shipment Date" := GlobalCourTrackShipHdr."Shipment Date";
            GlobalCourTrackHdr."Shipment Method Code" := GlobalCourTrackShipHdr."Shipment Method Code";
            GlobalCourTrackHdr."Shipping Agent Code" := GlobalCourTrackShipHdr."Shipping Agent Code";
            GlobalCourTrackHdr."Shipping Time" := GlobalCourTrackShipHdr."Shipping Time";
            GlobalCourTrackHdr."Transfer To Name" := GlobalCourTrackShipHdr."Transfer To Name";
            GlobalCourTrackHdr."Transfer To Address" := GlobalCourTrackShipHdr."Transfer To Address";
            GlobalCourTrackHdr."Transfer To Address 2" := GlobalCourTrackShipHdr."Transfer To Address 2";
            GlobalCourTrackHdr."Transfer To Post Code" := GlobalCourTrackShipHdr."Transfer To Post Code";
            GlobalCourTrackHdr."Transfer To Contact" := GlobalCourTrackShipHdr."Transfer To Contact";
            GlobalCourTrackHdr."Receipt Date" := GlobalCourTrackShipHdr."Receipt Date";
            GlobalCourTrackHdr."Transaction Type" := GlobalCourTrackShipHdr."Transaction Type";
            GlobalCourTrackHdr."Transport Method" := GlobalCourTrackShipHdr."Transport Method";
            GlobalCourTrackHdr."CT No." := GlobalCourTrackShipHdr."CT No.";
            GlobalCourTrackHdr.Insurance := GlobalCourTrackShipHdr.Insurance;
            GlobalCourTrackHdr."Applies To Entry" := ParmApplyToEntry;
            GlobalCourTrackHdr."Return Reason Code" := ParmReturnReason;
            GlobalCourTrackHdr."No." := '';
            GlobalCourTrackHdr.INSERT(TRUE);
            //Inserting lines.
            GlobalCourTrackShipLine.RESET;
            GlobalCourTrackShipLine.SETRANGE("Document No.", GlobalCourTrackShipHdr."No.");
            IF GlobalCourTrackShipLine.FIND('-') THEN BEGIN
                GlobalCourTrackLine.INIT;
                GlobalCourTrackLine."Document Type" := GlobalCourTrackLine."Document Type"::Return;
                GlobalCourTrackLine."Document No." := GlobalCourTrackHdr."No.";
                GlobalCourTrackLine."Line No." := GlobalCourTrackShipLine."Line No.";
                GlobalCourTrackLine."POD No." := GlobalCourTrackShipLine."POD No.";
                GlobalCourTrackLine."AWB No." := GlobalCourTrackShipLine."AWB No.";
                GlobalCourTrackLine."Packet No." := GlobalCourTrackShipLine."Packet No.";
                GlobalCourTrackLine.Description := GlobalCourTrackShipLine.Description;
                GlobalCourTrackLine."Packet Type" := GlobalCourTrackShipLine."Packet Type";
                GlobalCourTrackLine.Weight := GlobalCourTrackShipLine.Weight;
                GlobalCourTrackLine.Rate := GlobalCourTrackShipLine.Rate;
                GlobalCourTrackLine.Amount := GlobalCourTrackShipLine.Amount;
                GlobalCourTrackLine."Unit of Measure" := GlobalCourTrackShipLine."Unit of Measure";
                GlobalCourTrackLine.Quantity := GlobalCourTrackShipLine.Quantity;
                GlobalCourTrackLine."Quantity To Return" := GlobalCourTrackShipLine."Quantity Shipped";
                GlobalCourTrackLine.INSERT;
            END;
            MESSAGE(Text33019961);
        END;
    end;

    [Scope('Internal')]
    procedure checkReceiptDetail(ParmApplyToEntry: Code[20]; ParmDocDate: Date)
    begin
        //Checking Receipt.
        GlobalCourTrackRcptHdr.RESET;
        GlobalCourTrackRcptHdr.SETRANGE("Transfer No.", ParmApplyToEntry);
        GlobalCourTrackRcptHdr.SETRANGE("Document Date", ParmDocDate);
        IF GlobalCourTrackRcptHdr.FIND('-') THEN
            ERROR(Text33019962, ParmApplyToEntry);
    end;
}

