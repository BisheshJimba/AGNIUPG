page 25006529 "Vehicle Reservation"
{
    Caption = 'Vehicle Reservation';
    DataCaptionExpression = CaptionText;
    DeleteAllowed = false;
    PageType = Worksheet;
    SourceTable = Table25006393;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ReservEntry."Make Code";
                    ReservEntry."Make Code")
                {
                    Caption = 'Make Code';
                    Editable = false;
                }
                field(ReservEntry."Model Code";
                    ReservEntry."Model Code")
                {
                    Caption = 'Model Code';
                    Editable = false;
                }
                field(ReservEntry."Model Version No.";
                    ReservEntry."Model Version No.")
                {
                    Caption = 'Model Version No.';
                    Editable = false;
                }
                field(ReservEntry."Vehicle Serial No.";
                    ReservEntry."Vehicle Serial No.")
                {
                    Caption = 'Vehicle Serial No.';
                    Editable = false;
                }
                field(ReservEntry."Location Code";
                    ReservEntry."Location Code")
                {
                    Caption = 'Location Code';
                    Editable = false;
                }
                field(QtyToReserveBase; QtyToReserveBase)
                {
                    Caption = 'Quantity to Reserve';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(QtyReservedBase; QtyReservedBase)
                {
                    Caption = 'Reserved Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(UnreservedQuantity; QtyToReserveBase - QtyReservedBase)
                {
                    Caption = 'Unreserved Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
            }
            repeater()
            {
                Editable = false;
                field("Source Type"; "Source Type")
                {
                    Visible = false;
                }
                field("Source Subtype"; "Source Subtype")
                {
                    Visible = false;
                }
                field("Source ID"; "Source ID")
                {
                    Visible = false;
                }
                field("Source Batch Name"; "Source Batch Name")
                {
                    Visible = false;
                }
                field("Source Ref. No."; "Source Ref. No.")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field(Reserved; Reserved)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Auto Reserve")
                {
                    Caption = '&Auto Reserve';
                    Image = AutoReserve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AutoReserve;
                    end;
                }
                action("&Reserve from Current Line")
                {
                    Caption = '&Reserve from Current Line';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        ReservMgt.AutoReserveOneLine(Rec);
                        UpdateReservFrom;
                    end;
                }
                action("&Cancel Reservation")
                {
                    Caption = '&Cancel Reservation';
                    Image = Cancel;

                    trigger OnAction()
                    var
                        ReservEntry3: Record "25006392";
                        RecordsFound: Boolean;
                    begin
                        CLEAR(ReservEntry2);
                        ReservEntry2 := ReservEntry;
                        ReservMgt.SetPointerFilter(ReservEntry2);
                        IF ReservEntry2.FINDSET THEN
                            REPEAT
                                ReservEntry3.GET(ReservEntry2."Entry No.", NOT ReservEntry2.Positive);
                                IF RelatesToSummEntry(ReservEntry3, Rec) THEN BEGIN
                                    ReservEngineMgt.CloseReservEntry2(ReservEntry2);
                                    RecordsFound := TRUE;
                                END;
                            UNTIL ReservEntry2.NEXT = 0;

                        IF RecordsFound THEN
                            UpdateReservFrom
                        ELSE
                            ERROR(Text005);
                    end;
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        ReservSummEntry := Rec;
        IF NOT ReservSummEntry.FIND(Which) THEN
            EXIT(FALSE);
        Rec := ReservSummEntry;
        Rec.CALCFIELDS(Reserved);
        EXIT(TRUE);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        ReservSummEntry := Rec;
        CurrentSteps := ReservSummEntry.NEXT(Steps);
        IF CurrentSteps <> 0 THEN
            Rec := ReservSummEntry;
        Rec.CALCFIELDS(Reserved);
        EXIT(CurrentSteps);
    end;

    trigger OnOpenPage()
    begin
        FormIsOpen := TRUE;
        ReservEntry.CALCFIELDS("Make Code", "Model Code");
    end;

    var
        Text000: Label 'Fully reserved.';
        Text001: Label 'Full automatic Reservation not possible.\Reserve manually.';
        Text002: Label 'There is nothing available to reserve.';
        Text003: Label 'Do you want to cancel all reservations in the %1?';
        Text005: Label 'There are no reservations to cancel.';
        ReservEntry: Record "25006392";
        ReservEntry2: Record "25006392";
        SalesLine: Record "37";
        PurchLine: Record "39";
        ItemJnlLine: Record "83";
        ReqLine: Record "246";
        TransLine: Record "5741";
        ReservSummEntry: Record "25006393" temporary;
        ReservMgt: Codeunit "25006300";
        ReservEngineMgt: Codeunit "25006316";
        ReserveSalesLine: Codeunit "99000832";
        ReserveReqLine: Codeunit "99000833";
        ReservePurchLine: Codeunit "99000834";
        ReserveItemJnlLine: Codeunit "99000835";
        ReserveTransLine: Codeunit "99000836";
        CreateReservEntry: Codeunit "25006315";
        CurrentSteps: Integer;
        CaptionText: Text[130];
        FormIsOpen: Boolean;
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        QtyReserved: Decimal;
        QtyReservedBase: Decimal;
        QtyPerUOM: Decimal;
        FullAutoReservation: Boolean;

    [Scope('Internal')]
    procedure SetSalesLine(var CurrentSalesLine: Record "37")
    begin
        CurrentSalesLine.TESTFIELD("Job No.", '');
        CurrentSalesLine.TESTFIELD("Drop Shipment", FALSE);
        CurrentSalesLine.TESTFIELD(Type, CurrentSalesLine.Type::Item);
        CurrentSalesLine.TESTFIELD("Shipment Date");

        SalesLine := CurrentSalesLine;
        ReservEntry."Source Type" := DATABASE::"Sales Line";
        ReservEntry."Source Subtype" := SalesLine."Document Type";
        ReservEntry."Source ID" := SalesLine."Document No.";
        ReservEntry."Source Ref. No." := SalesLine."Line No.";

        ReservEntry."Model Version No." := SalesLine."No.";
        ReservEntry."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        ReservEntry."Location Code" := SalesLine."Location Code";

        CaptionText := ReserveSalesLine.Caption(SalesLine);
        UpdateReservFrom;
    end;

    [Scope('Internal')]
    procedure SetReqLine(var CurrentReqLine: Record "246")
    begin
        CurrentReqLine.TESTFIELD("Sales Order No.", '');
        CurrentReqLine.TESTFIELD("Sales Order Line No.", 0);
        CurrentReqLine.TESTFIELD("Sell-to Customer No.", '');
        CurrentReqLine.TESTFIELD(Type, CurrentReqLine.Type::Item);
        CurrentReqLine.TESTFIELD("Model Version No.");

        ReqLine := CurrentReqLine;

        ReservEntry."Source Type" := DATABASE::"Requisition Line";
        ReservEntry."Source ID" := ReqLine."Worksheet Template Name";
        ReservEntry."Source Batch Name" := ReqLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := ReqLine."Line No.";

        ReservEntry."Model Version No." := ReqLine."No.";
        ReservEntry."Vehicle Serial No." := ReqLine."Vehicle Serial No.";
        ReservEntry."Location Code" := ReqLine."Location Code";

        CaptionText := ReserveReqLine.Caption(ReqLine);
        UpdateReservFrom;
    end;

    [Scope('Internal')]
    procedure SetPurchLine(var CurrentPurchLine: Record "39")
    begin
        CurrentPurchLine.TESTFIELD("Job No.", '');
        CurrentPurchLine.TESTFIELD("Drop Shipment", FALSE);
        CurrentPurchLine.TESTFIELD(Type, CurrentPurchLine.Type::Item);
        CurrentPurchLine.TESTFIELD("Expected Receipt Date");

        PurchLine := CurrentPurchLine;
        ReservEntry."Source Type" := DATABASE::"Purchase Line";
        ReservEntry."Source Subtype" := PurchLine."Document Type";
        ReservEntry."Source ID" := PurchLine."Document No.";
        ReservEntry."Source Ref. No." := PurchLine."Line No.";

        ReservEntry."Model Version No." := PurchLine."No.";
        ReservEntry."Vehicle Serial No." := PurchLine."Vehicle Serial No.";
        ReservEntry."Location Code" := PurchLine."Location Code";

        CaptionText := ReservePurchLine.Caption(PurchLine);
        UpdateReservFrom;
    end;

    [Scope('Internal')]
    procedure SetItemJnlLine(var CurrentItemJnlLine: Record "83")
    begin
        CurrentItemJnlLine.TESTFIELD("Drop Shipment", FALSE);
        CurrentItemJnlLine.TESTFIELD("Posting Date");

        ItemJnlLine := CurrentItemJnlLine;
        ReservEntry."Source Type" := DATABASE::"Item Journal Line";
        ReservEntry."Source Subtype" := ItemJnlLine."Entry Type";
        ReservEntry."Source ID" := ItemJnlLine."Journal Template Name";
        ReservEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
        ReservEntry."Source Ref. No." := ItemJnlLine."Line No.";

        ReservEntry."Model Version No." := ItemJnlLine."Item No.";
        ReservEntry."Vehicle Serial No." := ItemJnlLine."Vehicle Serial No.";
        ReservEntry."Location Code" := ItemJnlLine."Location Code";

        CaptionText := ReserveItemJnlLine.Caption(ItemJnlLine);
        UpdateReservFrom;
    end;

    [Scope('Internal')]
    procedure SetTransLine(CurrentTransLine: Record "5741"; Direction: Option Outbound,Inbound)
    begin
        CLEARALL;

        TransLine := CurrentTransLine;
        ReservEntry."Source Type" := DATABASE::"Transfer Line";
        ReservEntry."Source Subtype" := Direction;
        ReservEntry."Source ID" := CurrentTransLine."Document No.";
        ReservEntry."Source Ref. No." := CurrentTransLine."Line No.";

        ReservEntry."Model Version No." := CurrentTransLine."Item No.";
        ReservEntry."Vehicle Serial No." := CurrentTransLine."Vehicle Serial No.";
        CASE Direction OF
            Direction::Outbound:
                BEGIN
                    ReservEntry."Location Code" := CurrentTransLine."Transfer-from Code";
                END;
            Direction::Inbound:
                BEGIN
                    ReservEntry."Location Code" := CurrentTransLine."Transfer-to Code";
                END;
        END;

        CaptionText := ReserveTransLine.Caption(TransLine);
        UpdateReservFrom;
    end;

    [Scope('Internal')]
    procedure SetReservEntry(ReservEntry2: Record "25006392")
    begin
        ReservEntry := ReservEntry2;
        UpdateReservMgt;
    end;

    [Scope('Internal')]
    procedure FilterReservEntry(var FilterReservEntry: Record "25006392"; FromReservSummEntry: Record "25006393")
    begin
        FilterReservEntry.SETRANGE("Model Version No.", ReservEntry."Model Version No.");

        CASE FromReservSummEntry.Sequence OF
            1:
                BEGIN // Item Ledger Entry
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Item Ledger Entry");
                    FilterReservEntry.SETRANGE("Source Subtype", 0);
                END;
            11, 12, 13, 14, 15, 16:
                BEGIN // Purchase Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Purchase Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry.Sequence - 11);
                END;
            21:
                BEGIN // Requisition Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Requisition Line");
                    FilterReservEntry.SETRANGE("Source Subtype", 0);
                END;
            31, 32, 33, 34, 35, 36:
                BEGIN // Sales Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry.Sequence - 31);
                END;
            41, 42, 43, 44, 45:
                BEGIN // Item Journal Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Item Journal Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry.Sequence - 41);
                END;
            61, 62, 63, 64:
                BEGIN // prod. order
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry.Sequence - 61);
                END;
            71, 72, 73, 74:
                BEGIN // prod. order
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Prod. Order Component");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry.Sequence - 71);
                END;
            91:
                BEGIN // Planning Component
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Planning Component");
                    FilterReservEntry.SETRANGE("Source Subtype", 0);
                END;
            101, 102:
                BEGIN // Transfer Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Transfer Line");
                    FilterReservEntry.SETRANGE("Source Subtype", FromReservSummEntry.Sequence - 101);
                END;
            110:
                BEGIN // Service Invoice Line
                    FilterReservEntry.SETRANGE("Source Type", DATABASE::"Service Invoice Line");
                    FilterReservEntry.SETRANGE("Source Subtype", 0);
                END;
        END;

        FilterReservEntry.SETRANGE("Location Code", ReservEntry."Location Code");
        FilterReservEntry.SETRANGE("Vehicle Serial No.", ReservEntry."Vehicle Serial No.");
        FilterReservEntry.SETRANGE(Positive, ReservMgt.IsPositive);
    end;

    [Scope('Internal')]
    procedure RelatesToSummEntry(var FilterReservEntry: Record "25006392"; FromReservSummEntry: Record "25006393"): Boolean
    begin
        CASE FromReservSummEntry.Sequence OF
            1: // Item Ledger Entry
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Item Ledger Entry") AND
                  (FilterReservEntry."Source Subtype" = 0));
            11, 12, 13, 14, 15, 16: // Purchase Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Purchase Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry.Sequence - 11));
            21: // Requisition Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Requisition Line") AND
                  (FilterReservEntry."Source Subtype" = 0));
            31, 32, 33, 34, 35, 36: // Sales Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Sales Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry.Sequence - 31));
            41, 42, 43, 44, 45: // Item Journal Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Item Journal Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry.Sequence - 41));
            51: // BOM Journal Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::Table89) AND
                  (FilterReservEntry."Source Subtype" = 0));
            101, 102: // Transfer Line
                EXIT((FilterReservEntry."Source Type" = DATABASE::"Transfer Line") AND
                  (FilterReservEntry."Source Subtype" = FromReservSummEntry.Sequence - 101));
        END;
    end;

    [Scope('Internal')]
    procedure UpdateReservFrom()
    var
        VehicleReservationEntry: Record "25006392";
    begin

        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.FIND;
                    SalesLine.CALCFIELDS(Reserved);
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.FIND;
                    ReqLine.CALCFIELDS(Reserved);
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchLine.FIND;
                    PurchLine.CALCFIELDS(Reserved);
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ItemJnlLine.FIND;
                    ItemJnlLine.CALCFIELDS(Reserved);
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    TransLine.FIND;
                    QtyToReserve := TransLine.Quantity;
                    QtyToReserveBase := TransLine."Quantity (Base)";
                    QtyReserved := TransLine.GetReservedQtyVeh(ReservEntry."Source Batch Name", TRUE, ReservEntry."Source Subtype", TRUE);
                    QtyReservedBase := QtyReserved;
                    QtyPerUOM := TransLine."Qty. per Unit of Measure";
                END;
        END;

        UpdateReservMgt;
        ReservMgt.UpdateStatistics(ReservSummEntry);
        //ReservMgt.UpdateStatistics(Rec);

        IF FormIsOpen THEN
            CurrPage.UPDATE;
    end;

    [Scope('Internal')]
    procedure UpdateReservFromOriginal()
    var
        EntrySummary: Record "338";
        QtyPerUOM: Decimal;
        QtyReservedIT: Decimal;
    begin
        /*
        IF NOT FormIsOpen THEN
          GetSerialLotNo(ItemTrackingQtyToReserve,ItemTrackingQtyToReserveBase);
        
        CASE ReservEntry."Source Type" OF
          DATABASE::"Sales Line":
            BEGIN
              SalesLine.FIND;
              SalesLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              IF SalesLine."Document Type" = SalesLine."Document Type"::"Return Order" THEN BEGIN
                SalesLine."Reserved Quantity" := -SalesLine."Reserved Quantity";
                SalesLine."Reserved Qty. (Base)" := -SalesLine."Reserved Qty. (Base)";
              END;
              QtyReserved := SalesLine."Reserved Quantity";
              QtyReservedBase := SalesLine."Reserved Qty. (Base)";
              QtyToReserve := SalesLine."Outstanding Quantity";
              QtyToReserveBase := SalesLine."Outstanding Qty. (Base)";
              QtyPerUOM := SalesLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Requisition Line":
            BEGIN
              ReqLine.FIND;
              ReqLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ReqLine."Reserved Quantity";
              QtyReservedBase := ReqLine."Reserved Qty. (Base)";
              QtyToReserve := ReqLine.Quantity;
              QtyToReserveBase := ReqLine."Quantity (Base)";
              QtyPerUOM := ReqLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Purchase Line":
            BEGIN
              PurchLine.FIND;
              PurchLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              IF PurchLine."Document Type" = PurchLine."Document Type"::"Return Order" THEN BEGIN
                PurchLine."Reserved Quantity" := -PurchLine."Reserved Quantity";
                PurchLine."Reserved Qty. (Base)" := -PurchLine."Reserved Qty. (Base)";
              END;
              QtyReserved := PurchLine."Reserved Quantity";
              QtyReservedBase := PurchLine."Reserved Qty. (Base)";
              QtyToReserve := PurchLine."Outstanding Quantity";
              QtyToReserveBase := PurchLine."Outstanding Qty. (Base)";
              QtyPerUOM := PurchLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Item Journal Line":
            BEGIN
              ItemJnlLine.FIND;
              ItemJnlLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ItemJnlLine."Reserved Quantity";
              QtyReservedBase := ItemJnlLine."Reserved Qty. (Base)";
              QtyToReserve := ItemJnlLine.Quantity;
              QtyToReserveBase := ItemJnlLine."Quantity (Base)";
              QtyPerUOM := ItemJnlLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Prod. Order Line":
            BEGIN
              ProdOrderLine.FIND;
              ProdOrderLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ProdOrderLine."Reserved Quantity";
              QtyReservedBase := ProdOrderLine."Reserved Qty. (Base)";
              QtyToReserve := ProdOrderLine."Remaining Quantity";
              QtyToReserveBase := ProdOrderLine."Remaining Qty. (Base)";
              QtyPerUOM := ProdOrderLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Prod. Order Component":
            BEGIN
              ProdOrderComp.FIND;
              ProdOrderComp.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ProdOrderComp."Reserved Quantity";
              QtyReservedBase := ProdOrderComp."Reserved Qty. (Base)";
              QtyToReserve := ProdOrderComp."Remaining Quantity";
              QtyToReserveBase := ProdOrderComp."Remaining Qty. (Base)";
              QtyPerUOM := ProdOrderComp."Qty. per Unit of Measure";
            END;
          DATABASE::"Assembly Header":
            BEGIN
              AssemblyHeader.FIND;
              AssemblyHeader.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := AssemblyHeader."Reserved Quantity";
              QtyReservedBase := AssemblyHeader."Reserved Qty. (Base)";
              QtyToReserve := AssemblyHeader."Remaining Quantity";
              QtyToReserveBase := AssemblyHeader."Remaining Quantity (Base)";
              QtyPerUOM := AssemblyHeader."Qty. per Unit of Measure";
            END;
          DATABASE::"Assembly Line":
            BEGIN
              AssemblyLine.FIND;
              AssemblyLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := AssemblyLine."Reserved Quantity";
              QtyReservedBase := AssemblyLine."Reserved Qty. (Base)";
              QtyToReserve := AssemblyLine."Remaining Quantity";
              QtyToReserveBase := AssemblyLine."Remaining Quantity (Base)";
              QtyPerUOM := AssemblyLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Planning Component":
            BEGIN
              PlanningComponent.FIND;
              PlanningComponent.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := PlanningComponent."Reserved Quantity";
              QtyReservedBase := PlanningComponent."Reserved Qty. (Base)";
              QtyToReserve := PlanningComponent.Quantity;
              QtyToReserveBase := PlanningComponent."Quantity (Base)";
              QtyPerUOM := PlanningComponent."Qty. per Unit of Measure";
            END;
          DATABASE::"Transfer Line":
            BEGIN
              TransLine.FIND;
              IF ReservEntry."Source Subtype" = 0 THEN BEGIN // Outbound
                TransLine.CALCFIELDS("Reserved Quantity Outbnd.","Reserved Qty. Outbnd. (Base)");
                QtyReserved := TransLine."Reserved Quantity Outbnd.";
                QtyReservedBase := TransLine."Reserved Qty. Outbnd. (Base)";
                QtyToReserve := TransLine."Outstanding Quantity";
                QtyToReserveBase := TransLine."Outstanding Qty. (Base)";
              END ELSE BEGIN // Inbound
                TransLine.CALCFIELDS("Reserved Quantity Inbnd.","Reserved Qty. Inbnd. (Base)");
                QtyReserved := TransLine."Reserved Quantity Inbnd.";
                QtyReservedBase := TransLine."Reserved Qty. Inbnd. (Base)";
                QtyToReserve := TransLine."Outstanding Quantity";
                QtyToReserveBase := TransLine."Outstanding Qty. (Base)";
              END;
              QtyPerUOM := TransLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Service Line":
            BEGIN
              ServiceLine.FIND;
              ServiceLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := ServiceLine."Reserved Quantity";
              QtyReservedBase := ServiceLine."Reserved Qty. (Base)";
              QtyToReserve := ServiceLine."Outstanding Quantity";
              QtyToReserveBase := ServiceLine."Outstanding Qty. (Base)";
              QtyPerUOM := ServiceLine."Qty. per Unit of Measure";
            END;
          DATABASE::"Job Planning Line":
            BEGIN
              JobPlanningLine.FIND;
              JobPlanningLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
              QtyReserved := JobPlanningLine."Reserved Quantity";
              QtyReservedBase := JobPlanningLine."Reserved Qty. (Base)";
              QtyToReserve := JobPlanningLine."Remaining Qty.";
              QtyToReserveBase := JobPlanningLine."Remaining Qty. (Base)";
              QtyPerUOM := JobPlanningLine."Qty. per Unit of Measure";
            END;
          //20.03.2013 EDMS >>
          DATABASE::"Service Line EDMS":
            BEGIN
              ServiceLineEDMS.FIND;
              ServiceLineEDMS.CALCFIELDS("Reserved Qty. (Base)");
              IF ServiceLineEDMS."Document Type" = ServiceLineEDMS."Document Type"::"Return Order" THEN
                ServiceLineEDMS."Reserved Qty. (Base)" := -ServiceLineEDMS."Reserved Qty. (Base)";
              QtyReserved := ServiceLineEDMS."Reserved Qty. (Base)";
              QtyToReserve := ServiceLineEDMS."Outstanding Qty. (Base)";
            END;
          //20.03.2013 EDMS <<
        END;
        
        UpdateReservMgt;
        ReservMgt.UpdateStatistics(
          Rec,ReservEntry."Shipment Date",HandleItemTracking);
        
        IF HandleItemTracking THEN BEGIN
          EntrySummary := Rec;
          QtyReservedBase := 0;
          IF FINDSET THEN
            REPEAT
              QtyReservedBase += ReservedThisLine(Rec);
            UNTIL NEXT = 0;
          QtyReservedIT := ROUND(QtyReservedBase / QtyPerUOM,0.00001);
          IF ABS(QtyReserved - QtyReservedIT) > 0.00001 THEN
            QtyReserved := QtyReservedIT;
          QtyToReserveBase := ItemTrackingQtyToReserveBase;
          IF ABS(ItemTrackingQtyToReserve - QtyToReserve) > 0.00001 THEN
            QtyToReserve := ItemTrackingQtyToReserve;
          Rec := EntrySummary;
        END;
        
        UpdateNonSpecific; // Late Binding
        
        IF FormIsOpen THEN
          CurrPage.UPDATE;
        */

    end;

    [Scope('Internal')]
    procedure UpdateReservMgt()
    begin
        CLEAR(ReservMgt);
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                ReservMgt.SetSalesLine(SalesLine);
            DATABASE::"Requisition Line":
                ReservMgt.SetReqLine(ReqLine);
            DATABASE::"Purchase Line":
                ReservMgt.SetPurchLine(PurchLine);
            DATABASE::"Item Journal Line":
                ReservMgt.SetItemJnlLine(ItemJnlLine);
            DATABASE::"Transfer Line":
                ReservMgt.SetTransferLine(TransLine, ReservEntry."Source Subtype");
        END;
    end;

    [Scope('Internal')]
    procedure ReservedThisLine(ReservSummEntry2: Record "25006393" temporary) ReservedQuantity: Decimal
    var
        ReservEntry3: Record "337";
    begin
        CLEAR(ReservEntry2);

        ReservEntry2.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name");
        ReservedQuantity := 0;

        FilterReservEntry(ReservEntry2, ReservSummEntry2);
        IF ReservEntry2.FINDSET THEN
            REPEAT
                ReservEntry3.GET(ReservEntry2."Entry No.", NOT ReservEntry2.Positive);
                IF (ReservEntry3."Source Type" = ReservEntry."Source Type") AND
                   (ReservEntry3."Source Subtype" = ReservEntry."Source Subtype") AND
                   (ReservEntry3."Source ID" = ReservEntry."Source ID") AND
                   (ReservEntry3."Source Batch Name" = ReservEntry."Source Batch Name") AND
                   (ReservEntry3."Source Ref. No." = ReservEntry."Source Ref. No.")
                THEN
                    ReservedQuantity += ReservEntry2.Quantity * CreateReservEntry.SignFactor(ReservEntry2);
            UNTIL ReservEntry2.NEXT = 0;

        EXIT(ReservedQuantity);
    end;

    [Scope('Internal')]
    procedure AutoReserve()
    begin
        IF ABS(QtyToReserveBase) - ABS(QtyReservedBase) = 0 THEN
            ERROR(Text000);

        ReservMgt.AutoReserve(
          FullAutoReservation, ReservEntry.Description,
          QtyToReserve - QtyReserved);
        IF NOT FullAutoReservation THEN
            MESSAGE(Text001);
        UpdateReservFrom;
    end;
}

