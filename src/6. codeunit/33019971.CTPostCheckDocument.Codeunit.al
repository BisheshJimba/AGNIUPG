codeunit 33019971 "CT Post - Check Document"
{

    trigger OnRun()
    begin
    end;

    var
        GlobalCourierTrackHdr: Record "33019987";

    [Scope('Internal')]
    procedure CheckCTHdr(ParmCourierTrackHdr1: Record "33019987")
    begin
        //Checking Courier Tracking header for empty fields.
        ParmCourierTrackHdr1.TESTFIELD("Transfer From Code");
        ParmCourierTrackHdr1.TESTFIELD("Transfer To Code");
        ParmCourierTrackHdr1.TESTFIELD("Transfer From Department");
        ParmCourierTrackHdr1.TESTFIELD("Transfer To Department");
        ParmCourierTrackHdr1.TESTFIELD("Posting Date");
        ParmCourierTrackHdr1.TESTFIELD("Transfer From Contact");
        ParmCourierTrackHdr1.TESTFIELD("Shipment Date");
        ParmCourierTrackHdr1.TESTFIELD("Shipment Method Code");
        ParmCourierTrackHdr1.TESTFIELD("Shipping Agent Code");
        ParmCourierTrackHdr1.TESTFIELD("Transfer To Contact");
        ParmCourierTrackHdr1.TESTFIELD("Receipt Date");
        ParmCourierTrackHdr1.TESTFIELD("Transport Method");
        //TESTFIELD("CT No.");
    end;

    [Scope('Internal')]
    procedure CheckCTLineShip(ParmCourierTrackHdr2: Record "33019987")
    var
        LocalCourierTrackLine: Record "33019988";
    begin
        //Checking Courier Tracking Lines for empty fields.
        LocalCourierTrackLine.RESET;
        LocalCourierTrackLine.SETRANGE("Document Type", ParmCourierTrackHdr2."Document Type");
        LocalCourierTrackLine.SETRANGE("Document No.", ParmCourierTrackHdr2."No.");
        IF LocalCourierTrackLine.FIND('-') THEN BEGIN
            REPEAT
                LocalCourierTrackLine.TESTFIELD("Packet No.");
                LocalCourierTrackLine.TESTFIELD(Rate);
                LocalCourierTrackLine.TESTFIELD("Unit of Measure");
                LocalCourierTrackLine.TESTFIELD(Quantity);
                LocalCourierTrackLine.TESTFIELD("Quantity To Ship");
            UNTIL LocalCourierTrackLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure CheckShipment(ParmCourTrackHdr3: Record "33019987")
    var
        Text33019961: Label 'Cannot receive without shipping. Please ship first and then receive.';
    begin
        //Checking for shipment before receiving.
        IF NOT ParmCourTrackHdr3.Shipped THEN
            ERROR(Text33019961);
    end;

    [Scope('Internal')]
    procedure CheckShipCanelled(ParmCourTrackHdr4: Record "33019987")
    var
        LocalCourShipHdr: Record "33019989";
        Text33019961: Label 'Shipment is cancelled by sender. Please confirm and then post or delete this document.';
    begin
        //Checking for shipment with same document no. for cancellation. If already cancelled then show error.
        LocalCourShipHdr.RESET;
        LocalCourShipHdr.SETRANGE("Transfer No.", ParmCourTrackHdr4."No.");
        LocalCourShipHdr.SETRANGE("Shipment Date", ParmCourTrackHdr4."Shipment Date");
        LocalCourShipHdr.SETRANGE(Void, TRUE);
        IF LocalCourShipHdr.FIND('-') THEN
            ERROR(Text33019961);
    end;

    [Scope('Internal')]
    procedure CheckCTLineRcpt(ParmCourierTrackHdr2: Record "33019987")
    var
        LocalCourierTrackLine: Record "33019988";
    begin
        //Checking Courier Tracking Lines for empty fields.
        LocalCourierTrackLine.RESET;
        LocalCourierTrackLine.SETRANGE("Document Type", ParmCourierTrackHdr2."Document Type");
        LocalCourierTrackLine.SETRANGE("Document No.", ParmCourierTrackHdr2."No.");
        IF LocalCourierTrackLine.FIND('-') THEN BEGIN
            REPEAT
                LocalCourierTrackLine.TESTFIELD("POD No.");
                LocalCourierTrackLine.TESTFIELD("AWB No.");
                LocalCourierTrackLine.TESTFIELD("Packet No.");
                LocalCourierTrackLine.TESTFIELD(Rate);
                LocalCourierTrackLine.TESTFIELD("Unit of Measure");
                LocalCourierTrackLine.TESTFIELD(Quantity);
                LocalCourierTrackLine.TESTFIELD("Quantity To Receive");
                LocalCourierTrackLine.TESTFIELD(Condition);
            UNTIL LocalCourierTrackLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure CheckShipped(PrmCTHdr: Record "33019987")
    var
        LclCTHdr: Record "33019987";
        Text33019961: Label 'Already shipped. You cannot ship the same document twice.';
    begin
        //Checking for re-shipment.
        LclCTHdr.RESET;
        LclCTHdr.SETRANGE("Document Type", PrmCTHdr."Document Type");
        LclCTHdr.SETRANGE("No.", PrmCTHdr."No.");
        IF LclCTHdr.FIND('-') THEN BEGIN
            IF LclCTHdr.Shipped THEN
                ERROR(Text33019961);
        END;
    end;

    [Scope('Internal')]
    procedure CheckShipper(PrmCTHdr: Record "33019987")
    var
        LclCTHdr: Record "33019987";
        Text33019961: Label 'Sorry, same user cannot ship and receive the courier.\ If returning shipment, please use Return Shipment.\ Or contact your system administrator for details.';
    begin
        //Checking shipper and receiver. If same user is shipping and receiving then show error.
        LclCTHdr.RESET;
        LclCTHdr.SETRANGE("Document Type", PrmCTHdr."Document Type");
        LclCTHdr.SETRANGE("No.", PrmCTHdr."No.");
        IF LclCTHdr.FIND('-') THEN BEGIN
            IF LclCTHdr."User ID" = USERID THEN
                ERROR(Text33019961);
        END;
    end;
}

