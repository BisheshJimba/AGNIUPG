codeunit 25006133 "Service Target Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        TargetChartSetup: Record "25006199";
        DescriptionTxt: Label 'Service Target vs Actual';
        MeasureTargetTxt: Label 'Target';
        MeasureActualTxt: Label 'Actual';

    [Scope('Internal')]
    procedure GetTargetChartSetup(var TargetChartSetupPar: Record "25006199")
    begin
        IF NOT TargetChartSetupPar.GET(USERID) THEN BEGIN
            TargetChartSetupPar."User ID" := USERID;
            TargetChartSetupPar."Use Work Date as Base" := TRUE;
            TargetChartSetupPar."Period Length" := TargetChartSetupPar."Period Length"::Month;
            TargetChartSetupPar."Value to Calculate" := TargetChartSetupPar."Value to Calculate"::Amount;
            TargetChartSetupPar."Chart Type" := TargetChartSetupPar."Chart Type"::Line;
            "Start Date" := WORKDATE;
            TargetChartSetupPar.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure DrillDown(var BusChartBuf: Record "485")
    begin
    end;

    [Scope('Internal')]
    procedure UpdateData(var BusChartBuf: Record "485"; Period: Option " ",Next,Previous)
    var
        ChartToMap: array[2] of Integer;
        ToDate: array[5] of Date;
        FromDate: array[5] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        SalesHeaderStatus: Integer;
        n: Integer;
        ServiceSalesBudget: Record "25006198";
    begin
        GetTargetChartSetup(TargetChartSetup);
        BusChartBuf.Initialize;
        BusChartBuf."Period Length" := TargetChartSetup."Period Length";
        BusChartBuf.SetPeriodXAxis;

        IF CalcPeriods(FromDate, ToDate, BusChartBuf, Period) THEN
            BusChartBuf.AddPeriods(ToDate[1], ToDate[ARRAYLEN(ToDate)]);

        n := 1;
        BusChartBuf.AddMeasure(MeasureActualTxt, 1, BusChartBuf."Data Type"::Decimal, TargetChartSetup.GetChartType);
        FOR ColumnNo := 1 TO ARRAYLEN(ToDate) DO BEGIN
            BusChartBuf.SetValueByIndex(n - 1, ColumnNo - 1, GetActualValue(FromDate[ColumnNo], ToDate[ColumnNo]));
        END;
        n := 2;
        BusChartBuf.AddMeasure(MeasureTargetTxt, 2, BusChartBuf."Data Type"::Decimal, TargetChartSetup.GetChartType);
        FOR ColumnNo := 1 TO ARRAYLEN(ToDate) DO BEGIN
            BusChartBuf.SetValueByIndex(n - 1, ColumnNo - 1, GetTargetValue(FromDate[ColumnNo], ToDate[ColumnNo]));
        END;
    end;

    local procedure CalcPeriods(var FromDate: array[5] of Date; var ToDate: array[5] of Date; var BusChartBuf: Record "485"; Period: Option " ",Next,Previous): Boolean
    var
        MaxPeriodNo: Integer;
        i: Integer;
    begin
        MaxPeriodNo := ARRAYLEN(ToDate);
        ToDate[MaxPeriodNo] := TargetChartSetup.GetStartDate(Period);
        IF ToDate[MaxPeriodNo] = 0D THEN
            EXIT(FALSE);
        FOR i := MaxPeriodNo DOWNTO 1 DO BEGIN
            IF i > 1 THEN BEGIN
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            END ELSE
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i])
        END;
        TargetChartSetup."Start Date" := ToDate[MaxPeriodNo];
        TargetChartSetup.MODIFY;
        EXIT(TRUE);
    end;

    local procedure GetTargetValue(FromDate: Date; ToDate: Date): Decimal
    var
        ServiceTargetQry: Query "25006010";
        Amount: Decimal;
        LocationCode: Code[10];
        ServicePersonCode: Code[10];
        ResourceNo: Code[20];
        Quantity: Decimal;
    begin
        LocationCode := TargetChartSetup.GetLocation;
        IF LocationCode <> '' THEN
            ServiceTargetQry.SETRANGE(Service_Advisor, LocationCode);
        ServicePersonCode := TargetChartSetup.GetServicePerson;
        IF ServicePersonCode <> '' THEN
            ServiceTargetQry.SETRANGE(Location, ServicePersonCode);
        ResourceNo := TargetChartSetup.GetResource;
        IF ResourceNo <> '' THEN
            ServiceTargetQry.SETRANGE(Resource, ResourceNo);
        ServiceTargetQry.SETRANGE(Date, FromDate, ToDate);
        ServiceTargetQry.OPEN;
        WHILE ServiceTargetQry.READ DO BEGIN
            Amount += ServiceTargetQry.Amount;
            Quantity += ServiceTargetQry.Quantity;
        END;

        IF TargetChartSetup."Value to Calculate" = TargetChartSetup."Value to Calculate"::Quantity THEN
            EXIT(Quantity)
        ELSE
            EXIT(Amount);
    end;

    local procedure GetActualValue(FromDate: Date; ToDate: Date): Decimal
    var
        ServiceActualQry: Query "25006009";
        Amount: Decimal;
        LocationCode: Code[10];
        ServicePersonCode: Code[10];
        ResourceNo: Code[20];
        Quantity: Decimal;
    begin
        LocationCode := TargetChartSetup.GetLocation;
        IF LocationCode <> '' THEN
            ServiceActualQry.SETRANGE(Location_Code, LocationCode);
        ServicePersonCode := TargetChartSetup.GetServicePerson;
        IF ServicePersonCode <> '' THEN
            ServiceActualQry.SETRANGE(Salesperson_Code, ServicePersonCode);
        ResourceNo := TargetChartSetup.GetResource;
        IF ResourceNo <> '' THEN
            ServiceActualQry.SETRANGE(Resource_No, ResourceNo);
        ServiceActualQry.SETRANGE(Posting_Date, FromDate, ToDate);
        ServiceActualQry.OPEN;
        WHILE ServiceActualQry.READ DO BEGIN
            Amount += ServiceActualQry.Amount_LCY;
            Quantity += ServiceActualQry.Quantity;
        END;

        IF TargetChartSetup."Value to Calculate" = TargetChartSetup."Value to Calculate"::Quantity THEN
            EXIT(Quantity)
        ELSE
            EXIT(Amount);
    end;

    [Scope('Internal')]
    procedure Description(): Text
    begin
        EXIT(DescriptionTxt);
    end;

    [Scope('Internal')]
    procedure StatusText(): Text
    begin
        EXIT(Description + ' | ' + TargetChartSetup.GetCurrentSelectionText);
    end;

    [Scope('Internal')]
    procedure SetActionsEnabled(var DayEnabled: Boolean; var WeekEnabled: Boolean; var MonthEnabled: Boolean; var QuarterEnabled: Boolean; var YearEnabled: Boolean; var AmountEnabled: Boolean; var QuantityEnabled: Boolean; var PercentEnabled: Boolean; var LineEnabled: Boolean; var StepLineEnabled: Boolean; var ColumnEnabled: Boolean; var StackedColumnEnabled: Boolean; var NoGroupingEnabled: Boolean; var LocationEnabled: Boolean; var ServiceAdvisorEnabled: Boolean; var ResourceEnabled: Boolean; var PreviousEnabled: Boolean; var NextEnabled: Boolean)
    var
        Period: Option " ",Next,Previous;
    begin
        GetTargetChartSetup(TargetChartSetup);
        DayEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."Period Length"::Day);
        WeekEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."Period Length"::Week);
        MonthEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."Period Length"::Month);
        QuarterEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."Period Length"::Quarter);
        YearEnabled := (TargetChartSetup."Period Length" <> TargetChartSetup."Period Length"::Year);
        AmountEnabled := (TargetChartSetup."Value to Calculate" <> TargetChartSetup."Value to Calculate"::Amount);
        QuantityEnabled := (TargetChartSetup."Value to Calculate" <> TargetChartSetup."Value to Calculate"::Quantity);
        PercentEnabled := FALSE;
        LineEnabled := (TargetChartSetup."Chart Type" <> TargetChartSetup."Chart Type"::Line);
        StepLineEnabled := (TargetChartSetup."Chart Type" <> TargetChartSetup."Chart Type"::"Step Line");
        ColumnEnabled := (TargetChartSetup."Chart Type" <> TargetChartSetup."Chart Type"::Column);
        StackedColumnEnabled := FALSE;
        NoGroupingEnabled := FALSE;
        LocationEnabled := FALSE;
        ServiceAdvisorEnabled := FALSE;
        ResourceEnabled := FALSE;
        PreviousEnabled := TRUE;
        NextEnabled := TargetChartSetup."Start Date" < TargetChartSetup.GetStartDate(Period::" ");
    end;

    [Scope('Internal')]
    procedure SetValueType(ValueType: Option Amount,Quantity,Percent)
    begin
        GetTargetChartSetup(TargetChartSetup);
        TargetChartSetup."Value to Calculate" := ValueType;
        TargetChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure SetChartType(ChartType: Option Line,StepLine,Column)
    begin
        GetTargetChartSetup(TargetChartSetup);
        TargetChartSetup."Chart Type" := ChartType;
        TargetChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure SetPeriodLenght(PeriodLenght: Option)
    begin
        GetTargetChartSetup(TargetChartSetup);
        TargetChartSetup."Period Length" := PeriodLenght;
        TargetChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure RunSetupPage()
    begin
        PAGE.RUNMODAL(PAGE::"Service Target Chart Setup");
    end;
}

