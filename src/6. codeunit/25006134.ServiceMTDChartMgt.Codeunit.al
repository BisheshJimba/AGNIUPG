codeunit 25006134 "Service MTD Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        MTDChartSetup: Record "25006200";
        ActualTxt: Label 'Actual';
        TargetTxt: Label 'Target';
        MTDPercentTxt: Label 'MTD %';
        MTDCaptionTxt: Label 'MTD';
        DescriptionTxt: Label 'Service Actual vs Target';

    [Scope('Internal')]
    procedure GetMTDChartSetup(var MTDChartSetupPar: Record "25006200")
    begin
        IF NOT MTDChartSetupPar.GET(USERID) THEN BEGIN
            MTDChartSetupPar."User ID" := USERID;
            MTDChartSetupPar."Use Work Date as Base" := TRUE;
            MTDChartSetupPar."Period Length" := MTDChartSetupPar."Period Length"::Month;
            MTDChartSetupPar."Value to Calculate" := MTDChartSetupPar."Value to Calculate"::Quantity;
            MTDChartSetupPar."Chart Type" := MTDChartSetupPar."Chart Type"::Column;
            MTDChartSetupPar.INSERT;
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
        ToDate: Date;
        Value: Decimal;
        TotalValue: Decimal;
        SalesHeaderStatus: Integer;
        n: Integer;
        ServiceSalesBudget: Record "25006198";
        Location: Record "14";
        ServiceAdvisor: Record "13";
        Resource: Record "156";
        CompanyInfo: Record "79";
    begin
        CompanyInfo.GET;
        GetMTDChartSetup(MTDChartSetup);
        BusChartBuf.Initialize;
        IF MTDChartSetup."Value to Calculate" = MTDChartSetup."Value to Calculate"::Percent THEN
            BusChartBuf.AddMeasure(MTDPercentTxt, 1, BusChartBuf."Data Type"::Decimal, MTDChartSetup.GetChartType)
        ELSE BEGIN
            BusChartBuf.AddMeasure(ActualTxt, 1, BusChartBuf."Data Type"::Decimal, MTDChartSetup.GetChartType);
            BusChartBuf.AddMeasure(TargetTxt, 2, BusChartBuf."Data Type"::Decimal, MTDChartSetup.GetChartType);
        END;
        BusChartBuf.SetXAxis(MTDCaptionTxt, BusChartBuf."Data Type"::String);
        CASE MTDChartSetup."Group By" OF
            MTDChartSetup."Group By"::Total:
                BEGIN
                    n := 1;
                    BusChartBuf.AddColumn(CompanyInfo.Name);
                    IF MTDChartSetup."Value to Calculate" = MTDChartSetup."Value to Calculate"::Percent THEN
                        BusChartBuf.SetValueByIndex(0, n - 1, GetPercentValue('', '', '', Period, ToDate))
                    ELSE BEGIN
                        BusChartBuf.SetValueByIndex(0, n - 1, GetActualValue('', '', '', Period, ToDate));
                        BusChartBuf.SetValueByIndex(1, n - 1, GetTargetValue('', '', '', Period, ToDate));
                    END;
                END;
            MTDChartSetup."Group By"::Location:
                BEGIN
                    n := 1;
                    Location.RESET;
                    Location.SETRANGE("Use As Service Location", TRUE);
                    IF Location.FIND('-') THEN
                        REPEAT
                            BusChartBuf.AddColumn(Location.Name);
                            IF MTDChartSetup."Value to Calculate" = MTDChartSetup."Value to Calculate"::Percent THEN
                                BusChartBuf.SetValueByIndex(0, n - 1, GetPercentValue(Location.Code, '', '', Period, ToDate))
                            ELSE BEGIN
                                BusChartBuf.SetValueByIndex(0, n - 1, GetActualValue(Location.Code, '', '', Period, ToDate));
                                BusChartBuf.SetValueByIndex(1, n - 1, GetTargetValue(Location.Code, '', '', Period, ToDate));
                            END;
                            n += 1;
                        UNTIL Location.NEXT = 0;
                END;
            MTDChartSetup."Group By"::"Service Advisor":
                BEGIN
                    n := 1;
                    ServiceAdvisor.RESET;
                    IF ServiceAdvisor.FIND('-') THEN
                        REPEAT
                            BusChartBuf.AddColumn(ServiceAdvisor.Name);
                            IF MTDChartSetup."Value to Calculate" = MTDChartSetup."Value to Calculate"::Percent THEN
                                BusChartBuf.SetValueByIndex(0, n - 1, GetPercentValue('', ServiceAdvisor.Code, '', Period, ToDate))
                            ELSE BEGIN
                                BusChartBuf.SetValueByIndex(0, n - 1, GetActualValue('', ServiceAdvisor.Code, '', Period, ToDate));
                                BusChartBuf.SetValueByIndex(1, n - 1, GetTargetValue('', ServiceAdvisor.Code, '', Period, ToDate));
                            END;
                            n += 1;
                        UNTIL ServiceAdvisor.NEXT = 0;
                END;
            MTDChartSetup."Group By"::Resource:
                BEGIN
                    n := 1;
                    Resource.RESET;
                    IF Resource.FIND('-') THEN
                        REPEAT
                            BusChartBuf.AddColumn(Resource.Name);
                            IF MTDChartSetup."Value to Calculate" = MTDChartSetup."Value to Calculate"::Percent THEN
                                BusChartBuf.SetValueByIndex(0, n - 1, GetPercentValue('', '', Resource."No.", Period, ToDate))
                            ELSE BEGIN
                                BusChartBuf.SetValueByIndex(0, n - 1, GetActualValue('', '', Resource."No.", Period, ToDate));
                                BusChartBuf.SetValueByIndex(0, n - 1, GetTargetValue('', '', Resource."No.", Period, ToDate));
                            END;
                            n += 1;
                        UNTIL Resource.NEXT = 0;
                END;
        END;
        MTDChartSetup."Start Date" := ToDate;
        MTDChartSetup.MODIFY;
    end;

    local procedure GetTargetValue(LocationCode: Code[10]; ServiceAdvisorCode: Code[10]; ResourceNo: Code[20]; Period: Option " ",Next,Previous; var ToDate: Date): Decimal
    var
        ServiceTargetQry: Query "25006010";
        Amount: Decimal;
        Quantity: Decimal;
        FromDate: Date;
    begin
        IF LocationCode <> '' THEN
            ServiceTargetQry.SETRANGE(Location, LocationCode);
        IF ServiceAdvisorCode <> '' THEN
            ServiceTargetQry.SETRANGE(Service_Advisor, ServiceAdvisorCode);
        IF ResourceNo <> '' THEN
            ServiceTargetQry.SETRANGE(Resource, ResourceNo);

        ToDate := MTDChartSetup.GetStartDate(Period);
        FromDate := MTDChartSetup.GetEndDate(ToDate);

        ServiceTargetQry.SETRANGE(Date, FromDate, ToDate);
        ServiceTargetQry.OPEN;
        WHILE ServiceTargetQry.READ DO BEGIN
            Amount += ServiceTargetQry.Amount;
            Quantity += ServiceTargetQry.Quantity;
        END;

        IF MTDChartSetup."Value to Calculate" = MTDChartSetup."Value to Calculate"::Quantity THEN
            EXIT(Quantity)
        ELSE
            EXIT(Amount);
    end;

    local procedure GetActualValue(LocationCode: Code[10]; ServiceAdvisorCode: Code[10]; ResourceNo: Code[20]; Period: Option " ",Next,Previous; var ToDate: Date): Decimal
    var
        ServiceActualLaborQry: Query "25006009";
        Amount: Decimal;
        Quantity: Decimal;
        FromDate: Date;
        ServiceActualQry: Query "25006012";
    begin
        IF LocationCode <> '' THEN BEGIN
            ServiceActualLaborQry.SETRANGE(Location_Code, LocationCode);
            ServiceActualQry.SETRANGE(Location_Code, LocationCode);
        END;
        IF ServiceAdvisorCode <> '' THEN BEGIN
            ServiceActualLaborQry.SETRANGE(Salesperson_Code, ServiceAdvisorCode);
            ServiceActualQry.SETRANGE(Salesperson_Code, ServiceAdvisorCode);
        END;
        IF ResourceNo <> '' THEN
            ServiceActualLaborQry.SETRANGE(Resource_No, ResourceNo);

        ToDate := MTDChartSetup.GetStartDate(Period);
        FromDate := MTDChartSetup.GetEndDate(ToDate);

        ServiceActualLaborQry.SETRANGE(Posting_Date, FromDate, ToDate);
        ServiceActualLaborQry.OPEN;
        WHILE ServiceActualLaborQry.READ DO BEGIN
            //Amount += ServiceActualLaborQry.Amount_LCY;
            Quantity += ServiceActualLaborQry.Quantity;
        END;

        ServiceActualQry.SETRANGE(Posting_Date, FromDate, ToDate);
        ServiceActualQry.OPEN;
        WHILE ServiceActualQry.READ DO BEGIN
            Amount += ServiceActualQry.Amount_LCY;
        END;

        IF MTDChartSetup."Value to Calculate" = MTDChartSetup."Value to Calculate"::Quantity THEN
            EXIT(Quantity)
        ELSE
            EXIT(Amount);
    end;

    local procedure GetPercentValue(LocationCode: Code[10]; ServiceAdvisorCode: Code[10]; ResourceNo: Code[20]; Period: Option " ",Next,Previous; var ToDate: Date): Decimal
    var
        TargetValue: Decimal;
    begin
        TargetValue := GetTargetValue(LocationCode, ServiceAdvisorCode, ResourceNo, Period, ToDate);
        IF TargetValue = 0 THEN
            EXIT(TargetValue)
        ELSE
            EXIT(ROUND((GetActualValue(LocationCode, ServiceAdvisorCode, ResourceNo, Period, ToDate) / TargetValue) * 100, 0.01));
    end;

    [Scope('Internal')]
    procedure Description(): Text
    begin
        EXIT(DescriptionTxt);
    end;

    [Scope('Internal')]
    procedure StatusText(): Text
    begin
        EXIT(Description + ' | ' + MTDChartSetup.GetCurrentSelectionText);
    end;

    [Scope('Internal')]
    procedure SetActionsEnabled(var DayEnabled: Boolean; var WeekEnabled: Boolean; var MonthEnabled: Boolean; var QuarterEnabled: Boolean; var YearEnabled: Boolean; var AmountEnabled: Boolean; var QuantityEnabled: Boolean; var PercentEnabled: Boolean; var LineEnabled: Boolean; var StepLineEnabled: Boolean; var ColumnEnabled: Boolean; var StackedColumnEnabled: Boolean; var NoGroupingEnabled: Boolean; var LocationEnabled: Boolean; var ServiceAdvisorEnabled: Boolean; var ResourceEnabled: Boolean; var PreviousEnabled: Boolean; var NextEnabled: Boolean)
    var
        Period: Option " ",Next,Previous;
    begin
        DayEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."Period Length"::Day);
        WeekEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."Period Length"::Week);
        MonthEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."Period Length"::Month);
        QuarterEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."Period Length"::Quarter);
        YearEnabled := (MTDChartSetup."Period Length" <> MTDChartSetup."Period Length"::Year);
        AmountEnabled := (MTDChartSetup."Value to Calculate" <> MTDChartSetup."Value to Calculate"::Amount);
        QuantityEnabled := (MTDChartSetup."Value to Calculate" <> MTDChartSetup."Value to Calculate"::Quantity);
        PercentEnabled := (MTDChartSetup."Value to Calculate" <> MTDChartSetup."Value to Calculate"::Percent);
        LineEnabled := FALSE;
        StepLineEnabled := FALSE;
        ColumnEnabled := (MTDChartSetup."Chart Type" <> MTDChartSetup."Chart Type"::Column);
        StackedColumnEnabled := FALSE;
        NoGroupingEnabled := (MTDChartSetup."Group By" <> MTDChartSetup."Group By"::Total);
        LocationEnabled := (MTDChartSetup."Group By" <> MTDChartSetup."Group By"::Location);
        ServiceAdvisorEnabled := (MTDChartSetup."Group By" <> MTDChartSetup."Group By"::"Service Advisor");
        ResourceEnabled := (MTDChartSetup."Group By" <> MTDChartSetup."Group By"::Resource);
        PreviousEnabled := TRUE;
        NextEnabled := MTDChartSetup."Start Date" < MTDChartSetup.GetStartDate(Period::" ");
    end;

    [Scope('Internal')]
    procedure SetValueType(ValueType: Option Amount,Quantity,Percent)
    begin
        GetMTDChartSetup(MTDChartSetup);
        MTDChartSetup."Value to Calculate" := ValueType;
        MTDChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure SetChartType(ChartType: Option Line,StepLine,Column)
    begin
        GetMTDChartSetup(MTDChartSetup);
        MTDChartSetup."Chart Type" := ChartType;
        MTDChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure SetPeriodLenght(PeriodLenght: Option)
    begin
        GetMTDChartSetup(MTDChartSetup);
        MTDChartSetup."Period Length" := PeriodLenght;
        MTDChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure RunSetupPage()
    begin
        PAGE.RUNMODAL(PAGE::"Service MTD Chart Setup");
    end;
}

