codeunit 25006290 "Resource Time Reg. Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        UserResourceSetupErr: Label 'There is no Resource No. configured in User Setup.';
        TimeRegisterInProgressMsg: Label 'Task status set to "In Progress"';
        TimeRegisterOnHoldMsg: Label 'Task status set to "On Hold"';
        TimeRegisterFinishedMsg: Label 'Task status set to "Finised"';
        TimeRegisterPendingMsg: Label 'Task status set to "Pending"';
        CurrentUserId: Code[50];
        DateTimeMgt: Codeunit "25006012";
        UserSetup: Record "91";
        TimeRegisterCancStartMsg: Label 'Task status "In Progress" cancelled';
        SingleInstanceManagment: Codeunit "25006001";
        ServiceScheduleMgt: Codeunit "25006201";
        ServiceScheduleSetup: Record "25006286";
        TimeModifiedLastEntryMsg: Label 'New time succesfully set.';
        TimeModifyNotLastEntryMsg: Label 'Time can be modified only for last record.';
        ValidateActionStartErr: Label 'You can''t start task, that is already started.';
        ValidateActionPostedDocErr: Label 'Can''t process action. Document already posted.';
        ValidateResourceWorktimeErr: Label 'Resource %1 have to start work time first.';
        TimeRegisterWorkingTxt: Label 'Working';
        TimeRegisterNotWorkingTxt: Label 'Not Working';

    [Scope('Internal')]
    procedure GetCurrentUserResourceNo(): Code[20]
    begin
        IF UserSetup.GET(SingleInstanceManagment.GetCurrentUserId) THEN
            EXIT(UserSetup."Resource No.")
        ELSE
            ERROR(UserResourceSetupErr);
    end;

    [Scope('Internal')]
    procedure GetResourceNoByUserId(UserID: Code[50]): Code[20]
    var
        UserSetup: Record "91";
    begin
        IF UserSetup.GET(UserID) THEN
            EXIT(UserSetup."Resource No.")
        ELSE
            ERROR(UserResourceSetupErr);
    end;

    [Scope('Internal')]
    procedure AddTimeRegEntries("Action": Code[20]; ServLaborAllocationEntry: Record "25006271"; CurrentResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "25006290";
        Period: Record "2000000007";
        PeriodTime: Time;
        NextPeriodDate: Date;
    begin
        //Add previous entries if needed>>
        IF (Action = 'ONHOLD') OR (Action = 'STOP') OR (Action = 'COMPLETE') THEN BEGIN
            ResourceTimeRegEntry.RESET;
            ResourceTimeRegEntry.SETRANGE("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
            ResourceTimeRegEntry.SETRANGE("Resource No.", CurrentResourceNo);
            ResourceTimeRegEntry.SETRANGE("Worktime Entry", FALSE);
            ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);

            IF ResourceTimeRegEntry.FINDLAST AND (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."Entry Type"::"In Progress") THEN BEGIN
                Period.RESET;
                Period.SETRANGE(Period."Period Type", Period."Period Type"::Date);
                Period.SETRANGE(Period."Period Start", ResourceTimeRegEntry.Date, OnDate);
                IF Period.FINDFIRST THEN
                    REPEAT
                        IF Period."Period Start" <> OnDate THEN BEGIN
                            PeriodTime := 235959T;
                            AddTimeRegEntry('OnHold', ServLaborAllocationEntry, CurrentResourceNo, Period."Period Start", PeriodTime);
                            NextPeriodDate := Period."Period Start" + 1;
                            PeriodTime := 000000T;
                            AddTimeRegEntry('Start', ServLaborAllocationEntry, CurrentResourceNo, NextPeriodDate, PeriodTime);
                        END;
                    UNTIL Period.NEXT = 0;
            END;
        END;
        //Add previous entries if needed<<
        AddTimeRegEntry(Action, ServLaborAllocationEntry, CurrentResourceNo, OnDate, OnTime);
    end;

    [Scope('Internal')]
    procedure AddTimeRegEntry("Action": Code[20]; ServLaborAllocationEntry: Record "25006271"; CurrentResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "25006290";
        EntryNo: Integer;
        PresentTime: DateTime;
        ActualWorkSpentTime: Decimal;
        ServLaborAllocApplication: Record "25006277";
        FirstEntryDate: Date;
        IsIdle: Boolean;
        ServiceSetup: Record "25006120";
        IsTravel: Boolean;
    begin
        ResourceTimeRegEntry.RESET;
        IF ResourceTimeRegEntry.FINDLAST THEN
            EntryNo := ResourceTimeRegEntry."Entry No." + 1
        ELSE
            EntryNo := 1;

        //Get First Entry Date
        ResourceTimeRegEntry.RESET;
        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        ResourceTimeRegEntry.SETRANGE("Resource No.", CurrentResourceNo);
        ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);
        IF ResourceTimeRegEntry.FINDFIRST THEN
            FirstEntryDate := ResourceTimeRegEntry.Date
        ELSE
            FirstEntryDate := OnDate;

        //Calculate actual work spent time
        ResourceTimeRegEntry.RESET;
        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        ResourceTimeRegEntry.SETRANGE("Resource No.", CurrentResourceNo);
        ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);
        PresentTime := CREATEDATETIME(OnDate, OnTime);
        IF ResourceTimeRegEntry.FINDLAST AND (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."Entry Type"::"In Progress") THEN BEGIN
            ActualWorkSpentTime := ROUND((PresentTime - CREATEDATETIME(ResourceTimeRegEntry.Date, ResourceTimeRegEntry.Time)) / 3600000, 0.0001);
        END;

        //Check if Allocation is Idle
        ServiceSetup.GET;
        IsIdle := ServLaborAllocationEntry."Source ID" = ServiceSetup."Default Idle Event";
        IsTravel := ServLaborAllocationEntry.Travel;
        //Calculate Actual Work Percentage
        //PlanedWorkTime := ServLaborAllocationEntry."End Date-Time" - ServLaborAllocationEntry."Start Date-Time";
        //ActualWorkPercentage := ROUND(ActualWorkTime/PlanedWorkTime,0.01)*100;
        CASE Action OF
            'START':
                BEGIN
                    ResourceTimeRegEntry.INIT;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Allocation Entry No." := ServLaborAllocationEntry."Entry No.";
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."Entry Type"::"In Progress";
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Idle := IsIdle;
                    ResourceTimeRegEntry.Travel := IsTravel;
                    ResourceTimeRegEntry."Source Type" := ServLaborAllocationEntry."Source Type";
                    ResourceTimeRegEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
                    ResourceTimeRegEntry."Source ID" := ServLaborAllocationEntry."Source ID";
                    ResourceTimeRegEntry.INSERT;
                END;
            'ONHOLD':
                BEGIN
                    ResourceTimeRegEntry.INIT;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Allocation Entry No." := ServLaborAllocationEntry."Entry No.";
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."Entry Type"::"On Hold";
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Idle := IsIdle;
                    ResourceTimeRegEntry.Travel := IsTravel;
                    ResourceTimeRegEntry."Source Type" := ServLaborAllocationEntry."Source Type";
                    ResourceTimeRegEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
                    ResourceTimeRegEntry."Source ID" := ServLaborAllocationEntry."Source ID";
                    ResourceTimeRegEntry.INSERT;
                END;
            'STOP':
                BEGIN
                    ResourceTimeRegEntry.INIT;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Allocation Entry No." := ServLaborAllocationEntry."Entry No.";
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."Entry Type"::Pending;
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Idle := IsIdle;
                    ResourceTimeRegEntry.Travel := IsTravel;
                    ResourceTimeRegEntry."Source Type" := ServLaborAllocationEntry."Source Type";
                    ResourceTimeRegEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
                    ResourceTimeRegEntry."Source ID" := ServLaborAllocationEntry."Source ID";
                    ResourceTimeRegEntry.INSERT;
                END;
            'COMPLETE':
                BEGIN
                    ResourceTimeRegEntry.INIT;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Allocation Entry No." := ServLaborAllocationEntry."Entry No.";
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."Entry Type"::Finished;
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.Idle := IsIdle;
                    ResourceTimeRegEntry.Travel := IsTravel;
                    ResourceTimeRegEntry."Source Type" := ServLaborAllocationEntry."Source Type";
                    ResourceTimeRegEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
                    ResourceTimeRegEntry."Source ID" := ServLaborAllocationEntry."Source ID";
                    ResourceTimeRegEntry.INSERT;

                    //MESSAGE(TimeRegisterFinishedMsg);
                END;
            'CANCELSTART':
                BEGIN
                    IF ServLaborAllocationEntry.Status = ServLaborAllocationEntry.Status::"In Progress" THEN BEGIN
                        ResourceTimeRegEntry.RESET;
                        ResourceTimeRegEntry.SETRANGE("Resource No.", CurrentResourceNo);
                        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
                        IF ResourceTimeRegEntry.FINDLAST AND (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."Entry Type"::"In Progress") THEN BEGIN
                            ResourceTimeRegEntry.Canceled := TRUE;
                            ResourceTimeRegEntry.MODIFY;
                            //MESSAGE(TimeRegisterCancStartMsg);
                        END;
                    END;
                END;
        END;


        ServLaborAllocationEntry.CALCFIELDS("Total Time Spent");
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        IF ServLaborAllocApplication.FINDFIRST THEN
            REPEAT
                ServLaborAllocApplication.VALIDATE("Finished Quantity (Hours)", ServLaborAllocationEntry."Total Time Spent");
                ServLaborAllocApplication.VALIDATE("Remaining Quantity (Hours)", ServLaborAllocationEntry."Quantity (Hours)" - ServLaborAllocationEntry."Total Time Spent");
                ServLaborAllocApplication.MODIFY;
            UNTIL ServLaborAllocApplication.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure AddWorkTimeRegEntries("Action": Code[20]; CurrentResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "25006290";
        EntryNo: Integer;
        PresentTime: DateTime;
        ActualWorkSpentTime: Decimal;
        ServLaborAllocApplication: Record "25006277";
        Period: Record "2000000007";
        PeriodTime: Time;
        NextPeriodDate: Date;
    begin
        //Add previous entries if needed>>
        IF (Action = 'FINISHWORKTIME') THEN BEGIN
            ResourceTimeRegEntry.RESET;
            //ResourceTimeRegEntry.SETRANGE("Allocation Entry No.",ServLaborAllocationEntry."Entry No.");
            ResourceTimeRegEntry.SETRANGE("Resource No.", CurrentResourceNo);
            ResourceTimeRegEntry.SETRANGE("Worktime Entry", TRUE);
            ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);

            IF ResourceTimeRegEntry.FINDLAST AND (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."Entry Type"::"In Progress") THEN BEGIN
                Period.RESET;
                Period.SETRANGE(Period."Period Type", Period."Period Type"::Date);
                Period.SETRANGE(Period."Period Start", ResourceTimeRegEntry.Date, OnDate);
                IF Period.FINDFIRST THEN
                    REPEAT
                        IF Period."Period Start" <> OnDate THEN BEGIN
                            PeriodTime := 235959T;
                            AddWorkTimeRegEntry('FinishWorktime', CurrentResourceNo, Period."Period Start", PeriodTime);
                            NextPeriodDate := Period."Period Start" + 1;
                            PeriodTime := 000000T;
                            AddWorkTimeRegEntry('StartWorktime', CurrentResourceNo, NextPeriodDate, PeriodTime);
                        END;
                    UNTIL Period.NEXT = 0;
            END;
        END;
        //Add previous entries if needed<<

        AddWorkTimeRegEntry(Action, CurrentResourceNo, OnDate, OnTime);
    end;

    [Scope('Internal')]
    procedure AddWorkTimeRegEntry("Action": Code[20]; CurrentResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "25006290";
        EntryNo: Integer;
        PresentTime: DateTime;
        ActualWorkSpentTime: Decimal;
        ServLaborAllocApplication: Record "25006277";
        FirstEntryDate: Date;
    begin
        ResourceTimeRegEntry.RESET;
        IF ResourceTimeRegEntry.FINDLAST THEN
            EntryNo := ResourceTimeRegEntry."Entry No." + 1
        ELSE
            EntryNo := 1;

        //Get First Entry Date
        ResourceTimeRegEntry.RESET;
        ResourceTimeRegEntry.SETRANGE(ResourceTimeRegEntry."Worktime Entry", TRUE);
        ResourceTimeRegEntry.SETRANGE("Resource No.", CurrentResourceNo);
        ResourceTimeRegEntry.SETRANGE(ResourceTimeRegEntry."Entry Type", ResourceTimeRegEntry."Entry Type"::"In Progress");
        ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);
        IF ResourceTimeRegEntry.FINDLAST THEN
            FirstEntryDate := ResourceTimeRegEntry.Date
        ELSE
            FirstEntryDate := OnDate;

        CASE Action OF
            'STARTWORKTIME':
                BEGIN
                    ResourceTimeRegEntry.INIT;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."Entry Type"::"In Progress";
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := 0;
                    ResourceTimeRegEntry."Worktime Entry" := TRUE;
                    ResourceTimeRegEntry."Start Entry Date" := OnDate;
                    ResourceTimeRegEntry.INSERT;
                END;
            'FINISHWORKTIME':
                BEGIN

                    //Calculate actual work spent time
                    ResourceTimeRegEntry.RESET;
                    ResourceTimeRegEntry.SETRANGE("Resource No.", CurrentResourceNo);
                    ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);
                    ResourceTimeRegEntry.SETRANGE(ResourceTimeRegEntry."Worktime Entry", TRUE);
                    PresentTime := CREATEDATETIME(OnDate, OnTime);
                    IF ResourceTimeRegEntry.FINDLAST THEN BEGIN
                        ActualWorkSpentTime := ROUND((PresentTime - CREATEDATETIME(ResourceTimeRegEntry.Date, ResourceTimeRegEntry.Time)) / 3600000, 0.0001);
                    END;

                    ResourceTimeRegEntry.INIT;
                    ResourceTimeRegEntry."Entry No." := EntryNo;
                    ResourceTimeRegEntry."Resource No." := CurrentResourceNo;
                    ResourceTimeRegEntry."Entry Type" := ResourceTimeRegEntry."Entry Type"::Finished;
                    ResourceTimeRegEntry.Date := OnDate;
                    ResourceTimeRegEntry.Time := OnTime;
                    ResourceTimeRegEntry."Time Spent" := ActualWorkSpentTime;
                    ResourceTimeRegEntry."Worktime Entry" := TRUE;
                    ResourceTimeRegEntry."Start Entry Date" := FirstEntryDate;
                    ResourceTimeRegEntry.INSERT;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure GetTaskColor(TimeRegStatus: Option Pending,"In Progress",Finished,"On Hold"; ServLaborAllocationEntry: Record "25006271"): Text[20]
    var
        DTWorkTime: Decimal;
        RowAttention: Text[20];
    begin
        IF TimeRegStatus <> TimeRegStatus::Finished THEN BEGIN
            DTWorkTime := DateTimeMgt.Datetime(WORKDATE, TIME);
            IF ServLaborAllocationEntry."End Date-Time" < DTWorkTime THEN
                RowAttention := 'Attention';
        END;

        IF TimeRegStatus = TimeRegStatus::"In Progress" THEN
            RowAttention := 'Favorable';

        EXIT(RowAttention);
    end;

    [Scope('Internal')]
    procedure GetTaskColorPool(ServLaborAllocationEntry: Record "25006271"): Text[20]
    var
        DTWorkTime: Decimal;
        RowAttention: Text[20];
    begin
        IF ServLaborAllocationEntry.Status <> ServLaborAllocationEntry.Status::Finished THEN BEGIN
            DTWorkTime := DateTimeMgt.Datetime(WORKDATE, TIME);
            IF ServLaborAllocationEntry."End Date-Time" < DTWorkTime THEN
                RowAttention := 'Attention';
        END;

        IF ServLaborAllocationEntry.Status = ServLaborAllocationEntry.Status::"In Progress" THEN
            RowAttention := 'Favorable';

        EXIT(RowAttention);
    end;

    [Scope('Internal')]
    procedure GetDashboardCaption(ResourceNo: Code[20]): Text[100]
    var
        DashboardTitle: Text[100];
        UserProfileManagement: Codeunit "25006002";
        ResourceTimeRegMgt: Codeunit "25006290";
        Resource: Record "156";
    begin
        //DashboardTitle := UserProfileManagement.GetUserFullName(SingleInstanceManagment.GetCurrentUserId);
        IF Resource.GET(ResourceNo) THEN
            DashboardTitle := Resource.Name;
        DashboardTitle := UPPERCASE(DashboardTitle);
        DashboardTitle += '  :  ' + GetCurrentPeriodText;

        IF ResourceTimeRegMgt.IsResourceWorking(ResourceNo) THEN
            DashboardTitle += '  :  ' + TimeRegisterWorkingTxt
        ELSE
            DashboardTitle += '  :  ' + TimeRegisterNotWorkingTxt;

        EXIT(DashboardTitle)
    end;

    [Scope('Internal')]
    procedure GetDashboardRefreshInMinutes(): Integer
    begin
        ServiceScheduleSetup.GET;
        IF ServiceScheduleSetup."Dashboard Refresh in Minutes" <> 0 THEN
            EXIT(ServiceScheduleSetup."Dashboard Refresh in Minutes")
        ELSE
            EXIT(5);
    end;

    [Scope('Internal')]
    procedure UndoLastAction(AllocationEntryNo: Integer; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegEntry: Record "25006290";
        ResourceTimeRegEntryPrev: Record "25006290";
        ResourceTimeRegEntryLast: Record "25006290";
        ServLaborAllocationEntry: Record "25006271";
        ServScheduleMgt: Codeunit "25006201";
        SingleInstanceMgt: Codeunit "25006001";
        AllocationStatus: Option Pending,"In Process","Finish All","Finish Part","On Hold";
    begin
        ResourceTimeRegEntry.RESET;
        ResourceTimeRegEntry.SETRANGE("Resource No.", ResourceNo);
        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.", AllocationEntryNo);
        ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);
        IF ResourceTimeRegEntry.FINDLAST THEN BEGIN
            ResourceTimeRegEntryLast := ResourceTimeRegEntry;
            IF ResourceTimeRegEntry.NEXT(-1) <> 0 THEN BEGIN
                ResourceTimeRegEntryPrev := ResourceTimeRegEntry;
                IF ServLaborAllocationEntry.GET(ResourceTimeRegEntryPrev."Allocation Entry No.") THEN BEGIN
                    CASE ResourceTimeRegEntryPrev."Entry Type" OF
                        ResourceTimeRegEntryPrev."Entry Type"::"In Progress":
                            UpdateAllocationStatus('START', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                        ResourceTimeRegEntryPrev."Entry Type"::Finished:
                            UpdateAllocationStatus('COMPLETE', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                        ResourceTimeRegEntryPrev."Entry Type"::"On Hold":
                            UpdateAllocationStatus('ONHOLD', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                        ResourceTimeRegEntryPrev."Entry Type"::Pending:
                            UpdateAllocationStatus('CANCELSTART', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                    END;
                END;
                ResourceTimeRegEntryLast.Canceled := TRUE;
                ResourceTimeRegEntryLast.MODIFY;
            END ELSE BEGIN
                IF ServLaborAllocationEntry.GET(ResourceTimeRegEntryLast."Allocation Entry No.") THEN BEGIN
                    UpdateAllocationStatus('CANCELSTART', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                END;
                ResourceTimeRegEntryLast."Entry Type" := ResourceTimeRegEntryLast."Entry Type"::Pending;
                ResourceTimeRegEntryLast.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SetPeriodFilter(var ServLaborAllocationEntry: Record "25006271")
    var
        DTDayStart: Decimal;
        DTDayEnd: Decimal;
        DateToSet: Date;
        Period: Option;
    begin
        ServiceScheduleSetup.GET;
        IF SingleInstanceManagment.GetCurrentPeriod = 0 THEN
            Period := GetDefaultPeriod
        ELSE
            Period := SingleInstanceManagment.GetCurrentPeriod;

        DateToSet := SingleInstanceManagment.GetCurrentDate;
        CASE Period OF
            1: //Day
                BEGIN
                    DTDayStart := DateTimeMgt.Datetime(DateToSet, 0T);
                    DTDayEnd := DateTimeMgt.Datetime(DateToSet, 235959.999T);
                    SingleInstanceManagment.SetCurrentPeriod(1);
                END;
            2: //Week
                BEGIN
                    DTDayStart := DateTimeMgt.Datetime(CALCDATE('<-CW>', DateToSet), 0T);
                    DTDayEnd := DateTimeMgt.Datetime(CALCDATE('<CW>', DateToSet), 235959.999T);
                    SingleInstanceManagment.SetCurrentPeriod(2);
                END;
        END;
        ServLaborAllocationEntry.SETFILTER("Start Date-Time", '..%1', DTDayEnd);
        ServLaborAllocationEntry.SETFILTER("End Date-Time", '%1..', DTDayStart);
    end;

    [Scope('Internal')]
    procedure SetPeriodFilterResourceLink(var ScheduleResourceLink: Record "25006291")
    var
        DTDayStart: Date;
        DTDayEnd: Date;
        DateToSet: Date;
        Period: Option;
    begin
        ServiceScheduleSetup.GET;
        IF SingleInstanceManagment.GetCurrentPeriod = 0 THEN
            Period := GetDefaultPeriod
        ELSE
            Period := SingleInstanceManagment.GetCurrentPeriod;

        DateToSet := SingleInstanceManagment.GetCurrentDate;
        CASE Period OF
            1: //Day
                BEGIN
                    DTDayStart := DateToSet;
                    DTDayEnd := DateToSet;
                    SingleInstanceManagment.SetCurrentPeriod(1);
                END;
            2: //Week
                BEGIN
                    DTDayStart := CALCDATE('<-CW>', DateToSet);
                    DTDayEnd := CALCDATE('<CW>', DateToSet);
                    SingleInstanceManagment.SetCurrentPeriod(2);
                END;
        END;
        ScheduleResourceLink.SETFILTER("Starting Date", '..%1|%2', DTDayEnd, 0D);
        ScheduleResourceLink.SETFILTER("Ending Date", '%1..|%2', DTDayStart, 0D);

        //ScheduleResourceLink.SETFILTER("Starting Date",'0D',DTDayEnd);
        //ScheduleResourceLink.SETFILTER("Ending Date",'0D',DTDayStart);
    end;

    [Scope('Internal')]
    procedure MovePeriodFilter(Shift: Integer)
    var
        DTDayStart: Decimal;
        DTDayEnd: Decimal;
        DateToSet: Date;
    begin
        CASE SingleInstanceManagment.GetCurrentPeriod OF
            1: //Day
                BEGIN
                    SingleInstanceManagment.SetCurrentDate(SingleInstanceManagment.GetCurrentDate + Shift);
                END;
            2: //Week
                BEGIN
                    SingleInstanceManagment.SetCurrentDate(SingleInstanceManagment.GetCurrentDate + Shift * 7);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure GetCurrentPeriodText(): Text
    var
        DayStart: Date;
        DayEnd: Date;
    begin
        IF SingleInstanceManagment.GetCurrentPeriod = 1 THEN
            EXIT(FORMAT(SingleInstanceManagment.GetCurrentDate))
        ELSE BEGIN
            DayStart := CALCDATE('<-CW>', SingleInstanceManagment.GetCurrentDate);
            DayEnd := CALCDATE('<CW>', SingleInstanceManagment.GetCurrentDate);
            EXIT(FORMAT(DayStart) + ' - ' + FORMAT(DayEnd));
        END;
    end;

    [Scope('Internal')]
    procedure GetDefaultPeriod(): Integer
    begin
        ServiceScheduleSetup.GET;
        CASE ServiceScheduleSetup."Dashboard Default Period" OF
            0: //Day
                BEGIN
                    SingleInstanceManagment.SetCurrentPeriod(1);
                END;
            1: //Week
                BEGIN
                    SingleInstanceManagment.SetCurrentPeriod(2);
                END;
        END;

        EXIT(SingleInstanceManagment.GetCurrentPeriod);
    end;

    [Scope('Internal')]
    procedure IsResourceWorking(ResourceNo: Code[20]): Boolean
    var
        WorkTimeEntry: Record "25006276";
    begin
        WorkTimeEntry.SETCURRENTKEY("Resource No.", Closed);
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF NOT WorkTimeEntry.FINDLAST THEN
            EXIT(FALSE)
        ELSE
            EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure StartNewTaskFromHeader(ServiceHeader: Record "25006145"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time; IsTravel: Boolean): Integer
    var
        ServLaborAllocationEntry: Record "25006271";
        ServLaborAllocationApp: Record "25006277";
        ServiceLine: Record "25006146" temporary;
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page "25006369";
        AllocatedEntryNo: Integer;
        WorkTimeEntry: Record "25006276";
    begin
        ServiceScheduleSetup.GET;
        //ResourceNo := GetCurrentUserResourceNo;

        WorkTimeEntry.RESET;
        WorkTimeEntry.SETCURRENTKEY("Resource No.", Closed);
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF NOT WorkTimeEntry.FINDLAST THEN
            ERROR(STRSUBSTNO(ValidateResourceWorktimeErr, ResourceNo));

        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := FALSE;
        SourceType := ServLaborAllocationEntry."Source Type"::"Service Document";
        Mode := Mode::"New Allocation";
        SourceSubType := ServiceHeader."Document Type";
        SourceID := ServiceHeader."No.";
        CLEAR(ServiceScheduleMgt);

        //ServiceScheduleMgt.CheckForCorrectServHeaderLine(ServiceHeader, ServiceLine, WhatAllocation::Header);
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE("Line No.", 0);

        CLEAR(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 1);
        AllocationForm.SetInvisibles(0);
        AllocationForm.SetIsTravel(IsTravel);
        AllocatedEntryNo := AllocationForm.Allocate;

        IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN BEGIN
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        END;

        EXIT(AllocatedEntryNo);
    end;

    [Scope('Internal')]
    procedure StartNewTaskFromLine(ServiceLine1: Record "25006146"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time; IsTravel: Boolean)
    var
        ServiceHeader: Record "25006145";
        ServLaborAllocationEntry: Record "25006271";
        StartDateTime: Decimal;
        CurrQtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        ServiceLine: Record "25006146";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        WhatAllocation: Option Header,Line;
        AllocationForm: Page "25006369";
        ServiceLine2: Record "25006146" temporary;
        AllocatedEntryNo: Integer;
        WorkTimeEntry: Record "25006276";
    begin
        //ResourceNo := GetCurrentUserResourceNo;

        WorkTimeEntry.RESET;
        WorkTimeEntry.SETCURRENTKEY("Resource No.", Closed);
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF NOT WorkTimeEntry.FINDLAST THEN
            ERROR(STRSUBSTNO(ValidateResourceWorktimeErr, ResourceNo));


        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := FALSE;
        CLEAR(ServiceScheduleMgt);
        LineNo := 0;
        SourceSubType := ServiceLine1."Document Type";
        SourceID := ServiceLine1."Document No.";
        SourceType := ServLaborAllocationEntry."Source Type"::"Service Document";

        ServiceLine2 := ServiceLine1;
        ServiceLine2.INSERT;

        //ServiceScheduleMgt.CheckForCorrectServHeaderLine(ServiceHeader, ServiceLine2, WhatAllocation::Line);

        CLEAR(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, SourceType, SourceSubType, SourceID, 0, ServiceLine2, 1);
        AllocationForm.SetInvisibles(0);
        AllocationForm.SetIsTravel(IsTravel);
        AllocatedEntryNo := AllocationForm.Allocate;

        IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN BEGIN
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        END;
    end;

    [Scope('Internal')]
    procedure StartNewTaskFromStandard(ResourceNo: Code[20]; OnDate: Date; OnTime: Time): Integer
    var
        ServLaborAllocationEntry: Record "25006271";
        ServLaborAllocationApp: Record "25006277";
        ServiceLine: Record "25006146" temporary;
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page "25006369";
        AllocatedEntryNo: Integer;
        StandardEvents: Page "25006357";
        StandardEvent: Record "25006272";
        WorkTimeEntry: Record "25006276";
        MeetingDescription: Text;
        EasyTimeMeetingDialog: Page "25006099";
    begin
        ServiceScheduleSetup.GET;
        //ResourceNo := GetCurrentUserResourceNo;

        WorkTimeEntry.RESET;
        WorkTimeEntry.SETCURRENTKEY("Entry No.");
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF NOT WorkTimeEntry.FINDLAST THEN
            ERROR(STRSUBSTNO(ValidateResourceWorktimeErr, ResourceNo));

        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := FALSE;
        SourceType := ServLaborAllocationEntry."Source Type"::"Service Document";
        Mode := Mode::"New Allocation";
        //SourceSubType := ServiceHeader."Document Type";
        //SourceID := ServiceHeader."No.";
        CLEAR(ServiceScheduleMgt);


        //IF NOT CheckUserRightsAdv(2, LaborAllocEntry) THEN EXIT;
        CLEAR(StandardEvents);
        StandardEvents.LOOKUPMODE(TRUE);
        IF StandardEvents.RUNMODAL = ACTION::LookupOK THEN BEGIN
            StandardEvents.GETRECORD(StandardEvent);
            //Allocate(ResourceNo,StartingDateTime,0,2,0,StandardEvent.Code,ServLine,0);

            IF StandardEvent.Code = 'MEETING' THEN BEGIN
                MeetingDescription := '';
                EasyTimeMeetingDialog.RUNMODAL;
                MeetingDescription := EasyTimeMeetingDialog.GetMeetingDescription;
            END;

            CLEAR(AllocationForm);
            AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, 2, 0, StandardEvent.Code, 0, ServiceLine, 1);
            AllocationForm.SetDescription(MeetingDescription);
            AllocationForm.SetInvisibles(0);
            AllocatedEntryNo := AllocationForm.Allocate;

            IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN BEGIN
                FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
                AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
            END;
        END;

        EXIT(AllocatedEntryNo);
    end;

    [Scope('Internal')]
    procedure CalculateDuration(var DurationPar: Duration; var QtyToAllocate: Decimal; WhichWay: Option "To Duration","From Duration")
    begin
        IF WhichWay = WhichWay::"To Duration" THEN
            DurationPar := ROUND(QtyToAllocate * 3600000, 1);

        IF WhichWay = WhichWay::"From Duration" THEN
            QtyToAllocate := ROUND(DurationPar / 3600000, 0.0001);
    end;

    [Scope('Internal')]
    procedure GetNextNewAllocEntryNo(): Integer
    var
        ServLaborAllocationEntryL: Record "25006271";
        NewEntryNoTmp: Integer;
    begin
        IF NewEntryNoTmp = 0 THEN BEGIN
            IF ServLaborAllocationEntryL.FINDLAST THEN
                NewEntryNoTmp := ServLaborAllocationEntryL."Entry No.";
        END;
        NewEntryNoTmp += 1;
        EXIT(NewEntryNoTmp);
    end;

    [Scope('Internal')]
    procedure UpdateAllocationStatus("Action": Code[20]; ServLaborAllocationEntry: Record "25006271"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        StartFinishAllocation: Page "25006355";
        StatusToSet: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        ServiceSetup: Record "25006120";
        ServStandardEvent: Record "25006272";
    begin
        ServiceSetup.GET;
        IF ServLaborAllocationEntry."Source ID" = ServiceSetup."Default Idle Event" THEN
            EXIT;

        CASE Action OF
            'START':
                BEGIN
                    StatusToSet := StatusToSet::"In Process";
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    StartFinishAllocation.SetParam(ResourceNo,
                      DateTimeMgt.Datetime(OnDate, OnTime),
                      ServLaborAllocationEntry."Quantity (Hours)",
                      ServLaborAllocationEntry."Source Type",
                      ServLaborAllocationEntry."Source Subtype",
                      ServLaborAllocationEntry."Source ID",
                      StatusToSet,
                      0);
                    StartFinishAllocation.StartEndWork;
                    /*
                    ServLaborAllocationEntry.Status := ServLaborAllocationEntry.Status::"In Progress";
                    ServLaborAllocationEntry.MODIFY;
                    ServiceScheduleMgt.ChangeServiceLineStatus(ServLaborAllocationEntry."Entry No.",FALSE);
                    */
                END;
            'ONHOLD':
                BEGIN
                    StatusToSet := StatusToSet::"On Hold";
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    StartFinishAllocation.SetParam(ResourceNo,
                      DateTimeMgt.Datetime(OnDate, OnTime),
                      ServLaborAllocationEntry."Quantity (Hours)",
                      ServLaborAllocationEntry."Source Type",
                      ServLaborAllocationEntry."Source Subtype",
                      ServLaborAllocationEntry."Source ID",
                      StatusToSet,
                      0);
                    StartFinishAllocation.StartEndWork;
                END;
            'STOP':
                BEGIN
                    StatusToSet := StatusToSet::"Finish Part";
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    StartFinishAllocation.SetParam(ResourceNo,
                      DateTimeMgt.Datetime(OnDate, OnTime),
                      ServLaborAllocationEntry."Quantity (Hours)",
                      ServLaborAllocationEntry."Source Type",
                      ServLaborAllocationEntry."Source Subtype",
                      ServLaborAllocationEntry."Source ID",
                      StatusToSet,
                      0);
                    StartFinishAllocation.StartEndWork;
                END;
            'COMPLETE':
                BEGIN
                    StatusToSet := StatusToSet::"Finish All";
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    StartFinishAllocation.SetParam(ResourceNo,
                      DateTimeMgt.Datetime(OnDate, OnTime),
                      ServLaborAllocationEntry."Quantity (Hours)",
                      ServLaborAllocationEntry."Source Type",
                      ServLaborAllocationEntry."Source Subtype",
                      ServLaborAllocationEntry."Source ID",
                      StatusToSet,
                      0);
                    StartFinishAllocation.StartEndWork;
                END;
            'CANCELSTART':
                BEGIN
                    CLEAR(ServiceScheduleMgt);
                    SingleInstanceManagment.SetCurrAllocation(ServLaborAllocationEntry."Entry No.");
                    ServiceScheduleMgt.CancelAllocation(StatusToSet::Pending, DateTimeMgt.Datetime(OnDate, OnTime), FALSE); //that is commented at 05.09.2014 - function from EDMS7.10.11
                END;
        END;
        UpdateParentAllocationStatus(ServLaborAllocationEntry."Entry No.", OnDate, OnTime);

    end;

    [Scope('Internal')]
    procedure ModifyLastTimeRegEntry(var ResourceTimeRegEntry: Record "25006290")
    var
        ModifyResTimeEntry: Page "25006297";
        ResourceTimeRegEntryTmp: Record "25006290" temporary;
        ResourceTimeRegEntryPrev: Record "25006290";
        ResourceTimeRegEntryNext: Record "25006290";
        ResourceTimeRegEntryTotal: Record "25006290";
        ResourceTimeRegEntryLast: Record "25006290";
        ActualWorkSpentTime: Decimal;
    begin
        ResourceTimeRegEntryPrev.COPYFILTERS(ResourceTimeRegEntry);
        ResourceTimeRegEntryPrev.SETRANGE("Entry Type", ResourceTimeRegEntryPrev."Entry Type"::"In Progress");
        ResourceTimeRegEntryPrev.SETFILTER("Entry No.", '<%1', ResourceTimeRegEntry."Entry No.");
        ResourceTimeRegEntryPrev.SETRANGE(Canceled, FALSE);

        ModifyResTimeEntry.SetEntry(ResourceTimeRegEntry);
        ModifyResTimeEntry.LOOKUPMODE(TRUE);
        IF ModifyResTimeEntry.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ModifyResTimeEntry.GETRECORD(ResourceTimeRegEntryTmp);
            ResourceTimeRegEntry.Date := ResourceTimeRegEntryTmp.Date;
            ResourceTimeRegEntry.Time := ResourceTimeRegEntryTmp.Time;
            ResourceTimeRegEntry."Time Spent" := ResourceTimeRegEntryTmp."Time Spent";
            ResourceTimeRegEntry.MODIFY;
            MESSAGE(TimeModifiedLastEntryMsg);
        END;
    end;

    [Scope('Internal')]
    procedure ValidateTimeRegAction("Action": Code[20]; ServLaborAllocationEntry: Record "25006271"; ResourceNo: Code[20])
    var
        ResourceTimeRegEntry: Record "25006290";
        EntryNo: Integer;
        PresentTime: DateTime;
        ActualWorkSpentTime: Duration;
        TotalWorkSpentTime: Duration;
        ServiceHeader: Record "25006145";
    begin
        ResourceTimeRegEntry.RESET;
        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        ResourceTimeRegEntry.SETRANGE("Resource No.", ResourceNo);
        ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);
        CASE Action OF
            'START':
                BEGIN
                    IF ResourceTimeRegEntry.FINDLAST AND (ResourceTimeRegEntry."Entry Type" = ResourceTimeRegEntry."Entry Type"::"In Progress") THEN BEGIN
                        ERROR(ValidateActionStartErr);
                    END;
                END;
        END;
        IF NOT ServiceHeader.GET(ServLaborAllocationEntry."Source Subtype", ServLaborAllocationEntry."Source ID") AND
          (ServLaborAllocationEntry."Source Type" = ServLaborAllocationEntry."Source Type"::"Service Document") THEN
            ERROR(ValidateActionPostedDocErr);
    end;

    [Scope('Internal')]
    procedure StartNewTaskFromAllocation(PoolServLaborAllocationEntry: Record "25006271"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time): Integer
    var
        ServLaborAllocationEntry: Record "25006271";
        ServLaborAllocationApp: Record "25006277";
        ServiceLine: Record "25006146" temporary;
        StartDateTime: Decimal;
        EndDateTime: Decimal;
        StartDateTimeDT: DateTime;
        EndDateTimeDT: DateTime;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page "25006369";
        AllocatedEntryNo: Integer;
    begin
        ServiceScheduleSetup.GET;
        EntryNo := PoolServLaborAllocationEntry."Entry No.";
        //ResourceNo := GetCurrentUserResourceNo;
        StartDateTime := PoolServLaborAllocationEntry."Start Date-Time";
        EndDateTime := ServiceScheduleMgt.GetEntryEndingTimeFull(EntryNo);
        StartDateTimeDT := CREATEDATETIME(DateTimeMgt.Datetime2Date(PoolServLaborAllocationEntry."Start Date-Time"), DateTimeMgt.Datetime2Time(PoolServLaborAllocationEntry."Start Date-Time"));
        EndDateTimeDT := CREATEDATETIME(DateTimeMgt.Datetime2Date(EndDateTime), DateTimeMgt.Datetime2Time(EndDateTime));
        DivideIntoLines := FALSE;
        SourceType := PoolServLaborAllocationEntry."Source Type";
        Mode := Mode::"New Allocation";
        SourceSubType := PoolServLaborAllocationEntry."Source Subtype";
        SourceID := PoolServLaborAllocationEntry."Source ID";
        CLEAR(ServiceScheduleMgt);

        Duration := EndDateTimeDT - StartDateTimeDT;
        CalculateDuration(Duration, QtyToAllocate, 1);

        ServiceLine.RESET;

        CLEAR(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, DateTimeMgt.Datetime(OnDate, OnTime), 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 1);//
        AllocationForm.SetInvisibles(QtyToAllocate);
        AllocatedEntryNo := AllocationForm.Allocate;
        UpdateAllocationParentId(AllocatedEntryNo, EntryNo);
        UpdateParentAllocationStatus(AllocatedEntryNo, OnDate, OnTime);
        IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);

        EXIT(AllocatedEntryNo);
    end;

    [Scope('Internal')]
    procedure StartNewTravelTaskFromAllocation(PoolServLaborAllocationEntry: Record "25006271"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ServLaborAllocationEntry: Record "25006271";
        ServLaborAllocationApp: Record "25006277";
        ServiceLine: Record "25006146" temporary;
        StartDateTime: Decimal;
        EndDateTime: Decimal;
        StartDateTimeDT: DateTime;
        EndDateTimeDT: DateTime;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page "25006369";
        AllocatedEntryNo: Integer;
    begin
        ServiceScheduleSetup.GET;
        EntryNo := PoolServLaborAllocationEntry."Entry No.";
        //ResourceNo := GetCurrentUserResourceNo;
        StartDateTime := PoolServLaborAllocationEntry."Start Date-Time";
        EndDateTime := ServiceScheduleMgt.GetEntryEndingTimeFull(EntryNo);
        StartDateTimeDT := CREATEDATETIME(DateTimeMgt.Datetime2Date(PoolServLaborAllocationEntry."Start Date-Time"), DateTimeMgt.Datetime2Time(PoolServLaborAllocationEntry."Start Date-Time"));
        EndDateTimeDT := CREATEDATETIME(DateTimeMgt.Datetime2Date(EndDateTime), DateTimeMgt.Datetime2Time(EndDateTime));
        DivideIntoLines := FALSE;
        SourceType := PoolServLaborAllocationEntry."Source Type";
        Mode := Mode::"New Allocation";
        SourceSubType := PoolServLaborAllocationEntry."Source Subtype";
        SourceID := PoolServLaborAllocationEntry."Source ID";
        CLEAR(ServiceScheduleMgt);

        Duration := EndDateTimeDT - StartDateTimeDT;
        CalculateDuration(Duration, QtyToAllocate, 1);

        ServiceLine.RESET;

        CLEAR(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, DateTimeMgt.Datetime(OnDate, OnTime), 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 1);//
        AllocationForm.SetInvisibles(QtyToAllocate);
        AllocationForm.SetIsTravel(TRUE);
        AllocatedEntryNo := AllocationForm.Allocate;

        IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN BEGIN
            FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
        END;
    end;

    [Scope('Internal')]
    procedure UpdateAllocationParentId(EntryNo: Integer; ParentEntryNo: Integer)
    var
        LaborAllocEntryTmp: Record "25006271" temporary;
        LaborAllocEntry: Record "25006271";
    begin
        ServiceScheduleMgt.FindSplitEntries(EntryNo, LaborAllocEntryTmp, 0, 1111);
        IF LaborAllocEntryTmp.FINDFIRST THEN
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocEntryTmp."Entry No.") THEN BEGIN
                    LaborAllocEntry."Parent Alloc. Entry No." := ParentEntryNo;
                    LaborAllocEntry.MODIFY;
                END;
            UNTIL LaborAllocEntryTmp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateParentAllocationStatus(ChildEntryNo: Integer; OnDate: Date; OnTime: Time)
    var
        LaborAllocEntryChildren: Record "25006271";
        LaborAllocEntry: Record "25006271";
        LaborAllocEntryParent: Record "25006271";
        ServAllocStatusPriority: Record "25006292";
        ParentEntryNo: Integer;
        LowestStatus: Option High,"Medium High","Medium Low",Low;
        AllocStatus: Option Pending,"In Progress",Finished,"On Hold";
        StatusToSet: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        StartFinishAllocation: Page "25006355";
    begin
        LowestStatus := 999999;

        LaborAllocEntry.GET(ChildEntryNo);
        ParentEntryNo := LaborAllocEntry."Parent Alloc. Entry No.";
        IF ParentEntryNo <> 0 THEN BEGIN
            LaborAllocEntryChildren.RESET;
            LaborAllocEntryChildren.SETRANGE("Source ID", LaborAllocEntry."Source ID");
            LaborAllocEntryChildren.SETRANGE("Parent Alloc. Entry No.", LaborAllocEntry."Parent Alloc. Entry No.");

            IF LaborAllocEntryChildren.FINDFIRST THEN
                REPEAT
                    IF ServAllocStatusPriority.GET(LaborAllocEntryChildren.Status) THEN BEGIN
                        IF ServAllocStatusPriority.Priority < LowestStatus THEN BEGIN
                            LowestStatus := ServAllocStatusPriority.Priority;
                            AllocStatus := ServAllocStatusPriority.Status;
                        END;
                    END;
                UNTIL LaborAllocEntryChildren.NEXT = 0;

            IF LaborAllocEntryParent.GET(ParentEntryNo) THEN BEGIN
                CASE AllocStatus OF
                    AllocStatus::"In Progress":
                        BEGIN
                            SingleInstanceManagment.SetCurrAllocation(ParentEntryNo);
                            StartFinishAllocation.SetParam(LaborAllocEntryParent."Resource No.",
                              DateTimeMgt.Datetime(OnDate, OnTime),
                              LaborAllocEntryParent."Quantity (Hours)",
                              LaborAllocEntryParent."Source Type",
                              LaborAllocEntryParent."Source Subtype",
                              LaborAllocEntryParent."Source ID",
                              StatusToSet::"In Process",
                              0);
                            StartFinishAllocation.StartEndWork;
                        END;
                    AllocStatus::"On Hold":
                        BEGIN
                            SingleInstanceManagment.SetCurrAllocation(ParentEntryNo);
                            StartFinishAllocation.SetParam(LaborAllocEntryParent."Resource No.",
                              DateTimeMgt.Datetime(OnDate, OnTime),
                              LaborAllocEntryParent."Quantity (Hours)",
                              LaborAllocEntryParent."Source Type",
                              LaborAllocEntryParent."Source Subtype",
                              LaborAllocEntryParent."Source ID",
                              StatusToSet::"On Hold",
                              0);
                            StartFinishAllocation.StartEndWork;
                        END;
                    AllocStatus::Finished:
                        BEGIN
                            SingleInstanceManagment.SetCurrAllocation(ParentEntryNo);
                            StartFinishAllocation.SetParam(LaborAllocEntryParent."Resource No.",
                              DateTimeMgt.Datetime(OnDate, OnTime),
                              LaborAllocEntryParent."Quantity (Hours)",
                              LaborAllocEntryParent."Source Type",
                              LaborAllocEntryParent."Source Subtype",
                              LaborAllocEntryParent."Source ID",
                              StatusToSet::"Finish All",
                              0);
                            StartFinishAllocation.StartEndWork;
                        END;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure StartDefaultIdleTask(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ServLaborAllocationEntry: Record "25006271";
        ServLaborAllocationApp: Record "25006277";
        ServiceLine: Record "25006146" temporary;
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page "25006369";
        AllocatedEntryNo: Integer;
        StandardEvent: Record "25006272";
        ServiceSetup: Record "25006120";
    begin
        ServiceSetup.GET;
        IF ServiceSetup."Default Idle Event" = '' THEN
            EXIT;
        StandardEvent.GET(ServiceSetup."Default Idle Event");
        StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        DivideIntoLines := FALSE;
        SourceType := ServLaborAllocationEntry."Source Type"::"Service Document";
        Mode := Mode::"New Allocation";
        //SourceSubType := ServiceHeader."Document Type";
        //SourceID := ServiceHeader."No.";
        CLEAR(ServiceScheduleMgt);
        CLEAR(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, 2, 0, StandardEvent.Code, 0, ServiceLine, 1);
        AllocationForm.SetInvisibles(0);
        AllocationForm.SetDescription(StandardEvent.Description);
        AllocatedEntryNo := AllocationForm.Allocate;
        IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);

        /*
        ServiceSetup.GET;
        CLEAR(ServiceScheduleMgt);
        StartDateTime := DateTimeMgt.Datetime(OnDate,OnTime);
        StandardEvent.GET(ServiceSetup."Default Idle Event");
        AllocatedEntryNo := ServiceScheduleMgt.CreateNewAllocEntry(StartDateTime,ResourceNo,1,2,StandardEvent.Code,0,'',0,0,0,1);
        IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN
          AddTimeRegEntries('Start',ServLaborAllocationEntry,ResourceNo,OnDate,OnTime);
        */

    end;

    [Scope('Internal')]
    procedure FinishDefaultIdleTask(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        LaborAllocEntry: Record "25006271";
        StandardEvent: Record "25006272";
        ServiceSetup: Record "25006120";
        CurrDateTime: Decimal;
        AllocationStatus: Option Pending,"In Process",Finished,"On Hold";
    begin
        ServiceSetup.GET;
        IF ServiceSetup."Default Idle Event" = '' THEN
            EXIT;
        StandardEvent.GET(ServiceSetup."Default Idle Event");
        LaborAllocEntry.RESET;
        LaborAllocEntry.SETCURRENTKEY("Source Type", Status, "Resource No.");
        LaborAllocEntry.SETFILTER(Status, '%1|%2', LaborAllocEntry.Status::"In Progress", LaborAllocEntry.Status::"On Hold");
        LaborAllocEntry.SETRANGE("Resource No.", ResourceNo);
        LaborAllocEntry.SETRANGE("Source Type", LaborAllocEntry."Source Type"::"Standard Event");
        LaborAllocEntry.SETRANGE(LaborAllocEntry."Source ID", StandardEvent.Code);
        IF LaborAllocEntry.FINDFIRST THEN
            REPEAT
                CurrDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
                ServiceScheduleMgt.SetAllocationStatus(AllocationStatus::Finished);
                ServiceScheduleMgt.WriteAllocationEntryEnd(LaborAllocEntry."Entry No.", CurrDateTime, FALSE, '', LaborAllocEntry.Travel);
                AddTimeRegEntries('Complete', LaborAllocEntry, LaborAllocEntry."Resource No.", OnDate, OnTime);
            UNTIL LaborAllocEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure StartWorktime(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        CurrDateTime: Decimal;
    begin
        CurrDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        //ResourceNo := GetCurrentUserResourceNo;
        ServiceScheduleMgt.ProcessStartWorkday(ResourceNo, CurrDateTime);
    end;

    [Scope('Internal')]
    procedure EndWorktime(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        CurrDateTime: Decimal;
    begin
        CurrDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        //ResourceNo := GetCurrentUserResourceNo;
        ServiceScheduleMgt.ProcessEndWorkday(ResourceNo, CurrDateTime);
    end;

    [Scope('Internal')]
    procedure StartWorktimeSilent(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        CurrDateTime: Decimal;
    begin
        CurrDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
        //ResourceNo := GetCurrentUserResourceNo;
        ServiceScheduleMgt.ProcessStartWorkdaySilent(ResourceNo, CurrDateTime);
    end;

    [Scope('Internal')]
    procedure ToggleWorktime(ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    begin
        //ResourceNo := GetCurrentUserResourceNo;
        IF IsResourceWorking(ResourceNo) THEN
            EndWorktime(ResourceNo, OnDate, OnTime)
        ELSE
            StartWorktime(ResourceNo, OnDate, OnTime);
    end;

    [Scope('Internal')]
    procedure HasTasksInProgress(ResourceNo: Code[20]): Boolean
    var
        LaborAllocEntry: Record "25006271";
        ResourceTimeRegMgt: Codeunit "25006290";
    begin
        LaborAllocEntry.RESET;
        LaborAllocEntry.SETCURRENTKEY("Source Type", Status, "Resource No.");
        LaborAllocEntry.SETRANGE(Status, LaborAllocEntry.Status::"In Progress");
        LaborAllocEntry.SETRANGE("Resource No.", ResourceNo);
        EXIT(LaborAllocEntry.FINDFIRST)
    end;

    [Scope('Internal')]
    procedure StartNewTaskFromStandardMobileOnline(StandardEvent: Record "25006272")
    var
        ServLaborAllocationEntry: Record "25006271";
        ServLaborAllocationApp: Record "25006277";
        ServiceLine: Record "25006146" temporary;
        ResourceNo: Code[20];
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page "25006369";
        AllocatedEntryNo: Integer;
    begin
        ResourceNo := GetCurrentUserResourceNo;
        StartDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);
        DivideIntoLines := FALSE;
        SourceType := ServLaborAllocationEntry."Source Type"::"Service Document";
        Mode := Mode::"New Allocation";
        //SourceSubType := ServiceHeader."Document Type";
        //SourceID := ServiceHeader."No.";
        CLEAR(ServiceScheduleMgt);

        CLEAR(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, 2, 0, StandardEvent.Code, 0, ServiceLine, 1);
        AllocationForm.SetInvisibles(0);
        AllocatedEntryNo := AllocationForm.Allocate;
        IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN
            AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, WORKDATE, TIME);
    end;
}

