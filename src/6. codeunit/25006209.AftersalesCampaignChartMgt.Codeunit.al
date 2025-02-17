codeunit 25006209 "Aftersales Campaign Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        CustomerXCaptionTxt: Label 'Customer Name';
        SalesLCYYCaptionTxt: Label 'Sales (LCY)';
        AllOtherCustomersTxt: Label 'All Other Customers';
        AftersalesCRMSetup: Record "25006398";
        ServiceHeaderEDMS: Record "25006145";

    [Scope('Internal')]
    procedure OnOpenPage(AftersalesCRMSetup: Record "25006398")
    begin
        IF NOT AftersalesCRMSetup.GET(USERID) THEN BEGIN
            AftersalesCRMSetup."User ID" := USERID;
            AftersalesCRMSetup."Use Work Date as Base" := TRUE;
            AftersalesCRMSetup."Period Length" := AftersalesCRMSetup."Period Length"::Month;
            AftersalesCRMSetup."Value to Calculate" := AftersalesCRMSetup."Value to Calculate"::"No. of Orders";
            AftersalesCRMSetup."Chart Type" := AftersalesCRMSetup."Chart Type"::Line;
            AftersalesCRMSetup.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure DrillDown(var BusChartBuf: Record "485")
    var
        ServiceHeaderEDMS: Record "25006145";
        ToDate: Date;
        Measure: Integer;
    begin
        Measure := BusChartBuf."Drill-Down Measure Index";
        IF (Measure < 0) OR (Measure > 3) THEN
            EXIT;
        AftersalesCRMSetup.GET(USERID);
        //ServiceHeaderEDMS.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        IF AftersalesCRMSetup."Show Orders" = AftersalesCRMSetup."Show Orders"::"Delayed Orders" THEN
            ServiceHeaderEDMS.SETFILTER("Shipment Date", '<%1', AftersalesCRMSetup.GetStartDate);
        IF EVALUATE(ServiceHeaderEDMS.Status, BusChartBuf.GetMeasureValueString(Measure), 9) THEN
            ServiceHeaderEDMS.SETRANGE(Status, ServiceHeaderEDMS.Status);

        ToDate := BusChartBuf.GetXValueAsDate(BusChartBuf."Drill-Down X Index");
        ServiceHeaderEDMS.SETRANGE("Document Date", 0D, ToDate);
        //PAGE.RUN(PAGE::"Sales Order List",SalesHeader);
    end;

    [Scope('Internal')]
    procedure UpdateData(var BusChartBuf: Record "485")
    var
        ChartToMap: array[2] of Integer;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        SalesHeaderStatus: Integer;
        n: Integer;
        Campaign: Record "5071";
    begin
        AftersalesCRMSetup.GET(USERID);
        BusChartBuf.Initialize;
        BusChartBuf."Period Length" := AftersalesCRMSetup."Period Length";
        BusChartBuf.SetPeriodXAxis;

        //CreateMap(ChartToMap);
        n := 0;
        Campaign.RESET;
        IF Campaign.FIND('-') THEN
            IF CalcPeriods(FromDate, ToDate, BusChartBuf) THEN
                BusChartBuf.AddPeriods(ToDate[1], ToDate[ARRAYLEN(ToDate)]);
        REPEAT
            n += 1;
            BusChartBuf.AddMeasure(Campaign."No." + ' ' + Campaign.Description, n, BusChartBuf."Data Type"::Decimal, AftersalesCRMSetup.GetChartType);
            FOR ColumnNo := 1 TO ARRAYLEN(ToDate) DO BEGIN
                Value := GetServiceOrderValue(Campaign."No.", FromDate[ColumnNo], ToDate[ColumnNo]);
                IF ColumnNo = 1 THEN
                    TotalValue := Value
                ELSE
                    TotalValue += Value;
                BusChartBuf.SetValueByIndex(n - 1, ColumnNo - 1, Value);
            END;
        UNTIL Campaign.NEXT = 0;
    end;

    local procedure CalcPeriods(var FromDate: array[5] of Date; var ToDate: array[5] of Date; var BusChartBuf: Record "485"): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ARRAYLEN(ToDate);
        ToDate[MaxPeriodNo] := AftersalesCRMSetup.GetStartDate;
        IF ToDate[MaxPeriodNo] = 0D THEN
            EXIT(FALSE);
        FOR i := MaxPeriodNo DOWNTO 1 DO BEGIN
            IF i > 1 THEN BEGIN
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            END ELSE
                FromDate[i] := 0D
        END;
        EXIT(TRUE);
    end;

    local procedure GetServiceOrderValue(Map: Code[20]; FromDate: Date; ToDate: Date): Decimal
    begin
        IF AftersalesCRMSetup."Value to Calculate" = AftersalesCRMSetup."Value to Calculate"::"No. of Orders" THEN
            EXIT(GetServiceOrderCount(Map, FromDate, ToDate));
        EXIT(GetServiceOrderAmount(Map, FromDate, ToDate));
    end;

    local procedure GetServiceOrderAmount(Map: Code[20]; FromDate: Date; ToDate: Date): Decimal
    var
        CurrExchRate: Record "330";
        ServiceOrderQry: Query "25006003";
        Amount: Decimal;
        TotalAmount: Decimal;
        MapType: Text;
    begin
        //IF AftersalesCRMSetup."Show Orders" = AftersalesCRMSetup."Show Orders"::"Delayed Orders" THEN
        //  TrailingSalesOrderQry.SETFILTER(ShipmentDate,'<%1',AftersalesCRMSetup.GetStartDate);

        //TrailingSalesOrderQry.SETRANGE(Status,Status);
        //IF Map=1 THEN
        //  MapType := 'Labor'
        //ELSE
        //  MapType := 'Item';

        ServiceOrderQry.SETRANGE(PostingDate, FromDate, ToDate);
        ServiceOrderQry.SETRANGE(Campaign_No, Map);
        ServiceOrderQry.OPEN;
        WHILE ServiceOrderQry.READ DO BEGIN
            IF ServiceOrderQry.CurrencyCode = '' THEN
                Amount := ServiceOrderQry.Amount
            ELSE
                Amount := ROUND(ServiceOrderQry.Amount / CurrExchRate.ExchangeRate(TODAY, ServiceOrderQry.CurrencyCode));
            TotalAmount := TotalAmount + Amount;
        END;
        EXIT(TotalAmount);
    end;

    local procedure GetServiceOrderCount(Map: Code[20]; FromDate: Date; ToDate: Date): Decimal
    begin
        //SHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        //IF AftersalesCRMSetup."Show Orders" = TrailingSalesOrdersSetup."Show Orders"::"Delayed Orders" THEN
        //  SalesHeader.SETFILTER("Shipment Date",'<%1',TrailingSalesOrdersSetup.GetStartDate)
        //ELSE
        //  SalesHeader.SETRANGE("Shipment Date");
        //SalesHeader.SETRANGE(Status,Status);
        ServiceHeaderEDMS.RESET;
        ServiceHeaderEDMS.SETRANGE("Campaign No.", Map);
        ServiceHeaderEDMS.SETRANGE("Document Date", FromDate, ToDate);
        EXIT(ServiceHeaderEDMS.COUNT);
    end;

    [Scope('Internal')]
    procedure CreateMap(var Map: array[2] of Integer)
    var
        SalesHeader: Record "36";
    begin
        Map[1] := SalesHeader.Status::Released;
        Map[2] := SalesHeader.Status::"Pending Prepayment";
    end;
}

