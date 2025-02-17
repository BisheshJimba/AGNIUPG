codeunit 25006317 "Sales Line-Veh. Reserve"
{
    Permissions = TableData 337 = rimd,
                  TableData 99000850 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text003: Label 'must not be filled in when a quantity is reserved';
        Text004: Label 'must not be changed when a quantity is reserved';
        Text005: Label 'Codeunit is not initialized correctly.';
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
        Text105: Label 'Vehicle is not available. It is reserved for another deal.';

    [Scope('Internal')]
    procedure CreateReservation(var SalesLine: Record "37"; Description: Text[50])
    var
        ShipmentDate: Date;
        OutBoundQty: Decimal;
        SignFactor: Integer;
    begin
        IF SetFromType = 0 THEN
            ERROR(Text005);

        SalesLine.TESTFIELD("Line Type", SalesLine."Line Type"::Vehicle);
        SalesLine.TESTFIELD("No.");
        SalesLine.TESTFIELD("Model Version No.");
        SalesLine.TESTFIELD("Location Code", SetFromLocationCode);

        IF (SalesLine."Document Type" = SalesLine."Document Type"::"Return Order") THEN
            SignFactor := 1
        ELSE
            SignFactor := -1;

        CreateReservEntry.CreateReservEntryFor(
          DATABASE::"Sales Line", SalesLine."Document Type",
          SalesLine."Document No.", '', SalesLine."Line No.", SalesLine.Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          SalesLine."No.", SalesLine."Vehicle Serial No.", SalesLine."Location Code",
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
    procedure FilterReservFor(var FilterReservEntry: Record "25006392"; SalesLine: Record "37")
    begin
        FilterReservEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        FilterReservEntry.SETRANGE("Source Subtype", SalesLine."Document Type");
        FilterReservEntry.SETRANGE("Source ID", SalesLine."Document No.");
        FilterReservEntry.SETRANGE("Source Batch Name", '');
        FilterReservEntry.SETRANGE("Source Ref. No.", SalesLine."Line No.");
    end;

    [Scope('Internal')]
    procedure ReservQuantity(SalesLine: Record "37") QtyToReserve: Decimal
    begin
        CASE SalesLine."Document Type" OF
            SalesLine."Document Type"::Quote,
          SalesLine."Document Type"::Order,
          SalesLine."Document Type"::Invoice,
          SalesLine."Document Type"::"Blanket Order":
                QtyToReserve := SalesLine."Outstanding Qty. (Base)";
            SalesLine."Document Type"::"Return Order",
          SalesLine."Document Type"::"Credit Memo":
                QtyToReserve := -SalesLine."Outstanding Qty. (Base)"
        END;
    end;

    [Scope('Internal')]
    procedure FindReservEntry(SalesLine: Record "37"; var ReservEntry: Record "25006392"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, SalesLine);
        EXIT(ReservEntry.FINDLAST);
    end;

    [Scope('Internal')]
    procedure VerifyChange(var NewSalesLine: Record "37"; var OldSalesLine: Record "37")
    var
        SalesLine: Record "37";
        TempReservEntry: Record "25006392";
        ShowError: Boolean;
        HasError: Boolean;
    begin

        IF (NewSalesLine.Type <> NewSalesLine.Type::Item) AND (OldSalesLine.Type <> OldSalesLine.Type::Item) THEN
            EXIT;

        IF (NewSalesLine."Line Type" <> NewSalesLine."Line Type"::Vehicle) AND
           (OldSalesLine."Line Type" <> OldSalesLine."Line Type"::Vehicle) THEN
            EXIT;

        IF Blocked THEN
            EXIT;

        IF NewSalesLine."Line No." = 0 THEN
            IF NOT SalesLine.GET(
                     NewSalesLine."Document Type", NewSalesLine."Document No.", NewSalesLine."Line No.")
            THEN
                EXIT;

        NewSalesLine.CALCFIELDS(Reserved);
        ShowError := NewSalesLine.Reserved;

        IF (NewSalesLine."Purchase Order No." <> '') THEN
            IF ShowError THEN
                NewSalesLine.FIELDERROR("Purchase Order No.", Text003)
            ELSE
                HasError := NewSalesLine."Purchase Order No." <> OldSalesLine."Purchase Order No.";

        IF (NewSalesLine."Purch. Order Line No." <> 0) THEN
            IF ShowError THEN
                NewSalesLine.FIELDERROR(
                  "Purch. Order Line No.", Text003)
            ELSE
                HasError := NewSalesLine."Purch. Order Line No." <> OldSalesLine."Purch. Order Line No.";

        IF NewSalesLine."Drop Shipment" <> OldSalesLine."Drop Shipment" THEN
            IF ShowError AND NewSalesLine."Drop Shipment" THEN
                NewSalesLine.FIELDERROR("Drop Shipment", Text003)
            ELSE
                HasError := TRUE;

        IF (NewSalesLine."No." <> OldSalesLine."No.") THEN
            IF ShowError THEN
                NewSalesLine.FIELDERROR("No.", Text004)
            ELSE
                HasError := TRUE;

        IF (NewSalesLine."Vehicle Serial No." <> OldSalesLine."Vehicle Serial No.") THEN
            IF ShowError THEN
                NewSalesLine.FIELDERROR("Variant Code", Text004)
            ELSE
                HasError := TRUE;

        IF (NewSalesLine."Location Code" <> OldSalesLine."Location Code") THEN
            IF ShowError THEN
                NewSalesLine.FIELDERROR("Location Code", Text004)
            ELSE
                HasError := TRUE;

        IF NewSalesLine."Line No." <> OldSalesLine."Line No." THEN
            HasError := TRUE;

        IF HasError THEN
            IF (NewSalesLine."No." <> OldSalesLine."No.") OR
               FindReservEntry(NewSalesLine, TempReservEntry)
            THEN BEGIN
                IF (NewSalesLine."No." <> OldSalesLine."No.") THEN BEGIN
                    ReservMgt.SetSalesLine(OldSalesLine);
                    ReservMgt.DeleteReservEntries(TRUE);
                    ReservMgt.SetSalesLine(NewSalesLine);
                END ELSE BEGIN
                    ReservMgt.SetSalesLine(NewSalesLine);
                    ReservMgt.DeleteReservEntries(TRUE);
                END;
            END;
    end;

    [Scope('Internal')]
    procedure VerifyQuantity(var NewSalesLine: Record "37"; var OldSalesLine: Record "37")
    var
        SalesLine: Record "37";
    begin

        IF Blocked THEN
            EXIT;

        IF NOT (NewSalesLine."Document Type" IN
        [NewSalesLine."Document Type"::Quote, NewSalesLine."Document Type"::Order, NewSalesLine."Document Type"::"Return Order"])
THEN
            IF NewSalesLine."Shipment No." = '' THEN
                EXIT;
        IF NewSalesLine.Type <> NewSalesLine.Type::Item THEN
            EXIT;
        IF NewSalesLine."Line No." = OldSalesLine."Line No." THEN
            IF NewSalesLine."Quantity (Base)" = OldSalesLine."Quantity (Base)" THEN
                EXIT;
        IF NewSalesLine."Line No." = 0 THEN
            IF NOT SalesLine.GET(NewSalesLine."Document Type", NewSalesLine."Document No.", NewSalesLine."Line No.") THEN
                EXIT;
        ReservMgt.SetSalesLine(NewSalesLine);
        IF NewSalesLine."Outstanding Qty. (Base)" * OldSalesLine."Outstanding Qty. (Base)" < 0 THEN
            ReservMgt.DeleteReservEntries(TRUE)
        ELSE
            ReservMgt.DeleteReservEntries(FALSE);
    end;

    [Scope('Internal')]
    procedure TransferSalesLineToItemJnlLine(var SalesLine: Record "37"; var ItemJnlLine: Record "83")
    var
        OldReservEntry: Record "25006392";
        OldReservEntry2: Record "25006392";
    begin

        IF NOT FindReservEntry(SalesLine, OldReservEntry) THEN
            EXIT;
        OldReservEntry.Lock;

        ItemJnlLine.TESTFIELD("Item No.", SalesLine."No.");
        ItemJnlLine.TESTFIELD("Model Version No.", SalesLine."Model Version No.");
        ItemJnlLine.TESTFIELD("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
        ItemJnlLine.TESTFIELD("Location Code", SalesLine."Location Code");


        IF ItemJnlLine."Invoiced Quantity" <> 0 THEN
            CreateReservEntry.SetUseQtyToInvoice(TRUE);

        OldReservEntry2 := OldReservEntry;

        IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN
            REPEAT
                OldReservEntry.TESTFIELD("Model Version No.", SalesLine."No.");
                OldReservEntry.TESTFIELD(OldReservEntry."Vehicle Serial No.", SalesLine."Vehicle Serial No.");
                OldReservEntry.TESTFIELD("Location Code", SalesLine."Location Code");

                OldReservEntry2.GET(OldReservEntry."Entry No.", NOT OldReservEntry.Positive);
                CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
                   ItemJnlLine."Entry Type", ItemJnlLine."Journal Template Name",
                   ItemJnlLine."Journal Batch Name", ItemJnlLine."Line No.",
                   OldReservEntry);

            UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0);
    end;

    [Scope('Internal')]
    procedure RenameLine(var NewSalesLine: Record "37"; var OldSalesLine: Record "37")
    begin
        ReservEngineMgt.RenamePointer(DATABASE::"Sales Line",
          OldSalesLine."Document Type",
          OldSalesLine."Document No.",
          '',
          OldSalesLine."Line No.",
          NewSalesLine."Document Type",
          NewSalesLine."Document No.",
          '',
          NewSalesLine."Line No.");
    end;

    [Scope('Internal')]
    procedure DeleteLine(var SalesLine: Record "37")
    begin
        ReservMgt.SetSalesLine(SalesLine);
        ReservMgt.DeleteReservEntries(TRUE);
        SalesLine.CALCFIELDS(Reserved);
    end;

    [Scope('Internal')]
    procedure Block(SetBlocked: Boolean)
    begin
        Blocked := SetBlocked;
    end;

    [Scope('Internal')]
    procedure CheckReservation(var SalesLine: Record "37")
    var
        ItemLedgerEntry: Record "32";
        ReservationEntry: Record "25006392";
        ReservationEntry2: Record "25006392";
    begin
        IF SalesLine."Document Type" IN [SalesLine."Document Type"::"Credit Memo", SalesLine."Document Type"::"Return Order"] THEN
            EXIT;

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive,
        "Location Code", "Posting Date", "Expiration Date", "Lot No.", "Serial No.");
        ItemLedgerEntry.SETRANGE("Item No.", SalesLine."No.");
        ItemLedgerEntry.SETRANGE("Serial No.", SalesLine."Vehicle Serial No.");
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        IF NOT ItemLedgerEntry.FINDFIRST THEN
            EXIT;

        ItemLedgerEntry.CALCFIELDS(Reserved);
        IF NOT ItemLedgerEntry.Reserved THEN
            EXIT;

        ReservationEntry.RESET;
        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Item Ledger Entry");
        ReservationEntry.SETRANGE("Source Ref. No.", ItemLedgerEntry."Entry No.");
        ReservationEntry.FINDFIRST;
        ReservationEntry2.GET(ReservationEntry."Entry No.", NOT ReservationEntry.Positive);
        IF (ReservationEntry2."Source Type" <> DATABASE::"Sales Line") OR
           (ReservationEntry2."Source Subtype" <> SalesLine."Document Type") OR
           (ReservationEntry2."Source ID" <> SalesLine."Document No.") OR
           (ReservationEntry2."Source Ref. No." <> SalesLine."Line No.") THEN
            ERROR(Text105);
    end;
}

