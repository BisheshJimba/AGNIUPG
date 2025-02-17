page 25006072 "Vehicle Statistics"
{
    Caption = 'Vehicle Statistics';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006005;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Serial No."; "Serial No.")
                {
                    Editable = false;
                }
                field(Inventory; Inventory)
                {
                    Editable = false;
                }
                field(CurrLocationCode; CurrLocationCode)
                {
                    Caption = 'Current Location Code';
                    Editable = false;
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field(ServiceCount; ServiceCount)
                {
                    Caption = 'Service Order Count';
                    Editable = false;
                }
                field(ServiceSalesLCY; ServiceSalesLCY)
                {
                    Caption = 'Sales (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text010);
                    end;
                }
                field(ServiceCostLCY; ServiceCostLCY)
                {
                    Caption = 'Cost (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text011);
                    end;
                }
                field(ServiceProfitLCY; ServiceProfitLCY)
                {
                    Caption = 'Profit (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text012);
                    end;
                }
                field(ServiceProfitPercent; ServiceProfitPercent)
                {
                    Caption = 'Profit %';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text013);
                    end;
                }
            }
            group("Vehicle Trade")
            {
                Caption = 'Vehicle Trade';
                field(TradeSalesLCY; TradeSalesLCY)
                {
                    Caption = 'Sales (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text001);
                    end;
                }
                field(TradeCogsLCY; TradeCogsLCY)
                {
                    Caption = 'COGS (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text003);
                    end;
                }
                field(TradeProfitLCY; TradeProfitLCY)
                {
                    Caption = 'Profit (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text004);
                    end;
                }
                field(TradeProfitPercent; TradeProfitPercent)
                {
                    Caption = 'Profit %';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text005);
                    end;
                }
                field(TradePurchaseLCY; TradePurchaseLCY)
                {
                    Caption = 'Purchase (LCY)';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text002);
                    end;
                }
                field(TradeCost; TradeCost)
                {
                    Caption = 'Cost';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text006);
                    end;
                }
                field(TradeExpenses; TradeExpenses)
                {
                    Caption = 'Expenses';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text008);
                    end;
                }
                field(TradeCostIncExpenses; TradeCostIncExpenses)
                {
                    Caption = 'Cost Inc. Expenses';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        DrillDown(Text007);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        CostCalcMgt: Codeunit "5836";
    begin
        CALCFIELDS(Inventory);
        CurrLocationCode := '';
        IF Inventory <> 0 THEN
            GetCurrLocation;

        CalculateVehicleTrade;
        CalculateService;
    end;

    trigger OnOpenPage()
    begin
        SETRANGE("Serial No.", "Serial No.");
    end;

    var
        ItemLedgerEntry: Record "32";
        VehicleTradeStatisticsBuffer: Record "25006043" temporary;
        ServiceStatisticsBuffer: Record "25006043" temporary;
        CurrLocationCode: Code[20];
        Text001: Label 'Sales (LCY)';
        Text002: Label 'Purchase (LCY)';
        Text003: Label 'COGS (LCY)';
        Text004: Label 'Profit (LCY)';
        Text005: Label 'Profit %';
        Text006: Label 'Cost';
        Text007: Label 'Cost Incl. Expenses';
        Text008: Label 'Expenses';
        Text010: Label 'Service (LCY)';
        Text011: Label 'Service Cost (LCY)';
        Text012: Label 'Service Profit (LCY)';
        Text013: Label 'Service Profit %';
        ServiceCount: Integer;
        TradeSalesLCY: Decimal;
        TradeCogsLCY: Decimal;
        TradeProfitPercent: Decimal;
        TradeProfitLCY: Decimal;
        TradePurchaseLCY: Decimal;
        TradeCost: Decimal;
        TradeExpenses: Decimal;
        TradeCostIncExpenses: Decimal;
        ServiceSalesLCY: Decimal;
        ServiceCostLCY: Decimal;
        ServiceProfitLCY: Decimal;
        ServiceProfitPercent: Decimal;

    [Scope('Internal')]
    procedure CalculateVehicleTrade()
    var
        SalesAmount: Decimal;
        ProfitAmount: Decimal;
    begin
        TradeSalesLCY := 0;
        TradeCogsLCY := 0;
        TradeProfitPercent := 0;
        TradeProfitLCY := 0;
        TradePurchaseLCY := 0;
        TradeCost := 0;
        TradeExpenses := 0;
        TradeCostIncExpenses := 0;

        VehicleTradeStatisticsBuffer.RESET;
        VehicleTradeStatisticsBuffer.DELETEALL;

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Serial No.");
        ItemLedgerEntry.SETRANGE("Serial No.", "Serial No.");
        CALCFIELDS("Default Vehicle Acc. Cycle No.");
        ItemLedgerEntry.SETRANGE("Vehicle Accounting Cycle No.", "Default Vehicle Acc. Cycle No.");

        IF ItemLedgerEntry.FINDFIRST THEN
            REPEAT
                VehicleTradeInitEntries(ItemLedgerEntry);
                ItemLedgerEntry.CALCFIELDS("Sales Amount (Actual)", "Cost Amount (Actual)", "Cost Amount (Non-Invtbl.)",
                                           "Purchase Amount (Actual)");

                CASE ItemLedgerEntry."Entry Type" OF
                    ItemLedgerEntry."Entry Type"::Sale:
                        BEGIN
                            SalesAmount := AddStatistic("Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 800, Text001,
                                                     ItemLedgerEntry."Sales Amount (Actual)", VehicleTradeStatisticsBuffer);

                            AddStatistic("Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 700, Text003,
                                         ItemLedgerEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);

                            ProfitAmount := AddStatistic("Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 600, Text004,
                                                         ItemLedgerEntry."Sales Amount (Actual)" + ItemLedgerEntry."Cost Amount (Actual)"
                                                        + ItemLedgerEntry."Cost Amount (Non-Invtbl.)", VehicleTradeStatisticsBuffer);

                            CalcProfitProcent("Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 500, Text005,
                                                   SalesAmount, ProfitAmount, VehicleTradeStatisticsBuffer);
                        END;

                    ItemLedgerEntry."Entry Type"::Purchase:
                        BEGIN
                            AddStatistic("Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 400, Text002,
                                        -ItemLedgerEntry."Purchase Amount (Actual)", VehicleTradeStatisticsBuffer);
                            AddStatistic("Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 200, Text007,
                                        -ItemLedgerEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);
                            CalcPurchCosts(ItemLedgerEntry, FALSE);
                        END;

                    ItemLedgerEntry."Entry Type"::"Positive Adjmt.":
                        BEGIN
                            AddStatistic("Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 200, Text007,
                                        -ItemLedgerEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);
                            CalcPurchCosts(ItemLedgerEntry, FALSE);
                        END;

                    ItemLedgerEntry."Entry Type"::Transfer:
                        BEGIN
                            IF ItemLedgerEntry.Positive THEN
                                CalcPurchCosts(ItemLedgerEntry, TRUE);
                        END;

                END;
            UNTIL ItemLedgerEntry.NEXT = 0;

        IF VehicleTradeStatisticsBuffer.FINDFIRST THEN
            REPEAT
                CASE VehicleTradeStatisticsBuffer."Field Name" OF
                    Text001:
                        TradeSalesLCY := VehicleTradeStatisticsBuffer."Field Value";
                    Text002:
                        TradePurchaseLCY := VehicleTradeStatisticsBuffer."Field Value";
                    Text003:
                        TradeCogsLCY := VehicleTradeStatisticsBuffer."Field Value";
                    Text004:
                        TradeProfitLCY := VehicleTradeStatisticsBuffer."Field Value";
                    Text005:
                        TradeProfitPercent := VehicleTradeStatisticsBuffer."Field Value";
                    Text006:
                        TradeCost := VehicleTradeStatisticsBuffer."Field Value";
                    Text007:
                        TradeCostIncExpenses := VehicleTradeStatisticsBuffer."Field Value";
                    Text008:
                        TradeExpenses := VehicleTradeStatisticsBuffer."Field Value";
                END;
            UNTIL VehicleTradeStatisticsBuffer.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure AddStatistic(SerialNo: Code[20]; AccNo: Code[20]; Sequence: Integer; FieldName: Text[30]; FieldValue: Decimal; var VehicleStatisticsBuffer: Record "25006043" temporary): Decimal
    begin
        IF VehicleStatisticsBuffer.GET(SerialNo, AccNo, Sequence, FieldName) THEN BEGIN
            VehicleStatisticsBuffer."Field Value" += FieldValue;
            VehicleStatisticsBuffer.MODIFY;
        END ELSE BEGIN
            VehicleStatisticsBuffer.INIT;
            VehicleStatisticsBuffer."Vehicle Serial No." := SerialNo;
            VehicleStatisticsBuffer."Vehicle Accounting Cycle No." := AccNo;
            VehicleStatisticsBuffer.Sequence := Sequence;
            VehicleStatisticsBuffer."Field Name" := FieldName;
            VehicleStatisticsBuffer."Field Value" := FieldValue;
            VehicleStatisticsBuffer.INSERT;
        END;

        EXIT(VehicleStatisticsBuffer."Field Value");
    end;

    [Scope('Internal')]
    procedure CalcProfitProcent(SerialNo: Code[20]; AccNo: Code[20]; Sequence: Integer; FieldName: Text[30]; SalesAmount: Decimal; ProfitAmount: Decimal; var VehicleStatisticsBuffer: Record "25006043" temporary)
    begin
        IF NOT VehicleStatisticsBuffer.GET(SerialNo, AccNo, Sequence, FieldName) THEN BEGIN
            VehicleStatisticsBuffer.INIT;
            VehicleStatisticsBuffer."Vehicle Serial No." := SerialNo;
            VehicleStatisticsBuffer."Vehicle Accounting Cycle No." := AccNo;
            VehicleStatisticsBuffer.Sequence := Sequence;
            VehicleStatisticsBuffer."Field Name" := FieldName;
            VehicleStatisticsBuffer.INSERT;
        END;

        IF SalesAmount = 0 THEN
            VehicleStatisticsBuffer."Field Value" := 0
        ELSE
            VehicleStatisticsBuffer."Field Value" := ROUND(100 * ProfitAmount / SalesAmount);

        VehicleStatisticsBuffer.MODIFY;
    end;

    [Scope('Internal')]
    procedure CalcPurchCosts(ItemLedgerEntry: Record "32"; IsPositiveTransfer: Boolean)
    var
        ValueEntry: Record "5802";
        InventoryPostingGroup: Record "94";
    begin
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
        ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
        IF IsPositiveTransfer THEN
            ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Purchase);

        IF ValueEntry.FINDFIRST THEN
            REPEAT
                IF InventoryPostingGroup.GET(ValueEntry."Inventory Posting Group") AND InventoryPostingGroup."Vehicle Additional Expenses"
            THEN
                    AddStatistic(ItemLedgerEntry."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 100, Text008,
                                 -ValueEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer)
                ELSE
                    AddStatistic(ItemLedgerEntry."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 300, Text006,
                                 -ValueEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);

                IF IsPositiveTransfer THEN
                    AddStatistic(ItemLedgerEntry."Serial No.", ItemLedgerEntry."Vehicle Accounting Cycle No.", 200, Text007,
                                 -ValueEntry."Cost Amount (Actual)", VehicleTradeStatisticsBuffer);

            UNTIL ValueEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure VehicleTradeInitEntries(ItemLedgerEntries: Record "32")
    begin
        AddStatistic("Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 800, Text001, 0, VehicleTradeStatisticsBuffer);
        AddStatistic("Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 400, Text002, 0, VehicleTradeStatisticsBuffer);
        AddStatistic("Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 700, Text003, 0, VehicleTradeStatisticsBuffer);
        AddStatistic("Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 600, Text004, 0, VehicleTradeStatisticsBuffer);
        AddStatistic("Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 500, Text005, 0, VehicleTradeStatisticsBuffer);
        AddStatistic("Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 300, Text006, 0, VehicleTradeStatisticsBuffer);
        AddStatistic("Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 200, Text007, 0, VehicleTradeStatisticsBuffer);
        AddStatistic("Serial No.", ItemLedgerEntries."Vehicle Accounting Cycle No.", 100, Text008, 0, VehicleTradeStatisticsBuffer);
    end;

    [Scope('Internal')]
    procedure GetCurrLocation()
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Serial No.");
        ItemLedgerEntry.SETRANGE("Serial No.", "Serial No.");
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        IF ItemLedgerEntry.FINDFIRST THEN
            CurrLocationCode := ItemLedgerEntry."Location Code";
    end;

    [Scope('Internal')]
    procedure CalculateService()
    var
        ServiceLedgerEntry: Record "25006167";
        CurrExchangeRate: Record "330";
        PostedServiceHeader: Record "25006149";
        SalesAmount: Decimal;
        ProfitAmount: Decimal;
    begin
        ServiceSalesLCY := 0;
        ServiceCostLCY := 0;
        ServiceProfitLCY := 0;
        ServiceProfitPercent := 0;

        ServiceStatisticsBuffer.RESET;
        ServiceStatisticsBuffer.DELETEALL;

        PostedServiceHeader.RESET;
        PostedServiceHeader.SETRANGE("Vehicle Serial No.", "Serial No.");
        ServiceCount := PostedServiceHeader.COUNT;

        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", "Serial No.");
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Sale);
        IF ServiceLedgerEntry.FINDFIRST THEN
            REPEAT
                IF ServiceLedgerEntry."Amount (LCY)" < 0 THEN
                    ServiceLedgerEntry."Amount (LCY)" *= -1;
                IF ServiceLedgerEntry."Total Cost" > 0 THEN
                    ServiceLedgerEntry."Total Cost" *= -1;
                ServiceInitEntries(ServiceLedgerEntry);
                SalesAmount := AddStatistic("Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 80, Text010,
                                           ServiceLedgerEntry."Amount (LCY)", ServiceStatisticsBuffer);

                IF ServiceLedgerEntry."Currency Code" <> '' THEN
                    ServiceLedgerEntry."Total Cost" := CurrExchangeRate.ExchangeAmtFCYToLCY(
                                             ServiceLedgerEntry."Posting Date",
                                             ServiceLedgerEntry."Currency Code",
                                             ServiceLedgerEntry."Total Cost",
                                             CurrExchangeRate.ExchangeRate(ServiceLedgerEntry."Posting Date", ServiceLedgerEntry."Currency Code")
              );


                AddStatistic("Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 70, Text011,
                            ServiceLedgerEntry."Total Cost", ServiceStatisticsBuffer);

                ProfitAmount := AddStatistic("Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 60, Text012,
                                            ServiceLedgerEntry."Amount (LCY)" + ServiceLedgerEntry."Total Cost", ServiceStatisticsBuffer);

                CalcProfitProcent("Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 50, Text013, SalesAmount, ProfitAmount
                                       , ServiceStatisticsBuffer);
            UNTIL ServiceLedgerEntry.NEXT = 0;

        IF ServiceStatisticsBuffer.FINDFIRST THEN
            REPEAT
                CASE ServiceStatisticsBuffer."Field Name" OF
                    Text010:
                        ServiceSalesLCY := ServiceStatisticsBuffer."Field Value";
                    Text011:
                        ServiceCostLCY := ServiceStatisticsBuffer."Field Value";
                    Text012:
                        ServiceProfitLCY := ServiceStatisticsBuffer."Field Value";
                    Text013:
                        ServiceProfitPercent := ServiceStatisticsBuffer."Field Value";
                END;
            UNTIL ServiceStatisticsBuffer.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ServiceInitEntries(ServiceLedgerEntry: Record "25006167")
    begin
        AddStatistic("Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 80, Text010, 0, ServiceStatisticsBuffer);
        AddStatistic("Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 70, Text011, 0, ServiceStatisticsBuffer);
        AddStatistic("Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 60, Text012, 0, ServiceStatisticsBuffer);
        AddStatistic("Serial No.", ServiceLedgerEntry."Vehicle Accounting Cycle No.", 50, Text013, 0, ServiceStatisticsBuffer);
    end;

    [Scope('Internal')]
    procedure DrillDown(FieldName: Text[30])
    var
        ItemLedgerEntry: Record "32";
        ValueEntry: Record "5802";
        InventoryPostingGroup: Record "94";
        TempValueEntry: Record "5802" temporary;
        ServiceLedgerEntry: Record "25006167";
        TempServiceLedgerEntry: Record "25006167" temporary;
        VehicleTrade: Boolean;
        Service: Boolean;
    begin
        VehicleTrade := FALSE;
        Service := FALSE;

        ValueEntry.RESET;
        ValueEntry.CLEARMARKS;

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Serial No.");
        ItemLedgerEntry.SETRANGE("Serial No.", "Serial No.");
        CALCFIELDS("Default Vehicle Acc. Cycle No.");
        ItemLedgerEntry.SETRANGE("Vehicle Accounting Cycle No.", "Default Vehicle Acc. Cycle No.");

        CASE FieldName OF
            Text001, Text003, Text004, Text005:
                BEGIN
                    VehicleTrade := TRUE;
                    ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
                    IF ItemLedgerEntry.FINDFIRST THEN
                        REPEAT
                            ValueEntry.RESET;
                            ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
                            ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                            IF ValueEntry.FINDFIRST THEN
                                REPEAT
                                    ValueEntry.MARK(TRUE);
                                UNTIL ValueEntry.NEXT = 0;
                        UNTIL ItemLedgerEntry.NEXT = 0;
                END;

            Text002, Text006, Text007, Text008:
                BEGIN
                    VehicleTrade := TRUE;
                    ItemLedgerEntry.SETFILTER("Entry Type", '%1|%2', ItemLedgerEntry."Entry Type"::Purchase,
                                              ItemLedgerEntry."Entry Type"::"Positive Adjmt.");
                    IF ItemLedgerEntry.FINDFIRST THEN
                        REPEAT
                            ValueEntry.RESET;
                            ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
                            ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                            IF ValueEntry.FINDFIRST THEN
                                REPEAT
                                    IF FieldName = Text006 THEN BEGIN
                                        IF NOT (InventoryPostingGroup.GET(ValueEntry."Inventory Posting Group") AND
                                           InventoryPostingGroup."Vehicle Additional Expenses")
                                        THEN
                                            ValueEntry.MARK(TRUE);
                                    END;
                                    IF FieldName = Text008 THEN BEGIN
                                        IF InventoryPostingGroup.GET(ValueEntry."Inventory Posting Group") AND
                                           InventoryPostingGroup."Vehicle Additional Expenses"
                                        THEN
                                            ValueEntry.MARK(TRUE);
                                    END;
                                    IF FieldName IN [Text002, Text007] THEN
                                        ValueEntry.MARK(TRUE);
                                UNTIL ValueEntry.NEXT = 0;
                        UNTIL ItemLedgerEntry.NEXT = 0;
                END;
            Text010, Text011, Text012, Text013:
                BEGIN
                    Service := TRUE;
                    TempServiceLedgerEntry.RESET;
                    TempServiceLedgerEntry.DELETEALL;
                    ServiceLedgerEntry.RESET;
                    ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.");
                    ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", "Serial No.");
                    ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Sale);
                    IF ServiceLedgerEntry.FINDFIRST THEN
                        REPEAT
                            TempServiceLedgerEntry := ServiceLedgerEntry;
                            IF TempServiceLedgerEntry.INSERT THEN;
                        UNTIL ServiceLedgerEntry.NEXT = 0;
                END;
        END;

        IF VehicleTrade THEN BEGIN
            ValueEntry.MARKEDONLY(TRUE);
            TempValueEntry.RESET;
            TempValueEntry.DELETEALL;
            IF ValueEntry.FINDFIRST THEN
                REPEAT
                    TempValueEntry := ValueEntry;
                    TempValueEntry.INSERT;
                UNTIL ValueEntry.NEXT = 0;

            PAGE.RUNMODAL(PAGE::"Value Entries", TempValueEntry);
        END;

        IF Service THEN
            PAGE.RUNMODAL(PAGE::"Service Ledger Entries EDMS", TempServiceLedgerEntry);
    end;
}

