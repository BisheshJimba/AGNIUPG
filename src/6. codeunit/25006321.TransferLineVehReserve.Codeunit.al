codeunit 25006321 "Transfer Line-Veh. Reserve"
{
    // 12.07.2013 EDMS P8
    //   * Code taken from C99000836

    Permissions = TableData 337 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Codeunit is not initialized correctly.';
        Text001: Label 'Reserved quantity cannot be greater than %1';
        Text002: Label 'must be filled in when a quantity is reserved';
        Text003: Label 'must not be changed when a quantity is reserved';
        ReservMgt: Codeunit "25006300";
        CreateReservEntry: Codeunit "25006315";
        ReservEngineMgt: Codeunit "25006316";
        Blocked: Boolean;
        SetFromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry",Service,Job;
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromProdOrderLine: Integer;
        SetFromRefNo: Integer;
        SetFromVariantCode: Code[10];
        SetFromLocationCode: Code[10];
        SetFromSerialNo: Code[20];
        SetFromLotNo: Code[20];
        SetFromQtyPerUOM: Decimal;
        DeleteItemTracking: Boolean;

    [Scope('Internal')]
    procedure CreateReservation(var TransLine: Record "5741"; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; QuantityBase: Decimal; Direction: Option Outbound,Inbound)
    var
        ShipmentDate: Date;
    begin
        IF SetFromType = 0 THEN
            ERROR(Text000);


        TransLine.TESTFIELD("Model Version No.");
        TransLine.TESTFIELD("Item No.");
        //TransLine.TESTFIELD("Variant Code",SetFromVariantCode);


        CASE Direction OF
            Direction::Outbound:
                BEGIN
                    TransLine.TESTFIELD("Shipment Date");
                    TransLine.TESTFIELD("Transfer-from Code", SetFromLocationCode);
                    TransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");
                    IF ABS(TransLine."Outstanding Qty. (Base)") <
                       ABS(TransLine."Reserved Qty. Outbnd. (Base)") + QuantityBase
                    THEN
                        ERROR(
                          Text001,
                          ABS(TransLine."Outstanding Qty. (Base)") - ABS(TransLine."Reserved Qty. Outbnd. (Base)"));
                    ShipmentDate := TransLine."Shipment Date";
                END;
            Direction::Inbound:
                BEGIN
                    TransLine.TESTFIELD("Receipt Date");
                    TransLine.TESTFIELD("Transfer-to Code", SetFromLocationCode);
                    TransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
                    IF ABS(TransLine."Outstanding Qty. (Base)") <
                       ABS(TransLine."Reserved Qty. Inbnd. (Base)") + QuantityBase
                    THEN
                        ERROR(
                          Text001,
                          ABS(TransLine."Outstanding Qty. (Base)") - ABS(TransLine."Reserved Qty. Inbnd. (Base)"));
                    ExpectedReceiptDate := TransLine."Receipt Date";
                END;
        END;
        CreateReservEntry.CreateReservEntryFor(
          DATABASE::"Transfer Line",
          Direction,
          TransLine."Document No.",
          '',
          TransLine."Line No.",
          Quantity);
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          TransLine."Model Version No.",
          TransLine."Vehicle Serial No.",
          SetFromLocationCode,
          Description);

        SetFromType := 0;
    end;

    [Scope('Internal')]
    procedure CreateReservationSetFrom(FromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry",Service,Job; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromRefNo: Integer; FromLocationCode: Code[10])
    begin
        SetFromType := FromType;
        SetFromSubtype := FromSubtype;
        SetFromID := FromID;
        SetFromBatchName := FromBatchName;
        SetFromRefNo := FromRefNo;
        SetFromLocationCode := FromLocationCode;
    end;

    [Scope('Internal')]
    procedure FilterReservFor(var FilterReservEntry: Record "25006392"; TransLine: Record "5741"; Direction: Option Outbound,Inbound)
    begin
        FilterReservEntry.SETRANGE("Source Type", DATABASE::"Transfer Line");
        FilterReservEntry.SETRANGE("Source Subtype", Direction);
        FilterReservEntry.SETRANGE("Source ID", TransLine."Document No.");
        FilterReservEntry.SETRANGE("Source Batch Name", '');
        FilterReservEntry.SETRANGE("Source Ref. No.", TransLine."Line No.");
    end;

    [Scope('Internal')]
    procedure Caption(TransLine: Record "5741") CaptionText: Text[80]
    begin
        CaptionText :=
          STRSUBSTNO(
            '%1 %2 %3', TransLine."Document No.", TransLine."Line No.",
            TransLine."Item No.");
    end;

    [Scope('Internal')]
    procedure FindReservEntry(TransLine: Record "5741"; var ReservEntry: Record "25006392"; Direction: Option Outbound,Inbound): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, TransLine, Direction);
        EXIT(ReservEntry.FINDLAST);
    end;

    [Scope('Internal')]
    procedure ReservEntryExist(TransLine: Record "5741"): Boolean
    var
        ReservEntry: Record "25006392";
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, TransLine, 0);
        ReservEntry.SETRANGE("Source Subtype"); // Ignore direction
        EXIT(NOT ReservEntry.ISEMPTY);
    end;

    [Scope('Internal')]
    procedure VerifyChange(var NewTransLine: Record "5741"; var OldTransLine: Record "5741")
    var
        TransLine: Record "5741";
        TempReservEntry: Record "25006392";
        ShowErrorInbnd: Boolean;
        ShowErrorOutbnd: Boolean;
        HasErrorInbnd: Boolean;
        HasErrorOutbnd: Boolean;
    begin
        IF Blocked THEN
            EXIT;
        IF NewTransLine."Line No." = 0 THEN
            IF NOT TransLine.GET(NewTransLine."Document No.", NewTransLine."Line No.") THEN
                EXIT;

        NewTransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
        NewTransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");

        ShowErrorInbnd := (NewTransLine."Reserved Qty. Inbnd. (Base)" <> 0);
        ShowErrorOutbnd := (NewTransLine."Reserved Qty. Outbnd. (Base)" <> 0);

        IF NewTransLine."Shipment Date" = 0D THEN
            IF ShowErrorOutbnd THEN
                NewTransLine.FIELDERROR("Shipment Date", Text002)
            ELSE
                HasErrorOutbnd := TRUE;

        IF NewTransLine."Receipt Date" = 0D THEN
            IF ShowErrorInbnd THEN
                NewTransLine.FIELDERROR("Receipt Date", Text002)
            ELSE
                HasErrorInbnd := TRUE;

        IF NewTransLine."Item No." <> OldTransLine."Item No." THEN
            IF ShowErrorInbnd OR ShowErrorOutbnd THEN
                NewTransLine.FIELDERROR("Item No.", Text003)
            ELSE BEGIN
                HasErrorInbnd := TRUE;
                HasErrorOutbnd := TRUE;
            END;

        IF NewTransLine."Transfer-from Code" <> OldTransLine."Transfer-from Code" THEN
            IF ShowErrorOutbnd THEN
                NewTransLine.FIELDERROR("Transfer-from Code", Text003)
            ELSE
                HasErrorOutbnd := TRUE;

        IF NewTransLine."Transfer-to Code" <> OldTransLine."Transfer-to Code" THEN
            IF ShowErrorInbnd THEN
                NewTransLine.FIELDERROR("Transfer-to Code", Text003)
            ELSE
                HasErrorInbnd := TRUE;

        IF NewTransLine."Transfer-from Bin Code" <> OldTransLine."Transfer-from Bin Code" THEN
            IF ShowErrorOutbnd THEN
                NewTransLine.FIELDERROR("Transfer-from Bin Code", Text003)
            ELSE
                HasErrorOutbnd := TRUE;

        IF NewTransLine."Transfer-To Bin Code" <> OldTransLine."Transfer-To Bin Code" THEN
            IF ShowErrorInbnd THEN
                NewTransLine.FIELDERROR("Transfer-To Bin Code", Text003)
            ELSE
                HasErrorInbnd := TRUE;

        IF NewTransLine."Variant Code" <> OldTransLine."Variant Code" THEN
            IF ShowErrorInbnd OR ShowErrorOutbnd THEN
                NewTransLine.FIELDERROR("Variant Code", Text003)
            ELSE BEGIN
                HasErrorInbnd := TRUE;
                HasErrorOutbnd := TRUE;
            END;

        IF NewTransLine."Line No." <> OldTransLine."Line No." THEN BEGIN
            HasErrorInbnd := TRUE;
            HasErrorOutbnd := TRUE;
        END;

        IF HasErrorOutbnd THEN BEGIN
            IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR
               FindReservEntry(NewTransLine, TempReservEntry, 0)
            THEN BEGIN
                IF NewTransLine."Item No." <> OldTransLine."Item No." THEN BEGIN
                    ReservMgt.SetTransferLine(OldTransLine, 0);
                    ReservMgt.DeleteReservEntries(TRUE);
                    ReservMgt.SetTransferLine(NewTransLine, 0);
                END ELSE BEGIN
                    ReservMgt.SetTransferLine(NewTransLine, 0);
                    ReservMgt.DeleteReservEntries(TRUE);
                END;
            END;
            AssignForPlanning(NewTransLine, 0);
            IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR
               (NewTransLine."Variant Code" <> OldTransLine."Variant Code") OR
               (NewTransLine."Transfer-to Code" <> OldTransLine."Transfer-to Code")
            THEN
                AssignForPlanning(OldTransLine, 0);
        END;

        IF HasErrorInbnd THEN BEGIN
            IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR
               FindReservEntry(NewTransLine, TempReservEntry, 1)
            THEN BEGIN
                IF NewTransLine."Item No." <> OldTransLine."Item No." THEN BEGIN
                    ReservMgt.SetTransferLine(OldTransLine, 1);
                    ReservMgt.DeleteReservEntries(TRUE);
                    ReservMgt.SetTransferLine(NewTransLine, 1);
                END ELSE BEGIN
                    ReservMgt.SetTransferLine(NewTransLine, 1);
                    ReservMgt.DeleteReservEntries(TRUE);
                END;
            END;
            AssignForPlanning(NewTransLine, 1);
            IF (NewTransLine."Item No." <> OldTransLine."Item No.") OR
               (NewTransLine."Variant Code" <> OldTransLine."Variant Code") OR
               (NewTransLine."Transfer-from Code" <> OldTransLine."Transfer-from Code")
            THEN
                AssignForPlanning(OldTransLine, 1);
        END;
    end;

    [Scope('Internal')]
    procedure VerifyQuantity(var NewTransLine: Record "5741"; var OldTransLine: Record "5741")
    var
        TransLine: Record "5741";
        Direction: Option Outbound,Inbound;
    begin
        IF Blocked THEN
            EXIT;

        IF NewTransLine."Line No." = OldTransLine."Line No." THEN
            IF NewTransLine."Quantity (Base)" = OldTransLine."Quantity (Base)" THEN
                EXIT;
        IF NewTransLine."Line No." = 0 THEN
            IF NOT TransLine.GET(NewTransLine."Document No.", NewTransLine."Line No.") THEN
                EXIT;
        FOR Direction := Direction::Outbound TO Direction::Inbound DO BEGIN
            ReservMgt.SetTransferLine(NewTransLine, Direction);
            //IF "Qty. per Unit of Measure" <> OldTransLine."Qty. per Unit of Measure" THEN
            //ReservMgt.ModifyUnitOfMeasure;
            ReservMgt.DeleteReservEntries(FALSE);
            AssignForPlanning(NewTransLine, Direction);
        END;
    end;

    [Scope('Internal')]
    procedure UpdatePlanningFlexibility(var TransLine: Record "5741")
    var
        ReservEntry: Record "25006392";
    begin
        //IF FindReservEntry(TransLine,ReservEntry,0) THEN
        //ReservEntry.MODIFYALL("Planning Flexibility",TransLine."Planning Flexibility");
        //IF FindReservEntry(TransLine,ReservEntry,1) THEN
        //ReservEntry.MODIFYALL("Planning Flexibility",TransLine."Planning Flexibility");
    end;

    [Scope('Internal')]
    procedure TransferTransferToItemJnlLine(var TransLine: Record "5741"; var ItemJnlLine: Record "83"; TransferQty: Decimal; Direction: Option Outbound,Inbound)
    var
        OldReservEntry: Record "25006392";
        TransferLocation: Code[10];
    begin
        IF NOT FindReservEntry(TransLine, OldReservEntry, Direction) THEN
            EXIT;

        OldReservEntry.Lock;

        CASE Direction OF
            Direction::Outbound:
                BEGIN
                    TransferLocation := TransLine."Transfer-from Code";
                    ItemJnlLine.TESTFIELD("Location Code", TransferLocation);
                END;
            Direction::Inbound:
                BEGIN
                    TransferLocation := TransLine."Transfer-to Code";
                    ItemJnlLine.TESTFIELD("New Location Code", TransferLocation);
                END;
        END;

        ItemJnlLine.TESTFIELD("Item No.", TransLine."Item No.");
        ItemJnlLine.TESTFIELD("Variant Code", TransLine."Variant Code");

        IF TransferQty = 0 THEN
            EXIT;
        IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN
            REPEAT
                OldReservEntry.TESTFIELD(OldReservEntry."Model Version No.", TransLine."Model Version No.");
                OldReservEntry.TESTFIELD(OldReservEntry."Vehicle Serial No.", TransLine."Vehicle Serial No.");
                OldReservEntry.TESTFIELD("Location Code", TransferLocation);

                CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
                    ItemJnlLine."Entry Type",
                    ItemJnlLine."Journal Template Name",
                    ItemJnlLine."Journal Batch Name",
                    ItemJnlLine."Line No.",
                    OldReservEntry);

            UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
    end;

    [Scope('Internal')]
    procedure RenameLine(var NewTransLine: Record "5741"; var OldTransLine: Record "5741")
    begin
        ReservEngineMgt.RenamePointer(DATABASE::"Transfer Line",
          0,
          OldTransLine."Document No.",
          '',
          OldTransLine."Line No.",
          0,
          NewTransLine."Document No.",
          '',
          NewTransLine."Line No.");
    end;

    [Scope('Internal')]
    procedure DeleteLineConfirm(var TransLine: Record "5741"): Boolean
    begin
        IF NOT ReservEntryExist(TransLine) THEN
            EXIT(TRUE);

        ReservMgt.SetTransferLine(TransLine, 0);

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure DeleteLine(var TransLine: Record "5741")
    begin
        IF Blocked THEN
            EXIT;

        ReservMgt.SetTransferLine(TransLine, 0);
        ReservMgt.DeleteReservEntries(TRUE);

        ReservMgt.SetTransferLine(TransLine, 1);
        ReservMgt.DeleteReservEntries(TRUE);
    end;

    [Scope('Internal')]
    procedure AssignForPlanning(var TransLine: Record "5741"; Direction: Option Outbound,Inbound)
    var
        PlanningAssignment: Record "99000850";
    begin
        IF TransLine."Item No." <> '' THEN
            CASE Direction OF
                Direction::Outbound:
                    PlanningAssignment.ChkAssignOne(TransLine."Item No.", TransLine."Variant Code", TransLine."Transfer-to Code", TransLine."Shipment Date");
                Direction::Inbound:
                    PlanningAssignment.ChkAssignOne(TransLine."Item No.", TransLine."Variant Code", TransLine."Transfer-from Code", TransLine."Receipt Date");
            END;
    end;

    [Scope('Internal')]
    procedure Block(SetBlocked: Boolean)
    begin
        Blocked := SetBlocked;
    end;
}

