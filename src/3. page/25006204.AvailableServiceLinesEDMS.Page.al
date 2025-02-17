page 25006204 "Available - Service Lines EDMS"
{
    // 02.06.2014 EDMS P8
    //   * merge stuff

    Caption = 'Available - Service Lines';
    DataCaptionExpression = CaptionText;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    Permissions = TableData 5902 = rm;
    SourceTable = Table25006146;
    SourceTableView = SORTING(Type, No., Variant Code, Location Code, Document Type, Shortcut Dimension 1 Code, Shortcut Dimension 2 Code);

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Outstanding Qty. (Base)"; "Outstanding Qty. (Base)")
                {
                }
                field("Reserved Qty. (Base)"; "Reserved Qty. (Base)")
                {
                    Editable = false;
                }
                field(QtyToReserveBase; QtyToReserveBase)
                {
                    Caption = 'Available Quantity';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
                field(ReservedThisLine; ReservedThisLine)
                {
                    Caption = 'Current Reserved Quantity';
                    DecimalPlaces = 0 : 5;

                    trigger OnDrillDown()
                    begin
                        ReservEntry2.RESET;
                        ReserveServLine.FilterReservFor(ReservEntry2, Rec);
                        ReservEntry2.SETRANGE("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
                        ReservMgt.MarkReservConnection(ReservEntry2, ReservEntry);
                        PAGE.RUNMODAL(PAGE::"Reservation Entries", ReservEntry2);
                        UpdateReservFrom;
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
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
                action("&Reserve")
                {
                    Caption = '&Reserve';
                    Image = Reserve;

                    trigger OnAction()
                    begin
                        ReservEntry.LOCKTABLE;
                        UpdateReservMgt;
                        ReservMgt.ServiceLineEDMSUpdateValues(Rec, QtyToReserve, QtyReservedThisLine);
                        ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine, NewQtyReservedThisLineBase);
                        ReservMgt.CopySign(NewQtyReservedThisLine, QtyToReserve);
                        IF NewQtyReservedThisLine <> 0 THEN
                            IF ABS(NewQtyReservedThisLine) > ABS(QtyToReserve) THEN
                                CreateReservation(QtyToReserve, QtyToReserveBase)
                            ELSE
                                CreateReservation(NewQtyReservedThisLine, NewQtyReservedThisLineBase)
                        ELSE
                            ERROR(Text000);
                    end;
                }
                action("&Cancel Reservation")
                {
                    Caption = '&Cancel Reservation';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM(Text001, FALSE) THEN
                            EXIT;

                        ReservEntry2.COPY(ReservEntry);
                        ReserveServLine.FilterReservFor(ReservEntry2, Rec);

                        IF ReservEntry2.FIND('-') THEN BEGIN
                            UpdateReservMgt;
                            REPEAT
                                ReservEngineMgt.CloseReservEntry(ReservEntry2, TRUE, FALSE);  //02.06.2014 EDMS P8
                            UNTIL ReservEntry2.NEXT = 0;

                            UpdateReservFrom;
                        END;
                    end;
                }
                action("&Show Document")
                {
                    Caption = '&Show Document';
                    Image = View;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        ServHeader.GET("Document Type", "Document No.");
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                PAGE.RUN(PAGE::"Service Quote EDMS", ServHeader);
                            "Document Type"::Order:
                                PAGE.RUN(PAGE::"Service Order EDMS", ServHeader);
                            "Document Type"::"Return Order":
                                PAGE.RUN(PAGE::"Service Return Order EDMS", ServHeader);
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ReservMgt.ServiceLineEDMSUpdateValues(Rec, QtyToReserve, QtyReservedThisLine);
    end;

    trigger OnOpenPage()
    begin
        ReservEntry.TESTFIELD("Source Type");

        SETRANGE("Document Type", CurrentSubType);
        SETRANGE(Type, Type::Item);
        SETRANGE("No.", ReservEntry."Item No.");
        SETRANGE("Variant Code", ReservEntry."Variant Code");
        SETRANGE("Job No.", '');
        SETRANGE("Drop Shipment", FALSE);
        SETRANGE("Location Code", ReservEntry."Location Code");

        SETFILTER("Planned Service Date", ReservMgt.GetAvailabilityFilter(ReservEntry."Shipment Date"));

        CASE CurrentSubType OF
            1:
                IF ReservMgt.IsPositive() THEN
                    SETFILTER("Quantity (Base)", '<0')
                ELSE
                    SETFILTER("Quantity (Base)", '>0');
            2:
                IF NOT ReservMgt.IsPositive() THEN
                    SETFILTER("Quantity (Base)", '<0')
                ELSE
                    SETFILTER("Quantity (Base)", '>0');
        END;

        IF ServSpecEDMS THEN BEGIN
            SETRANGE("Document Type", ServSpecDocType);
            SETRANGE("Document No.", ServSpecDocNo);
        END;
    end;

    var
        Text000: Label 'Fully reserved.';
        Text001: Label 'Do you want to cancel the reservation?';
        Text002: Label 'The available quantity is %1.';
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
        ServHeader: Record "25006145";
        SalesLine: Record "37";
        PurchLine: Record "39";
        ItemJnlLine: Record "83";
        ReqLine: Record "246";
        ProdOrderLine: Record "5406";
        ProdOrderComp: Record "5407";
        PlanningComponent: Record "99000829";
        TransLine: Record "5741";
        ServiceLine: Record "25006146";
        JobPlanningLine: Record "1003";
        AssemblyLine: Record "901";
        AssemblyHeader: Record "900";
        AssemblyLineReserve: Codeunit "926";
        AssemblyHeaderReserve: Codeunit "925";
        ReservMgt: Codeunit "99000845";
        ReservEngineMgt: Codeunit "99000831";
        ReserveSalesLine: Codeunit "99000832";
        ReserveReqLine: Codeunit "99000833";
        ReservePurchLine: Codeunit "99000834";
        ReserveItemJnlLine: Codeunit "99000835";
        ReserveProdOrderLine: Codeunit "99000837";
        ReserveProdOrderComp: Codeunit "99000838";
        ReservePlanningComponent: Codeunit "99000840";
        ReserveTransLine: Codeunit "99000836";
        ReserveServLine: Codeunit "25006121";
        JobPlanningLineReserve: Codeunit "1032";
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        QtyReservedThisLine: Decimal;
        QtyReservedThisLineBase: Decimal;
        NewQtyReservedThisLine: Decimal;
        NewQtyReservedThisLineBase: Decimal;
        CaptionText: Text[80];
        CurrentSubType: Option;
        ServSpecEDMS: Boolean;
        ServSpecDocType: Integer;
        ServSpecDocNo: Code[20];
        ReserveServiceLineEDMS: Codeunit "25006121";

    [Scope('Internal')]
    procedure SetSalesLine(var CurrentSalesLine: Record "37"; CurrentReservEntry: Record "337")
    begin
        CurrentSalesLine.TESTFIELD(Type, CurrentSalesLine.Type::Item);
        SalesLine := CurrentSalesLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetSalesLine(SalesLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveSalesLine.FilterReservFor(ReservEntry, SalesLine);
        CaptionText := ReserveSalesLine.Caption(SalesLine);
    end;

    [Scope('Internal')]
    procedure SetReqLine(var CurrentReqLine: Record "246"; CurrentReservEntry: Record "337")
    begin
        ReqLine := CurrentReqLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetReqLine(ReqLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveReqLine.FilterReservFor(ReservEntry, ReqLine);
        CaptionText := ReserveReqLine.Caption(ReqLine);
    end;

    [Scope('Internal')]
    procedure SetPurchLine(var CurrentPurchLine: Record "39"; CurrentReservEntry: Record "337")
    begin
        CurrentPurchLine.TESTFIELD(Type, CurrentPurchLine.Type::Item);
        PurchLine := CurrentPurchLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetPurchLine(PurchLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReservePurchLine.FilterReservFor(ReservEntry, PurchLine);
        CaptionText := ReservePurchLine.Caption(PurchLine);
    end;

    [Scope('Internal')]
    procedure SetItemJnlLine(var CurrentItemJnlLine: Record "83"; CurrentReservEntry: Record "337")
    begin
        ItemJnlLine := CurrentItemJnlLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetItemJnlLine(ItemJnlLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveItemJnlLine.FilterReservFor(ReservEntry, ItemJnlLine);
        CaptionText := ReserveItemJnlLine.Caption(ItemJnlLine);
    end;

    [Scope('Internal')]
    procedure SetProdOrderLine(var CurrentProdOrderLine: Record "5406"; CurrentReservEntry: Record "337")
    begin
        ProdOrderLine := CurrentProdOrderLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetProdOrderLine(ProdOrderLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveProdOrderLine.FilterReservFor(ReservEntry, ProdOrderLine);
        CaptionText := ReserveProdOrderLine.Caption(ProdOrderLine);
    end;

    [Scope('Internal')]
    procedure SetProdOrderComponent(var CurrentProdOrderComp: Record "5407"; CurrentReservEntry: Record "337")
    begin
        ProdOrderComp := CurrentProdOrderComp;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetProdOrderComponent(ProdOrderComp);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveProdOrderComp.FilterReservFor(ReservEntry, ProdOrderComp);
        CaptionText := ReserveProdOrderComp.Caption(ProdOrderComp);
    end;

    [Scope('Internal')]
    procedure SetPlanningComponent(var CurrentPlanningComponent: Record "99000829"; CurrentReservEntry: Record "337")
    begin
        PlanningComponent := CurrentPlanningComponent;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetPlanningComponent(PlanningComponent);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReservePlanningComponent.FilterReservFor(ReservEntry, PlanningComponent);
        CaptionText := ReservePlanningComponent.Caption(PlanningComponent);
    end;

    [Scope('Internal')]
    procedure SetTransferLine(var CurrentTransLine: Record "5741"; CurrentReservEntry: Record "337"; Direction: Option Outbound,Inbound)
    begin
        TransLine := CurrentTransLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetTransferLine(TransLine, Direction);
        ReservMgt.GetServiceReserv(ServSpecEDMS, ServSpecDocType, ServSpecDocNo);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveTransLine.FilterReservFor(ReservEntry, TransLine, Direction);
        CaptionText := ReserveTransLine.Caption(TransLine);
    end;

    [Scope('Internal')]
    procedure SetJobPlanningLine(var CurrentJobPlanningLine: Record "1003"; CurrentReservEntry: Record "337")
    begin
        CurrentJobPlanningLine.TESTFIELD(Type, CurrentJobPlanningLine.Type::Item);
        JobPlanningLine := CurrentJobPlanningLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetJobPlanningLine(JobPlanningLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        JobPlanningLineReserve.FilterReservFor(ReservEntry, JobPlanningLine);
        CaptionText := JobPlanningLineReserve.Caption(JobPlanningLine);
    end;

    [Scope('Internal')]
    procedure CreateReservation(ReserveQuantity: Decimal; ReserveQuantityBase: Decimal)
    var
        TrackingSpecification: Record "336";
    begin
        IF ABS("Outstanding Qty. (Base)") + "Reserved Qty. (Base)" < ReserveQuantityBase THEN
            ERROR(Text002, ABS("Outstanding Qty. (Base)") + "Reserved Qty. (Base)");

        TESTFIELD(Type, Type::Item);
        TESTFIELD("No.", ReservEntry."Item No.");
        TESTFIELD("Variant Code", ReservEntry."Variant Code");
        TESTFIELD("Location Code", ReservEntry."Location Code");

        TrackingSpecification.INIT;
        TrackingSpecification."Source Type" := DATABASE::"Service Line EDMS";
        TrackingSpecification."Source Subtype" := "Document Type";
        TrackingSpecification."Source ID" := "Document No.";
        TrackingSpecification."Source Batch Name" := '';
        TrackingSpecification."Source Prod. Order Line" := 0;
        TrackingSpecification."Source Ref. No." := "Line No.";
        TrackingSpecification."Variant Code" := "Variant Code";
        TrackingSpecification."Location Code" := "Location Code";
        TrackingSpecification."Serial No." := '';
        TrackingSpecification."Lot No." := '';
        TrackingSpecification."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        ReservMgt.CreateReservation(
          ReservEntry.Description,
          "Posting Date",
          ReserveQuantity,
          ReserveQuantityBase,
          TrackingSpecification);

        UpdateReservFrom;
        /*
        IF ABS("Outstanding Qty. (Base)") + "Reserved Qty. (Base)" < ReserveQuantity THEN
          ERROR(Text002,ABS("Outstanding Qty. (Base)") + "Reserved Qty. (Base)");
        
        TESTFIELD("Job No.",'');
        TESTFIELD("Drop Shipment",FALSE);
        TESTFIELD("No.",ReservEntry."Item No.");
        TESTFIELD("Variant Code",ReservEntry."Variant Code");
        TESTFIELD("Location Code",ReservEntry."Location Code");
        
        ReservMgt.CreateReservation(
          ReservEntry.Description,
          "Planned Service Date",
          ReserveQuantity,
          DATABASE::"Service Line EDMS",
          "Document Type",
          "Document No.",
          '',
          0,
          "Line No.",
          "Variant Code",
          "Location Code",
          '',
          '',
          "Qty. per Unit of Measure");
        
        UpdateReservFrom;
        */

    end;

    [Scope('Internal')]
    procedure UpdateReservFrom()
    begin
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.FIND;
                    SetSalesLine(SalesLine, ReservEntry);
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.FIND;
                    SetReqLine(ReqLine, ReservEntry);
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchLine.FIND;
                    SetPurchLine(PurchLine, ReservEntry);
                END;
            DATABASE::"Prod. Order Line":
                BEGIN
                    ProdOrderLine.FIND;
                    SetProdOrderLine(ProdOrderLine, ReservEntry);
                END;
            DATABASE::"Prod. Order Component":
                BEGIN
                    ProdOrderComp.FIND;
                    SetProdOrderComponent(ProdOrderComp, ReservEntry);
                END;
            DATABASE::"Planning Component":
                BEGIN
                    PlanningComponent.FIND;
                    SetPlanningComponent(PlanningComponent, ReservEntry);
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    TransLine.FIND;
                    SetTransferLine(TransLine, ReservEntry, ReservEntry."Source Subtype");
                END;
            DATABASE::"Job Planning Line":
                BEGIN
                    JobPlanningLine.FIND;
                    SetJobPlanningLine(JobPlanningLine, ReservEntry);
                END;
        END;
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
            DATABASE::"Prod. Order Line":
                ReservMgt.SetProdOrderLine(ProdOrderLine);
            DATABASE::"Prod. Order Component":
                ReservMgt.SetProdOrderComponent(ProdOrderComp);
            DATABASE::"Planning Component":
                ReservMgt.SetPlanningComponent(PlanningComponent);
            DATABASE::"Transfer Line":
                ReservMgt.SetTransferLine(TransLine, ReservEntry."Source Subtype");
        END;
    end;

    [Scope('Internal')]
    procedure ReservedThisLine(): Decimal
    begin
        ReservEntry2.RESET;
        ReserveServLine.FilterReservFor(ReservEntry2, Rec);
        ReservEntry2.SETRANGE("Reservation Status", ReservEntry2."Reservation Status"::Reservation);
        EXIT(ReservMgt.MarkReservConnection(ReservEntry2, ReservEntry));
    end;

    [Scope('Internal')]
    procedure SetCurrentSubType(SubType: Option)
    begin
        CurrentSubType := SubType;
    end;

    [Scope('Internal')]
    procedure SetAssemblyLine(var CurrentAsmLine: Record "901"; CurrentReservEntry: Record "337")
    begin
        CurrentAsmLine.TESTFIELD(Type, CurrentAsmLine.Type::Item);
        AssemblyLine := CurrentAsmLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetAssemblyLine(AssemblyLine);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        AssemblyLineReserve.FilterReservFor(ReservEntry, AssemblyLine);
        CaptionText := AssemblyLineReserve.Caption(AssemblyLine);
    end;

    [Scope('Internal')]
    procedure SetAssemblyHeader(var CurrentAsmHeader: Record "900"; CurrentReservEntry: Record "337")
    begin
        AssemblyHeader := CurrentAsmHeader;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetAssemblyHeader(AssemblyHeader);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        AssemblyHeaderReserve.FilterReservFor(ReservEntry, AssemblyHeader);
        CaptionText := AssemblyHeaderReserve.Caption(AssemblyHeader);
    end;

    [Scope('Internal')]
    procedure SetServiceLineEDMS(var CurrentServiceLine: Record "25006146"; CurrentReservEntry: Record "337")
    begin
        CurrentServiceLine.TESTFIELD(Type, CurrentServiceLine.Type::Item);
        ServiceLine := CurrentServiceLine;
        ReservEntry := CurrentReservEntry;

        CLEAR(ReservMgt);
        ReservMgt.SetServLineEDMS(ServiceLine);
        //ReservMgt.GetServiceReserv(ServSpecEDMS,ServSpecDocType,ServSpecDocNo);
        ReservEngineMgt.InitFilterAndSortingFor(ReservEntry, TRUE);
        ReserveServiceLineEDMS.FilterReservFor(ReservEntry, ServiceLine);
        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLine);
        //wwww
        //CurrentSalesLine.TESTFIELD(Type,CurrentSalesLine.Type::Item);
        //SalesLine := CurrentSalesLine;
        //ReservEntry := CurrentReservEntry;

        //CLEAR(ReservMgt);
        //ReservMgt.SetSalesLine(SalesLine);
        //ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
        //ReserveSalesLine.FilterReservFor(ReservEntry,SalesLine);
        //CaptionText := ReserveSalesLine.Caption(SalesLine);
    end;
}

