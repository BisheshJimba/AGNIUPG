codeunit 25006320 "Item Jnl. Line-Veh. Reserve"
{
    Permissions = TableData 337 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text005: Label 'Codeunit is not initialized correctly.';
        ReservMgt: Codeunit "25006300";
        CreateReservEntry: Codeunit "25006315";
        ReservEngineMgt: Codeunit "25006316";
        Blocked: Boolean;
        SetFromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry";
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromRefNo: Integer;
        SetFromVehicleSerialNo: Code[20];
        SetFromLocationCode: Code[10];

    [Scope('Internal')]
    procedure CreateReservation(var ItemJnlLine: Record "83"; Description: Text[50])
    begin
        IF SetFromType = 0 THEN
            ERROR(Text005);

        ItemJnlLine.TESTFIELD("Item No.");
        ItemJnlLine.TESTFIELD("Posting Date");
        ItemJnlLine.CALCFIELDS(Reserved);

        ItemJnlLine.TESTFIELD("Location Code", SetFromLocationCode);
        ItemJnlLine.TESTFIELD("Vehicle Serial No.", SetFromVehicleSerialNo);


        CreateReservEntry.CreateReservEntryFor(
          DATABASE::"Item Journal Line",
          ItemJnlLine."Entry Type", ItemJnlLine."Journal Template Name",
          ItemJnlLine."Journal Batch Name", ItemJnlLine."Line No.", ItemJnlLine.Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          ItemJnlLine."Item No.", ItemJnlLine."Vehicle Serial No.", ItemJnlLine."Location Code",
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
    procedure FilterReservFor(var FilterReservEntry: Record "25006392"; ItemJnlLine: Record "83")
    begin

        FilterReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
        FilterReservEntry.SETRANGE("Source Subtype", ItemJnlLine."Entry Type");
        FilterReservEntry.SETRANGE("Source ID", ItemJnlLine."Journal Template Name");
        FilterReservEntry.SETRANGE("Source Batch Name", ItemJnlLine."Journal Batch Name");
        FilterReservEntry.SETRANGE("Source Ref. No.", ItemJnlLine."Line No.");
    end;

    [Scope('Internal')]
    procedure FindReservEntry(ItemJnlLine: Record "83"; var ReservEntry: Record "25006392"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, ItemJnlLine);
        EXIT(ReservEntry.FINDLAST);
    end;

    [Scope('Internal')]
    procedure TransferItemJnlToItemLedgEntry(var ItemJnlLine: Record "83"; var ItemLedgEntry: Record "32"; SkipInventory: Boolean)
    var
        OldReservEntry: Record "25006392";
        OldReservEntry2: Record "25006392";
        SkipThisRecord: Boolean;
    begin
        IF NOT FindReservEntry(ItemJnlLine, OldReservEntry) THEN
            EXIT;

        OldReservEntry.Lock;

        ItemLedgEntry.TESTFIELD("Item No.", ItemJnlLine."Item No.");
        ItemLedgEntry.TESTFIELD("Serial No.", ItemJnlLine."Vehicle Serial No.");
        ItemLedgEntry.TESTFIELD("Model Version No.", ItemJnlLine."Model Version No.");

        IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer THEN BEGIN
            ItemLedgEntry.TESTFIELD("Location Code", ItemJnlLine."New Location Code");
        END ELSE BEGIN
            ItemLedgEntry.TESTFIELD("Location Code", ItemJnlLine."Location Code");
        END;


        IF OldReservEntry.FINDSET THEN
            REPEAT
                OldReservEntry.TESTFIELD("Model Version No.", ItemJnlLine."Item No.");
                OldReservEntry.TESTFIELD(OldReservEntry."Vehicle Serial No.", ItemJnlLine."Vehicle Serial No.");

                IF SkipInventory THEN BEGIN
                    OldReservEntry2.GET(OldReservEntry."Entry No.", NOT OldReservEntry.Positive);
                    SkipThisRecord := OldReservEntry2."Source Type" = DATABASE::"Item Ledger Entry";
                END;

                IF NOT SkipThisRecord THEN BEGIN
                    IF ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer THEN BEGIN
                        IF ItemLedgEntry.Quantity < 0 THEN
                            OldReservEntry.TESTFIELD("Location Code", ItemJnlLine."Location Code");
                        CreateReservEntry.SetInbound(TRUE);
                    END ELSE
                        //  OldReservEntry.TESTFIELD("Location Code",ItemJnlLine."Location Code");
                        //(allow to receive VIN if the location in purch. line is different than that of veh. reservation entries)31/05/2013 Agile CP

                        CreateReservEntry.TransferReservEntry(
                    DATABASE::"Item Ledger Entry", 0, '', '', ItemLedgEntry."Entry No.",
                    OldReservEntry);
                END
            UNTIL (OldReservEntry.NEXT = 0);
    end;

    [Scope('Internal')]
    procedure RenameLine(var NewItemJnlLine: Record "83"; var OldItemJnlLine: Record "83")
    begin
        ReservEngineMgt.RenamePointer(DATABASE::"Item Journal Line",
          OldItemJnlLine."Entry Type",
          OldItemJnlLine."Journal Template Name",
          OldItemJnlLine."Journal Batch Name",
          OldItemJnlLine."Line No.",
          NewItemJnlLine."Entry Type",
          NewItemJnlLine."Journal Template Name",
          NewItemJnlLine."Journal Batch Name",
          NewItemJnlLine."Line No.");
    end;

    [Scope('Internal')]
    procedure DeleteLine(var ItemJnlLine: Record "83")
    begin
        IF Blocked THEN
            EXIT;

        ReservMgt.SetItemJnlLine(ItemJnlLine);
        ReservMgt.DeleteReservEntries(TRUE);
        ItemJnlLine.CALCFIELDS("Reserved Qty. (Base)");
    end;

    [Scope('Internal')]
    procedure Block(SetBlocked: Boolean)
    begin
        Blocked := SetBlocked;
    end;
}

