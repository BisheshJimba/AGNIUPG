codeunit 25006135 "Service Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        Period: Option " ",Next,Previous;
        ServiceTargetChartMgt: Codeunit "25006133";
        ServiceMTDChartMgt: Codeunit "25006134";
        ResPerformanceChartMgt: Codeunit "25006140";
        UserProfileMgt: Codeunit "25006002";

    [Scope('Internal')]
    procedure AddinReady(var ChartDefinition: Record "25006201"; var BusinessChartBuffer: Record "485")
    var
        LastUsedChart: Record "25006202";
        LastChartRecorded: Boolean;
    begin
        LastChartRecorded := LastUsedChart.GET(USERID);
        ChartDefinition.RESET;
        ChartDefinition.SETRANGE("Codeunit ID", LastUsedChart."Codeunit ID");
        ChartDefinition.SETFILTER("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
        IF NOT ChartDefinition.FINDFIRST THEN BEGIN
            ChartDefinition.RESET;
            ChartDefinition.SETRANGE(Enabled, TRUE);
            ChartDefinition.SETFILTER("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
            IF NOT ChartDefinition.FINDFIRST THEN BEGIN
                ChartDefinition.RESET;
                EXIT;
            END;
        END;
        UpdateChart(ChartDefinition, BusinessChartBuffer, Period::" ");
        ChartDefinition.RESET;
    end;

    [Scope('Internal')]
    procedure DataPointClicked(var BusinessChartBuffer: Record "485"; var ChartDefinition: Record "25006201")
    begin
        CASE ChartDefinition."Codeunit ID" OF
            CODEUNIT::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.DrillDown(BusinessChartBuffer);
            CODEUNIT::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.DrillDown(BusinessChartBuffer);
        END;
    end;

    [Scope('Internal')]
    procedure SetPeriodLength(ChartDefinition: Record "25006201"; var BusChartBuf: Record "485"; PeriodLength: Option; IsInitState: Boolean)
    var
        NewStartDate: Date;
    begin
        CASE ChartDefinition."Codeunit ID" OF
            CODEUNIT::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.SetPeriodLenght(PeriodLength);
            CODEUNIT::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.SetPeriodLenght(PeriodLength);
            CODEUNIT::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.SetPeriodLenght(PeriodLength);

        END;
    end;

    [Scope('Internal')]
    procedure UpdateChart(var ChartDefinition: Record "25006201"; var BusinessChartBuffer: Record "485"; Period: Option)
    begin
        CASE ChartDefinition."Codeunit ID" OF
            CODEUNIT::"Service Target Chart Mgt.":
                BEGIN
                    ServiceTargetChartMgt.UpdateData(BusinessChartBuffer, Period);
                END;
            CODEUNIT::"Service MTD Chart Mgt.":
                BEGIN
                    ServiceMTDChartMgt.UpdateData(BusinessChartBuffer, Period);
                END;
            CODEUNIT::"Res. Performance Chart Mgt.":
                BEGIN
                    ResPerformanceChartMgt.UpdateData(BusinessChartBuffer, Period);
                END;

        END;
        UpdateLastUsedChart(ChartDefinition);
    end;

    [Scope('Internal')]
    procedure UpdateStatusText(var ChartDefinition: Record "25006201"; var StatusText: Text)
    begin
        CASE ChartDefinition."Codeunit ID" OF
            CODEUNIT::"Service Target Chart Mgt.":
                StatusText := ServiceTargetChartMgt.StatusText;
            CODEUNIT::"Service MTD Chart Mgt.":
                StatusText := ServiceMTDChartMgt.StatusText;
            CODEUNIT::"Res. Performance Chart Mgt.":
                StatusText := ResPerformanceChartMgt.StatusText;
        END;
    end;

    local procedure UpdateLastUsedChart(ChartDefinition: Record "25006201")
    var
        ServiceLastUsedChart: Record "25006202";
    begin
        IF ServiceLastUsedChart.GET(USERID) THEN BEGIN
            ServiceLastUsedChart.VALIDATE("Codeunit ID", ChartDefinition."Codeunit ID");
            ServiceLastUsedChart.VALIDATE("Chart Name", ChartDefinition."Chart Name");
            ServiceLastUsedChart.MODIFY;
        END ELSE BEGIN
            ServiceLastUsedChart.VALIDATE(UID, USERID);
            ServiceLastUsedChart.VALIDATE("Codeunit ID", ChartDefinition."Codeunit ID");
            ServiceLastUsedChart.VALIDATE("Chart Name", ChartDefinition."Chart Name");
            ServiceLastUsedChart.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure ActionsEnabled(var ChartDefinition: Record "25006201"; var DayEnabled: Boolean; var WeekEnabled: Boolean; var MonthEnabled: Boolean; var QuarterEnabled: Boolean; var YearEnabled: Boolean; var AmountEnabled: Boolean; var QuantityEnabled: Boolean; var PercentEnabled: Boolean; var LineEnabled: Boolean; var StepLineEnabled: Boolean; var ColumnEnabled: Boolean; var StackedColumnEnabled: Boolean; var NoGroupingEnabled: Boolean; var LocationEnabled: Boolean; var ServiceAdvisorEnabled: Boolean; var ResourceEnabled: Boolean; var PreviousEnabled: Boolean; var NextEnabled: Boolean)
    begin
        CASE ChartDefinition."Codeunit ID" OF
            CODEUNIT::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.SetActionsEnabled(DayEnabled, WeekEnabled, MonthEnabled, QuarterEnabled, YearEnabled,
                          AmountEnabled, QuantityEnabled, PercentEnabled,
                          LineEnabled, StepLineEnabled, ColumnEnabled, StackedColumnEnabled,
                          NoGroupingEnabled, LocationEnabled, ServiceAdvisorEnabled, ResourceEnabled,
                          PreviousEnabled, NextEnabled);
            CODEUNIT::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.SetActionsEnabled(DayEnabled, WeekEnabled, MonthEnabled, QuarterEnabled, YearEnabled,
                          AmountEnabled, QuantityEnabled, PercentEnabled,
                          LineEnabled, StepLineEnabled, ColumnEnabled, StackedColumnEnabled,
                          NoGroupingEnabled, LocationEnabled, ServiceAdvisorEnabled, ResourceEnabled,
                          PreviousEnabled, NextEnabled);
            CODEUNIT::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.SetActionsEnabled(DayEnabled, WeekEnabled, MonthEnabled, QuarterEnabled, YearEnabled,
                          AmountEnabled, QuantityEnabled, PercentEnabled,
                          LineEnabled, StepLineEnabled, ColumnEnabled, StackedColumnEnabled,
                          NoGroupingEnabled, LocationEnabled, ServiceAdvisorEnabled, ResourceEnabled,
                          PreviousEnabled, NextEnabled);
        END;
    end;

    [Scope('Internal')]
    procedure SetValueType(ChartDefinition: Record "25006201"; ValueType: Option Amount,Quantity,Percent)
    begin
        CASE ChartDefinition."Codeunit ID" OF
            CODEUNIT::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.SetValueType(ValueType);
            CODEUNIT::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.SetValueType(ValueType);
            CODEUNIT::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.SetValueType(ValueType);
        END;
    end;

    [Scope('Internal')]
    procedure SetChartType(ChartDefinition: Record "25006201"; ChartType: Option Line,StepLine,Column,StackedColumn)
    begin
        CASE ChartDefinition."Codeunit ID" OF
            CODEUNIT::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.SetChartType(ChartType);
            CODEUNIT::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.SetChartType(ChartType);
            CODEUNIT::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.SetChartType(ChartType);
        END;
    end;

    [Scope('Internal')]
    procedure Setup(ChartDefinition: Record "25006201")
    begin
        CASE ChartDefinition."Codeunit ID" OF
            CODEUNIT::"Service Target Chart Mgt.":
                ServiceTargetChartMgt.RunSetupPage;
            CODEUNIT::"Service MTD Chart Mgt.":
                ServiceMTDChartMgt.RunSetupPage;
            CODEUNIT::"Res. Performance Chart Mgt.":
                ResPerformanceChartMgt.RunSetupPage;
        END;
    end;

    [Scope('Internal')]
    procedure IsChartsDefined(): Boolean
    var
        ChartDefinition2: Record "25006201";
    begin
        ChartDefinition2.RESET;
        ChartDefinition2.SETRANGE(Enabled, TRUE);
        ChartDefinition2.SETFILTER("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
        IF ChartDefinition2.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;
}

