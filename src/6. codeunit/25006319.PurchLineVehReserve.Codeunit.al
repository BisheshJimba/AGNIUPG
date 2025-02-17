codeunit 25006319 "Purch. Line-Veh. Reserve"
{
    Permissions = TableData 337 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text004: Label 'Codeunit is not initialized correctly.';
        Location: Record "14";
        CreateReservEntry: Codeunit "25006315";
        ReservEngineMgt: Codeunit "25006316";
        ReservMgt: Codeunit "25006300";
        Blocked: Boolean;
        SetFromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry";
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromRefNo: Integer;
        SetFromLocationCode: Code[10];

    [Scope('Internal')]
    procedure CreateReservation(var PurchLine: Record "39"; Description: Text[50])
    var
        ShipmentDate: Date;
        OutBoundQty: Decimal;
        SignFactor: Integer;
    begin
        IF SetFromType = 0 THEN
            ERROR(Text004);

        PurchLine.TESTFIELD("Line Type", PurchLine."Line Type"::Vehicle);
        PurchLine.TESTFIELD("No.");
        PurchLine.TESTFIELD("Model Version No.");

        PurchLine.TESTFIELD("Location Code", SetFromLocationCode);

        IF (PurchLine."Document Type" = PurchLine."Document Type"::"Return Order") THEN
            SignFactor := -1
        ELSE
            SignFactor := 1;

        CreateReservEntry.CreateReservEntryFor(
          DATABASE::"Purchase Line", PurchLine."Document Type",
          PurchLine."Document No.", '', PurchLine."Line No.", PurchLine.Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          PurchLine."No.", PurchLine."Variant Code", PurchLine."Location Code",
          Description);

        SetFromType := 0;
    end;

    [Scope('Internal')]
    procedure CreateReservationSetFrom(FromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry"; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromRefNo: Integer; FromLocationCode: Code[10])
    begin
        SetFromType := FromType;
        SetFromSubtype := FromSubtype;
        SetFromID := FromID;
        SetFromBatchName := FromBatchName;
        SetFromRefNo := FromRefNo;
        SetFromLocationCode := FromLocationCode;
    end;

    [Scope('Internal')]
    procedure FilterReservFor(var FilterReservEntry: Record "25006392"; PurchLine: Record "39")
    begin
        FilterReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
        FilterReservEntry.SETRANGE("Source Subtype", PurchLine."Document Type");
        FilterReservEntry.SETRANGE("Source ID", PurchLine."Document No.");
        FilterReservEntry.SETRANGE("Source Batch Name", '');
        FilterReservEntry.SETRANGE("Source Ref. No.", PurchLine."Line No.");
    end;

    [Scope('Internal')]
    procedure ReservQuantity(PurchLine: Record "39") QtyToReserve: Decimal
    begin
        CASE PurchLine."Document Type" OF
            PurchLine."Document Type"::Quote,
          PurchLine."Document Type"::Order,
          PurchLine."Document Type"::Invoice,
          PurchLine."Document Type"::"Blanket Order":
                QtyToReserve := -PurchLine."Outstanding Qty. (Base)";
            PurchLine."Document Type"::"Return Order",
          PurchLine."Document Type"::"Credit Memo":
                QtyToReserve := PurchLine."Outstanding Qty. (Base)";
        END;
    end;

    [Scope('Internal')]
    procedure FindReservEntry(PurchLine: Record "39"; var ReservEntry: Record "25006392"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, PurchLine);
        EXIT(ReservEntry.FINDLAST);
    end;

    [Scope('Internal')]
    procedure TransferPurchLineToItemJnlLine(var PurchLine: Record "39"; var ItemJnlLine: Record "83")
    var
        OldReservEntry: Record "25006392";
    begin
        IF NOT FindReservEntry(PurchLine, OldReservEntry) THEN
            EXIT;

        OldReservEntry.Lock;


        ItemJnlLine.TESTFIELD("Item No.", PurchLine."No.");
        ItemJnlLine.TESTFIELD("Model Version No.", PurchLine."Model Version No.");
        ItemJnlLine.TESTFIELD("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
        ItemJnlLine.TESTFIELD("Location Code", PurchLine."Location Code");


        IF ItemJnlLine."Invoiced Quantity" <> 0 THEN
            CreateReservEntry.SetUseQtyToInvoice(TRUE);

        IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN
            REPEAT
                OldReservEntry.TESTFIELD("Model Version No.", PurchLine."No.");
                OldReservEntry.TESTFIELD(OldReservEntry."Vehicle Serial No.", PurchLine."Vehicle Serial No.");
                // OldReservEntry.TESTFIELD("Location Code",PurchLine."Location Code");
                // (allow to receive VIN even if location in purch. line is different from that in veh. reservation entries)-05/31/2013 Agile (CP)

                CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
                  ItemJnlLine."Entry Type", ItemJnlLine."Journal Template Name",
                  ItemJnlLine."Journal Batch Name", ItemJnlLine."Line No.",
                  OldReservEntry);

            UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0);
    end;

    [Scope('Internal')]
    procedure TransferPurchLineToPurchLine(var OldPurchLine: Record "39"; var NewPurchLine: Record "39")
    var
        OldReservEntry: Record "25006392";
    begin
        IF NOT FindReservEntry(OldPurchLine, OldReservEntry) THEN
            EXIT;

        OldReservEntry.Lock;

        NewPurchLine.TESTFIELD("No.", OldPurchLine."No.");
        NewPurchLine.TESTFIELD("Model Version No.", OldPurchLine."Model Version No.");
        NewPurchLine.TESTFIELD("Vehicle Serial No.", OldPurchLine."Vehicle Serial No.");
        NewPurchLine.TESTFIELD("Location Code", OldPurchLine."Location Code");


        IF OldReservEntry.FINDSET THEN
            REPEAT
                OldReservEntry.TESTFIELD(OldReservEntry."Model Version No.", OldPurchLine."Model Version No.");
                OldReservEntry.TESTFIELD(OldReservEntry."Vehicle Serial No.", OldPurchLine."Vehicle Serial No.");
                OldReservEntry.TESTFIELD("Location Code", OldPurchLine."Location Code");

                CreateReservEntry.TransferReservEntry(DATABASE::"Purchase Line",
                   NewPurchLine."Document Type", NewPurchLine."Document No.", '', NewPurchLine."Line No.",
                   OldReservEntry);

            UNTIL (OldReservEntry.NEXT = 0);
    end;

    [Scope('Internal')]
    procedure RenameLine(var NewPurchLine: Record "39"; var OldPurchLine: Record "39")
    begin
        ReservEngineMgt.RenamePointer(DATABASE::"Purchase Line",
          OldPurchLine."Document Type",
          OldPurchLine."Document No.",
          '',
          OldPurchLine."Line No.",
          NewPurchLine."Document Type",
          NewPurchLine."Document No.",
          '',
          NewPurchLine."Line No.");
    end;

    [Scope('Internal')]
    procedure DeleteLine(var PurchLine: Record "39")
    begin
        IF Blocked THEN
            EXIT;

        ReservMgt.SetPurchLine(PurchLine);
        ReservMgt.DeleteReservEntries(TRUE);
        PurchLine.CALCFIELDS(Reserved);
    end;

    [Scope('Internal')]
    procedure Block(SetBlocked: Boolean)
    begin
        Blocked := SetBlocked;
    end;
}

