codeunit 25006873 "Service Booking Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        QuantityTxt: Label 'Quantity';
        LocationCode: Code[20];
        SelectedDate: Date;

    [Scope('Internal')]
    procedure ResourceCapacity(var BusChartBuf: Record "485")
    var
        Resource: Record "156";
    begin
        InitializeBusinessChart(BusChartBuf);
        AddMeasure(BusChartBuf);
        SetXAxis(BusChartBuf);
        SetResourceCapacity(BusChartBuf);
    end;

    local procedure InitializeBusinessChart(var BusChartBuf: Record "485")
    begin
        BusChartBuf.Initialize;
    end;

    local procedure AddMeasure(var BusChartBuf: Record "485")
    begin
        BusChartBuf.AddMeasure('Allocated Time', 1, BusChartBuf."Data Type"::Decimal, BusChartBuf."Chart Type"::StackedColumn);
        BusChartBuf.AddMeasure('Overscheduled', 1, BusChartBuf."Data Type"::Decimal, BusChartBuf."Chart Type"::StackedColumn);
        BusChartBuf.AddMeasure('Available Capacity', 1, BusChartBuf."Data Type"::Decimal, BusChartBuf."Chart Type"::StackedColumn);
    end;

    local procedure SetXAxis(var BusChartBuf: Record "485")
    begin
        BusChartBuf.SetXAxis(QuantityTxt, BusChartBuf."Data Type"::String);
    end;

    local procedure SetResourceCapacity(var BusChartBuf: Record "485")
    var
        Index: Integer;
        ScheduleResourceGroup: Record "25006274";
        ScheduleResourceGroupSpec: Record "25006275";
    begin
        ScheduleResourceGroup.SETRANGE("Location Code", LocationCode);
        ScheduleResourceGroup.FINDFIRST;
        ScheduleResourceGroupSpec.RESET;
        ScheduleResourceGroupSpec.SETRANGE("Group Code", ScheduleResourceGroup.Code);

        IF ScheduleResourceGroupSpec.FINDFIRST THEN
            REPEAT
                SetCapacityByResource(BusChartBuf, Index, ScheduleResourceGroupSpec."Resource No.");
            UNTIL ScheduleResourceGroupSpec.NEXT = 0;
    end;

    local procedure SetCapacityByResource(var BusChartBuf: Record "485"; var Index: Integer; ResourceNo: Code[20])
    var
        AllocatedTime: Decimal;
        Overscheduled: Decimal;
        AvailableCapacity: Decimal;
        Resource: Record "156";
        BookingOrder: Record "25006145";
    begin
        IF Resource.GET(ResourceNo) THEN BEGIN
            Index += 1;


            //Calc >>
            //Allocated Time
            BookingOrder.RESET;
            BookingOrder.SETRANGE("Document Type", BookingOrder."Document Type"::Booking);
            BookingOrder.SETRANGE(BookingOrder."Booking Resource No.", ResourceNo);
            BookingOrder.SETRANGE(BookingOrder."Location Code", LocationCode);
            BookingOrder.SETFILTER("Requested Starting Date", '..%1', SelectedDate);
            BookingOrder.SETFILTER("Requested Finishing Date", '%1..', SelectedDate);
            IF BookingOrder.FINDFIRST THEN
                REPEAT
                    AllocatedTime += BookingOrder."Total Work (Hours)";
                UNTIL BookingOrder.NEXT = 0;

            //Capacity
            IF SelectedDate = 0D THEN
                SelectedDate := WORKDATE;

            Resource.SETRANGE("Date Filter", SelectedDate);
            Resource.CALCFIELDS(Capacity);

            //AvailableCapacity := 100 - AllocatedTime;
            AvailableCapacity := Resource.Capacity - AllocatedTime;
            IF AvailableCapacity < 0 THEN BEGIN
                Overscheduled := AvailableCapacity * -1;
                AllocatedTime := AllocatedTime - Overscheduled;
                AvailableCapacity := 0;
            END ELSE
                Overscheduled := 0;

            //Calc <<

            BusChartBuf.AddColumn(Resource.Name);
            BusChartBuf.SetValue('Allocated Time', Index - 1, AllocatedTime);//Allocated time
            BusChartBuf.SetValue('Available Capacity', Index - 1, AvailableCapacity); //Capacity
            BusChartBuf.SetValue('Overscheduled', Index - 1, Overscheduled); // Overflow
        END;
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

