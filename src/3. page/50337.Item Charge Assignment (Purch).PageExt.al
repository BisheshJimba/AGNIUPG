pageextension 50337 pageextension50337 extends "Item Charge Assignment (Purch)"
{
    // 26.04.2016 EB.P7 #PAR_88
    //   Modified UpdateQty, added GrossWeight;
    // 
    // 10.11.2015 EB.P7 #T011
    //   Modified DoVehicleChargeAssignment (UnitCost);
    // 
    // 03.07.2014 Elva Baltic P1 #S0002 EDMS7.10
    //   * Fix of empty AssgntAmount
    // 
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added LVI captions
    // 
    // 03.02.2014 Elva Baltic P7 #F018 MMG7.00
    //   * Code refactored.
    //   * Function "DoVehicleChargeAssignment" created
    // 
    // 16.01.2014 EDMS P15
    //   * Added GetVehicleToCharge button processing
    Editable = false;
    layout
    {
        addafter("Control 39")
        {
            field(VIN; VIN)
            {
            }
            field("Vehicle-Serial No."; "Vehicle-Serial No.")
            {
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field("VIN Code"; "VIN Code")
            {
                Visible = false;
            }
            field("Make Code"; "Make Code")
            {
                Visible = false;
            }
            field("Model Code"; "Model Code")
            {
                Visible = false;
            }
            field("Model Version No."; "Model Version No.")
            {
                Visible = false;
            }
            field(GrossWeight; GrossWeight)
            {
                Caption = 'Gross Weight';
                Editable = false;
            }
        }
    }
    actions
    {
        addafter(GetReturnReceiptLines)
        {
            action(GetVehicleToCharge)
            {
                Caption = 'Get Vehicle to Charge';
                Image = Receipt;

                trigger OnAction()
                var
                    VehSerNoPar: Code[20];
                    VehAccCycleNo: Code[20];
                    VehOperationPositive: Boolean;
                    GetVehicle: Page "25006087";
                    ItemLedgerEntry: Record "32";
                    ItemChargeAssgntPurch: Record "5805";
                    ReceiptLines: Page "5806";
                    PostedTransferReceiptLines: Page "5759";
                    ShipmentLines: Page "6657";
                    SalesShipmentLines: Page "5824";
                    AssignmentType: Option Sale,Purchase;
                    ReturnRcptLines: Page "6667";
                    OperationDescr: Text[10];
                begin
                    //16.01.2014 EDMS P15 - created

                    GetVehicle.LOOKUPMODE(TRUE);
                    IF GetVehicle.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        GetVehicle.GetVehicleParams(VehSerNoPar, VehAccCycleNo, VehOperationPositive);
                        DoVehicleChargeAssignment(VehSerNoPar, VehAccCycleNo, VehOperationPositive, Rec."Document Type", Rec."Document No.", Rec."Document Line No.");
                    END;
                end;
            }
        }
    }

    var
        UnitCost: Decimal;

    var
        AssignItemChargePurch: Codeunit "5805";
        FromPurchRcptLine: Record "121";
        PurchRcptLine1: Record "121";
        FromTransRcptLine: Record "5747";
        TransRcptLine1: Record "5747";
        FromReturnShptLine: Record "6651";
        ReturnShptLine1: Record "6651";
        FromSalesShptLine: Record "111";
        SalesShptLine1: Record "111";
        FromReturnRcptLine: Record "6661";
        ReturnRcptLine1: Record "6661";
        ItemChargeAssgntSales: Record "5809";
        AssignItemChargeSales: Codeunit "5807";
        Text002: Label '%1 of %2: %3, %4: %5 not found.';
        GrossWeight: Decimal;


    //Unsupported feature: Code Modification on "UpdateQtyAssgnt(PROCEDURE 2)".

    //procedure UpdateQtyAssgnt();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    PurchLine2.CALCFIELDS("Qty. to Assign","Qty. Assigned");
    AssignableQty := PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced" -
      PurchLine2."Qty. Assigned";

    ItemChargeAssgntPurch.RESET;
    ItemChargeAssgntPurch.SETCURRENTKEY("Document Type","Document No.","Document Line No.");
    #7..12

    RemQtyToAssign := AssignableQty - TotalQtyToAssign;
    RemAmountToAssign := AssgntAmount - TotalAmountToAssign;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    //AssgntAmount := AssignableQty * UnitCost;  03.07.2014 Elva Baltic P1 #S0002 EDMS7.10
    #4..15
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateQty(PROCEDURE 1)".

    //procedure UpdateQty();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE "Applies-to Doc. Type" OF
      "Applies-to Doc. Type"::Order,"Applies-to Doc. Type"::Invoice:
        BEGIN
          PurchLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
          QtyToReceiveBase := PurchLine."Qty. to Receive (Base)";
          QtyReceivedBase := PurchLine."Qty. Received (Base)";
          QtyToShipBase := 0;
          QtyShippedBase := 0;
        END;
      "Applies-to Doc. Type"::"Return Order","Applies-to Doc. Type"::"Credit Memo":
        BEGIN
          PurchLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
          QtyToReceiveBase := 0;
          QtyReceivedBase := 0;
          QtyToShipBase := PurchLine."Return Qty. to Ship (Base)";
          QtyShippedBase := PurchLine."Return Qty. Shipped (Base)";
        END;
      "Applies-to Doc. Type"::Receipt:
        BEGIN
          PurchRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
          QtyToReceiveBase := 0;
          QtyReceivedBase := PurchRcptLine."Quantity (Base)";
          QtyToShipBase := 0;
          QtyShippedBase := 0;
        END;
      "Applies-to Doc. Type"::"Return Shipment":
        BEGIN
          ReturnShptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
          QtyToReceiveBase := 0;
          QtyReceivedBase := 0;
          QtyToShipBase := 0;
          QtyShippedBase := ReturnShptLine."Quantity (Base)";
        END;
      "Applies-to Doc. Type"::"Transfer Receipt":
        BEGIN
          TransferRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
          QtyToReceiveBase := 0;
          QtyReceivedBase := TransferRcptLine.Quantity;
          QtyToShipBase := 0;
          QtyShippedBase := 0;
        END;
      "Applies-to Doc. Type"::"Sales Shipment":
        BEGIN
          SalesShptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
          QtyToReceiveBase := 0;
          QtyReceivedBase := 0;
          QtyToShipBase := 0;
          QtyShippedBase := SalesShptLine."Quantity (Base)";
        END;
      "Applies-to Doc. Type"::"Return Receipt":
        BEGIN
          ReturnRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
          QtyToReceiveBase := 0;
          QtyReceivedBase := ReturnRcptLine."Quantity (Base)";
          QtyToShipBase := 0;
          QtyShippedBase := 0;
        END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
          GrossWeight := PurchLine."Gross Weight";
    #9..16
          GrossWeight := PurchLine."Gross Weight";
    #17..24
          GrossWeight := PurchRcptLine."Gross Weight";
    #25..32
          GrossWeight := ReturnShptLine."Gross Weight";
    #33..40
          GrossWeight := TransferRcptLine."Gross Weight";
    #41..48
          GrossWeight := SalesShptLine."Gross Weight";
    #49..56
          GrossWeight := ReturnRcptLine."Gross Weight";
        END;
    END;
    */
    //end;

    procedure InitializeItemChargeAssgntPurch(var ItemChargeAssgntPurchPar: Record "5805")
    begin
        //16.01.2014 EDMS P15 - created
        ItemChargeAssgntPurchPar."Document Type" := PurchLine2."Document Type";
        ItemChargeAssgntPurchPar."Document No." := PurchLine2."Document No.";
        ItemChargeAssgntPurchPar."Document Line No." := PurchLine2."Line No.";
        ItemChargeAssgntPurchPar."Item Charge No." := PurchLine2."No.";
    end;

    procedure DoVehicleChargeAssignment(VehSerNoPar: Code[20]; VehAccCycleNo: Code[20]; VehOperationPositive: Boolean; PrchLineDocumentType: Option; PrchLineDocumentNo: Code[20]; PrchDocumentLineNo: Integer)
    var
        GetVehicle: Page "25006087";
        ItemLedgerEntry: Record "32";
        ItemChargeAssgntPurch: Record "5805";
        ReceiptLines: Page "5806";
        PostedTransferReceiptLines: Page "5759";
        ShipmentLines: Page "6657";
        SalesShipmentLines: Page "5824";
        AssignmentType: Option Sale,Purchase;
        ReturnRcptLines: Page "6667";
        OperationDescr: Text[10];
    begin
        ItemChargeAssgntPurch.RESET;
        ItemChargeAssgntPurch.SETRANGE("Document Type", PrchLineDocumentType);
        ItemChargeAssgntPurch.SETRANGE("Document No.", PrchLineDocumentNo);
        ItemChargeAssgntPurch.SETRANGE("Document Line No.", PrchDocumentLineNo);

        IF VehOperationPositive THEN
            OperationDescr := 'Income'
        ELSE
            OperationDescr := 'Outcome';

        IF VehSerNoPar <> '' THEN BEGIN
            ItemLedgerEntry.RESET;
            ItemLedgerEntry.SETRANGE("Serial No.", VehSerNoPar);
            ItemLedgerEntry.SETRANGE("Vehicle Accounting Cycle No.", VehAccCycleNo);
            ItemLedgerEntry.SETRANGE(Positive, VehOperationPositive);
            IF VehOperationPositive THEN
                ItemLedgerEntry.SETFILTER("Document Type", '%1|%2|%3',
                          ItemLedgerEntry."Document Type"::"Purchase Receipt",
                          ItemLedgerEntry."Document Type"::"Transfer Receipt",
                          ItemLedgerEntry."Document Type"::"Sales Return Receipt")
            ELSE
                ItemLedgerEntry.SETFILTER("Document Type", '%1|%2',
                          ItemLedgerEntry."Document Type"::"Purchase Return Shipment",
                          ItemLedgerEntry."Document Type"::"Sales Shipment");

            IF ItemLedgerEntry.FINDLAST THEN BEGIN   //means - the last of sorted by "Entry No."
                CASE ItemLedgerEntry."Document Type" OF
                    ItemLedgerEntry."Document Type"::"Purchase Receipt":
                        BEGIN
                            IF ItemChargeAssgntPurch.FINDLAST THEN
                                ReceiptLines.Initialize(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            ELSE BEGIN
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                ReceiptLines.Initialize(Rec, PurchLine2."Unit Cost");
                            END;

                            PurchRcptLine1.RESET;
                            PurchRcptLine1.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                            PurchRcptLine1.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                            IF PurchRcptLine1.FINDFIRST THEN BEGIN
                                FromPurchRcptLine.COPY(PurchRcptLine1);
                                ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                AssignItemChargePurch.CreateRcptChargeAssgnt(FromPurchRcptLine, ItemChargeAssgntPurch);
                            END;
                        END;

                    ItemLedgerEntry."Document Type"::"Transfer Receipt":
                        BEGIN
                            PostedTransferReceiptLines.SETTABLEVIEW(TransferRcptLine);
                            IF ItemChargeAssgntPurch.FINDLAST THEN
                                PostedTransferReceiptLines.Initialize(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            ELSE BEGIN
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                PostedTransferReceiptLines.Initialize(Rec, PurchLine2."Unit Cost");
                            END;

                            TransRcptLine1.RESET;
                            TransRcptLine1.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                            TransRcptLine1.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                            IF TransRcptLine1.FINDFIRST THEN BEGIN
                                FromTransRcptLine.COPY(TransRcptLine1);
                                ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                AssignItemChargePurch.CreateTransferRcptChargeAssgnt(FromTransRcptLine, ItemChargeAssgntPurch);
                            END;
                        END;

                    ItemLedgerEntry."Document Type"::"Purchase Return Shipment":
                        BEGIN
                            ShipmentLines.SETTABLEVIEW(ReturnShptLine);
                            IF ItemChargeAssgntPurch.FINDLAST THEN
                                ShipmentLines.Initialize(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            ELSE BEGIN
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                ShipmentLines.Initialize(Rec, PurchLine2."Unit Cost");
                            END;

                            ReturnShptLine1.RESET;
                            ReturnShptLine1.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                            ReturnShptLine1.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                            IF ReturnShptLine1.FINDFIRST THEN BEGIN
                                FromReturnShptLine.COPY(ReturnShptLine1);
                                IF FromReturnShptLine.FINDFIRST THEN BEGIN
                                    ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                    AssignItemChargePurch.CreateShptChargeAssgnt(FromReturnShptLine, ItemChargeAssgntPurch);
                                END;
                            END;
                        END;

                    ItemLedgerEntry."Document Type"::"Sales Shipment":
                        BEGIN
                            SalesShipmentLines.SETTABLEVIEW(SalesShptLine);
                            IF ItemChargeAssgntPurch.FINDLAST THEN
                                SalesShipmentLines.InitializePurchase(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            ELSE BEGIN
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                SalesShipmentLines.InitializePurchase(Rec, PurchLine2."Unit Cost");
                            END;

                            SalesShptLine1.RESET;
                            SalesShptLine1.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                            SalesShptLine1.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                            IF SalesShptLine1.FINDFIRST THEN BEGIN
                                AssignmentType := AssignmentType::Purchase;

                                FromSalesShptLine.COPY(SalesShptLine1);
                                IF FromSalesShptLine.FINDFIRST THEN
                                    IF AssignmentType = AssignmentType::Sale THEN BEGIN
                                        ItemChargeAssgntSales."Unit Cost" := PurchLine2."Unit Cost";
                                        AssignItemChargeSales.CreateShptChargeAssgnt(FromSalesShptLine, ItemChargeAssgntSales);
                                    END ELSE
                                        IF AssignmentType = AssignmentType::Purchase THEN BEGIN
                                            ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                            AssignItemChargePurch.CreateSalesShptChargeAssgnt(FromSalesShptLine, ItemChargeAssgntPurch);
                                        END;
                            END;
                        END;

                    ItemLedgerEntry."Document Type"::"Sales Return Receipt":
                        BEGIN
                            ReturnRcptLines.SETTABLEVIEW(ReturnRcptLine);
                            IF ItemChargeAssgntPurch.FINDLAST THEN
                                ReturnRcptLines.InitializePurchase(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            ELSE BEGIN
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                ReturnRcptLines.InitializePurchase(Rec, PurchLine2."Unit Cost");
                            END;

                            ReturnRcptLine1.RESET;
                            ReturnRcptLine1.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                            ReturnRcptLine1.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                            IF ReturnRcptLine1.FINDFIRST THEN BEGIN
                                AssignmentType := AssignmentType::Purchase;

                                FromReturnRcptLine.COPY(ReturnRcptLine1);
                                IF FromReturnRcptLine.FINDFIRST THEN
                                    IF AssignmentType = AssignmentType::Sale THEN BEGIN
                                        ItemChargeAssgntSales."Unit Cost" := PurchLine2."Unit Cost";
                                        AssignItemChargeSales.CreateRcptChargeAssgnt(FromReturnRcptLine, ItemChargeAssgntSales);

                                    END ELSE
                                        IF AssignmentType = AssignmentType::Purchase THEN BEGIN
                                            ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                            AssignItemChargePurch.CreateReturnRcptChargeAssgnt(FromReturnRcptLine, ItemChargeAssgntPurch);
                                        END;
                            END;
                        END;

                    ELSE
                        MESSAGE(Text002, OperationDescr, Rec.FIELDCAPTION("Vehicle-Serial No."), VehSerNoPar, Rec.FIELDCAPTION("Vehicle Accounting Cycle No."), VehAccCycleNo);
                END;
            END ELSE
                MESSAGE(Text002, OperationDescr, Rec.FIELDCAPTION("Vehicle-Serial No."), VehSerNoPar, Rec.FIELDCAPTION("Vehicle Accounting Cycle No."), VehAccCycleNo);
        END;
    end;
}

