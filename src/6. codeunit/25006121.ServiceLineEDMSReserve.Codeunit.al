codeunit 25006121 "Service Line EDMS-Reserve"
{
    // 11.07.2013 EDMS P8
    //   * partial reserve fix
    // 
    // 08.07.08 EDMS P1 - EDMS Service Management integration

    Permissions = TableData 337 = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'Codeunit is not initialized correctly.';
        Text001: Label 'Reserved quantity cannot be greater than %1';
        Text002: Label 'must be filled in when a quantity is reserved';
        Text003: Label 'must not be changed when a quantity is reserved';
        Location: Record "14";
        CreateReservEntry: Codeunit "99000830";
        ReservEngineMgt: Codeunit "99000831";
        ReservMgt: Codeunit "99000845";
        ItemTrackingMgt: Codeunit "6500";
        SetFromType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry";
        SetFromSubtype: Integer;
        SetFromID: Code[20];
        SetFromBatchName: Code[10];
        SetFromProdOrderLine: Integer;
        SetFromRefNo: Integer;
        SetFromVariantCode: Code[20];
        SetFromLocationCode: Code[10];
        SetFromSerialNo: Code[20];
        SetFromLotNo: Code[20];
        SetFromQtyPerUOM: Decimal;
        DeleteItemTracking: Boolean;
        Text004: Label 'must not be filled in when a quantity is reserved';
        OverruleItemTracking: Boolean;
        Text005: Label 'You cannot delete Items that are fully reserved to Service Order.';

    [Scope('Internal')]
    procedure CreateReservation(var ServiceLine: Record "25006146"; Description: Text[50]; ExpectedReceiptDate: Date; Quantity: Decimal; ForSerialNo: Code[20]; ForLotNo: Code[20])
    var
        ShipmentDate: Date;
    begin
        IF SetFromType = 0 THEN
            ERROR(Text000);

        ServiceLine.TESTFIELD(Type, ServiceLine.Type::Item);
        ServiceLine.TESTFIELD("No.");

        ServiceLine.CALCFIELDS("Reserved Qty. (Base)");
        IF ServiceLine.Quantity < ServiceLine."Reserved Qty. (Base)" THEN
            ERROR(
              Text001,
              ServiceLine.Quantity);

        ServiceLine.TESTFIELD("Variant Code", SetFromVariantCode);
        ServiceLine.TESTFIELD("Location Code", SetFromLocationCode);

        IF Quantity > 0 THEN
            ShipmentDate := ServiceLine."Planned Service Date"
        ELSE BEGIN
            ShipmentDate := ExpectedReceiptDate;
            ExpectedReceiptDate := ServiceLine."Planned Service Date";
        END;

        CreateReservEntry.CreateReservEntryFor(
          DATABASE::"Service Line EDMS", ServiceLine."Document Type",
          ServiceLine."Document No.", '', 0, ServiceLine."Line No.",
          ServiceLine."Qty. per Unit of Measure", Quantity, Quantity, ForSerialNo, ForLotNo);
        //ServiceLine."Qty. per Unit of Measure",Quantity,ServiceLine."Quantity (Base)",ForSerialNo,ForLotNo);  //11.07.2013 EDMS P8
        CreateReservEntry.CreateReservEntryFrom(
          SetFromType, SetFromSubtype, SetFromID, SetFromBatchName, SetFromProdOrderLine, SetFromRefNo,
          SetFromQtyPerUOM, SetFromSerialNo, SetFromLotNo);
        CreateReservEntry.CreateReservEntry(
          ServiceLine."No.", ServiceLine."Variant Code", ServiceLine."Location Code",
          Description, ExpectedReceiptDate, ShipmentDate);

        SetFromType := 0;
    end;

    [Scope('Internal')]
    procedure CreateReservationSetFrom(TrackingSpecificationFrom: Record "336")
    begin
        SetFromType := TrackingSpecificationFrom."Source Type";
        SetFromSubtype := TrackingSpecificationFrom."Source Subtype";
        SetFromID := TrackingSpecificationFrom."Source ID";
        SetFromBatchName := TrackingSpecificationFrom."Source Batch Name";
        SetFromProdOrderLine := TrackingSpecificationFrom."Source Prod. Order Line";
        SetFromRefNo := TrackingSpecificationFrom."Source Ref. No.";
        SetFromVariantCode := TrackingSpecificationFrom."Variant Code";
        SetFromLocationCode := TrackingSpecificationFrom."Location Code";
        SetFromSerialNo := TrackingSpecificationFrom."Serial No.";
        SetFromLotNo := TrackingSpecificationFrom."Lot No.";
        SetFromQtyPerUOM := TrackingSpecificationFrom."Qty. per Unit of Measure";
    end;

    [Scope('Internal')]
    procedure FilterReservFor(var FilterReservEntry: Record "337"; ServiceLine: Record "25006146")
    begin
        FilterReservEntry.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
        FilterReservEntry.SETRANGE("Source Subtype", ServiceLine."Document Type");
        FilterReservEntry.SETRANGE("Source ID", ServiceLine."Document No.");
        FilterReservEntry.SETRANGE("Source Batch Name", '');
        FilterReservEntry.SETRANGE("Source Prod. Order Line", 0);
        FilterReservEntry.SETRANGE("Source Ref. No.", ServiceLine."Line No.");
    end;

    [Scope('Internal')]
    procedure Caption(ServiceLine: Record "25006146") CaptionText: Text[80]
    begin
        CaptionText :=
          STRSUBSTNO('%1 %2 %3', ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."No.");
    end;

    [Scope('Internal')]
    procedure FindReservEntry(ServiceLine: Record "25006146"; var ReservEntry: Record "337"): Boolean
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        FilterReservFor(ReservEntry, ServiceLine);
        EXIT(ReservEntry.FINDLAST);
    end;

    [Scope('Internal')]
    procedure ReservEntryExist(ServLine: Record "25006146"): Boolean
    var
        ReservEntry: Record "337";
    begin
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        FilterReservFor(ReservEntry, ServLine);
        EXIT(NOT ReservEntry.ISEMPTY);
    end;

    [Scope('Internal')]
    procedure ReservQuantity(ServLine: Record "25006146") QtyToReserve: Decimal
    begin
        CASE ServLine."Document Type" OF
            ServLine."Document Type"::Quote,
          ServLine."Document Type"::Order:
                //ServLine."Document Type"::Invoice:
                QtyToReserve := ServLine.Quantity;
        END;
    end;

    [Scope('Internal')]
    procedure VerifyChange(var NewServiceLine: Record "25006146"; var OldServiceLine: Record "25006146")
    var
        ServiceLine: Record "25006146";
        TempReservEntry: Record "337";
        ShowError: Boolean;
        HasError: Boolean;
    begin
        IF (NewServiceLine.Type <> NewServiceLine.Type::Item) AND (OldServiceLine.Type <> OldServiceLine.Type::Item) THEN
            EXIT;

        IF NewServiceLine."Line No." = 0 THEN
            IF NOT ServiceLine.GET(NewServiceLine."Document Type", NewServiceLine."Document No.", NewServiceLine."Line No.") THEN
                EXIT;

        NewServiceLine.CALCFIELDS("Reserved Qty. (Base)");
        ShowError := NewServiceLine."Reserved Qty. (Base)" <> 0;

        IF (NewServiceLine."Planned Service Date" = 0D) AND (OldServiceLine."Planned Service Date" <> 0D) THEN
            IF ShowError THEN
                NewServiceLine.FIELDERROR("Planned Service Date", Text002)
            ELSE
                HasError := TRUE;

        IF NewServiceLine.Type <> OldServiceLine.Type THEN
            IF ShowError THEN
                NewServiceLine.FIELDERROR(Type, Text003)
            ELSE
                HasError := TRUE;

        IF NewServiceLine."No." <> OldServiceLine."No." THEN
            IF ShowError THEN
                NewServiceLine.FIELDERROR("No.", Text003)
            ELSE
                HasError := TRUE;

        IF NewServiceLine."Variant Code" <> OldServiceLine."Variant Code" THEN
            IF ShowError THEN
                NewServiceLine.FIELDERROR("Variant Code", Text003)
            ELSE
                HasError := TRUE;

        IF NewServiceLine."Location Code" <> OldServiceLine."Location Code" THEN
            IF ShowError THEN
                NewServiceLine.FIELDERROR("Location Code", Text003)
            ELSE
                HasError := TRUE;

        IF (NewServiceLine."Bin Code" <> OldServiceLine."Bin Code") THEN
            IF ShowError THEN
                NewServiceLine.FIELDERROR("Bin Code", Text004)
            ELSE
                HasError := TRUE;

        IF NewServiceLine."Line No." <> OldServiceLine."Line No." THEN
            HasError := TRUE;

        IF HasError THEN
            IF (NewServiceLine."No." <> OldServiceLine."No.") OR
               FindReservEntry(NewServiceLine, TempReservEntry)
            THEN BEGIN
                IF NewServiceLine."No." <> OldServiceLine."No." THEN BEGIN
                    ReservMgt.SetServLineEDMS(OldServiceLine);
                    ReservMgt.DeleteReservEntries(TRUE, 0);
                    ReservMgt.SetServLineEDMS(NewServiceLine);
                END ELSE BEGIN
                    ReservMgt.SetServLineEDMS(NewServiceLine);
                    ReservMgt.DeleteReservEntries(TRUE, 0);
                END;
                ReservMgt.AutoTrack(NewServiceLine."Outstanding Qty. (Base)");
            END;

        IF HasError //OR (NewServiceLine."Planned Service Date" <> NewServiceLine."Planned Service Date")
        THEN BEGIN
            AssignForPlanning(NewServiceLine);
            IF (NewServiceLine."No." <> OldServiceLine."No.") OR
               (NewServiceLine."Variant Code" <> OldServiceLine."Variant Code") OR
               (NewServiceLine."Location Code" <> OldServiceLine."Location Code")
            THEN
                AssignForPlanning(OldServiceLine);
        END;
    end;

    [Scope('Internal')]
    procedure VerifyQuantity(var NewServiceLine: Record "25006146"; var OldServiceLine: Record "25006146")
    var
        ServiceLine: Record "25006146";
    begin

        IF Type <> Type::Item THEN
            EXIT;
        IF "Line No." = OldServiceLine."Line No." THEN
            IF "Quantity (Base)" = OldServiceLine."Quantity (Base)" THEN
                EXIT;
        IF "Line No." = 0 THEN
            IF NOT ServiceLine.GET(NewServiceLine."Document Type", NewServiceLine."Document No.", "Line No.") THEN
                EXIT;
        ReservMgt.SetServLineEDMS(NewServiceLine);
        IF "Qty. per Unit of Measure" <> OldServiceLine."Qty. per Unit of Measure" THEN
            ReservMgt.ModifyUnitOfMeasure;
        IF "Outstanding Qty. (Base)" * OldServiceLine."Outstanding Qty. (Base)" < 0 THEN
            ReservMgt.DeleteReservEntries(FALSE, 0)
        ELSE
            ReservMgt.DeleteReservEntries(FALSE, "Outstanding Qty. (Base)");
        ReservMgt.ClearSurplus;
        ReservMgt.AutoTrack("Outstanding Qty. (Base)");
        AssignForPlanning(NewServiceLine);
    end;

    [Scope('Internal')]
    procedure AssignForPlanning(var ServiceLine: Record "25006146")
    var
        PlanningAssignment: Record "99000850";
        ServiceHeader: Record "25006145";
    begin
        IF ServiceLine."Document Type" <> ServiceLine."Document Type"::Order THEN
            EXIT;
        IF Type <> Type::Item THEN
            EXIT;
        IF "No." <> '' THEN
            ServiceHeader.GET(ServiceLine."Document Type", ServiceLine."Document No.");
        PlanningAssignment.ChkAssignOne("No.", "Variant Code", "Location Code", "Planned Service Date");
    end;

    [Scope('Internal')]
    procedure RenameLine(var NewServiceLine: Record "25006146"; var OldServiceLine: Record "25006146")
    begin
        ReservEngineMgt.RenamePointer(DATABASE::"Service Line EDMS",
          OldServiceLine."Document Type",
          OldServiceLine."Document No.",
          '',
          0,
          OldServiceLine."Line No.",
          NewServiceLine."Document Type",
          NewServiceLine."Document No.",
          '',
          0,
          NewServiceLine."Line No.");
    end;

    [Scope('Internal')]
    procedure DeleteLineConfirm(var ServLine: Record "25006146"): Boolean
    begin
        IF NOT ReservEntryExist(ServLine) THEN
            EXIT(TRUE);

        ReservMgt.SetServLineEDMS(ServLine);
        IF ReservMgt.DeleteItemTrackingConfirm THEN
            DeleteItemTracking := TRUE;

        EXIT(DeleteItemTracking);
    end;

    [Scope('Internal')]
    procedure DeleteLine(var ServLine: Record "25006146")
    begin
        IF NOT ReservEntryExist(ServLine) THEN
            EXIT;
        //Sipradi-YS * Code to not allowing deletion of reserved items.
        //ELSE
        //ERROR(Text005);
        //Sipradi-YS END;
        ReservMgt.SetServLineEDMS(ServLine);
        IF DeleteItemTracking THEN
            ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
        ReservMgt.DeleteReservEntries(TRUE, 0);
        DeleteInvoiceSpecFromLine(ServLine);
        ServLine.CALCFIELDS("Reserved Qty. (Base)");
    end;

    [Scope('Internal')]
    procedure CallItemTracking(var ServiceLine: Record "25006146")
    var
        TrackingSpecification: Record "336";
        ServiceHeader: Record "25006145";
        ItemTrackingForm: Page "6510";
    begin
        InitTrackingSpecification(ServiceLine, TrackingSpecification);
        ServiceHeader.GET(ServiceLine."Document Type", ServiceLine."Document No.");
        ItemTrackingForm.SetSourceSpec(TrackingSpecification, ServiceHeader."Posting Date");


        ItemTrackingForm.SetInbound(
          ((ServiceLine."Document Type" IN [ServiceLine."Document Type"::"Return Order"]) AND
           (ServiceLine."Quantity (Base)" > 0)) OR
          ((ServiceLine."Document Type" IN [ServiceLine."Document Type"::Order]) AND
           (ServiceLine."Quantity (Base)" < 0)));

        ItemTrackingForm.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure InitTrackingSpecification(var ServiceLine: Record "25006146"; var TrackingSpecification: Record "336")
    begin
        TrackingSpecification.INIT;
        TrackingSpecification."Source Type" := DATABASE::"Service Line EDMS";
        TrackingSpecification."Item No." := "No.";
        TrackingSpecification."Location Code" := "Location Code";
        TrackingSpecification.Description := Description;
        TrackingSpecification."Variant Code" := "Variant Code";
        TrackingSpecification."Source Subtype" := ServiceLine."Document Type";
        TrackingSpecification."Source ID" := ServiceLine."Document No.";
        TrackingSpecification."Source Batch Name" := '';
        TrackingSpecification."Source Prod. Order Line" := 0;
        TrackingSpecification."Source Ref. No." := "Line No.";
        TrackingSpecification."Quantity (Base)" := "Quantity (Base)";
        TrackingSpecification."Qty. to Invoice (Base)" := "Quantity (Base)";
        TrackingSpecification."Qty. to Invoice" := Quantity;
        TrackingSpecification."Quantity Invoiced (Base)" := "Quantity (Base)";

        TrackingSpecification."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        TrackingSpecification."Bin Code" := "Bin Code";

        IF ServiceLine."Document Type" IN [ServiceLine."Document Type"::"Return Order"] THEN BEGIN
            TrackingSpecification."Qty. to Handle (Base)" := "Quantity (Base)";
            TrackingSpecification."Quantity Handled (Base)" := "Quantity (Base)";
            TrackingSpecification."Qty. to Handle" := Quantity;
        END ELSE BEGIN
            TrackingSpecification."Qty. to Handle (Base)" := "Quantity (Base)";
            TrackingSpecification."Quantity Handled (Base)" := "Quantity (Base)";
            TrackingSpecification."Qty. to Handle" := Quantity;
        END;
    end;

    [Scope('Internal')]
    procedure TransServLineToServLine(var OldServLine: Record "25006146"; var NewServLine: Record "25006146"; TransferQty: Decimal)
    var
        OldReservEntry: Record "337";
        Status: Option Reservation,Tracking,Surplus,Prospect;
    begin
        IF NOT FindReservEntry(OldServLine, OldReservEntry) THEN
            EXIT;

        OldReservEntry.Lock;

        NewServLine.TESTFIELD("No.", OldServLine."No.");
        NewServLine.TESTFIELD("Variant Code", OldServLine."Variant Code");
        NewServLine.TESTFIELD("Location Code", OldServLine."Location Code");

        FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
            IF TransferQty = 0 THEN
                EXIT;
            OldReservEntry.SETRANGE("Reservation Status", Status);
            IF OldReservEntry.FINDSET THEN
                REPEAT
                    OldReservEntry.TESTFIELD(OldReservEntry."Item No.", OldServLine."No.");
                    OldReservEntry.TESTFIELD(OldReservEntry."Variant Code", OldServLine."Variant Code");
                    OldReservEntry.TESTFIELD(OldReservEntry."Location Code", OldServLine."Location Code");

                    TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Service Line EDMS",
                        NewServLine."Document Type", NewServLine."Document No.", '', 0,
                        NewServLine."Line No.", NewServLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);

                UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
        END;
    end;

    [Scope('Internal')]
    procedure RetrieveInvoiceSpecification(var ServLine: Record "25006146"; var TempInvoicingSpecification: Record "336" temporary; Consume: Boolean) OK: Boolean
    var
        SourceSpecification: Record "336";
    begin
        IF ServLine.Type <> ServLine.Type::Item THEN
            EXIT;
        InitTrackingSpecification(ServLine, SourceSpecification);
        OK := ItemTrackingMgt.RetrieveInvoiceSpecWithService(SourceSpecification, TempInvoicingSpecification, Consume);
        //END;
    end;

    local procedure RetrieveInvoiceSpecification2(var ServLine: Record "25006146"; var TempInvoicingSpecification: Record "336" temporary) OK: Boolean
    var
        TrackingSpecification: Record "336";
        ReservEntry: Record "337";
    begin
        // Used for combined shipment:
        IF ServLine.Type <> ServLine.Type::Item THEN
            EXIT;
        IF NOT FindReservEntry(ServLine, ReservEntry) THEN
            EXIT;
        ReservEntry.FINDSET;
        REPEAT
            ReservEntry.TESTFIELD("Reservation Status", ReservEntry."Reservation Status"::Prospect);
            ReservEntry.TESTFIELD("Item Ledger Entry No.");
            TrackingSpecification.GET(ReservEntry."Item Ledger Entry No.");
            TempInvoicingSpecification := TrackingSpecification;
            TempInvoicingSpecification."Qty. to Invoice (Base)" :=
              ReservEntry."Qty. to Invoice (Base)";
            TempInvoicingSpecification."Qty. to Invoice" :=
              ROUND(ReservEntry."Qty. to Invoice (Base)" / ReservEntry."Qty. per Unit of Measure", 0.00001);
            TempInvoicingSpecification."Buffer Status" := TempInvoicingSpecification."Buffer Status"::MODIFY;
            TempInvoicingSpecification.INSERT;
            ReservEntry.DELETE;
        UNTIL ReservEntry.NEXT = 0;

        OK := TempInvoicingSpecification.FINDFIRST;
    end;

    [Scope('Internal')]
    procedure DeleteInvoiceSpecFromHeader(var ServHeader: Record "25006145")
    var
        TrackingSpecification: Record "336";
    begin
        TrackingSpecification.SETCURRENTKEY("Source ID", "Source Type",
          "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        TrackingSpecification.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
        TrackingSpecification.SETRANGE("Source Subtype", ServHeader."Document Type");
        TrackingSpecification.SETRANGE("Source ID", ServHeader."No.");
        TrackingSpecification.SETRANGE("Source Batch Name", '');
        TrackingSpecification.SETRANGE("Source Prod. Order Line", 0);
        IF TrackingSpecification.FINDSET THEN
            REPEAT
                TrackingSpecification.DELETE;
            UNTIL TrackingSpecification.NEXT = 0;
    end;

    local procedure DeleteInvoiceSpecFromLine(ServLine: Record "25006146")
    var
        TrackingSpecification: Record "336";
    begin
        TrackingSpecification.SETCURRENTKEY("Source ID", "Source Type",
          "Source Subtype", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.");
        TrackingSpecification.SETRANGE("Source ID", ServLine."Document No.");
        TrackingSpecification.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
        TrackingSpecification.SETRANGE("Source Subtype", ServLine."Document Type");
        TrackingSpecification.SETRANGE("Source Batch Name", '');
        TrackingSpecification.SETRANGE("Source Prod. Order Line", 0);
        TrackingSpecification.SETRANGE("Source Ref. No.", ServLine."Line No.");
        IF TrackingSpecification.FINDSET THEN
            REPEAT
                TrackingSpecification.DELETE;
            UNTIL TrackingSpecification.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure TransServLineToItemJnlLine(var ServLine: Record "25006146"; var ItemJnlLine: Record "83"; TransferQty: Decimal; var CheckApplFromItemEntry: Boolean): Decimal
    var
        OldReservEntry: Record "337";
    begin
        IF NOT FindReservEntry(ServLine, OldReservEntry) THEN
            EXIT(TransferQty);

        OldReservEntry.Lock;

        IF OverruleItemTracking THEN
            IF (ItemJnlLine."Serial No." <> '') OR (ItemJnlLine."Lot No." <> '') THEN BEGIN
                CreateReservEntry.SetNewSerialLotNo(ItemJnlLine."Serial No.", ItemJnlLine."Lot No.");
                CreateReservEntry.SetOverruleItemTracking(TRUE);
                // Try to match against Item Tracking on the service order line:
                OldReservEntry.SETRANGE("Serial No.", ItemJnlLine."Serial No.");
                OldReservEntry.SETRANGE("Lot No.", ItemJnlLine."Lot No.");
                IF OldReservEntry.ISEMPTY THEN
                    EXIT(TransferQty);
            END;


        ItemJnlLine.TESTFIELD("Item No.", ServLine."No.");
        ItemJnlLine.TESTFIELD("Variant Code", ServLine."Variant Code");
        ItemJnlLine.TESTFIELD("Location Code", ServLine."Location Code");

        IF TransferQty = 0 THEN
            EXIT;

        IF ItemJnlLine."Invoiced Quantity" <> 0 THEN
            CreateReservEntry.SetUseQtyToInvoice(TRUE);

        IF ReservEngineMgt.InitRecordSet(OldReservEntry) THEN BEGIN
            REPEAT
                OldReservEntry.TESTFIELD(OldReservEntry."Item No.", ServLine."No.");
                OldReservEntry.TESTFIELD(OldReservEntry."Variant Code", ServLine."Variant Code");
                OldReservEntry.TESTFIELD(OldReservEntry."Location Code", ServLine."Location Code");

                IF CheckApplFromItemEntry THEN BEGIN
                    OldReservEntry.TESTFIELD("Appl.-from Item Entry");
                    CreateReservEntry.SetApplyFromEntryNo(OldReservEntry."Appl.-from Item Entry");
                END;

                TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Item Journal Line",
                    ItemJnlLine."Entry Type", ItemJnlLine."Journal Template Name",
                    ItemJnlLine."Journal Batch Name", 0, ItemJnlLine."Line No.",
                    ItemJnlLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);

            UNTIL (ReservEngineMgt.NEXTRecord(OldReservEntry) = 0) OR (TransferQty = 0);
            CheckApplFromItemEntry := FALSE;
        END;
        EXIT(TransferQty);
    end;

    [Scope('Internal')]
    procedure UpdateItemTrackingAfterPosting(var ServHeader: Record "25006145")
    var
        ReservEntry: Record "337";
    begin
        // Used for updating Quantity to Handle and Quantity to Invoice after posting
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, FALSE);
        ReservEntry.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
        ReservEntry.SETRANGE("Source Subtype", ServHeader."Document Type");
        ReservEntry.SETRANGE("Source ID", ServHeader."No.");
        ReservEntry.SETRANGE("Source Batch Name", '');
        ReservEntry.SETRANGE("Source Prod. Order Line", 0);
        IF ReservEntry.FINDSET THEN
            REPEAT
                ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
                ReservEntry."Qty. to Invoice (Base)" := ReservEntry."Quantity (Base)";
                ReservEntry.MODIFY;


            UNTIL ReservEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SetBinding(Binding: Option " ","Order-to-Order")
    begin
        CreateReservEntry.SetBinding(Binding);
    end;

    [Scope('Internal')]
    procedure TransServLineToSalesLine(var OldServLine: Record "25006146"; var NewSalesLine: Record "37"; TransferQty: Decimal)
    var
        OldReservEntry: Record "337";
        Status: Option Reservation,Tracking,Surplus,Prospect;
    begin
        IF NOT FindReservEntry(OldServLine, OldReservEntry) THEN
            EXIT;

        OldReservEntry.Lock;

        NewSalesLine.TESTFIELD("No.", OldServLine."No.");
        NewSalesLine.TESTFIELD("Variant Code", OldServLine."Variant Code");
        NewSalesLine.TESTFIELD("Location Code", OldServLine."Location Code");

        FOR Status := Status::Reservation TO Status::Prospect DO BEGIN
            IF TransferQty = 0 THEN
                EXIT;
            OldReservEntry.SETRANGE("Reservation Status", Status);
            IF OldReservEntry.FINDSET THEN
                REPEAT
                    OldReservEntry.TESTFIELD(OldReservEntry."Item No.", OldServLine."No.");
                    OldReservEntry.TESTFIELD(OldReservEntry."Variant Code", OldServLine."Variant Code");
                    OldReservEntry.TESTFIELD(OldReservEntry."Location Code", OldServLine."Location Code");

                    TransferQty := CreateReservEntry.TransferReservEntry(DATABASE::"Sales Line",
                        NewSalesLine."Document Type", NewSalesLine."Document No.", '', 0,
                        NewSalesLine."Line No.", NewSalesLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);

                UNTIL (OldReservEntry.NEXT = 0) OR (TransferQty = 0);
        END;
    end;
}

