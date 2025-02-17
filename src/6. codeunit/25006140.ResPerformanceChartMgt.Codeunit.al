codeunit 25006140 "Res. Performance Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        XAxisTxt: Label 'Period';
        LocationCode: Code[20];
        SelectedDate: Date;
        ResTimeRegMgt: Codeunit "25006290";
        ResPerformanceChartSetup: Record "25006203";
        DescriptionTxt: Label 'Resource Performance';
        MeasureProdTxt: Label 'Productive';
        MeasureNonProdTxt: Label 'Non Productive';
        MeasureAttendedTxt: Label 'Attended';

    [Scope('Internal')]
    procedure UpdateData(var BusChartBuf: Record "485"; Period: Option " ",Next,Previous)
    var
        ToDate: array[7] of Date;
        FromDate: array[7] of Date;
        Value: Decimal;
        TotalValue: Decimal;
        ColumnNo: Integer;
        AttendedHours: Decimal;
        ProductiveHours: Decimal;
        NonProductiveHours: Decimal;
        Day: Date;
        MaxPeriodNo: Integer;
    begin
        GetChartSetup(ResPerformanceChartSetup);
        BusChartBuf.Initialize;
        BusChartBuf."Period Length" := ResPerformanceChartSetup."Period Length";
        BusChartBuf.SetPeriodXAxis;

        IF ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."Chart Type"::StackedColumn THEN
            BusChartBuf.AddMeasure(MeasureAttendedTxt, 1, BusChartBuf."Data Type"::Decimal, ResPerformanceChartSetup.GetChartType);
        BusChartBuf.AddMeasure(MeasureProdTxt, 1, BusChartBuf."Data Type"::Decimal, ResPerformanceChartSetup.GetChartType);
        BusChartBuf.AddMeasure(MeasureNonProdTxt, 1, BusChartBuf."Data Type"::Decimal, ResPerformanceChartSetup.GetChartType);


        IF CalcPeriods(FromDate, ToDate, BusChartBuf, Period, MaxPeriodNo) THEN
            BusChartBuf.AddPeriods(ToDate[1], ToDate[MaxPeriodNo]);

        FOR ColumnNo := 1 TO MaxPeriodNo DO BEGIN
            NonProductiveHours := CalcNonProductiveHours(FromDate[ColumnNo], ToDate[ColumnNo], ResTimeRegMgt.GetCurrentUserResourceNo);
            ProductiveHours := CalcProductiveHours(FromDate[ColumnNo], ToDate[ColumnNo], ResTimeRegMgt.GetCurrentUserResourceNo);
            IF ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."Chart Type"::StackedColumn THEN
                AttendedHours := CalcAttendedHours(FromDate[ColumnNo], ToDate[ColumnNo], ResTimeRegMgt.GetCurrentUserResourceNo);

            //AttendedHours := AttendedHours - (ProductiveHours+NonProductiveHours);

            //AddColumn(Day);
            BusChartBuf.SetValue(MeasureNonProdTxt, ColumnNo - 1, NonProductiveHours);
            BusChartBuf.SetValue(MeasureProdTxt, ColumnNo - 1, ProductiveHours);
            IF ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."Chart Type"::StackedColumn THEN
                BusChartBuf.SetValue(MeasureAttendedTxt, ColumnNo - 1, AttendedHours);
        END;
    end;

    [Scope('Internal')]
    procedure GetChartSetup(var ResPerformanceChartSetupPar: Record "25006203")
    var
        UserSetup: Record "91";
    begin
        IF NOT ResPerformanceChartSetupPar.GET(USERID) THEN BEGIN
            ResPerformanceChartSetupPar."User ID" := USERID;
            ResPerformanceChartSetupPar."Use Work Date as Base" := TRUE;
            ResPerformanceChartSetupPar."Period Length" := ResPerformanceChartSetupPar."Period Length"::Month;
            ResPerformanceChartSetupPar."Value to Calculate" := ResPerformanceChartSetupPar."Value to Calculate"::Amount;
            ResPerformanceChartSetupPar."Chart Type" := ResPerformanceChartSetupPar."Chart Type"::StackedColumn;
            ResPerformanceChartSetupPar.INSERT;
        END;

        IF ResPerformanceChartSetupPar.GET(USERID) AND UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Resource No." <> ResPerformanceChartSetupPar."Resource No." THEN BEGIN
                ResPerformanceChartSetupPar."Resource No." := UserSetup."Resource No.";
                ResPerformanceChartSetupPar.MODIFY;
            END;
        END;
    end;

    local procedure CalcPeriods(var FromDate: array[7] of Date; var ToDate: array[7] of Date; var BusChartBuf: Record "485"; Period: Option " ",Next,Previous; var MaxPeriodNo: Integer): Boolean
    var
        i: Integer;
    begin
        IF ResPerformanceChartSetup."Period Length" = ResPerformanceChartSetup."Period Length"::Day THEN
            MaxPeriodNo := ARRAYLEN(ToDate)
        ELSE
            MaxPeriodNo := 5;

        ToDate[MaxPeriodNo] := ResPerformanceChartSetup.GetStartDate(Period);
        IF ToDate[MaxPeriodNo] = 0D THEN
            EXIT(FALSE);
        FOR i := MaxPeriodNo DOWNTO 1 DO BEGIN
            IF i > 1 THEN BEGIN
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i]);
                ToDate[i - 1] := FromDate[i] - 1;
            END ELSE
                FromDate[i] := BusChartBuf.CalcFromDate(ToDate[i])
        END;
        ResPerformanceChartSetup."Start Date" := ToDate[MaxPeriodNo];
        ResPerformanceChartSetup.MODIFY;
        EXIT(TRUE);
    end;

    local procedure CalcProductiveHours(DateFrom: Date; DateTo: Date; ResourceNo: Code[20]) ProductiveHours: Decimal
    var
        ResPerformanceSummary: Query "25006011";
    begin
        //Calc Productive hours in period
        CLEAR(ResPerformanceSummary);
        ResPerformanceSummary.SETRANGE(Date, DateFrom, DateTo);
        ResPerformanceSummary.SETRANGE(ResPerformanceSummary.Start_Entry_Date, DateFrom, DateTo);
        ResPerformanceSummary.SETRANGE(ResPerformanceSummary.Worktime_Entry, FALSE);
        ResPerformanceSummary.SETRANGE(ResPerformanceSummary.Idle, FALSE);
        ResPerformanceSummary.SETRANGE(Resource_No, ResourceNo);
        ResPerformanceSummary.OPEN;
        WHILE ResPerformanceSummary.READ DO BEGIN
            ProductiveHours += ResPerformanceSummary.Time_Spent;
        END;
        ResPerformanceSummary.CLOSE;
    end;

    local procedure CalcNonProductiveHours(DateFrom: Date; DateTo: Date; ResourceNo: Code[20]) NonProductiveHours: Decimal
    var
        ResPerformanceSummary: Query "25006011";
    begin
        //Calc Non Productive hours on Day
        CLEAR(ResPerformanceSummary);
        ResPerformanceSummary.SETRANGE(Date, DateFrom, DateTo);
        ResPerformanceSummary.SETRANGE(ResPerformanceSummary.Start_Entry_Date, DateFrom, DateTo);
        ResPerformanceSummary.SETRANGE(ResPerformanceSummary.Idle, TRUE);
        ResPerformanceSummary.SETRANGE(Resource_No, ResourceNo);
        ResPerformanceSummary.OPEN;
        WHILE ResPerformanceSummary.READ DO BEGIN
            NonProductiveHours += ResPerformanceSummary.Time_Spent;
        END;
        ResPerformanceSummary.CLOSE;
    end;

    local procedure CalcAttendedHours(DateFrom: Date; DateTo: Date; ResourceNo: Code[20]) AttendedHours: Decimal
    var
        ResPerformanceSummary: Query "25006011";
    begin
        //Calc Attended hours on Day
        CLEAR(ResPerformanceSummary);
        ResPerformanceSummary.SETRANGE(Date, DateFrom, DateTo);
        ResPerformanceSummary.SETRANGE(ResPerformanceSummary.Start_Entry_Date, DateFrom, DateTo);
        ResPerformanceSummary.SETRANGE(ResPerformanceSummary.Idle, FALSE);
        ResPerformanceSummary.SETRANGE(ResPerformanceSummary.Worktime_Entry, TRUE);
        ResPerformanceSummary.SETRANGE(Resource_No, ResourceNo);
        ResPerformanceSummary.OPEN;
        WHILE ResPerformanceSummary.READ DO BEGIN
            AttendedHours += ResPerformanceSummary.Time_Spent;
        END;
        ResPerformanceSummary.CLOSE;
    end;

    [Scope('Internal')]
    procedure SetPeriodLenght(PeriodLenght: Option)
    begin
        GetChartSetup(ResPerformanceChartSetup);
        ResPerformanceChartSetup."Period Length" := PeriodLenght;
        ResPerformanceChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure Description(): Text
    begin
        EXIT(DescriptionTxt);
    end;

    [Scope('Internal')]
    procedure StatusText(): Text
    begin
        EXIT(Description + ' | ' + ResPerformanceChartSetup.GetCurrentSelectionText);
    end;

    [Scope('Internal')]
    procedure SetActionsEnabled(var DayEnabled: Boolean; var WeekEnabled: Boolean; var MonthEnabled: Boolean; var QuarterEnabled: Boolean; var YearEnabled: Boolean; var AmountEnabled: Boolean; var QuantityEnabled: Boolean; var PercentEnabled: Boolean; var LineEnabled: Boolean; var StepLineEnabled: Boolean; var ColumnEnabled: Boolean; var StackedColumnEnabled: Boolean; var NoGroupingEnabled: Boolean; var LocationEnabled: Boolean; var ServiceAdvisorEnabled: Boolean; var ResourceEnabled: Boolean; var PreviousEnabled: Boolean; var NextEnabled: Boolean)
    var
        Period: Option " ",Next,Previous;
    begin
        GetChartSetup(ResPerformanceChartSetup);
        DayEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."Period Length"::Day);
        WeekEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."Period Length"::Week);
        MonthEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."Period Length"::Month);
        QuarterEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."Period Length"::Quarter);
        YearEnabled := (ResPerformanceChartSetup."Period Length" <> ResPerformanceChartSetup."Period Length"::Year);
        AmountEnabled := (ResPerformanceChartSetup."Value to Calculate" <> ResPerformanceChartSetup."Value to Calculate"::Amount);
        QuantityEnabled := (ResPerformanceChartSetup."Value to Calculate" <> ResPerformanceChartSetup."Value to Calculate"::Quantity);
        PercentEnabled := FALSE;
        LineEnabled := (ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."Chart Type"::Line);
        StepLineEnabled := (ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."Chart Type"::"Step Line");
        ColumnEnabled := (ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."Chart Type"::Column);
        StackedColumnEnabled := (ResPerformanceChartSetup."Chart Type" <> ResPerformanceChartSetup."Chart Type"::StackedColumn);
        NoGroupingEnabled := FALSE;
        LocationEnabled := FALSE;
        ServiceAdvisorEnabled := FALSE;
        ResourceEnabled := FALSE;
        PreviousEnabled := TRUE;
        NextEnabled := ResPerformanceChartSetup."Start Date" < ResPerformanceChartSetup.GetStartDate(Period::" ");
    end;

    [Scope('Internal')]
    procedure SetValueType(ValueType: Option Amount,Quantity,Percent)
    begin
        GetChartSetup(ResPerformanceChartSetup);
        ResPerformanceChartSetup."Value to Calculate" := ValueType;
        ResPerformanceChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure SetChartType(ChartType: Option Line,StepLine,Column)
    begin
        GetChartSetup(ResPerformanceChartSetup);
        ResPerformanceChartSetup."Chart Type" := ChartType;
        ResPerformanceChartSetup.MODIFY;
    end;

    [Scope('Internal')]
    procedure RunSetupPage()
    begin
        PAGE.RUNMODAL(PAGE::"Res. Performance Chart Setup");
    end;
}

