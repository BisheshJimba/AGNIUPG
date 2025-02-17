codeunit 50006 "QR Mgt."
{
    Permissions = TableData 32 = rm;

    trigger OnRun()
    begin
        //UpdateReservationEntry;
        Updatecheck;
    end;

    var
        ErrAssignedAndLineQtyNotEqual: Label '%1 quantity is not equal to the Assigned Quantity. \Purchase Qty = %2\Assigned Qty = %3.';
        HideValidationDialog: Boolean;

    local procedure BuildLotNo(var QRSpecification: Record "33019974" temporary): Code[20]
    var
        IRDMgt: Codeunit "50000";
        TotalStringLength: Integer;
        UniqueID: Text;
        Slash: Label '/';
        Dash: Label '-';
    begin
        TotalStringLength := MAXSTRLEN(QRSpecification."Lot No.");
        UniqueID := CREATEGUID;
        UniqueID := DELCHR(UniqueID, '=', '{}-');
        UniqueID := COPYSTR(UniqueID, 1, 12);
        UniqueID := IRDMgt.GetNepaliFiscalYear(TODAY) + Dash + UniqueID;
        UniqueID := COPYSTR(UniqueID, 1, TotalStringLength);
        EXIT(UniqueID);
    end;

    [Scope('Internal')]
    procedure BuildQRSpecifications(SourceType: Integer; SourceSubType: Option; SourceID: Code[20]; SourceRefNo: Integer; ItemNo: Code[20]; UnitOfMeasure: Code[10]; QtyPerUOM: Decimal; LocationCode: Code[10]; Date: Date; LotNo: Code[20]; var QRSpecification: Record "33019974" temporary)
    var
        Item: Record "27";
    begin
        QRSpecification."Source Type" := SourceType;
        QRSpecification."Source Subtype" := SourceSubType;
        QRSpecification."Source Ref No." := SourceRefNo;
        QRSpecification."Source ID" := SourceID;
        QRSpecification."Item No." := ItemNo;
        Item.GET(ItemNo);
        Item.TESTFIELD("Item Tracking Code");
        QRSpecification."Supplier Code" := Item."Supplier Code";
        QRSpecification."Unit of Measure" := UnitOfMeasure;
        QRSpecification."Qty. per Unit Of Measure" := QtyPerUOM;
        QRSpecification."Location Code" := LocationCode;
        QRSpecification."Expected Receipt Date" := Date;
        QRSpecification."Lot No." := LotNo;
    end;

    [Scope('Internal')]
    procedure GenerateItemTrackingLines(var QRSpecification: Record "33019974" temporary)
    var
        InventorySetup: Record "313";
        CreateReservEntry: Codeunit "99000830";
        ReservationEntry: Record "337";
        ReservationMgt: Codeunit "99000845";
        NoSeriesMgt: Codeunit "396";
        TotalNoOfLot: Integer;
        LotNo: Code[20];
    begin
        TestQuantity(QRSpecification);
        IF QRSpecification.FINDFIRST THEN BEGIN
            ReservationEntry.RESET;
            ReservationEntry.SETRANGE("Source ID", QRSpecification."Source ID");
            ReservationEntry.SETRANGE("Source Type", QRSpecification."Source Type");
            ReservationEntry.SETRANGE("Source Subtype", QRSpecification."Source Subtype");
            ReservationEntry.SETRANGE("Source Ref. No.", QRSpecification."Source Ref No.");
            IF ReservationEntry.FINDFIRST THEN BEGIN
                ReservationMgt.SetItemTrackingHandling(1);
                ReservationMgt.SetPointerFilter(ReservationEntry);
                ReservationMgt.DeleteReservEntries2(TRUE, 0, ReservationEntry);
            END;
            REPEAT
                QRSpecification."Lot No." := LotNo;
                QRSpecification.MODIFY;
                IF QRSpecification."Qty. Consumed" <> 0 THEN BEGIN
                    TotalNoOfLot := QRSpecification."No. of Stickers";
                    REPEAT
                        CreateReservEntry.SetDates(
                          0D, 0D);
                        CreateReservEntry.CreateReservEntryFor(QRSpecification."Source Type",
                        QRSpecification."Source Subtype",
                        QRSpecification."Source ID", '',
                        0,
                        QRSpecification."Source Ref No.",
                        QRSpecification."Qty. per Unit Of Measure",
                        QRSpecification."Per Sticker Qty",
                        QRSpecification."Per Sticker Qty",
                        '',
                        BuildLotNo(QRSpecification));

                        CreateReservEntry.CreateEntry(QRSpecification."Item No.", '', QRSpecification."Location Code", '',
                        QRSpecification."Expected Receipt Date", 0D, 0,
                        2);
                        TotalNoOfLot -= 1;
                    UNTIL TotalNoOfLot = 0;
                END;

            UNTIL QRSpecification.NEXT = 0;
        END;
    end;

    local procedure TransferLotToParent(var QRSpecification: Record "33019974" temporary)
    var
        PurchaseHeader: Record "38";
    begin
        CASE QRSpecification."Source Type" OF
            DATABASE::"Purchase Line":
                BEGIN
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("Document Type", QRSpecification."Source Subtype");
                    PurchaseHeader.SETRANGE("No.", QRSpecification."Source ID");
                    IF PurchaseHeader.FINDFIRST THEN BEGIN
                        PurchaseHeader."Lot No. Prefix" := QRSpecification."Lot No.";
                        PurchaseHeader.MODIFY(TRUE);
                    END;
                END;
        END;
    end;

    local procedure TestQuantity(var QRSpecification: Record "33019974" temporary)
    var
        PurchaseLine: Record "39";
        LineQty: Decimal;
        AssignedQty: Decimal;
        SpecifiedTable: Text[100];
    begin
        IF QRSpecification.FINDFIRST THEN BEGIN
            CASE QRSpecification."Source Type" OF
                DATABASE::"Purchase Line":
                    BEGIN
                        PurchaseLine.RESET;
                        PurchaseLine.SETRANGE("Document Type", QRSpecification."Source Subtype");
                        PurchaseLine.SETRANGE("Document No.", QRSpecification."Source ID");
                        PurchaseLine.SETRANGE("Line No.", QRSpecification."Source Ref No.");
                        IF PurchaseLine.FINDFIRST THEN BEGIN
                            LineQty := PurchaseLine."Qty. to Receive";
                        END;
                        SpecifiedTable := PurchaseLine.TABLECAPTION;
                    END;
            END;
            REPEAT
                AssignedQty += QRSpecification."Qty. Consumed";
            UNTIL QRSpecification.NEXT = 0;
        END;
        IF AssignedQty <> LineQty THEN BEGIN
            ERROR(ErrAssignedAndLineQtyNotEqual, SpecifiedTable, LineQty, AssignedQty);
        END;
    end;

    [Scope('Internal')]
    procedure GetParentLotNo(SupplierCode: Code[10]; PostingDate: Date; PurchRcptNo: Code[20]) ParentLotNo: Code[30]
    var
        IRDMgt: Codeunit "50000";
    begin
        ParentLotNo := SupplierCode;
        ParentLotNo += '-' + IRDMgt.GetEnglishFiscalYear(PostingDate) + '-' + FORMAT(GetReceiptDigit(PurchRcptNo));
    end;

    local procedure GetReceiptDigit(PurchRcptNo: Code[20]) TrimmedRcptDigit: Integer
    var
        Position: Integer;
        TrimmedRcptCode: Code[20];
    begin
        Position := STRPOS(PurchRcptNo, '-');
        TrimmedRcptCode := COPYSTR(PurchRcptNo, Position + 1, STRLEN(PurchRcptNo));
        IF EVALUATE(TrimmedRcptDigit, TrimmedRcptCode) THEN
            EXIT(TrimmedRcptDigit);
    end;

    [Scope('Internal')]
    procedure GenerateQRCode(ItemNo: Code[20]; PostingDate: Date; PurchRcptNo: Code[20]; LotNo: Code[20]; var QRCode: Code[250]; var ParentLotNo: Code[30]; Qty: Decimal)
    var
        Item: Record "27";
    begin
        IF Item.GET(ItemNo) THEN BEGIN
            Item.TESTFIELD("Supplier Code");
            IF Item."Supplier Code" <> '' THEN BEGIN
                ParentLotNo := GetParentLotNo(Item."Supplier Code", PostingDate, PurchRcptNo);
                QRCode := Item."Supplier Code" + '/' +
                          ItemNo + '/' +
                          ParentLotNo + '|' +
                          LotNo + '/' + FORMAT(Qty);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure GenerateBatchPrintDataset(SupplierCode: Code[10]; ItemNo: Code[20]; PurchRcptNo: Code[20]; var QRSpecification: Record "33019974" temporary)
    var
        ItemLedgerEntry: Record "32";
        UserSetup: Record "91";
        ParentLotList: Query "50000";
        PrintedParentLotList: Query "50000";
        LineNo: Integer;
    begin
        //ParentLotList.SETRANGE(SupplierFilter,SupplierCode);
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");
        ParentLotList.SETRANGE(ItemFilter, ItemNo);
        ParentLotList.SETRANGE(DocumentNoFilter, PurchRcptNo);
        ParentLotList.SETRANGE(LocationFilter, UserSetup."Default Location");
        ParentLotList.OPEN;
        CLEAR(QRSpecification);
        //IF QRSpecification.FINDLAST THEN
        //LineNo := QRSpecification."Line No.";
        QRSpecification.DELETEALL;
        WHILE ParentLotList.READ DO BEGIN
            LineNo += 1;
            QRSpecification.INIT;
            QRSpecification."Item No." := ParentLotList.Item_No;
            QRSpecification."Line No." := LineNo;
            QRSpecification."Parent Lot No." := ParentLotList.Parent_Lot_No;
            QRSpecification.Supplier := ParentLotList.Supplier_Code;
            QRSpecification."Part No." := ParentLotList.Item_No;
            QRSpecification."Purchase Receipt No." := ParentLotList.Document_No;
            QRSpecification."No. of Stickers" := ParentLotList.NoOfSticker;
            QRSpecification."Per Sticker Qty" := ParentLotList.PerStickerQty;
            QRSpecification."Remaining Stock Qty" := ParentLotList.Sum_Remaining_Quantity;
            //PrintedParentLotList.SETRANGE(SupplierFilter,SupplierCode);
            PrintedParentLotList.SETRANGE(ItemFilter, ItemNo);
            PrintedParentLotList.SETRANGE(DocumentNoFilter, PurchRcptNo);
            PrintedParentLotList.SETRANGE(QR_Code_Printed, FALSE);
            PrintedParentLotList.SETRANGE(PerStickerQty, ParentLotList.PerStickerQty);
            PrintedParentLotList.OPEN;
            IF PrintedParentLotList.READ THEN BEGIN
                QRSpecification."No. Of Sticker Available" := PrintedParentLotList.NoOfSticker;
            END;
            QRSpecification.INSERT;

        END;
    end;

    [Scope('Internal')]
    procedure GenerateILEPrintDataset(var ItemLedgEntries: Record "32"; var QRSpecification: Record "33019974" temporary)
    var
        Item: Record "27";
        LineNo: Integer;
    begin
        CLEAR(QRSpecification);
        QRSpecification.DELETEALL;
        //ItemLedgEntries.SETRANGE("QR Code Printed",TRUE);
        IF ItemLedgEntries.FINDSET THEN
            REPEAT
                LineNo += 1;
                ItemLedgEntries.TESTFIELD("Remaining Quantity");
                QRSpecification.INIT;
                IF ItemLedgEntries."QR Code Text" = '' THEN
                    FindQRDetails(ItemLedgEntries, QRSpecification);
                IF ItemLedgEntries."QR Code Text" <> '' THEN BEGIN
                    QRSpecification."Item No." := ItemLedgEntries."Item No.";
                    QRSpecification."Line No." := LineNo;
                    QRSpecification."Parent Lot No." := ItemLedgEntries."Parent Lot No.";
                    Item.GET(ItemLedgEntries."Item No.");
                    QRSpecification.Supplier := Item."Supplier Code";
                    QRSpecification."Part No." := ItemLedgEntries."Item No.";
                    QRSpecification."Purchase Receipt No." := ItemLedgEntries."Document No.";
                    QRSpecification."Item Ledger Entry No." := ItemLedgEntries."Entry No.";
                    QRSpecification."No. of Stickers" := 1;
                    QRSpecification."Per Sticker Qty" := ItemLedgEntries.Quantity;
                    QRSpecification."No. of Sticker Required" := 1;
                    QRSpecification."No. Of Sticker Available" := 1;
                    QRSpecification.INSERT;
                END;
            UNTIL ItemLedgEntries.NEXT = 0L;
    end;

    local procedure FindQRDetails(var ItemLedgerEntry: Record "32"; var QRSpecification: Record "33019974" temporary)
    begin
        GetParentLotNoCode(ItemLedgerEntry."Entry No.", ItemLedgerEntry, QRSpecification);
        ItemLedgerEntry.MODIFY;
    end;

    local procedure GetParentLotNoCode(ItemLedgEntryNo: Integer; var NewItemLedgerEntry: Record "32"; var QRSpecification: Record "33019974" temporary)
    var
        ItemApplicationEntry: Record "339";
        ItemLedgerEntry: Record "32";
        OutboundEntryNo: Integer;
        InboundEntryNo: Integer;
    begin
        ItemApplicationEntry.RESET;
        ItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
        IF ItemApplicationEntry.FINDFIRST THEN BEGIN
            REPEAT
                InboundEntryNo := ItemApplicationEntry."Inbound Item Entry No.";
                OutboundEntryNo := ItemApplicationEntry."Outbound Item Entry No.";
                IF OutboundEntryNo <> 0 THEN BEGIN
                    IF ItemApplicationEntry."Item Ledger Entry No." <> ItemApplicationEntry."Inbound Item Entry No." THEN BEGIN
                        ItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemApplicationEntry."Inbound Item Entry No.");
                    END
                    ELSE
                        IF ItemApplicationEntry."Item Ledger Entry No." <> ItemApplicationEntry."Outbound Item Entry No." THEN BEGIN
                            ItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemApplicationEntry."Outbound Item Entry No.");
                        END;
                END;
                IF NOT ItemApplicationEntry.FINDFIRST THEN BEGIN
                    InboundEntryNo := 0;
                    OutboundEntryNo := 0;
                END;
            UNTIL OutboundEntryNo = 0;
        END;
        IF ItemLedgerEntry.GET(InboundEntryNo) THEN BEGIN
            NewItemLedgerEntry."Parent Lot No." := ItemLedgerEntry."Parent Lot No.";
            GenerateQRCode(ItemLedgerEntry."Item No.", ItemLedgerEntry."Posting Date", ItemLedgerEntry."Document No.", NewItemLedgerEntry."Lot No.",
              NewItemLedgerEntry."QR Code Text", ItemLedgerEntry."Parent Lot No.", ItemLedgerEntry.Quantity);
            QRSpecification."Purchase Receipt No." := ItemLedgerEntry."Document No.";
        END;
    end;

    local procedure GetParentLotNoCodeInVariable(ItemLedgEntryNo: Integer; var ParentLotNo: Code[30]; var PkgNo: Code[20]; var PurchRcptNo: Code[20])
    var
        ItemApplicationEntry: Record "339";
        ItemLedgerEntry: Record "32";
        OutboundEntryNo: Integer;
        InboundEntryNo: Integer;
    begin
        ItemApplicationEntry.RESET;
        ItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
        IF ItemApplicationEntry.FINDFIRST THEN BEGIN
            REPEAT
                InboundEntryNo := ItemApplicationEntry."Inbound Item Entry No.";
                OutboundEntryNo := ItemApplicationEntry."Outbound Item Entry No.";
                IF OutboundEntryNo <> 0 THEN BEGIN
                    IF ItemApplicationEntry."Item Ledger Entry No." <> ItemApplicationEntry."Inbound Item Entry No." THEN BEGIN
                        ItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemApplicationEntry."Inbound Item Entry No.");
                    END
                    ELSE
                        IF ItemApplicationEntry."Item Ledger Entry No." <> ItemApplicationEntry."Outbound Item Entry No." THEN BEGIN
                            ItemApplicationEntry.SETRANGE("Item Ledger Entry No.", ItemApplicationEntry."Outbound Item Entry No.");
                        END;
                END;
                IF NOT ItemApplicationEntry.FINDFIRST THEN BEGIN
                    InboundEntryNo := 0;
                    OutboundEntryNo := 0;
                END;
            UNTIL OutboundEntryNo = 0;
        END;
        IF ItemLedgerEntry.GET(InboundEntryNo) THEN BEGIN
            ParentLotNo := ItemLedgerEntry."Parent Lot No.";
            PkgNo := ItemLedgerEntry."Package No.";
            PurchRcptNo := ItemLedgerEntry."Document No.";
        END;
    end;

    [Scope('Internal')]
    procedure QRBatchPrint(var QRSpecification: Record "33019974" temporary)
    var
        ItemLedgerEntry: Record "32";
        QRPrintMgt: Codeunit "50007";
        NoOfStickersRequired: Integer;
    begin
        QRSpecification.RESET;
        QRSpecification.SETFILTER("No. of Sticker Required", '>%1', 0);
        IF QRSpecification.FINDSET THEN
            REPEAT
                NoOfStickersRequired := QRSpecification."No. of Sticker Required";
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
                ItemLedgerEntry.SETRANGE("Document No.", QRSpecification."Purchase Receipt No.");
                ItemLedgerEntry.SETRANGE("QR Code Printed", FALSE);
                ItemLedgerEntry.SETRANGE(Quantity, QRSpecification."Per Sticker Qty");
                IF ItemLedgerEntry.COUNT < QRSpecification."No. of Sticker Required" THEN
                    ERROR('No. of Remaining Stickers = %1 and No. of Stickers Required = %2. You cannot print %2 stickers if remaining stickers is less than it.',
                        ItemLedgerEntry.COUNT, QRSpecification."No. of Sticker Required");
                IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        QRPrintMgt.RUN(ItemLedgerEntry);
                        ItemLedgerEntry.CALCFIELDS("QR Code Blob");
                        NoOfStickersRequired := NoOfStickersRequired - 1;
                    UNTIL NoOfStickersRequired = 0;
                END;
            UNTIL QRSpecification.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure InsertPackageNo(ReceiptNo: Code[20]; var QRSpecification: Record "33019974" temporary)
    var
        ItemLedgerEntry: Record "32";
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
        IF ReceiptNo <> '' THEN
            ItemLedgerEntry.SETRANGE("Document No.", ReceiptNo);
        ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        ItemLedgerEntry.SETFILTER("Package No.", '<>%1', '');
        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                QRSpecification.RESET;
                QRSpecification.SETRANGE("Code 1", ItemLedgerEntry."Package No.");
                IF NOT QRSpecification.FINDFIRST THEN BEGIN
                    CLEAR(QRSpecification);
                    QRSpecification.INIT;
                    QRSpecification."Line No." := ItemLedgerEntry."Entry No.";
                    QRSpecification."Code 1" := ItemLedgerEntry."Package No.";
                    QRSpecification.INSERT;
                END;
            UNTIL ItemLedgerEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetItemsForQRPrint(ReceiptNo: Code[20]; PkgNo: Code[20]; var QRSpecification: Record "33019974" temporary)
    var
        ItemLedgerEntry: Record "32";
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
        ItemLedgerEntry.SETRANGE("Document No.", ReceiptNo);
        ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        IF PkgNo <> '' THEN
            ItemLedgerEntry.SETRANGE("Package No.", PkgNo);
        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                QRSpecification.RESET;
                QRSpecification.SETRANGE("Code 1", ItemLedgerEntry."Item No.");
                IF NOT QRSpecification.FINDFIRST THEN BEGIN
                    CLEAR(QRSpecification);
                    QRSpecification.INIT;
                    QRSpecification."Line No." := ItemLedgerEntry."Entry No.";
                    QRSpecification."Code 1" := ItemLedgerEntry."Item No.";
                    QRSpecification.INSERT;
                END;
            UNTIL ItemLedgerEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GenerateBatchPrintDatasetFromPurchaseReceipt(SupplierCode: Code[10]; ItemNo: Code[20]; PurchRcptNo: Code[20]; PkgNo: Code[20]; var BatchGenerationGrid: Record "33019974" temporary; var QRSpecification: Record "33019974" temporary)
    var
        ItemLedgerEntry: Record "32";
        UserSetup: Record "91";
        LineNo: Integer;
        Item: Record "27";
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");

        CLEAR(QRSpecification);
        QRSpecification.DELETEALL;

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
        IF PurchRcptNo <> '' THEN
            ItemLedgerEntry.SETRANGE("Document No.", PurchRcptNo);
        IF PurchRcptNo = 'OPENING' THEN
            ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::"Positive Adjmt.")
        ELSE
            ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        IF ItemNo <> '' THEN
            ItemLedgerEntry.SETRANGE("Item No.", ItemNo);
        ItemLedgerEntry.SETRANGE("Location Code", UserSetup."Default Location");
        IF PkgNo <> '' THEN
            ItemLedgerEntry.SETRANGE("Package No.", PkgNo);

        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                IF ItemLedgerEntry.Quantity > 0 THEN BEGIN
                    Item.GET(ItemLedgerEntry."Item No.");
                    LineNo += 1;
                    CLEAR(QRSpecification);
                    QRSpecification.INIT;
                    QRSpecification."Item No." := ItemLedgerEntry."Item No.";
                    QRSpecification."Line No." := ItemLedgerEntry."Entry No.";
                    QRSpecification."Item Ledger Entry No." := ItemLedgerEntry."Entry No.";
                    QRSpecification."Parent Lot No." := ItemLedgerEntry."Parent Lot No.";
                    QRSpecification."Supplier Code" := Item."Supplier Code";
                    QRSpecification."Part No." := ItemLedgerEntry."Item No.";
                    QRSpecification."Purchase Receipt No." := ItemLedgerEntry."Document No.";
                    QRSpecification."Purchase Quantity" := ItemLedgerEntry.Quantity;
                    QRSpecification."Remaining Stock Qty" := ItemLedgerEntry."Remaining Quantity";
                    QRSpecification."Package No." := ItemLedgerEntry."Package No.";
                    QRSpecification."Location Code" := ItemLedgerEntry."Location Code";
                    QRSpecification."Lot No." := ItemLedgerEntry."Lot No.";
                    QRSpecification."Shortcut Dimension 1 Code" := ItemLedgerEntry."Global Dimension 1 Code";
                    QRSpecification."Shortcut Dimension 2 Code" := ItemLedgerEntry."Global Dimension 2 Code";
                    QRSpecification."Dimension Set ID" := ItemLedgerEntry."Dimension Set ID";
                    //IF NOT (ItemLedgerEntry."Document Type" IN [ItemLedgerEntry."Document Type"::"Purchase Receipt",ItemLedgerEntry."Document Type"::" "]) THEN
                    //GetParentLotNoCodeInVariable(ItemLedgerEntry."Entry No.",QRSpecification."Parent Lot No.",QRSpecification."Package No.");
                    BatchGenerationGrid.RESET;
                    QRSpecification."Add Item" := ItemAlreadySelectedInBatchGenerationGrid(BatchGenerationGrid, ItemLedgerEntry."Entry No.");
                    QRSpecification.INSERT;
                END;
            UNTIL ItemLedgerEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GenerateBatchPrintDatasetFromItemRecord(ItemNo: Code[20])
    var
        ItemLedgerEntry: Record "32";
        UserSetup: Record "91";
        ItemLedgerEntries: Page "38";
        LineNo: Integer;
        Item: Record "27";
    begin
        Item.GET(ItemNo);
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Location");

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", "Location Code");
        ItemLedgerEntry.FILTERGROUP(2);
        ItemLedgerEntry.SETRANGE("Item No.", ItemNo);
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        ItemLedgerEntry.SETRANGE("Location Code", UserSetup."Default Location");
        ItemLedgerEntry.SETFILTER("Remaining Quantity", '>%1', 0);
        IF ItemLedgerEntry.FINDSET THEN BEGIN
            CLEAR(ItemLedgerEntries);
            ItemLedgerEntries.SetShowSN;
            ItemLedgerEntries.SETTABLEVIEW(ItemLedgerEntry);
            ItemLedgerEntries.RUN;
            ItemLedgerEntry.FILTERGROUP(0);
        END;
    end;

    [Scope('Internal')]
    procedure QueueQR(var FromQRSpecification: Record "33019974" temporary; var ToQRSpecification: Record "33019974" temporary; Add: Boolean)
    begin
        ToQRSpecification.RESET;
        ToQRSpecification.SETRANGE("Line No.", FromQRSpecification."Line No.");
        IF ToQRSpecification.FINDFIRST THEN
            ToQRSpecification.DELETE;
        IF Add THEN BEGIN
            CLEAR(ToQRSpecification);
            ToQRSpecification.INIT;
            ToQRSpecification.TRANSFERFIELDS(FromQRSpecification);
            ToQRSpecification."No. of Sticker Required" := 0;
            ToQRSpecification."Per Sticker Qty" := 1;
            ToQRSpecification.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure ItemAlreadySelectedInBatchGenerationGrid(var QRSpecification: Record "33019974" temporary; ItemLedgEntryNo: Integer): Boolean
    begin
        QRSpecification.RESET;
        QRSpecification.SETRANGE("Line No.", ItemLedgEntryNo);
        IF QRSpecification.FINDFIRST THEN
            EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure TestNoOfPrint(var QRSpecification: Record "33019974" temporary)
    begin
        IF "No. of Sticker Required" * QRSpecification."Per Sticker Qty" > "Remaining Stock Qty" THEN
            ERROR('Remaining Stock Qty = %1.\Adjust the No. of Print and Per Sticker Qty accordingly.', "Remaining Stock Qty");
    end;

    [Scope('Internal')]
    procedure PostPrintItemReclassification(var QRSpecification: Record "33019974" temporary; var PrintQRSpecification: Record "33019974" temporary)
    var
        ItemJournalLine: Record "83";
        ItemJnlTemplate: Record "82";
        ItemJnlPostLine: Codeunit "22";
        LineNo: Integer;
        ReservationEntry: Record "337";
        NoOfStickersRequired: Integer;
        ReservationEntryNo: Integer;
        TempItemEntryRelation: Record "6507" temporary;
        InvtSetup: Record "313";
    begin
        InvtSetup.GET;
        InvtSetup.TESTFIELD("QR Item Reclass Jnl. Template");
        InvtSetup.TESTFIELD("QR Item Reclass Jnl. Batch");
        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", InvtSetup."QR Item Reclass Jnl. Template");
        ItemJournalLine.SETRANGE("Journal Batch Name", InvtSetup."QR Item Reclass Jnl. Batch");
        ItemJournalLine.SETFILTER("Item No.", '<>%1', '');
        IF ItemJournalLine.FINDFIRST THEN
            ERROR('Item Journal Line for Template %1 and Batch %2 already exists.', InvtSetup."QR Item Reclass Jnl. Template", InvtSetup."QR Item Reclass Jnl. Batch");

        QRSpecification.RESET;
        IF QRSpecification.FINDSET THEN
            REPEAT
                NoOfStickersRequired := QRSpecification."No. of Sticker Required";
                IF NoOfStickersRequired > 0 THEN BEGIN
                    REPEAT
                        CLEAR(ItemJournalLine);
                        ItemJournalLine.INIT;
                        ItemJournalLine."Journal Template Name" := InvtSetup."QR Item Reclass Jnl. Template";
                        ItemJournalLine."Journal Batch Name" := InvtSetup."QR Item Reclass Jnl. Batch";
                        ItemJournalLine."Entry Type" := ItemJournalLine."Entry Type"::Transfer;
                        ItemJournalLine."Document No." := QRSpecification."Purchase Receipt No.";
                        ItemJournalLine."Line No." := LineNo + 10000;
                        ItemJournalLine."Source Code" := ItemJnlTemplate."Source Code";
                        ItemJournalLine.VALIDATE("Item No.", QRSpecification."Item No.");
                        ItemJournalLine.VALIDATE("Posting Date", TODAY);
                        ItemJournalLine.VALIDATE("Location Code", QRSpecification."Location Code");
                        ItemJournalLine.VALIDATE(Quantity, QRSpecification."Per Sticker Qty");
                        ItemJournalLine."Shortcut Dimension 1 Code" := QRSpecification."Shortcut Dimension 1 Code";
                        ItemJournalLine."Shortcut Dimension 2 Code" := QRSpecification."Shortcut Dimension 2 Code";
                        ItemJournalLine."Dimension Set ID" := QRSpecification."Dimension Set ID";
                        ItemJournalLine."New Shortcut Dimension 1 Code" := QRSpecification."Shortcut Dimension 1 Code";
                        ItemJournalLine."New Shortcut Dimension 2 Code" := QRSpecification."Shortcut Dimension 2 Code";
                        ItemJournalLine."New Dimension Set ID" := QRSpecification."Dimension Set ID";
                        ItemJournalLine.INSERT(TRUE);
                        LineNo += 10000;

                        CLEAR(ReservationEntry);
                        ReservationEntry.INIT;
                        ReservationEntry."Item No." := ItemJournalLine."Item No.";
                        ReservationEntry."Location Code" := ItemJournalLine."Location Code";
                        ReservationEntry."Quantity (Base)" := ItemJournalLine.Quantity * -1;
                        ReservationEntry.Quantity := ReservationEntry."Quantity (Base)";
                        ReservationEntry."Qty. to Handle (Base)" := ReservationEntry."Quantity (Base)";
                        ReservationEntry."Qty. to Invoice (Base)" := ReservationEntry."Quantity (Base)";
                        ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Prospect;
                        ReservationEntry."Creation Date" := TODAY;
                        ReservationEntry."Source Type" := DATABASE::"Item Journal Line";
                        ReservationEntry."Source Subtype" := 4;
                        ReservationEntry."Source ID" := ItemJournalLine."Journal Template Name";
                        ReservationEntry."Source Batch Name" := ItemJournalLine."Journal Batch Name";
                        ReservationEntry."Source Ref. No." := ItemJournalLine."Line No.";
                        ReservationEntry."Shipment Date" := ItemJournalLine."Posting Date";
                        ReservationEntry."Created By" := USERID;
                        ReservationEntry."Qty. per Unit of Measure" := ItemJournalLine."Qty. per Unit of Measure";
                        ReservationEntry."New Lot No." := BuildLotNoForPurchase;
                        ReservationEntry."Lot No." := QRSpecification."Lot No.";
                        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                        ReservationEntry."Appl.-to Item Entry" := QRSpecification."Item Ledger Entry No.";
                        ReservationEntry.INSERT;

                        ReservationEntryNo := ReservationEntry."Entry No.";

                        NoOfStickersRequired -= 1;

                        CLEAR(ItemJnlPostLine);
                        ItemJnlPostLine.RunWithCheck(ItemJournalLine);
                        IF ItemJnlPostLine.CollectItemEntryRelation(TempItemEntryRelation) THEN BEGIN
                            IF TempItemEntryRelation.FINDSET THEN
                                REPEAT
                                    PrintQRSpecification.RESET;
                                    PrintQRSpecification.SETRANGE("Item Ledger Entry No.", TempItemEntryRelation."Item Entry No.");
                                    IF NOT PrintQRSpecification.FINDFIRST THEN BEGIN
                                        CLEAR(PrintQRSpecification);
                                        PrintQRSpecification.INIT;
                                        PrintQRSpecification."Line No." := TempItemEntryRelation."Item Entry No.";
                                        PrintQRSpecification."Item No." := QRSpecification."Item No.";
                                        PrintQRSpecification."Purchase Receipt No." := QRSpecification."Purchase Receipt No.";
                                        PrintQRSpecification."Lot No." := TempItemEntryRelation."Lot No.";
                                        PrintQRSpecification."No. of Sticker Required" := 1;
                                        PrintQRSpecification."Per Sticker Qty" := QRSpecification."Per Sticker Qty";
                                        PrintQRSpecification."Item Ledger Entry No." := TempItemEntryRelation."Item Entry No.";
                                        PrintQRSpecification.INSERT;
                                    END;
                                UNTIL TempItemEntryRelation.NEXT = 0;
                        END;

                        ReservationEntry.RESET;
                        ReservationEntry.SETRANGE("Entry No.", ReservationEntryNo);
                        ReservationEntry.SETRANGE(Positive, FALSE);
                        IF ReservationEntry.FINDFIRST THEN
                            ReservationEntry.DELETE;

                        ItemJournalLine.RESET;
                        ItemJournalLine.SETRANGE("Journal Template Name", InvtSetup."QR Item Reclass Jnl. Template");
                        ItemJournalLine.SETRANGE("Journal Batch Name", InvtSetup."QR Item Reclass Jnl. Batch");
                        IF ItemJournalLine.FINDSET THEN
                            ItemJournalLine.DELETEALL(TRUE);

                    UNTIL NoOfStickersRequired = 0;
                END;
            UNTIL QRSpecification.NEXT = 0;
    end;

    local procedure "--QRScanning-On-SalesLine"()
    begin
    end;

    [Scope('Internal')]
    procedure AssignLotNoToSalesLine(SalesHeader: Record "36"; QRText: Text[250]; Settings: array[50] of Boolean; QtyToAssign: Decimal): Code[20]
    var
        SalesLine: Record "37";
        NewSalesLine: Record "37";
        ItemNo: Code[20];
        Supplier: Code[10];
        ParentLotNo: Code[30];
        ActualLotNo: Code[20];
        WorkString: Text[250];
        AvailableQty: Integer;
        OldLotFound: Boolean;
        ItemCategory: Record "5722";
        Item: Record "27";
        Found: Boolean;
        QtyRequiredToFullFillDemand: Decimal;
        "---Settings": Integer;
        AutoInsertItems: Boolean;
        AddQtyInSalesOrder: Boolean;
        GetNextLine: Boolean;
        QtyAllocated: Decimal;
        Location: Record "14";
    begin
        IF QRText = '' THEN
            EXIT;
        AutoInsertItems := Settings[1];
        AddQtyInSalesOrder := Settings[2];
        WorkString := CONVERTSTR(QRText, '/', ',');
        WorkString := CONVERTSTR(WorkString, '|', ',');
        Supplier := SELECTSTR(1, WorkString);
        ItemNo := SELECTSTR(2, WorkString);
        /*
        ItemCategory.RESET;
        ItemCategory.SETRANGE("Supplier Code",Supplier);
        IF ItemCategory.FINDSET THEN REPEAT
          IF STRLEN(ItemNo+'-'+ItemCategory.Code) < 21 THEN BEGIN
            Item.RESET;
            Item.SETFILTER("No.",'%1',ItemNo+'-'+ItemCategory.Code);
            Item.SETRANGE("Supplier Code",Supplier);
            IF Item.FINDFIRST THEN BEGIN
              ItemNo := Item."No.";
              Found := TRUE;
            END;
          END;
        UNTIL (ItemCategory.NEXT = 0) OR (Found = TRUE);
        */
        ParentLotNo := SELECTSTR(3, WorkString);
        ActualLotNo := SELECTSTR(4, WorkString) + '/' + SELECTSTR(5, WorkString);
        AvailableQty := CheckInventory(SalesHeader."Location Code", ItemNo, ActualLotNo, OldLotFound);
        OldLotFound := PartsFromOldLot(QRText);

        IF (OldLotFound) AND (QtyToAssign > AvailableQty) THEN
            ERROR('Inventory is not available.\Item No = %1\Lot No = %2\Qty. on Inventory = %3,Qty. Entered = %4',
                  ItemNo, ParentLotNo, AvailableQty, QtyToAssign);

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE("No.", ItemNo);
        IF NOT SalesLine.FINDFIRST THEN BEGIN
            AutoInsertItems := FALSE;
            IF NOT AutoInsertItems THEN BEGIN
                ERROR('Item %1 could not be found on sales line.', ItemNo);
                //IF CONFIRM('Item %1 could not be found on sales line. Do you want to insert it?',FALSE,ItemNo) THEN
                //AutoInsertItems := TRUE;
            END;
            IF AutoInsertItems THEN BEGIN
                CLEAR(NewSalesLine);
                NewSalesLine.INIT;
                NewSalesLine.SetHideValidationDialog(TRUE);
                NewSalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
                NewSalesLine.VALIDATE("Document No.", SalesHeader."No.");
                NewSalesLine."Line No." := GetLastSalesLineNo(SalesHeader) + 10000;
                NewSalesLine.VALIDATE(Type, NewSalesLine.Type::Item);
                NewSalesLine.VALIDATE("No.", ItemNo);
                IF OldLotFound THEN
                    NewSalesLine.VALIDATE(Quantity, QtyToAssign)
                ELSE BEGIN
                    IF AvailableQty > 0 THEN
                        NewSalesLine.VALIDATE(Quantity, AvailableQty);
                END;
                NewSalesLine.INSERT(TRUE);

                IF NewSalesLine.Quantity > 0 THEN
                    AssignLotNoToPerSalesLine(NewSalesLine, ActualLotNo, NewSalesLine.Quantity);
            END;
        END ELSE BEGIN
            IF NOT OldLotFound THEN
                CheckSalesLineReservation(SalesLine, ActualLotNo);
            IF AddQtyInSalesOrder THEN BEGIN
                IF OldLotFound THEN
                    SalesLine.VALIDATE(Quantity, SalesLine.Quantity + QtyToAssign)
                ELSE
                    SalesLine.VALIDATE(Quantity, SalesLine.Quantity + AvailableQty);
                SalesLine.MODIFY(TRUE);
                IF AvailableQty > 0 THEN BEGIN
                    IF OldLotFound THEN
                        AssignLotNoToPerSalesLine(SalesLine, ActualLotNo, QtyToAssign)
                    ELSE
                        AssignLotNoToPerSalesLine(SalesLine, ActualLotNo, AvailableQty);
                END;
            END
            ELSE BEGIN
                REPEAT
                    // Changes on 18 JUNE 2017 >>
                    GetNextLine := FALSE;
                    QtyRequiredToFullFillDemand := SalesLine."Qty. to Ship" - CheckHowManyQtyIsFullfilled(DATABASE::"Sales Line", SalesLine."Document Type",
                        SalesLine."Document No.", SalesLine."Line No.");
                    IF QtyToAssign = 0 THEN
                        QtyToAssign := AvailableQty;
                    IF QtyToAssign < QtyRequiredToFullFillDemand THEN
                        QtyAllocated := QtyToAssign
                    ELSE
                        QtyAllocated := QtyRequiredToFullFillDemand;
                    IF (AvailableQty > 0) AND (QtyAllocated > 0) THEN BEGIN
                        IF QtyAllocated >= AvailableQty THEN
                            QtyAllocated := AvailableQty;
                        AssignLotNoToPerSalesLine(SalesLine, ActualLotNo, QtyAllocated);
                        QtyToAssign -= QtyAllocated;
                        AvailableQty -= QtyAllocated;
                    END;
                    IF QtyToAssign > 0 THEN BEGIN
                        IF (SalesLine.NEXT = 0) THEN BEGIN
                            Location.GET(SalesLine."Location Code");
                            IF Location."Check QR Excess Qty." THEN
                                ERROR('Excess Qty of %1 entered for Item %2.', QtyToAssign, ItemNo)
                        END
                        ELSE BEGIN
                            SalesLine.NEXT(-1);
                            GetNextLine := TRUE;
                        END;
                    END
                    ELSE
                        GetNextLine := FALSE;

                // Changes on 18 JUNE 2017 <<

                //Old Code >>
                /*
                GetNextLine := FALSE;
                QtyRequiredToFullFillDemand := SalesLine."Qty. to Ship" - CheckHowManyQtyIsFullfilled(DATABASE::"Sales Line",SalesLine."Document Type",
                    SalesLine."Document No.",SalesLine."Line No.");

                IF OldLotFound THEN BEGIN
                 // IF QtyToAssign > QtyRequiredToFullFillDemand THEN
                   // ERROR('Excess Qty of %1 entered for Item %2.',QtyToAssign-QtyRequiredToFullFillDemand,ItemNo);
                  //QtyRequiredToFullFillDemand := QtyToAssign;
                END ELSE BEGIN
                  //IF QtyRequiredToFullFillDemand > AvailableQty THEN
                    //ERROR('Excess Qty of %1 entered for Item %2.',AvailableQty-QtyRequiredToFullFillDemand,ItemNo);
                END;
                IF AvailableQty > 0 THEN BEGIN
                  IF QtyRequiredToFullFillDemand > 0 THEN BEGIN
                    IF QtyRequiredToFullFillDemand <= AvailableQty THEN BEGIN
                      AssignLotNoToPerSalesLine(SalesLine,ActualLotNo,QtyRequiredToFullFillDemand);
                    END ELSE BEGIN
                      AssignLotNoToPerSalesLine(SalesLine,ActualLotNo,AvailableQty);
                    END;
                  END
                  ELSE BEGIN
                    IF SalesLine.NEXT = 0 THEN
                      ERROR('Quantity exceeded for Item %1.',ItemNo)
                    ELSE BEGIN
                      SalesLine.NEXT(-1);
                      GetNextLine := TRUE;
                    END;
                  END;
                END;
                */
                //Old Code <<
                UNTIL (SalesLine.NEXT = 0) OR (NOT GetNextLine);
            END;
        END;
        EXIT(ItemNo);

    end;

    local procedure AssignLotNoToPerSalesLine(SalesLine: Record "37"; LotNo: Code[20]; AvailableQty: Decimal)
    var
        CreateReservEntry: Codeunit "99000830";
        ReservationEntry: Record "337";
        ReservationMgt: Codeunit "99000845";
        QtyAlreadyAssigned: Decimal;
    begin
        /*
IF LotNo = GetDefaultOldLotNo THEN BEGIN
  QtyAlreadyAssigned := CheckHowManyQtyIsFullfilled(DATABASE::"Sales Line",SalesLine."Document Type",
      SalesLine."Document No.",SalesLine."Line No.");
  ReservationEntry.RESET;
  ReservationEntry.SETRANGE("Source ID",SalesLine."Document No.");
  ReservationEntry.SETRANGE("Source Type",37);
  ReservationEntry.SETRANGE("Source Subtype",1);
  ReservationEntry.SETRANGE("Source Ref. No.",SalesLine."Line No.");
  IF ReservationEntry.FINDFIRST THEN BEGIN
    ReservationMgt.SetItemTrackingHandling(1); // Allow deletion of Item Tracking
    ReservationMgt.SetPointerFilter(ReservationEntry);
    ReservationMgt.DeleteReservEntries2(TRUE,0,ReservationEntry);
  END;
  AvailableQty += QtyAlreadyAssigned;
END;
*/
        IF LotNo <> '' THEN BEGIN
            CreateReservEntry.SetDates(
              0D, 0D);
            CreateReservEntry.CreateReservEntryFor(DATABASE::"Sales Line",
            SalesLine."Document Type",
            SalesLine."Document No.", '',
            0,
            SalesLine."Line No.",
            SalesLine."Qty. per Unit of Measure",
            AvailableQty,
            AvailableQty,
            '',
            LotNo);

            CreateReservEntry.CreateEntry(SalesLine."No.", SalesLine."Variant Code", SalesLine."Location Code", '',
            0D, SalesLine."Shipment Date", 0,
            2);
        END;

    end;

    local procedure GetLastSalesLineNo(SalesHeader: Record "36"): Integer
    var
        SalesLine: Record "37";
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDLAST THEN
            EXIT(SalesLine."Line No.")
    end;

    local procedure CheckSalesLineReservation(SalesLine: Record "37"; LotNo: Code[20])
    var
        ReservationEntry: Record "337";
    begin
        ReservationEntry.RESET;
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SETRANGE("Source Subtype", SalesLine."Document Type");
        ReservationEntry.SETRANGE("Source ID", SalesLine."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", SalesLine."Line No.");
        ReservationEntry.SETRANGE("Lot No.", LotNo);
        IF NOT ReservationEntry.ISEMPTY THEN
            ERROR('Item %1 with Lot No %2 has already been used on Order %3.', SalesLine."No.", LotNo, SalesLine."Document No.");
    end;

    local procedure CheckInventory(LocationCode: Code[10]; ItemNo: Code[20]; var LotNo: Code[20]; OldLotFound: Boolean): Decimal
    var
        Item: Record "27";
        ItemLedgerEntry: Record "32";
    begin
        Item.RESET;
        Item.SETFILTER("No.", ItemNo);
        Item.SETFILTER("Location Filter", LocationCode);
        Item.SETFILTER("Lot No. Filter", LotNo);
        Item.FINDFIRST;
        Item.CALCFIELDS(Inventory);
        IF Item.Inventory < 1 THEN BEGIN
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.");
            ItemLedgerEntry.SETRANGE("Item No.", ItemNo);
            ItemLedgerEntry.SETRANGE("Lot No.", LotNo);
            IF ItemLedgerEntry.ISEMPTY THEN BEGIN
                LotNo := GetDefaultOldLotNo;
                OldLotFound := TRUE;
                //EXIT(CheckInventory(LocationCode,ItemNo,LotNo,OldLotFound));
            END
            ELSE
                ERROR('Item %1 with lot no %2 is not in inventory.', ItemNo, LotNo);
        END;
        EXIT(Item.Inventory);
    end;

    [Scope('Internal')]
    procedure CheckHowManyQtyIsFullfilled(SourceType: Integer; SourceSubType: Integer; SourceID: Code[20]; SourceRefNo: Integer) QtyAssigned: Decimal
    var
        ReservationEntry: Record "337";
    begin
        QtyAssigned := 0;
        ReservationEntry.RESET;
        ReservationEntry.SETRANGE("Source Type", SourceType);
        ReservationEntry.SETRANGE("Source Subtype", SourceSubType);
        ReservationEntry.SETRANGE("Source ID", SourceID);
        ReservationEntry.SETRANGE("Source Ref. No.", SourceRefNo);
        IF ReservationEntry.FINDSET THEN
            REPEAT
                QtyAssigned += ReservationEntry."Qty. to Handle (Base)";
            UNTIL ReservationEntry.NEXT = 0;
        EXIT(QtyAssigned * -1);
    end;

    [Scope('Internal')]
    procedure PartsFromOldLot(QRText: Text[250]): Boolean
    var
        Supplier: Code[10];
        ParentLotNo: Code[30];
        ActualLotNo: Code[20];
        WorkString: Text[250];
        ItemNo: Code[20];
        ItemLedgerEntry: Record "32";
    begin
        WorkString := CONVERTSTR(QRText, '/', ',');
        WorkString := CONVERTSTR(WorkString, '|', ',');
        Supplier := SELECTSTR(1, WorkString);
        ItemNo := SELECTSTR(2, WorkString);
        ParentLotNo := SELECTSTR(3, WorkString);
        ActualLotNo := SELECTSTR(4, WorkString) + '/' + SELECTSTR(5, WorkString);
        IF ActualLotNo = GetDefaultOldLotNo THEN
            EXIT(TRUE);
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Lot No.", "Serial No.");
        ItemLedgerEntry.SETRANGE("Item No.", ItemNo);
        ItemLedgerEntry.SETRANGE("Lot No.", ActualLotNo);
        IF ItemLedgerEntry.ISEMPTY THEN
            EXIT(TRUE);
    end;

    local procedure "--QRScanning-On-ServiceLine"()
    begin
    end;

    [Scope('Internal')]
    procedure AssignLotNoToServiceLine(ServiceHeader: Record "25006145"; QRText: Text[250]; Settings: array[50] of Boolean; ServItemLineNo: Integer)
    var
        ServiceLine: Record "25006146";
        NewServiceLine: Record "25006146";
        ItemNo: Code[20];
        Supplier: Code[10];
        ParentLotNo: Code[30];
        ActualLotNo: Code[20];
        WorkString: Text[250];
        AvailableQty: Integer;
        OldLotFound: Boolean;
        "---Settings": Integer;
        AutoInsertItems: Boolean;
        AddQtyInSalesOrder: Boolean;
        QtyRequiredToFullFillDemand: Decimal;
    begin
        AutoInsertItems := Settings[1];
        AddQtyInSalesOrder := Settings[2];
        WorkString := CONVERTSTR(QRText, '/', ',');
        WorkString := CONVERTSTR(WorkString, '|', ',');
        Supplier := SELECTSTR(1, WorkString);
        ItemNo := SELECTSTR(2, WorkString);

        IF Supplier = 'HMIPP' THEN
            Supplier := 'HPP'
        ELSE
            IF Supplier = 'TH' THEN
                Supplier := 'THA';

        ParentLotNo := SELECTSTR(3, WorkString);
        ActualLotNo := SELECTSTR(4, WorkString) + '/' + SELECTSTR(5, WorkString);
        AvailableQty := CheckInventory(ServiceHeader."Location Code", ItemNo, ActualLotNo, OldLotFound);

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE("No.", ItemNo);
        IF NOT ServiceLine.FINDFIRST THEN BEGIN
            IF NOT AutoInsertItems THEN BEGIN
                IF CONFIRM('Item %1 could not be found on sales line. Do you want to insert it?', FALSE, ItemNo) THEN
                    AutoInsertItems := TRUE;
            END;
            IF AutoInsertItems THEN BEGIN
                CLEAR(NewServiceLine);
                NewServiceLine.INIT;
                NewServiceLine.VALIDATE("Document Type", ServiceHeader."Document Type");
                NewServiceLine.VALIDATE("Document No.", ServiceHeader."No.");
                NewServiceLine."Line No." := GetLastServiceLineNo(ServiceHeader) + 10000;
                NewServiceLine.VALIDATE(Type, NewServiceLine.Type::Item);
                NewServiceLine.VALIDATE("No.", ItemNo);
                IF AddQtyInSalesOrder THEN
                    NewServiceLine.VALIDATE(Quantity, AvailableQty);
                NewServiceLine.INSERT(TRUE);
                IF NOT OldLotFound THEN
                    IF (AvailableQty > 0) THEN
                        AssignLotNoToPerServiceLine(NewServiceLine, ActualLotNo, AvailableQty);
            END;
        END ELSE BEGIN
            CheckServiceLineReservation(ServiceLine, ActualLotNo);
            IF AddQtyInSalesOrder THEN BEGIN
                ServiceLine.VALIDATE(Quantity, ServiceLine.Quantity + AvailableQty);
                ServiceLine.MODIFY(TRUE);
                IF AvailableQty > 0 THEN
                    AssignLotNoToPerServiceLine(ServiceLine, ActualLotNo, AvailableQty);
            END
            ELSE BEGIN
                QtyRequiredToFullFillDemand := ServiceLine.Quantity - CheckHowManyQtyIsFullfilled(DATABASE::"Service Line", ServiceLine."Document Type",
                    ServiceLine."Document No.", ServiceLine."Line No.");
                IF QtyRequiredToFullFillDemand > 0 THEN BEGIN
                    IF QtyRequiredToFullFillDemand <= AvailableQty THEN BEGIN
                        AssignLotNoToPerServiceLine(ServiceLine, ActualLotNo, QtyRequiredToFullFillDemand);
                    END ELSE BEGIN
                        AssignLotNoToPerServiceLine(ServiceLine, ActualLotNo, AvailableQty);
                    END;
                END
                ELSE BEGIN
                    ERROR('Quantity exceeded for Item %1.', ItemNo);
                END;
            END;
        END;
    end;

    local procedure GetLastServiceLineNo(ServiceHeader: Record "25006145"): Integer
    var
        ServiceLine: Record "5902";
    begin
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceLine.FINDLAST THEN
            EXIT(ServiceLine."Line No.")
    end;

    local procedure AssignLotNoToPerServiceLine(ServiceLine: Record "25006146"; LotNo: Code[20]; AvailableQty: Decimal)
    var
        CreateReservEntry: Codeunit "99000830";
        ReservationEntry: Record "337";
        ReservationMgt: Codeunit "99000845";
    begin
        IF LotNo <> '' THEN BEGIN
            CreateReservEntry.SetDates(
              0D, 0D);
            CreateReservEntry.CreateReservEntryFor(DATABASE::"Service Line",
            ServiceLine."Document Type",
            ServiceLine."Document No.", '',
            0,
            "Line No.",
            "Qty. per Unit of Measure",
            AvailableQty,
            AvailableQty,
            '',
            LotNo);

            CreateReservEntry.CreateEntry("No.", "Variant Code", "Location Code", '',
            0D, "Promised Delivery Date", 0,
            2);
        END;
    end;

    local procedure CheckServiceLineReservation(ServiceLine: Record "25006146"; LotNo: Code[20])
    var
        ReservationEntry: Record "337";
    begin
        ReservationEntry.RESET;
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Service Line");
        ReservationEntry.SETRANGE("Source Subtype", ServiceLine."Document Type");
        ReservationEntry.SETRANGE("Source ID", ServiceLine."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", ServiceLine."Line No.");
        ReservationEntry.SETRANGE("Lot No.", LotNo);
        IF NOT ReservationEntry.ISEMPTY THEN
            ERROR('Item %1 with Lot No %2 has already been used on Order %3.', ServiceLine."No.", LotNo, ServiceLine."Document No.");
    end;

    local procedure "--QRScanning-On-TransferLine"()
    begin
    end;

    [Scope('Internal')]
    procedure AssignLotNoToTransferLine(TransferHeader: Record "5740"; QRText: Text[250]; Settings: array[50] of Boolean; QtyToAssign: Decimal): Code[20]
    var
        TransferLine: Record "5741";
        NewTransferLine: Record "5741";
        ItemCategory: Record "5722";
        Item: Record "27";
        ItemNo: Code[20];
        Supplier: Code[10];
        ParentLotNo: Code[30];
        ActualLotNo: Code[20];
        WorkString: Text[250];
        AvailableQty: Decimal;
        OldLotFound: Boolean;
        Found: Boolean;
        "---Settings": Integer;
        AutoInsertItems: Boolean;
        AddQtyInTransferOrder: Boolean;
        QtyRequiredToFullFillDemand: Decimal;
    begin
        IF QRText = '' THEN
            EXIT;
        AutoInsertItems := Settings[1];
        AddQtyInTransferOrder := Settings[2];
        WorkString := CONVERTSTR(QRText, '/', ',');
        WorkString := CONVERTSTR(WorkString, '|', ',');
        Supplier := SELECTSTR(1, WorkString);
        ItemNo := SELECTSTR(2, WorkString);

        /*
        IF Supplier = 'HMIPP' THEN
          Supplier := 'HPP'
        ELSE IF Supplier = 'TH' THEN
          Supplier := 'THA';
        */

        ItemCategory.RESET;
        ItemCategory.SETRANGE("Supplier Code", Supplier);
        IF ItemCategory.FINDSET THEN
            REPEAT
                IF STRLEN(ItemNo + '-' + ItemCategory.Code) < 21 THEN BEGIN
                    Item.RESET;
                    Item.SETFILTER("No.", '%1', ItemNo + '-' + ItemCategory.Code);
                    Item.SETRANGE("Supplier Code", Supplier);
                    IF Item.FINDFIRST THEN BEGIN
                        ItemNo := Item."No.";
                        Found := TRUE;
                    END;
                END;
            UNTIL (ItemCategory.NEXT = 0) OR (Found = TRUE);

        ParentLotNo := SELECTSTR(3, WorkString);
        ActualLotNo := SELECTSTR(4, WorkString) + '/' + SELECTSTR(5, WorkString);
        AvailableQty := CheckInventory(TransferHeader."Transfer-from Code", ItemNo, ActualLotNo, OldLotFound);
        OldLotFound := PartsFromOldLot(QRText);

        IF (OldLotFound) AND (QtyToAssign > AvailableQty) THEN
            ERROR('Inventory is not available.\Item No = %1\Lot No = %2\Qty. on Inventory = %3,Qty. Entered = %4',
                  ItemNo, ParentLotNo, AvailableQty, QtyToAssign);

        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        TransferLine.SETRANGE("Item No.", ItemNo);
        IF NOT TransferLine.FINDFIRST THEN BEGIN
            IF NOT AutoInsertItems THEN BEGIN
                IF CONFIRM('Item %1 could not be found on Transfer line Document %2. Do you want to insert it?', FALSE, ItemNo, TransferHeader."No.") THEN
                    AutoInsertItems := TRUE;
            END;
            IF AutoInsertItems THEN BEGIN
                CLEAR(NewTransferLine);
                NewTransferLine.INIT;
                NewTransferLine.VALIDATE("Document No.", TransferHeader."No.");
                NewTransferLine."Line No." := GetLastTransferLineNo(TransferHeader) + 10000;
                NewTransferLine.VALIDATE("Item No.", ItemNo);
                IF OldLotFound THEN
                    NewTransferLine.VALIDATE(Quantity, QtyToAssign)
                ELSE BEGIN
                    IF AvailableQty > 0 THEN
                        NewTransferLine.VALIDATE(Quantity, AvailableQty);
                END;
                NewTransferLine.INSERT(TRUE);
                IF NewTransferLine.Quantity > 0 THEN
                    AssignLotNoToPerTransferLine(NewTransferLine, ActualLotNo, NewTransferLine.Quantity);
            END;
        END ELSE BEGIN
            IF NOT OldLotFound THEN
                CheckTransferLineReservation(TransferLine, ActualLotNo);
            IF AddQtyInTransferOrder THEN BEGIN
                IF OldLotFound THEN
                    TransferLine.VALIDATE(Quantity, TransferLine.Quantity + QtyToAssign)
                ELSE
                    TransferLine.VALIDATE(Quantity, TransferLine.Quantity + AvailableQty);
                TransferLine.MODIFY(TRUE);
                IF AvailableQty > 0 THEN BEGIN
                    IF OldLotFound THEN
                        AssignLotNoToPerTransferLine(TransferLine, ActualLotNo, QtyToAssign)
                    ELSE
                        AssignLotNoToPerTransferLine(TransferLine, ActualLotNo, AvailableQty);
                END;
            END
            ELSE BEGIN
                QtyRequiredToFullFillDemand := TransferLine.Quantity - CheckHowManyQtyIsFullfilled(DATABASE::"Transfer Line", 0,
                    TransferLine."Document No.", TransferLine."Line No.");
                IF OldLotFound THEN BEGIN
                    IF QtyToAssign > QtyRequiredToFullFillDemand THEN
                        ERROR('Excess Qty of %1 entered for Item %2.', QtyToAssign - QtyRequiredToFullFillDemand, ItemNo);
                    QtyRequiredToFullFillDemand := QtyToAssign;
                END ELSE BEGIN
                    IF QtyRequiredToFullFillDemand < AvailableQty THEN
                        ERROR('Excess Qty of %1 entered for Item %2.', AvailableQty - QtyRequiredToFullFillDemand, ItemNo);
                END;
                IF AvailableQty > 0 THEN BEGIN
                    IF QtyRequiredToFullFillDemand > 0 THEN BEGIN
                        IF QtyRequiredToFullFillDemand <= AvailableQty THEN BEGIN
                            AssignLotNoToPerTransferLine(TransferLine, ActualLotNo, QtyRequiredToFullFillDemand);
                        END ELSE BEGIN
                            AssignLotNoToPerTransferLine(TransferLine, ActualLotNo, AvailableQty);
                        END;
                    END
                    ELSE BEGIN
                        ERROR('Quantity exceeded for Item %1.', ItemNo);
                    END;
                END;
            END;
        END;
        EXIT(ItemNo);

    end;

    local procedure GetLastTransferLineNo(TransferHeader: Record "5740"): Integer
    var
        TransferLine: Record "5741";
    begin
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", TransferHeader."No.");
        IF TransferLine.FINDLAST THEN
            EXIT(TransferLine."Line No.")
    end;

    local procedure AssignLotNoToPerTransferLine(TransferLine: Record "5741"; LotNo: Code[20]; AvailableQty: Decimal)
    var
        CreateReservEntry: Codeunit "99000830";
        ReservationEntry: Record "337";
        ReservationMgt: Codeunit "99000845";
    begin
        IF LotNo <> '' THEN BEGIN
            CreateReservEntry.SetDates(
              0D, 0D);
            CreateReservEntry.CreateReservEntryFor(DATABASE::"Transfer Line",
            0,
            TransferLine."Document No.", '',
            0,
            TransferLine."Line No.",
            TransferLine."Qty. per Unit of Measure",
            AvailableQty,
            AvailableQty,
            '',
            LotNo);

            CreateReservEntry.CreateEntry(TransferLine."Item No.", TransferLine."Variant Code", TransferLine."Transfer-from Code", '',
            0D, TransferLine."Shipment Date", 0,
            2);

            CreateReservEntry.CreateReservEntryFor(DATABASE::"Transfer Line",
            1,
            TransferLine."Document No.", '',
            0,
            TransferLine."Line No.",
            TransferLine."Qty. per Unit of Measure",
            AvailableQty,
            AvailableQty,
            '',
            LotNo);

            CreateReservEntry.CreateEntry(TransferLine."Item No.", TransferLine."Variant Code", TransferLine."Transfer-to Code", '',
            TransferLine."Receipt Date", 0D, 0,
            2);
        END;
    end;

    local procedure CheckTransferLineReservation(TransferLine: Record "5741"; LotNo: Code[20])
    var
        ReservationEntry: Record "337";
    begin
        ReservationEntry.RESET;
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Transfer Line");
        ReservationEntry.SETRANGE("Source Subtype", 0);
        ReservationEntry.SETRANGE("Source ID", TransferLine."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", TransferLine."Line No.");
        ReservationEntry.SETRANGE("Lot No.", LotNo);
        IF NOT ReservationEntry.ISEMPTY THEN
            ERROR('Item %1 with Lot No %2 has already been used on Order %3.', TransferLine."Item No.", LotNo, TransferLine."Document No.");
    end;

    [Scope('Internal')]
    procedure ShowAllListOfQR(var QRSpecification: Record "33019974" temporary)
    var
        ItemLedgerEntry: Record "32";
        ItemLedgerEntries: Page "38";
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Document No.", "Document Type", "Document Line No.");
        ItemLedgerEntry.FILTERGROUP(2);
        ItemLedgerEntry.SETRANGE("Document No.", QRSpecification."Purchase Receipt No.");
        ItemLedgerEntry.SETRANGE("Item No.", QRSpecification."Item No.");
        ItemLedgerEntry.SETRANGE(Quantity, QRSpecification."Per Sticker Qty");
        ItemLedgerEntry.FILTERGROUP(0);
        IF ItemLedgerEntry.FINDFIRST THEN BEGIN
            CLEAR(ItemLedgerEntries);
            ItemLedgerEntries.SETTABLEVIEW(ItemLedgerEntry);
            ItemLedgerEntries.RUN;
        END;
    end;

    local procedure GetDefaultOldLotNo(): Code[20]
    var
        InvtSetup: Record "313";
    begin
        InvtSetup.GET;
        EXIT(InvtSetup."Default Old Lot No.");
    end;

    local procedure "--QRGenerationInPurchase"()
    begin
    end;

    [Scope('Internal')]
    procedure AssignLotForPurchase(PurchHeader: Record "38")
    var
        PurchaseLine: Record "39";
        ReservationEntry: Record "337";
        Item: Record "27";
        CreateReservEntry: Codeunit "99000830";
        ReservationMgt: Codeunit "99000845";
        WindowText001: Label 'Assigning Item Tracking \#1##### \of \#2#####';
        WindowText002: Label 'Do you want to assign Lot for all Purchase Lines?';
        ProgressWindow: Dialog;
        TotalCount: Integer;
    begin
        IF NOT HideValidationDialog THEN
            IF NOT CONFIRM(WindowText002, TRUE) THEN
                EXIT;

        ReservationEntry.RESET;
        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SETRANGE("Source ID", PurchHeader."No.");
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
        ReservationEntry.SETRANGE("Source Subtype", 1);
        ReservationEntry.DELETEALL;

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type", PurchHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchHeader."No.");
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        PurchaseLine.SETFILTER("No.", '<>%1', '');
        PurchaseLine.SETFILTER("Qty. to Receive", '<>%1', 0);
        ProgressWindow.OPEN(WindowText001);
        ProgressWindow.UPDATE(2, PurchaseLine.COUNT);
        IF PurchaseLine.FINDSET THEN
            REPEAT
                TotalCount += 1;
                ProgressWindow.UPDATE(1, TotalCount);
                Item.GET(PurchaseLine."No.");
                PurchaseLine.TESTFIELD("Package No.");
                IF Item."Item Tracking Code" <> '' THEN BEGIN
                    CreateReservEntry.SetDates(
                      0D, 0D);
                    CreateReservEntry.CreateReservEntryFor(DATABASE::"Purchase Line",
                    PurchaseLine."Document Type",
                    PurchaseLine."Document No.", '',
                    0,
                    PurchaseLine."Line No.",
                    PurchaseLine."Qty. per Unit of Measure",
                    PurchaseLine."Qty. to Receive",
                    PurchaseLine."Qty. to Receive (Base)",
                    '',
                    PurchaseLine."Package No.");

                    CreateReservEntry.CreateEntry(PurchaseLine."No.", PurchaseLine."Variant Code", PurchaseLine."Location Code", '',
                    PurchaseLine."Expected Receipt Date", 0D, 0,
                    2);
                END;
            UNTIL PurchaseLine.NEXT = 0;
    end;

    local procedure BuildLotNoForPurchase(): Code[20]
    var
        IRDMgt: Codeunit "50000";
        TotalStringLength: Integer;
        UniqueID: Text;
        Slash: Label '/';
        Dash: Label '-';
    begin
        UniqueID := CREATEGUID;
        UniqueID := DELCHR(UniqueID, '=', '{}-');
        UniqueID := COPYSTR(UniqueID, 1, 12);
        UniqueID := IRDMgt.GetNepaliFiscalYear(TODAY) + Dash + UniqueID;
        UniqueID := COPYSTR(UniqueID, 1, 20);
        EXIT(UniqueID);
    end;

    [Scope('Internal')]
    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure "--OrderAdj"()
    begin
        /*
        SalesInvHeader := Rec;
        CurrPage.SETSELECTIONFILTER(SalesInvHeader);
        OrderAdjustment.SETTABLEVIEW(SalesInvHeader);
        OrderAdjustment.RUN;
        
        */

    end;

    local procedure "--ItemLedgerEntryPage"()
    begin
    end;

    [Scope('Internal')]
    procedure SplitQuantityFromItemLedger(var ItemLedgerEntry: Record "32")
    var
        QRSpecification: Record "33019974" temporary;
        QRPrint: Report "50074";
        PrintQRSpecification: Record "33019974" temporary;
        Item: Record "27";
        NoOfStickerRequired: Integer;
        PerStickerQty: Decimal;
        PageName: Label 'Split Quantity';
        QRSpecificationFilter: FilterPageBuilder;
        QRSpecificationFiltered: Record "33019974" temporary;
        Text009: Label 'You must specify %1.';
    begin
        QRSpecificationFilter.ADDRECORD(PageName, QRSpecification);
        QRSpecificationFilter.ADDFIELD(PageName, QRSpecification."No. of Sticker Required");
        QRSpecificationFilter.ADDFIELD(PageName, QRSpecification."Per Sticker Qty");

        QRSpecificationFilter.PAGECAPTION(PageName);
        QRSpecificationFilter.RUNMODAL;

        QRSpecificationFiltered.SETVIEW(QRSpecificationFilter.GETVIEW(PageName));
        IF QRSpecificationFiltered.GETFILTER("No. of Sticker Required") = '' THEN
            ERROR(Text009, QRSpecificationFiltered.FIELDCAPTION("No. of Sticker Required"));
        IF QRSpecificationFiltered.GETFILTER("Per Sticker Qty") = '' THEN
            ERROR(Text009, QRSpecificationFiltered.FIELDCAPTION("Per Sticker Qty"));

        EVALUATE(NoOfStickerRequired, QRSpecificationFiltered.GETFILTER("No. of Sticker Required"));
        EVALUATE(PerStickerQty, QRSpecificationFiltered.GETFILTER("Per Sticker Qty"));
        IF (NoOfStickerRequired = 0) OR (PerStickerQty = 0) THEN
            ERROR('You must specify No of sticker required and per sticker quantity.');

        IF ItemLedgerEntry.FINDFIRST THEN BEGIN
            ItemLedgerEntry.TESTFIELD("Remaining Quantity");
            Item.GET(ItemLedgerEntry."Item No.");
            CLEAR(QRSpecification);
            QRSpecification.INIT;
            QRSpecification."Item No." := ItemLedgerEntry."Item No.";
            QRSpecification."Line No." := ItemLedgerEntry."Entry No.";
            QRSpecification."Item Ledger Entry No." := ItemLedgerEntry."Entry No.";
            QRSpecification."Supplier Code" := Item."Supplier Code";
            QRSpecification."Part No." := ItemLedgerEntry."Item No.";
            QRSpecification."Purchase Quantity" := ItemLedgerEntry.Quantity;
            QRSpecification."Remaining Stock Qty" := ItemLedgerEntry."Remaining Quantity";
            QRSpecification."Location Code" := ItemLedgerEntry."Location Code";
            QRSpecification."Lot No." := ItemLedgerEntry."Lot No.";
            QRSpecification."Shortcut Dimension 1 Code" := ItemLedgerEntry."Global Dimension 1 Code";
            QRSpecification."Shortcut Dimension 2 Code" := ItemLedgerEntry."Global Dimension 2 Code";
            QRSpecification."Dimension Set ID" := ItemLedgerEntry."Dimension Set ID";
            QRSpecification."No. of Sticker Required" := NoOfStickerRequired;
            QRSpecification."Per Sticker Qty" := PerStickerQty;
            GetParentLotNoCodeInVariable(ItemLedgerEntry."Entry No.", QRSpecification."Parent Lot No.", QRSpecification."Package No.", QRSpecification."Purchase Receipt No.");
            QRSpecification.INSERT;
            PostPrintItemReclassification(QRSpecification, PrintQRSpecification);
            COMMIT;

            CLEAR(QRPrint);
            QRPrint.SetPrintUsingItemLedgerEntryNo;
            QRPrint.SetQRSpecification(PrintQRSpecification);
            QRPrint.RUN;
        END;
    end;

    [Scope('Internal')]
    procedure IsQRCodeMandatory(LocationCode: Code[10]): Boolean
    var
        Location: Record "14";
    begin
        IF Location.GET(LocationCode) THEN
            EXIT(Location."QR Mandatory");
    end;

    local procedure RemoveSymbolsFromItem()
    var
        Item: Record "27";
        NewItemCode: Code[20];
        Starttime: Time;
        Endttime: Time;
        Item1: Record "27";
    begin
        Starttime := TIME;
        Item.RESET;
        //Item.SETFILTER("No.",'%1|%2','TYRE 235/65/R17 JK','TYRE 235/65/R17 AP');
        //item.SETFILTER("No.",'*/*');
        IF Item.FINDFIRST THEN
            REPEAT
                NewItemCode := DELCHR(Item."No.", '=', '/');
                IF Item."No." <> NewItemCode THEN BEGIN
                    Item1.GET(Item."No.");
                    Item1.RENAME(NewItemCode);
                END;
            UNTIL Item.NEXT = 0;
        Endttime := TIME;
        MESSAGE('Start Time: ' + FORMAT(Starttime) + ' End time: ' + FORMAT(Endttime));
    end;

    local procedure UpdateReservationEntry()
    var
        TransferHeader: Record "5740";
        TransferLine: Record "5741";
        ReservationEntry: Record "337";
        Item: Record "27";
        InventorySetup: Record "313";
        TransferShipmentHeader: Record "5744";
        ItemLedgerEntry: Record "32";
        TransitLine: Record "5741";
        EntryNo: Integer;
        ServiceDocument: Boolean;
    begin
        InventorySetup.GET;

        ReservationEntry.RESET;
        ReservationEntry.LOCKTABLE;
        IF ReservationEntry.FINDLAST THEN
            EntryNo := ReservationEntry."Entry No." + 1;

        TransferLine.RESET;
        //TransferLine.SETRANGE("Document Date",071620D,012221D);
        TransferLine.SETRANGE("Document No.", 'BANTO77-03475');
        TransferLine.SETFILTER("Quantity Shipped", '<>0');
        TransferLine.SETFILTER("Quantity Received", '0');
        TransferLine.SETRANGE("Derived From Line No.", 0);
        IF TransferLine.FINDFIRST THEN BEGIN
            TransferHeader.GET(TransferLine."Document No.");
            IF TransferHeader."Source No." <> '' THEN
                ServiceDocument := TRUE;

            REPEAT
                TransitLine.RESET;
                TransitLine.SETRANGE("Document No.", TransferLine."Document No.");
                TransitLine.SETRANGE("Derived From Line No.", TransferLine."Line No.");
                TransitLine.FINDFIRST;
                //TransferShipmentHeader.RESET;
                //TransferShipmentHeader.SETRANGE("Transfer Order No.",TransferLine."Document No.");
                //TransferShipmentHeader.FINDFIRST;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Order No.", TransferLine."Document No.");
                ItemLedgerEntry.SETRANGE("Item No.", TransferLine."Item No.");
                ItemLedgerEntry.SETRANGE("Order Line No.", TransferLine."Line No.");
                ItemLedgerEntry.SETRANGE("Location Code", 'INTRANSIT');
                ItemLedgerEntry.FINDFIRST;
                Item.RESET;
                Item.SETRANGE("No.", TransferLine."Item No.");
                IF Item.FINDFIRST THEN BEGIN
                    IF Item."Item Tracking Code" <> '' THEN BEGIN
                        IF ServiceDocument THEN BEGIN
                            ReservationEntry.RESET;
                            ReservationEntry.SETRANGE("Source ID", TransferHeader."Source No.");
                            ReservationEntry.SETRANGE("Item No.", TransferLine."Item No.");
                            IF ReservationEntry.FINDSET THEN
                                REPEAT
                                    ReservationEntry."Item Ledger Entry No." := ItemLedgerEntry."Entry No.";
                                    ReservationEntry."Lot No." := InventorySetup."Default Old Lot No.";
                                    ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                    ReservationEntry.MODIFY;
                                UNTIL ReservationEntry.NEXT = 0;
                        END;
                        ReservationEntry.RESET;
                        ReservationEntry.SETRANGE("Source ID", TransferLine."Document No.");
                        ReservationEntry.SETRANGE("Item No.", TransferLine."Item No.");
                        IF ReservationEntry.FINDFIRST THEN BEGIN
                            REPEAT
                                ReservationEntry."Item Ledger Entry No." := ItemLedgerEntry."Entry No.";
                                ReservationEntry."Lot No." := InventorySetup."Default Old Lot No.";
                                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                ReservationEntry.MODIFY;
                            UNTIL ReservationEntry.NEXT = 0;
                        END ELSE BEGIN
                            ReservationEntry.INIT;
                            ReservationEntry."Entry No." := EntryNo;
                            ReservationEntry."Item No." := TransferLine."Item No.";
                            ReservationEntry."Location Code" := TransferLine."Transfer-to Code";
                            ReservationEntry.Quantity := TransferLine."Quantity Shipped";
                            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                            ReservationEntry."Source Type" := 5741;
                            ReservationEntry."Source Subtype" := 1;
                            ReservationEntry."Source ID" := TransferLine."Document No.";
                            ReservationEntry.Positive := TRUE;
                            ReservationEntry."Qty. per Unit of Measure" := 1;
                            ReservationEntry."Quantity (Base)" := TransferLine."Quantity Shipped";
                            ReservationEntry."Qty. to Handle (Base)" := TransferLine."Quantity Shipped";
                            ReservationEntry."Qty. to Invoice (Base)" := TransferLine."Quantity Shipped";
                            ReservationEntry."Lot No." := InventorySetup."Default Old Lot No.";
                            ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                            ReservationEntry."Item Ledger Entry No." := ItemLedgerEntry."Entry No.";
                            ReservationEntry."Source Prod. Order Line" := TransferLine."Line No.";
                            ReservationEntry."Source Ref. No." := TransitLine."Line No.";
                            ReservationEntry.INSERT;
                            EntryNo += 1;
                        END;
                    END;
                END;
            UNTIL TransferLine.NEXT = 0;
        END;
    end;

    local procedure Updatecheck()
    var
        AvgCostAdjmtEntryPoint: Record "5804";
    begin
        AvgCostAdjmtEntryPoint.RESET;
        AvgCostAdjmtEntryPoint.SETRANGE("Item No.", 'CPR SC XL FB 2WD PS');
        IF AvgCostAdjmtEntryPoint.FINDSET THEN
            REPEAT
                AvgCostAdjmtEntryPoint."Cost Is Adjusted" := FALSE;
                AvgCostAdjmtEntryPoint.MODIFY;
            UNTIL AvgCostAdjmtEntryPoint.NEXT = 0;
        MESSAGE('Update');
    end;

    [Scope('Internal')]
    procedure GenerateTransferQR(FANo: Code[20])
    var
        FA: Record "5600";
        AccCost: Decimal;
        AccDate: Date;
        Vendor: Code[20];
        FaLedg: Record "5601";
        VendLedg: Record "25";
        QRCode: Code[250];
    begin
        IF FA.GET(FANo) THEN BEGIN
            FaLedg.RESET;
            FaLedg.SETRANGE("FA No.", FANo);
            FaLedg.SETRANGE("FA Posting Type", FaLedg."FA Posting Type"::"Acquisition Cost");
            IF FaLedg.FINDLAST THEN BEGIN
                AccCost := FaLedg.Amount;
                AccDate := FaLedg."Posting Date";
                VendLedg.RESET;
                VendLedg.SETRANGE("Document No.", FaLedg."Document No.");
                IF VendLedg.FINDFIRST THEN
                    Vendor := VendLedg."Vendor No.";
            END;

            QRCode := FANo + '/' +
                      FORMAT(AccCost) + '/' +
                      FORMAT(AccDate) + '/' +
                      Vendor + '/' +
                      FA."Global Dimension 1 Code" + '/' +
                      FA."FA Location Code";

            FA."FA QR Text" := COPYSTR(QRCode, 1, 254);
            FA.MODIFY;

        END;
    end;
}

