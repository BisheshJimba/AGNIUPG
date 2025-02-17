page 25006557 "Aftersales CRM Chart"
{
    Caption = 'Sales Campaign Performance';
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
            }
            usercontrol(BusinessChart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {

                trigger DataPointClicked(point: DotNet BusinessChartDataPoint)
                begin
                    SetDrillDownIndexes(point);
                    AftersalesCampaignChartMgt.DrillDown(Rec);
                end;

                trigger DataPointDoubleClicked(point: DotNet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                begin
                    IsChartAddInReady := TRUE;
                    AftersalesCampaignChartMgt.OnOpenPage(AftersalesCRMSetup);
                    UpdateStatus;
                    IF IsChartDataReady THEN
                        UpdateChart;
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Show)
            {
                Caption = 'Show';
                Image = View;
                action(AllOrders)
                {
                    Caption = 'All Orders';
                    Enabled = AllOrdersEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetShowOrders(AftersalesCRMSetup."Show Orders"::"All Orders");
                        UpdateStatus;
                    end;
                }
                action(OrdersUntilToday)
                {
                    Caption = 'Orders Until Today';
                    Enabled = OrdersUntilTodayEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetShowOrders(AftersalesCRMSetup."Show Orders"::"Orders Until Today");
                        UpdateStatus;
                    end;
                }
                action(DelayedOrders)
                {
                    Caption = 'Delayed Orders';
                    Enabled = DelayedOrdersEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetShowOrders(AftersalesCRMSetup."Show Orders"::"Delayed Orders");
                        UpdateStatus;
                    end;
                }
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
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."Period Length"::Day);
                        UpdateStatus;
                    end;
                }
                action(Week)
                {
                    Caption = 'Week';
                    Enabled = WeekEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."Period Length"::Week);
                        UpdateStatus;
                    end;
                }
                action(Month)
                {
                    Caption = 'Month';
                    Enabled = MonthEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."Period Length"::Month);
                        UpdateStatus;
                    end;
                }
                action(Quarter)
                {
                    Caption = 'Quarter';
                    Enabled = QuarterEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."Period Length"::Quarter);
                        UpdateStatus;
                    end;
                }
                action(Year)
                {
                    Caption = 'Year';
                    Enabled = YearEnabled;

                    trigger OnAction()
                    begin
                        AftersalesCRMSetup.SetPeriodLength(AftersalesCRMSetup."Period Length"::Year);
                        UpdateStatus;
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
                        begin
                            AftersalesCRMSetup.SetValueToCalcuate(AftersalesCRMSetup."Value to Calculate"::"Amount Excl. VAT");
                            UpdateStatus;
                        end;
                    }
                    action(NoofOrders)
                    {
                        Caption = 'No. of Orders';
                        Enabled = NoOfOrdersEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetValueToCalcuate(AftersalesCRMSetup."Value to Calculate"::"No. of Orders");
                            UpdateStatus;
                        end;
                    }
                }
                group("Chart Type")
                {
                    Caption = 'Chart Type';
                    Image = BarChart;
                    action(StackedArea)
                    {
                        Caption = 'Stacked Area';
                        Enabled = StackedAreaEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetChartType(AftersalesCRMSetup."Chart Type"::Line);
                            UpdateStatus;
                        end;
                    }
                    action(StackedAreaPct)
                    {
                        Caption = 'Stacked Area (%)';
                        Enabled = StackedAreaPctEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetChartType(AftersalesCRMSetup."Chart Type"::"Step Line");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumn)
                    {
                        Caption = 'Stacked Column';
                        Enabled = StackedColumnEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetChartType(AftersalesCRMSetup."Chart Type"::"Stacked Area (%)");
                            UpdateStatus;
                        end;
                    }
                    action(StackedColumnPct)
                    {
                        Caption = 'Stacked Column (%)';
                        Enabled = StackedColumnPctEnabled;

                        trigger OnAction()
                        begin
                            AftersalesCRMSetup.SetChartType(AftersalesCRMSetup."Chart Type"::"Stacked Column");
                            UpdateStatus;
                        end;
                    }
                }
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
                    NeedsUpdate := TRUE;
                    UpdateStatus;
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
                    RunSetup;
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        Campaign.RESET;
        IF Campaign.COUNT > 0 THEN BEGIN
            UpdateChart;
            IsChartDataReady := TRUE;
            IF NOT IsChartAddInReady THEN
                SetActionsEnabled;
        END;
    end;

    trigger OnOpenPage()
    begin
        SetActionsEnabled;
        NeedsUpdate := TRUE;
    end;

    var
        AftersalesCRMSetup: Record "25006398";
        OldAftersalesCRMSetup: Record "25006398";
        AftersalesCampaignChartMgt: Codeunit "25006209";
        StatusText: Text[250];
        NeedsUpdate: Boolean;
        [InDataSet]
        AllOrdersEnabled: Boolean;
        [InDataSet]
        OrdersUntilTodayEnabled: Boolean;
        [InDataSet]
        DelayedOrdersEnabled: Boolean;
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
        NoOfOrdersEnabled: Boolean;
        [InDataSet]
        StackedAreaEnabled: Boolean;
        [InDataSet]
        StackedAreaPctEnabled: Boolean;
        [InDataSet]
        StackedColumnEnabled: Boolean;
        [InDataSet]
        StackedColumnPctEnabled: Boolean;
        IsChartAddInReady: Boolean;
        IsChartDataReady: Boolean;
        Campaign: Record "5071";

    local procedure UpdateChart()
    begin
        IF NOT NeedsUpdate THEN
            EXIT;
        IF NOT IsChartAddInReady THEN
            EXIT;
        AftersalesCampaignChartMgt.UpdateData(Rec);
        Update(CurrPage.BusinessChart);
        UpdateStatus;
        NeedsUpdate := FALSE;
    end;

    [Scope('Internal')]
    procedure UpdateStatus()
    begin
        AftersalesCRMSetup.GET(USERID);
        NeedsUpdate :=
          NeedsUpdate OR
          (OldAftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."Period Length") OR
          (OldAftersalesCRMSetup."Show Orders" <> AftersalesCRMSetup."Show Orders") OR
          (OldAftersalesCRMSetup."Use Work Date as Base" <> AftersalesCRMSetup."Use Work Date as Base") OR
          (OldAftersalesCRMSetup."Value to Calculate" <> AftersalesCRMSetup."Value to Calculate") OR
          (OldAftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."Chart Type");

        OldAftersalesCRMSetup := AftersalesCRMSetup;

        IF NeedsUpdate THEN
            StatusText := AftersalesCRMSetup.GetCurrentSelectionText;

        SetActionsEnabled;
    end;

    [Scope('Internal')]
    procedure RunSetup()
    begin
        //PAGE.RUNMODAL(PAGE::"Trailing Sales Orders Setup",AftersalesCRMSetup);
        //AftersalesCRMSetup.GET(USERID);
        //UpdateStatus;
    end;

    [Scope('Internal')]
    procedure SetActionsEnabled()
    begin
        AllOrdersEnabled := (AftersalesCRMSetup."Show Orders" <> AftersalesCRMSetup."Show Orders"::"All Orders") AND
          IsChartAddInReady;
        OrdersUntilTodayEnabled :=
          (AftersalesCRMSetup."Show Orders" <> AftersalesCRMSetup."Show Orders"::"Orders Until Today") AND
          IsChartAddInReady;
        DelayedOrdersEnabled := (AftersalesCRMSetup."Show Orders" <> AftersalesCRMSetup."Show Orders"::"Delayed Orders") AND
          IsChartAddInReady;
        DayEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."Period Length"::Day) AND
          IsChartAddInReady;
        WeekEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."Period Length"::Week) AND
          IsChartAddInReady;
        MonthEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."Period Length"::Month) AND
          IsChartAddInReady;
        QuarterEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."Period Length"::Quarter) AND
          IsChartAddInReady;
        YearEnabled := (AftersalesCRMSetup."Period Length" <> AftersalesCRMSetup."Period Length"::Year) AND
          IsChartAddInReady;
        AmountEnabled :=
          (AftersalesCRMSetup."Value to Calculate" <> AftersalesCRMSetup."Value to Calculate"::"Amount Excl. VAT") AND
          IsChartAddInReady;
        NoOfOrdersEnabled :=
          (AftersalesCRMSetup."Value to Calculate" <> AftersalesCRMSetup."Value to Calculate"::"No. of Orders") AND
          IsChartAddInReady;
        StackedAreaEnabled := (AftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."Chart Type"::Line) AND
          IsChartAddInReady;
        StackedAreaPctEnabled := (AftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."Chart Type"::"Step Line") AND
          IsChartAddInReady;
        StackedColumnEnabled := (AftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."Chart Type"::"Stacked Area (%)") AND
          IsChartAddInReady;
        StackedColumnPctEnabled :=
          (AftersalesCRMSetup."Chart Type" <> AftersalesCRMSetup."Chart Type"::"Stacked Column") AND
          IsChartAddInReady;
    end;
}

