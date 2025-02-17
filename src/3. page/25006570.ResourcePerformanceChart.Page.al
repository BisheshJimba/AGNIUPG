page 25006570 "Resource Performance Chart"
{
    PageType = CardPart;
    SourceTable = Table485;

    layout
    {
        area(content)
        {
            usercontrol(Chart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
            {

                trigger DataPointClicked(point: DotNet BusinessChartDataPoint)
                begin
                end;

                trigger DataPointDoubleClicked(point: DotNet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                begin
                    UpdateChart;
                end;
            }
        }
    }

    actions
    {
    }

    var
        BusChartBuf: Record "485";
        PerformanceChartMgt: Codeunit "25006140";

    [Scope('Internal')]
    procedure UpdateChart()
    var
        Period: Option " ",Next,Previous;
    begin
        PerformanceChartMgt.UpdateData(BusChartBuf, Period);
        BusChartBuf.Update(CurrPage.Chart);
    end;
}

