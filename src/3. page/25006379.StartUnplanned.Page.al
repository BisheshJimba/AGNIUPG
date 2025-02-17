page 25006379 "Start Unplanned"
{

    layout
    {
        area(content)
        {
            field(SourceType; SourceType)
            {
                Caption = 'Source Type';
                Enabled = false;
            }
            field(SourceID; SourceID)
            {
                Caption = 'Source ID';
                Enabled = false;
            }
            field(ResourceNo; ResourceNo)
            {
                Caption = 'Resource No.';
            }
            field(ReasonCode; ReasonCode)
            {
                Caption = 'Reason';
            }
            field(SchedulePassword; SchedulePassword)
            {
                Caption = 'Pasword';
                ExtendedDatatype = Masked;
            }
            field(StartingDate; StartingDate)
            {
                Caption = 'Starting Date';
                Enabled = false;
            }
            field(StartingTime; StartingTime)
            {
                Caption = 'Starting Time';
                Enabled = false;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        ServiceScheduleSetup.GET;
        ServStandardEvent.GET(SourceID);
        CurrQtyToAllocate := 0.001;
        CalculateDuration(Duration, CurrQtyToAllocate, 0);

        StartingDate := DateTimeMgt.Datetime2Date(StartingDateTime);
        StartingTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        EndingDateTime := ServSchedMgt.CalculateNewStartDateTime(ResourceNo, StartingDateTime, CurrQtyToAllocate);
        EndingDate := DateTimeMgt.Datetime2Date(EndingDateTime);
        EndingTime := DateTimeMgt.Datetime2Time(EndingDateTime);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            StartAlloc;
        END;
    end;

    var
        ServiceScheduleSetup: Record "25006286";
        ServStandardEvent: Record "25006272";
        ServiceLine: Record "25006146" temporary;
        ServLaborAllocEntry: Record "25006271";
        ServSchedMgt: Codeunit "25006201";
        SingleInstanceMgt: Codeunit "25006001";
        DateTimeMgt: Codeunit "25006012";
        ResourceNo: Code[20];
        SourceID: Code[20];
        ReasonCode: Code[10];
        SchedulePassword: Text[20];
        SourceType: Option ,"Service Document","Standard Event";
        SourceSubType: Option Quote,"Order";
        StartingDate: Date;
        EndingDate: Date;
        StartingTime: Time;
        EndingTime: Time;
        StartingDateTime: Decimal;
        EndingDateTime: Decimal;
        CurrQtyToAllocate: Decimal;
        TotalHours: Decimal;
        Duration: Duration;
        Text001: Label 'You can not allocate entry which duration is negative';

    [Scope('Internal')]
    procedure SetParam(ResourceNo1: Code[20]; StartingDateTime1: Decimal; SourceType1: Option ,"Service Document","Standard Event"; SourceSubType1: Option Qoute,"Order"; SourceID1: Code[20])
    var
        ServiceLineLoc: Record "25006146";
    begin
        ResourceNo := ResourceNo1;
        StartingDateTime := StartingDateTime1;
        SourceType := SourceType1;
        SourceSubType := SourceSubType1;
        SourceID := SourceID1;
    end;

    [Scope('Internal')]
    procedure CalculateDuration(var Duration: Duration; var QtyToAllocate: Decimal; WhichWay: Option "To Duration","From Duration")
    begin
        IF WhichWay = WhichWay::"To Duration" THEN
            Duration := ROUND(QtyToAllocate * 3600000, 1);

        IF WhichWay = WhichWay::"From Duration" THEN
            QtyToAllocate := ROUND(Duration / 3600000, 0.0001);
    end;

    [Scope('Internal')]
    procedure StartAlloc()
    begin
        ServSchedMgt.CompareSchedulePassword(ResourceNo, SchedulePassword);

        StartingDateTime := DateTimeMgt.Datetime(StartingDate, StartingTime);
        CalculateDuration(Duration, CurrQtyToAllocate, 1);
        IF CurrQtyToAllocate < 0 THEN
            ERROR(Text001);
        CLEAR(ServSchedMgt);
        ServSchedMgt.ProcessAllocation(ResourceNo, StartingDateTime, CurrQtyToAllocate, SourceType, SourceSubType, SourceID, ServiceLine,
                                       FALSE, 0, FALSE);

        ServLaborAllocEntry.RESET;
        ServLaborAllocEntry.SETCURRENTKEY("Resource No.");
        ServLaborAllocEntry.SETRANGE("Resource No.", ResourceNo);
        ServLaborAllocEntry.FINDLAST;
        ServLaborAllocEntry."Reason Code" := ReasonCode;
        ServLaborAllocEntry.MODIFY;

        SingleInstanceMgt.SetCurrAllocation(ServLaborAllocEntry."Entry No.");

        ServSchedMgt.CheckStartAndPlan(ServLaborAllocEntry."Entry No.");

        ServSchedMgt.ProcessStartLabor(StartingDateTime);
    end;
}

