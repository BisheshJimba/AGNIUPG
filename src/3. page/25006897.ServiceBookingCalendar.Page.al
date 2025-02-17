page 25006897 "Service Booking Calendar"
{
    Caption = 'Booking Calendar';
    PageType = StandardDialog;
    SourceTable = Table2000000007;

    layout
    {
        area(content)
        {
            usercontrol(Calendar; "EB.Calendar.Web")
            {

                trigger ControlAddInReady()
                var
                    AddInData: BigText;
                begin
                    //AddInReady := TRUE;
                    CalendarMgt.SetSelectedDate(SelectedDate);
                    CalendarMgt.SetLocationCode(LocationCode);
                    CalendarMgt.FillAddInData(AddInData);
                    CurrPage.Calendar.RecieveInitCalendarData(AddInData);
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
        IF SelectedDate = 0D THEN
            SelectedDate := WORKDATE;
    end;

    var
        CalendarMgt: Codeunit "25006874";
        LocationCode: Code[20];
        BookingMgt: Codeunit "25006875";
        AddInReady: Boolean;
        SelectedDate: Date;

    [Scope('Internal')]
    procedure "Calendar::RequestRefreshData"(Year: Integer; Month: Integer)
    var
        AddInData: BigText;
        DateFrom: Date;
        DateTo: Date;
    begin
        DateFrom := DMY2DATE(1, Month, Year);
        DateTo := CALCDATE('CM', DateFrom);
        CalendarMgt.SetLocationCode(LocationCode);
        CalendarMgt.SetSelectedDate(SelectedDate);
        CalendarMgt.SetCalendarPeriod(DateFrom, DateTo);
        CalendarMgt.FillAddInData(AddInData);
        CurrPage.Calendar.RecieveRefreshCalendarData(AddInData);
    end;

    [Scope('Internal')]
    procedure UpdateCalendar()
    var
        AddInData: BigText;
        DateFrom: Date;
        DateTo: Date;
    begin
        //IF NOT AddInReady THEN
        //  EXIT;


        CalendarMgt.SetLocationCode(LocationCode);
        CalendarMgt.SetCalendarPeriod(DateFrom, DateTo);
        CalendarMgt.FillAddInData(AddInData);
        CurrPage.Calendar.RecieveRefreshCalendarData(AddInData);
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
        Rec.SETRANGE(Rec."Period Type", Rec."Period Type"::Date);
        Rec.SETRANGE(Rec."Period Start", SelectedDate);
        CurrPage.UPDATE;
    end;

    [Scope('Internal')]
    procedure "Calendar::RequestSelectDate"(SelectedYear: Integer; SelectedMonth: Integer; SelectedDay: Integer)
    begin
        SelectedDate := DMY2DATE(SelectedDay, SelectedMonth, SelectedYear);
        Rec.SETRANGE(Rec."Period Type", Rec."Period Type"::Date);
        Rec.SETRANGE(Rec."Period Start", SelectedDate);
        CurrPage.UPDATE;
    end;

    [Scope('Internal')]
    procedure GetSelectedDate(): Date
    begin
        EXIT(SelectedDate);
    end;
}

