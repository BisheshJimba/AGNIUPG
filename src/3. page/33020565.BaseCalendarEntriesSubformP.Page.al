page 33020565 "Base Calendar Entries SubformP"
{
    Caption = 'Lines';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Table2000000007;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(CurrentCalendarCode; CurrentCalendarCode)
                {
                    Caption = 'Base Calendar Code';
                    Editable = false;
                    Visible = false;
                }
                field("Period Start"; "Period Start")
                {
                    Caption = 'Date';
                    Editable = false;
                }
                field("Period Name"; "Period Name")
                {
                    Caption = 'Day';
                    Editable = false;
                }
                field(WeekNo; WeekNo)
                {
                    Caption = 'Week No.';
                    Editable = false;
                    Visible = false;
                }
                field(Nonworking; Nonworking)
                {
                    Caption = 'Nonworking';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        UpdateBaseCalendarChanges;
                    end;
                }
                field(Description; Description)
                {
                    Caption = 'Description';

                    trigger OnValidate()
                    begin
                        UpdateBaseCalendarChanges;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Nonworking := CalendarMgmt.CheckDateStatus(CurrentCalendarCode, "Period Start", Description);
        WeekNo := DATE2DWY("Period Start", 2);
        CurrentCalendarCodeOnFormat;
        PeriodStartOnFormat;
        PeriodNameOnFormat;
        DescriptionOnFormat;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        EXIT(PeriodFormMgt.FindDate(Which, Rec, ItemPeriodLength));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        EXIT(PeriodFormMgt.NextDate(Steps, Rec, ItemPeriodLength));
    end;

    trigger OnOpenPage()
    begin
        RESET;
        SETFILTER("Period Start", '>=%1', 01010000D);
    end;

    var
        Item: Record "27";
        PeriodFormMgt: Codeunit "359";
        ItemPeriodLength: Option Day,Week,Month,Quarter,Year,Period;
        Nonworking: Boolean;
        Description: Text[50];
        CurrentCalendarCode: Code[10];
        CalendarMgmt: Codeunit "33020504";
        BaseCalendarChange: Record "33020561";
        WeekNo: Integer;

    [Scope('Internal')]
    procedure SetCalendarCode(CalendarCode: Code[10])
    begin
        CurrentCalendarCode := CalendarCode;
        CurrPage.UPDATE;
    end;

    [Scope('Internal')]
    procedure UpdateBaseCalendarChanges()
    begin
        BaseCalendarChange.RESET;
        BaseCalendarChange.SETRANGE("Base Calendar Code", CurrentCalendarCode);
        BaseCalendarChange.SETRANGE(Date, "Period Start");
        IF BaseCalendarChange.FIND('-') THEN
            BaseCalendarChange.DELETE;
        BaseCalendarChange.INIT;
        BaseCalendarChange."Base Calendar Code" := CurrentCalendarCode;
        BaseCalendarChange.Date := "Period Start";
        BaseCalendarChange.Description := Description;
        BaseCalendarChange.Nonworking := Nonworking;
        BaseCalendarChange.Day := "Period No.";
        BaseCalendarChange.INSERT;
    end;

    [Scope('Internal')]
    procedure ShowMonthlyCalendar()
    begin
        //GraphicCalendar.SetCalendarCode(1,0,'','',CurrentCalendarCode,"Period Start");
        //GraphicCalendar.RUN;
    end;

    local procedure CurrentCalendarCodeOnFormat()
    begin
        IF Nonworking THEN;
    end;

    local procedure PeriodStartOnFormat()
    begin
        IF Nonworking THEN;
    end;

    local procedure PeriodNameOnFormat()
    begin
        IF Nonworking THEN;
    end;

    local procedure DescriptionOnFormat()
    begin
        IF Nonworking THEN;
    end;
}

