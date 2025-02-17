page 25006096 "Purch. Reservation FactBox"
{
    // 08.09.2014 Elva Baltic P8 #S0006 EDMS
    //   * Created as copy from P25006081

    Caption = 'Reservation Entry Details';
    PageType = CardPart;
    SourceTable = Table39;

    layout
    {
        area(content)
        {
            field("Reservation Entry No."; "Reservation Entry No.")
            {
                Caption = 'Entry No.';
            }
            field(ReservEngineMgt.CreateForText2(ReservationEntry);
                ReservEngineMgt.CreateForText2(ReservationEntry))
            {
                Caption = 'Reserved For';
                Editable = false;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    LookupReservedFor;
                end;
            }
            field(ReservationCustomerNo; GetReservForInfo(ReturnValue::CustomerNo))
            {
                Caption = 'Reservation Customer No.';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowCustomeCard;
                end;
            }
            field(ReservationCustomerName; GetReservForInfo(ReturnValue::CustomerName))
            {
                Caption = 'Reservation Customer Name';

                trigger OnDrillDown()
                begin
                    ShowCustomeCard;
                end;
            }
            field(ReservationVIN; GetReservForInfo(ReturnValue::VIN))
            {
                Caption = 'Reservation VIN';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowVINList;
                end;
            }
            field(ReservationDealType; GetReservForInfo(ReturnValue::DealType))
            {
                Caption = 'Reservation Deal Type Code';
                Editable = false;

                trigger OnDrillDown()
                begin
                    ShowDealTypes;
                end;
            }
            field(ReservationOrderingPriceType; GetReservForInfo(ReturnValue::OrderingPriceType))
            {
                Caption = 'Reservation Ordering Price Type Code';

                trigger OnDrillDown()
                begin
                    ShowOrderingPriceType;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CALCFIELDS("Reservation Entry No.");
        CLEAR(ReservationEntry);
        IF ReservationEntry.GET(ReservEngineMgt.GetReservForEntryNo("Document No.", "Line No.", DATABASE::"Purchase Line", "Document Type", 0, ''), FALSE) THEN;
    end;

    var
        ReservationEntry: Record "337";
        ReservEngineMgt: Codeunit "99000831";
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;
        Customer: Record "18";
        Vehicle: Record "25006005";
        DealType: Record "25006068";
        OrderingPriceType: Record "25006763";

    [Scope('Internal')]
    procedure LookupReservedFor()
    var
        ReservEntry: Record "337";
    begin
        ReservEntry.GET(ReservationEntry."Entry No.", FALSE);
        LookupReserved(ReservEntry);
    end;

    [Scope('Internal')]
    procedure LookupReservedFrom()
    var
        ReservEntry: Record "337";
    begin
        ReservEntry.GET(ReservationEntry."Entry No.", TRUE);
        LookupReserved(ReservEntry);
    end;

    [Scope('Internal')]
    procedure LookupReserved(ReservEntry: Record "337")
    var
        SalesLine: Record "37";
        ReqLine: Record "246";
        PurchLine: Record "39";
        ItemJnlLine: Record "83";
        ItemLedgEntry: Record "32";
        ProdOrderLine: Record "5406";
        ProdOrderComp: Record "5407";
        PlanningComponent: Record "99000829";
        ServLine: Record "5902";
        JobPlanningLine: Record "1003";
        TransLine: Record "5741";
        AssemblyHeader: Record "900";
        AssemblyLine: Record "901";
        ServiceLineEDMS: Record "25006146";
    begin
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SalesLine.RESET;
                    SalesLine.SETRANGE("Document Type", ReservEntry."Source Subtype");
                    SalesLine.SETRANGE("Document No.", ReservEntry."Source ID");
                    SalesLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(PAGE::"Sales Lines", SalesLine);
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    ReqLine.RESET;
                    ReqLine.SETRANGE("Worksheet Template Name", ReservEntry."Source ID");
                    ReqLine.SETRANGE("Journal Batch Name", ReservEntry."Source Batch Name");
                    ReqLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(PAGE::"Requisition Lines", ReqLine);
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type", ReservEntry."Source Subtype");
                    PurchLine.SETRANGE("Document No.", ReservEntry."Source ID");
                    PurchLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    ItemJnlLine.RESET;
                    ItemJnlLine.SETRANGE("Journal Template Name", ReservEntry."Source ID");
                    ItemJnlLine.SETRANGE("Journal Batch Name", ReservEntry."Source Batch Name");
                    ItemJnlLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    ItemJnlLine.SETRANGE("Entry Type", ReservEntry."Source Subtype");
                    PAGE.RUNMODAL(PAGE::"Item Journal Lines", ItemJnlLine);
                END;
            DATABASE::"Item Ledger Entry":
                BEGIN
                    ItemLedgEntry.RESET;
                    ItemLedgEntry.SETRANGE("Entry No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, ItemLedgEntry);
                END;
            DATABASE::"Prod. Order Line":
                BEGIN
                    ProdOrderLine.RESET;
                    ProdOrderLine.SETRANGE(Status, ReservEntry."Source Subtype");
                    ProdOrderLine.SETRANGE("Prod. Order No.", ReservEntry."Source ID");
                    ProdOrderLine.SETRANGE("Line No.", ReservEntry."Source Prod. Order Line");
                    PAGE.RUNMODAL(0, ProdOrderLine);
                END;
            DATABASE::"Prod. Order Component":
                BEGIN
                    ProdOrderComp.RESET;
                    ProdOrderComp.SETRANGE(Status, ReservEntry."Source Subtype");
                    ProdOrderComp.SETRANGE("Prod. Order No.", ReservEntry."Source ID");
                    ProdOrderComp.SETRANGE("Prod. Order Line No.", ReservEntry."Source Prod. Order Line");
                    ProdOrderComp.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, ProdOrderComp);
                END;
            DATABASE::"Planning Component":
                BEGIN
                    PlanningComponent.RESET;
                    PlanningComponent.SETRANGE("Worksheet Template Name", ReservEntry."Source ID");
                    PlanningComponent.SETRANGE("Worksheet Batch Name", ReservEntry."Source Batch Name");
                    PlanningComponent.SETRANGE("Worksheet Line No.", ReservEntry."Source Prod. Order Line");
                    PlanningComponent.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, PlanningComponent);
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    TransLine.RESET;
                    TransLine.SETRANGE("Document No.", ReservEntry."Source ID");
                    TransLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    TransLine.SETRANGE("Derived From Line No.", ReservEntry."Source Prod. Order Line");
                    PAGE.RUNMODAL(0, TransLine);
                END;
            DATABASE::"Service Line":
                BEGIN
                    ServLine.SETRANGE("Document Type", ReservEntry."Source Subtype");
                    ServLine.SETRANGE("Document No.", ReservEntry."Source ID");
                    ServLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, ServLine);
                END;
            DATABASE::"Job Planning Line":
                BEGIN
                    JobPlanningLine.SETRANGE(Status, ReservEntry."Source Subtype");
                    JobPlanningLine.SETRANGE("Job No.", ReservEntry."Source ID");
                    JobPlanningLine.SETRANGE("Job Contract Entry No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, JobPlanningLine);
                END;
            DATABASE::"Assembly Header":
                BEGIN
                    AssemblyHeader.SETRANGE("Document Type", ReservEntry."Source Subtype");
                    AssemblyHeader.SETRANGE("No.", ReservEntry."Source ID");
                    PAGE.RUNMODAL(0, AssemblyHeader);
                END;
            DATABASE::"Assembly Line":
                BEGIN
                    AssemblyLine.SETRANGE("Document Type", ReservEntry."Source Subtype");
                    AssemblyLine.SETRANGE("Document No.", ReservEntry."Source ID");
                    AssemblyLine.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, AssemblyLine);
                END;
            // 31.03.2014 Elva Baltic P21 #F182 MMG7.00 >>
            DATABASE::"Service Line EDMS":
                BEGIN
                    ServiceLineEDMS.SETRANGE("Document Type", ReservEntry."Source Subtype");
                    ServiceLineEDMS.SETRANGE("Document No.", ReservEntry."Source ID");
                    ServiceLineEDMS.SETRANGE("Line No.", ReservEntry."Source Ref. No.");
                    PAGE.RUNMODAL(0, ServiceLineEDMS);
                END;
        // 31.03.2014 Elva Baltic P21 #F182 MMG7.00 <<
        END;
    end;

    [Scope('Internal')]
    procedure ShowCustomeCard()
    begin
        IF Customer.GET(GetReservForInfo(ReturnValue::CustomerNo)) THEN
            PAGE.RUN(PAGE::"Customer Card", Customer);
    end;

    [Scope('Internal')]
    procedure ShowVINList()
    begin
        Vehicle.RESET;
        Vehicle.SETCURRENTKEY(VIN);
        Vehicle.SETRANGE(VIN, GetReservForInfo(ReturnValue::VIN));
        PAGE.RUN(PAGE::"Vehicle List", Vehicle);
    end;

    [Scope('Internal')]
    procedure ShowDealTypes()
    begin
        IF DealType.GET(GetReservForInfo(ReturnValue::DealType)) THEN
            PAGE.RUN(PAGE::"Deal Types", DealType);
    end;

    [Scope('Internal')]
    procedure ShowOrderingPriceType()
    begin
        IF OrderingPriceType.GET(GetReservForInfo(ReturnValue::OrderingPriceType)) THEN
            PAGE.RUN(PAGE::"Ordering Price Types", OrderingPriceType);
    end;
}

