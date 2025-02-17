page 25006898 "Service Booking Chart"
{
    PageType = ListPart;
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
                    //ChartIsReady := TRUE;
                    UpdateChart;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        LocationCode := BookingMgt.GetDefaultLocationCode;
        SelectedDate := WORKDATE;
    end;

    var
        ChartIsReady: Boolean;
        BusChartBuf: Record "485";
        BookingChartMgt: Codeunit "25006873";
        LocationCode: Code[20];
        SelectedDate: Date;
        BookingMgt: Codeunit "25006875";

    [Scope('Internal')]
    procedure UpdateChart()
    begin
        //IF NOT ChartIsReady THEN
        //  EXIT;

        BookingChartMgt.SetSelectedDate(SelectedDate);
        BookingChartMgt.SetLocationCode(LocationCode);
        BookingChartMgt.ResourceCapacity(BusChartBuf);
        BusChartBuf.Update(CurrPage.Chart);
    end;

    [Scope('Internal')]
    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;

    [Scope('Internal')]
    procedure SetSelectedDate(SelectedDateToSet: Date)
    begin
        SelectedDate := SelectedDateToSet;
    end;
}

