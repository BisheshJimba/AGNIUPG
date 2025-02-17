page 25006561 "Service Chart"
{
    Caption = 'Service Chart';
    PageType = CardPart;
    SourceTable = Table485;

    layout
    {
        area(content)
        {
            field(StatusText; StatusText)
            {
                Caption = 'Status Text';
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = TRUE;
            }
            usercontrol(BusinessChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {

                trigger DataPointClicked(point: DotNet BusinessChartDataPoint)
                begin
                    SetDrillDownIndexes(point);
                    ChartManagement.DataPointClicked(Rec, SelectedChartDefinition);
                end;

                trigger DataPointDoubleClicked(point: DotNet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                begin
                    IsChartAddInReady := TRUE;
                    ChartManagement.AddinReady(SelectedChartDefinition, Rec);
                    InitializeSelectedChart;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Chart")
            {
                Caption = 'Previous Chart';
                Image = PreviousSet;

                trigger OnAction()
                begin
                    IF ChartManagement.IsChartsDefined THEN BEGIN
                        SelectedChartDefinition.SETFILTER("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
                        SelectedChartDefinition.SETRANGE(Enabled, TRUE);
                        IF SelectedChartDefinition.NEXT(-1) = 0 THEN
                            SelectedChartDefinition.FINDLAST;
                        InitializeSelectedChart;
                    END;
                end;
            }
            action("Next Chart")
            {
                Caption = 'Next Chart';
                Image = NextSet;

                trigger OnAction()
                begin
                    IF ChartManagement.IsChartsDefined THEN BEGIN
                        SelectedChartDefinition.SETFILTER("Profile ID", '%1|%2', '', UserProfileMgt.CurrProfileID);
                        SelectedChartDefinition.SETRANGE(Enabled, TRUE);
                        IF SelectedChartDefinition.NEXT = 0 THEN
                            SelectedChartDefinition.FINDFIRST;
                        InitializeSelectedChart;
                    END;
                end;
            }
            group(PeriodLength)
            {
                Caption = 'Period Length';
                Image = Period;
                action(Day)
                {
                    Caption = 'Day';
                    Enabled = DayEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart("Period Length"::Day);
                    end;
                }
                action(Week)
                {
                    Caption = 'Week';
                    Enabled = WeekEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart("Period Length"::Week);
                    end;
                }
                action(Month)
                {
                    Caption = 'Month';
                    Enabled = MonthEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart("Period Length"::Month);
                    end;
                }
                action(Quarter)
                {
                    Caption = 'Quarter';
                    Enabled = QuarterEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart("Period Length"::Quarter);
                    end;
                }
                action(Year)
                {
                    Caption = 'Year';
                    Enabled = YearEnabled;

                    trigger OnAction()
                    begin
                        SetPeriodAndUpdateChart("Period Length"::Year);
                    end;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                Image = SelectChart;
                group(ValueToCalculate)
                {
                    Caption = 'Value to Calculate';
                    Image = Calculate;
                    action(Amount)
                    {
                        Caption = 'Amount';
                        Enabled = AmountEnabled;

                        trigger OnAction()
                        var
                            ValueType: Option Amount,Quantity,Percent;
                        begin
                            SetValueTypeAndUpdateChart(ValueType::Amount);
                        end;
                    }
                    action(Quantity)
                    {
                        Caption = 'Quantity';
                        Enabled = QuantityEnabled;

                        trigger OnAction()
                        var
                            ValueType: Option Amount,Quantity,Percent;
                        begin
                            SetValueTypeAndUpdateChart(ValueType::Quantity);
                        end;
                    }
                    action(Percent)
                    {
                        Caption = 'Percent';
                        Enabled = PercentEnabled;

                        trigger OnAction()
                        var
                            ValueType: Option Amount,Quantity,Percent;
                        begin
                            SetValueTypeAndUpdateChart(ValueType::Percent);
                        end;
                    }
                }
                group("Chart Type")
                {
                    Caption = 'Chart Type';
                    Image = BarChart;
                    action(Line)
                    {
                        Caption = 'Line';
                        Enabled = LineEnabled;

                        trigger OnAction()
                        var
                            ChartType: Option Line,StepLine,Column,StackedColumn;
                        begin
                            SetChartTypeAndUpdateChart(ChartType::Line);
                        end;
                    }
                    action(StepLine)
                    {
                        Caption = 'Step Line';
                        Enabled = StepLineEnabled;

                        trigger OnAction()
                        var
                            ChartType: Option Line,StepLine,Column,StackedColumn;
                        begin
                            SetChartTypeAndUpdateChart(ChartType::StepLine);
                        end;
                    }
                    action(Column)
                    {
                        Caption = 'Column';
                        Enabled = ColumnEnabled;

                        trigger OnAction()
                        var
                            ChartType: Option Line,StepLine,Column,StackedColumn;
                        begin
                            SetChartTypeAndUpdateChart(ChartType::Column);
                        end;
                    }
                    action("Stacked Column")
                    {
                        Caption = 'Stacked Column';
                        Enabled = StackedColumnEnabled;

                        trigger OnAction()
                        var
                            ChartType: Option Line,StepLine,Column,StackedColumn;
                        begin
                            SetChartTypeAndUpdateChart(ChartType::StackedColumn);
                        end;
                    }
                }
                group("Group By")
                {
                    Caption = 'Group By';
                    action("No Grouping")
                    {
                        Caption = 'No Grouping';
                        Enabled = NoGroupingEnabled;
                    }
                    action(Location)
                    {
                        Caption = 'Location';
                        Enabled = LocationEnabled;
                    }
                    action("Service Advisor")
                    {
                        Caption = 'Service Advisor';
                        Enabled = ServiceAdvisorEnabled;
                    }
                    action(Resource)
                    {
                        Caption = 'Resource';
                        Enabled = ResourceEnabled;
                    }
                }
            }
            separator()
            {
            }
            action(PreviousPeriod)
            {
                Caption = 'Previous Period';
                Enabled = PreviousEnabled;
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::Previous);
                    ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
                    UpdateChart;
                end;
            }
            action(NextPeriod)
            {
                Caption = 'Next Period';
                Enabled = NextEnabled;
                Image = NextRecord;

                trigger OnAction()
                begin
                    ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::Next);
                    ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
                    UpdateChart;
                end;
            }
            separator()
            {
            }
            action(Refresh)
            {
                Caption = 'Refresh';
                Image = Refresh;

                trigger OnAction()
                begin
                    IF ChartManagement.IsChartsDefined THEN BEGIN
                        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
                        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
                        UpdateChart;
                    END;
                end;
            }
            separator()
            {
            }
            action(Setup)
            {
                Caption = 'Setup';
                Image = Setup;

                trigger OnAction()
                begin
                    IF ChartManagement.IsChartsDefined THEN BEGIN
                        ChartManagement.Setup(SelectedChartDefinition);
                        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
                        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
                        UpdateChart;
                    END;
                end;
            }
        }
    }

    var
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        DayEnabled: Boolean;
        [InDataSet]
        WeekEnabled: Boolean;
        [InDataSet]
        MonthEnabled: Boolean;
        [InDataSet]
        QuarterEnabled: Boolean;
        [InDataSet]
        YearEnabled: Boolean;
        [InDataSet]
        AmountEnabled: Boolean;
        [InDataSet]
        QuantityEnabled: Boolean;
        [InDataSet]
        LineEnabled: Boolean;
        [InDataSet]
        StepLineEnabled: Boolean;
        [InDataSet]
        ColumnEnabled: Boolean;
        StackedColumnEnabled: Boolean;
        PercentEnabled: Boolean;
        NoGroupingEnabled: Boolean;
        LocationEnabled: Boolean;
        ServiceAdvisorEnabled: Boolean;
        ResourceEnabled: Boolean;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;
        ServiceMTDChartMgt: Codeunit "25006134";
        ServiceMTDChartSetup: Record "25006200";
        SelectedChartDefinition: Record "25006201";
        ChartManagement: Codeunit "25006135";
        Period: Option " ",Next,Previous;
        UserProfileMgt: Codeunit "25006002";
        [InDataSet]
        PreviousEnabled: Boolean;
        [InDataSet]
        NextEnabled: Boolean;
        NoChartsDefined: Label 'No Charts Defined';

    local procedure UpdateChart()
    begin
        IF NOT IsChartAddInReady THEN
            EXIT;
        Update(CurrPage.BusinessChart);
        ChartManagement.ActionsEnabled(SelectedChartDefinition,
              DayEnabled, WeekEnabled, MonthEnabled, QuarterEnabled, YearEnabled,
              AmountEnabled, QuantityEnabled, PercentEnabled,
              LineEnabled, StepLineEnabled, ColumnEnabled, StackedColumnEnabled,
              NoGroupingEnabled, LocationEnabled, ServiceAdvisorEnabled, ResourceEnabled,
              PreviousEnabled, NextEnabled);
    end;

    local procedure InitializeSelectedChart()
    begin
        IF ChartManagement.IsChartsDefined THEN BEGIN
            ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
            ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
            UpdateChart;
        END ELSE
            StatusText := NoChartsDefined;
    end;

    local procedure SetPeriodAndUpdateChart(PeriodLength: Option)
    begin
        ChartManagement.SetPeriodLength(SelectedChartDefinition, Rec, PeriodLength, FALSE);
        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
        UpdateChart;
    end;

    local procedure SetValueTypeAndUpdateChart(ValueType: Option Amount,Quantity,Percent)
    begin
        ChartManagement.SetValueType(SelectedChartDefinition, ValueType);
        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
        UpdateChart;
    end;

    local procedure SetChartTypeAndUpdateChart(ChartType: Option Line,StepLine,Column)
    begin
        ChartManagement.SetChartType(SelectedChartDefinition, ChartType);
        ChartManagement.UpdateChart(SelectedChartDefinition, Rec, Period::" ");
        ChartManagement.UpdateStatusText(SelectedChartDefinition, StatusText);
        UpdateChart;
    end;
}

