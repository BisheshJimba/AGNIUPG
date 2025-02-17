codeunit 25006315 "Create Veh. Reserv. Entry"
{
    Permissions = TableData 337 = rim;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Reservation is illegal.';
        InsertReservEntry: Record "25006392";
        InsertReservEntry2: Record "25006392";
        LastReservEntry: Record "25006392";
        Inbound: Boolean;
        UseQtyToInvoice: Boolean;

    [Scope('Internal')]
    procedure CreateEntry(ModelVersionNo: Code[20]; VehicleSerialNo: Code[20]; LocationCode: Code[10]; Description: Text[50])
    var
        ReservEntry: Record "25006392";
        ReservEntry2: Record "25006392";
        ReservEntry3: Record "25006392";
        ReservMgt: Codeunit "25006300";
        LastEntryNo: Integer;
        TrackingSpecificationExists: Boolean;
        FirstSplit: Boolean;
    begin

        InsertReservEntry.TESTFIELD("Source Type");

        ReservEntry := InsertReservEntry;
        ReservEntry."Model Version No." := ModelVersionNo;
        ReservEntry."Vehicle Serial No." := VehicleSerialNo;
        ReservEntry."Location Code" := LocationCode;
        ReservEntry.Description := Description;
        ReservEntry."Creation Date" := WORKDATE;
        ReservEntry."Created By" := USERID;
        ReservEntry.Positive := (ReservEntry.Quantity > 0);
        ReservEntry.Quantity := ReservEntry.Quantity;

        InsertReservEntry2.TESTFIELD("Source Type");

        ReservEntry2 := ReservEntry;
        ReservEntry2.Quantity := -ReservEntry.Quantity;
        ReservEntry2.Positive := (ReservEntry2.Quantity > 0);
        ReservEntry2."Source Type" := InsertReservEntry2."Source Type";
        ReservEntry2."Source Subtype" := InsertReservEntry2."Source Subtype";
        ReservEntry2."Source ID" := InsertReservEntry2."Source ID";
        ReservEntry2."Source Batch Name" := InsertReservEntry2."Source Batch Name";
        ReservEntry2."Source Ref. No." := InsertReservEntry2."Source Ref. No.";
        ReservEntry2."Model Version No." := ModelVersionNo;
        ReservEntry2."Vehicle Serial No." := VehicleSerialNo;
        ReservEntry2.Quantity := ReservEntry2.Quantity;
        //ReservMgt.MakeRoomForReservation(ReservEntry2);
        CheckValidity(ReservEntry2);


        CheckValidity(ReservEntry);

        //ReservMgt.MakeRoomForReservation(ReservEntry);

        ReservEntry3.LOCKTABLE;
        IF ReservEntry3.FINDLAST THEN
            LastEntryNo := ReservEntry3."Entry No.";

        ReservEntry."Entry No." := LastEntryNo + 1;
        ReservEntry.INSERT;
        ReservEntry2."Entry No." := ReservEntry."Entry No.";
        ReservEntry2.INSERT;

        LastReservEntry := ReservEntry;

        CLEAR(InsertReservEntry);
        CLEAR(InsertReservEntry2);
    end;

    [Scope('Internal')]
    procedure CreateReservEntry(ModelVersionNo: Code[20]; VehicleSerialNo: Code[20]; LocationCode: Code[10]; Description: Text[50])
    begin
        CreateEntry(ModelVersionNo, VehicleSerialNo, LocationCode, Description);
    end;

    [Scope('Internal')]
    procedure CreateReservEntryFor(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForRefNo: Integer; Quantity: Decimal)
    begin
        InsertReservEntry."Source Type" := ForType;
        InsertReservEntry."Source Subtype" := ForSubtype;
        InsertReservEntry."Source ID" := ForID;
        InsertReservEntry."Source Batch Name" := ForBatchName;
        InsertReservEntry."Source Ref. No." := ForRefNo;
        InsertReservEntry.Quantity := SignFactor(InsertReservEntry) * Quantity;
    end;

    [Scope('Internal')]
    procedure CreateReservEntryFrom(FromType: Option; FromSubtype: Integer; FromID: Code[20]; FromBatchName: Code[10]; FromRefNo: Integer)
    begin
        InsertReservEntry2."Source Type" := FromType;
        InsertReservEntry2."Source Subtype" := FromSubtype;
        InsertReservEntry2."Source ID" := FromID;
        InsertReservEntry2."Source Batch Name" := FromBatchName;
        InsertReservEntry2."Source Ref. No." := FromRefNo;
    end;

    [Scope('Internal')]
    procedure CreateRemainingReservEntry(var OldReservEntry: Record "25006392"; RemainingQuantity: Decimal)
    var
        OldReservEntry2: Record "25006392";
    begin

        CreateReservEntryFor(
          OldReservEntry."Source Type", OldReservEntry."Source Subtype",
          OldReservEntry."Source ID", OldReservEntry."Source Batch Name",
          OldReservEntry."Source Ref. No.",
          RemainingQuantity);

        IF OldReservEntry2.GET(OldReservEntry."Entry No.", NOT OldReservEntry.Positive) THEN BEGIN // Get the related entry
            CreateReservEntryFrom(
                OldReservEntry2."Source Type", OldReservEntry2."Source Subtype",
                OldReservEntry2."Source ID", OldReservEntry2."Source Batch Name",
                OldReservEntry2."Source Ref. No.");
        END;
        CreateEntry(
          OldReservEntry."Model Version No.", OldReservEntry."Vehicle Serial No.",
          OldReservEntry."Location Code", OldReservEntry.Description);
    end;

    [Scope('Internal')]
    procedure TransferReservEntry(NewType: Option; NewSubtype: Integer; NewID: Code[20]; NewBatchName: Code[10]; NewRefNo: Integer; OldReservEntry: Record "25006392")
    var
        NewReservEntry: Record "25006392";
        RelatedReservEntry: Record "25006392";
        Location: Record "14";
        CurrSignFactor: Integer;
        QtyInvoiced: Decimal;
    begin

        //CurrSignFactor := SignFactor(OldReservEntry);

        NewReservEntry := OldReservEntry;
        IF NewReservEntry.RECORDLEVELLOCKING THEN
            NewReservEntry.MODIFY;

        NewReservEntry."Source Type" := NewType;
        NewReservEntry."Source Subtype" := NewSubtype;
        NewReservEntry."Source ID" := NewID;
        NewReservEntry."Source Batch Name" := NewBatchName;
        NewReservEntry."Source Ref. No." := NewRefNo;

        NewReservEntry.MODIFY;
    end;

    [Scope('Internal')]
    procedure SignFactor(var ReservEntry: Record "25006392"): Integer
    begin

        // Demand is regarded as negative, supply is regarded as positive.
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                IF ReservEntry."Source Subtype" IN [3, 5] THEN // Credit memo, Return Order = supply
                    EXIT(1)
                ELSE
                    EXIT(-1);
            DATABASE::"Requisition Line":
                IF ReservEntry."Source Subtype" = 1 THEN
                    EXIT(-1)
                ELSE
                    EXIT(1);
            DATABASE::"Purchase Line":
                IF ReservEntry."Source Subtype" IN [3, 5] THEN // Credit memo, Return Order = demand
                    EXIT(-1)
                ELSE
                    EXIT(1);
            DATABASE::"Item Journal Line":
                IF (ReservEntry."Source Subtype" = 4) AND (Inbound) THEN
                    EXIT(1)
                ELSE
                    IF ReservEntry."Source Subtype" IN [1, 3, 4, 5] THEN // Sale, Negative Adjmt., Transfer, Consumption
                        EXIT(-1)
                    ELSE
                        EXIT(1);
            DATABASE::Table89:
                EXIT(1);
            DATABASE::"Item Ledger Entry":
                EXIT(1);
            DATABASE::"Prod. Order Line":
                EXIT(1);
            DATABASE::"Prod. Order Component":
                EXIT(-1);
            DATABASE::"Planning Component":
                EXIT(-1);
            DATABASE::"Transfer Line":
                IF ReservEntry."Source Subtype" = 0 THEN // Outbound
                    EXIT(-1)
                ELSE
                    EXIT(1);
            DATABASE::"Service Invoice Line":
                EXIT(-1);
        END;
    end;

    [Scope('Internal')]
    procedure CheckValidity(var ReservEntry: Record "25006392")
    var
        IsError: Boolean;
    begin

        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                IsError := NOT (ReservEntry."Source Subtype" IN [1, 5]);

            DATABASE::"Purchase Line":
                IsError := NOT (ReservEntry."Source Subtype" IN [1, 5]);

        //DATABASE::"Requisition Line",

        END;

        IF IsError THEN
            ERROR(Text000);
    end;

    [Scope('Internal')]
    procedure GetLastEntry(var ReservEntry: Record "25006392")
    begin

        ReservEntry := LastReservEntry;
    end;

    [Scope('Internal')]
    procedure HasSamePointer(var ReservEntry: Record "25006392"; var Reserventry2: Record "25006392"): Boolean
    begin

        EXIT
          ((ReservEntry."Source Type" = Reserventry2."Source Type") AND
          (ReservEntry."Source Subtype" = Reserventry2."Source Subtype") AND
          (ReservEntry."Source ID" = Reserventry2."Source ID") AND
          (ReservEntry."Source Batch Name" = Reserventry2."Source Batch Name") AND
          (ReservEntry."Source Ref. No." = Reserventry2."Source Ref. No."));
    end;

    [Scope('Internal')]
    procedure SetInbound(NewInbound: Boolean)
    begin

        Inbound := NewInbound;
    end;

    [Scope('Internal')]
    procedure SetUseQtyToInvoice(UseQtyToInvoice2: Boolean)
    begin

        UseQtyToInvoice := UseQtyToInvoice2;
    end;
}

