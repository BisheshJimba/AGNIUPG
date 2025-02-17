codeunit 25006316 "Veh. Reservation Engine Mgt."
{
    Permissions = TableData 32 = rm,
                  TableData 337 = rimd,
                  TableData 99000849 = rid;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label '%1 must be greater than 0.';
        Text001: Label '%1 must be less than 0.';
        Text002: Label 'Use Cancel Reservation.';
        Text003: Label '%1 can only be reduced.';
        Text005: Label 'Outbound,Inbound';
        CalcSalesLine: Record "37";
        CalcPurchLine: Record "39";
        CalcItemJnlLine: Record "83";
        ModelVersion: Record "27";
        TempSortRec1: Record "25006392" temporary;
        TempSortRec2: Record "25006392" temporary;
        TempSortRec3: Record "25006392" temporary;
        TempSortRec4: Record "25006392" temporary;
        ReservMgt: Codeunit "25006300";
        Text007: Label 'Renaming reservation entries...';
        EDMS001: Label 'You are not allowed to cancel other user reservation.';
        UserSetup: Record "91";

    [Scope('Internal')]
    procedure CloseReservEntry2(ReservEntry: Record "25006392")
    var
        ReservEntry3: Record "25006392";
        LastEntryNo: Integer;
    begin
        UserSetup.GET(USERID);
        IF UserSetup."Cancel Only Own Reservation" AND (ReservEntry."Created By" <> UPPERCASE(USERID)) THEN
            ERROR(EDMS001);

        ReservEntry3.LOCKTABLE;
        IF ReservEntry3.FINDLAST THEN
            LastEntryNo := ReservEntry3."Entry No.";

        CloseReservEntry(ReservEntry);
    end;

    [Scope('Internal')]
    procedure CloseReservEntry(ReservEntry: Record "25006392")
    var
        ReservEntry2: Record "25006392";
        SurplusReservEntry: Record "25006392";
        DummyReservEntry: Record "25006392";
        TotalQty: Decimal;
        AvailabilityDate: Date;
        DeleteOnly: Boolean;
    begin

        ReservEntry.DELETE;
        GetModelVersion(ReservEntry."Model Version No.");

        ReservEntry2.GET(ReservEntry."Entry No.", NOT ReservEntry.Positive);
        DeleteOnly := TRUE;

        IF DeleteOnly THEN
            ReservEntry2.DELETE
        ELSE BEGIN
            IF NOT (CheckValidity(ReservEntry2)) THEN BEGIN
                ReservEntry2.DELETE;
                EXIT;
            END;

            ReservEntry2.MODIFY;
            IF ReservEntry2.Quantity = 0 THEN BEGIN
                ReservEntry2.DELETE(TRUE);
            END ELSE BEGIN
                ReservEntry2.MODIFY;


            END;
        END;
    end;

    [Scope('Internal')]
    procedure ModifyReservEntry(ReservEntry: Record "25006392"; NewQuantity: Decimal; NewDescription: Text[50]; ModifyReserved: Boolean)
    var
        TotalQty: Decimal;
    begin
        IF NewQuantity * ReservEntry.Quantity < 0 THEN
            IF NewQuantity < 0 THEN
                ERROR(Text000, ReservEntry.FIELDCAPTION(Quantity))
            ELSE
                ERROR(Text001, ReservEntry.FIELDCAPTION(Quantity));
        IF NewQuantity = 0 THEN
            ERROR(Text002);
        IF ABS(NewQuantity) > ABS(ReservEntry.Quantity) THEN
            ERROR(Text003, ReservEntry.FIELDCAPTION(Quantity));

        IF ModifyReserved THEN BEGIN
            IF ReservEntry."Model Version No." <> ModelVersion."No." THEN
                GetModelVersion(ReservEntry."Model Version No.");

            ReservEntry.GET(ReservEntry."Entry No.", ReservEntry.Positive); // Get existing entry
            ReservEntry.VALIDATE(Quantity, NewQuantity);
            ReservEntry.Description := NewDescription;
            ReservEntry."Changed By" := USERID;
            ReservEntry.MODIFY;

            IF ReservEntry.GET(ReservEntry."Entry No.", NOT ReservEntry.Positive) THEN BEGIN // Get related entry
                ReservEntry.VALIDATE(Quantity, -NewQuantity);
                ReservEntry.Description := NewDescription;
                ReservEntry."Changed By" := USERID;
                ReservEntry.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CreateForText(ReservEntry: Record "25006392"): Text[80]
    begin

        IF ReservEntry.GET(ReservEntry."Entry No.", FALSE) THEN
            EXIT(CreateText(ReservEntry))
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure CreateFromText(ReservEntry: Record "25006392"): Text[80]
    begin

        IF ReservEntry.GET(ReservEntry."Entry No.", TRUE) THEN
            EXIT(CreateText(ReservEntry))
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure CreateText(ReservEntry: Record "25006392"): Text[80]
    var
        SourceType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component",Transfer,"Service Order";
        SourceTypeText: Label 'Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order';
    begin

        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SourceType := SourceType::Sales;
                    CalcSalesLine."Document Type" := ReservEntry."Source Subtype";
                    EXIT(STRSUBSTNO('%1 %2 %3', SELECTSTR(SourceType, SourceTypeText),
                      CalcSalesLine."Document Type", ReservEntry."Source ID"));
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    SourceType := SourceType::Purchase;
                    CalcPurchLine."Document Type" := ReservEntry."Source Subtype";
                    EXIT(STRSUBSTNO('%1 %2 %3', SELECTSTR(SourceType, SourceTypeText),
                      CalcPurchLine."Document Type", ReservEntry."Source ID"));
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    SourceType := SourceType::"Requisition Line";
                    EXIT(STRSUBSTNO('%1 %2 %3', SELECTSTR(SourceType, SourceTypeText),
                    ReservEntry."Source ID", ReservEntry."Source Batch Name"));
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    SourceType := SourceType::"Item Journal";
                    CalcItemJnlLine."Entry Type" := ReservEntry."Source Subtype";
                    EXIT(STRSUBSTNO('%1 %2 %3 %4', SELECTSTR(SourceType, SourceTypeText),
                      CalcItemJnlLine."Entry Type", ReservEntry."Source ID", ReservEntry."Source Batch Name"));
                END;
            DATABASE::"Item Ledger Entry":
                BEGIN
                    SourceType := SourceType::"Item Ledger Entry";
                    EXIT(STRSUBSTNO('%1 %2', SELECTSTR(SourceType, SourceTypeText), ReservEntry."Source Ref. No."));
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    SourceType := SourceType::Transfer;
                    EXIT(STRSUBSTNO('%1 %2, %3', SELECTSTR(SourceType, SourceTypeText),
                      ReservEntry."Source ID", SELECTSTR(ReservEntry."Source Subtype" + 1, Text005)));
                END;
            DATABASE::"Service Invoice Line":
                BEGIN
                    SourceType := SourceType::"Service Order";
                    EXIT(STRSUBSTNO('%1 %2', SELECTSTR(SourceType, SourceTypeText), ReservEntry."Source ID"));
                END;
        END;

        EXIT('');
    end;

    [Scope('Internal')]
    procedure InitFilterAndSortingFor(var FilterReservEntry: Record "25006392")
    begin
        FilterReservEntry.RESET;
        FilterReservEntry.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");
    end;

    [Scope('Internal')]
    procedure InitFilterAndSortingLookupFor(var FilterReservEntry: Record "25006392")
    begin

        FilterReservEntry.RESET;
        FilterReservEntry.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");
    end;

    [Scope('Internal')]
    procedure LastReservEntryNo(): Integer
    var
        ReservEntry: Record "25006392";
    begin

        IF ReservEntry.FINDLAST THEN
            EXIT(ReservEntry."Entry No.")
        ELSE
            EXIT(0);
    end;

    local procedure GetModelVersion(ModelVersionNo: Code[20])
    begin

        IF ModelVersion."No." <> ModelVersionNo THEN
            ModelVersion.GET(ModelVersionNo);
    end;

    [Scope('Internal')]
    procedure InitRecordSet(var ReservEntry: Record "25006392"): Boolean
    var
        IsDemand: Boolean;
        CarriesItemTracking: Boolean;
    begin

        // Used for combining sorting of reservation entries with priorities
        IF ReservEntry.ISEMPTY THEN
            EXIT(FALSE);

        IsDemand := ReservEntry.Quantity < 0;

        TempSortRec1.RESET;
        TempSortRec2.RESET;
        TempSortRec3.RESET;
        TempSortRec4.RESET;

        TempSortRec1.DELETEALL;
        TempSortRec2.DELETEALL;
        TempSortRec3.DELETEALL;
        TempSortRec4.DELETEALL;

        REPEAT
            TempSortRec1 := ReservEntry;
            TempSortRec1.INSERT;

            IF IsDemand THEN
                IF CarriesItemTracking THEN BEGIN
                    TempSortRec4 := TempSortRec1;
                    TempSortRec4.INSERT;
                    TempSortRec2.DELETE;
                END ELSE BEGIN
                    TempSortRec3 := TempSortRec1;
                    TempSortRec3.INSERT;
                END;
        UNTIL ReservEntry.NEXT = 0;

        SetKeyAndFilters(TempSortRec1);
        SetKeyAndFilters(TempSortRec2);
        SetKeyAndFilters(TempSortRec3);
        SetKeyAndFilters(TempSortRec4);

        EXIT(NEXTRecord(ReservEntry) <> 0);
    end;

    [Scope('Internal')]
    procedure NEXTRecord(var ReservEntry: Record "25006392"): Integer
    var
        Found: Boolean;
    begin

        // Used for combining sorting of reservation entries with priorities
        IF TempSortRec1.ISEMPTY THEN
            EXIT(0);
        IF NOT TempSortRec3.ISEMPTY THEN BEGIN // Reservations with no item tracking against inventory
            TempSortRec3.FINDFIRST;
            TempSortRec1 := TempSortRec3;
            TempSortRec3.DELETE;
            Found := TRUE;
        END;


        IF NOT Found THEN BEGIN
            IF NOT TempSortRec2.ISEMPTY THEN BEGIN // Records carrying item tracking
                TempSortRec2.FINDFIRST;
                TempSortRec1 := TempSortRec2;
                TempSortRec2.DELETE;
            END ELSE BEGIN
                IF NOT TempSortRec2.ISEMPTY THEN BEGIN // Records carrying item tracking
                    TempSortRec2.FINDFIRST;
                    TempSortRec1 := TempSortRec2;
                    TempSortRec2.DELETE;
                END;
            END;
        END;

        ReservEntry := TempSortRec1;
        TempSortRec1.DELETE;
        EXIT(1);
    end;

    local procedure SetKeyAndFilters(var ReservEntry: Record "25006392")
    begin

        IF ReservEntry.ISEMPTY THEN
            EXIT;

        ReservEntry.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");

        IF ReservEntry.FINDSET THEN
            ReservMgt.SetPointerFilter(ReservEntry);
    end;

    [Scope('Internal')]
    procedure RenamePointer(TableID: Integer; OldSubtype: Integer; OldID: Code[20]; OldBatchName: Code[10]; OldRefNo: Integer; NewSubtype: Integer; NewID: Code[20]; NewBatchName: Code[10]; NewRefNo: Integer)
    var
        ReservEntry: Record "25006392";
        NewReservEntry: Record "25006392";
        PointerFieldIsActive: array[6] of Boolean;
        W: Dialog;
    begin

        GetActivePointerFields(TableID, PointerFieldIsActive);
        IF NOT PointerFieldIsActive[1] THEN
            EXIT;

        ReservEntry.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");

        IF PointerFieldIsActive[3] THEN
            ReservEntry.SETRANGE("Source ID", OldID)
        ELSE
            ReservEntry.SETRANGE("Source ID", '');

        IF PointerFieldIsActive[6] THEN
            ReservEntry.SETRANGE("Source Ref. No.", OldRefNo)
        ELSE
            ReservEntry.SETRANGE("Source Ref. No.", 0);

        ReservEntry.SETRANGE("Source Type", TableID);

        IF PointerFieldIsActive[2] THEN
            ReservEntry.SETRANGE("Source Subtype", OldSubtype)
        ELSE
            ReservEntry.SETRANGE("Source Subtype", 0);

        IF PointerFieldIsActive[4] THEN
            ReservEntry.SETRANGE("Source Batch Name", OldBatchName)
        ELSE
            ReservEntry.SETRANGE("Source Batch Name", '');

        ReservEntry.Lock;

        IF ReservEntry.FINDSET(TRUE, TRUE) THEN BEGIN
            W.OPEN(Text007);
            REPEAT
                NewReservEntry := ReservEntry;
                IF OldSubtype <> NewSubtype THEN
                    NewReservEntry."Source Subtype" := NewSubtype;
                IF OldID <> NewID THEN
                    NewReservEntry."Source ID" := NewID;
                IF OldBatchName <> NewBatchName THEN
                    NewReservEntry."Source Batch Name" := NewBatchName;
                IF OldRefNo <> NewRefNo THEN
                    NewReservEntry."Source Ref. No." := NewRefNo;
                ReservEntry.DELETE;
                NewReservEntry.INSERT;
            UNTIL ReservEntry.NEXT = 0;
            W.CLOSE;
        END;
    end;

    local procedure GetActivePointerFields(TableID: Integer; var PointerFieldIsActive: array[6] of Boolean)
    begin

        CLEAR(PointerFieldIsActive);
        PointerFieldIsActive[1] := TRUE;  // Type

        CASE TableID OF
            DATABASE::"Sales Line", DATABASE::"Purchase Line", DATABASE::"Service Invoice Line":
                BEGIN
                    PointerFieldIsActive[2] := TRUE;  // SubType
                    PointerFieldIsActive[3] := TRUE;  // ID
                    PointerFieldIsActive[6] := TRUE;  // RefNo
                END;
            DATABASE::"Requisition Line", DATABASE::Table89:
                BEGIN
                    PointerFieldIsActive[3] := TRUE;  // ID
                    PointerFieldIsActive[4] := TRUE;  // BatchName
                    PointerFieldIsActive[6] := TRUE;  // RefNo
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    PointerFieldIsActive[2] := TRUE;  // SubType
                    PointerFieldIsActive[3] := TRUE;  // ID
                    PointerFieldIsActive[4] := TRUE;  // BatchName
                    PointerFieldIsActive[6] := TRUE;  // RefNo
                END;
            DATABASE::"Item Ledger Entry":
                BEGIN
                    PointerFieldIsActive[6] := TRUE;  // RefNo
                END;
            DATABASE::"Prod. Order Line":
                BEGIN
                    PointerFieldIsActive[2] := TRUE;  // SubType
                    PointerFieldIsActive[3] := TRUE;  // ID
                    PointerFieldIsActive[5] := TRUE;  // ProdOrderLine
                END;
            DATABASE::"Prod. Order Component", DATABASE::"Transfer Line":
                BEGIN
                    PointerFieldIsActive[2] := TRUE;  // SubType
                    PointerFieldIsActive[3] := TRUE;  // ID
                    PointerFieldIsActive[5] := TRUE;  // ProdOrderLine
                    PointerFieldIsActive[6] := TRUE;  // RefNo
                END;
            DATABASE::"Planning Component":
                BEGIN
                    PointerFieldIsActive[3] := TRUE;  // ID
                    PointerFieldIsActive[4] := TRUE;  // BatchName
                    PointerFieldIsActive[5] := TRUE;  // ProdOrderLine
                    PointerFieldIsActive[6] := TRUE;  // RefNo
                END;
            ELSE
                PointerFieldIsActive[1] := FALSE;  // Type is not used
        END;
    end;

    [Scope('Internal')]
    procedure CheckValidity(ReservEntry: Record "25006392"): Boolean
    begin

        IF ReservEntry."Source Type" IN [DATABASE::"Sales Line", DATABASE::"Purchase Line"] THEN
            IF NOT (ReservEntry."Source Subtype" IN [1, 5]) THEN
                EXIT; // Only order, return order

        IF ReservEntry."Source Type" IN [DATABASE::"Prod. Order Line", DATABASE::"Prod. Order Component"]
        THEN
            IF ReservEntry."Source Subtype" = 0 THEN
                EXIT; // Not simulation

        EXIT(TRUE);
    end;
}

