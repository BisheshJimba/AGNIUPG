codeunit 25006300 "Veh. Reservation Management"
{
    Permissions = TableData 32 = rm,
                  TableData 25006392 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text003: Label 'CU99000845: CalculateRemainingQty - Source type missing';
        Text006: Label 'Outbound,Inbound';
        CalcReservEntry: Record "25006392";
        CalcReservEntry2: Record "25006392";
        ForItemLedgEntry: Record "32";
        CalcItemLedgEntry: Record "32";
        ForSalesLine: Record "37";
        CalcSalesLine: Record "37";
        ForPurchLine: Record "39";
        CalcPurchLine: Record "39";
        ForItemJnlLine: Record "83";
        ForReqLine: Record "246";
        CalcReqLine: Record "246";
        ForTransLine: Record "5741";
        CalcTransLine: Record "5741";
        ModelVersion: Record "27";
        Location: Record "14";
        CreateReservEntry: Codeunit "25006315";
        ReservEngineMgt: Codeunit "25006316";
        ReserveSalesLine: Codeunit "25006317";
        ReserveReqLine: Codeunit "25006318";
        ReservePurchLine: Codeunit "25006319";
        ReserveItemJnlLine: Codeunit "25006320";
        ReserveTransLine: Codeunit "25006321";
        Positive: Boolean;
        FieldFilter: Text[80];
        ValueArray: array[18] of Integer;
        CurrentBinding: Option ,"Order-to-Order";

    [Scope('Internal')]
    procedure IsPositive(): Boolean
    begin
        EXIT(Positive);
    end;

    [Scope('Internal')]
    procedure FormatQty(Quantity: Decimal): Decimal
    begin
        IF Positive THEN
            EXIT(Quantity);

        EXIT(-Quantity);
    end;

    [Scope('Internal')]
    procedure SetSalesLine(NewSalesLine: Record "37")
    begin
        CLEARALL;

        ForSalesLine := NewSalesLine;

        CalcReservEntry."Source Type" := DATABASE::"Sales Line";
        CalcReservEntry."Source Subtype" := ForSalesLine."Document Type";
        CalcReservEntry."Source ID" := NewSalesLine."Document No.";
        CalcReservEntry."Source Ref. No." := NewSalesLine."Line No.";

        CalcReservEntry."Model Version No." := NewSalesLine."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewSalesLine."Vehicle Serial No.";

        CalcReservEntry."Location Code" := NewSalesLine."Location Code";

        CalcReservEntry.Description := NewSalesLine.Description;
        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForSalesLine."Outstanding Qty. (Base)") <= 0);
        GetModelVersionSetup(CalcReservEntry);

        SetPointerFilter(CalcReservEntry2);
    end;

    [Scope('Internal')]
    procedure SetReqLine(NewReqLine: Record "246")
    begin

        CLEARALL;

        ForReqLine := NewReqLine;

        CalcReservEntry."Source Type" := DATABASE::"Requisition Line";
        CalcReservEntry."Source ID" := NewReqLine."Worksheet Template Name";
        CalcReservEntry."Source Batch Name" := NewReqLine."Journal Batch Name";
        CalcReservEntry."Source Ref. No." := NewReqLine."Line No.";

        CalcReservEntry."Model Version No." := NewReqLine."No.";
        CalcReservEntry."Vehicle Serial No." := NewReqLine."Vehicle Serial No.";

        CalcReservEntry."Location Code" := NewReqLine."Location Code";
        CalcReservEntry.Description := NewReqLine.Description;

        CalcReservEntry2 := CalcReservEntry;

        Positive := ForReqLine."Net Quantity (Base)" < 0;

        GetModelVersionSetup(CalcReservEntry);

        SetPointerFilter(CalcReservEntry2);
    end;

    [Scope('Internal')]
    procedure SetPurchLine(NewPurchLine: Record "39")
    begin
        CLEARALL;
        ForPurchLine := NewPurchLine;

        CalcReservEntry."Source Type" := DATABASE::"Purchase Line";
        CalcReservEntry."Source Subtype" := ForPurchLine."Document Type";
        CalcReservEntry."Source ID" := NewPurchLine."Document No.";
        CalcReservEntry."Source Ref. No." := NewPurchLine."Line No.";

        CalcReservEntry."Model Version No." := NewPurchLine."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewPurchLine."Vehicle Serial No.";
        CalcReservEntry."Location Code" := NewPurchLine."Location Code";

        CalcReservEntry.Description := NewPurchLine.Description;

        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForPurchLine."Outstanding Qty. (Base)") < 0);

        SetPointerFilter(CalcReservEntry2);
    end;

    [Scope('Internal')]
    procedure SetItemJnlLine(NewItemJnlLine: Record "83")
    begin
        CLEARALL;
        ForItemJnlLine := NewItemJnlLine;

        CalcReservEntry."Source Type" := DATABASE::"Item Journal Line";
        CalcReservEntry."Source Subtype" := ForItemJnlLine."Entry Type";
        CalcReservEntry."Source ID" := NewItemJnlLine."Journal Template Name";
        CalcReservEntry."Source Batch Name" := NewItemJnlLine."Journal Batch Name";
        CalcReservEntry."Source Ref. No." := NewItemJnlLine."Line No.";

        CalcReservEntry."Model Version No." := NewItemJnlLine."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewItemJnlLine."Vehicle Serial No.";
        CalcReservEntry."Location Code" := NewItemJnlLine."Location Code";

        CalcReservEntry.Description := NewItemJnlLine.Description;

        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForItemJnlLine."Quantity (Base)") < 0);

        SetPointerFilter(CalcReservEntry2);
    end;

    [Scope('Internal')]
    procedure SetItemLedgEntry(NewItemLedgEntry: Record "32")
    begin
        CLEARALL;

        ForItemLedgEntry := NewItemLedgEntry;

        CalcReservEntry."Source Type" := DATABASE::"Item Ledger Entry";
        CalcReservEntry."Source Ref. No." := NewItemLedgEntry."Entry No.";

        CalcReservEntry."Model Version No." := NewItemLedgEntry."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewItemLedgEntry."Serial No.";
        CalcReservEntry."Location Code" := NewItemLedgEntry."Location Code";

        CalcReservEntry.Description := NewItemLedgEntry.Description;

        Positive := ForItemLedgEntry."Remaining Quantity" <= 0;

        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        SetPointerFilter(CalcReservEntry2);
    end;

    [Scope('Internal')]
    procedure SetTransferLine(NewTransLine: Record "5741"; Direction: Option Outbound,Inbound)
    begin
        CLEARALL;

        ForTransLine := NewTransLine;

        CalcReservEntry."Source Type" := DATABASE::"Transfer Line";
        CalcReservEntry."Source Subtype" := Direction;
        CalcReservEntry."Source ID" := NewTransLine."Document No.";
        CalcReservEntry."Source Ref. No." := NewTransLine."Line No.";

        CalcReservEntry."Model Version No." := NewTransLine."Model Version No.";
        CalcReservEntry."Vehicle Serial No." := NewTransLine."Vehicle Serial No.";
        CASE Direction OF
            Direction::Outbound:
                BEGIN
                    CalcReservEntry."Location Code" := NewTransLine."Transfer-from Code";
                END;
            Direction::Inbound:
                BEGIN
                    CalcReservEntry."Location Code" := NewTransLine."Transfer-to Code";
                END;

        END;

        CalcReservEntry.Description := NewTransLine.Description;
        CalcReservEntry2 := CalcReservEntry;

        GetModelVersionSetup(CalcReservEntry);

        Positive :=
          ((CreateReservEntry.SignFactor(CalcReservEntry) * ForTransLine."Outstanding Qty. (Base)") <= 0);
        GetModelVersionSetup(CalcReservEntry);

        SetPointerFilter(CalcReservEntry2);
    end;

    [Scope('Internal')]
    procedure UpdateStatistics(var ReservSummEntry: Record "25006393")
    var
        ReservEntry: Record "25006392";
        i: Integer;
        CurrentEntryNo: Integer;
        ValueArrayNo: Integer;
        CalcSumValue: Decimal;
        CurrReservedQty: Decimal;
        NewEntryNo: Integer;
        ReservForm: Page "25006529";
    begin

        CurrentEntryNo := ReservSummEntry.Sequence;
        CalcReservEntry.TESTFIELD("Source Type");
        ReservSummEntry.DELETEALL;
        NewEntryNo := 0;

        FOR i := 1 TO SetValueArray DO BEGIN
            CalcSumValue := 0;

            CASE ValueArray[i] OF
                1: // Item Ledger Entry
                    IF CalcItemLedgEntry.READPERMISSION
                    THEN BEGIN
                        InitFilter(ValueArray[i]);
                        IF CalcItemLedgEntry.FINDSET THEN
                            REPEAT
                                CalcItemLedgEntry.CALCFIELDS(Reserved);
                                CalcSumValue := CalcItemLedgEntry."Remaining Quantity";
                                IF CalcSumValue <> 0 THEN
                                    IF (CalcSumValue > 0) = Positive THEN BEGIN
                                        CLEAR(ReservForm);
                                        ReservForm.SetReservEntry(CalcReservEntry);
                                        //CurrReservedQty := ReservForm.ReservedThisLine(ReservSummEntry);

                                        ReservSummEntry.INIT;
                                        NewEntryNo += 1;
                                        ReservSummEntry."Entry No." := NewEntryNo;
                                        ReservSummEntry.Sequence := ValueArray[i];
                                        ReservSummEntry."Source Type" := DATABASE::"Item Ledger Entry";
                                        ReservSummEntry."Source Ref. No." := CalcItemLedgEntry."Entry No.";
                                        ReservSummEntry.Description :=
                                         COPYSTR(CalcItemLedgEntry.TABLECAPTION, 1, MAXSTRLEN(ReservSummEntry.Description));
                                        ReservSummEntry.INSERT;
                                    END;
                            UNTIL CalcItemLedgEntry.NEXT = 0;
                    END;
                12, 16: // Purchase Order, Purchase Return Order
                    IF CalcPurchLine.READPERMISSION
                    THEN BEGIN
                        InitFilter(ValueArray[i]);
                        IF CalcPurchLine.FINDSET THEN
                            REPEAT
                                CalcPurchLine.CALCFIELDS(Reserved);
                                CalcSumValue := CalcPurchLine."Outstanding Qty. (Base)";
                                IF CalcSumValue <> 0 THEN
                                    IF (Positive = (CalcSumValue > 0)) AND (ValueArray[i] <> 16) OR
                                       (Positive = (CalcSumValue < 0)) AND (ValueArray[i] = 16)
                                    THEN BEGIN
                                        ReservSummEntry.INIT;
                                        NewEntryNo += 1;
                                        ReservSummEntry."Entry No." := NewEntryNo;
                                        ReservSummEntry.Sequence := ValueArray[i];
                                        ReservSummEntry."Source Type" := DATABASE::"Purchase Line";
                                        ReservSummEntry."Source Subtype" := CalcPurchLine."Document Type";
                                        ReservSummEntry."Source ID" := CalcPurchLine."Document No.";
                                        ReservSummEntry."Source Ref. No." := CalcPurchLine."Line No.";
                                        ReservSummEntry.Description :=
                                           COPYSTR(
                                             STRSUBSTNO('%1, %2', CalcPurchLine.TABLECAPTION, CalcPurchLine."Document Type"),
                                             1, MAXSTRLEN(ReservSummEntry.Description));
                                        ReservSummEntry.INSERT;
                                    END;
                            UNTIL CalcPurchLine.NEXT = 0;
                    END;
                32, 36: // Sales Order, Sales Return Order
                    IF CalcSalesLine.READPERMISSION
                    THEN BEGIN
                        InitFilter(ValueArray[i]);
                        IF CalcSalesLine.FINDSET THEN
                            REPEAT
                                CalcSalesLine.CALCFIELDS(Reserved);
                                CalcSumValue := CalcSalesLine."Outstanding Qty. (Base)";
                                IF CalcSumValue <> 0 THEN
                                    IF (Positive = (CalcSumValue < 0)) AND (ValueArray[i] <> 36) OR
                                       (Positive = (CalcSumValue > 0)) AND (ValueArray[i] = 36)
                                    THEN BEGIN
                                        ReservSummEntry.INIT;
                                        NewEntryNo += 1;
                                        ReservSummEntry."Entry No." := NewEntryNo;
                                        ReservSummEntry.Sequence := ValueArray[i];
                                        ReservSummEntry."Source Type" := DATABASE::"Sales Line";
                                        ReservSummEntry."Source Subtype" := CalcSalesLine."Document Type";
                                        ReservSummEntry."Source ID" := CalcSalesLine."Document No.";
                                        ReservSummEntry."Source Ref. No." := CalcSalesLine."Line No.";

                                        ReservSummEntry.Description :=
                                          COPYSTR(
                                            STRSUBSTNO('%1, %2', CalcSalesLine.TABLECAPTION, CalcSalesLine."Document Type"),
                                            1, MAXSTRLEN(ReservSummEntry.Description));
                                        ReservSummEntry.INSERT;
                                    END;
                            UNTIL CalcSalesLine.NEXT = 0;

                    END;
                101, 102: // Transfer Line
                    IF CalcTransLine.READPERMISSION THEN BEGIN
                        InitFilter(ValueArray[i]);
                        IF CalcTransLine.FINDSET THEN
                            REPEAT
                                CASE ValueArray[i] OF
                                    101:
                                        BEGIN
                                            CalcTransLine.CALCFIELDS("Reserved Outbound");
                                            CalcSumValue := -CalcTransLine."Outstanding Qty. (Base)";
                                        END;
                                    102:
                                        BEGIN
                                            CalcTransLine.CALCFIELDS("Reserved Inbound");
                                            CalcSumValue := CalcTransLine."Outstanding Qty. (Base)";
                                        END;
                                END;
                                IF CalcSumValue <> 0 THEN
                                    IF (CalcSumValue > 0) = Positive THEN BEGIN
                                        ReservSummEntry.INIT;
                                        NewEntryNo += 1;
                                        ReservSummEntry."Entry No." := NewEntryNo;
                                        ReservSummEntry.Sequence := ValueArray[i];
                                        ReservSummEntry."Source Type" := DATABASE::"Transfer Line";
                                        ReservSummEntry."Source ID" := CalcTransLine."Document No.";
                                        ReservSummEntry."Source Ref. No." := CalcTransLine."Line No.";

                                        ReservSummEntry.Description :=
                                          COPYSTR(
                                            STRSUBSTNO('%1, %2', CalcTransLine.TABLECAPTION, SELECTSTR(ValueArray[i] - 100, Text006)),
                                            1, MAXSTRLEN(ReservSummEntry.Description));
                                        ReservSummEntry.INSERT;
                                    END;
                            UNTIL CalcTransLine.NEXT = 0;
                    END;
            END;
        END;
        IF NOT ReservSummEntry.GET(CurrentEntryNo) THEN;
    end;

    [Scope('Internal')]
    procedure AutoReserve(var FullAutoReservation: Boolean; Description: Text[50]; MaxQtyToReserve: Decimal)
    var
        ReservSummEntry: Record "25006393" temporary;
        RemainingQtyToReserve: Decimal;
        i: Integer;
        StopReservation: Boolean;
    begin
        CalcReservEntry.TESTFIELD("Source Type");

        IF CalcReservEntry."Source Type" IN [DATABASE::"Sales Line", DATABASE::"Purchase Line"] THEN
            StopReservation := NOT (CalcReservEntry."Source Subtype" IN [1, 5]); // Only order and return order

        IF (CalcReservEntry."Source Type" = DATABASE::"Sales Line") THEN
            IF ((CalcReservEntry."Source Subtype" = 1) AND (ForSalesLine.Quantity < 0)) THEN
                StopReservation := TRUE;

        IF (CalcReservEntry."Source Type" = DATABASE::"Sales Line") THEN
            IF ((CalcReservEntry."Source Subtype" = 5) AND (ForSalesLine.Quantity >= 0)) THEN
                StopReservation := TRUE;

        IF StopReservation THEN BEGIN
            FullAutoReservation := TRUE;
            EXIT;
        END;

        RemainingQtyToReserve := CalculateRemainingQty;
        IF (MaxQtyToReserve <> 0) AND (ABS(MaxQtyToReserve) < ABS(RemainingQtyToReserve)) THEN
            RemainingQtyToReserve := MaxQtyToReserve;

        FullAutoReservation := FALSE;

        IF RemainingQtyToReserve = 0 THEN BEGIN
            FullAutoReservation := TRUE;
            EXIT;
        END;

        UpdateStatistics(ReservSummEntry);
        IF ReservSummEntry.FINDFIRST THEN BEGIN
            AutoReserveOneLine(ReservSummEntry);
            RemainingQtyToReserve := 0;
        END;

        FullAutoReservation := (RemainingQtyToReserve = 0);
    end;

    [Scope('Internal')]
    procedure AutoReserveOneLine(var ReservSummEntry: Record "25006393")
    var
        ModelVersion: Record "27";
        LocationCode: Code[10];
        Reserved: Boolean;
    begin
        CalcReservEntry.TESTFIELD("Source Type");

        ReservSummEntry.CALCFIELDS(Reserved);
        IF ReservSummEntry.Reserved THEN
            EXIT;

        IF NOT ModelVersion.GET(CalcReservEntry."Model Version No.") THEN
            CLEAR(ModelVersion);
        IF NOT Location.GET(CalcReservEntry."Location Code") THEN
            CLEAR(Location);

        CalcReservEntry.Lock;

        CASE ReservSummEntry.Sequence OF
            1:
                BEGIN // Item Ledger Entry
                    CalcItemLedgEntry.GET(ReservSummEntry."Source Ref. No.");
                    CalcItemLedgEntry.CALCFIELDS(Reserved);
                    IF NOT CalcItemLedgEntry.Reserved THEN
                        CreateReservation(
                          '',
                          DATABASE::"Item Ledger Entry", 0, '', '',
                          CalcItemLedgEntry."Entry No.",
                          CalcItemLedgEntry."Location Code");

                END;
            12, 16:
                BEGIN // Purchase Line, Purchase Return Line
                    CalcPurchLine.GET(ReservSummEntry."Source Subtype", ReservSummEntry."Source ID", ReservSummEntry."Source Ref. No.");
                    CalcPurchLine.CALCFIELDS(Reserved);
                    IF NOT CalcPurchLine.Reserved THEN
                        CreateReservation(
                          '',
                          DATABASE::"Purchase Line",
                          CalcPurchLine."Document Type", CalcPurchLine."Document No.", '',
                          CalcPurchLine."Line No.",
                          CalcPurchLine."Location Code");
                END;
            21:
                BEGIN // Requisition Line

                END;
            31, 32, 36:
                BEGIN // Sales Line, Sales Return Line
                    CalcSalesLine.GET(ReservSummEntry."Source Subtype", ReservSummEntry."Source ID", ReservSummEntry."Source Ref. No.");
                    CalcSalesLine.CALCFIELDS(Reserved);
                    IF NOT CalcSalesLine.Reserved THEN
                        CreateReservation(
                          '',
                          DATABASE::"Sales Line",
                          CalcSalesLine."Document Type", CalcSalesLine."Document No.", '',
                          CalcSalesLine."Line No.",
                          CalcSalesLine."Location Code");
                END;
            101, 102:
                BEGIN // Transfer
                    CalcTransLine.GET(ReservSummEntry."Source Subtype", ReservSummEntry."Source ID", ReservSummEntry."Source Ref. No.");

                    CASE ReservSummEntry.Sequence OF
                        101: // Outbound
                            BEGIN
                                CalcTransLine.CALCFIELDS(CalcTransLine."Reserved Outbound");
                                LocationCode := CalcTransLine."Transfer-from Code";
                                Reserved := CalcTransLine."Reserved Outbound";
                            END;
                        102: // Inbound
                            BEGIN
                                CalcTransLine.CALCFIELDS(CalcTransLine."Reserved Inbound");
                                LocationCode := CalcTransLine."Transfer-to Code";
                                Reserved := CalcTransLine."Reserved Inbound";
                            END;
                    END;

                    IF NOT Reserved THEN
                        CreateReservation(
                          '',
                          DATABASE::"Transfer Line",
                          ReservSummEntry.Sequence - 101,
                          CalcTransLine."Document No.", '',
                          CalcTransLine."Line No.",
                          LocationCode);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure CreateReservation(Description: Text[50]; FromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal"; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromRefNo: Integer; FromLocationCode: Code[10])
    begin
        CalcReservEntry.TESTFIELD("Source Type");

        CASE CalcReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    ReserveSalesLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReserveSalesLine.CreateReservation(
                      ForSalesLine, Description);
                    ForSalesLine.CALCFIELDS(Reserved);
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReserveReqLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReserveReqLine.CreateReservation(
                      ForReqLine, Description);
                    ForReqLine.CALCFIELDS(Reserved);
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    ReservePurchLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReservePurchLine.CreateReservation(
                      ForPurchLine, Description);
                    ForPurchLine.CALCFIELDS(Reserved);
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ReserveItemJnlLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReserveItemJnlLine.CreateReservation(
                      ForItemJnlLine, Description);
                    ForItemJnlLine.CALCFIELDS(Reserved);
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    //???P8
                    ReserveTransLine.CreateReservationSetFrom(
                      FromType, FromSubtype, FromID, FromBatchName, FromRefNo,
                      FromLocationCode);
                    ReserveTransLine.CreateReservation(
                      ForTransLine, Description, ForTransLine."Shipment Date", ForTransLine.Quantity, ForTransLine."Quantity (Base)",
                      CalcReservEntry."Source Subtype");
                    ForTransLine.CALCFIELDS("Reserved Outbound");
                    ForTransLine.CALCFIELDS("Reserved Inbound");
                END;
        END;
    end;

    [Scope('Internal')]
    procedure DeleteReservEntries(DeleteAll: Boolean)
    var
        ReservMgt: Codeunit "25006300";
        CalcReservEntry4: Record "25006392";
        QtyToReTrack: Decimal;
        QtyTracked: Decimal;
    begin
        DeleteReservEntries2(CalcReservEntry2);

        // Handle both sides of a req. line related to a transfer line:
        IF ((CalcReservEntry."Source Type" = DATABASE::"Requisition Line") AND
          (ForReqLine."Ref. Order Type" = ForReqLine."Ref. Order Type"::Transfer))
        THEN BEGIN
            CalcReservEntry4 := CalcReservEntry;
            CalcReservEntry4."Source Subtype" := 1;
            SetPointerFilter(CalcReservEntry4);
            DeleteReservEntries2(CalcReservEntry4);
        END;
    end;

    [Scope('Internal')]
    procedure DeleteReservEntries2(var ReservEntry: Record "25006392")
    var
        CalcReservEntry4: Record "25006392";
        DummyEntry: Record "25006392";
        CurrentVehicleSerialNo: Code[20];
        ReleaseInventory: Boolean;
        SignFactor: Integer;
    begin

        IF ReservEntry.ISEMPTY THEN
            EXIT;
        CurrentVehicleSerialNo := ReservEntry."Vehicle Serial No.";

        GetModelVersionSetup(ReservEntry);
        ReservEntry.TESTFIELD("Source Type");
        ReservEntry.Lock;
        SignFactor := CreateReservEntry.SignFactor(ReservEntry);

        IF ReservEntry.FINDSET THEN
            REPEAT
                ReservEngineMgt.CloseReservEntry(ReservEntry);
            UNTIL ReservEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CalculateRemainingQty(): Decimal
    begin
        CalcReservEntry.TESTFIELD("Source Type");

        CASE CalcReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    ForSalesLine.CALCFIELDS(Reserved);
                    IF ForSalesLine.Reserved THEN
                        EXIT(0)
                    ELSE
                        EXIT(ForSalesLine."Outstanding Qty. (Base)");
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ForReqLine.CALCFIELDS(Reserved);
                    IF ForReqLine.Reserved THEN
                        EXIT(0)
                    ELSE
                        EXIT(ForReqLine."Net Quantity (Base)");
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    ForPurchLine.CALCFIELDS(Reserved);
                    IF ForPurchLine.Reserved THEN
                        EXIT(0)
                    ELSE
                        EXIT(ForPurchLine."Outstanding Qty. (Base)");
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ForItemJnlLine.CALCFIELDS(Reserved);
                    IF ForItemJnlLine.Reserved THEN
                        EXIT(0)
                    ELSE
                        EXIT(ForItemJnlLine.Quantity);
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    CASE CalcReservEntry."Source Subtype" OF
                        0: // Outbound
                            BEGIN
                                ForTransLine.CALCFIELDS("Reserved Outbound");
                                IF ForTransLine."Reserved Outbound" THEN
                                    EXIT(0)
                                ELSE
                                    EXIT(ForTransLine."Outstanding Qty. (Base)");
                            END;
                        1: // Inbound
                            BEGIN
                                ForTransLine.CALCFIELDS("Reserved Inbound");
                                IF ForTransLine."Reserved Inbound" THEN
                                    EXIT(0)
                                ELSE
                                    EXIT(ForTransLine."Outstanding Qty. (Base)");
                            END;
                    END;
                END;
            ELSE
                ERROR(Text003);
        END;
    end;

    [Scope('Internal')]
    procedure CopySign(FromValue: Decimal; var ToValue: Decimal)
    begin
        IF FromValue * ToValue < 0 THEN
            ToValue := -ToValue;
    end;

    local procedure InitFilter(EntryID: Integer)
    begin
        CASE EntryID OF
            1:
                BEGIN // Item Ledger Entry
                    CalcItemLedgEntry.RESET;
                    CalcItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code",
                     "Posting Date", "Expiration Date", "Lot No.", "Serial No.");
                    CalcItemLedgEntry.SETRANGE("Item No.", CalcReservEntry."Model Version No.");
                    CalcItemLedgEntry.SETRANGE(Open, TRUE);
                    CalcItemLedgEntry.SETRANGE("Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcItemLedgEntry.SETRANGE(Positive, Positive);
                    CalcItemLedgEntry.SETRANGE("Location Code", CalcReservEntry."Location Code");
                    CalcItemLedgEntry.SETRANGE("Drop Shipment", FALSE);
                END;
            12, 16:
                BEGIN // Purchase Line
                    CalcPurchLine.RESET;
                    CalcPurchLine.SETCURRENTKEY("Vehicle Serial No.", "Vehicle Assembly ID");
                    CalcPurchLine.SETRANGE("Document Type", EntryID - 11);
                    CalcPurchLine.SETRANGE(Type, CalcPurchLine.Type::Item);
                    CalcPurchLine.SETRANGE("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcPurchLine.SETRANGE("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcPurchLine.SETRANGE("Drop Shipment", FALSE);
                    CalcPurchLine.SETRANGE("Location Code", CalcReservEntry."Location Code");
                    IF Positive AND (EntryID <> 16) THEN
                        CalcPurchLine.SETFILTER("Quantity (Base)", '>0')
                    ELSE
                        CalcPurchLine.SETFILTER("Quantity (Base)", '<0');
                    CalcPurchLine.SETRANGE("Job No.", ' ');
                END;
            21:
                BEGIN // Requisition Line
                    CalcReqLine.RESET;
                    CalcReqLine.SETCURRENTKEY(
                      Type, "No.", "Vehicle Serial No.", "Location Code", "Sales Order No.", "Planning Line Origin", "Due Date");
                    CalcReqLine.SETRANGE(Type, CalcReqLine.Type::Item);
                    CalcReqLine.SETRANGE("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcReqLine.SETRANGE("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcReqLine.SETRANGE("Location Code", CalcReservEntry."Location Code");
                    CalcReqLine.SETRANGE("Sales Order No.", '');
                    IF Positive THEN
                        CalcReqLine.SETFILTER("Quantity (Base)", '>0')
                    ELSE
                        CalcReqLine.SETFILTER("Quantity (Base)", '<0');
                END;
            31, 32, 36:
                BEGIN // Sales Line
                    CalcSalesLine.RESET;
                    CalcSalesLine.SETCURRENTKEY("Vehicle Serial No.", "Vehicle Assembly ID");
                    CalcSalesLine.SETRANGE("Document Type", EntryID - 31);
                    CalcSalesLine.SETRANGE(Type, CalcSalesLine.Type::Item);
                    CalcSalesLine.SETRANGE("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcSalesLine.SETRANGE("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcSalesLine.SETRANGE("Drop Shipment", FALSE);
                    CalcSalesLine.SETRANGE("Location Code", CalcReservEntry."Location Code");
                    IF EntryID = 36 THEN
                        IF Positive THEN
                            CalcSalesLine.SETFILTER("Quantity (Base)", '>0')
                        ELSE
                            CalcSalesLine.SETFILTER("Quantity (Base)", '<0')
                    ELSE
                        IF Positive THEN
                            CalcSalesLine.SETFILTER("Quantity (Base)", '<0')
                        ELSE
                            CalcSalesLine.SETFILTER("Quantity (Base)", '>0');
                    CalcSalesLine.SETRANGE("Job No.", ' ');
                END;
            101:
                BEGIN // Transfer, Outbound
                    CalcTransLine.RESET;
                    CalcTransLine.SETCURRENTKEY("Transfer-from Code");
                    CalcTransLine.SETRANGE("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcTransLine.SETRANGE("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcTransLine.SETRANGE("Transfer-from Code", CalcReservEntry."Location Code");
                    IF Positive THEN
                        CalcTransLine.SETFILTER("Outstanding Qty. (Base)", '<0')
                    ELSE
                        CalcTransLine.SETFILTER("Outstanding Qty. (Base)", '>0');
                END;
            102:
                BEGIN // Transfer, Inbound
                    CalcTransLine.RESET;
                    CalcTransLine.SETCURRENTKEY("Transfer-to Code");
                    CalcTransLine.SETRANGE("Model Version No.", CalcReservEntry."Model Version No.");
                    CalcTransLine.SETRANGE("Vehicle Serial No.", CalcReservEntry."Vehicle Serial No.");
                    CalcTransLine.SETRANGE("Transfer-to Code", CalcReservEntry."Location Code");
                    IF Positive THEN
                        CalcTransLine.SETFILTER("Outstanding Qty. (Base)", '>0')
                    ELSE
                        CalcTransLine.SETFILTER("Outstanding Qty. (Base)", '<0');
                END;
        END;
    end;

    local procedure SetValueArray(): Integer
    begin
        CLEAR(ValueArray);
        ValueArray[1] := 1;
        ValueArray[2] := 12;
        ValueArray[3] := 16;
        ValueArray[4] := 32;
        ValueArray[5] := 36;
        ValueArray[6] := 63;
        ValueArray[7] := 64;
        ValueArray[8] := 73;
        ValueArray[9] := 74;
        ValueArray[10] := 101;
        ValueArray[11] := 102;
        ValueArray[12] := 110;
        EXIT(12);
    end;

    [Scope('Internal')]
    procedure SetPointerFilter(var ReservEntry: Record "25006392")
    begin
        ReservEntry.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");
        ReservEntry.SETRANGE("Source ID", ReservEntry."Source ID");
        ReservEntry.SETRANGE("Source Ref. No.", ReservEntry."Source Ref. No.");
        ReservEntry.SETRANGE("Source Type", ReservEntry."Source Type");
        ReservEntry.SETRANGE("Source Subtype", ReservEntry."Source Subtype");
        ReservEntry.SETRANGE("Source Batch Name", ReservEntry."Source Batch Name");
    end;

    local procedure MakeConnection(var FromReservEntry: Record "25006392"; var ToReservEntry: Record "25006392"; Quantity: Decimal; AvailabilityDate: Date; Binding: Option ,"Order-to-Order")
    begin
        CreateReservEntry.CreateReservEntryFor(
          FromReservEntry."Source Type", FromReservEntry."Source Subtype", FromReservEntry."Source ID",
          FromReservEntry."Source Batch Name", FromReservEntry."Source Ref. No.",
          CreateReservEntry.SignFactor(FromReservEntry) * Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          ToReservEntry."Source Type", ToReservEntry."Source Subtype", ToReservEntry."Source ID", ToReservEntry."Source Batch Name",
          ToReservEntry."Source Ref. No.");
        CreateReservEntry.CreateEntry(
          FromReservEntry."Model Version No.", FromReservEntry."Vehicle Serial No.", FromReservEntry."Location Code",
          FromReservEntry.Description);
    end;

    [Scope('Internal')]
    procedure MakeRoomForReservation(var ReservEntry: Record "25006392"): Decimal
    var
        ReservEntry2: Record "25006392";
        TotalQuantity: Decimal;
    begin
        TotalQuantity := SourceQuantity(ReservEntry, FALSE);
        ReservEntry2 := ReservEntry;
        SetPointerFilter(ReservEntry2);
        DeleteReservEntries2(ReservEntry2);
    end;

    [Scope('Internal')]
    procedure SourceQuantity(var ReservEntry: Record "25006392"; SetAsCurrent: Boolean): Decimal
    begin
        EXIT(GetSourceRecordValue(ReservEntry, SetAsCurrent));
    end;

    [Scope('Internal')]
    procedure GetSourceRecordValue(var ReservEntry: Record "25006392"; SetAsCurrent: Boolean): Decimal
    var
        ItemLedgEntry: Record "32";
        SalesLine: Record "37";
        ReqLine: Record "246";
        PurchLine: Record "39";
        ItemJnlLine: Record "83";
        TransLine: Record "5741";
    begin
        CASE ReservEntry."Source Type" OF
            DATABASE::"Item Ledger Entry":
                BEGIN
                    ItemLedgEntry.GET(ReservEntry."Source Ref. No.");
                    IF SetAsCurrent THEN
                        SetItemLedgEntry(ItemLedgEntry);
                    EXIT(ItemLedgEntry."Remaining Quantity")
                END;
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.GET(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.");
                    IF SetAsCurrent THEN
                        SetSalesLine(SalesLine);
                    EXIT(SalesLine."Quantity (Base)");
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.GET(ReservEntry."Source ID", ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.");
                    IF SetAsCurrent THEN
                        SetReqLine(ReqLine);
                    EXIT(ReqLine."Quantity (Base)");
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchLine.GET(ReservEntry."Source Subtype", ReservEntry."Source ID", ReservEntry."Source Ref. No.");
                    IF SetAsCurrent THEN
                        SetPurchLine(PurchLine);
                    EXIT(PurchLine."Quantity (Base)");
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ItemJnlLine.GET(ReservEntry."Source ID", ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.");
                    IF SetAsCurrent THEN
                        SetItemJnlLine(ItemJnlLine);
                    EXIT(ItemJnlLine."Quantity (Base)");

                END;
            DATABASE::"Transfer Line":
                BEGIN
                    TransLine.GET(ReservEntry."Source ID", ReservEntry."Source Ref. No.");
                    IF SetAsCurrent THEN
                        SetTransferLine(TransLine, ReservEntry."Source Subtype");
                    EXIT(TransLine."Quantity (Base)");
                END;
        END;
        // WITH
    end;

    local procedure GetModelVersionSetup(var ReservEntry: Record "25006392")
    begin
        IF ReservEntry."Model Version No." <> ModelVersion."No." THEN
            ModelVersion.GET(ReservEntry."Model Version No.");
    end;

    [Scope('Internal')]
    procedure MarkReservConnection(var ReservEntry: Record "25006392"; TargetReservEntry: Record "25006392") ReservedQuantity: Decimal
    var
        ReservEntry2: Record "25006392";
        SignFactor: Integer;
    begin
        IF NOT ReservEntry.FINDSET THEN
            EXIT;
        SignFactor := CreateReservEntry.SignFactor(ReservEntry);

        REPEAT
            IF ReservEntry2.GET(ReservEntry."Entry No.", NOT ReservEntry.Positive) THEN
                IF ((ReservEntry2."Source Type" = TargetReservEntry."Source Type") AND
                    (ReservEntry2."Source Subtype" = TargetReservEntry."Source Subtype") AND
                    (ReservEntry2."Source ID" = TargetReservEntry."Source ID") AND
                    (ReservEntry2."Source Batch Name" = TargetReservEntry."Source Batch Name") AND
                    (ReservEntry2."Source Ref. No." = TargetReservEntry."Source Ref. No."))
                THEN BEGIN
                    ReservEntry.MARK(TRUE);
                    ReservedQuantity += ReservEntry.Quantity * SignFactor;
                END;
        UNTIL ReservEntry.NEXT = 0;
        ReservEntry.MARKEDONLY(TRUE);
    end;

    [Scope('Internal')]
    procedure SetMatchFilter(var ReservEntry: Record "25006392"; var FilterReservEntry: Record "25006392"; SearchForSupply: Boolean; AvailabilityDate: Date)
    begin
        FilterReservEntry.RESET;
        FilterReservEntry.SETCURRENTKEY(
          "Model Version No.", "Vehicle Serial No.", "Location Code");
        FilterReservEntry.SETRANGE("Model Version No.", ReservEntry."Model Version No.");
        FilterReservEntry.SETRANGE("Vehicle Serial No.", ReservEntry."Vehicle Serial No.");
        FilterReservEntry.SETRANGE("Location Code", ReservEntry."Location Code");
        FilterReservEntry.SETRANGE(Positive, SearchForSupply);
    end;

    [Scope('Internal')]
    procedure LookupLine(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer)
    var
        ItemLedgEntry: Record "32";
        SalesLine: Record "37";
        PurchLine: Record "39";
        ItemJnlLine: Record "83";
        ReqLine: Record "246";
    begin
        CASE SourceType OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document Type", SourceSubtype);
                    SalesLine.SETRANGE("Document No.", SourceID);
                    SalesLine.SETRANGE("Line No.", SourceRefNo);
                    PAGE.RUN(PAGE::"Sales Lines", SalesLine);
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.RESET;
                    ReqLine.SETRANGE("Worksheet Template Name", SourceID);
                    ReqLine.SETRANGE("Journal Batch Name", SourceBatchName);
                    ReqLine.SETRANGE("Line No.", SourceRefNo);
                    PAGE.RUN(PAGE::"Requisition Lines", ReqLine);
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type", SourceSubtype);
                    PurchLine.SETRANGE("Document No.", SourceID);
                    PurchLine.SETRANGE("Line No.", SourceRefNo);
                    PAGE.RUN(PAGE::"Purchase Lines", PurchLine);
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ItemJnlLine.RESET;
                    ItemJnlLine.SETRANGE("Journal Template Name", SourceID);
                    ItemJnlLine.SETRANGE("Journal Batch Name", SourceBatchName);
                    ItemJnlLine.SETRANGE("Line No.", SourceRefNo);
                    ItemJnlLine.SETRANGE("Entry Type", SourceSubtype);
                    PAGE.RUN(PAGE::"Item Journal Lines", ItemJnlLine);
                END;
            DATABASE::"Item Ledger Entry":
                BEGIN
                    ItemLedgEntry.RESET;
                    ItemLedgEntry.SETRANGE("Entry No.", SourceRefNo);
                    PAGE.RUN(0, ItemLedgEntry);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure LookupDocument(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer)
    var
        SalesHeader: Record "36";
        PurchHeader: Record "38";
        ReqLine: Record "246";
        ItemJnlLine: Record "83";
        ItemLedgEntry: Record "32";
        TransHeader: Record "5740";
    begin
        CASE SourceType OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesHeader.RESET;
                    SalesHeader.SETRANGE("Document Type", SourceSubtype);
                    SalesHeader.SETRANGE("No.", SourceID);
                    CASE SourceSubtype OF
                        0:
                            PAGE.RUNMODAL(PAGE::"Sales Quote", SalesHeader);
                        1:
                            PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader);
                        2:
                            PAGE.RUNMODAL(PAGE::"Sales Invoice", SalesHeader);
                        3:
                            PAGE.RUNMODAL(PAGE::"Credit Note", SalesHeader);
                    END;
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.RESET;
                    ReqLine.SETRANGE("Worksheet Template Name", SourceID);
                    ReqLine.SETRANGE("Journal Batch Name", SourceBatchName);
                    ReqLine.SETRANGE("Line No.", SourceRefNo);
                    PAGE.RUNMODAL(PAGE::"Requisition Lines", ReqLine);
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchHeader.RESET;
                    PurchHeader.SETRANGE("Document Type", SourceSubtype);
                    PurchHeader.SETRANGE("No.", SourceID);
                    CASE SourceSubtype OF
                        0:
                            PAGE.RUNMODAL(PAGE::"Purchase Quote", PurchHeader);
                        1:
                            PAGE.RUNMODAL(PAGE::"Purchase Order", PurchHeader);
                        2:
                            PAGE.RUNMODAL(PAGE::"Purchase Invoice", PurchHeader);
                        3:
                            PAGE.RUNMODAL(PAGE::"Debit Memo", PurchHeader);
                    END;
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ItemJnlLine.RESET;
                    ItemJnlLine.SETRANGE("Journal Template Name", SourceID);
                    ItemJnlLine.SETRANGE("Journal Batch Name", SourceBatchName);
                    ItemJnlLine.SETRANGE("Line No.", SourceRefNo);
                    ItemJnlLine.SETRANGE("Entry Type", SourceSubtype);
                    PAGE.RUNMODAL(PAGE::"Item Journal Lines", ItemJnlLine);
                END;
            DATABASE::"Item Ledger Entry":
                BEGIN
                    ItemLedgEntry.RESET;
                    ItemLedgEntry.SETRANGE("Entry No.", SourceRefNo);
                    PAGE.RUNMODAL(0, ItemLedgEntry);
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    TransHeader.RESET;
                    TransHeader.SETRANGE("No.", SourceID);
                    PAGE.RUNMODAL(PAGE::"Transfer Order", TransHeader);
                END;
        END;
    end;
}

