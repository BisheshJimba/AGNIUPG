page 25006358 "Service Schedule"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified OnOpenPage(), Usert Profile Setup to Branch Profile Setup
    // 
    // 06.01.2015 EB.P7 EB.Schedule.Web
    //   * Removed Classic Schedule Add-in
    // 
    // 20.08.2013 EDMS P7
    //   * Added second Add-in - EB.Schedule.Web
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009

    Caption = 'Service Schedule';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = Table25006145;

    layout
    {
        area(content)
        {
            group(View)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                Visible = true;
                field(ScheduleViewCode; ScheduleViewCode)
                {
                    Caption = 'View Code';
                    Importance = Promoted;
                    TableRelation = "Schedule View";
                    Visible = true;

                    trigger OnValidate()
                    begin
                        ValidateViewCode;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(ScheduleResourceGrp; ScheduleResourceGrp)
                {
                    Caption = 'Resource Group';
                    Importance = Promoted;
                    TableRelation = "Schedule Resource Group";
                    Visible = ShowFieldResourceGroup;

                    trigger OnValidate()
                    begin
                        //ServScheduleWebAddInMgt.SetParameters(DecStartDT,DecEndDT,ScheduleResourceGrp, ScheduleViewCode);

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(PeriodType; PeriodType)
                {
                    Caption = 'Period Type';
                    Importance = Promoted;
                    Visible = ShowFieldPeriodType;

                    trigger OnValidate()
                    begin
                        ValidatePeriodType;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(StartDate; StartDate)
                {
                    Caption = 'Start Date';
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        ValidatePeriodStart;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(EndDate; EndDate)
                {
                    Caption = 'End Date';
                    Visible = ShowFieldEndDate;

                    trigger OnValidate()
                    begin
                        ValidatePeriodEnd;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(StartTime; StartTime)
                {
                    Caption = 'Start Time';
                    Visible = ShowFieldStartTime;

                    trigger OnValidate()
                    begin
                        ValidatePeriodStart;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
                field(EndTime; EndTime)
                {
                    Caption = 'End Time';
                    Visible = ShowFieldEndTime;

                    trigger OnValidate()
                    begin
                        ValidatePeriodEnd;

                        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                    end;
                }
            }
            usercontrol(ScheduleWeb; "EB.Schedule.Web")
            {

                trigger ControlAddInReady()
                var
                    DecStartDT: Decimal;
                    DecEndDT: Decimal;
                    Index: Integer;
                    Data: BigText;
                begin
                    //ScheduleViewCode := 'DEFAULT';
                    //ScheduleResourceGrp := 'ALL MECH';
                    DecStartDT := DateTimeMgt.Datetime(StartDate, StartTime);
                    DecEndDT := DateTimeMgt.Datetime(EndDate, EndTime);
                    DecEndDT -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond

                    ServScheduleWebAddInMgt.SetParameters(DecStartDT, DecEndDT, ScheduleResourceGrp, ScheduleViewCode);

                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                    CurrPage.ScheduleWeb.RecieveInitScheduleData(ScheduleData);
                end;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("<Action1101931000>")
            {
                Caption = 'Resource Calendar Changes';
                Image = Resource;
                RunObject = Page 25006371;
            }
            action("Allocation Entries")
            {
                Caption = 'Allocation Entries';
                Image = CalendarMachine;

                trigger OnAction()
                var
                    AllocEntry: Record "25006271";
                    DatetimeMgt: Codeunit "25006012";
                    ResourceNoFilter: Code[1000];
                    ResourceGrpSec: Record "25006275";
                begin
                    ResourceNoFilter := '';
                    ResourceGrpSec.RESET;
                    ResourceGrpSec.SETRANGE("Group Code", ScheduleResourceGrp);
                    IF NOT ResourceGrpSec.FINDFIRST THEN
                        EXIT;
                    REPEAT
                        IF ResourceNoFilter <> '' THEN
                            ResourceNoFilter += '|';
                        ResourceNoFilter += ResourceGrpSec."Resource No.";
                    UNTIL ResourceGrpSec.NEXT = 0;

                    AllocEntry.RESET;
                    AllocEntry.SETCURRENTKEY("Resource No.", "Start Date-Time", "End Date-Time");
                    AllocEntry.SETFILTER("Resource No.", ResourceNoFilter);
                    AllocEntry.SETFILTER("Start Date-Time", '<=%1', DatetimeMgt.Datetime(EndDate, EndTime));
                    AllocEntry.SETFILTER("End Date-Time", '>%1', DatetimeMgt.Datetime(StartDate, StartTime));
                    IF PAGE.RUNMODAL(PAGE::"Serv. Labor Allocation Entries", AllocEntry) = ACTION::LookupOK THEN;
                end;
            }
        }
        area(processing)
        {
            action("<Action12>")
            {
                Caption = 'Previous Period';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Previous Set';

                trigger OnAction()
                begin
                    PrevPeriod
                end;
            }
            action("<Action112>")
            {
                Caption = 'Next Period';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Next Set';

                trigger OnAction()
                begin
                    NextPeriod
                end;
            }
            action(Day)
            {
                Caption = 'Day';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PeriodType := PeriodType::Day;
                    ValidatePeriodType;

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101914010>")
            {
                Caption = 'Week';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PeriodType := PeriodType::Week;
                    ValidatePeriodType;

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101904011>")
            {
                Caption = 'Month';
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    PeriodType := PeriodType::Month;
                    ValidatePeriodType;

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101924010>")
            {
                Caption = 'Custom';
                Enabled = false;
                Image = WorkCenterCalendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    PeriodType := PeriodType::Custom;
                    ValidatePeriodType;

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101904012>")
            {
                Caption = 'Refresh Data';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ServScheduleWebAddInMgt.Refresh(ScheduleData);

                    SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
                    ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
                    CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
                end;
            }
            action("<Action1101901000>")
            {
                Caption = 'Search';
                Image = Find;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ServScheduleWebAddInMgt.Search(ScheduleData);
                end;
            }
        }
    }

    trigger OnInit()
    var
        ServiceHeader: Record "25006145";
    begin
    end;

    trigger OnOpenPage()
    begin
        ScheduleViewCode := '';
        SetServiceHeader(Rec);

        //IF NOT DocumentMgtDMS.IsWebClientSession THEN BEGIN
        ShowFieldPeriodType := TRUE;
        ShowFieldResourceGroup := TRUE;
        ShowFieldEndDate := TRUE;
        ShowFieldStartTime := TRUE;
        ShowFieldEndTime := TRUE;
        //END;
        //MESSAGE(FORMAT(ActiveSession.COUNT) + ' ' + FORMAT(ActiveSession."Client Type"));

        ServiceScheduleMgt.CheckUserRightsInit;
        ServiceScheduleMgt.CheckUserRights(0);

        ServiceScheduleSetup.GET;

        IF (ScheduleViewCode = '') THEN BEGIN
            IF ServiceScheduleSetup."Def. View Code" <> '' THEN
                ScheduleViewCode := ServiceScheduleSetup."Def. View Code";
            IF UserProfile.GET(UserProfileMgt.CurrProfileID) AND (UserProfile."Service Schedule View Code" <> '') THEN
                ScheduleViewCode := UserProfile."Service Schedule View Code";
        END;

        ValidateViewCode;

        IF AllocationIsSet THEN BEGIN
            ScheduleResourceGrp := GetResourceGroup(ScheduleResourceGrp, SetResourceNo);
            StartDate := SetStartDate;
            IF StartTime > SetStartTime THEN
                StartTime := SetStartTime;
            ValidatePeriodStart;
        END;

        //ServScheduleAddInMgt.Refresh(_xml);
    end;

    var
        "0": BigText;
        PeriodType: Option Custom,Day,Week,Month;
        StartDate: Date;
        EndDate: Date;
        StartTime: Time;
        EndTime: Time;
        ScheduleViewCode: Code[20];
        ServiceScheduleMgt: Codeunit "25006201";
        ServiceScheduleSetup: Record "25006286";
        UserProfile: Record "25006067";
        ScheduleResourceGrp: Code[20];
        SetStartDate: Date;
        SetStartTime: Time;
        SetResourceNo: Code[20];
        AllocationIsSet: Boolean;
        DateTimeMgt: Codeunit "25006012";
        SingleInstanceMgt: Codeunit "25006001";
        UserProfileMgt: Codeunit "25006002";
        "-----------": Boolean;
        DocumentMgtDMS: Codeunit "25006000";
        ServScheduleMgt: Codeunit "25006201";
        ServScheduleWebAddInMgt: Codeunit "25006203";
        UseScheduleWebAddIn: Boolean;
        UseScheduleClassicAddIn: Boolean;
        ShowFieldPeriodType: Boolean;
        ShowFieldResourceGroup: Boolean;
        ShowFieldEndDate: Boolean;
        ShowFieldStartTime: Boolean;
        ShowFieldEndTime: Boolean;
        ScheduleData: BigText;

    [Scope('Internal')]
    procedure ValidatePeriodStart()
    var
        DT: DateTime;
    begin
        DT := CalcPeriodStart(PeriodType, CREATEDATETIME(StartDate, StartTime));
        StartDate := DT2DATE(DT);
        StartTime := DT2TIME(DT);

        DT := CalcPeriodEnd(PeriodType, CREATEDATETIME(StartDate, StartTime));
        EndDate := DT2DATE(DT);
        EndTime := DT2TIME(DT);

        CLEAR(ScheduleData);
        ScheduleData.ADDTEXT(STRSUBSTNO('Command:1010,Header From Date,%1', CREATEDATETIME(StartDate, StartTime)), 1);
        CurrPage.UPDATE(TRUE);
    end;

    [Scope('Internal')]
    procedure ValidatePeriodEnd()
    var
        DT: DateTime;
    begin
        DT := CalcPeriodEnd(PeriodType, CREATEDATETIME(EndDate, EndTime));
        EndDate := DT2DATE(DT);
        EndTime := DT2TIME(DT);

        DT := CalcPeriodStart(PeriodType, CREATEDATETIME(EndDate, EndTime));
        StartDate := DT2DATE(DT);
        StartTime := DT2TIME(DT);

        CLEAR(ScheduleData);
        ScheduleData.ADDTEXT(STRSUBSTNO('Command:1010,Header To Date,%1', CREATEDATETIME(EndDate, EndTime), 1));
        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure ValidatePeriodType()
    begin
        ValidatePeriodStart;
    end;

    [Scope('Internal')]
    procedure CalcPeriodEnd(PeriodType: Option Custom,Day,Week,Month; StartDT: DateTime): DateTime
    var
        Date1: Record "2000000007";
    begin
        CASE PeriodType OF
            PeriodType::Custom:
                BEGIN
                    EXIT(CREATEDATETIME(EndDate, EndTime));
                END;
            PeriodType::Day:
                BEGIN
                    EXIT(CREATEDATETIME(DT2DATE(StartDT), EndTime));
                END;
            PeriodType::Week:
                BEGIN
                    EXIT(CREATEDATETIME(CALCDATE('<CW>', DT2DATE(StartDT)), EndTime));
                END;
            PeriodType::Month:
                BEGIN
                    EXIT(CREATEDATETIME(CALCDATE('<CM>', DT2DATE(StartDT)), EndTime));
                END;
        END;
    end;

    [Scope('Internal')]
    procedure CalcPeriodStart(PeriodType: Option Custom,Day,Week,Month; EndDT: DateTime): DateTime
    var
        Date1: Record "2000000007";
    begin
        CASE PeriodType OF
            PeriodType::Custom:
                BEGIN
                    EXIT(CREATEDATETIME(StartDate, StartTime));
                END;
            PeriodType::Day:
                BEGIN
                    EXIT(CREATEDATETIME(DT2DATE(EndDT), StartTime));
                END;
            PeriodType::Week:
                BEGIN
                    EXIT(CREATEDATETIME(CALCDATE('<-1W>', CALCDATE('<CW>', DT2DATE(EndDT)) + 1), StartTime));
                END;
            PeriodType::Month:
                BEGIN
                    EXIT(CREATEDATETIME(CALCDATE('<-1M>', CALCDATE('<CM>', DT2DATE(EndDT)) + 1), StartTime));
                END;
        END;
    end;

    [Scope('Internal')]
    procedure NextPeriod()
    var
        Date1: Date;
        DayCount: Integer;
    begin
        CASE PeriodType OF
            PeriodType::Custom:
                BEGIN
                    DayCount := EndDate - StartDate + 1;
                    EndDate := EndDate + DayCount;
                    StartDate := StartDate + DayCount;
                END
            ELSE
                EndDate := EndDate + 1;
        END;
        ValidatePeriodEnd;

        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    [Scope('Internal')]
    procedure PrevPeriod()
    var
        Date1: Date;
        DayCount: Integer;
    begin
        CASE PeriodType OF
            PeriodType::Custom:
                BEGIN
                    DayCount := EndDate - StartDate + 1;
                    EndDate := EndDate - DayCount;
                    StartDate := StartDate - DayCount;
                END
            ELSE
                StartDate := StartDate - 1;
        END;

        ValidatePeriodStart;

        SetParams(StartDate, StartTime, EndDate, EndTime, ScheduleResourceGrp, ScheduleViewCode);
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    [Scope('Internal')]
    procedure SetPeriodStart(SDate: Date; STime: Time)
    begin
        StartDate := SDate;
        StartTime := STime;
    end;

    [Scope('Internal')]
    procedure SetPeriodEnd(EDate: Date; ETime: Time)
    begin
        EndDate := EDate;
        EndTime := ETime;
    end;

    [Scope('Internal')]
    procedure ValidateViewCode()
    var
        ScheduleView: Record "25006282";
    begin
        IF ScheduleViewCode = '' THEN
            EXIT;

        ScheduleView.GET(ScheduleViewCode);
        PeriodType := ScheduleView."Period Type";
        StartDate := CALCDATE(ScheduleView."Start Date Formula", WORKDATE);
        StartTime := ScheduleView."Start Time";
        EndTime := ScheduleView."End Time";
        ValidatePeriodType;

        ScheduleResourceGrp := ScheduleView."Resource Group";
        //MESSAGE('ScheduleResourceGrp='+ScheduleResourceGrp);
    end;

    [Scope('Internal')]
    procedure SetAllocation(var AllocationEntry: Record "25006271")
    begin
        SetStartDate := DateTimeMgt.Datetime2Date("Start Date-Time");
        SetStartTime := DateTimeMgt.Datetime2Time("Start Date-Time");
        SetResourceNo := "Resource No.";
        AllocationIsSet := TRUE;
    end;

    [Scope('Internal')]
    procedure GetResourceGroup(CurrGroupCode: Code[20]; ResourceNo: Code[20]): Code[20]
    var
        ScheduleResourceGroupSpec: Record "25006275";
    begin
        ScheduleResourceGroupSpec.RESET;
        ScheduleResourceGroupSpec.SETRANGE("Group Code", CurrGroupCode);
        ScheduleResourceGroupSpec.SETRANGE("Resource No.", ResourceNo);
        IF ScheduleResourceGroupSpec.FINDFIRST THEN
            EXIT(CurrGroupCode);

        ScheduleResourceGroupSpec.RESET;
        ScheduleResourceGroupSpec.SETRANGE("Resource No.", ResourceNo);
        ScheduleResourceGroupSpec.FINDFIRST;
        EXIT(ScheduleResourceGroupSpec."Group Code");
    end;

    [Scope('Internal')]
    procedure SetServiceHeader(var ServiceHeader: Record "25006145")
    var
        AllocationEntry: Record "25006271";
    begin
        AllocationEntry.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID", "Start Date-Time");
        AllocationEntry.SETRANGE("Source Type", AllocationEntry."Source Type"::"Service Document");
        AllocationEntry.SETRANGE("Source Subtype", ServiceHeader."Document Type");
        AllocationEntry.SETRANGE("Source ID", ServiceHeader."No.");
        IF AllocationEntry.FINDFIRST THEN
            SetAllocation(AllocationEntry);
        SingleInstanceMgt.SetServiceHeader(ServiceHeader);
    end;

    [Scope('Internal')]
    procedure SetParams(FormStartDate: Date; FormStartTime: Time; FormEndDate: Date; FormEndTime: Time; FormScheduleResourceGroup: Code[20]; FormScheduleViewCode: Code[20])
    var
        DecStartDT: Decimal;
        DecEndDT: Decimal;
    begin
        DecStartDT := DateTimeMgt.Datetime(FormStartDate, FormStartTime);
        DecEndDT := DateTimeMgt.Datetime(FormEndDate, FormEndTime);
        DecEndDT -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond
        ServScheduleWebAddInMgt.SetParameters(DecStartDT, DecEndDT, FormScheduleResourceGroup, FormScheduleViewCode);
    end;

    [Scope('Internal')]
    procedure "ScheduleWeb::RequestScheduleData"()
    var
        DecStartDT: Decimal;
        DecEndDT: Decimal;
        Index: Integer;
        Data: BigText;
    begin
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    [Scope('Internal')]
    procedure "ScheduleWeb::ProcessAllocation"(EventType: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    var
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        Text001: Label 'Standard Event,Service Line,Service Header';
        Diag: Dialog;
        Text002: Label 'Select allocation type';
    begin
        ServScheduleWebAddInMgt.ProcessAllocation(EventType, NewResNo, NewStartDT, NewEndDT);
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    [Scope('Internal')]
    procedure "ScheduleWeb::ProcessReallocation"(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    var
        LaborAllocEntry: Record "25006271";
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        CurrItemID: Code[100];
        CurrResGroupCode: Code[20];
    begin
        ServScheduleWebAddInMgt.ProcessReallocation(EntryNo, NewResNo, NewStartDT, NewEndDT);
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    [Scope('Internal')]
    procedure "ScheduleWeb::ProcessAllocationEdit"(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    begin
        //Not used
        ServScheduleWebAddInMgt.ProcessAllocationEdit(EntryNo, NewResNo, NewStartDT, NewEndDT);
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;

    [Scope('Internal')]
    procedure "ScheduleWeb::ProcessCommands"(Index: Integer; EntryNo: Integer; ResNo: Code[20]; CommStartDT: Decimal; CommEndDT: Decimal)
    var
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        Text001: Label 'Standard Event,Service Line,Service Header';
        Diag: Dialog;
        Text002: Label 'Select allocation type';
    begin
        ServScheduleWebAddInMgt.ProcessCommands(Index, EntryNo, ResNo, CommStartDT, CommEndDT);
        ServScheduleWebAddInMgt.FillTextData(ScheduleData, 0, '', FALSE);
        CurrPage.ScheduleWeb.RecieveRefreshScheduleData(ScheduleData);
    end;
}

