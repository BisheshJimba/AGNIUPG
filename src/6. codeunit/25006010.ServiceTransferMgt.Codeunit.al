codeunit 25006010 "Service Transfer Mgt."
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified CreateAutoReturnTransferOrder(),CreateTransOrderHByServH() Usert Profile Setup to Branch Profile Setup
    // 
    // 10.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     CreateAutoReturnTransferOrder
    // 
    // 09.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     CreateAutoReturnTransferOrder
    // 
    // 01.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     CheckServiceLocation
    //   Added code to:
    //     CreateTransOrderHByServH
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     CreateAutoReturnTransferOrder
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     DeleteTransferLine
    // 
    // 19.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added AutoReserveOutbndQty parameter to function:
    //     FillTransfLinesFromService
    //   Modified functions:
    //     FillTransfLinesFromService
    //     CreateTransferOrder
    //   Added function:
    //     CreateTransferOrderForSplit
    //     DeleteTransferLine
    //     FindTransferLine
    // 
    // 07.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     CreateTransOrderHByServH (to add Transfer Lines to existing Transfer Order)
    //     CreateTransferOrder
    //   Added function:
    //     ReserveTransfOrderQtyOutbnd
    // 
    // 15.01.2014 EDMS P8
    //   * Only return lines with quantity to return


    trigger OnRun()
    var
        SrvLine: Record "25006146";
        SlsLine: Record "37";
        ItemLedgerEntryTr: Record "32";
        decQtyToTakeAway: Decimal;
    begin
    end;

    var
        Text011: Label 'To Service (Inbound),From Service (Outbound)';
        Text015: Label 'Do you want to fill transfer order lines?';
        GlobalServLine: Record "25006146";
        UserProfileMgt: Codeunit "25006002";
        UserProfile: Record "25006067";
        ServiceSetup: Record "25006120";
        ChangedService: Boolean;
        TransferCreated: Boolean;
        Text016: Label 'Transfer Order No. %1 is successfully created!';
        Text017: Label 'Transfer Lines added to Transfer Order No. %1!';
        ReserveTransferLine: Codeunit "99000836";
        ReleaseTransferDoc: Codeunit "5708";
        Text018: Label 'Exist Shipped Transfer Line!';

    [Scope('Internal')]
    procedure FillTransfLinesFromService(TransferHeader: Record "5740"; AutoReserveOutbndQty: Boolean)
    var
        TransferLine: Record "5741";
        LineNo: Integer;
        ServiceLine: Record "25006146";
        ReservationMgt: Codeunit "99000845";
        QtyTransfered: Decimal;
    begin
        // LineNo := 10000;                                                              // 19.03.2014 Elva Baltic P21
        LineNo := 0;                                                                     // 19.03.2014 Elva Baltic P21
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        IF TransferLine.FINDLAST THEN
            LineNo += TransferLine."Line No.";

        IF IsServiceLocation(TransferHeader."Transfer-from Code") THEN BEGIN
            //Taking global service line variable to handle only selected lines
            GlobalServLine.SETRANGE("Document Type", TransferHeader."Source Subtype");
            GlobalServLine.SETRANGE("Document No.", TransferHeader."Source No.");
            GlobalServLine.SETRANGE(Type, GlobalServLine.Type::Item);
            IF GlobalServLine.FINDFIRST THEN
                REPEAT
                    GlobalServLine.CALCFIELDS("Reserved Quantity"); //ratan

                    IF GlobalServLine."Reserved Quantity" >= 0 THEN BEGIN
                        LineNo += 10000;
                        IF GlobalServLine."Qty. to Return" > 0 THEN BEGIN  //15.01.2014 EDMS P8   //ratan
                            CreateTransferLine(TransferHeader,
                                             TransferLine,
                                             LineNo,
                                             GlobalServLine."No.",
                                          GlobalServLine."Qty. to Return", GlobalServLine."Variant Code");
                            //Changing reservations in 4 steps
                            //Step 1: Saving the initial Quantity Transfered
                            QtyTransfered := GlobalServLine.CalcTransferedQuantity;
                            //Step 2: Canceling all Service Line reservations to Item Ledger Entries (Transfered Qty.)
                            ReservationMgt.CancelServLineRresILE(GlobalServLine);
                            //Step 3: Reserving Service Line to ILE (decreased by Qty.to Return)
                            GlobalServLine.AutoReserveToILE(QtyTransfered - GlobalServLine."Qty. to Return");
                            //Step 4: Auto-Reserve return Transfer Line (Outb.) to Item Ledger Entry
                            TransferLine.AutoReserveSilent(0); //0=Outbound

                            GlobalServLine."Qty. to Return" := 0;
                            GlobalServLine.MODIFY;
                        END;

                    END;
                UNTIL GlobalServLine.NEXT = 0;
        END
        ELSE
            IF IsServiceLocation(TransferHeader."Transfer-to Code") THEN BEGIN
                ServiceSetup.GET;
                ServiceLine.RESET;
                ServiceLine.SETRANGE("Document Type", TransferHeader."Source Subtype");
                ServiceLine.SETRANGE("Document No.", TransferHeader."Source No.");
                ServiceLine.SETRANGE(Type, ServiceLine.Type::Item);
                IF ServiceLine.FINDFIRST THEN
                    REPEAT
                        ServiceLine.CALCFIELDS("Reserved Quantity");
                        IF ServiceLine."Reserved Quantity" < ServiceLine.Quantity THEN BEGIN
                            LineNo += 10000;
                            CreateTransferLine(TransferHeader,
                                               TransferLine,
                                               LineNo,
                                               ServiceLine."No.",
                                            ServiceLine.Quantity - ServiceLine."Reserved Quantity", ServiceLine."Variant Code");
                            CheckLineReservation(TransferLine, ServiceLine);
                            TransferLine.AutoReserveServ(1);
                            // IF ServiceSetup."Inbound Transf. Auto-Reserve" THEN                            // 19.03.2014 Elva Baltic P21
                            IF ServiceSetup."Inbound Transf. Auto-Reserve" AND AutoReserveOutbndQty THEN      // 19.03.2014 Elva Baltic P21
                                TransferLine.AutoReserveSilent(0); //Automatically reserves outbound qty. to ILE, PO, etc on Spare Parts Location
                        END;
                    UNTIL ServiceLine.NEXT = 0;
            END
    end;

    [Scope('Internal')]
    procedure IsServiceLocation(LocationCode: Code[20]): Boolean
    var
        Location: Record "14";
    begin
        IF NOT Location.GET(LocationCode) THEN
            EXIT(FALSE);
        EXIT(Location."Use As Service Location")
    end;

    [Scope('Internal')]
    procedure CreateServLineForTransf(TransferLine: Record "5741")
    var
        ServLine: Record "25006146";
        LineNo: Integer;
    begin
        TransferLine.TESTFIELD("Source Type", DATABASE::"Service Line EDMS");
        TransferLine.TESTFIELD("Source Subtype");
        TransferLine.TESTFIELD("Source No.");

        LineNo := 0;
        ServLine.RESET;
        ServLine.SETRANGE("Document Type", TransferLine."Source Subtype");
        ServLine.SETRANGE("Document No.", TransferLine."Source No.");
        IF ServLine.FINDLAST THEN
            LineNo := ServLine."Line No.";

        ServLine.INIT;
        ServLine."Document Type" := TransferLine."Source Subtype";
        ServLine."Document No." := TransferLine."Source No.";
        LineNo += 10000;
        ServLine."Line No." := LineNo;
        ServLine.INSERT(TRUE);
        ServLine.Type := ServLine.Type::Item;
        ServLine.VALIDATE("No.", TransferLine."Item No.");
        TransferLine.CALCFIELDS("Reserved Quantity Inbnd.", "Reserved Quantity Outbnd.");
        IF IsServiceLocation(TransferLine."Transfer-from Code") THEN
            ServLine.VALIDATE(Quantity, TransferLine.Quantity - TransferLine."Reserved Quantity Outbnd.")
        ELSE
            IF IsServiceLocation(TransferLine."Transfer-to Code") THEN
                ServLine.VALIDATE(Quantity, TransferLine.Quantity - TransferLine."Reserved Quantity Inbnd.");
        ServLine.MODIFY(TRUE);
    end;

    [Scope('Internal')]
    procedure LinkTransferWithService(TransferHeader: Record "5740")
    var
        TransferLine: Record "5741";
        TransferLine2: Record "5741";
        LineNo: Integer;
        Direction: Option Outbound,Inbound;
    begin
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        IF TransferLine.FINDFIRST THEN
            REPEAT
                TransferLine.CALCFIELDS("Reserved Quantity Inbnd.", "Reserved Quantity Outbnd.");
                IF IsServiceLocation(TransferLine."Transfer-from Code") THEN BEGIN
                    IF TransferLine."Reserved Quantity Outbnd." <> TransferLine.Quantity THEN
                        IF NOT TransferLine.AutoReserveServ(Direction::Outbound) THEN BEGIN
                            CreateServLineForTransf(TransferLine);
                            TransferLine.AutoReserveServ(Direction::Outbound);
                        END;
                END
                ELSE
                    IF IsServiceLocation(TransferLine."Transfer-to Code") THEN BEGIN
                        IF TransferLine."Reserved Quantity Inbnd." <> TransferLine.Quantity THEN
                            IF NOT TransferLine.AutoReserveServ(Direction::Inbound) THEN BEGIN
                                CreateServLineForTransf(TransferLine);
                                TransferLine.AutoReserveServ(Direction::Inbound);
                            END
                    END;
            UNTIL TransferLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateTransferOrder(ServiceHeader: Record "25006145"): Boolean
    var
        TransferHeader: Record "5740";
        FromLocationCode: Code[20];
        ToLocationCode: Code[20];
        OptionNumber: Integer;
        FromLocation: Code[20];
        ToLocation: Code[20];
        ServLocation: Code[20];
        SparePartLocation: Code[20];
        FillLines: Boolean;
    begin
        OptionNumber := STRMENU(Text011);
        IF OptionNumber = 0 THEN
            EXIT(FALSE);

        FillLines := CreateTransOrderHByServH(ServiceHeader, TransferHeader, (OptionNumber = 1));
        IF FillLines THEN
            // FillTransfLinesFromService(TransferHeader);                 // 19.03.2014 Elva Baltic P21
            FillTransfLinesFromService(TransferHeader, TRUE);              // 19.03.2014 Elva Baltic P21

        // 07.03.2014 Elva Baltic P21 >>
        /*
        IF TransferCreated THEN
          MESSAGE(Text016, TransferHeader."No.")
        ELSE
          MESSAGE(Text017, TransferHeader."No.");
        */

        COMMIT;
        PAGE.RUNMODAL(PAGE::"Transfer Order", TransferHeader);
        // 07.03.2014 Elva Baltic P21 <<

        EXIT(TRUE)

    end;

    [Scope('Internal')]
    procedure SetTransferLineSelection(var ServLine: Record "25006146")
    begin
        IF ServLine.FINDFIRST THEN
            REPEAT
                GlobalServLine.GET(ServLine."Document Type", ServLine."Document No.", ServLine."Line No.");
                GlobalServLine.MARK(TRUE);
            UNTIL ServLine.NEXT = 0;
        GlobalServLine.MARKEDONLY(TRUE);
    end;

    [Scope('Internal')]
    procedure CreateTransferLine(var TransferHeader: Record "5740"; var TransferLine: Record "5741"; NewLineNo: Integer; ItemNo: Code[20]; Quantity: Decimal; VariantCode: Code[20])
    begin
        TransferLine.INIT;
        TransferLine."Document No." := TransferHeader."No.";
        TransferLine."Line No." := NewLineNo;
        TransferLine."Document Profile" := TransferLine."Document Profile"::Service;
        TransferLine.VALIDATE("Item No.", ItemNo);
        TransferLine.VALIDATE("Variant Code", VariantCode);
        IF IsServiceLocation(TransferHeader."Transfer-to Code") THEN
            CalcAvailability(TransferLine, Quantity);
        TransferLine.VALIDATE(Quantity, Quantity);
        TransferLine.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure MoveServLineResToTransfOrder(var ServLine: Record "25006146"; var TransfLine: Record "5741")
    var
        ResEntry: Record "337";
        ResEntry2: Record "337";
    begin
        ResEntry.RESET;
        ResEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
                               "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
        ResEntry.SETRANGE("Reservation Status", ResEntry."Reservation Status"::Reservation);
        ResEntry.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
        ResEntry.SETRANGE("Source Subtype", ServLine."Document Type");
        ResEntry.SETRANGE("Source ID", ServLine."Document No.");
        ResEntry.SETRANGE("Source Ref. No.", ServLine."Line No.");
        IF ResEntry.FINDFIRST THEN
            REPEAT
                ResEntry2.RESET;
                ResEntry2.GET(ResEntry."Entry No.", ResEntry.Positive);
                ResEntry2."Source Type" := DATABASE::"Transfer Line";
                ResEntry2."Source Subtype" := 0; //Outbound
                ResEntry2."Source ID" := TransfLine."Document No.";
                ResEntry2."Source Ref. No." := TransfLine."Line No.";
                ResEntry2."Source Prod. Order Line" := 0;
                ResEntry2.MODIFY;
            UNTIL ResEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ServLineQtyResToILE(ServLine: Record "25006146"): Decimal
    var
        ResEntry: Record "337";
        ResEntry2: Record "337";
        ResQuantity: Decimal;
    begin
        ResEntry.RESET;
        ResEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
                               "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
        ResEntry.SETRANGE("Reservation Status", ResEntry."Reservation Status"::Reservation);
        ResEntry.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
        ResEntry.SETRANGE("Source Subtype", ServLine."Document Type");
        ResEntry.SETRANGE("Source ID", ServLine."Document No.");
        ResEntry.SETRANGE("Source Ref. No.", ServLine."Line No.");
        IF ResEntry.FINDFIRST THEN
            REPEAT
                ResEntry2.RESET;
                ResEntry2.GET(ResEntry."Entry No.", NOT ResEntry.Positive);
                IF ResEntry2."Source Type" = DATABASE::"Item Ledger Entry" THEN
                    ResQuantity += ResEntry2.Quantity;
            UNTIL ResEntry.NEXT = 0;

        EXIT(ResQuantity);
    end;

    [Scope('Internal')]
    procedure CreateAutoReturnTransferOrder(var SalesHeader: Record "36"; Post: Boolean)
    var
        SparePartLocation: Code[20];
        SalesLine: Record "37";
        FromLocation: Code[20];
        ToLocation: Code[20];
        TransferHeader: Record "5740";
        TransferLine: Record "5741";
        LineNo: Integer;
        TransferPostShipment: Codeunit "5704";
        TransferPostReceipt: Codeunit "5705";
        Item: Record "27";
        TransHeaderInserted: Boolean;
    begin
        ServiceSetup.GET;
        UserProfile.GET(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo);
        SparePartLocation := UserProfile."Def. Spare Part Location Code";
        IF SparePartLocation = '' THEN
            SparePartLocation := ServiceSetup."Def. Spare Part Location Code";

        // 31.03.2014 Elva Baltic P21 >>
        // FromLocation := SparePartLocation;
        // ToLocation := SalesHeader."Location Code";
        FromLocation := SalesHeader."Location Code";
        ToLocation := SparePartLocation;
        // 31.03.2014 Elva Baltic P21 <<

        // 10.04.2014 Elva Baltic P21 >>
        /*
        TransferHeader.RESET;
        TransferHeader.INIT;
        TransferHeader.INSERT(TRUE);
        TransferHeader.VALIDATE("Transfer-from Code",FromLocation);
        TransferHeader.VALIDATE("Transfer-to Code",ToLocation);
        TransferHeader."Document Profile" := TransferHeader."Document Profile"::Service;
        TransferHeader."Source Type" := DATABASE::"Sales Line";
        TransferHeader."Source Subtype" := SalesHeader."Document Type";
        TransferHeader."Source No." := SalesHeader."No.";
        TransferHeader."Posting Date" := SalesHeader."Posting Date";                          // 09.04.2014 Elva Baltic P21
        TransferHeader.MODIFY(TRUE);
        */

        TransHeaderInserted := FALSE;
        // 10.04.2014 Elva Baltic P21 <<

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        SalesLine.SETFILTER("No.", '<>''''');
        IF SalesLine.FINDFIRST THEN
            REPEAT
                // 10.04.2014 Elva Baltic P21 >>
                Item.GET(SalesLine."No.");
                IF NOT TransHeaderInserted THEN BEGIN
                    TransferHeader.RESET;
                    TransferHeader.INIT;
                    TransferHeader.INSERT(TRUE);
                    TransferHeader.VALIDATE("Transfer-from Code", FromLocation);
                    TransferHeader.VALIDATE("Transfer-to Code", ToLocation);
                    TransferHeader."Document Profile" := TransferHeader."Document Profile"::Service;
                    TransferHeader."Source Type" := DATABASE::"Sales Line";
                    TransferHeader."Source Subtype" := SalesHeader."Document Type";
                    TransferHeader."Source No." := SalesHeader."No.";
                    TransferHeader."Posting Date" := SalesHeader."Posting Date";
                    TransferHeader.MODIFY(TRUE);
                    TransHeaderInserted := TRUE;
                END;
                // 10.04.2014 Elva Baltic P21 <<
                LineNo += 10000;
                TransferLine.INIT;
                TransferLine."Document No." := TransferHeader."No.";
                TransferLine."Line No." := LineNo;
                TransferLine.VALIDATE("Item No.", SalesLine."No.");
                TransferLine.VALIDATE(Quantity, SalesLine.Quantity);
                TransferLine.INSERT(TRUE);
            UNTIL SalesLine.NEXT = 0;

        // IF Post THEN BEGIN                                                                        // 10.04.2014 Elva Baltic P21
        IF Post AND TransHeaderInserted THEN BEGIN                                                   // 10.04.2014 Elva Baltic P21
            TransferPostShipment.RUN(TransferHeader);
            TransferPostReceipt.RUN(TransferHeader);
        END;

    end;

    [Scope('Internal')]
    procedure GetServiceChangeInfo(): Boolean
    begin
        EXIT(ChangedService)
    end;

    [Scope('Internal')]
    procedure CheckLineReservation(TransferLine: Record "5741"; var ServiceLine: Record "25006146")
    var
        TransferHeader: Record "5740";
        TransferDate: Date;
    begin
        TransferHeader.GET(TransferLine."Document No.");
        IF IsServiceLocation(TransferHeader."Transfer-from Code") THEN
            TransferDate := TransferLine."Shipment Date"
        ELSE
            TransferDate := TransferLine."Receipt Date";

        IF (TransferDate > ServiceLine."Planned Service Date") THEN BEGIN
            ChangedService := TRUE;
            ServiceLine.VALIDATE("Planned Service Date", TransferLine."Receipt Date");
            ServiceLine.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure CalcAvailability(var TransferLine: Record "5741"; Quantity: Decimal): Decimal
    var
        Item: Record "27";
        Vendor: Record "23";
        AvailableToPromise: Codeunit "5790";
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        AvailableQty: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
        EmptyDateFormula: DateFormula;
    begin
        IF Item.GET(TransferLine."Item No.") THEN BEGIN
            IF TransferLine."Shipment Date" <> 0D THEN
                AvailabilityDate := TransferLine."Shipment Date"
            ELSE
                AvailabilityDate := WORKDATE;

            Item.RESET;
            Item.SETRANGE("Date Filter", 0D, AvailabilityDate);
            Item.SETRANGE("Variant Filter", TransferLine."Variant Code");
            Item.SETRANGE("Location Filter", TransferLine."Transfer-from Code");
            Item.SETRANGE("Drop Shipment Filter", FALSE);
            IF Vendor.GET(Item."Vendor No.") AND (Vendor."Lead Time Calculation" <> EmptyDateFormula) THEN BEGIN
                AvailableQty := AvailableToPromise.QtyAvailabletoPromise(Item, GrossRequirement, ScheduledReceipt, AvailabilityDate,
                                          PeriodType, LookaheadDateformula);

                IF (Quantity > AvailableQty) THEN BEGIN
                    TransferLine.VALIDATE("Shipment Date", CALCDATE(Vendor."Lead Time Calculation", TransferLine."Shipment Date"));
                END;
            END;

        END;
    end;

    [Scope('Internal')]
    procedure "//--SIE------"()
    begin
    end;

    [Scope('Internal')]
    procedure CreateTransOrderHByServH(ServiceHeader: Record "25006145"; var TransferHeader: Record "5740"; ToServiceLocation: Boolean): Boolean
    var
        FromLocationCode: Code[20];
        ToLocationCode: Code[20];
        OptionNumber: Integer;
        FromLocation: Code[20];
        ToLocation: Code[20];
        ServLocation: Code[20];
        SparePartLocation: Code[20];
        FillLines: Boolean;
    begin
        ServiceSetup.GET;
        UserProfile.GET(UserProfileMgt.CurrProfileID);
        UserProfile.TESTFIELD("Def. Spare Part Location Code");  //27.03.2013 EDMS P8
        SparePartLocation := UserProfile."Def. Spare Part Location Code";
        IF SparePartLocation = '' THEN
            SparePartLocation := ServiceSetup."Def. Spare Part Location Code";

        ServiceHeader.TESTFIELD("Location Code");                                                     // 01.04.2014 Elva Baltic P21
        CheckServiceLocation(ServiceHeader."Location Code");                                          // 01.04.2014 Elva Baltic P21

        IF ToServiceLocation THEN BEGIN
            FromLocation := SparePartLocation;
            ToLocation := ServiceHeader."Location Code";

            CASE ServiceSetup."Inbound Transfer Line Filling" OF
                ServiceSetup."Inbound Transfer Line Filling"::Manual:
                    FillLines := FALSE;
                ServiceSetup."Inbound Transfer Line Filling"::Prompt:
                    BEGIN
                        IF CONFIRM(Text015, TRUE) THEN
                            FillLines := TRUE
                        ELSE
                            FillLines := FALSE;
                    END;
                ServiceSetup."Inbound Transfer Line Filling"::Automatic:
                    FillLines := TRUE;
            END;
        END
        ELSE BEGIN
            FromLocation := ServiceHeader."Location Code";
            ToLocation := SparePartLocation;

            CASE ServiceSetup."Outbound Transfer Line Filling" OF
                ServiceSetup."Outbound Transfer Line Filling"::Manual:
                    FillLines := FALSE;
                ServiceSetup."Outbound Transfer Line Filling"::Prompt:
                    BEGIN
                        IF CONFIRM(Text015, TRUE) THEN
                            FillLines := TRUE
                        ELSE
                            FillLines := FALSE;
                    END;
                ServiceSetup."Outbound Transfer Line Filling"::Automatic:
                    FillLines := TRUE;
            END;

        END;

        // 07.03.2014 Elva Baltic P21 >>
        TransferCreated := FALSE;
        TransferHeader.RESET;
        TransferHeader.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransferHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransferHeader.SETRANGE("Source Subtype", 1);
        TransferHeader.SETRANGE("Source No.", ServiceHeader."No.");
        TransferHeader.SETRANGE("Document Profile", TransferHeader."Document Profile"::Service);
        TransferHeader.SETRANGE("Transfer-from Code", FromLocation);
        TransferHeader.SETRANGE("Transfer-to Code", ToLocation);
        IF NOT TransferHeader.FINDFIRST THEN BEGIN
            // 07.03.2014 Elva Baltic P21 <<
            TransferHeader.RESET;
            TransferHeader.INIT;
            TransferHeader.INSERT(TRUE);
            TransferHeader.VALIDATE("Transfer-from Code", FromLocation);
            TransferHeader.VALIDATE("Transfer-to Code", ToLocation);
            TransferHeader."Document Profile" := TransferHeader."Document Profile"::Service;
            TransferHeader."Source Type" := DATABASE::"Service Header EDMS";
            TransferHeader."Source Subtype" := ServiceHeader."Document Type";
            TransferHeader."Source No." := ServiceHeader."No.";
            //Sipradi-YS
            TransferHeader."Model Code" := ServiceHeader."Model Code";
            TransferHeader."Vehicle Regd. No." := ServiceHeader."Vehicle Registration No.";
            //Sipradi-YS
            TransferHeader.MODIFY(TRUE);
            // 07.03.2014 Elva Baltic P21 >>
            TransferCreated := TRUE;
        END ELSE
            IF TransferHeader.Status = TransferHeader.Status::Released THEN
                ReleaseTransferDoc.Reopen(TransferHeader);
        // 07.03.2014 Elva Baltic P21 <<

        EXIT(FillLines)
    end;

    [Scope('Internal')]
    procedure DeleteTransOrderHeadIfEmpty(var TransferHeader: Record "5740")
    var
        TransferLine: Record "5741";
    begin
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        IF NOT TransferLine.FINDFIRST THEN
            TransferHeader.DELETE;
    end;

    [Scope('Internal')]
    procedure CreateTransferOrderBySIEAssign(ServiceHeader: Record "25006145"; var SIEAssignment: Record "25006706"; ToServiceLocation: Boolean; RunModeFlags: Integer): Boolean
    var
        TransferHeader: Record "5740";
        FromLocationCode: Code[20];
        ToLocationCode: Code[20];
        OptionNumber: Integer;
        FromLocation: Code[20];
        ToLocation: Code[20];
        ServLocation: Code[20];
        SparePartLocation: Code[20];
        FillLines: Boolean;
        FlagsArray: array[16] of Boolean;
    begin
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        FillLines := CreateTransOrderHByServH(ServiceHeader, TransferHeader, ToServiceLocation);
        IF FillLines THEN
            FillTransfLinesFromSIEAssign(TransferHeader, SIEAssignment);
        DeleteTransOrderHeadIfEmpty(TransferHeader);  //27.03.2013 EDMS P8
        EXIT(TRUE)
    end;

    [Scope('Internal')]
    procedure FillTransfLinesFromSIEAssign(TransferHeader: Record "5740"; var SIEAssignment: Record "25006706")
    var
        TransferLine: Record "5741";
        LineNo: Integer;
        ServiceLine: Record "25006146";
        ReservationMgt: Codeunit "99000845";
        QtyTransfered: Decimal;
    begin
        LineNo := 10000;
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        IF TransferLine.FINDLAST THEN
            LineNo += TransferLine."Line No.";

        IF IsServiceLocation(TransferHeader."Transfer-from Code") THEN BEGIN
            //Taking global service line variable to handle only selected lines
            GlobalServLine.SETRANGE("Document Type", TransferHeader."Source Subtype");
            GlobalServLine.SETRANGE("Document No.", TransferHeader."Source No.");
            GlobalServLine.SETRANGE(Type, GlobalServLine.Type::Item);
            IF GlobalServLine.FINDFIRST THEN
                IF SIEAssignment.FINDFIRST THEN;
            REPEAT
                GlobalServLine.CALCFIELDS("Reserved Quantity");
                IF GlobalServLine."Reserved Quantity" > 0 THEN BEGIN
                    LineNo += 10000;
                    CreateTransferLine(TransferHeader,
                                       TransferLine,
                                       LineNo,
                                       GlobalServLine."No.",
                                       GlobalServLine."Qty. to Return", GlobalServLine."Variant Code");
                    //Changing reservations in 4 steps
                    //Step 1: Saving the initial Quantity Transfered
                    QtyTransfered := GlobalServLine.CalcTransferedQuantity;
                    //Step 2: Canceling all Service Line reservations to Item Ledger Entries (Transfered Qty.)
                    ReservationMgt.CancelServLineRresILE(GlobalServLine);
                    //Step 3: Reserving Service Line to ILE (decreased by Qty.to Return)
                    GlobalServLine.AutoReserveToILE(QtyTransfered - GlobalServLine."Qty. to Return");
                    //Step 4: Auto-Reserve return Transfer Line (Outb.) to Item Ledger Entry
                    TransferLine.AutoReserveSilent(0); //0=Outbound

                    IF GlobalServLine."Qty. to Return" <> 0 THEN BEGIN
                        GlobalServLine."Qty. to Return" := 0;
                        GlobalServLine.MODIFY;
                    END;

                END;
            UNTIL GlobalServLine.NEXT = 0;
        END
        ELSE
            IF IsServiceLocation(TransferHeader."Transfer-to Code") THEN BEGIN
                ServiceSetup.GET;
                ServiceLine.RESET;
                ServiceLine.SETRANGE("Document Type", TransferHeader."Source Subtype");
                ServiceLine.SETRANGE("Document No.", TransferHeader."Source No.");
                ServiceLine.SETRANGE(Type, ServiceLine.Type::Item);
                IF SIEAssignment.FINDFIRST THEN
                    REPEAT
                        ServiceLine.GET(SIEAssignment."Applies-to Doc. Type", SIEAssignment."Applies-to Doc. No.",
                          SIEAssignment."Applies-to Doc. Line No.");
                        ServiceLine.CALCFIELDS("Reserved Quantity");
                        IF ServiceLine."Reserved Quantity" < SIEAssignment."Qty. to Transfer" THEN BEGIN
                            LineNo += 10000;
                            CreateTransferLine(TransferHeader,
                                               TransferLine,
                                               LineNo,
                                               ServiceLine."No.",
                                               SIEAssignment."Qty. to Transfer" - ServiceLine."Reserved Quantity", ServiceLine."Variant Code");
                            CheckLineReservation(TransferLine, ServiceLine);
                            TransferLine.AutoReserveServ(1);
                            IF ServiceSetup."Inbound Transf. Auto-Reserve" THEN
                                TransferLine.AutoReserveSilent(0); //Automatically reserves outbound qty. to ILE, PO, etc on Spare Parts Location
                        END;
                    UNTIL SIEAssignment.NEXT = 0;
            END
    end;

    [Scope('Internal')]
    procedure PostTransOrderHByServH(ServiceHeader: Record "25006145"; RunModeFlags: Integer)
    var
        TransHeader: Record "5740";
        TransferPostShipment: Codeunit "5704";
        TransferPostReceipt: Codeunit "5705";
    begin
        //AdjustFlagsToArray(RunModeFlags, FlagsArray);
        TransHeader.RESET;
        TransHeader.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransHeader.SETRANGE("Source Subtype", 1);
        TransHeader.SETRANGE("Source No.", ServiceHeader."No.");
        TransHeader.SETRANGE("Document Profile", "Document Profile"::Service);
        IF TransHeader.FINDFIRST THEN
            REPEAT
                CLEAR(TransferPostShipment);
                CLEAR(TransferPostReceipt);
                IF NOT GUIALLOWED THEN
                    MESSAGE('NASMSG: is going to TransferPostShipment');
                TransferPostShipment.RUN(TransHeader);
                IF NOT GUIALLOWED THEN
                    MESSAGE('NASMSG: is going to TransferPostReceipt.');
                TransferPostReceipt.RUN(TransHeader);
            UNTIL TransHeader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure "--SMALL TECHN--"()
    begin
    end;

    [Scope('Internal')]
    procedure CutNextBit(var Flags: Integer) RetValue: Boolean
    begin
        RetValue := ((Flags MOD 2) > 0);
        Flags := Flags DIV 2;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure AdjustFlagsToArray(Flags: Integer; var ArrayEDMS: array[16] of Boolean)
    var
        i: Integer;
    begin
        FOR i := 1 TO 16 DO BEGIN
            ArrayEDMS[i] := CutNextBit(Flags);
        END;
    end;

    [Scope('Internal')]
    procedure ReserveTransfOrderQtyOutbnd(TransHeader: Record "5740")
    var
        TransLine: Record "5741";
        ReservationMgt: Codeunit "99000845";
    begin
        TransLine.RESET;
        TransLine.SETRANGE("Document No.", TransHeader."No.");
        TransLine.SETRANGE("Derived From Line No.", 0);
        IF TransLine.FINDSET THEN
            REPEAT
                TransLine.CALCFIELDS("Reserved Quantity Outbnd.");
                IF TransLine."Reserved Quantity Outbnd." < TransLine.Quantity - TransLine."Quantity Shipped" THEN
                    AutoReserveSilent(0);  //Automatically reserves outbound qty. to ILE, PO, etc on Spare Parts Location
            UNTIL TransLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateTransferOrderForSplit(ServiceHeader: Record "25006145")
    var
        TransferHeader: Record "5740";
        OptionNumber: Integer;
    begin
        CreateTransOrderHByServH(ServiceHeader, TransferHeader, TRUE);
        FillTransfLinesFromService(TransferHeader, FALSE);
    end;

    [Scope('Internal')]
    procedure DeleteTransferLine(ServiceLine: Record "25006146")
    var
        ResEntryNegative: Record "337";
        ResEntryPositive: Record "337";
        TransfLine: Record "5741";
        TransfHeader: Record "5740";
    begin
        IF FindTransferLine(ServiceLine, TransfLine) THEN BEGIN
            TransfLine.TESTFIELD("Quantity Shipped", 0);
            TransfLine.TESTFIELD("Quantity Received", 0);
            IF TransfLine."Derived From Line No." <> 0 THEN
                ERROR(Text018);
            TransfHeader.GET(TransfLine."Document No.");
            IF TransfHeader.Status = TransfHeader.Status::Released THEN BEGIN
                ReleaseTransferDoc.Reopen(TransfHeader);
                TransfLine.GET(TransfLine."Document No.", TransfLine."Line No.");                   // 28.03.2014 Elva Baltic P21
            END;
            ReserveTransferLine.DeleteLine(TransfLine);
            TransfLine.DELETE(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure FindTransferLine(ServiceLine: Record "25006146"; var TransfLine: Record "5741"): Boolean
    var
        ResEntryNegative: Record "337";
        ResEntryPositive: Record "337";
    begin
        ResEntryNegative.RESET;
        ResEntryNegative.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SETRANGE("Source ID", ServiceLine."Document No.");
        ResEntryNegative.SETRANGE("Source Ref. No.", "Line No.");
        ResEntryNegative.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
        ResEntryNegative.SETRANGE("Source Subtype", ServiceLine."Document Type");
        ResEntryNegative.SETRANGE("Reservation Status", ResEntryNegative."Reservation Status"::Reservation);
        IF ResEntryNegative.FINDFIRST THEN
            REPEAT
                IF ResEntryPositive.GET(ResEntryNegative."Entry No.", TRUE) THEN BEGIN
                    IF ResEntryPositive."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
                        IF TransfLine.GET(ResEntryPositive."Source ID", ResEntryPositive."Source Ref. No.") THEN
                            EXIT(TRUE)
                    END;
                END;
            UNTIL ResEntryNegative.NEXT = 0;
        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure CheckServiceLocation(LocationCode: Code[20]): Boolean
    var
        Location: Record "14";
    begin
        Location.GET(LocationCode);
        Location.TESTFIELD("Use As Service Location");
    end;
}

