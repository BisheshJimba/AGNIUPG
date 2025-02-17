page 25006564 "Service Target Settings"
{
    Caption = 'Service Target Settings';

    layout
    {
        area(content)
        {
            group(Period)
            {
                Caption = 'Period';
                field(StartDate; StartDate)
                {
                    Caption = 'Starting Date';
                }
                field(EndDate; EndDate)
                {
                    Caption = 'Ending Date';

                    trigger OnValidate()
                    begin
                        IF StartDate > EndDate THEN
                            ERROR(Text004);
                    end;
                }
            }
            group(General)
            {
                Caption = 'General';
                field(LocationCode; LocationCode)
                {
                    Caption = 'Location';
                    TableRelation = Location;
                }
                field(ServicePersonCode; ServicePersonCode)
                {
                    Caption = 'Service Advisor';
                    TableRelation = Salesperson/Purchaser;
                }
                field(ResourceCode;ResourceCode)
                {
                    Caption = 'Resource';
                    TableRelation = Resource;
                }
                field(ServicePrice;ServiceRate)
                {
                    Caption = 'Service Rate';

                    trigger OnValidate()
                    begin
                        SumWeekTotal;
                    end;
                }
            }
            group(Week)
            {
                Caption = 'Week';
                field(Monday;Monday)
                {
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Monday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        MondayOnAfterV;
                    end;
                }
                field(Tuesday;Tuesday)
                {
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Tuesday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        TuesdayOnAfterV;
                    end;
                }
                field(Wednesday;Wednesday)
                {
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Wednesday (Hours)';

                    trigger OnValidate()
                    begin
                        WednesdayOnAfterV;
                    end;
                }
                field(Thursday;Thursday)
                {
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Thursday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        ThursdayOnAfterV;
                    end;
                }
                field(Friday;Friday)
                {
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Friday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        FridayOnAfterV;
                    end;
                }
                field(Saturday;Saturday)
                {
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Saturday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        SaturdayOnAfterV;
                    end;
                }
                field(Sunday;Sunday)
                {
                    AutoFormatExpression = '<precision,0:5><standard format,0>';
                    AutoFormatType = 10;
                    Caption = 'Sunday (Hours)';
                    MaxValue = 24;
                    MinValue = 0;

                    trigger OnValidate()
                    begin
                        SundayOnAfterV;
                    end;
                }
                field(WeekTotalAmount;WeekTotalAmount)
                {
                    Caption = 'Week Total Amount';
                    DecimalPlaces = 0:2;
                    Editable = false;
                }
                field(WeekTotalQuantity;WeekTotalQuantity)
                {
                    Caption = 'Week Total Hours';
                    DecimalPlaces = 0:2;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(FillTargetPeriod)
            {
                Caption = 'Fill Target Period';
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF StartDate = 0D THEN
                      ERROR(Text002);
                    IF EndDate = 0D THEN
                      ERROR(Text003);
                    IF StartDate > EndDate THEN
                      ERROR(Text004);

                    ServiceTarget.RESET;
                    ServiceTarget.SETFILTER(Date, '%1..%2', StartDate, EndDate);
                    IF LocationCode = '' THEN
                      ServiceTarget.SETFILTER(Location, '=%1','')
                    ELSE
                      ServiceTarget.SETFILTER(Location, LocationCode);

                    IF ServicePersonCode = '' THEN
                      ServiceTarget.SETFILTER("Service Advisor", '=%1','')
                    ELSE
                      ServiceTarget.SETFILTER("Service Advisor", ServicePersonCode);

                    IF ResourceCode = '' THEN
                      ServiceTarget.SETFILTER(Resource, '=%1','')
                    ELSE
                      ServiceTarget.SETFILTER(Resource, ResourceCode);

                    ServiceTarget.DELETEALL;

                    ServiceTarget.RESET;
                    i := 0;
                    Date := StartDate;
                    WHILE Date <= EndDate DO BEGIN
                      CASE DATE2DWY(Date,1) OF
                        1:
                          NewTargetEntry(Date,Monday);
                        2:
                          NewTargetEntry(Date,Tuesday);
                        3:
                          NewTargetEntry(Date,Wednesday);
                        4:
                          NewTargetEntry(Date,Thursday);
                        5:
                          NewTargetEntry(Date,Friday);
                        6:
                          NewTargetEntry(Date,Saturday);
                        7:
                          NewTargetEntry(Date,Sunday);
                      END;
                      i += 1;
                      Date := StartDate + i;
                    END;
                    MESSAGE(Text001);
                end;
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        WeekTotalQuantity: Decimal;
        WeekTotalAmount: Decimal;
        Monday: Decimal;
        Tuesday: Decimal;
        Wednesday: Decimal;
        Thursday: Decimal;
        Friday: Decimal;
        Saturday: Decimal;
        Sunday: Decimal;
        Text001: Label 'Target Period Filled!';
        Text002: Label 'Start Date not specified';
        Text003: Label 'End Date not specified';
        Text004: Label 'The starting date is later than the ending date.';
        ServiceRate: Decimal;
        LocationCode: Code[10];
        ResourceCode: Code[10];
        ServicePersonCode: Code[10];
        ServiceTarget: Record "25006198";
        Date: Date;
        i: Integer;

    local procedure SumWeekTotal()
    begin
        WeekTotalQuantity := Monday + Tuesday + Wednesday +
          Thursday + Friday + Saturday + Sunday;
        WeekTotalAmount := WeekTotalQuantity * ServiceRate;
    end;

    local procedure MondayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure TuesdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure WednesdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure ThursdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure FridayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure SaturdayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure SundayOnAfterV()
    begin
        SumWeekTotal;
    end;

    local procedure NewTargetEntry(DatePar: Date;Quantity: Decimal)
    var
        NewServiceTarget: Record "25006198";
    begin
        IF Quantity <= 0 THEN
          EXIT;
        ServiceTarget.INIT;
        ServiceTarget.Date := Date;
        ServiceTarget.Location := LocationCode;
        ServiceTarget.Resource := ResourceCode;
        ServiceTarget."Service Advisor" := ServicePersonCode;
        ServiceTarget.Amount := ServiceRate * Quantity;
        ServiceTarget.Quantity := Quantity;
        ServiceTarget.INSERT;
    end;
}

