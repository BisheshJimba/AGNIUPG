codeunit 25006318 "Req. Line-Veh. Reserve"
{
    Permissions = TableData 337 = rimd,
                  TableData 99000849 = rmd;

    trigger OnRun()
    begin
    end;

    var
        Text005: Label 'Codeunit is not initialized correctly.';
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
    procedure CreateReservation(var ReqLine: Record "246"; Description: Text[50])
    var
        ShipmentDate: Date;
    begin
        IF SetFromType = 0 THEN
            ERROR(Text005);

        ReqLine.TESTFIELD(Type, ReqLine.Type::Item);
        ReqLine.TESTFIELD("No.");
        ReqLine.TESTFIELD("Model Version No.");

        ReqLine.TESTFIELD("Location Code", SetFromLocationCode);


        CreateReservEntry.CreateReservEntryFor(
          DATABASE::"Requisition Line", 0,
          ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name", 0, ReqLine."Line No.");
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromRefNo);
        CreateReservEntry.CreateReservEntry(
          ReqLine."No.", ReqLine."Vehicle Serial No.", ReqLine."Location Code",
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
    procedure FilterReservFor(var FilterReservEntry: Record "25006392"; ReqLine: Record "246")
    begin
        FilterReservEntry.SETRANGE("Source Type", DATABASE::"Requisition Line");
        FilterReservEntry.SETRANGE("Source Subtype", 0);
        FilterReservEntry.SETRANGE("Source ID", ReqLine."Worksheet Template Name");
        FilterReservEntry.SETRANGE("Source Batch Name", ReqLine."Journal Batch Name");
        FilterReservEntry.SETRANGE("Source Ref. No.", ReqLine."Line No.");
    end;

    [Scope('Internal')]
    procedure FindReservEntry(ReqLine: Record "246"; var ReservEntry: Record "25006392"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry);
        FilterReservFor(ReservEntry, ReqLine);
        EXIT(ReservEntry.FINDLAST);
    end;

    [Scope('Internal')]
    procedure TransferReqLineToPurchLine(var ReqLine: Record "246"; var PurchLine: Record "39")
    var
        OldReservEntry: Record "25006392";
        OldReservEntry2: Record "25006392";
        NewReservEntry: Record "25006392";
    begin
        IF NOT FindReservEntry(ReqLine, OldReservEntry) THEN
            EXIT;

        OldReservEntry.Lock;

        PurchLine.TESTFIELD("No.", ReqLine."No.");
        PurchLine.TESTFIELD("Variant Code", ReqLine."Variant Code");
        PurchLine.TESTFIELD("Location Code", ReqLine."Location Code");

        OldReservEntry.FINDSET;

        REPEAT
            OldReservEntry.TESTFIELD(OldReservEntry."Model Version No.", ReqLine."Model Version No.");
            OldReservEntry.TESTFIELD(OldReservEntry."Vehicle Serial No.", ReqLine."Vehicle Serial No.");
            OldReservEntry.TESTFIELD("Location Code", ReqLine."Location Code");

            NewReservEntry := OldReservEntry;
            NewReservEntry."Source Type" := DATABASE::"Purchase Line";
            NewReservEntry."Source Subtype" := PurchLine."Document Type";
            NewReservEntry."Source ID" := PurchLine."Document No.";
            NewReservEntry."Source Batch Name" := '';
            NewReservEntry."Source Ref. No." := PurchLine."Line No.";

            IF OldReservEntry2.GET(OldReservEntry."Entry No.", NOT OldReservEntry.Positive) THEN BEGIN
                IF CreateReservEntry.HasSamePointer(OldReservEntry2, NewReservEntry) THEN BEGIN
                    OldReservEntry2.DELETE;
                    NewReservEntry.DELETE;
                END ELSE
                    NewReservEntry.MODIFY;
            END ELSE
                NewReservEntry.MODIFY;

        UNTIL OldReservEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure DeleteLine(var ReqLine: Record "246")
    begin
        IF Blocked THEN
            EXIT;

        ReservMgt.SetReqLine(ReqLine);
        ReservMgt.DeleteReservEntries(TRUE);
    end;
}

