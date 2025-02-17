pageextension 50339 pageextension50339 extends "Item Charge Assignment (Sales)"
{
    // 16.01.2014 EDMS P15
    //   * Added GetVehicleToCharge button processing
    layout
    {
        addafter("Control 42")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Editable = false;
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field(VIN; VIN)
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
                    ItemChargeAssgntSales: Record "5809";
                    ReceiptLines: Page "5806";
                    PostedTransferReceiptLines: Page "5759";
                    ShipmentLines: Page "6657";
                    SalesShipmentLines: Page "5824";
                    AssignmentType: Option Sale,Purchase;
                    ReturnRcptLines: Page "6667";
                    OperationDescr: Text[10];
                    SalesShptLine1: Record "111";
                begin
                    //16.01.2014 EDMS P15 - created
                    ItemChargeAssgntSales.SETRANGE("Document Type", Rec."Document Type");
                    ItemChargeAssgntSales.SETRANGE("Document No.", Rec."Document No.");
                    ItemChargeAssgntSales.SETRANGE("Document Line No.", Rec."Document Line No.");

                    GetVehicle.LOOKUPMODE(TRUE);
                    IF GetVehicle.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        GetVehicle.GetVehicleParams(VehSerNoPar, VehAccCycleNo, VehOperationPositive);
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
                                ItemLedgerEntry.SETFILTER("Document Type", '%1', ItemLedgerEntry."Document Type"::"Sales Return Receipt")
                            ELSE
                                ItemLedgerEntry.SETFILTER("Document Type", '%1', ItemLedgerEntry."Document Type"::"Sales Shipment");

                            IF ItemLedgerEntry.FINDLAST THEN BEGIN   //means - the last of sorted by "Entry No."
                                CASE ItemLedgerEntry."Document Type" OF
                                    ItemLedgerEntry."Document Type"::"Sales Shipment":
                                        BEGIN
                                            SalesShipmentLines.SETTABLEVIEW(SalesShptLine);
                                            IF ItemChargeAssgntSales.FINDLAST THEN
                                                // ???               SalesShipmentLines.InitializeSales(ItemChargeAssgntSales,SalesLine2."Unit Cost")
                                                SalesShipmentLines.InitializeSales(ItemChargeAssgntSales, SalesLine2."Sell-to Customer No.", UnitCost)
                                            ELSE BEGIN
                                                InitializeItemChargeAssgntSales(ItemChargeAssgntSales);
                                                //???                SalesShipmentLines.InitializePurchase(Rec,SalesLine2."Unit Cost");
                                                SalesShipmentLines.InitializeSales(Rec, SalesLine2."Sell-to Customer No.", UnitCost);
                                            END;

                                            SalesShptLine1.RESET;
                                            SalesShptLine1.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                                            SalesShptLine1.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                                            IF SalesShptLine1.FINDFIRST THEN BEGIN
                                                AssignmentType := AssignmentType::Sale;

                                                FromSalesShptLine.COPY(SalesShptLine1);
                                                IF FromSalesShptLine.FINDFIRST THEN
                                                    IF AssignmentType = AssignmentType::Sale THEN BEGIN
                                                        ItemChargeAssgntSales."Unit Cost" := UnitCost;
                                                        AssignItemChargeSales.CreateShptChargeAssgnt(FromSalesShptLine, ItemChargeAssgntSales);
                                                    END ELSE
                                                        IF AssignmentType = AssignmentType::Purchase THEN BEGIN
                                                            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
                                                            AssignItemChargePurch.CreateSalesShptChargeAssgnt(FromSalesShptLine, ItemChargeAssgntPurch);
                                                        END;
                                            END;
                                        END;

                                    ItemLedgerEntry."Document Type"::"Sales Return Receipt":
                                        BEGIN
                                            ReturnRcptLines.SETTABLEVIEW(ReturnRcptLine);
                                            IF ItemChargeAssgntSales.FINDLAST THEN
                                                // ???                  ReturnRcptLines.InitializePurchase(ItemChargeAssgntSales,SalesLine2."Unit Cost")
                                                ReturnRcptLines.InitializeSales(ItemChargeAssgntSales, SalesLine2."Sell-to Customer No.", UnitCost)
                                            ELSE BEGIN
                                                // ???                  InitializeItemChargeAssgntPurch(ItemChargeAssgntSales);
                                                ReturnRcptLines.InitializeSales(Rec, SalesLine2."Sell-to Customer No.", UnitCost);
                                            END;

                                            ReturnRcptLine1.RESET;
                                            ReturnRcptLine1.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                                            ReturnRcptLine1.SETRANGE("Line No.", ItemLedgerEntry."Document Line No.");
                                            IF ReturnRcptLine1.FINDFIRST THEN BEGIN
                                                AssignmentType := AssignmentType::Sale;

                                                FromReturnRcptLine.COPY(ReturnRcptLine1);
                                                IF FromReturnRcptLine.FINDFIRST THEN
                                                    IF AssignmentType = AssignmentType::Sale THEN BEGIN
                                                        ItemChargeAssgntSales."Unit Cost" := UnitCost;
                                                        AssignItemChargeSales.CreateRcptChargeAssgnt(FromReturnRcptLine, ItemChargeAssgntSales);

                                                    END ELSE
                                                        IF AssignmentType = AssignmentType::Purchase THEN BEGIN
                                                            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
                                                            AssignItemChargePurch.CreateReturnRcptChargeAssgnt(FromReturnRcptLine, ItemChargeAssgntPurch);
                                                        END;
                                            END;
                                        END;

                                    ELSE
                                        MESSAGE(Text002, OperationDescr, Rec.FIELDCAPTION("Vehicle Serial No."), VehSerNoPar, Rec.FIELDCAPTION("Vehicle Accounting Cycle No."), VehAccCycleNo);
                                END;
                            END ELSE
                                MESSAGE(Text002, OperationDescr, Rec.FIELDCAPTION("Vehicle Serial No."), VehSerNoPar, Rec.FIELDCAPTION("Vehicle Accounting Cycle No."), VehAccCycleNo);
                        END;
                    END;
                end;
            }
        }
    }

    var
        AssignItemChargeSales: Codeunit "5807";
        FromSalesShptLine: Record "111";
        SalesShptLine1: Record "111";
        FromReturnRcptLine: Record "6661";
        ReturnRcptLine1: Record "6661";
        ItemChargeAssgntPurch: Record "5805";
        AssignItemChargePurch: Codeunit "5805";
        Text001: Label 'The Rem. to Assign amount is %1. It must be zero before you can post %2 %3.\ \Are you sure that you want to close the page?', Comment = '%2 = Document Type, %3 = Document No.';
        Text002: Label '%1 of %2: %3, %4: %5 not found.';

    procedure InitializeItemChargeAssgntSales(var ItemChargeAssgntSalesPar: Record "5809")
    begin
        //16.01.2014 EDMS P15 - created
        ItemChargeAssgntSalesPar."Document Type" := SalesLine2."Document Type";
        ItemChargeAssgntSalesPar."Document No." := SalesLine2."Document No.";
        ItemChargeAssgntSalesPar."Document Line No." := SalesLine2."Line No.";
        ItemChargeAssgntSalesPar."Item Charge No." := SalesLine2."No.";
    end;
}

