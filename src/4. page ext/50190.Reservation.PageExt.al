pageextension 50190 pageextension50190 extends Reservation
{
    // 17.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Modified UpdateReservFrom function
    // 
    // 18.01.2013 EDMS P8
    //   * Added use of new fields: Service Order *

    var
        ServiceLineEDMS: Record "25006146";

    var
        ReserveServiceLineEDMS: Codeunit "25006121";

    var
        AvailableServiceLinesEDMS: Page "25006204";


    //Unsupported feature: Code Modification on "SetReqLine(PROCEDURE 2)".

    //procedure SetReqLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CurrentReqLine.TESTFIELD("Sales Order No.",'');
    CurrentReqLine.TESTFIELD("Sales Order Line No.",0);
    CurrentReqLine.TESTFIELD("Sell-to Customer No.",'');
    CurrentReqLine.TESTFIELD(Type,CurrentReqLine.Type::Item);
    CurrentReqLine.TESTFIELD("Due Date");
    #6..17

    CaptionText := ReserveReqLine.Caption(ReqLine);
    UpdateReservFrom;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //18.01.2013 EDMS P8 >>
    IF (CurrentReqLine."Sales Order No." = '') AND (CurrentReqLine."Service Order No." = '') THEN BEGIN
      CurrentReqLine.TESTFIELD("Sales Order No.",'');
    END ELSE
      IF (CurrentReqLine."Sales Order No." <> '') THEN BEGIN
        CurrentReqLine.TESTFIELD("Sales Order No.",'');
        CurrentReqLine.TESTFIELD("Sales Order Line No.",0);
      END ELSE BEGIN
        CurrentReqLine.TESTFIELD("Service Order No.",'');
        CurrentReqLine.TESTFIELD("Service Order Line No.",0);
      END;
    //18.01.2013 EDMS P8 <<
    #3..20
    */
    //end;


    //Unsupported feature: Code Modification on "FilterReservEntry(PROCEDURE 11)".

    //procedure FilterReservEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    FilterReservEntry.SETRANGE("Item No.",ReservEntry."Item No.");

    CASE FromReservSummEntry."Entry No." OF
    #4..66
          FilterReservEntry.SETRANGE("Source Type",DATABASE::"Assembly Line");
          FilterReservEntry.SETRANGE("Source Subtype",FromReservSummEntry."Entry No." - 151);
        END;
    END;

    FilterReservEntry.SETRANGE(
    #73..77
      FilterReservEntry.SETRANGE("Lot No.",ReservEntry."Lot No.");
    END;
    FilterReservEntry.SETRANGE(Positive,ReservMgt.IsPositive);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..69
      220,230:
        BEGIN // Service Line EDMS
          FilterReservEntry.SETRANGE("Source Type",DATABASE::"Service Line EDMS");
        END;

    #70..80
    */
    //end;


    //Unsupported feature: Code Modification on "RelatesToSummEntry(PROCEDURE 5)".

    //procedure RelatesToSummEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE FromReservSummEntry."Entry No." OF
      1: // Item Ledger Entry
        EXIT((FilterReservEntry."Source Type" = DATABASE::"Item Ledger Entry") AND
    #4..37
      151,152,153,154,155: // Assembly Line
        EXIT((FilterReservEntry."Source Type" = DATABASE::"Assembly Line") AND
          (FilterReservEntry."Source Subtype" = FromReservSummEntry."Entry No." - 151));
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..40
      220,230: // Service Line EDMS - 08.07.08 EDMS P1
          EXIT(FilterReservEntry."Source Type" = DATABASE::"Service Line EDMS");

    END;
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateReservMgt(PROCEDURE 7)".

    //procedure UpdateReservMgt();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(ReservMgt);
    CASE ReservEntry."Source Type" OF
      DATABASE::"Sales Line":
    #4..23
        ReservMgt.SetServLine(ServiceLine);
      DATABASE::"Job Planning Line":
        ReservMgt.SetJobPlanningLine(JobPlanningLine);
    END;
    ReservMgt.SetSerialLotNo(ReservEntry."Serial No.",ReservEntry."Lot No.");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..26
      DATABASE::"Service Line EDMS": //EDMS
        ReservMgt.SetServLineEDMS(ServiceLineEDMS);
    END;
    ReservMgt.SetSerialLotNo(ReservEntry."Serial No.",ReservEntry."Lot No.");
    */
    //end;


    //Unsupported feature: Code Modification on "DrillDownTotalQuantity(PROCEDURE 6)".

    //procedure DrillDownTotalQuantity();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF HandleItemTracking AND ("Entry No." <> 1) THEN BEGIN
      CLEAR(AvailableItemTrackingLines);
      AvailableItemTrackingLines.SetItemTrackingLine("Table ID","Source Subtype",ReservEntry,
        ReservMgt.IsPositive,ReservEntry."Shipment Date");
      AvailableItemTrackingLines.RUNMODAL;
      EXIT;
    END;

    ReservEntry2 := ReservEntry;
    IF NOT Location.GET(ReservEntry2."Location Code") THEN
      CLEAR(Location);
    CASE "Entry No." OF
      1:
        BEGIN // Item Ledger Entry
          CLEAR(AvailableItemLedgEntries);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableItemLedgEntries.SetSalesLine(SalesLine,ReservEntry2);
                IF Location."Bin Mandatory" OR Location."Require Pick" THEN
                  AvailableItemLedgEntries.SetTotalAvailQty(
                    "Total Available Quantity" +
                    CreatePick.CheckOutBound(
                      ReservEntry2."Source Type",ReservEntry2."Source Subtype",
                      ReservEntry2."Source ID",ReservEntry2."Source Ref. No.",
                      ReservEntry2."Source Prod. Order Line"))
                ELSE
                  AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableItemLedgEntries.SetReqLine(ReqLine,ReservEntry2);
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableItemLedgEntries.SetPurchLine(PurchLine,ReservEntry2);
                IF Location."Bin Mandatory" OR Location."Require Pick" AND
                   (PurchLine."Document Type" = PurchLine."Document Type"::"Return Order")
                THEN
                  AvailableItemLedgEntries.SetTotalAvailQty(
                    "Total Available Quantity" +
                    CreatePick.CheckOutBound(
                      ReservEntry2."Source Type",ReservEntry2."Source Subtype",
                      ReservEntry2."Source ID",ReservEntry2."Source Ref. No.",
                      ReservEntry2."Source Prod. Order Line"))
                ELSE
                  AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableItemLedgEntries.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableItemLedgEntries.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                IF Location."Bin Mandatory" OR Location."Require Pick" THEN
                  AvailableItemLedgEntries.SetTotalAvailQty(
                    "Total Available Quantity" +
                    CreatePick.CheckOutBound(
                      ReservEntry2."Source Type",ReservEntry2."Source Subtype",
                      ReservEntry2."Source ID",ReservEntry2."Source Ref. No.",
                      ReservEntry2."Source Prod. Order Line"))
                ELSE
                  AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableItemLedgEntries.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableItemLedgEntries.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                IF Location."Bin Mandatory" OR Location."Require Pick" THEN
                  AvailableItemLedgEntries.SetTotalAvailQty(
                    "Total Available Quantity" +
                    CreatePick.CheckOutBound(
                      ReservEntry2."Source Type",ReservEntry2."Source Subtype",
                      ReservEntry2."Source ID",ReservEntry2."Source Ref. No.",
                      ReservEntry2."Source Prod. Order Line"))
                ELSE
                  AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableItemLedgEntries.SetServiceLine(ServiceLine,ReservEntry2);
                AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableItemLedgEntries.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                AvailableItemLedgEntries.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableItemLedgEntries.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                AvailableItemLedgEntries.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableItemLedgEntries.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserveBase - QtyReservedBase);
                AvailableItemLedgEntries.RUNMODAL;
              END ;
          END;
        END;
      11,12,13,14,15,16:
        BEGIN // Purchase Line
          CLEAR(AvailablePurchLines);
          AvailablePurchLines.SetCurrentSubType("Entry No." - 11);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailablePurchLines.SetSalesLine(SalesLine,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailablePurchLines.SetReqLine(ReqLine,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailablePurchLines.SetPurchLine(PurchLine,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailablePurchLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailablePurchLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailablePurchLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailablePurchLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailablePurchLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailablePurchLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailablePurchLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailablePurchLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
              END ;
          END;
        END;
      21:
        BEGIN // Requisition Line
          CLEAR(AvailableReqLines);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableReqLines.SetSalesLine(SalesLine,ReservEntry2);
                AvailableReqLines.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableReqLines.SetReqLine(ReqLine,ReservEntry2);
                AvailableReqLines.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableReqLines.SetPurchLine(PurchLine,ReservEntry2);
                AvailableReqLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableReqLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableReqLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableReqLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableReqLines.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableReqLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableReqLines.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableReqLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableReqLines.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableReqLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailableReqLines.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableJobPlanningLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableJobPlanningLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableJobPlanningLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END ;
          END;
        END;
      31,32,33,34,35,36:
        BEGIN // Sales Line
          CLEAR(AvailableSalesLines);
          AvailableSalesLines.SetCurrentSubType("Entry No." - 31);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableSalesLines.SetSalesLine(SalesLine,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableSalesLines.SetReqLine(ReqLine,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableSalesLines.SetPurchLine(PurchLine,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableSalesLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableSalesLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableSalesLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableSalesLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableSalesLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableSalesLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableSalesLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableSalesLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
              END ;
          END;
        END;
      61,62,63,64:
        BEGIN
          CLEAR(AvailableProdOrderLines);
          AvailableProdOrderLines.SetCurrentSubType("Entry No." - 61);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableProdOrderLines.SetSalesLine(SalesLine,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableProdOrderLines.SetReqLine(ReqLine,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableProdOrderLines.SetPurchLine(PurchLine,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableProdOrderLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableProdOrderLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableProdOrderLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableProdOrderLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableProdOrderLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableProdOrderLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableProdOrderLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableProdOrderLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableProdOrderLines.RUNMODAL;
              END ;
          END;
        END;
      71,72,73,74:
        BEGIN
          CLEAR(AvailableProdOrderComps);
          AvailableProdOrderComps.SetCurrentSubType("Entry No." - 71);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableProdOrderComps.SetSalesLine(SalesLine,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableProdOrderComps.SetReqLine(ReqLine,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableProdOrderComps.SetPurchLine(PurchLine,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableProdOrderComps.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableProdOrderComps.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableProdOrderComps.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableProdOrderComps.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableProdOrderComps.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableProdOrderComps.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableProdOrderComps.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableProdOrderComps.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableProdOrderComps.RUNMODAL;
              END ;
          END;
        END;
      91:
        BEGIN
          CLEAR(AvailablePlanningComponents);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailablePlanningComponents.SetSalesLine(SalesLine,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailablePlanningComponents.SetReqLine(ReqLine,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailablePlanningComponents.SetPurchLine(PurchLine,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailablePlanningComponents.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailablePlanningComponents.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailablePlanningComponents.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailablePlanningComponents.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailablePlanningComponents.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailablePlanningComponents.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailablePlanningComponents.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailablePlanningComponents.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailablePlanningComponents.RUNMODAL;
              END ;
          END;
        END;
      101,102:
        BEGIN
          CLEAR(AvailableTransLines);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableTransLines.SetSalesLine(SalesLine,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableTransLines.SetReqLine(ReqLine,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableTransLines.SetPurchLine(PurchLine,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableTransLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableTransLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableTransLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableTransLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableTransLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableTransLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableTransLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableTransLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableTransLines.RUNMODAL;
              END ;
          END;
        END;
      110:
        BEGIN // Service Line
          CLEAR(AvailableServiceLines);
          AvailableServiceLines.SetCurrentSubType("Entry No." - 109);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableServiceLines.SetSalesLine(SalesLine,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableServiceLines.SetReqLine(ReqLine,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableServiceLines.SetPurchLine(PurchLine,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableServiceLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableServiceLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableServiceLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableServiceLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableServiceLines.SetServInvLine(ServiceLine,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableServiceLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableServiceLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableServiceLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableServiceLines.RUNMODAL;
              END ;
          END;
        END;
      131,132,133,134:
        BEGIN // Job Planning Line
          CLEAR(AvailableJobPlanningLines);
          AvailableJobPlanningLines.SetCurrentSubType("Entry No." - 131);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableJobPlanningLines.SetSalesLine(SalesLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableJobPlanningLines.SetReqLine(ReqLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableJobPlanningLines.SetPurchLine(PurchLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableJobPlanningLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableJobPlanningLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableJobPlanningLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableJobPlanningLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableJobPlanningLines.SetServLine(ServiceLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableJobPlanningLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableJobPlanningLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableJobPlanningLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableJobPlanningLines.RUNMODAL;
              END ;
          END;
        END;
      141,  142:
        BEGIN // Asm Header
          CLEAR(AvailableAssemblyHeaders);
          AvailableAssemblyHeaders.SetCurrentSubType("Entry No." - 141);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableAssemblyHeaders.SetSalesLine(SalesLine,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableAssemblyHeaders.SetReqLine(ReqLine,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableAssemblyHeaders.SetPurchLine(PurchLine,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableAssemblyHeaders.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableAssemblyHeaders.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableAssemblyHeaders.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableAssemblyHeaders.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableAssemblyHeaders.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableAssemblyHeaders.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableAssemblyHeaders.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableAssemblyHeaders.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableAssemblyHeaders.RUNMODAL;
              END ;
          END;
        END;
      151,152:
        BEGIN // Asm Line
          CLEAR(AvailableAssemblyLines);
          AvailableAssemblyLines.SetCurrentSubType("Entry No." - 151);
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableAssemblyLines.SetSalesLine(SalesLine,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableAssemblyLines.SetReqLine(ReqLine,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableAssemblyLines.SetPurchLine(PurchLine,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableAssemblyLines.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableAssemblyLines.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableAssemblyLines.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableAssemblyLines.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Service Line":
              BEGIN
                AvailableAssemblyLines.SetServiceInvLine(ServiceLine,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Job Planning Line":
              BEGIN
                AvailableAssemblyLines.SetJobPlanningLine(JobPlanningLine,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END;
            DATABASE::"Assembly Header":
              BEGIN
                AvailableAssemblyLines.SetAssemblyHeader(AssemblyHeader,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END ;
            DATABASE::"Assembly Line":
              BEGIN
                AvailableAssemblyLines.SetAssemblyLine(AssemblyLine,ReservEntry2);
                AvailableAssemblyLines.RUNMODAL;
              END ;
          END;
        END;
    END;

    UpdateReservFrom;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..118
            //20.03.2013 EDMS >>
            DATABASE::"Service Line EDMS":
              BEGIN
                AvailableItemLedgEntries.SetServiceLineEDMS(ServiceLineEDMS,ReservEntry2);
                AvailableItemLedgEntries.SetTotalAvailQty("Total Available Quantity");
                AvailableItemLedgEntries.SetMaxQtyToReserve(QtyToReserve - QtyReserved);
                AvailableItemLedgEntries.RUNMODAL;
              END;
            //20.03.2013 EDMS <<
    #119..180
            DATABASE::"Service Line EDMS":  //11.07.2013 EDMS P8
              BEGIN
                AvailablePurchLines.SetServiceLineEDMS(ServiceLineEDMS,ReservEntry2);
                AvailablePurchLines.RUNMODAL;
    #241..243
    #183..241
            DATABASE::"Service Line EDMS":  //11.07.2013 EDMS P8
              BEGIN
                AvailableReqLines.SetServiceLineEDMS(ServiceLineEDMS,ReservEntry2);
                AvailableReqLines.RUNMODAL;
    #303..305
    #244..303
            DATABASE::"Service Line EDMS":  //11.07.2013 EDMS P8
              BEGIN
                AvailableSalesLines.SetServiceLineEDMS(ServiceLineEDMS,ReservEntry2);
                AvailableSalesLines.RUNMODAL;
    #365..367
    #306..549
            DATABASE::"Service Line EDMS":  //11.07.2013 EDMS P8
              BEGIN
                AvailableTransLines.SetServiceLineEDMS(ServiceLineEDMS,ReservEntry2);
                AvailableTransLines.RUNMODAL;
    #611..613
    #552..799
      220,230: //18.07.2008 EDMS P1 - Elva DMS Service Management integration
        BEGIN // Service Order, Service Return Order
          CLEAR(AvailableServiceLinesEDMS);
          CASE "Entry No." OF
           220:AvailableServiceLinesEDMS.SetCurrentSubType(1);
           230:AvailableServiceLinesEDMS.SetCurrentSubType(2);
          END;
          CASE ReservEntry2."Source Type" OF
            DATABASE::"Sales Line":
              BEGIN
                AvailableServiceLinesEDMS.SetSalesLine(SalesLine,ReservEntry2);
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
            DATABASE::"Requisition Line":
              BEGIN
                AvailableServiceLinesEDMS.SetReqLine(ReqLine,ReservEntry2);
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
            DATABASE::"Purchase Line":
              BEGIN
                AvailableServiceLinesEDMS.SetPurchLine(PurchLine,ReservEntry2);
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
            DATABASE::"Item Journal Line":
              BEGIN
                AvailableServiceLinesEDMS.SetItemJnlLine(ItemJnlLine,ReservEntry2);
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
            DATABASE::"Prod. Order Line":
              BEGIN
                AvailableServiceLinesEDMS.SetProdOrderLine(ProdOrderLine,ReservEntry2);
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
            DATABASE::"Prod. Order Component":
              BEGIN
                AvailableServiceLinesEDMS.SetProdOrderComponent(ProdOrderComp,ReservEntry2);
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
            DATABASE::"Planning Component":
              BEGIN
                AvailableServiceLinesEDMS.SetPlanningComponent(PlanningComponent,ReservEntry2);
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
            DATABASE::"Transfer Line":
              BEGIN
                AvailableServiceLinesEDMS.SetTransferLine(TransLine,ReservEntry2,ReservEntry."Source Subtype");
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
            DATABASE::"Service Line EDMS":  //11.07.2013 EDMS P8
              BEGIN
                AvailableServiceLinesEDMS.SetServiceLineEDMS(ServiceLineEDMS,ReservEntry2);
                AvailableServiceLinesEDMS.RUNMODAL;
              END;
          END;
        END;
    #800..802
    */
    //end;


    //Unsupported feature: Code Modification on "GetQtyPerUOMFromSource(PROCEDURE 24)".

    //procedure GetQtyPerUOMFromSource();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE ReservEntry."Source Type" OF
      DATABASE::"Sales Line":
        EXIT(GetQtyPerUomFromSalesLine);
    #4..22
        EXIT(GetQtyPerUomFromServiceLine);
      DATABASE::"Job Planning Line":
        EXIT(GetQtyPerUomFromJobPlanningLine);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..25
      //20.03.2013 EDMS >>
      DATABASE::"Service Line EDMS":
        BEGIN
          ServiceLineEDMS.FIND;
          ServiceLineEDMS.CALCFIELDS("Reserved Qty. (Base)");
          IF ServiceLineEDMS."Document Type" = ServiceLineEDMS."Document Type"::"Return Order" THEN
            ServiceLineEDMS."Reserved Qty. (Base)" := -ServiceLineEDMS."Reserved Qty. (Base)";
          QtyReserved := ServiceLineEDMS."Reserved Qty. (Base)";
          QtyToReserve := ServiceLineEDMS."Outstanding Qty. (Base)";
          //17.04.2014 Elva Baltic P1 #RX MMG7.00 >>
          QtyReserved := ServiceLineEDMS."Reserved Quantity";
          QtyReservedBase := ServiceLineEDMS."Reserved Qty. (Base)";
          QtyToReserve := ServiceLineEDMS."Outstanding Quantity";
          QtyToReserveBase := ServiceLineEDMS."Outstanding Qty. (Base)";
          EXIT(ServiceLineEDMS."Qty. per Unit of Measure");
          //17.04.2014 Elva Baltic P1 #RX MMG7.00 <<
        END;
      //20.03.2013 EDMS <<
    END;
    */
    //end;

    procedure SetServiceLineEDMS(var CurrentServiceLine: Record "25006146")
    begin
        CurrentServiceLine.TESTFIELD(Type, CurrentServiceLine.Type::Item);

        ServiceLineEDMS := CurrentServiceLine;
        ReservEntry."Source Type" := DATABASE::"Service Line EDMS";
        ReservEntry."Source Subtype" := ServiceLineEDMS."Document Type";
        ReservEntry."Source ID" := ServiceLineEDMS."Document No.";
        ReservEntry."Source Ref. No." := ServiceLineEDMS."Line No.";

        ReservEntry."Item No." := ServiceLineEDMS."No.";
        ReservEntry."Variant Code" := ServiceLineEDMS."Variant Code";
        ReservEntry."Location Code" := ServiceLineEDMS."Location Code";
        ReservEntry."Shipment Date" := ServiceLineEDMS."Planned Service Date";

        CaptionText := ReserveServiceLineEDMS.Caption(ServiceLineEDMS);
        UpdateReservFrom;
    end;
}

