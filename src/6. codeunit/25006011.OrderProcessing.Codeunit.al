codeunit 25006011 "Order Processing"
{
    // 15.04.2015 EDMS P21
    //   Modified function:
    //     PurchaseLine3
    // 
    // 23.04.2013 Elva Baltic P15
    //   * Added function DimensionChange


    trigger OnRun()
    begin
    end;

    var
        EDMS001: Label 'Document do not exist.';
        Text001: Label 'Nonstock Item %1 does not exist.';
        Text002: Label 'You have to pick one document.';
        SortNo: Code[20];

    [Scope('Internal')]
    procedure ImportBuffer(DocumentNo: Code[20]; PurchInvImportBuf: Record "25006756"; var DataBuffer: Record "25006004"; Preview: Boolean)
    var
        PurchHdr: Record "38";
        PurchLine: Record "39";
        PurchLine2: Record "39";
        PurchLine3: Record "39";
        TotalTransfer: Decimal;
        UnitPrice: Decimal;
        QtyToTransfer: Decimal;
        EntryNo: Integer;
        LineNo: Integer;
        WhichLine: Integer;
        LineCount: Integer;
        LastOne: Boolean;
        PartialTransfer: Boolean;
        DifferentPartNo: Boolean;
    begin
        PurchInvImportBuf.RESET;
        PurchInvImportBuf.SETRANGE("Document Type", PurchInvImportBuf."Document Type"::"Purch. Header");
        IF PurchInvImportBuf.COUNT > 1 THEN BEGIN
            COMMIT;
            IF PAGE.RUNMODAL(PAGE::"Purch. Invoice Import Buffer", PurchInvImportBuf) = ACTION::LookupOK THEN
                PurchInvImportBuf.SETRANGE("Invoice No.", PurchInvImportBuf."Invoice No.")
            ELSE
                ERROR(Text002);
        END;

        PurchaseHeader(PurchHdr, PurchLine2, PurchLine3, DocumentNo);

        //PurchInvImportBuf.RESET;
        PurchInvImportBuf.SETRANGE("Document Type", PurchInvImportBuf."Document Type"::"Purch. Line");
        IF PurchInvImportBuf.FINDFIRST THEN BEGIN
            IF PurchHdr."Vendor Invoice No." = '' THEN BEGIN
                PurchHdr."Vendor Invoice No." := PurchInvImportBuf."Invoice No.";
                PurchHdr.MODIFY;
            END;
            REPEAT
                SortNo := '';
                SortNo := PurchInvImportBuf."DeliveredPart No.";
                DifferentPartNo := FALSE;
                IF (PurchInvImportBuf."DeliveredPart No." <> PurchInvImportBuf."Odered Part No.") THEN
                    DifferentPartNo := TRUE;
                ChangeItemNo(PurchInvImportBuf."DeliveredPart No.");
                TotalTransfer := 0;
                PurchLine.RESET;
                PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                PurchLine.SETFILTER("Document No.", '<>%1', PurchHdr."No.");
                PurchLine.SETCURRENTKEY(Type, "No.");
                PurchLine.SETRANGE(Type, PurchLine.Type::Item);
                PurchLine.SETRANGE("No.", PurchInvImportBuf."DeliveredPart No.");
                PurchLine.SETRANGE("Vendor Order No.", PurchInvImportBuf."Order No.");
                LineCount := PurchLine.COUNT;
                WhichLine := 0;
                UnitPrice := PurchInvImportBuf."Unit Price";
                IF PurchLine.FINDFIRST AND NOT DifferentPartNo THEN
                    REPEAT
                        PurchLine.TESTFIELD("Document Type");
                        PurchLine.TESTFIELD("Document No.");
                        PurchLine.TESTFIELD("Quantity Received", 0);
                        PurchLine.TESTFIELD("Buy-from Vendor No.", PurchLine3."Buy-from Vendor No.");
                        PurchLine.TESTFIELD("Pay-to Vendor No.", PurchLine3."Pay-to Vendor No.");
                        WhichLine += 1;
                        LastOne := TRUE;
                        PartialTransfer := FALSE;
                        QtyToTransfer := TotalTransfer;
                        IF QtyToTransfer = 0 THEN
                            QtyToTransfer := PurchInvImportBuf."Invoiced Quantity";
                        IF ((PurchLine.Quantity < QtyToTransfer) AND (LineCount > 1) AND (LineCount <> WhichLine)) THEN BEGIN
                            TotalTransfer := QtyToTransfer - PurchLine.Quantity;
                            QtyToTransfer := PurchLine.Quantity;
                            LastOne := FALSE;
                        END;
                        IF PurchLine.Quantity > QtyToTransfer THEN
                            PartialTransfer := TRUE;

                        IF Preview THEN
                            PreviewLine(DataBuffer, PurchLine, QtyToTransfer, EntryNo, PurchInvImportBuf."Odered Part No.")
                        ELSE
                            MovePurchLine(PurchHdr, PurchLine, PurchLine2, PurchLine3, QtyToTransfer,
                                          PurchInvImportBuf."Unit Price", PartialTransfer);

                    UNTIL (PurchLine.NEXT = 0) OR LastOne
                ELSE BEGIN
                    IF NOT Preview THEN BEGIN
                        PartialTransfer := FALSE;
                        CheckItem(PurchInvImportBuf."DeliveredPart No.");
                        QtyToTransfer := PurchInvImportBuf."Invoiced Quantity";
                        PurchLine3.VALIDATE(Type, PurchLine3.Type::Item);
                        PurchLine3.VALIDATE("No.", PurchInvImportBuf."DeliveredPart No.");
                        //PurchLine3."Vendor Invoice No." := PurchInvImportBuf."Invoice No.";
                        PurchLine3."Vendor Order No." := PurchInvImportBuf."Order No.";
                        LineNo := PurchaseLine2(PurchLine, PurchLine2, PurchLine3,
                                             QtyToTransfer, PartialTransfer, PurchHdr, UnitPrice);
                    END ELSE BEGIN
                        PurchLine.INIT;
                        PurchLine."Document Type" := PurchHdr."Document Type";
                        PurchLine."Document No." := DocumentNo;
                        PurchLine."Line No." := 0;
                        PurchLine.Type := PurchLine.Type::Item;
                        PurchLine."No." := PurchInvImportBuf."DeliveredPart No.";
                        PurchLine.Quantity := PurchInvImportBuf."Invoiced Quantity";
                        PreviewLine(DataBuffer, PurchLine, PurchInvImportBuf."Invoiced Quantity", EntryNo,
                                     PurchInvImportBuf."Odered Part No.");
                    END;
                END;
            UNTIL PurchInvImportBuf.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure PurchaseHeader(var PurchHdr: Record "38"; var PurchLine: Record "39"; var PurchLine2: Record "39"; PurchOrderNo: Code[20])
    begin
        PurchHdr.RESET;
        IF NOT PurchHdr.GET(PurchHdr."Document Type"::Order, PurchOrderNo) THEN
            ERROR(EDMS001);

        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchHdr."Document Type");
        PurchLine.SETRANGE("Document No.", PurchOrderNo);
        IF NOT PurchLine.FINDFIRST THEN BEGIN
            PurchLine.INIT;
            PurchLine."Document Type" := PurchHdr."Document Type";
            PurchLine."Document No." := PurchOrderNo;
            PurchLine."Buy-from Vendor No." := PurchHdr."Buy-from Vendor No.";
            PurchLine."Pay-to Vendor No." := PurchHdr."Pay-to Vendor No.";
        END;

        PurchLine2.TRANSFERFIELDS(PurchLine);
    end;

    [Scope('Internal')]
    procedure PurchaseLine(PurchLine: Record "39"; var PurchLine2: Record "39"; PurchLine3: Record "39"; QtyToTransfer: Integer; PartialTransfer: Boolean): Integer
    var
        Item: Record "27";
        ItemPriceGroup: Record "25006754";
        DiscountPercent: Decimal;
        LineNo: Integer;
    begin
        LineNo := 0;
        PurchLine2.SETRANGE("Document Type", PurchLine2."Document Type");
        PurchLine2.SETRANGE("Document No.", PurchLine2."Document No.");
        IF PurchLine2.FINDLAST THEN
            LineNo := PurchLine2."Line No.";

        LineNo := LineNo + 10000;

        DiscountPercent := PurchLine."Line Discount %";
        Item.GET(PurchLine2."No.");
        ItemPriceGroup.SETRANGE(Code, Item."Item Price Group Code");
        IF ItemPriceGroup.FINDFIRST THEN
            DiscountPercent := ItemPriceGroup."Purchase Discount Percent";

        PurchLine2.INIT;
        PurchLine2.TRANSFERFIELDS(PurchLine);
        PurchLine2."Document Type" := PurchLine3."Document Type";
        PurchLine2."Document No." := PurchLine3."Document No.";
        PurchLine2."Line No." := LineNo;

        IF PartialTransfer THEN BEGIN
            PurchLine2.VALIDATE(Quantity, QtyToTransfer);
            IF DiscountPercent <> 0 THEN
                PurchLine2.VALIDATE("Line Discount %", DiscountPercent);
        END;

        PurchLine2.INSERT;

        EXIT(LineNo);
    end;

    [Scope('Internal')]
    procedure PurchaseLine2(PurchLine: Record "39"; var PurchLine2: Record "39"; PurchLine3: Record "39"; QtyToTransfer: Integer; ClearLine: Boolean; PurchHdr: Record "38"; UnitCost: Decimal): Integer
    var
        Item: Record "27";
        ItemPriceGroup: Record "25006754";
        WMSManagement: Codeunit "7302";
        LineNo: Integer;
        DiscountPercent: Decimal;
    begin
        LineNo := 0;
        PurchLine2.SETRANGE("Document Type", PurchLine2."Document Type");
        PurchLine2.SETRANGE("Document No.", PurchLine2."Document No.");

        IF PurchLine2.FINDLAST THEN
            LineNo := PurchLine2."Line No.";

        IF ClearLine THEN
            Item.GET(PurchLine3."No.")
        ELSE
            Item.GET(PurchLine."No.");
        ItemPriceGroup.SETRANGE(Code, Item."Item Price Group Code");
        IF ItemPriceGroup.FINDFIRST THEN
            DiscountPercent := ItemPriceGroup."Purchase Discount Percent";

        LineNo := LineNo + 10000;
        IF NOT ClearLine THEN BEGIN
            PurchLine2.INIT;
            PurchLine2.TRANSFERFIELDS(PurchLine);
            PurchLine2."Document Type" := PurchLine3."Document Type";
            PurchLine2."Document No." := PurchLine3."Document No.";
            PurchLine2."Line No." := LineNo;
            PurchLine2.VALIDATE(Quantity, QtyToTransfer);
            PurchLine2.VALIDATE("Direct Unit Cost", UnitCost);
            IF DiscountPercent <> 0 THEN
                PurchLine2.VALIDATE("Line Discount %", DiscountPercent);
            PurchLine2.INSERT(TRUE);
        END
        ELSE BEGIN
            PurchLine2.INIT;
            PurchLine2.TRANSFERFIELDS(PurchLine3);
            PurchLine2."Line No." := LineNo;
            PurchLine2.VALIDATE(Quantity, QtyToTransfer);
            PurchLine2.INSERT;
            IF PurchLine2."Location Code" <> PurchHdr."Location Code" THEN
                PurchLine2.VALIDATE("Location Code", PurchHdr."Location Code");
            IF PurchLine2."Bin Code" = '' THEN
                WMSManagement.GetDefaultBin(PurchLine2."No.", PurchLine2."Variant Code",
                                            PurchLine2."Location Code", PurchLine2."Bin Code");
            PurchLine2.VALIDATE("Direct Unit Cost", UnitCost);
            IF DiscountPercent <> 0 THEN
                PurchLine2.VALIDATE("Line Discount %", DiscountPercent);
            PurchLine2.MODIFY(TRUE);
        END;
        EXIT(LineNo);
    end;

    [Scope('Internal')]
    procedure PurchaseLine3(PurchLine: Record "39"; var PurchLine2: Record "39"; PurchLine3: Record "39"; QtyToTransfer: Decimal; UnitPrice: Decimal; Discount: Decimal; ClearLine: Boolean; PurchHdr: Record "38"; LineDescription: Text[30]; LocationCode: Text[30]; BinCode: Text[30]): Integer
    var
        Item: Record "27";
        ItemPriceGroup: Record "25006754";
        BinContent: Record "7302";
        LineNo: Integer;
    begin
        LineNo := 0;
        PurchLine2.SETRANGE("Document Type", PurchLine2."Document Type");
        PurchLine2.SETRANGE("Document No.", PurchLine2."Document No.");
        IF PurchLine2.FINDLAST THEN
            LineNo := PurchLine2."Line No.";

        IF ClearLine THEN
            Item.GET(PurchLine3."No.")
        ELSE
            Item.GET(PurchLine."No.");
        ItemPriceGroup.SETRANGE(Code, Item."Item Price Group Code");
        IF ItemPriceGroup.FINDFIRST THEN
            Discount := ItemPriceGroup."Purchase Discount Percent";

        LineNo := LineNo + 10000;
        IF NOT ClearLine THEN BEGIN
            PurchLine2.INIT;
            PurchLine2.TRANSFERFIELDS(PurchLine);
            PurchLine2."Document Type" := PurchLine3."Document Type";
            PurchLine2."Document No." := PurchLine3."Document No.";
            PurchLine2."Line No." := LineNo;
            IF LocationCode <> '' THEN
                PurchLine2.VALIDATE("Location Code", LocationCode);
            IF BinCode <> '' THEN
                PurchLine2.VALIDATE("Bin Code", BinCode);
            PurchLine2.VALIDATE(Quantity, QtyToTransfer);
            IF UnitPrice <> 0 THEN     // 15.04.2015 EDMS P21
                PurchLine2.VALIDATE("Direct Unit Cost", UnitPrice);
            PurchLine2.VALIDATE("Line Discount %", Discount);
            IF LineDescription <> '' THEN
                PurchLine2.VALIDATE(Description, LineDescription);
            PurchLine2.INSERT(TRUE);
        END
        ELSE BEGIN
            PurchLine2.INIT;
            PurchLine2.TRANSFERFIELDS(PurchLine3);
            PurchLine2."Line No." := LineNo;
            PurchLine2.VALIDATE(Quantity, QtyToTransfer);
            PurchLine2.INSERT(TRUE);
            IF LocationCode <> '' THEN
                PurchLine2.VALIDATE("Location Code", LocationCode)
            ELSE
                PurchLine2.VALIDATE("Location Code", PurchHdr."Location Code");
            IF BinCode <> '' THEN
                PurchLine2.VALIDATE("Bin Code", BinCode);
            IF UnitPrice <> 0 THEN     // 15.04.2015 EDMS P21
                PurchLine2.VALIDATE("Direct Unit Cost", UnitPrice);
            PurchLine2.VALIDATE("Line Discount %", Discount);
            IF LineDescription <> '' THEN
                PurchLine2.VALIDATE(Description, LineDescription);
            IF PurchLine2."Bin Code" = '' THEN
                FillBin(PurchLine2);
            PurchLine2."Expected Receipt Date" := PurchLine3."Expected Receipt Date";
            PurchLine2.MODIFY(TRUE);
        END;
        EXIT(LineNo);
    end;

    [Scope('Internal')]
    procedure ReservationTransfer(PurchLine: Record "39"; PurchLine2: Record "39")
    var
        ReservEntry: Record "337";
    begin
        PurchLine.CALCFIELDS("Reserved Quantity");
        IF PurchLine."Reserved Quantity" > 0 THEN BEGIN
            ReservEntry.RESET;
            ReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
            ReservEntry.SETRANGE("Source Subtype", PurchLine."Document Type");
            ReservEntry.SETRANGE("Source ID", PurchLine."Document No.");
            ReservEntry.SETRANGE("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Reservation);
            IF ReservEntry.FINDSET THEN
                REPEAT
                    ChangeReservationSource(ReservEntry."Entry No.", PurchLine2);
                UNTIL ReservEntry.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure ReservationTransferItemChange(PurchLine: Record "39"; ItemNo: Code[20])
    var
        ReservEntry: Record "337";
    begin
        PurchLine.CALCFIELDS("Reserved Quantity");
        IF PurchLine."Reserved Quantity" > 0 THEN BEGIN
            ReservEntry.RESET;
            ReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
            ReservEntry.SETRANGE("Source Subtype", PurchLine."Document Type");
            ReservEntry.SETRANGE("Source ID", PurchLine."Document No.");
            ReservEntry.SETRANGE("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Reservation);
            IF ReservEntry.FINDSET THEN
                REPEAT
                    ChangeReservationSourceItem(ReservEntry."Entry No.", ItemNo, PurchLine."No.", PurchLine);
                UNTIL ReservEntry.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure PartialReservationTransfer(PurchLine: Record "39"; PurchLine2: Record "39"; var QtyToTransfer: Decimal)
    var
        ReservEntry: Record "337";
        QtyToTransferR: Decimal;
    begin
        PurchLine.CALCFIELDS("Reserved Quantity");
        IF PurchLine."Reserved Quantity" > 0 THEN BEGIN
            QtyToTransferR := QtyToTransfer;
            ReservEntry.RESET;
            ReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
            ReservEntry.SETRANGE("Source Subtype", PurchLine."Document Type");
            ReservEntry.SETRANGE("Source ID", PurchLine."Document No.");
            ReservEntry.SETRANGE("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Reservation);
            IF ReservEntry.FINDSET THEN
                REPEAT
                    IF QtyToTransferR <> 0 THEN BEGIN
                        IF ReservEntry.Quantity <= QtyToTransferR THEN BEGIN
                            ChangeReservationSource(ReservEntry."Entry No.", PurchLine2);
                            QtyToTransferR -= ReservEntry.Quantity;
                        END
                        ELSE //recReservEntry.quantity > QtyToTransferR
                         BEGIN
                            SplitReservation(ReservEntry."Entry No.", ReservEntry.Quantity - QtyToTransferR, PurchLine2);
                            QtyToTransferR := 0;
                        END;
                    END;
                UNTIL ReservEntry.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure PartialReservationTransferItem(PurchLine: Record "39"; PurchLineNew: Record "39"; var QtyToTransfer: Decimal)
    var
        ReservEntry: Record "337";
        QtyToTransferR: Decimal;
    begin
        PurchLine.CALCFIELDS("Reserved Quantity");
        IF PurchLine."Reserved Quantity" > 0 THEN BEGIN
            QtyToTransferR := QtyToTransfer;
            ReservEntry.RESET;
            ReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
            ReservEntry.SETRANGE("Source Subtype", PurchLine."Document Type");
            ReservEntry.SETRANGE("Source ID", PurchLine."Document No.");
            ReservEntry.SETRANGE("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SETRANGE("Reservation Status", ReservEntry."Reservation Status"::Reservation);
            IF ReservEntry.FINDSET THEN
                REPEAT
                    IF QtyToTransferR <> 0 THEN BEGIN
                        IF ReservEntry.Quantity <= QtyToTransferR THEN BEGIN
                            ChangeReservationSourceItem(ReservEntry."Entry No.", PurchLineNew."No.", PurchLine."No.", PurchLineNew);
                            QtyToTransferR -= ReservEntry.Quantity;
                        END
                        ELSE //recReservEntry.quantity > QtyToTransferR
                         BEGIN
                            SplitReservationItemChange(ReservEntry."Entry No.", PurchLine.Quantity - QtyToTransferR, PurchLineNew);
                            QtyToTransferR := 0;
                        END;
                    END;
                UNTIL ReservEntry.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeReservationSource(ResEntryNo: Integer; PurchLine: Record "39")
    var
        ReservEntry: Record "337";
    begin
        ReservEntry.RESET;
        ReservEntry.GET(ResEntryNo, TRUE);
        ReservEntry."Source Subtype" := PurchLine."Document Type";
        ReservEntry."Source ID" := PurchLine."Document No.";
        ReservEntry."Source Ref. No." := PurchLine."Line No.";
        ReservEntry.MODIFY;
    end;

    [Scope('Internal')]
    procedure ChangeReservationSourceItem(ResEntryNo: Integer; NewItemNo: Code[20]; ItemNo: Code[20]; PurchLine: Record "39")
    var
        ReservEntry: Record "337";
        ReservEntry2: Record "337" temporary;
        ReservEntry3: Record "337";
        SalesLine: Record "37";
        VendorOrderNo: Text[30];
        BaseQty: Integer;
    begin
        VendorOrderNo := PurchLine."Vendor Order No.";
        CheckReservationEntries(ResEntryNo);

        ReservEntry.GET(ResEntryNo, TRUE);
        ReservEntry.VALIDATE("Item No.", NewItemNo);
        BaseQty := ReservEntry."Quantity (Base)";
        ReservEntry.VALIDATE("Quantity (Base)", 0);
        ReservEntry.MODIFY;

        PurchLine.VALIDATE("No.", NewItemNo);
        PurchLine.VALIDATE("Vendor Order No.", VendorOrderNo);
        PurchLine.MODIFY;

        ReservEntry.VALIDATE("Quantity (Base)", BaseQty);
        ReservEntry.MODIFY;

        IF ReservEntry.GET(ResEntryNo, FALSE) THEN BEGIN
            ReservEntry.VALIDATE("Item No.", NewItemNo);
            ReservEntry2.TRANSFERFIELDS(ReservEntry);
            ReservEntry.DELETE;

            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
            SalesLine.SETRANGE("Document No.", ReservEntry."Source ID");
            SalesLine.SETRANGE(Type, SalesLine.Type::Item);
            SalesLine.SETRANGE("No.", ItemNo);
            //SalesLine.SETRANGE(Quantity, ABS(ReservEntry."Quantity (Base)"));
            IF SalesLine.FINDFIRST THEN BEGIN
                SalesLine.VALIDATE("No.", NewItemNo);
                SalesLine.MODIFY;
            END;
            ReservEntry.TRANSFERFIELDS(ReservEntry2);
            ReservEntry.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure CheckReservationEntries(ResEntryNo: Integer)
    var
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
        ReservEntry3: Record "337";
        SalesLine: Record "37";
        SalesLineNew: Record "37";
        ExistQty: Integer;
        SalesLineNo: Integer;
    begin
        ExistQty := 0;
        ReservEntry.RESET;
        IF ReservEntry.GET(ResEntryNo, FALSE) THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
            SalesLine.SETRANGE("Document No.", ReservEntry."Source ID");
            IF SalesLine.FINDLAST THEN
                SalesLineNo := SalesLine."Line No." + 10000
            ELSE
                SalesLineNo := 10000;

            ReservEntry2.RESET;
            ReservEntry2.SETRANGE("Item No.", ReservEntry."Item No.");
            ReservEntry2.SETRANGE("Location Code", ReservEntry."Location Code");
            ReservEntry2.SETRANGE("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
            ReservEntry2.SETRANGE("Source ID", ReservEntry."Source ID");
            ReservEntry2.SETRANGE("Source Ref. No.", ReservEntry."Source Ref. No.");
            ReservEntry2.SETFILTER("Entry No.", '<>%1', ReservEntry."Entry No.");
            IF ReservEntry2.FINDFIRST THEN
                REPEAT
                    ReservEntry3.RESET;
                    ReservEntry3.GET(ReservEntry2."Entry No.", TRUE);
                    ExistQty += ReservEntry3."Quantity (Base)";
                    ReservEntry2."Source Ref. No." := SalesLineNo;
                    ReservEntry2.MODIFY;
                // END;
                UNTIL ReservEntry2.NEXT = 0;
        END;

        IF ExistQty = 0 THEN
            EXIT;
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Document No.", ReservEntry."Source ID");
        SalesLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
        IF SalesLine.FINDFIRST THEN BEGIN
            SalesLineNew.INIT;
            SalesLineNew.TRANSFERFIELDS(SalesLine);
            SalesLineNew.VALIDATE("Line No.", SalesLineNo);
            SalesLineNew.VALIDATE(Quantity, ExistQty);
            SalesLineNew.INSERT(TRUE);
            //  DimensionChangeSalesLine(SalesLine, SalesLineNo);//30.10.2012 EDMS
            SalesLine.VALIDATE(Quantity, SalesLine.Quantity - ExistQty);
            SalesLine.MODIFY(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure SplitReservation(ResEntryNo: Integer; QtyToLeave: Decimal; PurchLine: Record "39")
    var
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
        ReservEntry3: Record "337";
        NewEntryNo: Integer;
    begin
        ReservEntry.LOCKTABLE;
        ReservEntry.RESET;
        ReservEntry.FINDLAST;
        NewEntryNo := ReservEntry."Entry No." + 1;

        ReservEntry2.RESET;
        ReservEntry2.SETRANGE("Entry No.", ResEntryNo);
        IF ReservEntry2.FINDFIRST THEN
            REPEAT
                ReservEntry3.INIT;
                ReservEntry3.TRANSFERFIELDS(ReservEntry2);
                ReservEntry3."Entry No." := NewEntryNo;

                IF ReservEntry2.Positive THEN BEGIN
                    ReservEntry3."Source Subtype" := PurchLine."Document Type";
                    ReservEntry3."Source ID" := PurchLine."Document No.";
                    ReservEntry3."Source Ref. No." := PurchLine."Line No.";

                    ReservEntry3."Quantity (Base)" := ReservEntry3."Quantity (Base)" - QtyToLeave;
                    ReservEntry3.Quantity := ReservEntry3.Quantity - QtyToLeave;
                    ReservEntry3."Qty. to Handle (Base)" := ReservEntry3."Qty. to Handle (Base)" - QtyToLeave;
                    ReservEntry3."Qty. to Invoice (Base)" := ReservEntry3."Qty. to Invoice (Base)" - QtyToLeave;

                    ReservEntry2."Quantity (Base)" := QtyToLeave;
                    ReservEntry2.Quantity := QtyToLeave;
                    ReservEntry2."Qty. to Handle (Base)" := QtyToLeave;
                    ReservEntry2."Qty. to Invoice (Base)" := QtyToLeave;
                    ReservEntry2.MODIFY;
                END
                ELSE BEGIN
                    ReservEntry3."Quantity (Base)" := ReservEntry3."Quantity (Base)" + QtyToLeave;
                    ReservEntry3.Quantity := ReservEntry3.Quantity + QtyToLeave;
                    ReservEntry3."Qty. to Handle (Base)" := ReservEntry3."Qty. to Handle (Base)" + QtyToLeave;
                    ReservEntry3."Qty. to Invoice (Base)" := ReservEntry3."Qty. to Invoice (Base)" + QtyToLeave;

                    ReservEntry2."Quantity (Base)" := -QtyToLeave;
                    ReservEntry2.Quantity := -QtyToLeave;
                    ReservEntry2."Qty. to Handle (Base)" := -QtyToLeave;
                    ReservEntry2."Qty. to Invoice (Base)" := -QtyToLeave;
                    ReservEntry2.MODIFY;

                END;
                ReservEntry3.INSERT;
            UNTIL ReservEntry2.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SplitReservationItemChange(ResEntryNo: Integer; QtyToLeave: Decimal; PurchLine: Record "39")
    var
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
        ReservEntry3: Record "337";
        SalesLine: Record "37";
        NewSalesLine: Record "37";
        StartQty: Decimal;
        NewEntryNo: Integer;
        SalesLineNo: Integer;
    begin
        CheckReservationEntries(ResEntryNo);

        ReservEntry.LOCKTABLE;
        ReservEntry.RESET;
        ReservEntry.FINDLAST;
        NewEntryNo := ReservEntry."Entry No." + 1;

        ReservEntry2.RESET;
        ReservEntry2.SETRANGE("Entry No.", ResEntryNo);
        IF ReservEntry2.FINDFIRST THEN BEGIN
            StartQty := ABS(ReservEntry2."Quantity (Base)");
            REPEAT
                ReservEntry3.INIT;
                ReservEntry3.TRANSFERFIELDS(ReservEntry2);
                ReservEntry3."Entry No." := NewEntryNo;
                ReservEntry3."Item No." := PurchLine."No.";

                IF ReservEntry2.Positive THEN BEGIN
                    ReservEntry3."Source Ref. No." := PurchLine."Line No.";
                    ReservEntry3."Quantity (Base)" := StartQty - QtyToLeave;
                    ReservEntry3.Quantity := StartQty - QtyToLeave;
                    ReservEntry3."Qty. to Handle (Base)" := StartQty - QtyToLeave;
                    ReservEntry3."Qty. to Invoice (Base)" := StartQty - QtyToLeave;

                    ReservEntry2."Quantity (Base)" := QtyToLeave;
                    ReservEntry2.Quantity := QtyToLeave;
                    ReservEntry2."Qty. to Handle (Base)" := QtyToLeave;
                    ReservEntry2."Qty. to Invoice (Base)" := QtyToLeave;
                    ReservEntry2.MODIFY;
                END
                ELSE BEGIN
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
                    SalesLine.SETRANGE("Document No.", ReservEntry2."Source ID");
                    IF SalesLine.FINDLAST THEN
                        SalesLineNo := SalesLine."Line No."
                    ELSE
                        SalesLineNo := 0;
                    SalesLine.SETRANGE(Type, SalesLine.Type::Item);
                    SalesLine.SETRANGE("No.", ReservEntry2."Item No.");
                    SalesLine.SETRANGE(Quantity, ABS(ReservEntry2."Quantity (Base)"));
                    IF SalesLine.FINDFIRST THEN BEGIN
                        SalesLineNo += 10000;
                        NewSalesLine.TRANSFERFIELDS(SalesLine);
                        NewSalesLine."Line No." := SalesLineNo;
                        NewSalesLine.VALIDATE("No.", PurchLine."No.");
                        NewSalesLine.VALIDATE(Quantity, SalesLine.Quantity - QtyToLeave);
                        NewSalesLine.INSERT(TRUE);

                        SalesLine.VALIDATE(Quantity, QtyToLeave);
                        SalesLine.MODIFY(TRUE);
                    END;
                    ReservEntry3."Source Ref. No." := SalesLineNo;
                    ReservEntry3."Quantity (Base)" := ReservEntry3."Quantity (Base)" + QtyToLeave;
                    ReservEntry3.Quantity := ReservEntry3.Quantity + QtyToLeave;
                    ReservEntry3."Qty. to Handle (Base)" := ReservEntry3."Qty. to Handle (Base)" + QtyToLeave;
                    ReservEntry3."Qty. to Invoice (Base)" := ReservEntry3."Qty. to Invoice (Base)" + QtyToLeave;

                    ReservEntry2."Quantity (Base)" := -QtyToLeave;
                    ReservEntry2.Quantity := -QtyToLeave;
                    ReservEntry2."Qty. to Handle (Base)" := -QtyToLeave;
                    ReservEntry2."Qty. to Invoice (Base)" := -QtyToLeave;
                    ReservEntry2.MODIFY;
                END;
                ReservEntry3.INSERT;
            UNTIL ReservEntry2.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure FillBin(var PurchaseLine: Record "39")
    var
        BinContent: Record "7302";
    begin
        BinContent.RESET;
        BinContent.SETCURRENTKEY("Item No.");
        BinContent.SETRANGE("Item No.", PurchaseLine."No.");
        BinContent.SETRANGE("Location Code", PurchaseLine."Location Code");
        IF NOT BinContent.FINDFIRST THEN
            EXIT;

        BinContent.SETRANGE(Default, TRUE);
        IF BinContent.FINDFIRST THEN BEGIN
            PurchaseLine.VALIDATE("Bin Code", BinContent."Bin Code");
            EXIT;
        END;

        BinContent.SETRANGE(Default);
        IF BinContent.FINDFIRST THEN
            PurchaseLine.VALIDATE("Bin Code", BinContent."Bin Code");
    end;

    [Scope('Internal')]
    procedure PreviewLine(var DataBuffer: Record "25006004"; PurchLine: Record "39"; QtyToTransfer: Decimal; var EntryNo: Integer; OderedSortNo: Code[25])
    begin
        EntryNo += 1;
        DataBuffer.INIT;
        DataBuffer."Entry No." := EntryNo;
        DataBuffer."Text Field 1" := FORMAT(PurchLine."Document Type");
        DataBuffer."Code Field 1" := PurchLine."Document No.";
        DataBuffer."Code Field 2" := FORMAT(PurchLine."Line No.");
        DataBuffer."Text Field 2" := PurchLine."No.";
        DataBuffer."Text Field 3" := PurchLine.Description;
        DataBuffer."Text Field 4" := SortNo;
        DataBuffer."Text Field 5" := OderedSortNo;
        ChangeItemNo(OderedSortNo);
        DataBuffer."Text Field 6" := OderedSortNo;
        DataBuffer."Decimal Field 1" := PurchLine.Quantity;
        DataBuffer."Decimal Field 2" := PurchLine.Quantity - QtyToTransfer;
        DataBuffer."Decimal Field 3" := QtyToTransfer;
        DataBuffer.INSERT;
    end;

    [Scope('Internal')]
    procedure CheckItem(var ItemCode: Code[25])
    var
        Item: Record "27";
        NonstockItem: Record "5718";
        NonstockItemEntryRef: Record "25006065";
        NonstockItemMgt: Codeunit "5703";
    begin
        IF Item.GET(ItemCode) THEN
            EXIT;

        IF NOT NonstockItem.GET(COPYSTR(ItemCode, 1, 20)) THEN BEGIN
            NonstockItem.SETCURRENTKEY("Vendor Item No.");
            NonstockItem.SETRANGE("Vendor Item No.", ItemCode);
            IF NOT NonstockItem.FINDFIRST THEN
                ERROR(STRSUBSTNO(Text001, ItemCode));
        END;

        IF NonstockItem."Item No." <> '' THEN BEGIN
            ItemCode := NonstockItem."Item No.";
            EXIT;
        END;

        NonstockItemMgt.NonstockAutoItem(NonstockItem);

        NonstockItem.GET(NonstockItem."Entry No.");
        ItemCode := NonstockItem."Item No.";
    end;

    [Scope('Internal')]
    procedure ChangeItemNo(var ItemCode: Code[25])
    var
        Item: Record "27";
        NonstockItem: Record "5718";
        NonstockItemEntryRef: Record "25006065";
        NonstockItemMgt: Codeunit "5703";
    begin
        NonstockItemEntryRef.RESET;
        NonstockItemEntryRef.GET(ItemCode);

        ItemCode := NonstockItemEntryRef."Entry Format Item No.";

        IF Item.GET(ItemCode) THEN
            EXIT;

        Item.SETCURRENTKEY("Vendor Item No.");
        Item.SETRANGE("Vendor Item No.", ItemCode);
        IF Item.FINDFIRST THEN BEGIN
            ItemCode := Item."No.";
            EXIT;
        END;

        IF NOT NonstockItem.GET(COPYSTR(ItemCode, 1, 20)) THEN BEGIN
            NonstockItem.SETCURRENTKEY("Vendor Item No.");
            NonstockItem.SETRANGE("Vendor Item No.", ItemCode);
            IF NonstockItem.FINDFIRST THEN;
        END;

        IF NonstockItem."Item No." <> '' THEN BEGIN
            ItemCode := NonstockItem."Item No.";
            EXIT;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeLines(PurchInvImportBuf: Record "25006756"; PurchLine3: Record "39")
    var
        PurchLine: Record "39";
        PurchLine2: Record "39";
        PurchLineNew: Record "39";
        QtyToTransfer: Decimal;
        totalTransfer: Decimal;
        PurchLineNo: Integer;
        PartialTransfer: Boolean;
        LastOne: Boolean;
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SETCURRENTKEY(Type, "No.");
        PurchLine.SETRANGE(Type, PurchLine.Type::Item);
        PurchLine.SETRANGE("No.", PurchInvImportBuf."Odered Part No.");
        IF PurchLine.FINDFIRST THEN
            REPEAT
                CheckItem(PurchInvImportBuf."DeliveredPart No.");
                PurchLine.TESTFIELD("Document Type");
                PurchLine.TESTFIELD("Document No.");
                PurchLine.TESTFIELD("Quantity Received", 0);
                PurchLine.TESTFIELD("Buy-from Vendor No.", PurchLine3."Buy-from Vendor No.");
                PurchLine.TESTFIELD("Pay-to Vendor No.", PurchLine3."Pay-to Vendor No.");

                PurchLine2.RESET;
                PurchLine2.SETRANGE("Document Type", PurchLine."Document Type");
                PurchLine2.SETRANGE("Document No.", PurchLine."Document No.");
                IF PurchLine2.FINDLAST THEN
                    PurchLineNo := PurchLine2."Line No."
                ELSE
                    PurchLineNo := 0;

                PartialTransfer := FALSE;
                QtyToTransfer := totalTransfer;
                LastOne := TRUE;
                IF QtyToTransfer = 0 THEN
                    QtyToTransfer := PurchInvImportBuf."Invoiced Quantity";
                IF (PurchLine.Quantity < QtyToTransfer) THEN BEGIN
                    totalTransfer := QtyToTransfer - PurchLine.Quantity;
                    QtyToTransfer := PurchLine.Quantity;
                    LastOne := FALSE;
                END;
                IF PurchLine.Quantity > QtyToTransfer THEN
                    PartialTransfer := TRUE;

                IF PartialTransfer THEN BEGIN
                    PurchLineNo += 10000;
                    PurchLineNew.INIT;
                    PurchLineNew.TRANSFERFIELDS(PurchLine);
                    PurchLineNew."Line No." := PurchLineNo;
                    PurchLineNew.VALIDATE("No.", PurchInvImportBuf."DeliveredPart No.");
                    PurchLineNew.VALIDATE(Quantity, QtyToTransfer);
                    PurchLineNew.INSERT(TRUE);
                    //      DimensionChangeItemChange(PurchLine, PurchLineNo);//30.10.2012 EDMS
                END;

                IF PartialTransfer THEN
                    PartialReservationTransferItem(PurchLine, PurchLineNew, QtyToTransfer)
                ELSE
                    ReservationTransferItemChange(PurchLine, PurchInvImportBuf."DeliveredPart No.");

                IF PartialTransfer THEN BEGIN
                    PurchLine.VALIDATE(Quantity, PurchLine.Quantity - QtyToTransfer);
                    PurchLine.MODIFY(TRUE);
                END;

            UNTIL (PurchLine.NEXT = 0) OR LastOne;
    end;

    [Scope('Internal')]
    procedure MovePurchLine(PurchHdr: Record "38"; PurchLine: Record "39"; PurchLine2: Record "39"; PurchLine3: Record "39"; QtyToTransfer: Decimal; UnitPrice: Decimal; PartialTransfer: Boolean)
    var
        LineNo: Integer;
    begin
        LineNo := PurchaseLine2(PurchLine, PurchLine2, PurchLine3, QtyToTransfer,
                                PartialTransfer, PurchHdr, UnitPrice);
        IF PartialTransfer THEN
            PartialReservationTransfer(PurchLine, PurchLine2, QtyToTransfer)
        ELSE
            ReservationTransfer(PurchLine, PurchLine2);

        //DimensionChange(PurchLine, PurchLine3, LineNo, PartialTransfer);//30.10.2012 EDMS
        IF PartialTransfer THEN BEGIN
            PurchLine.VALIDATE(Quantity, PurchLine.Quantity - QtyToTransfer);
            PurchLine.MODIFY(TRUE);
        END
        ELSE
            PurchLine.DELETE(TRUE);
    end;

    [Scope('Internal')]
    procedure DimensionChange(PurchLinePar: Record "39"; var PurchLine3Par: Record "39"; LineNoPar: Integer)
    begin
        // 23.04.2013 Elva Baltic P15
        IF PurchLine3Par.GET(PurchLine3Par."Document Type", PurchLine3Par."Document No.", LineNoPar) THEN   //just in case - to set the cursor correctly
            PurchLine3Par."Dimension Set ID" := PurchLinePar."Dimension Set ID";
    end;
}

