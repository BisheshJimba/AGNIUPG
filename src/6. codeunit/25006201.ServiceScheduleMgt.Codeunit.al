codeunit 25006201 "Service Schedule Mgt."
{
    // 11.06.2015 EB.P7 #Schedule3.0
    //   GetAllocRecDescr Modified.
    // 
    // 28.05.2015 EB.P30 #T030
    //   Created function:
    //     CopyServLaborAllocApplFromDetServLedg
    // 
    // 12.05.2015 EB.P30 #T030
    //   Modified functions:
    //     InsertAllocApplication
    //     ModifyAllocApplication
    // 
    // 18.12.2014 Elva Baltic P21 #E0003
    //   Modified procedure:
    //     DeleteAllocationFromServLines
    // 
    // 12.12.2014 EB.P8
    //   Small fix.
    // 
    // 19.05.2014 Elva Baltic P21 #S0101 MMG7.00
    //   Modified function:
    //     CancelAllocation
    // 
    // 16.05.2014 Elva Baltic P21 #S0101 MMG7.00
    //   Added function:
    //     CancelAllocation
    // 
    // 14.05.2014 Elva Baltic P21 #S0102 MMG7.00
    //   Modified function:
    //     CreateFieldText
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     CopyServLaborAllocAppl
    // 
    // 09.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Temporaty=TRUE set for variable ServiceLine in function ServiceMoveAllocation
    // 
    // 22.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Modified AllocateNewVisitOrder function
    // 
    // 14.03.2014 Elva Baltic P8 #S0003 MMG7.00
    //   * Fix: Details Entry No. should be copied into related allocations
    //   * New function FindFirstAppliedEntryNo
    // 
    // 10.12.2013 EDMS P8
    //   * fix when lost "Applies-to Entry No."
    // 
    // 22.11.2013 EDMS P8
    // 20.11.2013 EDMS P8
    //   * small changes in user rights
    //   * add functions ErrorWithRefresh
    // 
    // 24.10.2013 EDMS P8
    //   * Implement use of T25006268. New UpdateAllocDetailsText
    // 
    // 17.10.2013 EDMS P8
    //   * now able to start job with change resource
    //   * now able to start FEW jobs if Resource."Allow Several Jobs AtOnce"
    // 
    // 15.08.2013 EDMS P8
    //   * fix for case: ON HOLD it did finish current allocation with correct end time but did not createhold allocation part...
    //   * CHANGE IN FindSplitEntries
    // 
    // 12.08.2013 EDMS P8
    //   * fix for case: try to Break allocation in process without chosen T25006272.Code, now it will bring error
    //   * fix for case: finished splitten allocation should react on moving the same as it is in other status, like 'Pending'
    // 
    // 20.07.2013 EDMS P8
    //   * fix for case: create new allocation that is going to be splitten in several parts it made unrelated allocations
    //   * fix for case: if once push on finished allocation that is continuous on unavailable time as well it made split
    //   * fix for case: resize allocation in case of split it did split and in new allocation other status than first
    //   * fix for case: at start of split allocation it did increase total time.
    //   * fix for case: at finish of split allocation it did left other allocation in progress, but should delete it.
    //   * fix for case: at Hold Allocation on serv doc allocat. it brought error '' (do not create correct application line for next new allocat.).
    //   * fix for case: at Hold Allocation on SPLITTEN allocation it made one hold allacation and last alloc. part left 'In Process'
    // 
    // 09.07.2013 EDMS P8
    //   * fix to make new allocation line - it was created for wholo header instead...
    // 
    // 28.06.2013 EDMS P8
    //   * fix error message "Not found Alloc Entry,,,"
    //   * add COMMIT before PageVar.RUNMODAL
    // 
    // 04.06.2013 EDMS P8
    //   new function CalcEndDTOnlyWorktime
    // 15.04.2013 EDMS P8
    //   * Fix on-hold part should be separated of finished, influence into behavior of work ClearAllocationEntry in function MovementIncSplit
    // 
    // 09.04.2013 EDMS P8
    //   * fix new created allocation should not create additional AppEntries for Lines
    // 
    // 03.04.2013 P8
    //   * set for page runmodal: ChangeAllocationForm.LOOKUPMODE(TRUE);  //03.04.2013 P8
    //   * removed unnecessary GetScheduleViewCode
    // 
    // 19.03.2013 EDMS P8
    //   fix for split process
    // 
    // 01.03.2013 EDMS P8
    //   * FIX resource insert/remove for order
    // 
    // 2012.05.07 EDMS P8
    //   * As far splited entries became more useful then most routines must be recoded so that it could be runed in modes:
    //   *   to process single entry;
    //   *   to process splited entries by submodes:
    //   *     first run - check all involved records, is it allowed to continue;
    //   *     second loop - main actions;
    //   *     third loop - finalize and adjust with other noninvolved entries
    // 
    // 2012.04.12 EDMS P8
    //   * removed "Service Line"."Resource No." field use.
    // 
    // 18.01.2012 EDMS P8
    //   * fix to be shown lunch unavailable periods
    //   * add functions: SeparateAllocEntry, CreateNewAllocEntry
    //   * do not use SplitTracking for now (added value to that variable)
    //   * terms: splited entries - means entries of one application linked by "Applies-to Entry No.", so splitted due to some breaks...
    //   *       related - means entries that are linked by "Parent Alloc. Entry No.", different application but one line for now
    //   *         it should be synchronized!
    // 
    // 28.01.2010 EDMSB P2
    //   * Added function ShowServiceAllocation, AllocateEventAndStart
    // 
    // Split tracking - handle linked entries

    Permissions = TableData 454 = rimd;

    trigger OnRun()
    begin
    end;

    var
        LaborAllocationEntryPrevTmp: Record "25006271" temporary;
        ServiceScheduleSetup: Record "25006286";
        ServiceSetup: Record "25006120";
        UserSetup: Record "91";
        Resource: Record "156";
        SingleInstanceMgt: Codeunit "25006001";
        CalendarMgt: Codeunit "7600";
        DocumentMgt: Codeunit "25006000";
        DateTimeMgt: Codeunit "25006012";
        ResourceTimeRegMgt: Codeunit "25006290";
        LaborAllocEntry: Record "25006271";
        LaborAllocApp: Record "25006277";
        Text001: Label 'X';
        Text100: Label 'Do you want to delete all connected entries?';
        Text101: Label 'Do you want to move all connected entries?';
        Text102: Label 'It was not possible to plan activities.';
        ServLaborApplicationGlobTmp: Record "25006277" temporary;
        ServiceLine: Record "25006146" temporary;
        ReasonCodeGlobal: Code[20];
        SplitTracking: Option No,Yes,Undef;
        Text103: Label 'Replan all entries after this event?';
        AllocationStatus: Option Pending,"In Process",Finished,"On Hold";
        AllocationStatusAction: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        ScheduleAction: Option Planning,"Time Registration";
        DoServiceSpliting: Boolean;
        ChangeAllocationStatus: Boolean;
        Text106: Label 'You have to finish labor in progress: %1 %2!';
        Text107: Label 'Resource %1 have to start work time first.';
        Text108: Label 'You can start only service labors.';
        Text109: Label 'This labor allocation entry is already finished.';
        Text110: Label 'This labor allocation entry is already in progress.';
        Text111: Label 'You can only finish labor that is in progress.';
        Text112: Label 'Wrong password.';
        Text113: Label 'You are not allowed to work now.';
        Text114: Label 'You cannot deallocate. One or more connected entries has status %1.';
        Text115: Label 'You can not post Service Line %1. Because there are unfinished Service Shedule entries.';
        Text116: Label 'You cannot delete this service, because there is finished service allocation.';
        Text117: Label 'Do you want delete service entries in schedule, too?';
        Text118: Label 'You cannot delete service, because there are entris in schedule.';
        Text119: Label 'Resource %1 has not started worktime.';
        Text120: Label 'Resource %1 has already started worktime.';
        Text121: Label 'No Serv. Labor Allocation Entries are selected. Please select the entry.';
        Text122: Label 'Labor sequence will be wrong. Do you want continue?';
        Text123: Label 'You can not split entry which has status : %1!';
        Text124: Label 'The process is canceled.';
        Text125: Label 'Resource %1 has no such skills: %2! Do you want continue?';
        Text126: Label 'Do you want to clear remaining allocation parts?';
        AlreadyAskedAboutSkills: Boolean;
        AlreadyAskedAboutSequence: Boolean;
        StatusChanged: Boolean;
        AskedForAllocationSpliting: Boolean;
        Text127: Label 'Scheduled allocation does not fit into today''s (%1) remaining available time. Do you want to move the remaining part (%2 hours) to the next avaiable working time?';
        Text128: Label 'You don''t have rights to perform this action.';
        Text129: Label 'Do You want finish all started labors?';
        Text130: Label 'One or more connected entries has status %1. Do you want continue?';
        Text131: Label 'One or more line has already been scheduled for service %1 %2. Are you sure to continue?';
        Text132: Label 'Service %1 %2 has already been scheduled as a whole. Are you sure to continue?';
        Text133: Label 'You can only select lines from one document.';
        Text134: Label 'You cannot spilt this entry. This is whole order entry.';
        Text135: Label 'Working on simultaneous tasks is not allowed.';
        Text136: Label 'This labor is already planed for other resource.';
        Text137: Label 'This labor %1 is already planed for other resource. Do You want to split it?';
        Text138: Label 'You can change only finished service allocation entry';
        GlobDontModifyServLine: Boolean;
        Text139: Label 'The process is canceled. \Available resources: %1.';
        Text140: Label 'No allocation found for this document.';
        Text141: Label 'You can not post Service Header %1. Because there are unfinished Service Shedule entries.';
        Text142: Label 'You are not allow to plan this service document allocation method.';
        Text143: Label 'You can register only Service Line.';
        Text144: Label 'Labor %1 is not Call-out labor.';
        DontChangeServiceStatus: Boolean;
        LaborAllocAppType: Option " ","Service Document","Standard Event","Service Line";
        Text145: Label 'Would you like to remove resource from lines as well?';
        Text146: Label 'Please add/remove resources in Service Schedule.';
        Text147: Label 'Would you like to remove document allocations?';
        Text148: Label 'Resources for document must be entered via table.';
        SLAEfilterDataset: Record "25006271";
        isUserRightsChecked: Boolean;
        isOperAllowedChecked: Boolean;
        OperationMainCode: Integer;
        UserRightsAllowed: Boolean;
        OperAllowed: Boolean;
        Text150: Label 'Operation has stoped.';
        Text160: Label 'It is not allowed move entry outside from a resource.';
        LaborAllocEntryPrevStatus: Integer;
        ErrorStatus: Option Null,Error,ErrorNeedRefresh;
        ErrorMsgText: Text[1024];
        Text161: Label 'Do You want to cancel started labor?';
        Text162: Label 'You can only cancel labor that is in progress!';
        Text163: Label 'You can''t finish working day while there is labors on hold.';
        ServiceStepsChecking: Codeunit "33020236";
        Steps: Option CheckBay,CheckChecklist,CheckDiagnosis;
        RecRef: RecordRef;
        CountEntries: Integer;
        NoWorkflowEnabledErr: Label 'This record is not supported by related approval workflow.';

    [Scope('Internal')]
    procedure FillAllocEntryBuffer(var TempLaborAllocEntry: Record "25006271" temporary; ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        LaborAllocEntry: Record "25006271";
    begin
        LaborAllocEntry.RESET;
        LaborAllocEntry.SETCURRENTKEY("Resource No.", "Start Date-Time", "End Date-Time");
        LaborAllocEntry.SETRANGE("Resource No.", ResourceNo);
        LaborAllocEntry.SETFILTER("Start Date-Time", '<=%1', EndingDateTime);
        LaborAllocEntry.SETFILTER("End Date-Time", '>%1', StartingDateTime);
        IF LaborAllocEntry.FINDFIRST THEN
            REPEAT
                TempLaborAllocEntry := LaborAllocEntry;
                TempLaborAllocEntry.INSERT;
            UNTIL LaborAllocEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure BufferContainsSelectedEntry(var TempLaborAllocEntry: Record "25006271" temporary): Boolean
    begin
        IF TempLaborAllocEntry.FINDFIRST THEN
            REPEAT
                IF TempLaborAllocEntry."Entry No." = SingleInstanceMgt.GetAllocationEntryNo THEN
                    EXIT(TRUE);
            UNTIL TempLaborAllocEntry.NEXT = 0;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure GetMatrixCellValue(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal; CellType: Option Allocation,Capacity,Availability) CellValueText: Text[250]
    var
        TempLaborAllocEntry: Record "25006271" temporary;
        ServiceHour: Record "25006129";
        RecordCount: Integer;
    begin
        ServiceScheduleSetup.GET;

        IF CellType IN [CellType::Allocation, CellType::Availability] THEN
            FillAllocEntryBuffer(TempLaborAllocEntry, ResourceNo, StartingDateTime, EndingDateTime);

        IF CellType = CellType::Allocation THEN BEGIN
            RecordCount := TempLaborAllocEntry.COUNT;
            IF RecordCount > 1 THEN
                CellValueText := '(' + FORMAT(RecordCount) + ') ';

            IF BufferContainsSelectedEntry(TempLaborAllocEntry) THEN
                CellValueText := COPYSTR(CellValueText + GetAllocRecDescr(TempLaborAllocEntry), 1, 250)
            ELSE BEGIN
                RecordCount := 0;
                TempLaborAllocEntry.RESET;
                IF TempLaborAllocEntry.FINDFIRST THEN
                    REPEAT
                        RecordCount += 1;
                        IF RecordCount > 1 THEN
                            CellValueText := COPYSTR(CellValueText + '; ', 1, 250);

                        CellValueText := COPYSTR(CellValueText + GetAllocRecDescr(TempLaborAllocEntry), 1, 250);
                    UNTIL (TempLaborAllocEntry.NEXT = 0) OR (RecordCount = 3)
                ELSE BEGIN
                    IF ServiceScheduleSetup."Show Unavailable Time" THEN
                        IF NOT GetTimeAvailable(ResourceNo, StartingDateTime, EndingDateTime) THEN
                            CellValueText := Text001;
                END;
            END;
        END;
        IF CellType IN [CellType::Capacity, CellType::Availability] THEN BEGIN
            IF CellType = CellType::Capacity THEN
                CellValueText := FORMAT(ROUND(GetCapacity(ResourceNo, StartingDateTime, EndingDateTime), 0.01)) + ' h'
            ELSE
                CellValueText := FORMAT(ROUND(GetCapacity(ResourceNo, StartingDateTime, EndingDateTime) -
                                        GetNotAvailabilityTime(TempLaborAllocEntry, StartingDateTime, EndingDateTime), 0.01)) + ' h';
        END;

        EXIT;
    end;

    [Scope('Internal')]
    procedure GetMatrixGroupCellValue(var ResourceCodeBuffer: Record "25006270" temporary; StartingDateTime: Decimal; EndingDateTime: Decimal; CellType: Option Allocation,Capacity,Availability) CellValueText: Text[250]
    var
        TempLaborAllocEntry: Record "25006271" temporary;
        RecordCount: Integer;
        AllocatedHours: Decimal;
        StartingDateTime1: Decimal;
        EndingDateTime1: Decimal;
        GroupCode: Code[20];
        ResourceCodeBufferFilter: Record "25006270" temporary;
        CapacityHours: Decimal;
    begin
        AllocatedHours := 0;
        GroupCode := ResourceCodeBuffer.Code;

        ResourceCodeBufferFilter.COPY(ResourceCodeBuffer);
        ResourceCodeBuffer.RESET;

        IF ResourceCodeBuffer.FINDFIRST THEN
            REPEAT
                IF ResourceCodeBuffer."Applies-to Code" = GroupCode THEN BEGIN
                    TempLaborAllocEntry.DELETEALL;
                    IF CellType IN [CellType::Allocation, CellType::Availability] THEN BEGIN
                        FillAllocEntryBuffer(TempLaborAllocEntry, ResourceCodeBuffer.Code, StartingDateTime, EndingDateTime);
                        AllocatedHours += GetNotAvailabilityTime(TempLaborAllocEntry, StartingDateTime, EndingDateTime);
                    END;
                    IF CellType IN [CellType::Availability, CellType::Capacity] THEN
                        CapacityHours += GetCapacity(ResourceCodeBuffer.Code, StartingDateTime, EndingDateTime);
                END;
            UNTIL ResourceCodeBuffer.NEXT = 0;

        ResourceCodeBuffer.COPY(ResourceCodeBufferFilter);

        CASE CellType OF
            CellType::Allocation:
                BEGIN
                    CellValueText := FORMAT(ROUND(AllocatedHours, 0.01)) + ' h';  //Temporary solution
                    IF AllocatedHours = 0 THEN
                        CellValueText := '';
                END;
            CellType::Capacity:
                CellValueText := FORMAT(ROUND(CapacityHours, 0.01)) + ' h';
            CellType::Availability:
                IF CapacityHours - AllocatedHours < 0 THEN
                    CellValueText := FORMAT(0) + ' h'
                ELSE
                    CellValueText := FORMAT(ROUND(CapacityHours - AllocatedHours, 0.01)) + ' h';
        END;
        EXIT;
    end;

    [Scope('Internal')]
    procedure GetMatrixCellFormat(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal; var Bold: Boolean; var ForeColor: Integer) CellValueText: Text[250]
    var
        TempLaborAllocEntry: Record "25006271" temporary;
        RecordCount: Integer;
    begin
        FillAllocEntryBuffer(TempLaborAllocEntry, ResourceNo, StartingDateTime, EndingDateTime);

        SetCellFormat(TempLaborAllocEntry, Bold, ForeColor);
    end;

    [Scope('Internal')]
    procedure SetCellFormat(var TempLaborAllocEntry: Record "25006271" temporary; var Bold: Boolean; var ForeColor: Integer)
    var
        ColorConfig: Record "25006281";
        ServiceHdr: Record "25006145";
        ServCount: Integer;
        RecCount: Integer;
        StandardCount: Integer;
    begin
        ColorConfig.RESET;
        RecCount := TempLaborAllocEntry.COUNT;
        IF RecCount = 0 THEN
            EXIT;
        IF BufferContainsSelectedEntry(TempLaborAllocEntry) THEN
            ColorConfig.SETRANGE("Active Allocation", TRUE)
        ELSE
            ColorConfig.SETRANGE("Active Allocation", FALSE);

        IF RecCount > 1 THEN BEGIN
            ColorConfig.SETRANGE("Mixed Allocation", TRUE);
            IF ColorConfig.FINDFIRST THEN BEGIN
                Bold := ColorConfig."Font Bold";
                ForeColor := ColorConfig."Font Color";
                EXIT;
            END;
            ColorConfig.SETRANGE("Mixed Allocation", FALSE);
        END ELSE
            ColorConfig.SETRANGE("Mixed Allocation", FALSE);

        IF NOT TempLaborAllocEntry.GET(SingleInstanceMgt.GetAllocationEntryNo) THEN
            TempLaborAllocEntry.FINDFIRST;

        ColorConfig.SETRANGE("Source Type", TempLaborAllocEntry."Source Type");
        ColorConfig.SETRANGE("Source Subtype", TempLaborAllocEntry."Source Subtype");
        IF ServiceHdr.GET(TempLaborAllocEntry."Source Subtype", TempLaborAllocEntry."Source ID") THEN;
        ColorConfig.SETFILTER("Work Status", '%1|''''', ServiceHdr."Work Status Code");
        ColorConfig.SETRANGE(Status, TempLaborAllocEntry.Status);
        IF ColorConfig.FINDLAST THEN BEGIN
            Bold := ColorConfig."Font Bold";
            ForeColor := ColorConfig."Font Color";
        END;
    end;

    [Scope('Internal')]
    procedure SetCellFormatRTC(var LaborAllocEntry: Record "25006271"; var ForeColor: Integer; var BackColor: Integer)
    var
        ColorConfig: Record "25006281";
        ServiceHeader: Record "25006145";
        ServLaborAllocationApplication: Record "25006277";
        PostedServiceHeader: Record "25006149";
        PostedServRetOrderHeader: Record "25006154";
    begin
        IF LaborAllocEntry."Allocation Status" = LaborAllocEntry."Allocation Status"::Unavailability THEN BEGIN
            ServiceScheduleSetup.GET;
            ForeColor := 0; //Black
            BackColor := 16777215; //White
            EXIT;
        END;

        ForeColor := 0; //Black
        BackColor := 16777215; //White

        ColorConfig.RESET;
        //ColorConfig.SETRANGE("Active Allocation", FALSE);
        //ColorConfig.SETRANGE("Mixed Allocation", FALSE);

        ColorConfig.SETRANGE("Source Type", LaborAllocEntry."Source Type");
        ColorConfig.SETRANGE("Source Subtype", LaborAllocEntry."Source Subtype");

        IF LaborAllocEntry."Source Type" = LaborAllocEntry."Source Type"::"Service Document" THEN BEGIN
            IF (NOT ServiceHeader.GET(LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID")) AND
               (NOT PostedServiceHeader.GET(LaborAllocEntry."Source ID")) THEN
                EXIT;
            IF LaborAllocEntry."Source Subtype" = LaborAllocEntry."Source Subtype"::Order THEN BEGIN
                //ServLaborAllocationApplication.RESET;
                //ServLaborAllocationApplication.SETRANGE("Document Type",ServLaborAllocationApplication."Document Type"::Order);
                //ServLaborAllocationApplication.SETRANGE(Posted,TRUE);
                //IF ServLaborAllocationApplication.FINDFIRST THEN
                //  ColorConfig.SETRANGE("Source Subtype", ColorConfig."Source Subtype"::"Posted Order");
                IF PostedServiceHeader.GET(LaborAllocEntry."Source ID") THEN
                    ColorConfig.SETRANGE("Source Subtype", ColorConfig."Source Subtype"::"Posted Order");
            END;
            IF LaborAllocEntry."Source Subtype" = LaborAllocEntry."Source Subtype"::"Return Order" THEN BEGIN
                IF PostedServRetOrderHeader.GET(LaborAllocEntry."Source ID") THEN
                    ColorConfig.SETRANGE("Source Subtype", ColorConfig."Source Subtype"::"Posted Return Order");
            END;
        END;



        ColorConfig.SETFILTER("Work Status", '%1|''''', ServiceHeader."Work Status Code");



        ColorConfig.SETRANGE(Status, LaborAllocEntry.Status);

        IF ColorConfig.FINDLAST THEN BEGIN
            ForeColor := ColorConfig."Font Color";
            BackColor := ColorConfig."Background Color";
        END;
    end;

    [Scope('Internal')]
    procedure SetResourceColor(ResourceNo: Code[20]; var ForeColor: Integer)
    var
        WorkTimeEntry: Record "25006276";
    begin
        ServiceScheduleSetup.GET;

        WorkTimeEntry.RESET;
        WorkTimeEntry.SETCURRENTKEY("Resource No.", Closed);
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF WorkTimeEntry.FINDFIRST THEN
            ForeColor := ServiceScheduleSetup."Working Resource Color"
        ELSE
            ForeColor := ServiceScheduleSetup."Non-Working Resource Color";
    end;

    [Scope('Internal')]
    procedure SetDateColor(DateFilter: Date; var ForeColor: Integer; var UpdateBold: Boolean)
    var
        CheckDescription: Text[50];
        Day: Integer;
        ServiceHour: Record "25006129";
    begin
        Day := DATE2DWY(DateFilter, 1) - 1;
        ServiceHour.RESET;
        ServiceHour.SETRANGE(Day, Day);
        IF NOT ServiceHour.FINDFIRST THEN BEGIN
            //ForeColor := ServiceScheduleSetup."Nonworking Day Color";
            UpdateBold := TRUE;
        END;
    end;

    [Scope('Internal')]
    procedure GetAllocRecDescr(var LaborAllocEntry: Record "25006271") RecordDesr: Text[250]
    begin
        IF LaborAllocEntry."Entry No." <> 0 THEN
            RecordDesr := COPYSTR(CreateFieldText(LaborAllocEntry."Entry No."), 1, 250);

        IF RecordDesr = '' THEN
            RecordDesr := LaborAllocEntry."Source ID";
    end;

    [Scope('Internal')]
    procedure SelectAllocation(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        TempLaborAllocEntry: Record "25006271" temporary;
        RecordCount: Integer;
    begin
        IF NOT CheckUserRightsAdv(1, TempLaborAllocEntry) THEN EXIT;
        ScheduleAction := ScheduleAction::Planning;

        FillAllocEntryBuffer(TempLaborAllocEntry, ResourceNo, StartingDateTime, EndingDateTime);
        RecordCount := TempLaborAllocEntry.COUNT;

        IF RecordCount = 0 THEN
            EXIT;

        IF RecordCount = 1 THEN BEGIN
            TempLaborAllocEntry.FINDFIRST;
            SelectAllocationEntry(TempLaborAllocEntry."Entry No.")
        END ELSE //RecordCount > 1
            IF PAGE.RUNMODAL(PAGE::"Serv. Labor Allocation Entries", TempLaborAllocEntry) = ACTION::LookupOK THEN
                SelectAllocationEntry(TempLaborAllocEntry."Entry No.");
    end;

    [Scope('Internal')]
    procedure Deallocate(EntryNo: Integer)
    var
        LaborAllocEntryLoc: Record "25006271";
    begin
        ScheduleAction := ScheduleAction::Planning;

        //EntryNo := SingleInstanceMgt.GetAllocationEntryNo;

        IF NOT LaborAllocEntryLoc.GET(EntryNo) THEN BEGIN
            MESSAGE(Text121);
            EXIT;
        END;
        IF NOT CheckUserRightsAdv(2, LaborAllocEntryLoc) THEN EXIT;

        IF LaborAllocEntryLoc.Status IN [LaborAllocEntryLoc.Status::"In Progress", LaborAllocEntryLoc.Status::Finished] THEN
            DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, EntryNo, 11111)
        ELSE BEGIN
            IF SplitAllocTracking(EntryNo, 1) THEN
                DeallocateIncSplit(EntryNo, TRUE)
            ELSE
                DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, EntryNo, 11111)
        END;
    end;

    [Scope('Internal')]
    procedure DeallocateIncSplit(EntryNo: Integer; DeleteAll: Boolean)
    var
        LaborAllocEntryTemp: Record "25006271" temporary;
        LaborEntry: Integer;
        ReplanOtherEntries: Boolean;
        ProceedMode: Integer;
    begin
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 0);  //15.08.2013 EDMS P8
        LaborAllocEntryTemp.RESET;
        LaborAllocEntryTemp.SETCURRENTKEY("Resource No.", "End Date-Time");


        IF LaborAllocEntryTemp.FINDFIRST THEN BEGIN
            REPEAT
                DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntryTemp."Entry No.", 10000)
            UNTIL LaborAllocEntryTemp.NEXT = 0;
            LaborAllocEntryTemp.FINDLAST;
            REPEAT
                ProceedMode := 1110;
                IF LaborAllocEntryTemp.COUNT = 1 THEN
                    ProceedMode := 1111;
                IF DeleteAll THEN BEGIN
                    DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntryTemp."Entry No.", ProceedMode)
                END ELSE
                    IF LaborAllocEntryTemp."Entry No." <> EntryNo THEN
                        DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntryTemp."Entry No.", ProceedMode);
            UNTIL LaborAllocEntryTemp.NEXT(-1) = 0;
        END;
    end;

    [Scope('Internal')]
    procedure MoveAllocation(EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal)
    var
        ServiceLine: Record "25006146" temporary;
        ServiceLine2: Record "25006146";
        LaborAllocAppTemp: Record "25006277" temporary;
        AllocationForm: Page "25006369";
    begin
        CLEAR(AllocationForm);
        IF NOT LaborAllocEntry.GET(EntryNo) THEN BEGIN
            MESSAGE(Text121);
            EXIT;
        END;
        IF NOT CheckUserRightsAdv(300, LaborAllocEntry) THEN EXIT;


        AllocationForm.SetParam(EntryNo, NewResourceNo, NewStartingDateTime, LaborAllocEntry."Quantity (Hours)",
          LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID", 1, ServiceLine, 0);

        AllocationForm.LOOKUPMODE(TRUE);  //03.04.2013 P8
        COMMIT;  //28.06.2013 EDMS P8
        AllocationForm.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure StartEndAllocation(AllocationStatus1: Option Pending,"In Progress","Finish All","Finish Part","On Hold")
    var
        WorkTimeEntry: Record "25006276";
        LaborAllocEntryTemp: Record "25006271" temporary;
        LaborAllocEntryLoc: Record "25006271";
        CurrDateTime: Decimal;
        HoldHours: Decimal;
        StartFinishAllocation: Page "25006355";
    begin
        CLEAR(StartFinishAllocation);
        IF NOT LaborAllocEntry.GET(SingleInstanceMgt.GetAllocationEntryNo) THEN BEGIN
            MESSAGE(Text121);
            EXIT;
        END;
        IF NOT CheckUserRightsAdv(1, LaborAllocEntry) THEN EXIT;

        CurrDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);

        IF AllocationStatus1 = AllocationStatus1::"In Progress" THEN BEGIN
            IF LaborAllocEntry.Status = LaborAllocEntry.Status::Finished THEN
                ERROR(Text109);
            IF LaborAllocEntry.Status = LaborAllocEntry.Status::"In Progress" THEN
                ERROR(Text110);
        END;

        IF AllocationStatus1 IN [AllocationStatus1::"Finish All", AllocationStatus1::"Finish Part", AllocationStatus1::"On Hold"] THEN BEGIN
            IF LaborAllocEntry.Status <> LaborAllocEntry.Status::"In Progress" THEN
                ERROR(Text111);
        END;

        StartFinishAllocation.SetParam(LaborAllocEntry."Resource No.", CurrDateTime, LaborAllocEntry."Quantity (Hours)",
                                 LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID",
                                 AllocationStatus1, HoldHours);
        StartFinishAllocation.LOOKUPMODE(TRUE);  //03.04.2013 P8
        COMMIT;  //28.06.2013 EDMS P8
        StartFinishAllocation.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure StartEndWorktime(ResourceNo: Code[20]; Status: Option Start,"End")
    var
        CurrDateTime: Decimal;
        WorktimeRegistration: Page "25006353";
        PageAction: Action;
    begin
        IF NOT CheckUserRightsAdv(1, LaborAllocEntry) THEN EXIT;

        CurrDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);
        CLEAR(WorktimeRegistration);
        WorktimeRegistration.SetParam(ResourceNo, CurrDateTime, Status);
        WorktimeRegistration.LOOKUPMODE(TRUE);  //03.04.2013 P8
        COMMIT;  //28.06.2013 EDMS P8
        WorktimeRegistration.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure CalcEndDTOnlyWorktime(StartDT: Decimal; EndDT: Decimal; NewResNo: Code[20]) RetValue: Decimal
    var
        DateRec: Record "2000000007";
        UnavailAllocEntry: Record "25006271" temporary;
        DateTimeMgt: Codeunit "25006012";
        CurrDT: Decimal;
        NewCurrDT: Decimal;
        UnavailAllocEntryCount: Integer;
        CurrRecIndex: Integer;
    begin
        UnavailAllocEntry.RESET;
        UnavailAllocEntry.DELETEALL;
        RetValue := EndDT;
        IF ServiceScheduleSetup."Show Unavailable Time" THEN BEGIN
            DateRec.RESET;
            DateRec.SETRANGE("Period Type", DateRec."Period Type"::Date);
            DateRec.SETRANGE("Period Start", DateTimeMgt.Datetime2Date(StartDT), DateTimeMgt.Datetime2Date(EndDT));
            IF DateRec.FINDFIRST THEN
                REPEAT
                    FillUnavailableTimeEntries(UnavailAllocEntry, NewResNo,
                                                                  DateRec."Period Start");
                UNTIL DateRec.NEXT = 0;
            CurrDT := StartDT;
            UnavailAllocEntryCount := UnavailAllocEntry.COUNT;
            IF UnavailAllocEntryCount > 1 THEN BEGIN
                CurrRecIndex := 1;
                UnavailAllocEntry.FINDFIRST;
                WHILE ((CurrDT < EndDT) AND (CurrRecIndex <= UnavailAllocEntryCount)) DO BEGIN
                    IF (UnavailAllocEntry."Start Date-Time" <= CurrDT) AND (CurrDT <= UnavailAllocEntry."End Date-Time") THEN BEGIN
                        IF (UnavailAllocEntry."End Date-Time" > EndDT) THEN BEGIN
                            NewCurrDT := EndDT;
                        END ELSE BEGIN
                            NewCurrDT := UnavailAllocEntry."End Date-Time";
                        END;
                        RetValue -= (NewCurrDT - CurrDT);
                        RetValue -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond
                    END ELSE BEGIN
                        IF (UnavailAllocEntry."Start Date-Time" >= CurrDT) AND (CurrDT <= UnavailAllocEntry."End Date-Time") THEN BEGIN
                            IF (UnavailAllocEntry."Start Date-Time" >= EndDT) THEN BEGIN
                                NewCurrDT := EndDT;
                            END ELSE BEGIN
                                CurrDT := UnavailAllocEntry."Start Date-Time";
                                IF (UnavailAllocEntry."End Date-Time" > EndDT) THEN
                                    NewCurrDT := EndDT
                                ELSE
                                    NewCurrDT := UnavailAllocEntry."End Date-Time";
                                RetValue -= (NewCurrDT - CurrDT);
                                RetValue -= DateTimeMgt.Datetime(0D, 000000.001T); //minus one millisecond
                            END;
                        END ELSE BEGIN
                            NewCurrDT := CurrDT;
                            RetValue -= 0;
                        END;
                    END;
                    CurrDT := NewCurrDT;
                    CurrRecIndex += 1;
                    UnavailAllocEntry.NEXT;
                END;
            END;
        END;

        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure BreakAllocation()
    var
        CurrDateTime: Decimal;
        AllocationForm: Page "25006369";
    begin
        CurrDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);

        IF NOT LaborAllocEntry.GET(SingleInstanceMgt.GetAllocationEntryNo) THEN BEGIN
            MESSAGE(Text121);
            EXIT;
        END;

        IF NOT CheckUserRightsAdv(4, LaborAllocEntry) THEN EXIT;


        AllocationForm.SetParam(LaborAllocEntry."Entry No.", LaborAllocEntry."Resource No.", CurrDateTime,
          LaborAllocEntry."Quantity (Hours)",
          LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID", 3, ServiceLine, 0);
        AllocationForm.LOOKUPMODE(TRUE);  //03.04.2013 P8
        COMMIT;  //28.06.2013 EDMS P8
        AllocationForm.RUNMODAL;

        //END;//30.10.2012 EDMS
    end;

    [Scope('Internal')]
    procedure ProcessMovement(EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; SplitTracking1: Option No,Yes; NewStatus: Option Pending,"In Process",Finished,"On Hold"; Operation: Integer; Travel: Boolean)
    var
        LaborAllocEntryTemp: Record "25006271" temporary;
        OldResourceNo: Code[20];
        OldStartingDateTime: Decimal;
        OldEndingDateTime: Decimal;
        OldHours: Decimal;
        DoReplan: Boolean;
        MainAllocEntrNo: Integer;
    begin
        // Operation codes:
        // -1 UNDEFINED
        // 0 view; 1 - time registration; 2 - Planning; 3 - Reallocate (manager); 4 - BREAK; 100 - allocate lines; 110 - allocate header; 120 - ALLOCATE standart event
        // 200 - spliting
        // 300 - move; 310 - change end time of finished
        // 400 - delete entry
        ScheduleAction := ScheduleAction::Planning;
        SplitTracking := SplitTracking1;
        LaborAllocEntry.GET(EntryNo);
        IF Operation < 0 THEN
            Operation := 300;
        IF NOT CheckUserRightsAdv(Operation, LaborAllocEntry) THEN EXIT;

        OldResourceNo := LaborAllocEntry."Resource No.";
        IF NOT (Resource.GET(NewResourceNo)) THEN BEGIN
            NewResourceNo := OldResourceNo;
            IF NOT (Resource.GET(NewResourceNo)) THEN
                ERROR(Text160);
        END;
        OldStartingDateTime := LaborAllocEntry."Start Date-Time";
        OldEndingDateTime := LaborAllocEntry."End Date-Time";
        OldHours := LaborAllocEntry."Quantity (Hours)";
        DoReplan := TRUE;

        ServiceScheduleSetup.GET;

        IF SplitAllocTracking(EntryNo, 0) THEN BEGIN
            MainAllocEntrNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
            //MESSAGE('msg in processmovement 01');
            MovementIncSplit(EntryNo, NewResourceNo, NewStartingDateTime, NewQtyToAllocate, NewStatus);
            // in routine MovementIncSplit is deleted EntryNo, then need continue with MainAllocEntrNo
            EntryNo := MainAllocEntrNo;
        END ELSE BEGIN
            WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,
                                   LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                   LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, NewStatus, FALSE, Travel);

            IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
                JoinAllocationEntries(NewResourceNo, NewStartingDateTime);

            IF NewResourceNo <> OldResourceNo THEN BEGIN  //replan old resource entries
                ReplanEntries(OldResourceNo, OldEndingDateTime, -OldHours, FALSE, 0, '');

                IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
                    JoinAllocationEntries(OldResourceNo, OldStartingDateTime);
            END;
        END;
        //Adjust Related entries
        SynchroniseRelatedEntries(EntryNo);
    end;

    [Scope('Internal')]
    procedure ProcessMovementApp(var ServLaborAllocApplicationPar: Record "25006277"; EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; SplitTracking1: Option No,Yes) MainAllocEntrNo: Integer
    var
        LaborAllocEntryTemp: Record "25006271" temporary;
        OldResourceNo: Code[20];
        OldStartingDateTime: Decimal;
        OldEndingDateTime: Decimal;
        OldHours: Decimal;
        DoReplan: Boolean;
        ResourceTmp: Record "156" temporary;
        Resource: Record "156";
        ServLaborAllocEntryTmp: Record "25006271" temporary;
        PreviousAllocEntryNo: Integer;
    begin
        // at first create new entries
        LaborAllocEntry.GET(EntryNo);
        ResourceTmp.RESET;
        ResourceTmp.DELETEALL;
        IF ServLaborAllocApplicationPar.FINDFIRST THEN
            REPEAT
                //Ùeit vai nu ar setrange atrast vai tÙds jau existÙ, vai pirms tam jau padot arÙ existÙjoÙas rindas ar pareizu LineNo.
                LaborAllocApp.RESET;
                LaborAllocApp.SETRANGE("Allocation Entry No.", ServLaborAllocApplicationPar."Allocation Entry No.");
                LaborAllocApp.SETRANGE("Document Type", ServLaborAllocApplicationPar."Document Type");
                LaborAllocApp.SETRANGE("Document No.", ServLaborAllocApplicationPar."Document No.");
                LaborAllocApp.SETRANGE("Document Line No.", ServLaborAllocApplicationPar."Document Line No.");
                LaborAllocApp.SETRANGE("Resource No.", ServLaborAllocApplicationPar."Resource No.");
                //IF NOT LaborAllocApp.GET("Allocation Entry No.", "Document Type", "Document No.", "Document Line No.","Line No.") THEN BEGIN
                IF NOT LaborAllocApp.FINDFIRST THEN BEGIN
                    IF NOT ResourceTmp.GET(ServLaborAllocApplicationPar."Resource No.") THEN BEGIN
                        IF Resource.GET(ServLaborAllocApplicationPar."Resource No.") THEN BEGIN
                            ResourceTmp := Resource;
                            ResourceTmp.INSERT;
                        END;
                    END;
                END;
            UNTIL ServLaborAllocApplicationPar.NEXT = 0;
        //'NewStartingDateTime:'+FORMAT(NewStartingDateTime)+', NewQtyToAllocate:'+FORMAT(NewQtyToAllocate)); //
        IF ResourceTmp.FINDFIRST THEN BEGIN
            MainAllocEntrNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
            FindSplitEntries(MainAllocEntrNo, ServLaborAllocEntryTmp, 0, 1111);
            PreviousAllocEntryNo := 0;
            REPEAT
                ServLaborAllocEntryTmp.FINDFIRST;
                REPEAT
                    PreviousAllocEntryNo := AddResourceToAllocEntry(ServLaborAllocEntryTmp, LaborAllocApp,
                      ResourceTmp."No.", PreviousAllocEntryNo, LaborAllocEntry, LaborAllocApp);
                UNTIL ServLaborAllocEntryTmp.NEXT = 0;
            UNTIL ResourceTmp.NEXT = 0;
        END;
        ProcessMovement(EntryNo, NewResourceNo, NewStartingDateTime, NewQtyToAllocate, SplitTracking1, LaborAllocEntry.Status, -1, LaborAllocEntry.Travel);
        EXIT(MainAllocEntrNo);
    end;

    [Scope('Internal')]
    procedure MovementIncSplit(EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; NewStatus: Integer)
    var
        ServLaborAllocEntryTmp: Record "25006271" temporary;
        ServLaborAllocApplication: Record "25006277";
        ServiceLineLoc: Record "25006146" temporary;
        NewSourceID: Code[20];
        NewSourceType: Option ,"Service Document","Standard Event";
        NewSourceSubType: Option Qoute,"Order";
        NewTotalHours: Decimal;
        DoReplan: Boolean;
        RecalcQtyToAllocate: Decimal;
        QtyToMove: Decimal;
        OldStartingDateTime: Decimal;
        MainAllocEntrNo: Integer;
        Travel: Boolean;
    begin
        ServiceScheduleSetup.GET;

        LaborAllocEntry.GET(EntryNo);
        Travel := LaborAllocEntry.Travel;
        NewSourceType := LaborAllocEntry."Source Type";
        NewSourceSubType := LaborAllocEntry."Source Subtype";
        NewSourceID := LaborAllocEntry."Source ID";
        //NewStatus := LaborAllocEntry.Status;
        DoReplan := FALSE;

        ServiceLineLoc.DELETEALL;
        IF LaborAllocEntry."Source Type" = LaborAllocEntry."Source Type"::"Service Document" THEN BEGIN
            LaborAllocApp.RESET;
            LaborAllocApp.SETRANGE("Allocation Entry No.", LaborAllocEntry."Entry No.");
            IF LaborAllocApp.FINDFIRST THEN
                REPEAT
                    FillServiceLine2(ServiceLineLoc, LaborAllocApp."Document Type", LaborAllocApp."Document No.",
                      LaborAllocApp."Document Line No.");
                UNTIL LaborAllocApp.NEXT = 0;
        END;

        RecalcQtyToAllocate := 0;
        FindSplitEntries(EntryNo, ServLaborAllocEntryTmp, 0, 0);  //15.08.2013 EDMS P8
        IF ServLaborAllocEntryTmp.FINDFIRST THEN BEGIN
            REPEAT
                IF ServLaborAllocEntryTmp."Entry No." = EntryNo THEN
                    RecalcQtyToAllocate += NewQtyToAllocate
                ELSE
                    RecalcQtyToAllocate += ServLaborAllocEntryTmp."Quantity (Hours)";
            UNTIL ServLaborAllocEntryTmp.NEXT = 0;
        END;

        OldStartingDateTime := LaborAllocEntry."Start Date-Time";
        QtyToMove := NewStartingDateTime - OldStartingDateTime;
        //lets first split part will be as start point
        MainAllocEntrNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
        EntryNo := MainAllocEntrNo;
        LaborAllocEntry.GET(EntryNo);
        NewStartingDateTime := LaborAllocEntry."Start Date-Time" + QtyToMove;
        //MESSAGE('msg in movement 0');

        DeallocateIncSplit(EntryNo, FALSE);

        //MESSAGE('msg in movement 1');
        ClearAllocationEntry(EntryNo, FALSE);

        //MESSAGE('msg in movement 2');
        ServiceLineLoc.RESET;
        IF ServiceLineLoc.FINDFIRST THEN
            REPEAT
                FillServiceLine2(ServiceLine, ServiceLineLoc."Document Type", ServiceLineLoc."Document No.", ServiceLineLoc."Line No.");
            UNTIL ServiceLineLoc.NEXT = 0;


        WriteAllocationEntries(NewResourceNo, NewStartingDateTime, RecalcQtyToAllocate,
                               NewSourceType, NewSourceSubType, NewSourceID, 1, EntryNo, DoReplan, NewStatus, FALSE, Travel);


        IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
            JoinAllocationEntries(NewResourceNo, NewStartingDateTime);
    end;

    [Scope('Internal')]
    procedure AllocateStandardEvent(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        StandardEvents: Page "25006357";
        StandardEvent: Record "25006272";
        ServLine: Record "25006146";
    begin
        IF NOT CheckUserRightsAdv(2, LaborAllocEntry) THEN EXIT;

        CLEAR(StandardEvents);

        StandardEvents.LOOKUPMODE(TRUE);

        IF StandardEvents.RUNMODAL = ACTION::LookupOK THEN BEGIN
            StandardEvents.GETRECORD(StandardEvent);
            Allocate(ResourceNo, StartingDateTime, 0, 2, 0, StandardEvent.Code, ServLine, 0);
        END
        ELSE
            EXIT;
    end;

    [Scope('Internal')]
    procedure AllocateServiceLines(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        ServiceLinesAllocation: Page "25006354";
        ServiceLine: Record "25006146";
        ServiceLine2: Record "25006146";
        ServiceHdr: Record "25006145";
        WhatAllocation: Option Header,Line;
        NewLineNo: Integer;
    begin
        IF NOT CheckUserRightsAdv(100, LaborAllocEntry) THEN EXIT;

        CLEAR(ServiceLinesAllocation);

        ServiceLinesAllocation.LOOKUPMODE(TRUE);

        IF ServiceLinesAllocation.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ServiceLinesAllocation.SetSelectionFilter1(ServiceLine);
            CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, WhatAllocation::Line);

            ServiceLine2.CLEARMARKS;
            IF ServiceLine.FINDFIRST THEN
                REPEAT
                    NewLineNo := ServiceLine."Line No.";
                    IF NOT CheckServiceLineResource(ServiceLine."Document Type", ServiceLine."Document No.",
                        ServiceLine.Type, ServiceLine."Line No.", 1, ResourceNo) THEN BEGIN
                        IF CONFIRM(STRSUBSTNO(Text137, ServiceLine."No.")) THEN
                            NewLineNo := SplitServiceLine(ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.");
                    END;
                    ServiceLine2.GET(ServiceLine."Document Type", ServiceLine."Document No.", NewLineNo);
                    ServiceLine2.MARK(TRUE);
                UNTIL ServiceLine.NEXT = 0;
            COMMIT;
            ServiceLine2.MARKEDONLY(TRUE);

            IF ServiceLine2.FINDFIRST THEN
                Allocate(ResourceNo, StartingDateTime, 0, 1, ServiceLine2."Document Type", ServiceLine2."Document No.", ServiceLine2, 0);
        END
        ELSE
            EXIT;
    end;

    [Scope('Internal')]
    procedure AllocateServiceOrder(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        ServiceHdrsAllocation: Page "25006356";
        ServiceHdr: Record "25006145";
        ServiceLineLoc: Record "25006146" temporary;
        WhatAllocation: Option Header,Line;
    begin
        IF NOT CheckUserRightsAdv(110, LaborAllocEntry) THEN EXIT;

        CLEAR(ServiceHdrsAllocation);
        ServiceHdrsAllocation.LOOKUPMODE(TRUE);

        IF ServiceHdrsAllocation.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ServiceHdrsAllocation.GETRECORD(ServiceHdr);
            CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, WhatAllocation::Header);
            ServiceLine.SETRANGE("Document Type", ServiceHdr."Document Type");
            ServiceLine.SETRANGE("Document No.", ServiceHdr."No.");
            ServiceLine.SETRANGE("Line No.", 0);
            Allocate(ResourceNo, StartingDateTime, 0, 1, ServiceHdr."Document Type", ServiceHdr."No.", ServiceLine, 0);
        END
        ELSE
            EXIT;
    end;

    [Scope('Internal')]
    procedure AllocateEventAndStart(ResourceNo: Code[20])
    var
        StandardEvents: Page "25006357";
        AllocationForm: Page "25006379";
        StandardEvent: Record "25006272";
        ServLine: Record "25006146";
        StartingDateTime: Decimal;
    begin
        IF NOT CheckUserRightsAdv(1, LaborAllocEntry) THEN EXIT;

        StartingDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);
        CLEAR(StandardEvents);

        StandardEvents.LOOKUPMODE(TRUE);

        IF StandardEvents.RUNMODAL = ACTION::LookupOK THEN BEGIN
            StandardEvents.GETRECORD(StandardEvent);
            CLEAR(AllocationForm);
            AllocationForm.SetParam(ResourceNo, StartingDateTime, 2, 0, StandardEvent.Code);
            AllocationForm.LOOKUPMODE(TRUE);
            COMMIT;  //28.06.2013 EDMS P8
            AllocationForm.RUNMODAL;
        END
        ELSE
            EXIT;
    end;

    [Scope('Internal')]
    procedure Allocate(ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option ,"Service Document","Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; var ServiceLine1: Record "25006146"; ForceStatus: Integer): Boolean
    var
        AllocationForm: Page "25006369";
        LaborAllocAppTemp: Record "25006277" temporary;
    begin
        CLEAR(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartingDateTime, QtyToAllocate, SourceType, SourceSubType, SourceID, 0, ServiceLine1, ForceStatus);
        AllocationForm.SETTABLEVIEW := LaborAllocAppTemp;
        AllocationForm.LOOKUPMODE(TRUE);  //03.04.2013 P8
        COMMIT;  //28.06.2013 EDMS P8
        AllocationForm.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure AllocateNewVisitQuote(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        ServiceHdr: Record "25006145";
        ServiceLineLoc: Record "25006146" temporary;
        WhatAllocation: Option Header,Line;
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Return Order";
    begin
        IF NOT CheckUserRightsAdv(110, LaborAllocEntry) THEN EXIT;

        DocumentNo := CreateNewServiceDocument(ServiceHdr."Document Type"::Quote);
        ServiceHdr.SETRANGE("Document Type", ServiceHdr."Document Type"::Quote);
        ServiceHdr.SETRANGE("No.", DocumentNo);
        IF ServiceHdr.FINDFIRST THEN BEGIN
            CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, WhatAllocation::Header);
            Allocate(ResourceNo, StartingDateTime, 0, 1, ServiceHdr."Document Type", ServiceHdr."No.", ServiceLine, 0);
        END ELSE
            EXIT;
    end;

    [Scope('Internal')]
    procedure AllocateNewVisitOrder(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal)
    var
        ServiceHdr: Record "25006145";
        ServiceLineLoc: Record "25006146";
        WhatAllocation: Option Header,Line;
        DocumentNo: Code[20];
        DocumentType: Option Quote,"Order","Return Order";
    begin
        IF NOT CheckUserRightsAdv(110, LaborAllocEntry) THEN EXIT;

        DocumentNo := CreateNewServiceDocument(ServiceHdr."Document Type"::Order);
        ServiceHdr.SETRANGE("Document Type", ServiceHdr."Document Type"::Order);
        ServiceHdr.SETRANGE("No.", DocumentNo);
        IF ServiceHdr.FINDFIRST THEN BEGIN
            //22.03.2014 Elva Baltic P1 #X01 MMG7.00 >>
            //CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, WhatAllocation::Header);
            ServiceLineLoc.RESET;
            ServiceLineLoc.SETRANGE("Document Type", ServiceLineLoc."Document Type"::Order);
            ServiceLineLoc.SETRANGE("Document No.", DocumentNo);
            ServiceLineLoc.SETRANGE(Type, ServiceLineLoc.Type::Labor); //06.04.2014 Elva Baltic P1 #X01 MMG7.00
                                                                       //CheckForCorrectServHeaderLine(ServiceHdr, ServiceLine, WhatAllocation::Line); //09.04.2014 Elva Baltic P1 #X01 MMG7.00
            CheckForCorrectServHeaderLine(ServiceHdr, ServiceLineLoc, WhatAllocation::Line); //09.04.2014 Elva Baltic P1 #X01 MMG7.00
                                                                                             //22.03.2014 Elva Baltic P1 #X01 MMG7.00 <<
            Allocate(ResourceNo, StartingDateTime, 0, 1, ServiceHdr."Document Type", ServiceHdr."No.", ServiceLineLoc, 0);
        END ELSE
            EXIT;
    end;

    [Scope('Internal')]
    procedure ProcessAllocation(ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option " ","Service Document","Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; var ServiceLine1: Record "25006146"; DivideIntoLines: Boolean; ForceStatus1: Option Pending,"In Progress",Finished,"On Hold",Cancelled; TravelPar: Boolean)
    var
        ServiceLine2: Record "25006146" temporary;
        ServiceHours: Decimal;
        QtyToAllocate2: Decimal;
        JoinStartingDateTime: Decimal;
        RecCount: Integer;
        EntryNo: Integer;
        DoReplan: Boolean;
    begin
        //21.11.2013 EDMS P8
        CASE SourceType OF
            SourceType::"Service Document":
                BEGIN
                    IF ServiceLine1."Line No." > 0 THEN BEGIN
                        IF NOT CheckUserRightsAdv(100, LaborAllocEntry) THEN EXIT;
                    END ELSE
                        IF NOT CheckUserRightsAdv(110, LaborAllocEntry) THEN EXIT;
                END;
            SourceType::"Standard Event":
                IF NOT CheckUserRightsAdv(120, LaborAllocEntry) THEN
                    EXIT;
            ELSE
                IF NOT CheckUserRightsAdv(100, LaborAllocEntry) THEN EXIT;
        END;

        ServiceScheduleSetup.GET;
        ScheduleAction := ScheduleAction::Planning;
        DoReplan := TRUE;

        JoinStartingDateTime := StartingDateTime;
        IF NOT DivideIntoLines THEN BEGIN
            FillServiceLine(ServiceLine1);
            WriteAllocationEntries(ResourceNo, StartingDateTime, QtyToAllocate, SourceType, SourceSubType, SourceID, 0, 0, DoReplan, ForceStatus1, FALSE, TravelPar);
        END ELSE BEGIN
            RecCount := ServiceLine1.COUNT;
            IF ServiceLine1.FINDFIRST THEN
                REPEAT
                    ServiceHours += ServiceLine1.GetTimeQty;
                UNTIL ServiceLine1.NEXT = 0;

            EntryNo := 0;
            IF ServiceLine1.FINDFIRST THEN
                REPEAT
                    ServiceLine2.RESET;
                    ServiceLine2.DELETEALL;
                    IF ServiceLine1.Quantity <> 0 THEN BEGIN
                        ServiceLine2 := ServiceLine1;
                        ServiceLine2.INSERT;
                        FillServiceLine(ServiceLine2);
                        QtyToAllocate2 := ROUND((ServiceLine2.GetTimeQty / ServiceHours) * QtyToAllocate, 0.001);
                        WriteAllocationEntries(ResourceNo, StartingDateTime, QtyToAllocate2, SourceType, ServiceLine2."Document Type",
                                               ServiceLine2."Document No.", 0, 0, DoReplan, ForceStatus1, FALSE, TravelPar);
                        StartingDateTime := LaborAllocEntry."End Date-Time";
                        EntryNo := LaborAllocEntry."Entry No.";
                    END;
                UNTIL ServiceLine1.NEXT = 0;
        END;

        IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
            JoinAllocationEntries(ResourceNo, JoinStartingDateTime);
    end;

    [Scope('Internal')]
    procedure ProcessAllocationResources(var ResourceTmp: Record "156" temporary; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option " ","Service Document","Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; var ServiceLine1: Record "25006146"; DivideIntoLines: Boolean; ForceStatus1: Option Pending,"In Progress",Finished,"On Hold",Cancelled; TravelPar: Boolean) MainAllocEntrNo: Integer
    var
        ServLaborAllocEntryTmp: Record "25006271" temporary;
        PreviousAllocEntryNo: Integer;
        TextNoRecords: Label 'No Resource to process, so no entry is generated.';
    begin
        IF ResourceTmp.FINDFIRST THEN BEGIN
            ProcessAllocation(ResourceTmp."No.", StartingDateTime, QtyToAllocate, SourceType, SourceSubType,
              SourceID, ServiceLine1, DivideIntoLines, ForceStatus1, TravelPar);
            MainAllocEntrNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
            FindSplitEntries(MainAllocEntrNo, ServLaborAllocEntryTmp, 0, 1111);
            PreviousAllocEntryNo := 0;
            IF ResourceTmp.NEXT <> 0 THEN
                REPEAT
                    ServLaborAllocEntryTmp.FINDFIRST;
                    REPEAT
                        PreviousAllocEntryNo := AddResourceToAllocEntry(ServLaborAllocEntryTmp, LaborAllocApp,
                          ResourceTmp."No.", PreviousAllocEntryNo, LaborAllocEntry, LaborAllocApp);
                    UNTIL ServLaborAllocEntryTmp.NEXT = 0;
                UNTIL ResourceTmp.NEXT = 0;
        END ELSE
            ERROR(TextNoRecords);
        EXIT(MainAllocEntrNo);
    end;

    [Scope('Internal')]
    procedure AllocationSpliting(NewResourceNo: Code[20]; NewStartingDateTime: Decimal)
    var
        AllocationForm: Page "25006369";
        ServiceLine: Record "25006146";
    begin
        CLEAR(AllocationForm);
        IF NOT LaborAllocEntry.GET(SingleInstanceMgt.GetAllocationEntryNo) THEN BEGIN
            MESSAGE(Text121);
            EXIT;
        END;
        IF NOT CheckUserRightsAdv(200, LaborAllocEntry) THEN EXIT;

        AllocationForm.SetIsTravel(LaborAllocEntry.Travel);
        AllocationForm.SetParam(0, NewResourceNo, NewStartingDateTime, LaborAllocEntry."Quantity (Hours)",
          LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID", 2, ServiceLine, 0);
        AllocationForm.LOOKUPMODE(TRUE);  //03.04.2013 P8
        COMMIT;  //28.06.2013 EDMS P8
        AllocationForm.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure ProcessSpliting(NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; SplitTracking1: Option No,Yes)
    var
        LaborAllocEntryTemp: Record "25006271" temporary;
        TotalHours: Decimal;
        StartDateTime: Decimal;
        EntryNo: Integer;
        DoReplan: Boolean;
        DifferentStatus: Boolean;
    begin
        IF NewQtyToAllocate <= 0 THEN
            EXIT;

        IF NOT CheckUserRightsAdv(200, LaborAllocEntry) THEN EXIT;

        ServiceScheduleSetup.GET;
        ScheduleAction := ScheduleAction::Planning;
        DoReplan := TRUE;

        SplitTracking := SplitTracking1;
        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        LaborAllocEntry.GET(EntryNo);

        AllocationStatus := LaborAllocEntry.Status;
        ChangeAllocationStatus := TRUE;

        TotalHours := CalculateTotalHours(EntryNo);
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
        LaborAllocEntryTemp.SETCURRENTKEY("Resource No.", "Start Date-Time");
        IF LaborAllocEntryTemp.FINDFIRST THEN
            StartDateTime := LaborAllocEntryTemp."Start Date-Time";


        IF SplitAllocTracking(EntryNo, 0) THEN BEGIN
            IF NewQtyToAllocate >= TotalHours THEN
                MovementIncSplit(EntryNo, NewResourceNo, NewStartingDateTime, NewQtyToAllocate, LaborAllocEntry.Status) //do only moving
            ELSE BEGIN
                MovementIncSplit(EntryNo, LaborAllocEntry."Resource No.", StartDateTime, TotalHours - NewQtyToAllocate,
                    LaborAllocEntry.Status); //correct old entry
                DoServiceSpliting := (NewResourceNo <> LaborAllocEntry."Resource No.");
                LaborAllocApp.RESET;
                LaborAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
                IF LaborAllocApp.FINDFIRST THEN
                    REPEAT
                        FillServiceLine2(ServiceLine, LaborAllocApp."Document Type", LaborAllocApp."Document No.",
                          LaborAllocApp."Document Line No.");
                    UNTIL LaborAllocApp.NEXT = 0;

                WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,      //insert new entry
                                       LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                       LaborAllocEntry."Source ID", 0, 0, DoReplan, LaborAllocEntry.Status, FALSE, FALSE);

                IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
                    JoinAllocationEntries(NewResourceNo, NewStartingDateTime);
            END;
        END ELSE BEGIN
            IF NewQtyToAllocate >= LaborAllocEntry."Quantity (Hours)" THEN BEGIN
                DoServiceSpliting := (NewResourceNo <> LaborAllocEntry."Resource No.");
                DifferentStatus := CheckLaborStatus(LaborAllocEntryTemp);
                IF DifferentStatus AND DoServiceSpliting THEN BEGIN
                    LaborAllocApp.RESET;
                    LaborAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
                    IF LaborAllocApp.FINDFIRST THEN
                        REPEAT
                            FillServiceLine2(ServiceLine, LaborAllocApp."Document Type", LaborAllocApp."Document No.",
                              LaborAllocApp."Document Line No.");
                        UNTIL LaborAllocApp.NEXT = 0;

                    WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,
                                           LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                           LaborAllocEntry."Source ID", 0, 0, DoReplan, LaborAllocEntry.Status, FALSE, FALSE);

                    IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
                        JoinAllocationEntries(NewResourceNo, NewStartingDateTime);

                    DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, EntryNo, 11111);

                    IF LaborAllocEntryTemp.FINDFIRST THEN
                        REPEAT
                            StatusChanged := FALSE;
                            IF LaborAllocEntryTemp."Entry No." <> EntryNo THEN BEGIN
                                ChangeServiceLineStatus(LaborAllocEntryTemp."Entry No.", FALSE);
                                StatusChanged := TRUE;
                            END;
                        UNTIL (LaborAllocEntryTemp.NEXT = 0) OR StatusChanged;

                END ELSE BEGIN
                    WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,
                                           LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                           LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, LaborAllocEntry.Status, FALSE, FALSE);

                    IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
                        JoinAllocationEntries(NewResourceNo, NewStartingDateTime);
                END;
            END ELSE BEGIN
                WriteAllocationEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."Start Date-Time",
                                     LaborAllocEntry."Quantity (Hours)" - NewQtyToAllocate,
                                     LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                     LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, LaborAllocEntry.Status, FALSE, FALSE);

                IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
                    JoinAllocationEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."Start Date-Time");

                DoServiceSpliting := (NewResourceNo <> LaborAllocEntry."Resource No.");

                LaborAllocApp.RESET;
                LaborAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
                IF LaborAllocApp.FINDFIRST THEN
                    REPEAT
                        FillServiceLine2(ServiceLine, LaborAllocApp."Document Type", LaborAllocApp."Document No.",
                          LaborAllocApp."Document Line No.");
                    UNTIL LaborAllocApp.NEXT = 0;

                WriteAllocationEntries(NewResourceNo, NewStartingDateTime, NewQtyToAllocate,
                                     LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                     LaborAllocEntry."Source ID", 0, 0, DoReplan, LaborAllocEntry.Status, FALSE, FALSE);

                IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
                    JoinAllocationEntries(NewResourceNo, NewStartingDateTime);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SelectAllocationEntry(EntryNo: Integer)
    begin
        SingleInstanceMgt.SetCurrAllocation(EntryNo);
    end;

    [Scope('Internal')]
    procedure DeleteAllocationEntry(var LaborAllocEntry: Record "25006271"; var LaborAllocApp: Record "25006277"; EntryNo: Integer; RunModeFlags: Integer)
    var
        LaborAllocEntryLoc: Record "25006271";
        ResourceNo: Code[20];
        SourceID: Code[20];
        SourceSubType: Option Qoute,"Order";
        StartingDateTime: Decimal;
        EndingDateTime: Decimal;
        HourQty: Decimal;
        ApplyToEntryNo: Integer;
        DoOneServiceMoving: Boolean;
        isNeedCheck: Boolean;
        isNeedChangeLineStatus: Boolean;
        isGoingToAct: Boolean;
        isGoingToReplan: Boolean;
        isGoingToJoin: Boolean;
    begin
        // RunModeFlags = 11111, THE first from left is isGoingToJoin
        ServiceScheduleSetup.GET;

        IF NOT LaborAllocEntry.GET(EntryNo) THEN
            EXIT;
        isNeedCheck := (CutNextDigit(RunModeFlags) > 0);
        isNeedChangeLineStatus := (CutNextDigit(RunModeFlags) > 0);
        isGoingToAct := (CutNextDigit(RunModeFlags) > 0);
        isGoingToReplan := (CutNextDigit(RunModeFlags) > 0);
        isGoingToJoin := (CutNextDigit(RunModeFlags) > 0);

        IF isNeedCheck THEN BEGIN
            IF NOT CheckUserRightsAdv(400, LaborAllocEntry) THEN EXIT;
        END;

        ResourceNo := LaborAllocEntry."Resource No.";
        StartingDateTime := LaborAllocEntry."Start Date-Time";
        EndingDateTime := LaborAllocEntry."End Date-Time";
        HourQty := LaborAllocEntry."Quantity (Hours)";
        SourceSubType := LaborAllocEntry."Source Subtype";
        SourceID := LaborAllocEntry."Source ID";

        //correct service line status >>
        IF isNeedChangeLineStatus THEN
            ChangeServiceLineStatus(LaborAllocEntry."Entry No.", TRUE);
        //correct service line status <<

        IF isGoingToAct THEN BEGIN
            ChangeApplyTo(EntryNo, LaborAllocEntry."Applies-to Entry No.");
            LaborAllocEntry.DELETE(TRUE);
        END;

        IF isGoingToReplan THEN
            ReplanEntries(ResourceNo, EndingDateTime, -HourQty, ServiceScheduleSetup."Replan Document", SourceSubType, SourceID);

        IF isGoingToJoin THEN
            IF ServiceScheduleSetup."Handle Linked Entries" <> ServiceScheduleSetup."Handle Linked Entries"::No THEN
                JoinAllocationEntries(ResourceNo, StartingDateTime);
    end;

    [Scope('Internal')]
    procedure InsertAllocationEntry(var LaborAllocEntryPar: Record "25006271"; var LaborAllocAppPar: Record "25006277"; ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option ,"Service Document","Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; ApplyToEntry: Integer; DoChangeServLineResource: Boolean; TravelPar: Boolean)
    var
        ServiceLine1: Record "25006146";
        LaborAllocApp1: Record "25006277";
        ServiceHeader: Record "25006145";
        RetStartDateTime: Decimal;
        EntryNo: Integer;
        LineNo: Integer;
        SingleInstanceManagment: Codeunit "25006001";
    begin
        ServiceScheduleSetup.GET;

        //LaborAllocEntry.RESET;
        //IF LaborAllocEntry.FINDLAST THEN
        //EntryNo := LaborAllocEntry."Entry No.";
        LaborAllocEntry.RESET;
        IF LaborAllocEntry.FINDLAST THEN
            EntryNo := LaborAllocEntry."Entry No.";
        IF LaborAllocEntryPar.FINDLAST THEN
            IF LaborAllocEntryPar."Entry No." > EntryNo THEN
                EntryNo := LaborAllocEntryPar."Entry No.";

        EntryNo += 1;

        //12.12.2014 EB.P8 >>
        LaborAllocEntryPar.INIT;
        LaborAllocEntryPar."Entry No." := EntryNo;
        LaborAllocEntryPar."Source Type" := SourceType;
        LaborAllocEntryPar."Source Subtype" := SourceSubType;
        LaborAllocEntryPar."Source ID" := SourceID;
        "Start Date-Time" := StartingDateTime;
        "End Date-Time" := StartingDateTime + QtyToAllocate * 3.6;
        "Start Date Time" := CREATEDATETIME(DateTimeMgt.Datetime2Date("Start Date-Time"), DateTimeMgt.Datetime2Time("Start Date-Time"));
        "End Date Time" := CREATEDATETIME(DateTimeMgt.Datetime2Date("End Date-Time"), DateTimeMgt.Datetime2Time("End Date-Time"));
        "Quantity (Hours)" := QtyToAllocate;
        "Resource No." := ResourceNo;
        "User ID" := SingleInstanceManagment.GetCurrentUserId;
        Travel := TravelPar;
        LaborAllocEntryPar.VALIDATE("Applies-to Entry No.", ApplyToEntry);  //14.03.2014 Elva Baltic P8 #S0003 MMG7.00
        CASE SourceType OF
            SourceType::"Standard Event":
                "Planning Policy" := ServiceScheduleSetup."Planning Policy";
            SourceType::"Service Document":
                BEGIN
                    IF LaborAllocEntryPar."Source Subtype" = LaborAllocEntryPar."Source Subtype"::Order THEN BEGIN
                        ServiceHeader.GET(ServiceHeader."Document Type"::Order, SourceID);
                        "Planning Policy" := ServiceHeader."Planning Policy";
                    END;
                    IF LaborAllocEntryPar."Source Subtype" = LaborAllocEntryPar."Source Subtype"::Quote THEN BEGIN
                        ServiceHeader.GET(ServiceHeader."Document Type"::Quote, SourceID);
                        "Planning Policy" := ServiceHeader."Planning Policy";
                    END;
                END;
        END;
        LaborAllocEntryPar.INSERT;
        //LaborAllocEntryPar := LaborAllocEntry;
        //IF NOT LaborAllocEntryPar.INSERT THEN;  //IT catch situations when LaborAllocEntryPar is temporaral Record
        //12.12.2014 EB.P8 <<

        IF (SourceType = SourceType::"Service Document") THEN
            IF DoChangeServLineResource THEN BEGIN  //09.07.2013 EDMS P8
                IF ServiceLine.FINDFIRST AND (ApplyToEntry = 0) THEN BEGIN  //17.04.2008. EDMS P2
                    REPEAT
                        LineNo := ServiceLine."Line No.";
                        IF DoServiceSpliting THEN
                            LineNo := SplitServiceLine(ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.");

                        ControlLaborSequence(ServiceLine."Document Type", ServiceLine."Document No.", LineNo, StartingDateTime);
                        ControlSkills(ServiceLine."Document Type", ServiceLine."Document No.", LineNo, ResourceNo);

                        InsertAllocApplication(LaborAllocAppPar, EntryNo, ServiceLine."Document Type", ServiceLine."Document No.",
                                               LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                    UNTIL ServiceLine.NEXT = 0;
                    DoServiceSpliting := FALSE;
                    ServiceLine.RESET;
                    ServiceLine.DELETEALL;
                END ELSE BEGIN
                    LaborAllocApp1.RESET;
                    LaborAllocApp1.SETRANGE("Allocation Entry No.", LaborAllocEntryPar."Applies-to Entry No.");
                    IF LaborAllocApp1.FINDFIRST THEN
                        REPEAT
                            LineNo := LaborAllocApp1."Document Line No.";

                            ControlLaborSequence(LaborAllocApp1."Document Type", LaborAllocApp1."Document No.", LineNo, StartingDateTime);
                            ControlSkills(LaborAllocApp1."Document Type", LaborAllocApp1."Document No.", LineNo, ResourceNo);

                            InsertAllocApplication(LaborAllocAppPar, EntryNo, LaborAllocApp1."Document Type", LaborAllocApp1."Document No.",
                                                   LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                        UNTIL LaborAllocApp1.NEXT = 0;
                END;
            END ELSE BEGIN  //09.04.2013 EDMS P8
                            //09.07.2013 EDMS P8 >>
                IF ServiceLine.FINDFIRST AND (ApplyToEntry = 0) THEN BEGIN
                    REPEAT
                        LineNo := ServiceLine."Line No.";
                        IF DoServiceSpliting THEN
                            LineNo := SplitServiceLine(ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.");

                        ControlLaborSequence(ServiceLine."Document Type", ServiceLine."Document No.", LineNo, StartingDateTime);
                        ControlSkills(ServiceLine."Document Type", ServiceLine."Document No.", LineNo, ResourceNo);

                        InsertAllocApplication(LaborAllocAppPar, EntryNo, ServiceLine."Document Type", ServiceLine."Document No.",
                                               LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                    UNTIL ServiceLine.NEXT = 0;
                    DoServiceSpliting := FALSE;
                    ServiceLine.RESET;
                    ServiceLine.DELETEALL;
                END ELSE BEGIN
                    //20.07.2013 EDMS P8 >>
                    IF ApplyToEntry = 0 THEN BEGIN
                        //InsertAllocApplication(LaborAllocApp, EntryNo, ServiceLine."Document Type", ServiceLine."Document No.",
                        //                 LineNo, ResourceNo, DoChangeServLineResource);
                        InsertAllocApplication(LaborAllocAppPar, EntryNo, SourceSubType, SourceID,
                                         LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                    END ELSE BEGIN
                        LaborAllocApp1.RESET;
                        LaborAllocApp1.SETRANGE("Allocation Entry No.", LaborAllocEntryPar."Applies-to Entry No.");
                        IF LaborAllocApp1.FINDFIRST THEN
                            REPEAT
                                LineNo := LaborAllocApp1."Document Line No.";

                                ControlLaborSequence(LaborAllocApp1."Document Type", LaborAllocApp1."Document No.", LineNo, StartingDateTime);
                                ControlSkills(LaborAllocApp1."Document Type", LaborAllocApp1."Document No.", LineNo, ResourceNo);

                                InsertAllocApplication(LaborAllocAppPar, EntryNo, LaborAllocApp1."Document Type", LaborAllocApp1."Document No.",
                                                       LineNo, ResourceNo, DoChangeServLineResource, TravelPar);
                            UNTIL LaborAllocApp1.NEXT = 0;
                    END;
                    //20.07.2013 EDMS P8 <<

                END;
                //09.07.2013 EDMS P8 <<
            END;
    end;

    [Scope('Internal')]
    procedure ModifyAllocationEntry(var LaborAllocEntry: Record "25006271"; var LaborAllocApp: Record "25006277"; EntryNo: Integer; NewResourceNo: Code[20]; NewStartingDateTime: Decimal; NewQtyToAllocate: Decimal; DoChangeServLineResource: Boolean; Status: Integer; AppliesToEntryNo: Integer; Travel: Boolean)
    var
        LaborAllocAppLoc: Record "25006277";
        OldResourceNo: Code[20];
    begin
        ServiceScheduleSetup.GET;
        LaborAllocEntry.GET(EntryNo);
        OldResourceNo := LaborAllocEntry."Resource No.";
        LaborAllocEntry."Resource No." := NewResourceNo;
        LaborAllocEntry."Start Date-Time" := NewStartingDateTime;
        LaborAllocEntry."End Date-Time" := NewStartingDateTime + NewQtyToAllocate * 3.6;
        LaborAllocEntry."Quantity (Hours)" := NewQtyToAllocate;
        LaborAllocEntry.Travel := Travel;
        IF AppliesToEntryNo > 0 THEN  //10.12.2013 EDMS P8
            LaborAllocEntry.VALIDATE("Applies-to Entry No.", AppliesToEntryNo);  //14.03.2014 Elva Baltic P8 #S0003 MMG7.00
        IF Status >= 0 THEN
            LaborAllocEntry.Status := Status;
        LaborAllocEntry.MODIFY;


        IF (ServiceScheduleSetup."Control Labor Sequence") OR
           (ServiceScheduleSetup."Control Skills" <> ServiceScheduleSetup."Control Skills"::No)
        THEN BEGIN
            LaborAllocAppLoc.RESET;
            LaborAllocAppLoc.SETRANGE("Allocation Entry No.", EntryNo);
            IF LaborAllocAppLoc.FINDFIRST THEN
                REPEAT
                    ControlLaborSequence(LaborAllocAppLoc."Document Type", LaborAllocAppLoc."Document No.", LaborAllocAppLoc."Document Line No.",
                                         NewStartingDateTime);
                    IF OldResourceNo <> NewResourceNo THEN
                        ControlSkills(LaborAllocAppLoc."Document Type", LaborAllocAppLoc."Document No.", LaborAllocAppLoc."Document Line No.",
                                      NewResourceNo);
                UNTIL LaborAllocAppLoc.NEXT = 0;
        END;

        IF LaborAllocEntry."Source Type" = LaborAllocEntry."Source Type"::"Service Document" THEN
            ModifyAllocApplication(LaborAllocApp, EntryNo, NewResourceNo, DoChangeServLineResource, Travel);
    end;

    [Scope('Internal')]
    procedure DeleteAllocApplication(var LaborAllocApp: Record "25006277"; AllocationEntryNo: Integer)
    var
        LaborAllocAppLoc: Record "25006277";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        DocumentNo: Code[20];
        LineNo: Integer;
        ResourceNo: Code[20];
    begin
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Allocation Entry No.", AllocationEntryNo);
        IF LaborAllocApp.FINDFIRST THEN
            REPEAT
                DocumentType := LaborAllocApp."Document Type";
                DocumentNo := LaborAllocApp."Document No.";
                ResourceNo := LaborAllocApp."Resource No.";
                LineNo := LaborAllocApp."Document Line No.";
                LaborAllocApp.DELETE(TRUE);

                LaborAllocAppLoc.RESET;
                LaborAllocAppLoc.SETRANGE("Document Type", DocumentType);
                LaborAllocAppLoc.SETRANGE("Document No.", DocumentNo);
                LaborAllocAppLoc.SETRANGE("Document Line No.", LineNo);
            //    IF NOT LaborAllocAppLoc.FINDFIRST THEN BEGIN  // P8
            //    IF LineNo = 0 THEN
            //    IF CONFIRM(Text145) THEN
            //    DocAllocAdjustDocLinesResource(DocumentType, DocumentNo, '');
            //END;

            UNTIL LaborAllocApp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure InsertAllocApplication(var LaborAllocApp: Record "25006277"; AllocationEntry: Integer; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; LineNo: Integer; ResourceNo: Code[20]; DoChangeServLineResource: Boolean; Travel: Boolean)
    var
        LaborAllocEntryLocal: Record "25006271";
        EntryNo: Integer;
        IsTimeLine: Boolean;
        ResourceCost: Record "156";
    begin
        IsTimeLine := FALSE;
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Allocation Entry No.", AllocationEntry);
        LaborAllocApp.SETRANGE("Time Line", TRUE);
        IF NOT LaborAllocApp.FINDFIRST THEN
            IsTimeLine := TRUE;

        IF NOT LaborAllocEntryLocal.GET(AllocationEntry) THEN EXIT;  //28.06.2013 EDMS P8

        LaborAllocApp.RESET;
        IF LaborAllocApp.FINDLAST THEN
            EntryNo := LaborAllocApp."Allocation Entry No.";

        EntryNo += 1;
        LaborAllocApp.INIT;
        LaborAllocApp."Allocation Entry No." := AllocationEntry;
        LaborAllocApp."Document Type" := DocumentType;
        LaborAllocApp."Document No." := DocumentNo;
        LaborAllocApp."Document Line No." := LineNo;
        LaborAllocApp."Resource No." := ResourceNo;
        LaborAllocApp.Travel := Travel;
        IF IsTimeLine THEN BEGIN
            LaborAllocApp."Time Line" := IsTimeLine;
            LaborAllocApp."Remaining Quantity (Hours)" := LaborAllocEntryLocal."Quantity (Hours)";
        END;
        IF ResourceCost.GET(ResourceNo) THEN                                        //12.05.2015 EB.P30 #T030
            LaborAllocApp.VALIDATE("Unit Cost", ResourceCost."Unit Cost");            //12.05.2015 EB.P30 #T030
        LaborAllocApp.INSERT(TRUE);

        IF DoChangeServLineResource THEN BEGIN
            DocAllocAdjustDocLinesResource(DocumentType, DocumentNo, ResourceNo);  // P8
        END;
    end;

    [Scope('Internal')]
    procedure ModifyAllocApplication(var LaborAllocApp: Record "25006277"; EntryNo: Integer; ResourceNo: Code[20]; DoChangeServLineResource: Boolean; Travel: Boolean)
    var
        LaborAllocEntryLocal: Record "25006271";
        ResourceCost: Record "156";
        IsResourceChanged: Boolean;
        TotalTimeSpent: Decimal;
    begin
        LaborAllocEntryLocal.GET(EntryNo);
        LaborAllocEntryLocal.CALCFIELDS("Total Time Spent", "Total Time Spent Travel");
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
        IF LaborAllocApp.FINDFIRST THEN
            REPEAT
                //12.05.2015 EB.P30 #T030 >>
                IsResourceChanged := FALSE;
                IF LaborAllocApp."Resource No." <> ResourceNo THEN
                    IsResourceChanged := TRUE;
                //12.05.2015 EB.P30 #T030 <<
                LaborAllocApp."Resource No." := ResourceNo;
                LaborAllocApp.Travel := Travel;
                IF Travel THEN
                    TotalTimeSpent := LaborAllocEntryLocal."Total Time Spent Travel"
                ELSE
                    TotalTimeSpent := LaborAllocEntryLocal."Total Time Spent";

                LaborAllocApp.VALIDATE("Finished Quantity (Hours)", TotalTimeSpent);
                LaborAllocApp.VALIDATE("Remaining Quantity (Hours)", LaborAllocEntryLocal."Quantity (Hours)" - TotalTimeSpent);


                //12.05.2015 EB.P30 #T030 >>
                IF IsResourceChanged THEN BEGIN
                    IF ResourceCost.GET(ResourceNo) THEN
                        LaborAllocApp.VALIDATE("Unit Cost", ResourceCost."Unit Cost");
                END;
                //12.05.2015 EB.P30 #T030
                LaborAllocApp.MODIFY;
                IF DoChangeServLineResource THEN BEGIN
                    DocAllocAdjustDocLinesResource(LaborAllocApp."Document Type", LaborAllocApp."Document No.", ResourceNo);  // P8
                END;
            UNTIL LaborAllocApp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure IsTimeAvailable(var ServLaborAlloc: Record "25006271"; ResourceNo: Code[20]; CurrentDay: Date; ModifyEntryNo: Integer): Boolean
    var
        ServiceHour: Record "25006129";
        ResourceCalendarChange: Record "25006279";
        ServLaborAlloc2: Record "25006271";
        LaborAllocApp: Record "25006277" temporary;
        ResourceLoc: Record "156";
        CheckDescription: Text[50];
        Starting: Decimal;
        Finishing: Decimal;
        QtyToAllocate: Decimal;
        EntryNo: Integer;
        HourEntry: Integer;
        WhichEntry: Integer;
        PeriodStart: Time;
        OwnWorkTime: Boolean;
        DoChangeServLineResource: Boolean;
    begin
        //EDMS P2
        ServiceScheduleSetup.GET;
        DoChangeServLineResource := FALSE;
        //check for busy time in Base Calendar and in Resource Calendar Change >>
        OwnWorkTime := FALSE;
        IF ResourceCalendarChange.GET(ResourceNo, CurrentDay) THEN BEGIN
            IF ResourceCalendarChange."Change Type" = ResourceCalendarChange."Change Type"::Nonworking THEN
                EXIT(FALSE)
            ELSE BEGIN
                IF NOT (ResourceCalendarChange."Starting Time" = 000000T) THEN BEGIN
                    QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, 000000T),
                                                        DateTimeMgt.Datetime(CurrentDay, ResourceCalendarChange."Starting Time"));
                    InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, 000000T), QtyToAllocate,
                                          0, 0, 'Err1', 0, DoChangeServLineResource, FALSE);
                    OwnWorkTime := TRUE;
                END ELSE BEGIN
                    InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, 000000T), 0,
                                          0, 0, 'Err1', 0, DoChangeServLineResource, FALSE);
                    OwnWorkTime := TRUE;
                END;


                IF NOT (ResourceCalendarChange."Ending Time" > 235959T) THEN BEGIN
                    QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, ResourceCalendarChange."Ending Time"),
                                                        DateTimeMgt.Datetime(CurrentDay, 235959.999T));
                    InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo,
                                          DateTimeMgt.Datetime(CurrentDay, ResourceCalendarChange."Ending Time"), QtyToAllocate, 0, 0, 'Err2', 0,
                                          DoChangeServLineResource, FALSE);
                    OwnWorkTime := TRUE;
                END ELSE BEGIN
                    InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo,
                                          DateTimeMgt.Datetime(CurrentDay, ResourceCalendarChange."Ending Time"), 0, 0, 0, 'Err2', 0,
                                          DoChangeServLineResource, FALSE);
                    OwnWorkTime := TRUE;
                END;
            END;
        END;

        //write busy time from Service Hour EDMS >>
        IF NOT OwnWorkTime THEN BEGIN
            ServiceHour.RESET;
            //AB >>
            //ResourceLoc.GET(ResourceNo);
            IF ResourceLoc.GET(ResourceNo) THEN BEGIN
                ServiceHour.SETRANGE("Service Work Group Code", ResourceLoc."Service Work Group Code");
                ServiceHour.SETFILTER("Starting Date", '''''|<=%1', CurrentDay);
                ServiceHour.SETFILTER("Ending Date", '''''|>=%1', CurrentDay);
                ServiceHour.SETRANGE(Day, DATE2DWY(CurrentDay, 1) - 1);
                //21.02.2010 EDMSB P2 >>
                HourEntry := ServiceHour.COUNT;
                IF ServiceHour.FINDFIRST THEN BEGIN
                    PeriodStart := 000000T;
                    REPEAT
                        WhichEntry += 1;
                        IF NOT (ServiceHour."Starting Time" = PeriodStart) THEN BEGIN
                            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, PeriodStart),
                                                                DateTimeMgt.Datetime(CurrentDay, ServiceHour."Starting Time"));
                            InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, PeriodStart),
                                                  QtyToAllocate, 0, 0, 'Err4', 0, DoChangeServLineResource, FALSE);
                        END ELSE BEGIN
                            InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, PeriodStart), 0,
                                                  0, 0, 'Err4', 0, DoChangeServLineResource, FALSE);
                        END;
                        PeriodStart := ServiceHour."Ending Time";
                        IF HourEntry = WhichEntry THEN BEGIN
                            IF NOT (ServiceHour."Ending Time" > 235959T) THEN BEGIN
                                QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, ServiceHour."Ending Time"),
                                                                    DateTimeMgt.Datetime(CurrentDay, 235959.999T));
                                InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo,
                                                      DateTimeMgt.Datetime(CurrentDay, ServiceHour."Ending Time"), QtyToAllocate, 0, 0, 'Err5', 0,
                                                      DoChangeServLineResource, FALSE);
                            END ELSE BEGIN
                                InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo,
                                                      DateTimeMgt.Datetime(CurrentDay, ServiceHour."Ending Time"), 0, 0, 0, 'Err5', 0,
                                                      DoChangeServLineResource, FALSE);
                            END;
                        END;
                    UNTIL ServiceHour.NEXT = 0;
                END ELSE
                    EXIT(FALSE)
                //21.02.2010 EDMSB P2 <<
            END;
            //AB <<
        END;
        // <<
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure GetTimeAvailable(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal): Boolean
    var
        ServiceHour: Record "25006129";
        ResourceCalendarChange: Record "25006279";
        ResourceLoc: Record "156";
        CurrentDay: Date;
    begin
        CurrentDay := DateTimeMgt.Datetime2Date(StartingDateTime);

        IF ResourceCalendarChange.GET(ResourceNo, CurrentDay) THEN BEGIN
            IF ResourceCalendarChange."Change Type" = ResourceCalendarChange."Change Type"::Nonworking THEN
                EXIT(FALSE)
            ELSE BEGIN
                IF (DateTimeMgt.Datetime2Time(StartingDateTime) <= ResourceCalendarChange."Ending Time") AND
                   (DateTimeMgt.Datetime2Time(EndingDateTime) >= ResourceCalendarChange."Starting Time")
                THEN
                    EXIT(TRUE)
                ELSE
                    EXIT(FALSE)
            END;
        END;

        ServiceHour.RESET;
        ServiceHour.SETRANGE("Service Work Group Code", ResourceLoc."Service Work Group Code");
        ServiceHour.SETFILTER("Starting Date", '''''|<=%1', CurrentDay);
        ServiceHour.SETFILTER("Ending Date", '''''|>=%1', CurrentDay);
        ServiceHour.SETRANGE(Day, DATE2DWY(CurrentDay, 1) - 1);
        //18.01.2012 EDMS P8 >>
        IF ServiceHour.FINDFIRST THEN BEGIN
            REPEAT
                IF (DateTimeMgt.Datetime2Time(StartingDateTime) <= ServiceHour."Ending Time") AND
                   (DateTimeMgt.Datetime2Time(EndingDateTime) >= ServiceHour."Starting Time")
                THEN
                    EXIT(TRUE);
            UNTIL ServiceHour.NEXT = 0;
            EXIT(FALSE);
            //18.01.2012 EDMS P8 <<
        END;

        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure IsStarttimeAvailable(var ServLaborAllocPar: Record "25006271"; ResourceNo: Code[20]; CurrentDay: Date; StartTime: Time)
    var
        QtyToAllocate: Decimal;
    begin
        //busy time from date start till starttime >>
        IF NOT (StartTime = 000000T) THEN BEGIN
            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, 000000T),
                                               DateTimeMgt.Datetime(CurrentDay, StartTime));
            InsertAllocationEntry(ServLaborAllocPar, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, 000000T), QtyToAllocate,
                                  0, 0, 'Err3', 0, FALSE, FALSE);  //12.12.2014 EB.P8
        END;
        // <<
    end;

    [Scope('Internal')]
    procedure IsStarttimeAvailableBackward(var ServLaborAlloc: Record "25006271"; ResourceNo: Code[20]; CurrentDay: Date; StartTime: Time)
    var
        QtyToAllocate: Decimal;
    begin
        //busy time from date start till starttime >>
        IF NOT (StartTime = 000000T) THEN BEGIN
            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(CurrentDay, StartTime),
                                                DateTimeMgt.Datetime(CurrentDay, 235959.999T));
            InsertAllocationEntry(ServLaborAlloc, LaborAllocApp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, StartTime), QtyToAllocate,
                                  0, 0, 'Err3', 0, FALSE, FALSE);
        END;
        // <<
    end;

    [Scope('Internal')]
    procedure WriteAllocationEntries(ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal; SourceType: Option "Service Document",,"Standard Event"; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]; FunctionMode: Option Insert,Modify; ModifyEntryNo: Integer; DoReplan: Boolean; Status: Integer; FirstRowMustTakeFromModify: Boolean; Travel: Boolean)
    var
        ServLaborAlloc: Record "25006271";
        ServLaborAllocTemp: Record "25006271" temporary;
        ServiceHour: Record "25006129";
        RepairStatus: Record "25006166";
        CurrentDay: Date;
        StartTime: Time;
        RetStartDateTime: Decimal;
        ReplanHours: Decimal;
        QtyToAllocate2: Decimal;
        ApplyToEntry: Integer;
        FirstEntry: Boolean;
        DoChangeServLineResource: Boolean;
        ChangeAllocationStatusLocal: Boolean;
        DoOneServiceMoving: Boolean;
        Allocations: Page "25006362";
    begin
        ServiceScheduleSetup.GET;
        CurrentDay := DateTimeMgt.Datetime2Date(StartingDateTime);
        StartTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        ChangeAllocationStatusLocal := ChangeAllocationStatus;
        ChangeAllocationStatus := FALSE;
        QtyToAllocate2 := QtyToAllocate;
        AllocationStatus := Status;  //20.07.2013 EDMS P8

        ReturnAvailableTimes(ServLaborAllocTemp, QtyToAllocate, ResourceNo, CurrentDay, StartTime, ModifyEntryNo);

        DoChangeServLineResource := FALSE;  //09.04.2013 EDMS P8
        //DoChangeServLineResource := TRUE;
        FirstEntry := TRUE;
        ApplyToEntry := ModifyEntryNo;
        ServLaborAllocTemp.RESET;

        //MESSAGE('AllocationStatus:'+FORMAT(AllocationStatus)+' AllocationStatusAction: '+FORMAT(AllocationStatusAction)+' ScheduleAction: '+FORMAT(ScheduleAction));

        IF ServLaborAllocTemp.FINDFIRST THEN
            REPEAT
                //MESSAGE('msg in writeAlloc, 1');
                IF FirstEntry AND (FunctionMode = FunctionMode::Modify) THEN BEGIN
                    IF ServLaborAlloc.GET(ModifyEntryNo) THEN;
                    IF LaborAllocEntry.GET(ModifyEntryNo) THEN;
                    IF DoReplan THEN BEGIN
                        ReplanHours := CheckForTime(ResourceNo, ServLaborAllocTemp."Start Date-Time",
                                                    ServLaborAllocTemp."End Date-Time", ModifyEntryNo, ServiceScheduleSetup."Replan Document",
                                                    SourceSubType, SourceID);
                        IF ReplanHours > 0 THEN
                            ReplanEntries(ResourceNo, ServLaborAllocTemp."Start Date-Time", ReplanHours, ServiceScheduleSetup."Replan Document",
                                         SourceSubType, SourceID)
                        ELSE BEGIN
                            ReplanHours := CalculateReplanHours(QtyToAllocate2, ServLaborAlloc."Quantity (Hours)",
                                                                ServLaborAllocTemp."Start Date-Time", ServLaborAlloc."Start Date-Time",
                                                                ServLaborAllocTemp."Resource No.");
                            IF ReplanHours <> 0 THEN
                                ReplanEntries(ResourceNo, ServLaborAlloc."End Date-Time", ReplanHours, ServiceScheduleSetup."Replan Document",
                                              SourceSubType, SourceID);
                        END;
                    END;
                    ModifyAllocationEntry(LaborAllocEntry, LaborAllocApp, ModifyEntryNo, ServLaborAllocTemp."Resource No.",
                                          ServLaborAllocTemp."Start Date-Time", ServLaborAllocTemp."Quantity (Hours)",
                                          DoChangeServLineResource, Status, ServLaborAllocTemp."Applies-to Entry No.", Travel);
                END ELSE BEGIN
                    IF (NOT FirstEntry) THEN BEGIN
                        IF (ServiceScheduleSetup."Min. Notability (Hours)" > ServLaborAllocTemp."Quantity (Hours)") THEN
                            EXIT;
                        IF NOT CONFIRM(STRSUBSTNO(Text127, CurrentDay, ServLaborAllocTemp."Quantity (Hours)")) THEN
                            EXIT;
                    END;

                    IF DoReplan <> DoReplan::No THEN BEGIN
                        ReplanHours := CheckForTime(ResourceNo, ServLaborAllocTemp."Start Date-Time",
                                                    ServLaborAllocTemp."End Date-Time", 0, ServiceScheduleSetup."Replan Document",
                                                    SourceSubType, SourceID);
                        IF ReplanHours > 0 THEN
                            ReplanEntries(ResourceNo, ServLaborAllocTemp."Start Date-Time", ReplanHours, ServiceScheduleSetup."Replan Document",
                                          SourceSubType, SourceID);
                    END;
                    //lll
                    IF FirstEntry THEN BEGIN
                        IF FirstRowMustTakeFromModify THEN
                            ApplyToEntry := ModifyEntryNo
                        ELSE
                            ApplyToEntry := 0
                    END ELSE
                        IF ApplyToEntry = 0 THEN  //20.07.2013 EDMS P8
                            ApplyToEntry := ModifyEntryNo;

                    // THERE COULD BE FOR ONE ALLOCATION both applications: document and lines
                    InsertAllocationEntry(LaborAllocEntry, LaborAllocApp, ServLaborAllocTemp."Resource No.",
                                          ServLaborAllocTemp."Start Date-Time", ServLaborAllocTemp."Quantity (Hours)",
                                          SourceType, SourceSubType, SourceID, ApplyToEntry, DoChangeServLineResource, Travel);

                END;

                IF ApplyToEntry <> 0 THEN
                    ChangeApplyTo(ApplyToEntry, LaborAllocEntry."Entry No.");

                //Update Forced status.
                AllocationStatus := Status;
                ChangeStatus(LaborAllocEntry);

                ChangeServiceLineStatus(LaborAllocEntry."Entry No.", FALSE);

                FirstEntry := FALSE;
                ApplyToEntry := LaborAllocEntry."Entry No.";
            UNTIL ServLaborAllocTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CalculateReplanHours(NewQty: Decimal; OldQty: Decimal; NewStartDateTime: Decimal; OldStartDateTime: Decimal; ResourceNo: Code[20]): Decimal
    var
        ReplanHours: Decimal;
    begin
        ReplanHours := 0;
        ReplanHours := NewQty - OldQty;
        IF NewStartDateTime <> OldStartDateTime THEN
            ReplanHours += CalcWorkHourDifference(ResourceNo, OldStartDateTime, NewStartDateTime);

        EXIT(ReplanHours)
    end;

    [Scope('Internal')]
    procedure WriteAllocationEntryEnd(EntryNo: Integer; EndingDateTime: Decimal; DoReplan: Boolean; ReasonCode: Code[10]; Travel: Boolean)
    var
        ReplanHours: Decimal;
        DoOneServiceMoving: Boolean;
        LaborAllocEntryTemp: Record "25006271" temporary;
    begin
        ServiceScheduleSetup.GET;
        LaborAllocEntry.GET(EntryNo);

        IF DoReplan THEN BEGIN
            ReplanHours := CheckForTime(LaborAllocEntry."Resource No.", LaborAllocEntry."Start Date-Time",
                                        EndingDateTime, EntryNo, ServiceScheduleSetup."Replan Document",
                                        LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID");
            IF ReplanHours > 0 THEN
                ReplanEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."End Date-Time", ReplanHours,
                              ServiceScheduleSetup."Replan Document", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID")
            ELSE BEGIN
                ReplanHours := CalcHourDifference(LaborAllocEntry."Start Date-Time", EndingDateTime) - LaborAllocEntry."Quantity (Hours)";
                IF ReplanHours < 0 THEN
                    ReplanEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."End Date-Time", ReplanHours,
                                  ServiceScheduleSetup."Replan Document", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID")
            END;
        END;

        LaborAllocEntry.GET(EntryNo);
        ChangeStatus(LaborAllocEntry);
        ModifyAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntry."Entry No.", LaborAllocEntry."Resource No.",
                              LaborAllocEntry."Start Date-Time",
                              CalcHourDifference(LaborAllocEntry."Start Date-Time", EndingDateTime),
                              FALSE, -1, LaborAllocEntry."Applies-to Entry No.", Travel);

        IF ReasonCode <> '' THEN
            ModifyReason(LaborAllocEntry, ReasonCode);

        ChangeServiceLineStatus(LaborAllocEntry."Entry No.", FALSE);

        SynchroniseRelatedEntries(LaborAllocEntry."Entry No.");
    end;

    [Scope('Internal')]
    procedure ReturnAvailableTimes(var ServLaborAllocTemp: Record "25006271"; var QtyToAllocate: Decimal; ResourceNo: Code[20]; CurrentDay: Date; StartTime: Time; ModifyEntryNo: Integer)
    var
        ServLaborAllocTemp2: Record "25006271" temporary;
        LaborAllocAppTemp: Record "25006277" temporary;
        LastTime: Decimal;
        AllocateCurrentQty: Decimal;
        AllocateStartDateTime: Decimal;
        DayQty: Integer;
        DoChangeServLineResource: Boolean;
    begin
        ServiceScheduleSetup.GET;
        IF ServiceScheduleSetup."Disable Unavail. Time Control" THEN BEGIN
            InsertAllocationEntry(ServLaborAllocTemp, LaborAllocAppTemp, ResourceNo, DateTimeMgt.Datetime(CurrentDay, StartTime), QtyToAllocate,
                                            0, 0, 'Err6', 0, DoChangeServLineResource, FALSE);
            EXIT;
        END;
        DayQty := 0;
        DoChangeServLineResource := FALSE;
        REPEAT
            IF IsTimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, ModifyEntryNo) THEN BEGIN
                IsStarttimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, StartTime);
                ServLaborAllocTemp2.RESET;
                ServLaborAllocTemp2.SETCURRENTKEY("Resource No.", "Start Date-Time");
                LastTime := 0;

                IF ServLaborAllocTemp2.FINDFIRST THEN
                    REPEAT
                        IF (LastTime <> 0) AND (LastTime < ServLaborAllocTemp2."Start Date-Time") AND (QtyToAllocate > 0) THEN BEGIN
                            IF QtyToAllocate > CalcHourDifference(LastTime, ServLaborAllocTemp2."Start Date-Time") THEN
                                AllocateCurrentQty := CalcHourDifference(LastTime, ServLaborAllocTemp2."Start Date-Time")
                            ELSE
                                AllocateCurrentQty := QtyToAllocate;

                            AllocateStartDateTime := LastTime;
                            InsertAllocationEntry(ServLaborAllocTemp, LaborAllocAppTemp, ResourceNo, AllocateStartDateTime, AllocateCurrentQty,
                                                  0, 0, 'Err6', 0, DoChangeServLineResource, FALSE);
                            QtyToAllocate -= AllocateCurrentQty;
                        END;

                        ServLaborAllocTemp2.SETFILTER("End Date-Time", '>%1', ServLaborAllocTemp2."End Date-Time");
                        LastTime := ServLaborAllocTemp2."End Date-Time";
                    UNTIL ServLaborAllocTemp2.NEXT = 0;
            END;

            ServLaborAllocTemp2.RESET;
            ServLaborAllocTemp2.DELETEALL;
            CurrentDay := CurrentDay + 1;
            StartTime := 000000T;
            DayQty += 1;
            QtyToAllocate := ROUND(QtyToAllocate, 0.00001);
        UNTIL (QtyToAllocate <= 0) OR (DayQty > 1000);  //12.12.2014 EB.P8

        IF DayQty > 1000 THEN
            MESSAGE(Text102);
    end;

    [Scope('Internal')]
    procedure ReturnAvailableTimesBackward(var ServLaborAllocTemp: Record "25006271" temporary; var QtyToAllocate: Decimal; ResourceNo: Code[20]; CurrentDay: Date; StartTime: Time; ModifyEntryNo: Integer)
    var
        ServLaborAllocTemp2: Record "25006271" temporary;
        LaborAllocAppTemp: Record "25006277" temporary;
        LastTime: Decimal;
        AllocateCurrentQty: Decimal;
        AllocateStartDateTime: Decimal;
        DayQty: Integer;
        DoChangeServLineResource: Boolean;
    begin
        DayQty := 0;
        DoChangeServLineResource := FALSE;
        REPEAT
            IF IsTimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, ModifyEntryNo) THEN BEGIN
                IsStarttimeAvailableBackward(ServLaborAllocTemp2, ResourceNo, CurrentDay, StartTime);
                ServLaborAllocTemp2.RESET;
                ServLaborAllocTemp2.SETCURRENTKEY("Resource No.", "End Date-Time");
                LastTime := 0;

                IF ServLaborAllocTemp2.FINDLAST THEN
                    REPEAT
                        IF (LastTime <> 0) AND (LastTime > ServLaborAllocTemp2."End Date-Time") AND (QtyToAllocate > 0) THEN BEGIN
                            IF QtyToAllocate > CalcHourDifference(ServLaborAllocTemp2."End Date-Time", LastTime) THEN BEGIN
                                AllocateCurrentQty := CalcHourDifference(ServLaborAllocTemp2."End Date-Time", LastTime);
                                AllocateStartDateTime := ServLaborAllocTemp2."End Date-Time";
                            END ELSE BEGIN
                                AllocateCurrentQty := QtyToAllocate;
                                AllocateStartDateTime := LastTime - QtyToAllocate * 3.6;
                            END;

                            InsertAllocationEntry(ServLaborAllocTemp, LaborAllocAppTemp, ResourceNo, AllocateStartDateTime, AllocateCurrentQty,
                                                  0, 0, 'Err7', 0, DoChangeServLineResource, FALSE);
                            QtyToAllocate -= AllocateCurrentQty;
                        END;

                        LastTime := ServLaborAllocTemp2."Start Date-Time";
                        ServLaborAllocTemp2.SETFILTER("Start Date-Time", '<%1', ServLaborAllocTemp2."Start Date-Time");
                    UNTIL ServLaborAllocTemp2.NEXT(-1) = 0;
            END;

            ServLaborAllocTemp2.RESET;
            ServLaborAllocTemp2.DELETEALL;
            CurrentDay := CurrentDay - 1;
            StartTime := 000000T;
            DayQty += 1;
        UNTIL (QtyToAllocate <= 0) OR (DayQty > 1000);  //12.12.2014 EB.P8

        IF DayQty > 1000 THEN
            MESSAGE(Text102);
    end;

    [Scope('Internal')]
    procedure CalcHourDifference(StartDateTime: Decimal; EndDateTime: Decimal): Decimal
    begin
        //Returns difference in hours
        EXIT((EndDateTime - StartDateTime) / 3.6);
    end;

    [Scope('Internal')]
    procedure ChangeApplyTo(ChangeFromEntry: Integer; ChangeToEntry: Integer)
    var
        ServLaborAlloc: Record "25006271";
    begin
        ServLaborAlloc.RESET;
        ServLaborAlloc.SETCURRENTKEY("Applies-to Entry No.");
        ServLaborAlloc.SETRANGE("Applies-to Entry No.", ChangeFromEntry);
        ServLaborAlloc.SETFILTER("Entry No.", '<>%1', ChangeToEntry);
        IF ServLaborAlloc.FINDFIRST THEN
            REPEAT
                ServLaborAlloc.VALIDATE("Applies-to Entry No.", ChangeToEntry);  //14.03.2014 Elva Baltic P8 #S0003 MMG7.00
                ServLaborAlloc.MODIFY;
            UNTIL ServLaborAlloc.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SplitAllocTracking(EntryNo: Integer; Mode: Option Move,Delete): Boolean
    var
        LaborAllocEntryTemp: Record "25006271" temporary;
        QuestionText: Text[200];
    begin
        ServiceScheduleSetup.GET;
        IF ServiceScheduleSetup."Handle Linked Entries" = ServiceScheduleSetup."Handle Linked Entries"::No THEN
            EXIT(FALSE);

        IF ServiceScheduleSetup."Handle Linked Entries" = ServiceScheduleSetup."Handle Linked Entries"::Yes THEN
            EXIT(TRUE);

        IF Mode = Mode::Delete THEN
            QuestionText := Text100;

        IF ServiceScheduleSetup."Handle Linked Entries" = ServiceScheduleSetup."Handle Linked Entries"::Prompt THEN BEGIN
            FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
            LaborAllocEntryTemp.RESET;
            IF LaborAllocEntryTemp.COUNT > 1 THEN
                IF CONFIRM(QuestionText) THEN
                    EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure FillServiceLine(var ServiceLine1: Record "25006146")
    begin
        IF ServiceLine1.FINDFIRST THEN
            REPEAT
                ServiceLine := ServiceLine1;
                IF ServiceLine.INSERT THEN;
            UNTIL ServiceLine1.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure FillServiceLine2(var ServiceLineLoc: Record "25006146"; DocumentType: Integer; DocumentNo: Code[20]; LineNo: Integer)
    begin
        ServiceLineLoc."Document Type" := DocumentType;
        ServiceLineLoc."Document No." := DocumentNo;
        ServiceLineLoc."Line No." := LineNo;
        IF ServiceLineLoc.INSERT THEN;
    end;

    [Scope('Internal')]
    procedure CalculateTotalHours(EntryNo: Integer): Decimal
    var
        LaborAllocEntryTemp: Record "25006271" temporary;
        TotalHours: Decimal;
    begin
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
        IF LaborAllocEntryTemp.FINDFIRST THEN
            REPEAT
                TotalHours += LaborAllocEntryTemp."Quantity (Hours)";
            UNTIL LaborAllocEntryTemp.NEXT = 0;

        EXIT(TotalHours);
    end;

    [Scope('Internal')]
    procedure CalcLaborRemainHours(EntryNo: Integer): Decimal
    var
        LaborAllocEntryTemp: Record "25006271" temporary;
        TotalHours: Decimal;
    begin
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
        LaborAllocEntryTemp.SETFILTER(Status, '%1|%2', LaborAllocEntryTemp.Status::Pending, LaborAllocEntryTemp.Status::"On Hold");
        IF LaborAllocEntryTemp.FINDFIRST THEN
            REPEAT
                TotalHours += LaborAllocEntryTemp."Quantity (Hours)";
            UNTIL LaborAllocEntryTemp.NEXT = 0;

        EXIT(TotalHours);
    end;

    [Scope('Internal')]
    procedure ReplanEntries(ResourceNo: Code[20]; StartingDateTime: Decimal; ChangeHours: Decimal; DoOneServiceMoving: Boolean; SourceSubType: Option Qoute,"Order"; SourceID: Code[20])
    var
        LaborAllocEntry2: Record "25006271";
        LaborAllocApp2: Record "25006277";
        LaborAllocEntryTemp: Record "25006271" temporary;
        LaborAllocAppTemp: Record "25006277" temporary;
        ServiceLineTemp: Record "25006146" temporary;
        CurrentDay: Date;
        StartTime: Time;
        ApplyToEntry: Integer;
        NewStartingDateTime: Decimal;
        NewEndingDateTime: Decimal;
        OldEndingTime: Decimal;
        WorkHours: Decimal;
        DoReplan: Boolean;
    begin
        ServiceScheduleSetup.GET;
        OldEndingTime := 0;
        DoReplan := FALSE;
        LaborAllocEntry2.RESET;
        LaborAllocEntry2.SETRANGE("Resource No.", ResourceNo);
        LaborAllocEntry2.SETFILTER("Start Date-Time", '>=%1', StartingDateTime);
        LaborAllocEntry2.SETFILTER(Status, '%1|%2', LaborAllocEntry2.Status::Pending, LaborAllocEntry2.Status::"On Hold");
        LaborAllocEntry2.SETRANGE("Planning Policy", LaborAllocEntry2."Planning Policy"::Queue);

        IF LaborAllocEntry2.FINDFIRST THEN
            REPEAT
                LaborAllocEntryTemp := LaborAllocEntry2;
                LaborAllocEntryTemp.INSERT;
            UNTIL LaborAllocEntry2.NEXT = 0;

        IF DoOneServiceMoving THEN BEGIN
            LaborAllocEntry2.SETRANGE("Planning Policy");
            LaborAllocEntry2.SETRANGE("Source Type", LaborAllocEntry2."Source Type"::"Service Document");
            LaborAllocEntry2.SETRANGE("Source Subtype", SourceSubType);
            LaborAllocEntry2.SETRANGE("Source ID", SourceID);
            IF LaborAllocEntry2.FINDFIRST THEN
                REPEAT
                    LaborAllocEntryTemp := LaborAllocEntry2;
                    IF LaborAllocEntryTemp.INSERT THEN;
                UNTIL LaborAllocEntry2.NEXT = 0;
        END;

        LaborAllocEntryTemp.SETCURRENTKEY("Resource No.", "Start Date-Time");

        IF LaborAllocEntryTemp.FINDFIRST THEN
            REPEAT
                IF OldEndingTime <> 0 THEN BEGIN
                    WorkHours := CalcWorkHourDifference(ResourceNo, OldEndingTime, LaborAllocEntryTemp."Start Date-Time");
                    IF WorkHours <> 0 THEN
                        NewStartingDateTime := CalculateNewStartDateTime(ResourceNo, NewEndingDateTime, WorkHours)
                    ELSE
                        NewStartingDateTime := NewEndingDateTime;
                END ELSE BEGIN
                    NewStartingDateTime := LaborAllocEntryTemp."Start Date-Time" + ChangeHours * 3.6;
                    IF ChangeHours < 0 THEN BEGIN
                        WorkHours := CalcWorkHourDifference(ResourceNo, StartingDateTime, LaborAllocEntryTemp."Start Date-Time");
                        NewStartingDateTime := StartingDateTime + (WorkHours + ChangeHours) * 3.6;
                    END;
                END;

                OldEndingTime := LaborAllocEntryTemp."End Date-Time";
                WriteAllocationEntries(ResourceNo, NewStartingDateTime, LaborAllocEntryTemp."Quantity (Hours)",
                                       LaborAllocEntryTemp."Source Type", LaborAllocEntryTemp."Source Subtype",
                                       LaborAllocEntryTemp."Source ID", 1, LaborAllocEntryTemp."Entry No.", DoReplan,
                                       LaborAllocEntryTemp.Status, FALSE, FALSE);
                NewEndingDateTime := LaborAllocEntry."End Date-Time";
            UNTIL LaborAllocEntryTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CalcWorkHourDifference(ResourceNo: Code[20]; FromDateTime: Decimal; ToDateTime: Decimal): Decimal
    var
        ServLaborAllocTemp: Record "25006271" temporary;
        ServLaborAllocTemp2: Record "25006271" temporary;
        LaborAllocAppTemp: Record "25006277" temporary;
        CurrentDay: Date;
        StartTime: Time;
        LastTime: Decimal;
        AllocateCurrentQty: Decimal;
        AllocateStartDateTime: Decimal;
        AllocateCurrentEndDateTime: Decimal;
        WorkHours: Decimal;
        FromDateTime2: Decimal;
        CycleEnd: Boolean;
        IsReverse: Boolean;
        DoChangeServLineResource: Boolean;
    begin
        IsReverse := FALSE;
        IF FromDateTime > ToDateTime THEN BEGIN
            FromDateTime2 := FromDateTime;
            FromDateTime := ToDateTime;
            ToDateTime := FromDateTime2;
            IsReverse := TRUE;
        END;

        CurrentDay := DateTimeMgt.Datetime2Date(FromDateTime);
        StartTime := DateTimeMgt.Datetime2Time(FromDateTime);
        CycleEnd := FALSE;
        DoChangeServLineResource := FALSE;

        REPEAT
            IF IsTimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, 0) THEN BEGIN
                IsStarttimeAvailable(ServLaborAllocTemp2, ResourceNo, CurrentDay, StartTime);
                ServLaborAllocTemp2.RESET;
                ServLaborAllocTemp2.SETCURRENTKEY("Resource No.", "Start Date-Time");
                LastTime := 0;
                IF ServLaborAllocTemp2.FINDFIRST THEN
                    REPEAT
                        IF (LastTime <> 0) AND (LastTime < ServLaborAllocTemp2."Start Date-Time") THEN BEGIN
                            IF ToDateTime <= ServLaborAllocTemp2."Start Date-Time" THEN BEGIN
                                AllocateCurrentEndDateTime := ToDateTime;
                                CycleEnd := TRUE;
                            END ELSE
                                AllocateCurrentEndDateTime := ServLaborAllocTemp2."Start Date-Time";
                            AllocateStartDateTime := LastTime;
                            AllocateCurrentQty := CalcHourDifference(AllocateStartDateTime, AllocateCurrentEndDateTime);
                            InsertAllocationEntry(ServLaborAllocTemp, LaborAllocAppTemp, ResourceNo, AllocateStartDateTime, AllocateCurrentQty,
                                                  0, 0, 'Err8', 0, DoChangeServLineResource, FALSE);
                        END;
                        ServLaborAllocTemp2.SETFILTER("End Date-Time", '>%1', ServLaborAllocTemp2."End Date-Time");
                        LastTime := ServLaborAllocTemp2."End Date-Time";
                    UNTIL (ServLaborAllocTemp2.NEXT = 0) OR CycleEnd;
            END;
            ServLaborAllocTemp2.RESET;
            ServLaborAllocTemp2.DELETEALL;
            CurrentDay := CurrentDay + 1;
            StartTime := 000000T;
        UNTIL CycleEnd OR (DateTimeMgt.Datetime(CurrentDay, StartTime) > ToDateTime);

        WorkHours := 0;
        ServLaborAllocTemp.RESET;
        IF ServLaborAllocTemp.FINDFIRST THEN
            REPEAT
                WorkHours += ServLaborAllocTemp."Quantity (Hours)";
            UNTIL ServLaborAllocTemp.NEXT = 0;

        IF IsReverse THEN
            EXIT(-WorkHours);

        EXIT(WorkHours);
    end;

    [Scope('Internal')]
    procedure CalculateNewStartDateTime(ResourceNo: Code[20]; StartingDateTime: Decimal; QtyToAllocate: Decimal): Decimal
    var
        ServLaborAllocTemp: Record "25006271" temporary;
        CurrentDay: Date;
        StartTime: Time;
    begin
        CurrentDay := DateTimeMgt.Datetime2Date(StartingDateTime);
        StartTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        IF QtyToAllocate > 0 THEN
            ReturnAvailableTimes(ServLaborAllocTemp, QtyToAllocate, ResourceNo, CurrentDay, StartTime, 0)
        ELSE BEGIN
            QtyToAllocate *= -1;
            ReturnAvailableTimesBackward(ServLaborAllocTemp, QtyToAllocate, ResourceNo, CurrentDay, StartTime, 0);
        END;

        ServLaborAllocTemp.RESET;
        IF ServLaborAllocTemp.FINDLAST THEN
            EXIT(ServLaborAllocTemp."End Date-Time")
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CheckForTime(ResourceNo: Code[20]; StartingDateTime: Decimal; FinishingDateTime: Decimal; EntryNo: Integer; DoOneServiceMoving: Boolean; SourceSubType: Option Qoute,"Order"; SourceID: Code[20]): Decimal
    var
        ServLaborAlloc: Record "25006271";
        ContinueStartingDateTime: Decimal;
    begin
        ContinueStartingDateTime := FinishingDateTime;

        ServLaborAlloc.RESET;
        ServLaborAlloc.SETRANGE("Resource No.", ResourceNo);
        ServLaborAlloc.SETRANGE("Start Date-Time", StartingDateTime, FinishingDateTime - 0.00001);
        IF EntryNo <> 0 THEN
            ServLaborAlloc.SETFILTER("Entry No.", '<>%1', EntryNo);
        ServLaborAlloc.SETCURRENTKEY("Resource No.", "Start Date-Time");

        IF DoOneServiceMoving THEN BEGIN
            ServLaborAlloc.SETRANGE("Source Type", ServLaborAlloc."Source Type"::"Service Document");
            ServLaborAlloc.SETRANGE("Source Subtype", SourceSubType);
            ServLaborAlloc.SETRANGE("Source ID", SourceID);
        END;

        IF ServLaborAlloc.FINDFIRST THEN
            ContinueStartingDateTime := ServLaborAlloc."Start Date-Time";

        EXIT(CalcHourDifference(ContinueStartingDateTime, FinishingDateTime));
    end;

    [Scope('Internal')]
    procedure SplitServiceLine(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; LineNo: Integer): Integer
    var
        ServiceLineLoc: Record "25006146";
        NewLineNo: Integer;
    begin
        IF ServiceLineLoc.GET(DocumentType, DocumentNo, LineNo) THEN
            NewLineNo := DocumentMgt.ServiceSplitLine(ServiceLineLoc, 2)
        ELSE
            NewLineNo := LineNo;

        EXIT(NewLineNo)
    end;

    [Scope('Internal')]
    procedure FindServiceEntries(var LaborAllocEntry: Record "25006271"; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; ResourceNo: Code[20])
    var
        LaborAllocEntryLoc: Record "25006271";
    begin
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", DocumentType);
        LaborAllocApp.SETRANGE("Document No.", DocumentNo);
        LaborAllocApp.SETRANGE("Resource No.", ResourceNo);
        IF LaborAllocApp.FINDFIRST THEN
            REPEAT
                IF (LaborAllocEntryLoc.GET(LaborAllocApp."Allocation Entry No.")) AND
                   NOT (LaborAllocEntry.GET(LaborAllocApp."Allocation Entry No."))
                THEN BEGIN
                    LaborAllocEntry := LaborAllocEntryLoc;
                    LaborAllocEntry.INSERT;
                END;
            UNTIL LaborAllocApp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ProcessStartLabor(StartingDateTime: Decimal)
    var
        WorkTimeEntry: Record "25006276";
        Hours: Decimal;
        EntryNo: Integer;
        DoReplan: Boolean;
        ResourceNo: Code[20];
        OnDate: Date;
        OnTime: Time;
        Travel: Boolean;
    begin
        ServiceScheduleSetup.GET;
        ScheduleAction := ScheduleAction::"Time Registration";
        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        LaborAllocEntry.GET(EntryNo);
        Travel := LaborAllocEntry.Travel;
        //P8 >>
        //Hours := CalcLaborRemainHours(LaborAllocEntry."Entry No.");
        //Hours := LaborAllocEntry."Quantity (Hours)";  //20.07.2013 EDMS P8
        //P8 <<

        //Hours := CalcHourDifference(StartingDateTime,LaborAllocEntry."End Date-Time");
        Hours := LaborAllocEntry."Quantity (Hours)";
        //IF Hours <= 0 THEN
        //  Hours := LaborAllocEntry."Quantity (Hours)";

        ReasonCodeGlobal := LaborAllocEntry."Reason Code";

        ChangeAllocationStatus := TRUE;
        AllocationStatus := AllocationStatus::"In Process";

        AskedForAllocationSpliting := TRUE;
        //DoReplan := FALSE; // P8 old
        DoReplan := TRUE; // P8 new version
        //P8 >>
        IF Resource."No." <> '' THEN
            //THAT COLD BE FILLED IN CompareSchedulePassword from P25006355
            ResourceNo := Resource."No."  //17.10.2013 EDMS P8
        ELSE
            ResourceNo := LaborAllocEntry."Resource No.";

        SingleInstanceMgt.SetDateFilter(DateTimeMgt.Datetime2Date(StartingDateTime));
        OnDate := DateTimeMgt.Datetime2Date(StartingDateTime);
        OnTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);

        IF (LaborAllocEntry."Start Date-Time" <> StartingDateTime) OR
          (LaborAllocEntry."Quantity (Hours)" <> Hours) THEN BEGIN
            ProcessMovement(LaborAllocEntry."Entry No.", ResourceNo,
               StartingDateTime, Hours, 1, AllocationStatus, 1, Travel);
        END ELSE BEGIN
            WriteAllocationEntries(ResourceNo, StartingDateTime, Hours,
                                 LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                 LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, AllocationStatus, FALSE, Travel);  //20.07.2013 EDMS P8
        END;
        //P8 <<


        //Check for Hold/Complete other tasks.
        FinishOtherTasks(ResourceNo, EntryNo, StartingDateTime);
    end;

    [Scope('Internal')]
    procedure ProcessFinishLabor(EndingDateTime: Decimal; AllocationStatus1: Option Pending,"In Process","Finish All","Finish Part","On Hold"; HoldHours: Decimal; ReasonCode: Code[10])
    var
        FinishedHours: Decimal;
        EntryNo: Integer;
        DoReplan: Boolean;
        OnDate: Date;
        OnTime: Time;
        Travel: Boolean;
    begin
        ScheduleAction := ScheduleAction::"Time Registration";
        ServiceScheduleSetup.GET;
        AllocationStatusAction := AllocationStatus1;

        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        LaborAllocEntry.GET(EntryNo);
        Travel := LaborAllocEntry.Travel;
        CASE AllocationStatus1 OF
            AllocationStatus1::Pending:
                AllocationStatus := AllocationStatus::Pending;
            AllocationStatus1::"In Process":
                AllocationStatus := AllocationStatus::"In Process";
            AllocationStatus1::"Finish All", AllocationStatus1::"Finish Part":
                AllocationStatus := AllocationStatus::Finished;
            AllocationStatus1::"On Hold":
                AllocationStatus := AllocationStatus::"On Hold";
        END;

        IF AllocationStatus IN [AllocationStatus::Finished] THEN
            DoReplan := TRUE
        ELSE
            DoReplan := FALSE;

        IF AllocationStatus1 = AllocationStatus1::"Finish All" THEN BEGIN
            WriteAllocationEntryEnd(EntryNo, EndingDateTime, DoReplan, ReasonCode, Travel);
            CheckRemainingLinkedAllocation(EntryNo); //Possibly bug inside function.
        END;

        IF AllocationStatus1 = AllocationStatus1::"Finish Part" THEN
            WriteAllocationEntryEnd(EntryNo, EndingDateTime, DoReplan, ReasonCode, Travel);

        IF AllocationStatus = AllocationStatus::"On Hold" THEN BEGIN
            //AllocationStatus := AllocationStatus::Finished;
            //AllocationStatus := AllocationStatus::"On Hold";
            WriteAllocationEntryEnd(EntryNo, EndingDateTime, DoReplan, ReasonCode, Travel);
            HoldHours += CheckRemainingLinkedAllocation(EntryNo);  //15.08.2013 EDMS P8
            LaborAllocEntry.GET(EntryNo);  //20.07.2013 EDMS P8

            ChangeAllocationStatus := TRUE;
            AllocationStatus := AllocationStatus::"On Hold";
            ReasonCodeGlobal := ReasonCode;
            IF HoldHours > 0 THEN
                WriteAllocationEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."End Date-Time", HoldHours,
                                     LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                     //                         LaborAllocEntry."Source ID", 0, 0, DoReplan, AllocationStatus, TRUE);  //20.07.2013 EDMS P8
                                     //                         LaborAllocEntry."Source ID", 0, LaborAllocEntry."Entry No.", DoReplan, AllocationStatus, FALSE);  //20.07.2013 EDMS P8
                                     LaborAllocEntry."Source ID", 0, LaborAllocEntry."Entry No.", DoReplan, AllocationStatus, TRUE, Travel);  //15.08.2013 EDMS P8
        END;

        OnDate := DateTimeMgt.Datetime2Date(EndingDateTime);
        OnTime := DateTimeMgt.Datetime2Time(EndingDateTime);
        IF NOT ResourceTimeRegMgt.HasTasksInProgress(LaborAllocEntry."Resource No.") THEN
            ResourceTimeRegMgt.StartDefaultIdleTask(LaborAllocEntry."Resource No.", OnDate, OnTime);
    end;

    [Scope('Internal')]
    procedure ProcessBreak(StandardCode: Code[20]; ReasonCode: Code[10]; BreakHours: Decimal)
    var
        LaborAllocEntry2: Record "25006271";
        LaborAllocEntry3: Record "25006271";
        ServStandardEvent: Record "25006272";
        CurrDateTime: Decimal;
        FinishedHours: Decimal;
        HoldHours: Decimal;
        DoReplan: Boolean;
        Travel: Boolean;
    begin
        ScheduleAction := ScheduleAction::"Time Registration";
        ServiceScheduleSetup.GET;
        ServStandardEvent.GET(StandardCode);  //12.08.2013 EDMS P8

        CurrDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);
        LaborAllocEntry2.GET(SingleInstanceMgt.GetAllocationEntryNo);
        FinishedHours := CalcHourDifference(LaborAllocEntry2."Start Date-Time", CurrDateTime);
        HoldHours := LaborAllocEntry2."Quantity (Hours)" - FinishedHours;
        DoReplan := TRUE;
        Travel := LaborAllocEntry2.Travel;

        AllocationStatus := AllocationStatus::Finished;
        WriteAllocationEntryEnd(SingleInstanceMgt.GetAllocationEntryNo, CurrDateTime, DoReplan, ReasonCode, Travel);

        AllocationStatus := AllocationStatus::Pending;
        WriteAllocationEntries(LaborAllocEntry2."Resource No.", CurrDateTime, BreakHours, 2, 0, StandardCode, 0, 0, DoReplan, 0, FALSE, Travel);

        ChangeAllocationStatus := TRUE;
        AllocationStatus := AllocationStatus::"On Hold";
        WriteAllocationEntries(LaborAllocEntry2."Resource No.", LaborAllocEntry."End Date-Time", HoldHours,
                               LaborAllocEntry2."Source Type", LaborAllocEntry2."Source Subtype",
                               LaborAllocEntry2."Source ID", 0, SingleInstanceMgt.GetAllocationEntryNo, DoReplan, -1, FALSE, Travel);
    end;

    [Scope('Internal')]
    procedure ProcessHoldLabor(CurrentDateTime: Decimal)
    var
        WorkTimeEntry: Record "25006276";
        Hours: Decimal;
        EntryNo: Integer;
        DoReplan: Boolean;
        ResourceNo: Code[20];
        LaborAllocEntryTmp: Record "25006271" temporary;
        LaborAllocEntry: Record "25006271";
        OnDate: Date;
        OnTime: Time;
        Travel: Boolean;
    begin
        /*
        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        FindSplitEntries(EntryNo, LaborAllocEntryTmp, 0, 1111);
        IF LaborAllocEntryTmp.FINDFIRST THEN
          REPEAT
            IF LaborAllocEntry.GET(LaborAllocEntryTmp."Entry No.") THEN BEGIN
              ReasonCodeGlobal := LaborAllocEntry."Reason Code";
              AllocationStatus := AllocationStatus::"On Hold";
              ChangeStatus(LaborAllocEntry);
            END;
          UNTIL LaborAllocEntryTmp.NEXT = 0;
        
        ChangeServiceLineStatus(EntryNo,FALSE);
        
        OnDate := DateTimeMgt.Datetime2Date(CurrentDateTime);
        OnTime := DateTimeMgt.Datetime2Time(CurrentDateTime);
        IF NOT ResourceTimeRegMgt.HasTasksInProgress(LaborAllocEntryTmp."Resource No.") THEN
          ResourceTimeRegMgt.StartDefaultIdleTask(LaborAllocEntryTmp."Resource No.",OnDate,OnTime);
        */

        ServiceScheduleSetup.GET;
        ScheduleAction := ScheduleAction::"Time Registration";
        EntryNo := SingleInstanceMgt.GetAllocationEntryNo;
        LaborAllocEntry.GET(EntryNo);
        Travel := LaborAllocEntry.Travel;

        Hours := CalcHourDifference(CurrentDateTime, LaborAllocEntry."End Date-Time");
        IF Hours <= 0 THEN
            Hours := LaborAllocEntry."Quantity (Hours)";

        ReasonCodeGlobal := LaborAllocEntry."Reason Code";

        ChangeAllocationStatus := TRUE;
        AllocationStatus := AllocationStatus::"On Hold";

        AskedForAllocationSpliting := TRUE;
        DoReplan := TRUE;
        IF Resource."No." <> '' THEN
            ResourceNo := Resource."No."
        ELSE
            ResourceNo := LaborAllocEntry."Resource No.";

        SingleInstanceMgt.SetDateFilter(DateTimeMgt.Datetime2Date(CurrentDateTime));
        OnDate := DateTimeMgt.Datetime2Date(CurrentDateTime);
        OnTime := DateTimeMgt.Datetime2Time(CurrentDateTime);

        //ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo,OnDate,OnTime);

        IF (LaborAllocEntry."Start Date-Time" <> CurrentDateTime) OR
          (LaborAllocEntry."Quantity (Hours)" <> Hours) THEN BEGIN
            ProcessMovement(LaborAllocEntry."Entry No.", ResourceNo,
               CurrentDateTime, Hours, 1, AllocationStatus, 1, Travel);
        END ELSE BEGIN
            WriteAllocationEntries(ResourceNo, CurrentDateTime, Hours,
                                 LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                 LaborAllocEntry."Source ID", 1, EntryNo, DoReplan, AllocationStatus, FALSE, Travel);
        END;

        IF NOT ResourceTimeRegMgt.HasTasksInProgress(ResourceNo) THEN
            ResourceTimeRegMgt.StartDefaultIdleTask(ResourceNo, OnDate, OnTime);

    end;

    [Scope('Internal')]
    procedure ChangeStatus(var LaborAllocEntry: Record "25006271")
    begin
        LaborAllocEntry.VALIDATE(Status, AllocationStatus);
        LaborAllocEntry.VALIDATE("Reason Code", ReasonCodeGlobal);
        LaborAllocEntry.MODIFY;
    end;

    [Scope('Internal')]
    procedure ChangeServiceLineStatus(EntryNo: Integer; Remove: Boolean)
    var
        ServiceHdr: Record "25006145";
        ServiceLine: Record "25006146";
        ServiceLineTemp: Record "25006146" temporary;
        PostedServiceHdr: Record "25006149";
        PostedServiceLine: Record "25006150";
        PostedServRetHdr: Record "25006154";
        PostedServRetLine: Record "25006155";
        LaborAllocEntry: Record "25006271";
        LaborAllocApp: Record "25006277";
        LaborAllocApp2: Record "25006277";
        WorkStatus: Record "25006166";
        CurrStatus: Integer;
        WorkStatusCode: Code[10];
        Resource: Record "156";
    begin
        LaborAllocEntry.GET(EntryNo);
        IF LaborAllocEntry."Source Type" <> LaborAllocEntry."Source Type"::"Service Document" THEN
            EXIT;

        IF DontChangeServiceStatus THEN
            EXIT;


        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
        IF LaborAllocApp.FINDFIRST THEN
            REPEAT
                CurrStatus := 999999;
                WorkStatusCode := '';
                LaborAllocApp2.RESET;
                LaborAllocApp2.SETRANGE("Document Type", LaborAllocApp."Document Type");
                LaborAllocApp2.SETRANGE("Document No.", LaborAllocApp."Document No.");
                IF LaborAllocApp."Document Line No." <> 0 THEN BEGIN
                    LaborAllocApp2.SETRANGE("Document Line No.", LaborAllocApp."Document Line No.");
                    IF Remove THEN
                        LaborAllocApp2.SETFILTER("Allocation Entry No.", '<>%1', EntryNo);
                    IF LaborAllocApp2.FINDFIRST THEN
                        REPEAT
                            Resource.GET(LaborAllocApp2."Resource No.");
                            IF NOT (ServiceScheduleSetup."Only Pers. Affect Doc. Status" AND
                                (Resource.Type = Resource.Type::Machine)) THEN BEGIN
                                IF LaborAllocEntry.GET(LaborAllocApp2."Allocation Entry No.") THEN BEGIN
                                    WorkStatus.RESET;
                                    WorkStatus.SETRANGE("Service Order Status", LaborAllocEntry.Status);
                                    IF WorkStatus.FINDFIRST THEN;

                                    IF CurrStatus > WorkStatus.Priority THEN BEGIN
                                        CurrStatus := WorkStatus.Priority;
                                        WorkStatusCode := WorkStatus.Code;
                                    END;
                                END;
                            END;
                        UNTIL LaborAllocApp2.NEXT = 0;

                    IF NOT LaborAllocApp.Posted THEN BEGIN
                        //Preparing temp variable to be used as parameter
                        ServiceLineTemp.RESET;
                        ServiceLineTemp.DELETEALL;
                        ServiceLine.RESET;
                        ServiceLine.SETRANGE("Document Type", LaborAllocApp."Document Type");
                        ServiceLine.SETRANGE("Document No.", LaborAllocApp."Document No.");
                        IF ServiceLine.FINDFIRST THEN
                            REPEAT
                                ServiceLineTemp.INIT;
                                ServiceLineTemp := ServiceLine;
                                ServiceLineTemp.INSERT;
                            UNTIL ServiceLine.NEXT = 0;

                        //Updating service line status
                        ServiceLine.RESET;
                        ServiceLine.GET(LaborAllocApp."Document Type", LaborAllocApp."Document No.", LaborAllocApp."Document Line No.");
                        ServiceLine.Status := WorkStatusCode;
                        IF NOT GlobDontModifyServLine THEN
                            ServiceLine.MODIFY(TRUE);

                        //Updating service line status in temp variable
                        ServiceLineTemp.GET(LaborAllocApp."Document Type", LaborAllocApp."Document No.", LaborAllocApp."Document Line No.");
                        ServiceLineTemp.Status := WorkStatusCode;
                        ServiceLineTemp.MODIFY(TRUE);

                        ServiceHdr.GET(ServiceLine."Document Type", ServiceLine."Document No.");
                        ChangeServiceHeaderStatus(ServiceHdr, ServiceLineTemp);
                    END;
                END ELSE BEGIN
                    WorkStatus.RESET;
                    WorkStatus.SETRANGE("Service Order Status", LaborAllocEntry.Status);
                    IF WorkStatus.FINDFIRST THEN;
                    IF NOT LaborAllocApp.Posted THEN BEGIN
                        ServiceHdr.GET(LaborAllocApp."Document Type", LaborAllocApp."Document No.");
                        IF Remove THEN
                            ServiceHdr.VALIDATE("Work Status Code", '')
                        ELSE
                            ServiceHdr.VALIDATE("Work Status Code", WorkStatus.Code);
                        ServiceHdr.MODIFY(TRUE);
                    END;
                END;
            UNTIL LaborAllocApp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ChangeServiceHeaderStatusOld(ServiceHeader: Record "25006145"; var ServiceLine: Record "25006146")
    var
        ServiceWorkStatus: Record "25006166";
        LowestStatus: Integer;
        StatusCode: Code[20];
    begin
        LowestStatus := 999999;
        StatusCode := '';

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceLine."Document Type"::Order);
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE(Type, ServiceLine.Type::Labor);
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                IF ServiceWorkStatus.GET(ServiceLine.Status) THEN BEGIN
                    IF ServiceWorkStatus.Priority < LowestStatus THEN BEGIN
                        LowestStatus := ServiceWorkStatus.Priority;
                        StatusCode := ServiceWorkStatus.Code;
                    END;
                END;
            UNTIL ServiceLine.NEXT = 0;

        ServiceHeader.VALIDATE("Work Status Code", StatusCode);
        ServiceHeader.MODIFY(TRUE);
    end;

    [Scope('Internal')]
    procedure ChangeServiceHeaderStatus(ServiceHeader: Record "25006145"; var ServiceLine: Record "25006146")
    var
        ServiceWorkStatus: Record "25006166";
        LowestStatus: Integer;
        StatusCode: Code[20];
        LaborAllocApp: Record "25006277";
        LaborAllocEntry: Record "25006271";
        Resource: Record "156";
    begin
        LowestStatus := 999999;
        StatusCode := '';

        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", ServiceHeader."Document Type");
        LaborAllocApp.SETRANGE("Document No.", ServiceHeader."No.");
        LaborAllocApp.SETRANGE("Document Line No.", 0);
        IF LaborAllocApp.FINDFIRST THEN
            REPEAT
                Resource.GET(LaborAllocApp."Resource No.");
                IF NOT (ServiceScheduleSetup."Only Pers. Affect Doc. Status" AND
                    (Resource.Type = Resource.Type::Machine)) THEN BEGIN
                    IF LaborAllocEntry.GET(LaborAllocApp."Allocation Entry No.") THEN BEGIN
                        ServiceWorkStatus.RESET;
                        ServiceWorkStatus.SETRANGE("Service Order Status", LaborAllocEntry.Status);
                        IF ServiceWorkStatus.FINDFIRST THEN BEGIN
                            IF ServiceWorkStatus.Priority < LowestStatus THEN BEGIN
                                LowestStatus := ServiceWorkStatus.Priority;
                                StatusCode := ServiceWorkStatus.Code;
                            END;
                        END;
                    END;
                END;
            UNTIL LaborAllocApp.NEXT = 0;

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE(Type, ServiceLine.Type::Labor);
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                IF ServiceWorkStatus.GET(ServiceLine.Status) THEN BEGIN
                    IF ServiceWorkStatus.Priority < LowestStatus THEN BEGIN
                        LowestStatus := ServiceWorkStatus.Priority;
                        StatusCode := ServiceWorkStatus.Code;
                    END;
                END;
            UNTIL ServiceLine.NEXT = 0;

        ServiceHeader.VALIDATE("Work Status Code", StatusCode);
        ServiceHeader.MODIFY(TRUE);
    end;

    [Scope('Internal')]
    procedure ProcessStartWorkday(ResourceNo: Code[20]; StartDateTime: Decimal)
    var
        WorkTimeEntry: Record "25006276";
        EntryNo: Integer;
        ServLaborAllocationEntry: Record "25006271";
        OnDate: Date;
        OnTime: Time;
    begin
        ScheduleAction := ScheduleAction::"Time Registration";
        WorkTimeEntry.RESET;
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF WorkTimeEntry.FINDFIRST THEN BEGIN
            MESSAGE(STRSUBSTNO(Text120, ResourceNo));
            EXIT;
        END;

        WorkTimeEntry.RESET;
        IF WorkTimeEntry.FINDLAST THEN
            EntryNo := WorkTimeEntry."Entry No." + 1
        ELSE
            EntryNo := 1;

        WorkTimeEntry.INIT;
        WorkTimeEntry."Entry No." := EntryNo;
        WorkTimeEntry.VALIDATE("Resource No.", ResourceNo);
        WorkTimeEntry.VALIDATE("Worktime Begin", StartDateTime);
        WorkTimeEntry.INSERT(TRUE);

        OnDate := DateTimeMgt.Datetime2Date(StartDateTime);
        OnTime := DateTimeMgt.Datetime2Time(StartDateTime);

        ResourceTimeRegMgt.AddWorkTimeRegEntries('STARTWORKTIME', ResourceNo, OnDate, OnTime);
        ResourceTimeRegMgt.StartDefaultIdleTask(ResourceNo, OnDate, OnTime);
    end;

    [Scope('Internal')]
    procedure ProcessEndWorkday(ResourceNo: Code[20]; EndDateTime: Decimal)
    var
        WorkTimeEntry: Record "25006276";
        ServLaborAllocationEntryL: Record "25006271";
        DoReplan: Boolean;
        ResourceTimeRegMgt: Codeunit "25006290";
        ServiceSetup: Record "25006120";
        ServStandardEvent: Record "25006272";
        OnDate: Date;
        OnTime: Time;
    begin
        ServiceSetup.GET;
        ScheduleAction := ScheduleAction::"Time Registration";
        DoReplan := FALSE;

        OnDate := DateTimeMgt.Datetime2Date(EndDateTime);
        OnTime := DateTimeMgt.Datetime2Time(EndDateTime);

        //Check for holded labors.
        ServLaborAllocationEntryL.RESET;
        ServLaborAllocationEntryL.SETRANGE("Resource No.", ResourceNo);
        ServLaborAllocationEntryL.SETRANGE(Status, Status::"In Progress");
        ServLaborAllocationEntryL.SETRANGE(Status, Status::"On Hold");
        IF ServLaborAllocationEntryL.FINDFIRST THEN
            ERROR(Text163);

        ServLaborAllocationEntryL.RESET;
        ServLaborAllocationEntryL.SETRANGE("Resource No.", ResourceNo);
        ServLaborAllocationEntryL.SETRANGE(Status, Status::"In Progress");
        //SETFILTER(Status,'%1|%2', Status::"In Progress",Status::"On Hold");
        ServLaborAllocationEntryL.SETFILTER("Source ID", '<>%1', ServiceSetup."Default Idle Event");
        IF ServLaborAllocationEntryL.FINDFIRST THEN BEGIN
            IF CONFIRM(Text129) THEN
                REPEAT
                    AllocationStatus := AllocationStatus::Finished;
                    WriteAllocationEntryEnd(ServLaborAllocationEntryL."Entry No.", EndDateTime, DoReplan, '', ServLaborAllocationEntryL.Travel);
                    ResourceTimeRegMgt.AddTimeRegEntries('Complete', ServLaborAllocationEntryL, ServLaborAllocationEntryL."Resource No.", OnDate, OnTime);
                UNTIL ServLaborAllocationEntryL.NEXT = 0
            ELSE
                ERROR(STRSUBSTNO(Text106, ServLaborAllocationEntryL."Source Subtype", ServLaborAllocationEntryL."Source ID"));
        END;

        WorkTimeEntry.SETCURRENTKEY("Resource No.", Closed);
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF NOT WorkTimeEntry.FINDLAST THEN BEGIN
            MESSAGE(STRSUBSTNO(Text119, ResourceNo));
            EXIT;
        END;

        WorkTimeEntry.VALIDATE("Worktime End", EndDateTime);
        WorkTimeEntry.VALIDATE("Worked Hours", CalcHourDifference(WorkTimeEntry."Worktime Begin", EndDateTime));
        WorkTimeEntry.VALIDATE(Closed, TRUE);
        WorkTimeEntry.MODIFY(TRUE);

        ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
        ResourceTimeRegMgt.AddWorkTimeRegEntries('FINISHWORKTIME', ResourceNo, OnDate, OnTime);
    end;

    [Scope('Internal')]
    procedure ProcessStartWorkdaySilent(ResourceNo: Code[20]; StartDateTime: Decimal)
    var
        WorkTimeEntry: Record "25006276";
        EntryNo: Integer;
        ServLaborAllocationEntry: Record "25006271";
        OnDate: Date;
        OnTime: Time;
    begin
        OnDate := DateTimeMgt.Datetime2Date(StartDateTime);
        OnTime := DateTimeMgt.Datetime2Time(StartDateTime);

        ScheduleAction := ScheduleAction::"Time Registration";
        WorkTimeEntry.RESET;
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF NOT WorkTimeEntry.FINDFIRST THEN BEGIN
            WorkTimeEntry.RESET;
            IF WorkTimeEntry.FINDLAST THEN
                EntryNo := WorkTimeEntry."Entry No." + 1
            ELSE
                EntryNo := 1;

            WorkTimeEntry.INIT;
            WorkTimeEntry."Entry No." := EntryNo;
            WorkTimeEntry.VALIDATE("Resource No.", ResourceNo);
            WorkTimeEntry.VALIDATE("Worktime Begin", StartDateTime);
            WorkTimeEntry.INSERT(TRUE);

            ResourceTimeRegMgt.AddWorkTimeRegEntries('STARTWORKTIME', ResourceNo, OnDate, OnTime);

        END;
    end;

    [Scope('Internal')]
    procedure CompareSchedulePassword(ResourceNo: Code[20]; SchedulePassword: Text[20])
    begin
        IF Resource.GET(ResourceNo) THEN
            IF Resource."Serv. Schedule Password" = SchedulePassword THEN
                EXIT;

        ERROR(Text112);
    end;

    [Scope('Internal')]
    procedure CreateFieldText(EntryNo: Integer): Text[250]
    var
        LaborAllocEntry: Record "25006271";
        LaborAllocApp: Record "25006277";
        ScheduleCellConfig: Record "25006280";
        ServHdr: Record "25006145";
        ServLine: Record "25006146";
        StandardEvent: Record "25006272";
        PostedServHdr: Record "25006149";
        PostedServLine: Record "25006150";
        ServLaborAllocationDetailLoc: Record "25006268";
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        EndText: Text[250];
        FieldValue: Text[250];
        FieldCaption: Text[250];
        FieldOption: Text[250];
        OptionNumber: Integer;
        SourceTypeFilter: Text;
        FieldRefClass: Option Normal,FlowFilter,FlowField;
    begin
        ScheduleCellConfig.SETCURRENTKEY(Sequence);
        EndText := '';
        LaborAllocEntry.GET(EntryNo);
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
        IF LaborAllocApp.FINDFIRST THEN;
        IF LaborAllocEntry."Source Type" = LaborAllocEntry."Source Type"::"Service Document" THEN BEGIN
            IF ServHdr.GET(LaborAllocApp."Document Type", LaborAllocApp."Document No.") THEN BEGIN
                IF LaborAllocApp."Document Line No." <> 0 THEN BEGIN
                    ServLine.GET(LaborAllocApp."Document Type", LaborAllocApp."Document No.", LaborAllocApp."Document Line No.");
                    SourceTypeFilter := FORMAT(DATABASE::"Service Header EDMS") + '|' + FORMAT(DATABASE::"Service Line EDMS");
                END ELSE
                    SourceTypeFilter := FORMAT(DATABASE::"Service Header EDMS");
            END ELSE
                IF PostedServHdr.GET(LaborAllocApp."Document No.") THEN BEGIN
                    IF LaborAllocApp."Document Line No." <> 0 THEN BEGIN
                        PostedServLine.GET(LaborAllocApp."Document No.", LaborAllocApp."Document Line No.");
                        SourceTypeFilter := FORMAT(DATABASE::"Posted Serv. Order Header") + '|' + FORMAT(DATABASE::"Posted Serv. Order Line");
                    END ELSE
                        SourceTypeFilter := FORMAT(DATABASE::"Posted Serv. Order Header");
                END ELSE
                    EXIT(LaborAllocEntry."Source ID");
        END ELSE BEGIN
            StandardEvent.GET(LaborAllocEntry."Source ID");
            SourceTypeFilter := FORMAT(DATABASE::"Serv. Standard Event");
        END;
        //24.10.2013 EDMS P8 >>
        IF LaborAllocEntry."Detail Entry No." > 0 THEN
            IF ServLaborAllocationDetailLoc.GET(LaborAllocEntry."Detail Entry No.") THEN BEGIN
                IF SourceTypeFilter <> '' THEN
                    SourceTypeFilter += '|';
                SourceTypeFilter += FORMAT(DATABASE::"Serv. Allocation Description");
                ;
            END;
        ScheduleCellConfig.SETFILTER("Source Type", SourceTypeFilter);
        //24.10.2013 EDMS P8 <<

        IF ScheduleCellConfig.FINDFIRST THEN
            REPEAT
                CASE ScheduleCellConfig."Source Type" OF
                    DATABASE::"Service Header EDMS":
                        BEGIN
                            RecordRef.OPEN(DATABASE::"Service Header EDMS");
                            RecordRef.GETTABLE(ServHdr);
                        END;
                    DATABASE::"Service Line EDMS":
                        BEGIN
                            RecordRef.OPEN(DATABASE::"Service Line EDMS");
                            RecordRef.GETTABLE(ServLine);
                        END;
                    DATABASE::"Posted Serv. Order Header":
                        BEGIN
                            RecordRef.OPEN(DATABASE::"Service Header EDMS");
                            RecordRef.GETTABLE(PostedServHdr);
                        END;
                    DATABASE::"Posted Serv. Order Line":
                        BEGIN
                            RecordRef.OPEN(DATABASE::"Service Line EDMS");
                            RecordRef.GETTABLE(PostedServLine);
                        END;
                    DATABASE::"Serv. Standard Event":
                        BEGIN
                            RecordRef.OPEN(DATABASE::"Serv. Standard Event");
                            RecordRef.GETTABLE(StandardEvent);
                        END;
                    //24.10.2013 EDMS P8 >>
                    DATABASE::"Serv. Allocation Description":
                        BEGIN
                            RecordRef.OPEN(DATABASE::"Serv. Allocation Description");
                            RecordRef.GETTABLE(ServLaborAllocationDetailLoc);
                        END;
                //24.10.2013 EDMS P8 <<
                END;

                FieldRef := RecordRef.FIELD(ScheduleCellConfig."Source Ref. No.");

                // 14.05.2014 Elva Baltic P21 #S0102 MMG7.00 >>
                EVALUATE(FieldRefClass, FORMAT(FieldRef.CLASS));
                IF FieldRefClass = FieldRefClass::FlowField THEN
                    FieldRef.CALCFIELD;
                // 14.05.2014 Elva Baltic P21 #S0102 MMG7.00 <<

                FieldValue := FORMAT(FieldRef.VALUE);
                FieldOption := FieldRef.OPTIONCAPTION;

                IF FieldOption <> '' THEN BEGIN
                    EVALUATE(OptionNumber, FieldValue);
                    FieldValue := SELECTSTR(OptionNumber + 1, FieldOption);
                END;

                IF ScheduleCellConfig.Prefix <> '' THEN
                    FieldCaption := ScheduleCellConfig.Prefix + ': '
                ELSE
                    FieldCaption := '';

                IF FieldValue <> '' THEN BEGIN
                    IF EndText = '' THEN
                        EndText := COPYSTR(FieldCaption + FieldValue, 1, 250)
                    ELSE
                        EndText := COPYSTR(EndText + '; ' + FieldCaption + FieldValue, 1, 250);
                END;
                RecordRef.CLOSE;
            UNTIL ScheduleCellConfig.NEXT = 0;

        EXIT(EndText);
    end;

    [Scope('Internal')]
    procedure CreateNewServiceDocument(DocumentType: Option Quote,"Order","Return Order"): Code[20]
    var
        ServHeader: Record "25006145";
    begin
        CLEAR(ServHeader);
        ServHeader.INIT;
        ServHeader."Document Type" := DocumentType;
        ServHeader.INSERT(TRUE);
        COMMIT;
        CASE DocumentType OF
            DocumentType::Quote:
                PAGE.RUNMODAL(PAGE::"Service Quote EDMS", ServHeader);
            DocumentType::Order:
                PAGE.RUNMODAL(PAGE::"Service Order EDMS", ServHeader);
        END;

        EXIT(ServHeader."No.");
    end;

    [Scope('Internal')]
    procedure DeleteAllocationFromServLines(ServLine: Record "25006146")
    var
        LaborAllocEntry: Record "25006271";
        LaborAllocApp: Record "25006277";
        LaborAllocEntry2: Record "25006271";
        LaborAllocApp2: Record "25006277";
        LaborAllocAppTemp: Record "25006277" temporary;
    begin
        // 18.12.2014 Elva Baltic P21 #E0003 >>
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", ServLine."Document Type");
        LaborAllocApp.SETRANGE("Document No.", ServLine."Document No.");
        LaborAllocApp.SETRANGE("Document Line No.", ServLine."Line No.");
        IF LaborAllocApp.FINDSET THEN
            REPEAT
                LaborAllocApp.DELETE(TRUE);
            UNTIL LaborAllocApp.NEXT = 0;
        // 18.12.2014 Elva Baltic P21 #E0003 <<

        LaborAllocApp.RESET;
        LaborAllocEntry.RESET;
        LaborAllocApp.SETRANGE("Document Type", ServLine."Document Type");
        LaborAllocApp.SETRANGE("Document No.", ServLine."Document No.");
        LaborAllocApp.SETRANGE("Document Line No.", ServLine."Line No.");
        IF LaborAllocApp.FINDFIRST THEN BEGIN
            IF GUIALLOWED THEN
                IF NOT CONFIRM(Text117) THEN
                    ERROR(Text118);
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocApp."Allocation Entry No.") THEN
                    IF LaborAllocEntry.Status = LaborAllocEntry.Status::Finished THEN
                        ERROR(Text116);
                LaborAllocAppTemp := LaborAllocApp;
                LaborAllocAppTemp.INSERT;
            UNTIL LaborAllocApp.NEXT = 0;
        END;

        IF LaborAllocAppTemp.FINDFIRST THEN  //tempp2
            REPEAT
                DeleteAllocationEntry(LaborAllocEntry2, LaborAllocApp2, LaborAllocAppTemp."Allocation Entry No.", 11111);
            UNTIL LaborAllocAppTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure DeleteAllocationFromServHdr(ServHdr: Record "25006145")
    var
        LaborAllocEntry: Record "25006271";
        LaborAllocApp: Record "25006277";
        LaborAllocEntry2: Record "25006271";
        LaborAllocApp2: Record "25006277";
        LaborAllocAppTemp: Record "25006277" temporary;
    begin
        LaborAllocApp.RESET;
        LaborAllocEntry.RESET;
        LaborAllocApp.SETRANGE("Document Type", ServHdr."Document Type");
        LaborAllocApp.SETRANGE("Document No.", ServHdr."No.");
        LaborAllocApp.SETRANGE("Document Line No.", 0);
        IF LaborAllocApp.FINDFIRST THEN BEGIN
            IF NOT CONFIRM(Text117) THEN
                ERROR(Text118);
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocApp."Allocation Entry No.") THEN
                    IF LaborAllocEntry.Status = LaborAllocEntry.Status::Finished THEN
                        ERROR(Text116);
                LaborAllocAppTemp := LaborAllocApp;
                LaborAllocAppTemp.INSERT;
            UNTIL LaborAllocApp.NEXT = 0;
        END;

        IF LaborAllocAppTemp.FINDFIRST THEN  //tempp2
            REPEAT
                DeleteAllocationEntry(LaborAllocEntry2, LaborAllocApp2, LaborAllocAppTemp."Allocation Entry No.", 11111);
            UNTIL LaborAllocAppTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ModifyReason(var LaborAllocEntry: Record "25006271"; ReasonCode: Code[10])
    begin
        LaborAllocEntry."Reason Code" := ReasonCode;
        LaborAllocEntry.MODIFY;
    end;

    [Scope('Internal')]
    procedure PostingServLine(ServiceLine: Record "25006146"; NewOrderNo: Code[20])
    var
        LaborAllocEntry: Record "25006271";
        LaborAllocApp: Record "25006277";
        LaborAllocEntryTemp: Record "25006271" temporary;
        LaborAllocAppTemp: Record "25006277" temporary;
    begin
        IF ServiceLine.Type <> ServiceLine.Type::Labor THEN
            EXIT;

        ServiceScheduleSetup.GET;
        LaborAllocApp.LOCKTABLE;
        LaborAllocEntry.LOCKTABLE;

        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", ServiceLine."Document Type");
        LaborAllocApp.SETRANGE("Document No.", ServiceLine."Document No.");
        LaborAllocApp.SETRANGE("Document Line No.", ServiceLine."Line No.");
        IF NOT LaborAllocApp.FINDFIRST THEN
            EXIT
        ELSE
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocApp."Allocation Entry No.") THEN BEGIN
                    IF (LaborAllocEntry.Status <> LaborAllocEntry.Status::Finished) AND ServiceScheduleSetup."Post Only When Finished" THEN
                        ERROR(STRSUBSTNO(Text115, ServiceLine."Line No."));
                    LaborAllocEntryTemp := LaborAllocEntry;
                    IF LaborAllocEntryTemp.INSERT THEN;
                END;
                LaborAllocAppTemp := LaborAllocApp;
                LaborAllocAppTemp.INSERT;
            UNTIL LaborAllocApp.NEXT = 0;

        IF LaborAllocAppTemp.FINDFIRST THEN
            REPEAT
                LaborAllocApp.GET(LaborAllocAppTemp."Allocation Entry No.", LaborAllocAppTemp."Document Type",
                                  LaborAllocAppTemp."Document No.", LaborAllocAppTemp."Document Line No.", LaborAllocAppTemp."Line No.");
                LaborAllocApp.DELETE(TRUE);
            UNTIL LaborAllocAppTemp.NEXT = 0;

        IF LaborAllocEntryTemp.FINDFIRST THEN
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocEntryTemp."Entry No.") THEN
                    LaborAllocEntry.DELETE;
            UNTIL LaborAllocEntryTemp.NEXT = 0;

        IF LaborAllocEntryTemp.FINDFIRST THEN
            REPEAT
                LaborAllocEntry.TRANSFERFIELDS(LaborAllocEntryTemp);
                LaborAllocEntry."Source ID" := NewOrderNo;
                LaborAllocEntry.INSERT;
            UNTIL LaborAllocEntryTemp.NEXT = 0;

        IF LaborAllocAppTemp.FINDFIRST THEN
            REPEAT
                LaborAllocApp.TRANSFERFIELDS(LaborAllocAppTemp);
                LaborAllocApp."Document No." := NewOrderNo;
                LaborAllocApp.Posted := TRUE;
                LaborAllocApp.INSERT(TRUE);
            UNTIL LaborAllocAppTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure PostingServHdr(ServiceHdr: Record "25006145"; NewOrderNo: Code[20])
    var
        LaborAllocEntry: Record "25006271";
        LaborAllocApp: Record "25006277";
        LaborAllocEntryTemp: Record "25006271" temporary;
        LaborAllocAppTemp: Record "25006277" temporary;
    begin
        ServiceScheduleSetup.GET;
        ServiceSetup.GET;
        LaborAllocApp.LOCKTABLE;
        LaborAllocEntry.LOCKTABLE;

        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", ServiceHdr."Document Type");
        LaborAllocApp.SETRANGE("Document No.", ServiceHdr."No.");
        LaborAllocApp.SETRANGE("Document Line No.", 0);
        IF NOT LaborAllocApp.FINDFIRST THEN
            EXIT
        ELSE
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocApp."Allocation Entry No.") THEN BEGIN
                    IF (LaborAllocEntry.Status <> LaborAllocEntry.Status::Finished) AND ServiceScheduleSetup."Post Only When Finished" THEN
                        ERROR(STRSUBSTNO(Text141, ServiceHdr."No."));
                    LaborAllocEntryTemp := LaborAllocEntry;
                    IF LaborAllocEntryTemp.INSERT THEN;
                END;
                LaborAllocAppTemp := LaborAllocApp;
                LaborAllocAppTemp.INSERT;
            UNTIL LaborAllocApp.NEXT = 0;

        IF LaborAllocAppTemp.FINDFIRST THEN
            REPEAT
                LaborAllocApp.GET(LaborAllocAppTemp."Allocation Entry No.", LaborAllocAppTemp."Document Type",
                                  LaborAllocAppTemp."Document No.", LaborAllocAppTemp."Document Line No.",
                                  LaborAllocAppTemp."Line No.");
                LaborAllocApp.DELETE(TRUE);
            UNTIL LaborAllocAppTemp.NEXT = 0;

        IF LaborAllocEntryTemp.FINDFIRST THEN
            REPEAT
                IF LaborAllocEntry.GET(LaborAllocEntryTemp."Entry No.") THEN
                    LaborAllocEntry.DELETE;
            UNTIL LaborAllocEntryTemp.NEXT = 0;

        IF LaborAllocEntryTemp.FINDFIRST THEN
            REPEAT
                LaborAllocEntry := LaborAllocEntryTemp;
                LaborAllocEntry."Source ID" := NewOrderNo;
                LaborAllocEntry.INSERT;
            UNTIL LaborAllocEntryTemp.NEXT = 0;

        IF LaborAllocAppTemp.FINDFIRST THEN
            REPEAT
                LaborAllocApp := LaborAllocAppTemp;
                LaborAllocApp."Document No." := NewOrderNo;
                LaborAllocApp.Posted := TRUE;
                LaborAllocApp.INSERT(TRUE);
            UNTIL LaborAllocAppTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ClearAllocationEntry(EntryNo: Integer; TimeCompensateByMoveOtherAlloc: Boolean)
    var
        LaborAllocEntry: Record "25006271";
        DoOneServiceMoving: Boolean;
    begin
        ServiceScheduleSetup.GET;
        IF NOT LaborAllocEntry.GET(EntryNo) THEN
            EXIT;

        IF TimeCompensateByMoveOtherAlloc THEN  //15.04.2013 EDMS P8
            ReplanEntries(LaborAllocEntry."Resource No.", LaborAllocEntry."End Date-Time",
                        -LaborAllocEntry."Quantity (Hours)", ServiceScheduleSetup."Replan Document",
                        LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID");

        LaborAllocEntry."Quantity (Hours)" := 0;
        LaborAllocEntry."End Date-Time" := LaborAllocEntry."Start Date-Time";
        LaborAllocEntry."Resource No." := '';
        LaborAllocEntry."User ID" := USERID;
        LaborAllocEntry.VALIDATE("Applies-to Entry No.", 0);  //14.03.2014 Elva Baltic P8 #S0003 MMG7.00
        LaborAllocEntry.Status := LaborAllocEntry.Status::Pending;
        LaborAllocEntry."Reason Code" := '';
        LaborAllocEntry.MODIFY;
    end;

    [Scope('Internal')]
    procedure ControlLaborSequence(SourceSubtype: Option Quote,"Order"; SourceID: Code[20]; LineNo: Integer; StartingDateTime: Decimal): Boolean
    var
        LaborAllocEntryLoc: Record "25006271";
        LaborAllocAppLoc: Record "25006277";
    begin
        ServiceScheduleSetup.GET;
        IF NOT ServiceScheduleSetup."Control Labor Sequence" THEN
            EXIT;
        LaborAllocAppLoc.RESET;
        LaborAllocAppLoc.SETRANGE("Document Type", SourceSubtype);
        LaborAllocAppLoc.SETRANGE("Document No.", SourceID);
        LaborAllocAppLoc.SETFILTER("Document Line No.", '<%1', LineNo);
        IF LaborAllocAppLoc.FINDFIRST THEN
            REPEAT
                IF LaborAllocEntryLoc.GET(LaborAllocAppLoc."Allocation Entry No.") THEN
                    IF (StartingDateTime < LaborAllocEntryLoc."Start Date-Time") AND NOT (AlreadyAskedAboutSequence) THEN BEGIN
                        IF CONFIRM(Text122) THEN
                            EXIT(TRUE)
                        ELSE
                            ERROR(Text124);
                        AlreadyAskedAboutSequence := TRUE;
                    END;
            UNTIL LaborAllocAppLoc.NEXT = 0;

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure ControlSkills(SourceSubtype: Option Quote,"Order"; SourceID: Code[20]; LineNo: Integer; ResourceNo: Code[20])
    var
        LaborAllocEntryLoc: Record "25006271";
        LaborAllocAppLoc: Record "25006277";
        ServiceLineLoc: Record "25006146";
        ResourceSkill: Record "25006160";
        LaborSkill: Record "25006161";
        MissedSkills: Text[1000];
        ResourceList: Text[500];
    begin
        ServiceScheduleSetup.GET;

        IF ServiceScheduleSetup."Control Skills" = ServiceScheduleSetup."Control Skills"::No THEN
            EXIT;
        IF (ServiceScheduleSetup."Control Skills" = ServiceScheduleSetup."Control Skills"::"Only Planning") AND
           (ScheduleAction = ScheduleAction::"Time Registration")
        THEN
            EXIT;

        MissedSkills := '';

        IF ServiceLineLoc.GET(SourceSubtype, SourceID, LineNo) THEN BEGIN
            IF ServiceLineLoc.Type <> ServiceLineLoc.Type::Labor THEN
                EXIT;

            LaborSkill.RESET;
            LaborSkill.SETRANGE("Labor Code", ServiceLineLoc."No.");
            IF LaborSkill.COUNT = 0 THEN
                EXIT;

            ResourceSkill.RESET;
            ResourceSkill.SETRANGE("Resource No.", ResourceNo);
            IF LaborSkill.FINDFIRST THEN
                REPEAT
                    ResourceSkill.SETRANGE("Skill Code", LaborSkill."Skill Code");
                    IF NOT ResourceSkill.FINDFIRST THEN BEGIN
                        IF MissedSkills <> '' THEN
                            MissedSkills += '; ';
                        MissedSkills += LaborSkill."Skill Code";
                    END;
                UNTIL LaborSkill.NEXT = 0;

            IF (MissedSkills <> '') AND NOT (AlreadyAskedAboutSkills) THEN BEGIN
                IF NOT CONFIRM(STRSUBSTNO(Text125, ResourceNo, MissedSkills)) THEN BEGIN
                    ResourceList := '';
                    ResourceList := AvailableResourceWithSkills(ResourceNo, LaborSkill);
                    IF ResourceList <> '' THEN
                        ERROR(STRSUBSTNO(Text139, ResourceList))
                    ELSE
                        ERROR(Text124);
                END;
                AlreadyAskedAboutSkills := TRUE;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure AvailableResourceWithSkills(ResourceNo: Code[20]; var LaborSkill: Record "25006161"): Text[500]
    var
        ScheduleResourceGroupSpec: Record "25006275";
        ScheduleResourceGroupSpec2: Record "25006275";
        ResourceSkill: Record "25006160";
        ResourceTemp: Record "156" temporary;
        ResourceList: Text[500];
        ResourceAccepted: Boolean;
        i: Integer;
    begin
        ResourceTemp.RESET;
        ResourceTemp.DELETEALL;
        ResourceList := '';
        ScheduleResourceGroupSpec.RESET;
        ScheduleResourceGroupSpec.SETRANGE("Resource No.", ResourceNo);
        IF ScheduleResourceGroupSpec.FINDFIRST THEN
            REPEAT
                ScheduleResourceGroupSpec2.RESET;
                ScheduleResourceGroupSpec2.SETRANGE("Group Code", ScheduleResourceGroupSpec."Group Code");
                ScheduleResourceGroupSpec2.SETFILTER("Resource No.", '<>%1', ResourceNo);
                IF ScheduleResourceGroupSpec2.FINDFIRST THEN
                    REPEAT
                        ResourceAccepted := TRUE;
                        ResourceSkill.RESET;
                        ResourceSkill.SETRANGE("Resource No.", ScheduleResourceGroupSpec2."Resource No.");
                        IF LaborSkill.FINDFIRST THEN
                            REPEAT
                                ResourceSkill.SETRANGE("Skill Code", LaborSkill."Skill Code");
                                IF NOT ResourceSkill.FINDFIRST THEN
                                    ResourceAccepted := FALSE;
                            UNTIL LaborSkill.NEXT = 0;
                        IF ResourceAccepted THEN BEGIN
                            ResourceTemp.INIT;
                            ResourceTemp."No." := ScheduleResourceGroupSpec2."Resource No.";
                            IF ResourceTemp.INSERT THEN;
                        END;
                    UNTIL ScheduleResourceGroupSpec2.NEXT = 0;
            UNTIL ScheduleResourceGroupSpec.NEXT = 0;

        i := 0;
        IF ResourceTemp.FINDFIRST THEN
            REPEAT
                IF ResourceList <> '' THEN
                    ResourceList += ';';
                ResourceList += ResourceTemp."No.";
                i += 1;
            UNTIL (ResourceTemp.NEXT = 0) OR (i = 5);

        EXIT(ResourceList);
    end;

    [Scope('Internal')]
    procedure FromQuoteToOrder(ServiceLine: Record "25006146"; NewServiceNo: Code[20])
    var
        LaborAllocEntryLoc: Record "25006271";
        LaborAllocAppLoc: Record "25006277";
        LaborAllocAppLocTemp: Record "25006277" temporary;
    begin
        LaborAllocAppLoc.RESET;
        LaborAllocAppLoc.SETRANGE("Document Type", ServiceLine."Document Type");
        LaborAllocAppLoc.SETRANGE("Document No.", ServiceLine."Document No.");
        LaborAllocAppLoc.SETRANGE("Document Line No.", ServiceLine."Line No.");
        IF LaborAllocAppLoc.FINDFIRST THEN
            REPEAT
                LaborAllocAppLocTemp := LaborAllocAppLoc;
                LaborAllocAppLocTemp."Document Type" := LaborAllocAppLocTemp."Document Type"::Order;
                LaborAllocAppLocTemp."Document No." := NewServiceNo;
                LaborAllocAppLocTemp.INSERT;
                IF LaborAllocEntryLoc.GET(LaborAllocAppLoc."Allocation Entry No.") THEN BEGIN
                    LaborAllocEntryLoc."Source Subtype" := LaborAllocEntryLoc."Source Subtype"::Order;
                    LaborAllocEntryLoc."Source ID" := NewServiceNo;
                    LaborAllocEntryLoc.MODIFY;
                END;
            UNTIL LaborAllocAppLoc.NEXT = 0
        ELSE
            EXIT;

        LaborAllocAppLoc.RESET;
        LaborAllocAppLoc.SETRANGE("Document Type", ServiceLine."Document Type");
        LaborAllocAppLoc.SETRANGE("Document No.", ServiceLine."Document No.");
        LaborAllocAppLoc.SETRANGE("Document Line No.", ServiceLine."Line No.");
        LaborAllocAppLoc.DELETEALL;

        IF LaborAllocAppLocTemp.FINDFIRST THEN
            REPEAT
                LaborAllocAppLoc := LaborAllocAppLocTemp;
                LaborAllocAppLoc.INSERT(TRUE);
            UNTIL LaborAllocAppLocTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CheckRemainingLinkedAllocation(EntryNo: Integer) RetValue: Decimal
    var
        LaborAllocEntryLoc: Record "25006271";
        LaborAllocAppLoc: Record "25006277";
        LaborAllocEntryTemp: Record "25006271" temporary;
    begin
        //Possibly bug inside function.
        //RetValue - returns deleted hours
        FindSplitEntries(EntryNo, LaborAllocEntryTemp, 0, 1111);
        LaborAllocEntryTemp.RESET;
        LaborAllocEntryTemp.SETCURRENTKEY("Resource No.", "End Date-Time");
        LaborAllocEntryTemp.SETFILTER(Status, '%1|%2|%3', LaborAllocEntryTemp.Status::Pending, LaborAllocEntryTemp.Status::"On Hold", LaborAllocEntryTemp.Status::"In Progress");

        IF LaborAllocEntryTemp.FINDFIRST THEN BEGIN
            REPEAT
                RetValue += LaborAllocEntryTemp."Quantity (Hours)";
                DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, LaborAllocEntryTemp."Entry No.", 11111);
            UNTIL LaborAllocEntryTemp.NEXT = 0;
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure CheckLaborStatus(LaborAllocEntryLoc: Record "25006271"): Boolean
    var
        StatusFinishProgress: Integer;
        StatusPendingHold: Integer;
    begin
        StatusFinishProgress := 0;
        StatusPendingHold := 0;
        LaborAllocEntryLoc.RESET;
        IF LaborAllocEntryLoc.FINDFIRST THEN
            REPEAT
                IF LaborAllocEntryLoc.Status IN [LaborAllocEntryLoc.Status::Pending, LaborAllocEntryLoc.Status::"On Hold"] THEN
                    StatusPendingHold += 1;
                IF LaborAllocEntryLoc.Status IN [LaborAllocEntryLoc.Status::Finished, LaborAllocEntryLoc.Status::"In Progress"] THEN
                    StatusFinishProgress += 1;
            UNTIL LaborAllocEntryLoc.NEXT = 0;

        IF (StatusFinishProgress > 0) AND (StatusPendingHold > 0) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure JoinAllocationEntries(ResourceNo: Code[20]; StartingDateTime: Decimal)
    var
        LaborAllocEntryLoc: Record "25006271";
        LaborAllocEntryLoc2: Record "25006271";
        LaborAllocEntryTemp: Record "25006271" temporary;
        LaborAllocEntryTemp2: Record "25006271" temporary;
        LaborAllocEntryTemp3: Record "25006271" temporary;
        JoinLaborAllocEntryTemp: Record "25006271" temporary;
        AlreadyJoinLaborAllocEntryTemp: Record "25006271" temporary;
        LaborAllocAppLoc: Record "25006277";
        JoinTotalHours: Decimal;
        EndDateTime: Decimal;
    begin
        LaborAllocEntryTemp2.RESET;
        LaborAllocEntryTemp2.DELETEALL;
        AlreadyJoinLaborAllocEntryTemp.RESET;
        AlreadyJoinLaborAllocEntryTemp.DELETEALL;

        LaborAllocEntryLoc.RESET;
        LaborAllocEntryLoc.SETCURRENTKEY("Resource No.", "Start Date-Time");
        LaborAllocEntryLoc.SETRANGE("Resource No.", ResourceNo);
        LaborAllocEntryLoc.SETFILTER("Start Date-Time", '>=%1', StartingDateTime);
        //21.07.2015 EB.P7 #Performance issue >>
        IF SingleInstanceMgt.GetAllocationEntryNo <> 0 THEN
            LaborAllocEntryLoc.SETRANGE("Entry No.", SingleInstanceMgt.GetAllocationEntryNo);
        //21.07.2015 EB.P7 #Performance issue <<

        IF LaborAllocEntryLoc.FINDFIRST THEN
            REPEAT
                IF NOT LaborAllocEntryTemp2.GET(LaborAllocEntryLoc."Entry No.") THEN BEGIN
                    LaborAllocEntryTemp.RESET;
                    LaborAllocEntryTemp.DELETEALL;
                    LaborAllocEntryTemp3.RESET;
                    LaborAllocEntryTemp3.DELETEALL;
                    FindSplitEntries(LaborAllocEntryLoc."Entry No.", LaborAllocEntryTemp, 0, 1111);
                    IF LaborAllocEntryTemp.FINDFIRST THEN
                        REPEAT
                            IF NOT LaborAllocEntryTemp2.GET(LaborAllocEntryTemp."Entry No.") THEN BEGIN
                                LaborAllocEntryTemp2 := LaborAllocEntryTemp;
                                LaborAllocEntryTemp2.INSERT;
                            END;
                            IF NOT LaborAllocEntryTemp3.GET(LaborAllocEntryTemp."Entry No.") THEN BEGIN
                                LaborAllocEntryTemp3 := LaborAllocEntryTemp;
                                LaborAllocEntryTemp3.INSERT;
                            END;
                        UNTIL LaborAllocEntryTemp.NEXT = 0;

                    LaborAllocEntryTemp.SETCURRENTKEY("Resource No.", "Start Date-Time");
                    IF LaborAllocEntryTemp.FINDFIRST THEN
                        REPEAT
                            JoinTotalHours := 0;
                            IF NOT AlreadyJoinLaborAllocEntryTemp.GET(LaborAllocEntryTemp."Entry No.") THEN BEGIN
                                JoinLaborAllocEntryTemp.RESET;
                                JoinLaborAllocEntryTemp.DELETEALL;
                                JoinLaborAllocEntryTemp := LaborAllocEntryTemp;
                                JoinLaborAllocEntryTemp.INSERT;

                                FindJoinEntries(JoinLaborAllocEntryTemp."End Date-Time", LaborAllocEntryTemp3, JoinLaborAllocEntryTemp);
                                EndDateTime := 0;
                                IF JoinLaborAllocEntryTemp.FINDFIRST THEN
                                    REPEAT
                                        IF NOT AlreadyJoinLaborAllocEntryTemp.GET(JoinLaborAllocEntryTemp."Entry No.") THEN BEGIN
                                            AlreadyJoinLaborAllocEntryTemp := JoinLaborAllocEntryTemp;
                                            AlreadyJoinLaborAllocEntryTemp.INSERT;
                                        END;
                                        JoinTotalHours += JoinLaborAllocEntryTemp."Quantity (Hours)";
                                        IF JoinLaborAllocEntryTemp."End Date-Time" > EndDateTime THEN
                                            EndDateTime := JoinLaborAllocEntryTemp."End Date-Time";
                                    UNTIL JoinLaborAllocEntryTemp.NEXT = 0;

                                JoinLaborAllocEntryTemp.RESET;
                                IF JoinLaborAllocEntryTemp.COUNT > 1 THEN BEGIN
                                    LaborAllocEntryLoc2.GET(LaborAllocEntryTemp."Entry No.");
                                    LaborAllocEntryLoc2."End Date-Time" := EndDateTime;
                                    LaborAllocEntryLoc2."Quantity (Hours)" := (EndDateTime - LaborAllocEntryLoc2."Start Date-Time") / 3.6;
                                    LaborAllocEntryLoc2.MODIFY;
                                    IF JoinLaborAllocEntryTemp.FINDFIRST THEN
                                        REPEAT
                                            IF JoinLaborAllocEntryTemp."Entry No." <> LaborAllocEntryTemp."Entry No." THEN BEGIN

                                                IF LaborAllocEntryLoc2.GET(JoinLaborAllocEntryTemp."Entry No.") THEN;
                                                ChangeApplyTo(LaborAllocEntryLoc2."Entry No.", LaborAllocEntryLoc2."Applies-to Entry No.");
                                                LaborAllocEntryLoc2.DELETE;

                                                LaborAllocAppLoc.RESET;
                                                LaborAllocAppLoc.SETRANGE("Allocation Entry No.", JoinLaborAllocEntryTemp."Entry No.");
                                                LaborAllocAppLoc.DELETEALL(TRUE);

                                            END;
                                        UNTIL JoinLaborAllocEntryTemp.NEXT = 0;
                                END;
                            END;
                        UNTIL LaborAllocEntryTemp.NEXT = 0;
                END;
            UNTIL LaborAllocEntryLoc.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure FindJoinEntries(StartingDateTime: Decimal; var LaborAllocEntryLoc: Record "25006271"; var JoinLaborAllocEntry: Record "25006271")
    begin
        IF JoinLaborAllocEntry.FINDFIRST THEN;
        LaborAllocEntryLoc.SETCURRENTKEY("Resource No.", "Start Date-Time");
        LaborAllocEntryLoc.SETRANGE("Start Date-Time", StartingDateTime);
        LaborAllocEntryLoc.SETRANGE(Status, JoinLaborAllocEntry.Status);

        IF LaborAllocEntryLoc.FINDFIRST THEN
            REPEAT
                IF NOT JoinLaborAllocEntry.GET(LaborAllocEntryLoc."Entry No.") THEN BEGIN
                    JoinLaborAllocEntry.INIT;
                    JoinLaborAllocEntry := LaborAllocEntryLoc;
                    JoinLaborAllocEntry.INSERT;
                    FindJoinEntries(LaborAllocEntryLoc."End Date-Time", LaborAllocEntryLoc, JoinLaborAllocEntry);
                END;
            UNTIL LaborAllocEntryLoc.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CheckUserRightsInit()
    begin
        CLEAR(isOperAllowedChecked);
        CLEAR(OperationMainCode);
        CLEAR(OperAllowed);
        CLEAR(LaborAllocationEntryPrevTmp);
        LaborAllocationEntryPrevTmp.DELETEALL;
        LaborAllocEntryPrevStatus := -1;
    end;

    [Scope('Internal')]
    procedure CheckUserRights(WhatAllow: Option View,Time,Planning,All): Boolean
    begin
        IF UserSetup.GET(USERID) THEN BEGIN
            CASE WhatAllow OF
                WhatAllow::View:
                    IF UserSetup."Allow Use Service Schedule" IN [UserSetup."Allow Use Service Schedule"::" "] THEN BEGIN
                        ErrorWithRefresh(Text128);
                        EXIT(FALSE);
                    END;
                WhatAllow::Time:
                    IF UserSetup."Allow Use Service Schedule" IN [UserSetup."Allow Use Service Schedule"::" ",
                                                                  UserSetup."Allow Use Service Schedule"::"View Only"] THEN BEGIN
                        ErrorWithRefresh(Text128);
                        EXIT(FALSE);
                    END;
                WhatAllow::Planning:
                    IF UserSetup."Allow Use Service Schedule" IN [UserSetup."Allow Use Service Schedule"::" ",
                                                                  UserSetup."Allow Use Service Schedule"::"View Only",
                                                                  UserSetup."Allow Use Service Schedule"::"Time Registration"] THEN BEGIN
                        ErrorWithRefresh(Text128);
                        EXIT(FALSE);
                    END;
                WhatAllow::All:
                    IF UserSetup."Allow Use Service Schedule" IN [UserSetup."Allow Use Service Schedule"::" ",
                                                                  UserSetup."Allow Use Service Schedule"::"View Only",
                                                                  UserSetup."Allow Use Service Schedule"::"Time Registration",
                                                                  UserSetup."Allow Use Service Schedule"::Planning]
                    THEN
                        EXIT(FALSE);
            END;
        END ELSE BEGIN
            ErrorWithRefresh(Text128);
            EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CheckUserRightsAdv(Operation: Integer; LaborAllocationEntryPar: Record "25006271"): Boolean
    begin
        // it is atvanced version of CheckUserRights
        // Operation codes:
        // 0 view; 1 - time registration; 2 - Planning; 3 - ; 4 - BREAK; 100 - allocate lines; 110 - allocate header; 120 - ALLOCATE standart event
        // 200 - spliting
        // 300 - move; 310 - change end time of finished
        // 400 - delete entry
        // due to last requirements 20.11.2013 is changed a bit operations: 300 and 310 allowed do with rights same to operation=1
        // It is important to understand that function call mostly happenes at operation right before actual write to db, so
        //   variable LaborAllocEntryPrevStatus is important in taking of decision

        IF isOperAllowedChecked AND (OperationMainCode = Operation) AND
            (LaborAllocEntryPrevStatus = LaborAllocationEntryPar.Status) THEN
            EXIT(OperAllowed);
        OperationMainCode := Operation;
        OperAllowed := FALSE;
        isOperAllowedChecked := TRUE;
        LaborAllocationEntryPrevTmp.TRANSFERFIELDS(LaborAllocationEntryPar);
        LaborAllocEntryPrevStatus := LaborAllocationEntryPar.Status;
        CASE Operation OF
            0:
                OperAllowed := CheckUserRights(0);
            1:
                OperAllowed := CheckUserRights(1);
            2:
                BEGIN
                    OperAllowed := CheckUserRights(2);
                END;
            3:
                BEGIN
                    OperAllowed := CheckUserRights(3);
                END;
            4:
                BEGIN
                    IF LaborAllocationEntryPar."Source Type" <> LaborAllocationEntryPar."Source Type"::"Service Document" THEN
                        ERROR(Text108);
                    IF Status <> Status::"In Progress" THEN
                        ERROR(Text111);
                    OperAllowed := CheckUserRights(1);
                END;
            100:
                BEGIN
                    ServiceScheduleSetup.GET;
                    IF ServiceScheduleSetup."Serv. Document Alloc. Method" = ServiceScheduleSetup."Serv. Document Alloc. Method"::Header THEN
                        ERROR(Text142);
                    OperAllowed := CheckUserRights(2);
                END;
            110:
                BEGIN
                    ServiceScheduleSetup.GET;
                    IF ServiceScheduleSetup."Serv. Document Alloc. Method" = ServiceScheduleSetup."Serv. Document Alloc. Method"::Line THEN
                        ERROR(Text142);
                    OperAllowed := CheckUserRights(2);
                END;
            120:
                BEGIN
                    OperAllowed := CheckUserRights(2);
                END;
            200:
                BEGIN
                    IF NOT ((Status = Status::Pending) OR
                            (Status = Status::"On Hold"))
                    THEN
                        ERROR(STRSUBSTNO(Text123, Status));

                    LaborAllocApp.RESET;
                    LaborAllocApp.SETRANGE("Allocation Entry No.", LaborAllocationEntryPar."Entry No.");
                    LaborAllocApp.SETRANGE("Document Line No.", 0);
                    IF LaborAllocApp.FINDFIRST THEN
                        ERROR(Text134);
                    OperAllowed := CheckUserRights(2);
                END;
            300:
                BEGIN
                    OperAllowed := CheckUserRights(2);  //20.11.2013 EDMS P8
                    IF OperAllowed THEN
                        IF Status IN [Status::"In Progress", Status::Finished] THEN BEGIN
                            OperAllowed := FALSE;
                            OperAllowed := CheckUserRights(3);
                            IF NOT OperAllowed THEN BEGIN
                                ErrorWithRefresh(Text128);  //22.11.2013 EDMS P8
                            END;
                        END;
                END;
            310:
                BEGIN
                    IF (LaborAllocationEntryPar."Source Type" <> LaborAllocationEntryPar."Source Type"::"Service Document") OR
                       (Status <> Status::Finished)
                    THEN
                        ErrorWithRefresh(Text138);
                    OperAllowed := CheckUserRights(3);
                END;
            400:
                BEGIN
                    OperAllowed := CheckUserRights(2);
                    IF (Status = Status::Finished) OR
                       (Status = Status::"In Progress")
                    THEN
                        IF NOT CheckUserRights(3) THEN
                            ERROR(STRSUBSTNO(Text114, FORMAT(Status)))
                        ELSE
                            IF NOT CONFIRM(STRSUBSTNO(Text130, FORMAT(Status))) THEN
                                ERROR(STRSUBSTNO(Text114, FORMAT(Status)));
                END;
        END;
        EXIT(OperAllowed);
    end;

    [Scope('Internal')]
    procedure FindServAllocAplicationEntries(var LaborAllocAppLoc: Record "25006277"; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    begin
        LaborAllocAppLoc.SETRANGE("Document Type", DocumentType);
        LaborAllocAppLoc.SETRANGE("Document No.", DocumentNo);
    end;

    [Scope('Internal')]
    procedure FindServAllocationEntries(var LaborAllocLoc: Record "25006271"; DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    begin
        LaborAllocLoc.SETRANGE("Source Type", LaborAllocLoc."Source Type"::"Service Document");
        LaborAllocLoc.SETRANGE("Source Subtype", DocumentType);
        LaborAllocLoc.SETRANGE("Source ID", DocumentNo);
    end;

    [Scope('Internal')]
    procedure CheckForCorrectServHeaderLine(ServiceHdr: Record "25006145"; var ServiceLine: Record "25006146"; WhatAllocate: Option Header,Line)
    var
        LaborAllocEntryLoc: Record "25006271";
        LaborAllocAppLoc: Record "25006277";
        DocumentNo: Code[20];
        NewResource: Record "156";
    begin
        CASE WhatAllocate OF
            WhatAllocate::Header:
                BEGIN
                    //      LaborAllocEntryLoc.RESET;
                    //      LaborAllocEntryLoc.SETRANGE("Source Subtype", ServiceHdr."Document Type");
                    //      LaborAllocEntryLoc.SETRANGE("Source ID", ServiceHdr."No.");
                    //      IF LaborAllocEntryLoc.FINDFIRST THEN
                    //        IF GUIALLOWED THEN
                    //          IF NOT CONFIRM(STRSUBSTNO(Text131, ServiceHdr."Document Type", ServiceHdr."No.")) THEN
                    //            ERROR(Text150);
                END;
            WhatAllocate::Line:
                BEGIN
                    //      IF ServiceLine.FINDFIRST THEN BEGIN
                    //        DocumentNo := ServiceLine."Document No.";
                    //        REPEAT
                    //          IF DocumentNo <> ServiceLine."Document No." THEN
                    //            ERROR(Text133);
                    //        UNTIL ServiceLine.NEXT = 0;
                    //      END;
                    //      LaborAllocEntryLoc.RESET;
                    //      LaborAllocEntryLoc.SETRANGE("Source Subtype", ServiceLine."Document Type");  //12.12.2014 EB.P8
                    //      LaborAllocEntryLoc.SETRANGE("Source ID", ServiceLine."Document No.");
                    //      IF LaborAllocEntryLoc.FINDFIRST THEN
                    //        IF GUIALLOWED THEN
                    //          IF NOT CONFIRM(STRSUBSTNO(Text131, ServiceLine."Document Type", ServiceLine."Document No.")) THEN
                    //            ERROR(Text150);
                    //Sipradi- YS 6.23.2012
                    ServiceStepsChecking.CheckSteps(ServiceLine."Document No.", Steps::CheckDiagnosis);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure IsResourceWorkingTime(ResourceNo: Code[20]; CheckDate: Date): Boolean
    var
        ServiceHour: Record "25006129";
        ResourceCalendarChange: Record "25006279";
    begin
        IF ResourceCalendarChange.GET(ResourceNo, CheckDate) THEN BEGIN
            IF ResourceCalendarChange."Change Type" = ResourceCalendarChange."Change Type"::Nonworking THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE);
        END;

        ServiceHour.RESET;
        ServiceHour.SETFILTER("Starting Date", '''''|<=%1', CheckDate);
        ServiceHour.SETFILTER("Ending Date", '''''|>=%1', CheckDate);
        ServiceHour.SETRANGE(Day, DATE2DWY(CheckDate, 1) - 1);
        IF NOT ServiceHour.FINDLAST THEN
            EXIT(FALSE);

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure GetResourceWorkplace(ResourceNo: Code[20]; CheckDate: Date): Code[10]
    var
        WorkplaceResource: Record "25006285";
    begin
        WorkplaceResource.RESET;
        WorkplaceResource.SETRANGE("Resource No.", ResourceNo);
        WorkplaceResource.SETFILTER("Starting Date", '''''|<=%1', CheckDate);
        WorkplaceResource.SETFILTER("Ending Date", '''''|>=%1', CheckDate);
        IF WorkplaceResource.FINDLAST THEN
            EXIT(WorkplaceResource."Workplace Code")
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure GetResourceSkills(ResourceNo: Code[20]; var ResourceSkill: Record "25006160"): Code[10]
    var
        WorkplaceResource: Record "25006285";
    begin
        ResourceSkill.RESET;
        ResourceSkill.SETRANGE("Resource No.", ResourceNo);
    end;

    [Scope('Internal')]
    procedure GetResourceShift(ResourceNo: Code[20]): Code[10]
    var
        Resource: Record "156";
    begin
        IF Resource.GET(ResourceNo) THEN
            EXIT(Resource."Service Work Group Code")
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure GroupResourceCodeBuffer(var ResourceCodeBuffer: Record "25006270"; CurrDate: Date; GroupBy: Option " ",Workplace,Skill,Shift)
    var
        WorkplaceResource: Record "25006285";
        Workplace: Record "25006284";
    begin
        CASE GroupBy OF
            GroupBy::Workplace:
                GroupResourceByWorkplaces(ResourceCodeBuffer, CurrDate);
            GroupBy::Skill:
                BEGIN
                    GroupResourceBySkills(ResourceCodeBuffer, CurrDate);
                END;
            GroupBy::Shift:
                BEGIN
                    GroupResourceByShifts(ResourceCodeBuffer, CurrDate);
                END;
            ELSE
                EXIT;
        END
    end;

    [Scope('Internal')]
    procedure GroupResourceByWorkplaces(var ResourceCodeBuffer: Record "25006270"; CurrDate: Date)
    var
        WorkplaceResource: Record "25006285";
        Workplace: Record "25006284";
        codex: Code[10];
        textx: Text[30];
    begin
        IF ResourceCodeBuffer.FINDFIRST THEN
            REPEAT
                WorkplaceResource.SETRANGE("Resource No.", ResourceCodeBuffer.Code);
                IF CurrDate <> 0D THEN BEGIN
                    WorkplaceResource.SETFILTER("Starting Date", '''''|<=%1', CurrDate);
                    WorkplaceResource.SETFILTER("Ending Date", '''''|>=%1', CurrDate);
                END;

                IF WorkplaceResource.FINDLAST THEN BEGIN
                    ResourceCodeBuffer."Code 2" := WorkplaceResource."Workplace Code";
                    ResourceCodeBuffer."Applies-to Code" := WorkplaceResource."Workplace Code";
                    ResourceCodeBuffer.MODIFY;
                    Workplace.GET(WorkplaceResource."Workplace Code");
                    Workplace.MARK(TRUE);
                END;
            UNTIL ResourceCodeBuffer.NEXT = 0;


        Workplace.MARKEDONLY(TRUE);
        IF Workplace.FINDFIRST THEN
            REPEAT
                ResourceCodeBuffer.INIT;
                ResourceCodeBuffer.Code := Workplace.Code;
                ResourceCodeBuffer.Name := Workplace.Description;
                ResourceCodeBuffer."Code 2" := Workplace.Code;
                ResourceCodeBuffer."Show in Bold" := TRUE;
                ResourceCodeBuffer.Group := TRUE;
                ResourceCodeBuffer.INSERT;
            UNTIL Workplace.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GroupResourceBySkills(var ResourceCodeBuffer: Record "25006270"; CurrDate: Date)
    var
        ResourceSkill: Record "25006160";
        Skill: Record "25006159";
    begin
        IF ResourceCodeBuffer.FINDFIRST THEN
            REPEAT
                ResourceCodeBuffer."Applies-to Code" := ResourceCodeBuffer."Code 2";
                ResourceCodeBuffer.MODIFY;
                ResourceSkill.SETRANGE("Resource No.", ResourceCodeBuffer.Code);
                IF ResourceSkill.FINDFIRST THEN
                    REPEAT
                        IF Skill.GET(ResourceSkill."Skill Code") THEN
                            Skill.MARK(TRUE);
                    UNTIL ResourceSkill.NEXT = 0;
            UNTIL ResourceCodeBuffer.NEXT = 0;


        Skill.MARKEDONLY(TRUE);
        IF Skill.FINDFIRST THEN
            REPEAT
                ResourceCodeBuffer.INIT;
                ResourceCodeBuffer.Code := Skill.Code;
                ResourceCodeBuffer.Name := Skill.Description;
                ResourceCodeBuffer."Code 2" := Skill.Code;
                ResourceCodeBuffer."Show in Bold" := TRUE;
                ResourceCodeBuffer.Group := TRUE;
                ResourceCodeBuffer.INSERT;
            UNTIL Skill.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GroupResourceByShifts(var ResourceCodeBuffer: Record "25006270"; CurrDate: Date)
    var
        Resource: Record "156";
        Shift: Record "25006151";
    begin
        IF ResourceCodeBuffer.FINDFIRST THEN
            REPEAT
                IF Resource.GET(ResourceCodeBuffer.Code) THEN BEGIN
                    ResourceCodeBuffer."Code 2" := Resource."Service Work Group Code";
                    ResourceCodeBuffer."Applies-to Code" := Resource."Service Work Group Code";
                    ResourceCodeBuffer.MODIFY;
                    IF Shift.GET(Resource."Service Work Group Code") THEN
                        Shift.MARK(TRUE);
                END;
            UNTIL ResourceCodeBuffer.NEXT = 0;


        Shift.MARKEDONLY(TRUE);
        IF Shift.FINDFIRST THEN
            REPEAT
                ResourceCodeBuffer.INIT;
                ResourceCodeBuffer.Code := Shift.Code;
                ResourceCodeBuffer.Name := Shift.Description;
                ResourceCodeBuffer."Code 2" := Shift.Code;
                ResourceCodeBuffer."Show in Bold" := TRUE;
                ResourceCodeBuffer.Group := TRUE;
                ResourceCodeBuffer.INSERT;
            UNTIL Shift.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ChangePlanningPolicy(ServiceHdr: Record "25006145")
    begin
        LaborAllocEntry.RESET;
        LaborAllocEntry.SETRANGE("Source Type", LaborAllocEntry."Source Type"::"Service Document");
        LaborAllocEntry.SETRANGE("Source Subtype", ServiceHdr."Document Type");
        LaborAllocEntry.SETRANGE("Source ID", ServiceHdr."No.");
        IF LaborAllocEntry.FINDFIRST THEN
            REPEAT
                LaborAllocEntry."Planning Policy" := ServiceHdr."Planning Policy";
                LaborAllocEntry.MODIFY;
            UNTIL LaborAllocEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CheckServiceLineResource(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; ReturnType: Option Error,Boolean; ResourceNo: Code[20]): Boolean
    var
        TextLoc: Label 'here are params %1';
    begin
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", DocType);
        LaborAllocApp.SETRANGE("Document No.", DocNo);
        LaborAllocApp.SETRANGE("Document Line No.", LineNo);
        IF LaborAllocApp.FINDFIRST THEN BEGIN
            //2012.03.19 EDMS P8 >>
            LaborAllocApp.SETRANGE("Resource No.", ResourceNo);
            IF NOT LaborAllocApp.FINDFIRST THEN BEGIN
                IF ReturnType = ReturnType::Error THEN
                    ERROR(Text136)
                //      ERROR(TextLoc, ServiceLine.GETFILTERS)
                ELSE
                    EXIT(FALSE);
            END ELSE
                EXIT(FALSE);
        END ELSE BEGIN
            EXIT(CheckDocAllocResource(DocType, DocNo, LineType, LineNo, ReturnType, ResourceNo));  // P8
        END;
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure ChangeFinishedAllocEnding(LaborAllocEntry: Record "25006271")
    var
        ChangeAllocationForm: Page "25006360";
    begin
        IF NOT CheckUserRightsAdv(310, LaborAllocEntry) THEN EXIT;

        CLEAR(ChangeAllocationForm);
        ChangeAllocationForm.GetServLaborAllocation(LaborAllocEntry);
        ChangeAllocationForm.LOOKUPMODE(TRUE);  //03.04.2013 P8
        COMMIT;  //28.06.2013 EDMS P8
        ChangeAllocationForm.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure DontModifySalesLine(DontModify: Boolean)
    begin
        GlobDontModifyServLine := DontModify;
    end;

    [Scope('Internal')]
    procedure GetCapacity(ResourceNo: Code[20]; StartingDateTime: Decimal; EndingDateTime: Decimal): Decimal
    var
        ServiceHour: Record "25006129";
        ResCalendarChange: Record "25006279";
        Date: Record "2000000007";
        Resource: Record "156";
        CurrDate: Date;
        CurrStartTime: Time;
        CurrEndTime: Time;
        CurrEndTime2: Time;
        Capacity: Decimal;
    begin
        IF NOT Resource.GET(ResourceNo) THEN
            EXIT(0);
        Capacity := 0;
        CurrDate := DateTimeMgt.Datetime2Date(StartingDateTime);
        CurrStartTime := DateTimeMgt.Datetime2Time(StartingDateTime);
        REPEAT
            CurrEndTime := DateTimeMgt.Datetime2Time(EndingDateTime);
            IF ResCalendarChange.GET(ResourceNo, CurrDate) THEN BEGIN
                IF CurrStartTime < ResCalendarChange."Starting Time" THEN
                    CurrStartTime := ResCalendarChange."Starting Time";
                IF (CurrEndTime > ResCalendarChange."Ending Time") OR (CurrDate < DateTimeMgt.Datetime2Date(EndingDateTime)) THEN
                    CurrEndTime := ResCalendarChange."Ending Time";
                IF CurrEndTime > CurrStartTime THEN
                    Capacity := Capacity + (CurrEndTime - CurrStartTime) / (1000 * 60 * 60);
            END ELSE BEGIN
                Date.RESET;
                Date.SETRANGE("Period Start", CurrDate);
                IF Date.FINDFIRST THEN BEGIN
                    ServiceHour.RESET;
                    ServiceHour.SETRANGE("Service Work Group Code", Resource."Service Work Group Code");
                    ServiceHour.SETFILTER("Starting Date", '<=%1|%2', CurrDate, 0D);
                    ServiceHour.SETFILTER("Ending Date", '>=%1|%2', CurrDate, 0D);
                    ServiceHour.SETRANGE(Day, Date."Period No." - 1);
                    IF ServiceHour.FINDFIRST THEN BEGIN
                        CurrEndTime2 := CurrEndTime;
                        REPEAT
                            CurrEndTime := CurrEndTime2;
                            IF CurrStartTime < ServiceHour."Starting Time" THEN
                                CurrStartTime := ServiceHour."Starting Time";
                            IF (CurrEndTime > ServiceHour."Ending Time") OR (CurrDate < DateTimeMgt.Datetime2Date(EndingDateTime)) THEN
                                CurrEndTime := ServiceHour."Ending Time";
                            IF CurrEndTime - CurrStartTime > 0 THEN
                                Capacity := Capacity + (CurrEndTime - CurrStartTime) / (1000 * 60 * 60);
                        UNTIL ServiceHour.NEXT = 0;
                    END;
                END;
            END;
            CurrDate := CurrDate + 1;
            CurrStartTime := 0T;
        UNTIL CurrDate > DateTimeMgt.Datetime2Date(EndingDateTime);
        EXIT(Capacity)
    end;

    [Scope('Internal')]
    procedure GetNotAvailabilityTime(var TempLaborAllocEntry: Record "25006271" temporary; StartingDateTime: Decimal; EndingDateTime: Decimal): Decimal
    var
        NotAvailable: Decimal;
        CurrStart: Decimal;
        CurrEnd: Decimal;
    begin
        IF TempLaborAllocEntry.FINDFIRST THEN
            REPEAT
                IF StartingDateTime > TempLaborAllocEntry."Start Date-Time" THEN
                    CurrStart := StartingDateTime
                ELSE
                    CurrStart := TempLaborAllocEntry."Start Date-Time";
                IF EndingDateTime < TempLaborAllocEntry."End Date-Time" THEN
                    CurrEnd := EndingDateTime
                ELSE
                    CurrEnd := TempLaborAllocEntry."End Date-Time";
                NotAvailable := NotAvailable + CalcHourDifference(CurrStart, CurrEnd);
            UNTIL TempLaborAllocEntry.NEXT = 0;

        EXIT(NotAvailable);
    end;

    [Scope('Internal')]
    procedure ShowServiceAllocation(SourceID: Code[20])
    var
        ServLaborAllocation: Record "25006271";
    begin
        ServLaborAllocation.RESET;
        ServLaborAllocation.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID");
        ServLaborAllocation.SETRANGE("Source Type", ServLaborAllocation."Source Type"::"Service Document");
        ServLaborAllocation.SETRANGE("Source ID", SourceID);
        IF ServLaborAllocation.COUNT = 0 THEN
            MESSAGE(Text140)
        ELSE
            PAGE.RUNMODAL(PAGE::"Service Labor List", ServLaborAllocation);
    end;

    [Scope('Internal')]
    procedure CheckStartAndPlan(EntryNo: Integer)
    var
        LaborAllocEntryLoc: Record "25006271";
        LaborAllocEntry: Record "25006271";
        LaborAllocEntryTemp: Record "25006271" temporary;
        WorkTimeEntry: Record "25006276";
        CurrDateTime: Decimal;
    begin
        LaborAllocEntry.GET(EntryNo);
        CurrDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);

        WorkTimeEntry.RESET;
        WorkTimeEntry.SETCURRENTKEY("Resource No.", Closed);
        WorkTimeEntry.SETRANGE("Resource No.", LaborAllocEntry."Resource No.");
        WorkTimeEntry.SETRANGE(Closed, FALSE);
        IF NOT WorkTimeEntry.FINDLAST THEN
            ERROR(STRSUBSTNO(Text107, LaborAllocEntry."Resource No."));

        Resource.GET(LaborAllocEntry."Resource No.");
        IF NOT Resource."Allow Simultaneous Work" THEN BEGIN  //17.10.2013 EDMS P8
            LaborAllocEntryLoc.RESET;
            LaborAllocEntryLoc.SETCURRENTKEY("Source Type", Status, "Resource No.");
            LaborAllocEntryLoc.SETRANGE(Status, LaborAllocEntryLoc.Status::"In Progress");
            LaborAllocEntryLoc.SETRANGE("Resource No.", LaborAllocEntry."Resource No.");
            IF LaborAllocEntryLoc.FINDFIRST THEN
                ERROR(Text135);
        END;

        IF IsTimeAvailable(LaborAllocEntryTemp, LaborAllocEntry."Resource No.", WORKDATE, 0) THEN BEGIN
            LaborAllocEntryTemp.RESET;
            IF LaborAllocEntryTemp.FINDFIRST THEN
                REPEAT
                    IF (LaborAllocEntryTemp."Start Date-Time" <= CurrDateTime) AND
                       (LaborAllocEntryTemp."End Date-Time" >= CurrDateTime)
                    THEN
                        ERROR(Text113);
                UNTIL LaborAllocEntryTemp.NEXT = 0
            ELSE
                ERROR(Text113);
        END ELSE
            ERROR(Text113);
    end;

    [Scope('Internal')]
    procedure DoNotChangeServStatus()
    begin
        DontChangeServiceStatus := TRUE;
    end;

    [Scope('Internal')]
    procedure LookupAllocationRTC(EntryNo: Integer)
    var
        LaborAllocEntry: Record "25006271";
        ServiceHeader: Record "25006145";
        PostedServOrder: Record "25006149";
    begin
        IF NOT LaborAllocEntry.GET(EntryNo) THEN EXIT;

        IF LaborAllocEntry."Source Type" <> LaborAllocEntry."Source Type"::"Service Document" THEN
            EXIT;

        IF ServiceHeader.GET(LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID") THEN BEGIN
            CASE ServiceHeader."Document Type" OF
                ServiceHeader."Document Type"::Quote:
                    PAGE.RUNMODAL(PAGE::"Service Quote EDMS", ServiceHeader);
                ServiceHeader."Document Type"::Order:
                    PAGE.RUNMODAL(PAGE::"Service Order EDMS", ServiceHeader);
            END;
        END ELSE BEGIN
            IF PostedServOrder.GET(LaborAllocEntry."Source ID") THEN
                PAGE.RUNMODAL(PAGE::"Posted Service Order EDMS", PostedServOrder);
        END;
    end;

    [Scope('Internal')]
    procedure AllocationChanged(EntryNo: Integer; NewResourceNo: Code[20]; var NewStartDT: Decimal; var NewEndDT: Decimal) RetValue: Boolean
    var
        LaborAllocEntryL: Record "25006271";
        AdjustedTime: Time;
        DateTmeTmp: Decimal;
        RoundMs: Integer;
        OrigNewStartDT: Decimal;
        OrigNewEndDT: Decimal;
    begin
        LaborAllocEntryL.GET(EntryNo);
        OrigNewStartDT := NewStartDT;
        OrigNewEndDT := NewEndDT;

        ServiceScheduleSetup.GET;
        IF ServiceScheduleSetup."Allocation Time Step (Minutes)" > 0 THEN
            RoundMs := ServiceScheduleSetup."Allocation Time Step (Minutes)"
        ELSE
            RoundMs := 36000; // IF NO SETUP THEN min by system is 36 sec.
        IF RoundMs > 0 THEN BEGIN
            // lets do time adjustment

            IF "Start Date-Time" <> NewStartDT THEN
                NewStartDT := DateTimeRound(NewStartDT, RoundMs);
            IF "End Date-Time" <> NewEndDT THEN BEGIN
                NewEndDT := DateTimeRound(NewEndDT, RoundMs);
            END;
            AdjustedTime := 000001T - 1000 + RoundMs;
            DateTmeTmp := DateTimeMgt.Datetime(0D, AdjustedTime);
            IF ((NewEndDT - NewStartDT) < DateTmeTmp) THEN BEGIN
                NewEndDT := NewStartDT + DateTmeTmp;
            END;
        END;

        //do define should be shown task-edit form or should not?
        IF ("Resource No." <> NewResourceNo) AND (NewResourceNo <> '') THEN
            RetValue := TRUE;
        // rounding by 1 second
        IF NOT IsDateTimeEqualDateTime("Start Date-Time", OrigNewStartDT) THEN  //20.07.2013 EDMS P8
            RetValue := TRUE;
        IF NOT IsDateTimeEqualDateTime("End Date-Time", OrigNewEndDT) THEN
            RetValue := TRUE;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure FillUnavailableTimeEntries(var AllocEntry: Record "25006271"; ResourceNo: Code[20]; TargetDate: Date)
    var
        ServiceHour: Record "25006129";
        ResCalendarChange: Record "25006279";
        ServLaborAlloc2: Record "25006271";
        ApplicationEntry: Record "25006277" temporary;
        ResourceLoc: Record "156";
        CheckDescription: Text[50];
        Starting: Decimal;
        Finishing: Decimal;
        QtyToAllocate: Decimal;
        EntryNo: Integer;
        DoChangeServLineResource: Boolean;
        Text001: Label 'Unavailability';
        ResWorkTimeChange: Boolean;
        PrevRecStartTime: Time;
        PrevRecEndTime: Time;
    begin
        ServiceScheduleSetup.GET;
        DoChangeServLineResource := FALSE;
        ResWorkTimeChange := FALSE;

        //check for busy time in Base Calendar and in Resource Calendar Change >>
        IF ResCalendarChange.GET(ResourceNo, TargetDate) THEN BEGIN
            CASE ResCalendarChange."Change Type"::"Work Time Change" OF
                ResCalendarChange."Change Type"::Nonworking:
                    BEGIN
                        QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, 000000T),
                                                            DateTimeMgt.Datetime(TargetDate, 235959.999T));
                        InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo, DateTimeMgt.Datetime(TargetDate, 000000T), QtyToAllocate,
                                              0, 0, Text001, 0, DoChangeServLineResource, AllocEntry.Travel);
                    END;

                ResCalendarChange."Change Type"::"Work Time Change":
                    BEGIN
                        ResWorkTimeChange := TRUE;
                        IF ResCalendarChange."Starting Time" > 0T THEN BEGIN
                            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, 000000T),
                                                                DateTimeMgt.Datetime(TargetDate, ResCalendarChange."Starting Time"));
                            InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo, DateTimeMgt.Datetime(TargetDate, 000000T), QtyToAllocate,
                                                  0, 0, Text001, 0, DoChangeServLineResource, AllocEntry.Travel);
                        END;

                        IF ResCalendarChange."Ending Time" < 235959.999T THEN BEGIN
                            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, ResCalendarChange."Ending Time"),
                                                                DateTimeMgt.Datetime(TargetDate, 235959.999T));
                            InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo,
                                                  DateTimeMgt.Datetime(TargetDate, ResCalendarChange."Ending Time"), QtyToAllocate, 0, 0, Text001, 0,
                                                  DoChangeServLineResource, AllocEntry.Travel);
                        END;
                    END;
            END;
        END;

        //write busy time from Service Hour EDMS >>
        IF NOT ResWorkTimeChange THEN BEGIN
            ServiceHour.RESET;
            //AB >>
            IF (ResourceLoc.GET(ResourceNo)) THEN BEGIN
                //ResourceLoc.GET(ResourceNo);
                ServiceHour.SETRANGE("Service Work Group Code", ResourceLoc."Service Work Group Code");
                ServiceHour.SETFILTER("Starting Date", '''''|<=%1', TargetDate);
                ServiceHour.SETFILTER("Ending Date", '''''|>=%1', TargetDate);
                ServiceHour.SETRANGE(Day, DATE2DWY(TargetDate, 1) - 1);

                //18.01.2012 EDMS P8 >>
                IF ServiceHour.FINDFIRST THEN BEGIN
                    PrevRecStartTime := 0T;
                    PrevRecEndTime := 0T;
                    REPEAT
                        IF ServiceHour."Starting Time" > 0T THEN BEGIN
                            QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, PrevRecEndTime),
                                                                DateTimeMgt.Datetime(TargetDate, ServiceHour."Starting Time"));
                            InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo, DateTimeMgt.Datetime(TargetDate, PrevRecEndTime),
                                                  QtyToAllocate, 0, 0, Text001, 0, DoChangeServLineResource, AllocEntry.Travel);
                        END;

                        PrevRecStartTime := ServiceHour."Starting Time";
                        PrevRecEndTime := ServiceHour."Ending Time";
                    UNTIL ServiceHour.NEXT = 0;
                    IF ServiceHour."Ending Time" < 235959.999T THEN BEGIN
                        QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, ServiceHour."Ending Time"),
                                                            DateTimeMgt.Datetime(TargetDate, 235959.999T));
                        InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo,
                                              DateTimeMgt.Datetime(TargetDate, ServiceHour."Ending Time"), QtyToAllocate, 0, 0, Text001, 0,
                                              DoChangeServLineResource, AllocEntry.Travel);
                    END;
                    //18.01.2012 EDMS P8 <<
                END ELSE BEGIN
                    QtyToAllocate := CalcHourDifference(DateTimeMgt.Datetime(TargetDate, 000000T),
                                                          DateTimeMgt.Datetime(TargetDate, 235959.999T));
                    InsertAllocationEntry(AllocEntry, ApplicationEntry, ResourceNo, DateTimeMgt.Datetime(TargetDate, 000000T), QtyToAllocate,
                                            0, 0, Text001, 0, DoChangeServLineResource, AllocEntry.Travel);
                END;
            END;
            //AB <<
        END;
    end;

    [Scope('Internal')]
    procedure DateTimeRound(DateTime: Decimal; RoundMs: Integer): Decimal
    var
        AdjustedTime: Time;
    begin
        IF RoundMs > 0 THEN BEGIN
            AdjustedTime := 000001T - 1000 + RoundMs;
            EXIT(ROUND(DateTime, DateTimeMgt.Datetime(0D, AdjustedTime)))
        END ELSE
            EXIT(DateTime);
    end;

    [Scope('Internal')]
    procedure IsDateTimeEqualDateTime(FirstDT: Decimal; SecondDT: Decimal): Boolean
    begin
        EXIT(DateTimeRound(FirstDT, 1000) = DateTimeRound(SecondDT, 1000));  //20.07.2013 EDMS P8
    end;

    [Scope('Internal')]
    procedure DocAllocAdjustDocLinesResource(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]; ResourceNo: Code[20])
    var
        ServiceLineLocal: Record "25006146";
        Resources: Text[250];
    begin
        //  P8
        IF GetSourceType(LaborAllocEntry, LaborAllocApp) <> LaborAllocAppType::"Service Document" THEN
            EXIT;
        ServiceLineLocal.RESET;
        ServiceLineLocal.SETRANGE("Document Type", DocumentType);
        ServiceLineLocal.SETRANGE("Document No.", DocumentNo);
        ServiceLineLocal.SETRANGE(Type, ServiceLineLocal.Type::Labor);
        FillServiceLine(ServiceLineLocal);
        IF ServiceLineLocal.FINDFIRST THEN BEGIN
            Resources := GetRelatedResources(DocumentType, DocumentNo, ServiceLineLocal.Type::Labor, ServiceLineLocal."Line No.", 0);
            REPEAT
                SetRelatedResources(DocumentType, DocumentNo, ServiceLineLocal.Type::Labor, ServiceLineLocal."Line No.",
                  Resources, 11);
            UNTIL ServiceLineLocal.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure CheckDocAllocResource(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; ReturnType: Option Error,Boolean; ResourceNo: Code[20]): Boolean
    begin
        //  P8
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", DocType);
        LaborAllocApp.SETRANGE("Document No.", DocNo);
        LaborAllocApp.SETRANGE("Document Line No.", 0);
        IF LaborAllocApp.FINDFIRST THEN BEGIN
            //2012.03.19 EDMS P8 >>
            LaborAllocApp.SETRANGE("Resource No.", ResourceNo);
            IF NOT LaborAllocApp.FINDFIRST THEN BEGIN
                IF ReturnType = ReturnType::Error THEN
                    ERROR(Text136)
                ELSE
                    EXIT(FALSE);
            END ELSE
                EXIT(FALSE);
        END;
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure GetDocAllocResource(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]) ResourceNo: Code[20]
    begin
        // old version, look at GetDocAllocResources
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", DocumentType);
        LaborAllocApp.SETRANGE("Document No.", DocumentNo);
        LaborAllocApp.SETRANGE("Document Line No.", 0);
        IF LaborAllocApp.FINDFIRST THEN
            IF (LaborAllocApp."Resource No." <> '') THEN
                ResourceNo := LaborAllocApp."Resource No.";
        EXIT(ResourceNo);
    end;

    [Scope('Internal')]
    procedure GetDocAllocResources(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20]) ResourceNos: Text[250]
    var
        ServLaborApplicationTmp: Record "25006277" temporary;
    begin
        ResourceNos := '';
        LaborAllocApp.RESET;
        LaborAllocApp.SETRANGE("Document Type", DocumentType);
        LaborAllocApp.SETRANGE("Document No.", DocumentNo);
        LaborAllocApp.SETRANGE("Document Line No.", 0);
        IF LaborAllocApp.FINDFIRST THEN BEGIN
            REPEAT
                ServLaborApplicationTmp.SETRANGE("Resource No.", LaborAllocApp."Resource No.");
                IF NOT ServLaborApplicationTmp.FINDFIRST THEN BEGIN
                    ResourceNos += LaborAllocApp."Resource No." + ',';
                    ServLaborApplicationTmp := LaborAllocApp;
                    ServLaborApplicationTmp.INSERT;
                END;
            UNTIL LaborAllocApp.NEXT = 0;
            ResourceNos := COPYSTR(ResourceNos, 1, STRLEN(ResourceNos) - 1);
        END;
        EXIT(ResourceNos);
    end;

    [Scope('Internal')]
    procedure GetSourceType(LaborAllocEntryPar: Record "25006271"; LaborAllocAppPar: Record "25006277"): Integer
    var
        RetValue: Option " ","Service Document","Standard Event","Service Line";
    begin
        IF LaborAllocEntryPar."Entry No." > 0 THEN BEGIN
            RetValue := LaborAllocEntryPar."Source Type";
            IF RetValue = RetValue::"Service Document" THEN
                IF LaborAllocAppPar."Document Line No." > 0 THEN
                    RetValue := RetValue::"Service Line";
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure SeparateAllocEntry(var ServLaborAllocEntryPar: Record "25006271"; var ServAllocAppSourcePar: Record "25006277"; var ServLineDestPar: Record "25006146"; ShareQtySource: Decimal; ShareQtyDest: Decimal; StartTimeDepends: Boolean; DoCreateServLine: Boolean; ParamStr: Text[30]): Integer
    var
        ServLineSource: Record "25006146";
        ServLaborAllocEntryDest: Record "25006271";
        ServLaborAllocEntryTmp: Record "25006271" temporary;
        AllocAppEntrySource: Record "25006277";
        AllocAppEntryDest: Record "25006277";
        TextLoc001: Label 'Error to proceed allocation split - should be finished or unstarted.';
        AllocAppEntry: Record "25006277";
        QtySource: Decimal;
        QtySourceBeforeChange: Decimal;
        QtyDest: Decimal;
        DocMgtDMS: Codeunit "25006000";
        SplitQuantity: Decimal;
        SplitHours: Decimal;
        OldQuantity: Decimal;
        OldHours: Decimal;
        NewQuantity: Decimal;
        NewHours: Decimal;
        NewLineNo: Integer;
        CurrentLineNo: Integer;
        DateStart: Decimal;
        FinishedQty: Decimal;
        RemainingQty: Decimal;
        AllocTimeQty: Decimal;
        NewAllocEntryNo: Integer;
        LineNoSource: Integer;
        ShareOfLineInAlloc: Decimal;
        MainAllocQty: Decimal;
        IsSourceDeallocated: Boolean;
        ResourceNo: Code[20];
        doAvoidSrcChanges: Boolean;
        doAvoidSrcLineQtyChange: Boolean;
        doAvoidDestLineQtyChange: Boolean;
    begin
        // supposed that the function could be runned if allocation not used at all or finished already
        // Proceed only for one Alloc Entry.
        // StartTimeDepends = true - means Start Time for new Allocation Entry should be ending time of source entry.
        // supposed to be used in cases:
        //   of adding allocation to Service Line EDMS that has already allocated to other resource, then need to split line and allocation
        //   of both lines exist but need to adjust qty share for existing first allocation and create new allocation for second line with o
        // parameter ServAllocAppSourcePar - supposed to be temporary record with stored several applications - usefull if source allocation
        //   is deallocated already (in procedure from that is called).
        //   IMPORTANT it should be filtered if real record used, instead of temporary!
        // parameter ServLaborAllocEntryPar - could be temporary or not!
        // note for coding: FINISHED AND REMAINING QUANTITIES are stored only in first AllocAppEntry entry
        // parameter ServLineDestPar should be filtered or temporary in case of ServAllocAppSourcePar.COUNT > 1
        // parameter ShareQtySource - stores quantity share of labor but not entry (so for entry it going to be adjusted)

        // ParamStr: first char is digit-flag, doAvoidSrcChanges("Applies-to Entry No.")
        //  2nd char is digit-flag, doAvoidSrcLineQtyChange
        //  3rd char is digit-flag, doAvoidDestLineQtyChange
        IF STRLEN(ParamStr) > 0 THEN
            EVALUATE(doAvoidSrcChanges, COPYSTR(ParamStr, 1, 1));
        IF STRLEN(ParamStr) > 1 THEN
            EVALUATE(doAvoidSrcLineQtyChange, COPYSTR(ParamStr, 2, 1));
        IF STRLEN(ParamStr) > 2 THEN
            EVALUATE(doAvoidDestLineQtyChange, COPYSTR(ParamStr, 3, 1));

        IF NOT ServAllocAppSourcePar.FINDFIRST THEN
            EXIT;
        LineNoSource := ServAllocAppSourcePar."Document Line No.";
        ResourceNo := ServAllocAppSourcePar."Resource No.";
        REPEAT
            IF (ServAllocAppSourcePar."Finished Quantity (Hours)" > 0) THEN BEGIN
                FindSplitEntries(ServAllocAppSourcePar."Allocation Entry No.", ServLaborAllocEntryTmp, 0, 1111);
                IF ServLaborAllocEntryTmp.FINDFIRST THEN BEGIN
                    REPEAT
                        AllocAppEntry.RESET;
                        AllocAppEntry.SETRANGE("Allocation Entry No.", ServLaborAllocEntryTmp."Entry No.");
                        IF AllocAppEntry.FINDFIRST THEN
                            IF (AllocAppEntry."Remaining Quantity (Hours)" > 0) THEN
                                ERROR(TextLoc001);
                    UNTIL ServLaborAllocEntryTmp.NEXT = 0;
                END;
            END;
        UNTIL ServAllocAppSourcePar.NEXT = 0;
        ServAllocAppSourcePar.FINDFIRST;

        //At first fix source allocation
        //before run it do check: is it a real record?
        LaborAllocEntry.GET(ServLaborAllocEntryPar."Entry No.");
        IF NOT doAvoidSrcChanges THEN BEGIN
            QtySourceBeforeChange := ServLaborAllocEntryPar."Quantity (Hours)";
            IsSourceDeallocated := FALSE;
            IF (ShareQtySource <> 100) THEN BEGIN
                // need to update current entry quantity
                WITH ServLaborAllocEntryPar DO BEGIN
                    MainAllocQty := "Quantity (Hours)";
                    QtySource := MainAllocQty * ShareQtySource / 100;
                    IF QtySource = 0 THEN BEGIN
                        DeallocateIncSplit(ServLaborAllocEntryPar."Entry No.", TRUE);
                        IsSourceDeallocated := TRUE;
                    END ELSE BEGIN
                        IF NOT doAvoidSrcLineQtyChange THEN
                            IF ServLineSource.GET(ServLaborAllocEntryPar."Source Subtype", ServLaborAllocEntryPar."Source ID",
                                LineNoSource) THEN BEGIN
                                ServLineSource.SetTimeQty(QtySource, TRUE, TRUE);
                                ServLineSource.MODIFY;
                            END;
                        IF FinishedQty = 0 THEN
                            ProcessMovement(ServLaborAllocEntryPar."Entry No.", "Resource No.", "Start Date-Time", QtySource, 1, LaborAllocEntry.Status, -1, LaborAllocEntry.Travel)
                        ELSE BEGIN
                            ProcessMovement(ServLaborAllocEntryPar."Entry No.", "Resource No.", "Start Date-Time", QtySource, 1, LaborAllocEntry.Status, -1, LaborAllocEntry.Travel);
                        END;
                    END;
                END;
            END;
        END;

        //add "Service Line EDMS" for destination
        IF DoCreateServLine THEN BEGIN
            ServLineSource.GET(ServLaborAllocEntryPar."Source Subtype", ServLaborAllocEntryPar."Source ID",
              AllocAppEntrySource."Document Line No.");
            ServLineDestPar := ServLineSource;
            NewLineNo := NewLineNo + 1;
            "Line No." := NewLineNo;
            ServLineDestPar.INSERT;

            //    DocMgtDMS.ServiceCopyDimensions(ServLineSource, NewLineNo);//30.10.2012 EDMS

        END;
        IF NOT doAvoidDestLineQtyChange THEN BEGIN
            IF ShareQtyDest <> 100 THEN BEGIN
                ServLineDestPar.VALIDATE("Standard Time", "Standard Time" * ShareQtyDest / 100);
                ServLineDestPar.SetTimeQty(QtySourceBeforeChange * ShareQtyDest / 100, TRUE, TRUE);
            END;
            ServLineDestPar.MODIFY;
        END;

        // add allocation for destination service line
        FinishedQty := ServAllocAppSourcePar."Finished Quantity (Hours)";
        RemainingQty := ServAllocAppSourcePar."Remaining Quantity (Hours)";
        FinishedQty := ROUND(FinishedQty * ShareQtyDest / 100, 0.00001);
        RemainingQty := ROUND(RemainingQty * ShareQtyDest / 100, 0.00001);
        IF StartTimeDepends AND NOT IsSourceDeallocated THEN BEGIN
            DateStart := GetEntryEndingTimeFull(ServLaborAllocEntryPar."Entry No.");
            IF DateStart <= DateTimeMgt.Datetime(0D, 0T) THEN // THAT Is in case when source allocation is deallocated
                DateStart := ServLaborAllocEntryPar."Start Date-Time";
        END ELSE
            DateStart := ServLaborAllocEntryPar."Start Date-Time";
        DateStart := ROUND(DateStart, 0.000001, '>');  // it strange, but sometimes datestart stored in database is not able to proceed
                                                       // by DateTime2Time, so need to round-up it before!

        //19.03.2013 EDMS P8 >>
        IF ServLaborAllocEntryPar.Status = ServLaborAllocEntryPar.Status::Pending THEN
            AllocTimeQty := ServLineDestPar.GetTimeQty
        ELSE
            AllocTimeQty := ROUND(ServLaborAllocEntryPar."Quantity (Hours)" * ShareQtyDest / 100, 0.00001);
        //19.03.2013 EDMS P8 <<

        NewAllocEntryNo := CreateNewAllocEntry(DateStart, ResourceNo,
          AllocTimeQty, ServLineDestPar."Document Type",
          ServLineDestPar."Document No.", ServLineDestPar."Line No.", ServLaborAllocEntryPar."Reason Code",
          ServLaborAllocEntryPar."Planning Policy", FinishedQty, RemainingQty, ServLaborAllocEntryPar.Status);
        IF ServAllocAppSourcePar.COUNT > 1 THEN BEGIN
            ServAllocAppSourcePar.NEXT; // it should be second line
            REPEAT
                ServLineDestPar.NEXT;
                CreateAppEntry(NewAllocEntryNo, ServLineDestPar."Document Type", ServLineDestPar."Document No.",
                  ServLineDestPar."Line No.", ResourceNo, 0, 0, FALSE);
            UNTIL ServAllocAppSourcePar.NEXT = 0;
        END;
        ProcessMovement(NewAllocEntryNo, ResourceNo, DateStart, AllocTimeQty, 1, ServLaborAllocEntryPar.Status, -1, ServLaborAllocEntryPar.Travel);
        EXIT(NewLineNo);
    end;

    [Scope('Internal')]
    procedure GetQtyShareOfLineInAlloc(DocType: Integer; DocNo: Code[20]; LineNo: Integer; EntryNo: Integer) ShareOfLine: Decimal
    var
        ServAllocApp: Record "25006277";
        ServiceLine: Record "25006146";
        ServLaborAllocationEntry: Record "25006271";
        QtyTotalOfApp: Decimal;
        MainAllocQty: Decimal;
        MainLineQty: Decimal;
    begin
        QtyTotalOfApp := 0;
        ShareOfLine := 1;
        ServAllocApp.RESET;
        ServAllocApp.SETRANGE("Allocation Entry No.", EntryNo);
        IF ServAllocApp.FINDFIRST THEN BEGIN
            IF ServLaborAllocationEntry.GET(EntryNo) THEN
                MainAllocQty := ServLaborAllocationEntry."Quantity (Hours)"
            ELSE
                MainAllocQty := 0;
            ServiceLine.GET(DocType, DocNo, LineNo);
            MainLineQty := ServiceLine.GetTimeQty;
            IF ServAllocApp.COUNT > 1 THEN BEGIN
                REPEAT
                    IF ServiceLine.GET(DocType, DocNo, ServAllocApp."Document Line No.") THEN
                        QtyTotalOfApp += ServiceLine.GetTimeQty;
                UNTIL ServAllocApp.NEXT = 0;
                ShareOfLine := QtyTotalOfApp / MainLineQty;
            END;
        END;
        EXIT(ShareOfLine * 100);
    end;

    [Scope('Internal')]
    procedure GetEntryEndingTimeFull(EntryNo: Integer): Decimal
    var
        ServLaborAllocEntryTmp: Record "25006271" temporary;
    begin
        //returns ending time of last allocation part if original is splitted
        FindSplitEntries(EntryNo, ServLaborAllocEntryTmp, 0, 1111);
        ServLaborAllocEntryTmp.RESET;
        IF ServLaborAllocEntryTmp.FINDLAST THEN
            EXIT("End Date-Time");
        EXIT(0);
    end;

    [Scope('Internal')]
    procedure CreateNewAllocEntry(StartingDateTime: Decimal; ResourceNo: Code[20]; Hours: Decimal; SourceType: Integer; SourceID: Code[20]; LineNo: Integer; ReasonCode: Code[10]; PlanningPolicy: Integer; FinishedHours: Decimal; RemainingHours: Decimal; Status: Integer): Integer
    var
        NewServLaborAllocEntry: Record "25006271";
        NewAllocAppEntry: Record "25006277";
        EntryNo: Integer;
    begin
        //returns new allocation entry no
        NewServLaborAllocEntry.RESET;
        NewServLaborAllocEntry.FINDLAST;
        EntryNo := NewServLaborAllocEntry."Entry No." + 1;

        NewServLaborAllocEntry.INIT;
        NewServLaborAllocEntry."Entry No." := EntryNo;
        NewServLaborAllocEntry."Source Type" := NewServLaborAllocEntry."Source Type"::"Service Document";
        NewServLaborAllocEntry."Source Subtype" := SourceType;
        NewServLaborAllocEntry."Source ID" := SourceID;
        NewServLaborAllocEntry."Start Date-Time" := ROUND(StartingDateTime, 0.00001);
        NewServLaborAllocEntry."Quantity (Hours)" := Hours;
        NewServLaborAllocEntry."End Date-Time" := ROUND(StartingDateTime + NewServLaborAllocEntry."Quantity (Hours)" * 3.6, 0.00001);
        NewServLaborAllocEntry."Resource No." := ResourceNo;
        NewServLaborAllocEntry."User ID" := USERID;
        NewServLaborAllocEntry.Status := Status;
        NewServLaborAllocEntry."Reason Code" := ReasonCode;
        NewServLaborAllocEntry."Planning Policy" := PlanningPolicy;
        NewServLaborAllocEntry.INSERT;

        CreateAppEntry(EntryNo, SourceType, SourceID, LineNo, ResourceNo, FinishedHours, RemainingHours, TRUE);
        EXIT(EntryNo);
    end;

    [Scope('Internal')]
    procedure CreateAppEntry(EntryNo: Integer; DocType: Integer; DocNo: Code[20]; LineNo: Integer; ResourceNo: Code[20]; FinishedHours: Decimal; RemainingHours: Decimal; TimeLine: Boolean)
    var
        NewAllocAppEntry: Record "25006277";
    begin
        NewAllocAppEntry.INIT;
        NewAllocAppEntry."Allocation Entry No." := EntryNo;
        NewAllocAppEntry."Document Type" := DocType;
        NewAllocAppEntry."Document No." := DocNo;
        NewAllocAppEntry."Document Line No." := LineNo;
        NewAllocAppEntry."Resource No." := ResourceNo;
        NewAllocAppEntry."Time Line" := TimeLine;
        IF TimeLine THEN BEGIN
            NewAllocAppEntry."Finished Quantity (Hours)" := FinishedHours;
            NewAllocAppEntry."Remaining Quantity (Hours)" := RemainingHours;
        END ELSE BEGIN
            NewAllocAppEntry."Finished Quantity (Hours)" := 0;
            NewAllocAppEntry."Remaining Quantity (Hours)" := 0;
        END;
        NewAllocAppEntry.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure CreateAppEntryByEntry(var ServLaborAllocationEntryPar: Record "25006271"; var ServLaborAllocApplicationPar: Record "25006277"; LineNo: Integer; FinishedHours: Decimal; RemainingHours: Decimal; TimeLine: Boolean)
    begin
        ServLaborAllocApplicationPar.INIT;
        ServLaborAllocApplicationPar."Allocation Entry No." := ServLaborAllocationEntryPar."Entry No.";
        ServLaborAllocApplicationPar."Document Type" := ServLaborAllocationEntryPar."Source Subtype";
        ServLaborAllocApplicationPar."Document No." := ServLaborAllocationEntryPar."Source ID";
        ServLaborAllocApplicationPar."Document Line No." := LineNo;
        ServLaborAllocApplicationPar."Resource No." := ServLaborAllocationEntryPar."Resource No.";
        ServLaborAllocApplicationPar."Time Line" := TimeLine;
        IF TimeLine THEN BEGIN
            ServLaborAllocApplicationPar."Finished Quantity (Hours)" := FinishedHours;
            ServLaborAllocApplicationPar."Remaining Quantity (Hours)" := RemainingHours;
        END ELSE BEGIN
            ServLaborAllocApplicationPar."Finished Quantity (Hours)" := 0;
            ServLaborAllocApplicationPar."Remaining Quantity (Hours)" := 0;
        END;
        ServLaborAllocApplicationPar.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure AdjustAllocEntryByShare(ServLinePar: Record "25006146"; ShareQty: Decimal)
    var
        ServLaborAllocEntry: Record "25006271";
        AllocAppEntry: Record "25006277";
    begin
        IF (ShareQty <> 100) THEN BEGIN
            // need to update current entry quantity
            AllocAppEntry.RESET;
            AllocAppEntry.SETRANGE("Document Type", ServLinePar."Document Type");
            AllocAppEntry.SETRANGE("Document No.", ServLinePar."Document No.");
            AllocAppEntry.SETRANGE("Document Line No.", ServLinePar."Line No.");
            IF NOT AllocAppEntry.FINDFIRST THEN
                EXIT;
            IF ServLaborAllocEntry.GET(AllocAppEntry."Allocation Entry No.") THEN BEGIN
                "Quantity (Hours)" := "Quantity (Hours)" * ShareQty / 100;
                "End Date-Time" := ROUND("Start Date-Time" + "Quantity (Hours)" * 3.6, 0.00001);

                IF "Quantity (Hours)" = 0 THEN
                    ServLaborAllocEntry.DELETE(TRUE)
                ELSE
                    ServLaborAllocEntry.MODIFY(TRUE);
                AllocAppEntry.RESET;
                AllocAppEntry.SETRANGE("Allocation Entry No.", ServLaborAllocEntry."Entry No.");
                IF AllocAppEntry.FINDFIRST THEN BEGIN
                    IF AllocAppEntry."Finished Quantity (Hours)" > 0 THEN BEGIN
                        AllocAppEntry."Finished Quantity (Hours)" := AllocAppEntry."Finished Quantity (Hours)" * ShareQty / 100;
                    END;
                    IF AllocAppEntry."Remaining Quantity (Hours)" > 0 THEN BEGIN
                        AllocAppEntry."Remaining Quantity (Hours)" := "Quantity (Hours)";
                    END;
                    AllocAppEntry."Time Line" := TRUE;
                    AllocAppEntry.MODIFY;
                END;
            END ELSE BEGIN
                IF AllocAppEntry."Finished Quantity (Hours)" > 0 THEN BEGIN
                    AllocAppEntry."Finished Quantity (Hours)" := AllocAppEntry."Finished Quantity (Hours)" * ShareQty / 100;
                END;
                AllocAppEntry.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure LookupResourceToAllocEntry(AllocEntryNo: Code[20])
    var
        ResourceList: Page "77";
        ServLaborAllocationEntry: Record "25006271";
        Resource: Record "156";
        NewLineNo: Integer;
    begin
        IF NOT CheckUserRightsAdv(2, LaborAllocEntry) THEN EXIT;

        CLEAR(ResourceList);

        ResourceList.LOOKUPMODE(TRUE);

        IF ResourceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ResourceList.SetSelectionFilter1(Resource);

            IF Resource.FINDFIRST THEN BEGIN
                IF ServLaborAllocationEntry.GET(AllocEntryNo) THEN
                    REPEAT
                        AddResourceToAllocEntry(ServLaborAllocationEntry, LaborAllocApp, Resource."No.", 0, LaborAllocEntry, LaborAllocApp);
                    UNTIL Resource.NEXT = 0;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure AddResourceToAllocEntry(var ServLaborAllocationEntry: Record "25006271"; var ServLaborAllocApplication: Record "25006277"; ResourceNo: Code[20]; ApplyToEntryNo: Integer; var NewServLaborAllocEntry: Record "25006271"; var NewServLaborAllocApplication: Record "25006277"): Integer
    var
        TextNotLineFound: Label 'For the location is not found service line.';
        EntryNo: Integer;
        LaborAllocEntryL: Record "25006271";
    begin
        // actually it is not adding to allocation entry, but creating new entry with same pars and different resource
        ServLaborAllocApplication.SETRANGE("Resource No.");
        ServLaborAllocApplication.SETRANGE("Allocation Entry No.", ServLaborAllocationEntry."Entry No.");
        IF NOT ServLaborAllocApplication.FINDFIRST THEN
            ERROR(TextNotLineFound);

        LaborAllocEntryL.RESET;
        LaborAllocEntryL.FINDLAST;
        EntryNo := LaborAllocEntryL."Entry No." + 1;

        NewServLaborAllocEntry.INIT;
        NewServLaborAllocEntry."Entry No." := EntryNo;
        NewServLaborAllocEntry."Source Type" := NewServLaborAllocEntry."Source Type"::"Service Document";
        NewServLaborAllocEntry."Source Subtype" := ServLaborAllocationEntry."Source Subtype";
        NewServLaborAllocEntry."Source ID" := ServLaborAllocationEntry."Source ID";
        NewServLaborAllocEntry."Start Date-Time" := ROUND(ServLaborAllocationEntry."Start Date-Time", 0.00001);
        NewServLaborAllocEntry."Quantity (Hours)" := ServLaborAllocationEntry."Quantity (Hours)";
        NewServLaborAllocEntry."End Date-Time" := ROUND(ServLaborAllocationEntry."Start Date-Time" +
          NewServLaborAllocEntry."Quantity (Hours)" * 3.6, 0.00001);
        NewServLaborAllocEntry."Resource No." := ResourceNo;
        NewServLaborAllocEntry."User ID" := USERID;
        NewServLaborAllocEntry.Status := ServLaborAllocationEntry.Status;
        NewServLaborAllocEntry."Reason Code" := ServLaborAllocationEntry."Reason Code";
        NewServLaborAllocEntry."Planning Policy" := ServLaborAllocationEntry."Planning Policy";
        NewServLaborAllocEntry."Parent Alloc. Entry No." := ServLaborAllocationEntry."Entry No.";
        NewServLaborAllocEntry."Parent Link Synchronize" := TRUE;
        NewServLaborAllocEntry.INSERT;

        //ADJUST SOURCE ENTRY sets:
        IF NOT "Parent Link Synchronize" THEN BEGIN
            "Parent Link Synchronize" := TRUE;
            ServLaborAllocationEntry.MODIFY;
        END;

        CreateAppEntryByEntry(NewServLaborAllocEntry, NewServLaborAllocApplication,
          ServLaborAllocApplication."Document Line No.", 0, ServLaborAllocationEntry."Quantity (Hours)", FALSE);
        EXIT(EntryNo);
    end;

    [Scope('Internal')]
    procedure ShowServLineResources(var ServiceLine: Record "25006146")
    var
        ServLaborAllocApplication: Record "25006277";
        ServLaborAllocApplicationTemp: Record "25006277" temporary;
    begin
        IF NOT ServiceLine.FINDSET THEN
            EXIT;
        ServLaborAllocApplicationTemp.RESET;
        ServLaborAllocApplicationTemp.DELETEALL;
        ServLaborAllocApplication.SETRANGE("Document Type", ServiceLine."Document Type");
        ServLaborAllocApplication.SETRANGE("Document No.", ServiceLine."Document No.");
        ServLaborAllocApplication.SETRANGE("Document Line No.", ServiceLine."Line No.");
        IF ServLaborAllocApplication.FINDFIRST THEN
            REPEAT
                ServLaborAllocApplicationTemp := ServLaborAllocApplication;
                ServLaborAllocApplicationTemp.INSERT;
            UNTIL ServLaborAllocApplication.NEXT = 0;
        PAGE.RUNMODAL(0, ServLaborAllocApplicationTemp);
    end;

    [Scope('Internal')]
    procedure GetMainAllocEntrNo(EntryNo: Integer; RunModeFlags: Integer) RetEntryNo: Integer
    var
        LaborAllocEntryL: Record "25006271";
        StatusArray: array[10] of Integer;
    begin
        // RunModeFlags = 1011, what statuses are taken in account REAden from right to left (On Hold,Finished,In Progress,Pending)
        AdjustFlagsToArray(RunModeFlags, StatusArray);

        RetEntryNo := EntryNo;
        IF LaborAllocEntry.GET(EntryNo) THEN BEGIN
            REPEAT
                LaborAllocEntry.GET(EntryNo);
                IF IsIntInArrayTen(LaborAllocEntry.Status, StatusArray) THEN
                    RetEntryNo := LaborAllocEntry."Entry No.";
                EntryNo := LaborAllocEntry."Applies-to Entry No.";
            UNTIL LaborAllocEntry."Applies-to Entry No." = 0;
        END;
        EXIT(RetEntryNo);
    end;

    [Scope('Internal')]
    procedure FindSplitEntries(EntryNo: Integer; var LaborAllocEntryPar: Record "25006271"; EntryType: Option Original,Next,Previous; RunModeFlags: Integer)
    var
        LaborAllocEntryLookIn: Record "25006271";
        LaborAllocEntryCurr: Record "25006271";
        StatusArray: array[10] of Integer;
    begin
        // RunModeFlags = 1011, that statuses are taken in account, readen from right to left (On Hold,Finished,In Progress,Pending)
        LaborAllocEntryCurr.GET(EntryNo);
        IF RunModeFlags = 0 THEN BEGIN  //15.08.2013 EDMS P8
                                        // that one is a case that need to take only one status records of source rec.
            CASE LaborAllocEntryCurr.Status OF
                0:
                    RunModeFlags := 1;
                1:
                    RunModeFlags := 10;
                2:
                    RunModeFlags := 100;
                3:
                    RunModeFlags := 1000;
            END;
        END;
        AdjustFlagsToArray(RunModeFlags, StatusArray);

        IF EntryType <> EntryType::Previous THEN BEGIN
            IF NOT LaborAllocEntryPar.GET(LaborAllocEntryCurr."Entry No.") THEN BEGIN
                IF IsIntInArrayTen(LaborAllocEntryCurr.Status, StatusArray) THEN BEGIN
                    LaborAllocEntryPar := LaborAllocEntryCurr;
                    LaborAllocEntryPar.INSERT;
                END;
            END;
            LaborAllocEntryLookIn.RESET;
            LaborAllocEntryLookIn.SETRANGE("Applies-to Entry No.", EntryNo);
            IF LaborAllocEntryLookIn.FINDFIRST THEN
                REPEAT
                    FindSplitEntries(LaborAllocEntryLookIn."Entry No.", LaborAllocEntryPar, 1, RunModeFlags);  //12.08.2013 EDMS P8
                UNTIL LaborAllocEntryLookIn.NEXT = 0;
        END;

        IF EntryType <> EntryType::Next THEN BEGIN
            IF NOT LaborAllocEntryPar.GET(LaborAllocEntryCurr."Entry No.") THEN BEGIN
                IF IsIntInArrayTen(LaborAllocEntryCurr.Status, StatusArray) THEN BEGIN
                    LaborAllocEntryPar := LaborAllocEntryCurr;
                    LaborAllocEntryPar.INSERT;
                END;
            END;
            IF LaborAllocEntryCurr."Applies-to Entry No." > 0 THEN
                IF LaborAllocEntryLookIn.GET(LaborAllocEntryCurr."Applies-to Entry No.") THEN
                    FindSplitEntries(LaborAllocEntryLookIn."Entry No.", LaborAllocEntryPar, 2, RunModeFlags);  //12.08.2013 EDMS P8
        END;
    end;

    [Scope('Internal')]
    procedure FindRelatedEntries(EntryNo: Integer; var LaborAllocEntryTmp: Record "25006271" temporary; DeleteRecs: Boolean; RunModeFlags: Integer) RetRecCount: Integer
    var
        LaborAllocEntryL: Record "25006271";
        StatusArray: array[10] of Integer;
    begin
        // RunModeFlags = 1011, what statuses are taken in account REAden from right to left (On Hold,Finished,In Progress,Pending)
        AdjustFlagsToArray(RunModeFlags, StatusArray);

        // it is supposed that related as child and parent directions
        IF DeleteRecs THEN BEGIN
            //FIND parent part, SO THAT part is to get rid of recursive loop
            IF LaborAllocEntry.GET(EntryNo) THEN
                IF LaborAllocEntry."Parent Alloc. Entry No." > 0 THEN BEGIN
                    FindRelatedEntries(LaborAllocEntry."Parent Alloc. Entry No.", LaborAllocEntryTmp, TRUE, 1011);
                    EXIT(LaborAllocEntryTmp.COUNT);
                END;
            LaborAllocEntryTmp.RESET;
            LaborAllocEntryTmp.DELETEALL;
        END;
        IF NOT LaborAllocEntry.GET(EntryNo) THEN
            EXIT;
        IF NOT LaborAllocEntryTmp.GET(EntryNo) THEN BEGIN
            IF IsIntInArrayTen(LaborAllocEntry.Status, StatusArray) THEN BEGIN
                LaborAllocEntryTmp := LaborAllocEntry;
                LaborAllocEntryTmp.INSERT;
            END;
        END;
        //FIND child part
        LaborAllocEntryL.SETCURRENTKEY("Parent Alloc. Entry No.");
        LaborAllocEntryL.SETRANGE("Parent Alloc. Entry No.", EntryNo);
        IF LaborAllocEntryL.FINDFIRST THEN
            REPEAT
                FindRelatedEntries(LaborAllocEntryL."Entry No.", LaborAllocEntryTmp, FALSE, 1011);
            UNTIL LaborAllocEntryL.NEXT = 0;
        EXIT(LaborAllocEntryTmp.COUNT);
    end;

    [Scope('Internal')]
    procedure FindFirstAppliedEntryNo() RetValue: Integer
    var
        LaborAllocEntryParent: Record "25006271";
    begin
        IF LaborAllocEntry."Applies-to Entry No." > 0 THEN BEGIN
            LaborAllocEntry.GET(LaborAllocEntry."Applies-to Entry No.");
            EXIT(FindFirstAppliedEntryNo)
        END ELSE
            EXIT(LaborAllocEntry."Entry No.");
    end;

    [Scope('Internal')]
    procedure FindAllocEntriesOfServLine(ServiceLinePar: Record "25006146"; var LaborAllocEntryTmp: Record "25006271" temporary; RunModeFlags: Text[30])
    var
        LaborAllocEntryL: Record "25006271";
        LaborAllocAppL: Record "25006277";
    begin
        LaborAllocAppL.RESET;
    end;

    [Scope('Internal')]
    procedure SynchroniseRelatedEntry(SourceLaborAllocEntryNo: Integer; DestLaborAllocEntryNo: Integer) SynchronisedCount: Integer
    var
        SourceLaborAllocEntryTmp: Record "25006271" temporary;
        DestLaborAllocEntryTmp: Record "25006271" temporary;
        LaborAllocEntryL: Record "25006271";
        EntryNo: Integer;
        DestStatusBefore: Integer;
    begin
        FindSplitEntries(SourceLaborAllocEntryNo, SourceLaborAllocEntryTmp, 0, 1111);
        FindSplitEntries(DestLaborAllocEntryNo, DestLaborAllocEntryTmp, 0, 1011);
        DestLaborAllocEntryTmp.FINDFIRST;
        LaborAllocEntry.RESET;
        IF SourceLaborAllocEntryTmp.COUNT > DestLaborAllocEntryTmp.COUNT THEN BEGIN
            LaborAllocEntry.RESET;
            LaborAllocEntry.FINDLAST;
            EntryNo := LaborAllocEntry."Entry No.";
            DestLaborAllocEntryTmp.FINDLAST;
            REPEAT
                InsertAllocationEntry(LaborAllocEntry, LaborAllocApp, DestLaborAllocEntryTmp."Resource No.",
                                      DestLaborAllocEntryTmp."Start Date-Time", DestLaborAllocEntryTmp."Quantity (Hours)",
                                      DestLaborAllocEntryTmp."Source Type", DestLaborAllocEntryTmp."Source Subtype",
                                      DestLaborAllocEntryTmp."Source ID", DestLaborAllocEntryNo, TRUE, LaborAllocEntry.Travel);
                DestLaborAllocEntryTmp := LaborAllocEntry;
                DestLaborAllocEntryTmp.INSERT;
            UNTIL SourceLaborAllocEntryTmp.COUNT = DestLaborAllocEntryTmp.COUNT;
        END ELSE BEGIN
            IF SourceLaborAllocEntryTmp.COUNT < DestLaborAllocEntryTmp.COUNT THEN BEGIN
                REPEAT
                    DestLaborAllocEntryTmp.FINDLAST;
                    DeleteAllocationEntry(LaborAllocEntry, LaborAllocApp, DestLaborAllocEntryTmp."Entry No.", 11111);
                    DestLaborAllocEntryTmp.DELETE;
                UNTIL SourceLaborAllocEntryTmp.COUNT = DestLaborAllocEntryTmp.COUNT;
            END;
        END;
        // now is going to synchr. times
        SourceLaborAllocEntryTmp.FINDFIRST;
        DestLaborAllocEntryTmp.FINDFIRST;
        EntryNo := 0;
        REPEAT
            LaborAllocEntry.GET(DestLaborAllocEntryTmp."Entry No.");
            DestStatusBefore := LaborAllocEntry.Status;
            IF DestLaborAllocEntryTmp."Applies-to Entry No." = 0 THEN
                DestLaborAllocEntryTmp."Applies-to Entry No." := SourceLaborAllocEntryTmp."Applies-to Entry No.";
            ModifyAllocationEntry(LaborAllocEntry, LaborAllocApp, DestLaborAllocEntryTmp."Entry No.",
                                  DestLaborAllocEntryTmp."Resource No.",
                                  SourceLaborAllocEntryTmp."Start Date-Time", SourceLaborAllocEntryTmp."Quantity (Hours)",
                                  FALSE, SourceLaborAllocEntryTmp.Status, DestLaborAllocEntryTmp."Applies-to Entry No.", LaborAllocEntry.Travel);
            IF DestStatusBefore <> SourceLaborAllocEntryTmp.Status THEN BEGIN
                AllocationStatus := SourceLaborAllocEntryTmp.Status;
                ReasonCodeGlobal := SourceLaborAllocEntryTmp."Reason Code";
                ChangeStatus(LaborAllocEntry);
                ChangeServiceLineStatus(LaborAllocEntry."Entry No.", FALSE);
            END;
            EntryNo := LaborAllocEntry."Entry No.";
            DestLaborAllocEntryTmp.NEXT;
        UNTIL SourceLaborAllocEntryTmp.NEXT = 0;
        EXIT(SynchronisedCount);
    end;

    [Scope('Internal')]
    procedure SynchroniseRelatedEntries(EntryNo: Integer)
    var
        LaborAllocEntryTemp: Record "25006271" temporary;
    begin
        EntryNo := GetMainAllocEntrNo(EntryNo, 1011);
        LaborAllocEntry.GET(EntryNo);
        FindRelatedEntries(EntryNo, LaborAllocEntryTemp, TRUE, 1011);
        IF LaborAllocEntryTemp.GET(EntryNo) THEN
            LaborAllocEntryTemp.DELETE;
        IF LaborAllocEntryTemp.FINDFIRST THEN
            REPEAT
                IF LaborAllocEntryTemp."Parent Link Synchronize" OR (LaborAllocEntry."Parent Link Synchronize" AND
                    (LaborAllocEntry."Entry No." <> LaborAllocEntryTemp."Entry No.")) THEN BEGIN
                    SynchroniseRelatedEntry(EntryNo, LaborAllocEntryTemp."Entry No.");
                END;
            UNTIL LaborAllocEntryTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure AllocationSetParam(var SourceType: Option ,"Service Document","Standard Event"; var QtyToAllocate: Decimal; var ServiceLineSrcPar: Record "25006146"; var ServiceLinePar: Record "25006146" temporary; var LineNo: Integer; Mode: Option "New Allocation","Move Existing","Split Existing","Break"; SourceSubType: Option Quote,"Order"; SourceID: Code[20])
    var
        ServiceLineLoc: Record "25006146";
        IsServiceHeader: Boolean;
    begin
        CASE SourceType OF
            SourceType::"Standard Event":
                BEGIN
                    IF QtyToAllocate = 0 THEN
                        QtyToAllocate := 1;

                END;
            SourceType::"Service Document":
                BEGIN
                    IF ServiceLineSrcPar.FINDFIRST AND (ServiceLineSrcPar."Line No." > 0) THEN BEGIN //Service Line Allocation
                        IF ServiceLineSrcPar.COUNT = 1 THEN
                            LineNo := ServiceLineSrcPar."Line No.";
                        REPEAT
                            ServiceLinePar := ServiceLineSrcPar;
                            ServiceLinePar.INSERT;
                            IF Mode = Mode::"New Allocation" THEN
                                QtyToAllocate += ServiceLinePar.GetTimeQty;
                        UNTIL ServiceLineSrcPar.NEXT = 0;
                    END ELSE BEGIN //Service Header Allocation
                        IF Mode = Mode::"New Allocation" THEN BEGIN
                            ServiceLineLoc.RESET;
                            ServiceLineLoc.SETRANGE("Document Type", SourceSubType);
                            ServiceLineLoc.SETRANGE("Document No.", SourceID);
                            ServiceLineLoc.SETRANGE(Type, ServiceLineLoc.Type::Labor);
                            IF ServiceLineLoc.FINDFIRST THEN
                                REPEAT
                                    QtyToAllocate += ServiceLineLoc.GetTimeQty;
                                UNTIL ServiceLineLoc.NEXT = 0;
                        END;

                        ServiceLinePar.RESET;
                        ServiceLinePar.SETRANGE("Document Type", SourceSubType);
                        ServiceLinePar.SETRANGE("Document No.", SourceID);
                        ServiceLinePar.SETRANGE("Line No.", 0);
                        IF NOT ServiceLinePar.FINDFIRST THEN BEGIN
                            ServiceLinePar.INIT;
                            ServiceLinePar."Document Type" := SourceSubType;
                            ServiceLinePar."Document No." := SourceID;
                            "Line No." := 0;
                            ServiceLinePar.INSERT;
                        END;
                    END;
                END;

        END;

        QtyToAllocate := RoundQtyHours(QtyToAllocate, 0);
    end;

    [Scope('Internal')]
    procedure RoundQtyHours(QtyToRound: Decimal; RunMode: Integer): Decimal
    begin
        EXIT(ROUND(QtyToRound, 0.0001));
    end;

    [Scope('Internal')]
    procedure UpdateAllocDetailsText(EntryNo: Integer; DetailsText: Text[250]; DetEntryNo: Integer)
    var
        LaborAllocEntryLoc: Record "25006271";
        ServLaborAllocationDetailLoc: Record "25006268";
        Isfound: Boolean;
    begin
        //24.10.2013 EDMS P8
        IF EntryNo = 0 THEN
            EntryNo := LaborAllocEntry."Entry No.";
        IF LaborAllocEntryLoc.GET(EntryNo) THEN BEGIN
            Isfound := FALSE;
            IF (DetEntryNo <> "Detail Entry No.") THEN BEGIN
                IF ServLaborAllocationDetailLoc.GET(DetEntryNo) THEN BEGIN
                    IF ServLaborAllocationDetailLoc.Description = DetailsText THEN BEGIN
                        LaborAllocEntryLoc.VALIDATE("Detail Entry No.", DetEntryNo);
                        LaborAllocEntryLoc.MODIFY(TRUE);
                        Isfound := TRUE;
                    END;
                END;
            END;
            IF NOT Isfound THEN BEGIN
                IF ServLaborAllocationDetailLoc.GET("Detail Entry No.") THEN BEGIN
                    IF ServLaborAllocationDetailLoc.Description = DetailsText THEN BEGIN
                        //NO NEED CHANGE
                        Isfound := TRUE;
                    END;
                END;
            END;
            IF NOT Isfound THEN BEGIN
                ServLaborAllocationDetailLoc."Entry No." := 0;
                ServLaborAllocationDetailLoc.Description := DetailsText;
                ServLaborAllocationDetailLoc.INSERT(TRUE);
                DetEntryNo := ServLaborAllocationDetailLoc."Entry No.";
                LaborAllocEntry.VALIDATE("Detail Entry No.", DetEntryNo);
                LaborAllocEntry.MODIFY(TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ErrorWithRefresh(MsgText: Text[1024])
    begin
        ErrorStatus := 2;
        ErrorMsgText := MsgText;
    end;

    [Scope('Internal')]
    procedure SetErrorStatus(ErrorStatusPar: Integer)
    begin
        ErrorStatus := ErrorStatusPar;
    end;

    [Scope('Internal')]
    procedure GetErrorStatus(): Integer
    begin
        EXIT(ErrorStatus);
    end;

    [Scope('Internal')]
    procedure GetErrorMsgText(): Text[1024]
    begin
        EXIT(ErrorMsgText);
    end;

    [Scope('Internal')]
    procedure SetAllocationStatus(AllocationStatus1: Option Pending,"In Process",Finished,"On Hold")
    begin
        AllocationStatus := AllocationStatus1;
    end;

    [Scope('Internal')]
    procedure FinishOtherTasks(ResourceNo: Code[20]; EntryNo: Integer; StartingDateTime: Decimal)
    var
        OnDate: Date;
        OnTime: Time;
        MainAllocEntryNo: Integer;
        MainLaborAllocationEntry: Record "25006271";
        StartFinishAllocation: Page "25006355";
        StatusToSet: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        SingleInstanceManagment: Codeunit "25006001";
        Resource: Record "156";
    begin
        OnDate := DateTimeMgt.Datetime2Date(StartingDateTime);
        OnTime := DateTimeMgt.Datetime2Time(StartingDateTime);

        ServiceSetup.GET;
        Resource.GET(ResourceNo);
        CASE Resource."On Task Start" OF
            Resource."On Task Start"::"Hold Other Tasks":
                BEGIN
                    LaborAllocEntry.RESET;
                    LaborAllocEntry.SETRANGE("Resource No.", ResourceNo);
                    LaborAllocEntry.SETRANGE(Status, LaborAllocEntry.Status::"In Progress");
                    LaborAllocEntry.SETFILTER(LaborAllocEntry."Entry No.", '<>%1', EntryNo);
                    LaborAllocEntry.SETFILTER(LaborAllocEntry."Applies-to Entry No.", '<>%1', EntryNo);
                    LaborAllocEntry.SETFILTER("Source ID", '<>%1', ServiceSetup."Default Idle Event");
                    IF LaborAllocEntry.FINDFIRST THEN BEGIN
                        REPEAT
                            AllocationStatus := AllocationStatus::"On Hold";
                            MainAllocEntryNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
                            IF MainLaborAllocationEntry.GET(MainAllocEntryNo) AND
                              (MainLaborAllocationEntry.Status = MainLaborAllocationEntry.Status::"In Progress") THEN BEGIN
                                StatusToSet := StatusToSet::"On Hold";
                                SingleInstanceManagment.SetCurrAllocation(MainLaborAllocationEntry."Entry No.");
                                StartFinishAllocation.SetParam(ResourceNo,
                                  DateTimeMgt.Datetime(OnDate, OnTime),
                                  MainLaborAllocationEntry."Quantity (Hours)",
                                  MainLaborAllocationEntry."Source Type",
                                  MainLaborAllocationEntry."Source Subtype",
                                  MainLaborAllocationEntry."Source ID",
                                  StatusToSet,
                                  0);
                                StartFinishAllocation.StartEndWork;
                            END;
                            //WriteAllocationEntryEnd(LaborAllocEntry."Entry No.", StartingDateTime, FALSE, '',LaborAllocEntry.Travel);
                            ResourceTimeRegMgt.AddTimeRegEntries('Onhold', MainLaborAllocationEntry, MainLaborAllocationEntry."Resource No.", OnDate, OnTime);
                        UNTIL LaborAllocEntry.NEXT = 0
                    END;
                END;
            Resource."On Task Start"::"Complete Other Tasks":
                BEGIN
                    LaborAllocEntry.RESET;
                    LaborAllocEntry.SETRANGE("Resource No.", ResourceNo);
                    LaborAllocEntry.SETFILTER(Status, '%1', LaborAllocEntry.Status::"In Progress");
                    LaborAllocEntry.SETFILTER(LaborAllocEntry."Entry No.", '<>%1', EntryNo);
                    LaborAllocEntry.SETFILTER(LaborAllocEntry."Applies-to Entry No.", '<>%1', EntryNo);
                    LaborAllocEntry.SETFILTER("Source ID", '<>%1', ServiceSetup."Default Idle Event");
                    IF LaborAllocEntry.FINDFIRST THEN BEGIN
                        REPEAT
                            AllocationStatus := AllocationStatus::Finished;
                            MainAllocEntryNo := GetMainAllocEntrNo(LaborAllocEntry."Entry No.", 1011);
                            IF MainLaborAllocationEntry.GET(MainAllocEntryNo) AND
                              (MainLaborAllocationEntry.Status = MainLaborAllocationEntry.Status::"In Progress") THEN BEGIN
                                StatusToSet := StatusToSet::"Finish All";
                                SingleInstanceManagment.SetCurrAllocation(MainLaborAllocationEntry."Entry No.");
                                StartFinishAllocation.SetParam(ResourceNo,
                                  DateTimeMgt.Datetime(OnDate, OnTime),
                                  MainLaborAllocationEntry."Quantity (Hours)",
                                  MainLaborAllocationEntry."Source Type",
                                  MainLaborAllocationEntry."Source Subtype",
                                  MainLaborAllocationEntry."Source ID",
                                  StatusToSet,
                                  0);
                                StartFinishAllocation.StartEndWork;
                            END;
                            //WriteAllocationEntryEnd(LaborAllocEntry."Entry No.", StartingDateTime, FALSE, '',LaborAllocEntry.Travel);
                            ResourceTimeRegMgt.AddTimeRegEntries('Complete', LaborAllocEntry, LaborAllocEntry."Resource No.", OnDate, OnTime);
                        UNTIL LaborAllocEntry.NEXT = 0
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure "--SERVICE RESOURCES--"()
    begin
    end;

    [Scope('Internal')]
    procedure GetRelatedResources(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; RunMode: Integer) RetValue: Text[250]
    var
        ServLaborApplication: Record "25006277";
        ServLaborApplicationTmp: Record "25006277" temporary;
        ServiceLine: Record "25006146";
        ServLaborApplicationLoc: Record "25006277";
        isItDocAllocation: Boolean;
        StatusArray: array[10] of Integer;
        isTempTableUse: Boolean;
    begin
        //RunMode first digit from right means should it be used temp resource table
        RetValue := '';
        IF LineType = ServiceLine.Type::Labor THEN BEGIN
            ServLaborApplicationTmp.RESET;
            ServLaborApplicationTmp.DELETEALL;

            ServLaborApplication.RESET;
            ServLaborApplication.SETRANGE("Document Type", DocType);
            ServLaborApplication.SETRANGE("Document No.", DocNo);
            IF LineNo = 0 THEN BEGIN
                // in case that requested for document:
                ServLaborApplication.SETRANGE("Document Line No.");
            END ELSE BEGIN
                ServLaborApplication.SETRANGE("Document Line No.", 0);  // at first try to find document allocation
                IF NOT ServLaborApplication.FINDFIRST THEN
                    ServLaborApplication.SETRANGE("Document Line No.", LineNo);
            END;
            IF ServLaborApplication.FINDFIRST THEN BEGIN
                REPEAT
                    ServLaborApplicationTmp.SETRANGE("Resource No.", ServLaborApplication."Resource No.");
                    IF NOT ServLaborApplicationTmp.FINDFIRST THEN BEGIN
                        RetValue += ServLaborApplication."Resource No." + ',';
                        ServLaborApplicationTmp := ServLaborApplication;
                        ServLaborApplicationTmp.INSERT;
                    END;
                UNTIL ServLaborApplication.NEXT = 0;
                RetValue := COPYSTR(RetValue, 1, STRLEN(RetValue) - 1);
            END;
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure SetRelatedResources(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; RecourcesTextSource: Text[250]; RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "25006277";
        Posit: Integer;
        ServiceSetup: Record "25006120";
        ResourceToAdd: Text[30];
        Resource: Record "156";
        RecourcesText: Text[250];
        RecourcesTextToModify: Text[250];
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "25006146";
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        ServiceSetup.GET;
        isItAllowedMessage := ((RunMode MOD 10) = 0);
        divResult := (RunMode DIV 10);
        isItDocAllocation := ((divResult > 0) AND ((divResult MOD 10) > 0));
        IF ((LineNo = 0) AND NOT isItDocAllocation) THEN
            ERROR(Text148);

        RecourcesText := RecourcesTextSource;
        ResourcesCount := 0;
        IF LineType = ServiceLine.Type::Labor THEN BEGIN
            ServLaborApplication.SETRANGE("Document Type", DocType);
            ServLaborApplication.SETRANGE("Document No.", DocNo);
            ServLaborApplication.SETRANGE("Document Line No.", LineNo);
            IF NOT ServLaborApplication.FINDFIRST THEN BEGIN
                ServLaborApplication.SETRANGE("Document Line No.", 0);
                // actually for nowdays such case is unpossible, but in future...
                IF ServLaborApplication.FINDFIRST THEN
                    IF isItAllowedMessage THEN BEGIN
                        IF NOT CONFIRM(Text147, FALSE) THEN
                            EXIT;
                    END ELSE
                        EXIT;
            END;
            ServLaborApplication.SETRANGE("Document Line No.", LineNo);
            REPEAT
                Posit := STRPOS(RecourcesText, ',');
                IF Posit > 0 THEN BEGIN
                    ResourceToAdd := COPYSTR(RecourcesText, 1, Posit - 1);
                    RecourcesText := COPYSTR(RecourcesText, Posit + 1, STRLEN(RecourcesText) - Posit);
                END ELSE BEGIN
                    ResourceToAdd := RecourcesText;
                    RecourcesText := '';
                END;
                IF Resource.GET(ResourceToAdd) THEN BEGIN
                    ServLaborApplication.SETRANGE("Resource No.", ResourceToAdd);
                    IF NOT ServLaborApplication.FINDLAST THEN BEGIN
                        Resource.TESTFIELD(Blocked, FALSE);

                        ServLaborApplication.INIT;
                        ServLaborApplication."Allocation Entry No." := 0;
                        ServLaborApplication."Document Type" := DocType;
                        ServLaborApplication."Document No." := DocNo;
                        ServLaborApplication."Document Line No." := LineNo;
                        ServLaborApplication."Resource No." := ResourceToAdd;
                        ServLaborApplication.INSERT(TRUE);
                    END;
                END;
            UNTIL RecourcesText = '';
            ServLaborApplication.SETRANGE("Resource No.");
            IF isItDocAllocation THEN
                ServLaborApplication.SETRANGE("Document Line No.", 0);
            IF ServLaborApplication.FINDFIRST THEN
                REPEAT
                    Posit := STRPOS(RecourcesTextSource, ServLaborApplication."Resource No.");
                    IF NOT (Posit > 0) THEN BEGIN
                        ServLaborApplication.DELETE(TRUE);
                        ServLaborApplication.FINDFIRST;
                    END;
                UNTIL ServLaborApplication.NEXT = 0;
            IF ServLaborApplication.FINDFIRST THEN BEGIN
                Posit := STRPOS(RecourcesTextSource, ServLaborApplication."Resource No.");
                IF NOT (Posit > 0) THEN
                    ServLaborApplication.DELETE(TRUE);
            END;
            IF ServLaborApplication.FINDFIRST THEN
                REPEAT
                    RecourcesTextToModify += ServLaborApplication."Resource No." + ',';
                UNTIL ServLaborApplication.NEXT = 0;
            IF STRLEN(RecourcesTextToModify) > 0 THEN
                RecourcesTextToModify := COPYSTR(RecourcesTextToModify, 1, STRLEN(RecourcesTextToModify) - 1);

        END;
        EXIT(ServLaborApplication.COUNT);
    end;

    [Scope('Internal')]
    procedure RelatedResourcesList(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; var RelatedResources: Text[250])
    var
        ServLaborAllocApplication: Record "25006277";
    begin
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Document Type", DocType);
        ServLaborAllocApplication.SETRANGE("Document No.", DocNo);
        ServLaborAllocApplication.SETRANGE("Document Line No.", LineNo);
        IF LineNo < 0 THEN
            ServLaborAllocApplication.SETRANGE("Document Line No.");
        PAGE.RUNMODAL(PAGE::"Service Line Resources", ServLaborAllocApplication);
        RelatedResources := GetRelatedResources(DocType, DocNo, LineType, LineNo, 0);
    end;

    [Scope('Internal')]
    procedure ResourcesList(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; var RelatedResources: Text[250])
    var
        ServLaborApplication: Record "25006277";
        Resource: Record "156";
        ServiceSetup: Record "25006120";
    begin
        //??? checkstatusopen
        // not used for now, it is supposed to be used for lookup (case then SS unactive and only one resource is set)

        ServiceSetup.GET;
        IF ServiceSetup."Service Schedule Active" THEN
            ERROR(Text146);

        ServLaborApplication.RESET;
        ServLaborApplication.SETRANGE("Document Type", DocType);
        ServLaborApplication.SETRANGE("Document No.", DocNo);
        ServLaborApplication.SETRANGE("Document Line No.", LineNo);
        IF ServLaborApplication.FINDFIRST THEN
            IF Resource.GET(ServLaborApplication."Resource No.") THEN;
        IF PAGE.RUNMODAL(0, Resource) = ACTION::OK THEN BEGIN
            RelatedResources := Resource."No.";
            IF ServLaborApplication.FINDFIRST THEN BEGIN
                ServLaborApplication.SETRANGE("Resource No.", Resource."No.");
                IF ServLaborApplication.FINDFIRST THEN BEGIN
                    ServLaborApplication.SETRANGE("Resource No.");
                    ServLaborApplication.SETFILTER("Resource No.", '<>%1', Resource."No.");
                    IF ServLaborApplication.FINDFIRST THEN
                        ServLaborApplication.DELETEALL(TRUE);
                END ELSE BEGIN
                    ServLaborApplication.SETRANGE("Resource No.");
                    ServLaborApplication.FINDFIRST;
                    ServLaborApplication."Resource No." := Resource."No.";
                    ServLaborApplication.MODIFY;
                    ServLaborApplication.FINDLAST;
                    REPEAT
                        ServLaborApplication.DELETE(TRUE);
                    UNTIL ServLaborApplication."Resource No." = Resource."No.";
                END;
            END ELSE BEGIN
                ServLaborApplication.INIT;
                ServLaborApplication."Allocation Entry No." := 0;
                ServLaborApplication."Document Type" := DocType;
                ServLaborApplication."Document No." := DocNo;
                ServLaborApplication."Document Line No." := LineNo;
                ServLaborApplication."Resource No." := Resource."No.";
                ServLaborApplication.INSERT(TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ResourcesCopyLineToLine(DocType: Integer; DocNo: Code[20]; LineType: Integer; LineNo: Integer; DocTypeDestin: Integer; DocNoDestin: Code[20]; LineNoDestin: Integer)
    var
        ServiceLineDest: Record "25006146";
        ResourcesText: Text[250];
    begin
        //Allocation Entry No.,Document Type,Document No.,Line No.
        ServiceSetup.GET;
        IF NOT ServiceSetup."Service Schedule Active" THEN BEGIN
            ResourcesText := GetRelatedResources(DocType, DocNo, LineType, LineNo, 0);
            IF ServiceLineDest.GET(DocTypeDestin, DocNoDestin, LineNoDestin) THEN
                SetRelatedResources(DocType, DocNo, LineType, LineNo, ResourcesText, 0);
        END;
        //means that schedule entries we are not going to copy
    end;

    [Scope('Internal')]
    procedure FillRelatedApplicOfEntry(var ServLaborAllocApplicationPar: Record "25006277"; EntryNoPar: Integer; var LineNoPar: Integer; DocType: Integer; DocNo: Code[20]; ResourceNoPar: Code[20]; NextNewAllocEntryNo: Integer)
    var
        LaborAllocEntryL: Record "25006271";
        LaborAllocApplicationL: Record "25006277";
        ServLaborAllocationEntryTmp: Record "25006271" temporary;
    begin
        IF LaborAllocEntryL.GET(EntryNoPar) THEN BEGIN
            LaborAllocApplicationL.SETRANGE("Document Type", LaborAllocEntryL."Source Subtype");
            LaborAllocApplicationL.SETRANGE("Document No.", LaborAllocEntryL."Source ID");
            LaborAllocApplicationL.SETRANGE("Allocation Entry No.", LaborAllocEntryL."Entry No.");
            IF LaborAllocApplicationL.FINDFIRST THEN
                LineNoPar := LaborAllocApplicationL."Document Line No.";

            FindRelatedEntries(EntryNoPar, ServLaborAllocationEntryTmp, TRUE, 1011);
            LaborAllocApplicationL.RESET;
            IF ServLaborAllocationEntryTmp.FINDFIRST THEN
                REPEAT
                    LaborAllocApplicationL.SETRANGE("Document Type", ServLaborAllocationEntryTmp."Source Subtype");
                    LaborAllocApplicationL.SETRANGE("Document No.", ServLaborAllocationEntryTmp."Source ID");
                    LaborAllocApplicationL.SETRANGE("Allocation Entry No.", ServLaborAllocationEntryTmp."Entry No.");
                    IF LaborAllocApplicationL.FINDFIRST THEN
                        IF LaborAllocApplicationL.FINDFIRST THEN BEGIN
                            ServLaborAllocApplicationPar := LaborAllocApplicationL;
                            ServLaborAllocApplicationPar.INSERT(TRUE);
                        END;
                UNTIL ServLaborAllocationEntryTmp.NEXT = 0;
        END ELSE BEGIN
            // means new entry
            ServLaborAllocApplicationPar."Allocation Entry No." := NextNewAllocEntryNo;
            ServLaborAllocApplicationPar."Document Type" := DocType;
            ServLaborAllocApplicationPar."Document No." := DocNo;
            ServLaborAllocApplicationPar."Document Line No." := LineNoPar;
            ServLaborAllocApplicationPar."Resource No." := ResourceNoPar;
            ServLaborAllocApplicationPar.INSERT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure RemoveDuplicates(var ServLaborApplication: Record "25006277")
    var
        ServLaborApplicationLoc: Record "25006277";
        ServLaborApplicationLoc2: Record "25006277";
    begin
        IF ServLaborApplication.FINDFIRST THEN BEGIN
            // THAT part to remove duplicates that are not in schedule
            ServLaborApplicationLoc.RESET;
            ServLaborApplicationLoc.SETRANGE("Document Type", ServLaborApplication."Document Type");
            ServLaborApplicationLoc.SETRANGE("Document No.", ServLaborApplication."Document No.");
            ServLaborApplicationLoc.SETRANGE("Document Line No.", ServLaborApplication."Document Line No.");
            ServLaborApplicationLoc.SETRANGE("Allocation Entry No.", 0);
            REPEAT
                ServLaborApplicationLoc.SETRANGE("Resource No.", ServLaborApplication."Resource No.");
                IF ServLaborApplicationLoc.FINDSET THEN BEGIN
                    ServLaborApplicationLoc2.COPYFILTERS(ServLaborApplicationLoc);
                    ServLaborApplicationLoc2.SETFILTER("Allocation Entry No.", '>0');
                    IF ServLaborApplicationLoc2.FINDSET THEN BEGIN
                        ServLaborApplicationLoc.DELETEALL(TRUE);
                        ServLaborApplication.FINDFIRST;
                    END ELSE BEGIN
                        IF ServLaborApplicationLoc.COUNT > 1 THEN BEGIN
                            REPEAT
                                ServLaborApplicationLoc.FINDFIRST;
                                ServLaborApplicationLoc.DELETE(TRUE);
                            UNTIL ServLaborApplicationLoc.COUNT <= 1;
                            ServLaborApplication.FINDFIRST;
                        END;
                    END;
                END;
            UNTIL ServLaborApplication.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure "--SMALL TECHN--"()
    begin
    end;

    [Scope('Internal')]
    procedure CutNextDigit(var Flags: Integer) RetValue: Integer
    begin
        RetValue := Flags MOD 10;
        Flags := Flags DIV 10;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure AdjustFlagsToArray(Flags: Integer; var ArrayDMS: array[10] of Integer)
    var
        i: Integer;
    begin
        FOR i := 1 TO 10 DO BEGIN
            IF (CutNextDigit(Flags) > 0) THEN
                ArrayDMS[i] := i - 1
            ELSE
                ArrayDMS[i] := -1;
        END;
    end;

    [Scope('Internal')]
    procedure IsIntInArrayTen(CheckValue: Integer; var ArrayDMS: array[10] of Integer) RetValue: Boolean
    var
        i: Integer;
    begin
        FOR i := 1 TO 10 DO BEGIN
            IF (CheckValue = ArrayDMS[i]) THEN
                RetValue := TRUE;
        END;

        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure CopyServLaborAllocAppl(FromDocType: Option Quote,"Order","Return Order",Invoice,"Credit Memo","Blanket Order"; FromDocNo: Code[20]; FromLineNo: Integer; IsPosted: Boolean; ToServLine: Record "25006146")
    var
        FromServLaborAllocAppl: Record "25006277";
        NewServLaborAllocAppl: Record "25006277";
    begin
        FromServLaborAllocAppl.RESET;
        FromServLaborAllocAppl.SETRANGE("Document Type", FromDocType);
        FromServLaborAllocAppl.SETRANGE("Document No.", FromDocNo);
        FromServLaborAllocAppl.SETRANGE("Document Line No.", FromLineNo);
        FromServLaborAllocAppl.SETRANGE(Posted, IsPosted);
        IF FromServLaborAllocAppl.FINDSET THEN
            REPEAT
                IF Resource.GET(FromServLaborAllocAppl."Resource No.") THEN BEGIN
                    Resource.TESTFIELD(Blocked, FALSE);
                    NewServLaborAllocAppl.INIT;
                    NewServLaborAllocAppl.TRANSFERFIELDS(FromServLaborAllocAppl, FALSE);
                    NewServLaborAllocAppl."Allocation Entry No." := 0;
                    NewServLaborAllocAppl."Document Type" := ToServLine."Document Type";
                    NewServLaborAllocAppl."Document No." := ToServLine."Document No.";
                    NewServLaborAllocAppl."Document Line No." := ToServLine."Line No.";
                    NewServLaborAllocAppl.Posted := FALSE;
                    NewServLaborAllocAppl.INSERT(TRUE);
                END;
            UNTIL FromServLaborAllocAppl.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CancelAllocation(AllocationStatus1: Option Pending,"In Progress","Finish All","Finish Part","On Hold"; StartingDateTime: Decimal; ShowDialog: Boolean)
    var
        DoReplan: Boolean;
        Hours: Decimal;
        LaborAllocEntry2: Record "25006271";
        ServSchedAddInMgt: Codeunit "25006203";
        Travel: Boolean;
    begin
        IF ShowDialog THEN
            IF NOT CONFIRM(Text161) THEN
                EXIT;

        IF NOT LaborAllocEntry.GET(SingleInstanceMgt.GetAllocationEntryNo) THEN BEGIN
            MESSAGE(Text121);
            EXIT;
        END;

        IF NOT CheckUserRightsAdv(1, LaborAllocEntry) THEN
            EXIT;

        IF AllocationStatus1 = AllocationStatus1::Pending THEN BEGIN
            IF (LaborAllocEntry.Status = LaborAllocEntry.Status::Pending) AND NOT ShowDialog THEN
                EXIT;

            IF LaborAllocEntry.Status <> LaborAllocEntry.Status::"In Progress" THEN
                ERROR(Text162);

            Hours := LaborAllocEntry."Quantity (Hours)";
            ReasonCodeGlobal := LaborAllocEntry."Reason Code";
            DoReplan := FALSE;
            AllocationStatus := AllocationStatus::Pending;
            ChangeAllocationStatus := TRUE;
            Travel := LaborAllocEntry.Travel;

            WriteAllocationEntries(LaborAllocEntry."Resource No.", StartingDateTime, Hours,
                                   LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype",
                                   LaborAllocEntry."Source ID", 1, LaborAllocEntry."Entry No.", DoReplan, AllocationStatus, FALSE, Travel);

            // Cancel Start Allocations for Applied Entries too
            LaborAllocEntry2.RESET;
            LaborAllocEntry2.SETRANGE("Applies-to Entry No.", LaborAllocEntry."Entry No.");
            IF LaborAllocEntry2.FINDFIRST THEN
                ServSchedAddInMgt.CancelStartAllocation(LaborAllocEntry2."Entry No.", LaborAllocEntry2."Resource No.", LaborAllocEntry2."Start Date-Time", LaborAllocEntry2."End Date-Time", FALSE);
        END;
    end;

    [Scope('Internal')]
    procedure CopyServLaborAllocApplFromDetServLedg(FromDocType: Option Quote,"Order","Return Order",Invoice,"Credit Memo","Blanket Order"; FromDocNo: Code[20]; FromLineNo: Integer; ToServLine: Record "25006146")
    var
        NewServLaborAllocAppl: Record "25006277";
        ServLedgEntry: Record "25006167";
        DetServLedgEntry: Record "25006188";
    begin
        ServLedgEntry.RESET;
        ServLedgEntry.SETRANGE("Document Type", FromDocType);
        ServLedgEntry.SETRANGE("Document No.", FromDocNo);
        ServLedgEntry.SETRANGE("Document Line No.", FromLineNo);
        IF ServLedgEntry.FINDSET THEN
            REPEAT
                DetServLedgEntry.RESET;
                DetServLedgEntry.SETRANGE("Service Ledger Entry No.", ServLedgEntry."Entry No.");
                IF DetServLedgEntry.FINDSET THEN
                    REPEAT
                        IF Resource.GET(DetServLedgEntry."Resource No.") THEN BEGIN
                            Resource.TESTFIELD(Blocked, FALSE);
                            NewServLaborAllocAppl.INIT;
                            NewServLaborAllocAppl."Allocation Entry No." := 0;
                            NewServLaborAllocAppl."Document Type" := ToServLine."Document Type";
                            NewServLaborAllocAppl."Document No." := ToServLine."Document No.";
                            NewServLaborAllocAppl."Document Line No." := ToServLine."Line No.";
                            NewServLaborAllocAppl."Line No." += 10000;
                            NewServLaborAllocAppl."Resource No." := DetServLedgEntry."Resource No.";
                            NewServLaborAllocAppl."Finished Quantity (Hours)" := ABS(DetServLedgEntry."Finished Quantity (Hours)");
                            NewServLaborAllocAppl."Time Line" := TRUE;
                            NewServLaborAllocAppl."Unit Cost" := DetServLedgEntry."Unit Cost";
                            NewServLaborAllocAppl."Finished Cost Amount" := ABS(DetServLedgEntry."Cost Amount");
                            NewServLaborAllocAppl."Cost Amount" := ABS(DetServLedgEntry."Cost Amount");
                            NewServLaborAllocAppl.Posted := FALSE;
                            NewServLaborAllocAppl.INSERT(TRUE);
                        END;
                    UNTIL DetServLedgEntry.NEXT = 0;
            UNTIL ServLedgEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure OnSendDocForApproval(HeaderVariant: Variant)
    var
        ServiceHeader: Record "5900";
        RecRef: RecordRef;
        ServiceItemLine: Record "5901";
        ServiceLine: Record "5902";
        RequiresApproval: Boolean;
        Customer: Record "18";
        ApprovalRequired: Boolean;
        ProcurementMemo: Record "130415";
    begin
        RecRef.GETTABLE(HeaderVariant);
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Memo":
                BEGIN
                    RecRef.SETTABLE(ProcurementMemo);
                    IF ProcurementMemo.Status IN [ProcurementMemo.Status::Open] THEN BEGIN
                        ProcurementMemoApproval(ProcurementMemo);
                        ProcurementMemoApprovalfromworkflowusergrp(ProcurementMemo);
                        ProcurementMemo.VALIDATE(Status, ProcurementMemo.Status::"Pending Approval");
                        ProcurementMemo.MODIFY;
                        MESSAGE('Procurement Memo Approval Has Been Sent');
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure ProcurementMemoApprovalfromworkflowusergrp(ProcurementMemo: Record "130415")
    var
        Employee: Record "5200";
        PurchaseHeaderRec: Record "38";
        Amount: Decimal;
        ApprovalLines: Record "104199";
        "eason: The extension could not be deployed because it is already deployed as a global application or a per tenant application.": Integer;
        ApprovalCreated: Boolean;
        PurchaseLine: Record "39";
        Workflowusergroup: Record "1540";
        Workflowusergroupmember: Record "1541";
        EmpNotFind: Label 'Employee with user id %1 could not be found in employees. Please link the nav login id with employee.';
        MailSubject: Label 'Procurement Memo Notification for Document %1';
        SalutationText: Label 'Dear %1';
        Sir: Label 'Sir';
        Mam: Label 'Mam';
        ApprovalReqEmailMsg: Label 'Please approve the document no. %1 For Procurement Memo';
        ApprovedMailMsg: Label 'Document no. %1 has been approved for Procurement Memo';
        RejectedMailMsg: Label 'Document no. %1 has been rejected for Procurement Memo';
        Regards: Label 'Regards,';
        ThankingYou: Label 'Thanking You,';
        BodyMessage: Label 'Approval Memo for the Document No. %1';
        Amt: Label 'For that purpose quotation from Vendor can be find below';
        SMTPMail: Codeunit "400";
        SMTPMailSetup: Record "409";
        MessageText: Text;
        ReceipientEmail: Text;
        ApprovalEntry: Record "454";
        Salutation: Text;
        MailSent: Boolean;
        MailApplicable: Boolean;
        FooterName: Text;
        FooterText: Text;
        SMSApplicable: Boolean;
        BothApplicable: Boolean;
        NCHLNPISetup: Record "33019810";
        SMSWebService: Codeunit "50002";
        MobilePhoneNo: Text;
        MessageID: Text;
        NextApprovalEntries: Record "454";
        NextApprovalCC: Text;
        ProcurementHeader: Record "130415";
    begin
        ApprovalCreated := FALSE;
        Amount := 0;
        CLEAR(SMTPMail);
        CLEAR(SMSApplicable);
        CLEAR(MailApplicable);
        CLEAR(BothApplicable);
        SMTPMailSetup.GET;
        Workflowusergroup.RESET();
        Workflowusergroup.SETRANGE(Active, TRUE);
        Workflowusergroup.SETRANGE(Type, Workflowusergroup.Type::Procurement);
        Workflowusergroup.SETFILTER("Amount Limit Lower", '<=%1', ProcurementMemo."Total Amount");
        Workflowusergroup.SETFILTER("Amount Limit Upper", '>=%1', ProcurementMemo."Total Amount");
        IF Workflowusergroup.FINDFIRST() THEN BEGIN
            Workflowusergroupmember.RESET();
            Workflowusergroupmember.SETRANGE("Workflow User Group Code", Workflowusergroup.Code);
            IF Workflowusergroupmember.FINDSET THEN
                REPEAT
                BEGIN
                    Employee.RESET;
                    Employee.SETRANGE("User ID", Workflowusergroupmember."User Name");
                    IF NOT Employee.FINDFIRST THEN
                        ERROR(EmpNotFind, Workflowusergroupmember."User Name");
                    ReceipientEmail := Employee."Company E-Mail";
                    MessageText := STRSUBSTNO(ApprovalReqEmailMsg, ProcurementMemo."Memo No.");
                    Salutation := STRSUBSTNO(SalutationText, Employee."User ID");
                    FooterName := Workflowusergroupmember."User Name";
                    MailApplicable := TRUE;


                    ProcurementHeader.GET(ProcurementMemo."Memo No.");
                    ProcurementHeader.CALCFIELDS("Total Amount");
                    SMTPMail.CreateMessage(Workflowusergroupmember."User Name", SMTPMailSetup."User ID", ReceipientEmail, STRSUBSTNO(MailSubject, COMPANYNAME), '', TRUE);
                    SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
                    SMTPMail.AppendBody(Salutation);
                    SMTPMail.AppendBody('<br><br>');
                    SMTPMail.AppendBody('Company Name:' + ' ' + FORMAT(COMPANYNAME));
                    //SMTPMail.AppendBody('<br><br>');
                    //SMTPMail.AppendBody(STRSUBSTNO(MessageText,DocumentNo));
                    SMTPMail.AppendBody('<br><br>');
                    SMTPMail.AppendBody('Background:' + ' ' + FORMAT(ProcurementHeader.Background + ProcurementHeader.Background1 + ProcurementHeader.Remarks + Amt));
                    SMTPMail.AppendBody('<br><br>');
                    SMTPMail.AppendBody('Total Amount:' + ' ' + FORMAT(ProcurementHeader."Total Amount"));
                    SMTPMail.AppendBody('<br><br>');
                    SMTPMail.AppendBody(Regards);
                    SMTPMail.AppendBody('<br><br>');
                    SMTPMail.AppendBody(FooterName);
                    IF NextApprovalCC <> '' THEN
                        SMTPMail.AddCC(NextApprovalCC);
                    SMTPMail.Send;

                END;
                UNTIL Workflowusergroupmember.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure OnApproveDoc(DocNo: Code[20])
    var
        ApprovalEntry2: Record "454";
        ServiceHeader: Record "5900";
        RecID: RecordID;
        Opportunity: Record "5092";
        ProcurementMemo: Record "130415";
        ApprovalEntry: Record "454";
        ProcAppr: Record "104199";
    begin
        IF NOT CONFIRM('Do you want to Approve', FALSE) THEN
            EXIT;
        ApprovalEntry.RESET;
        ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Document No.", DocNo);
        ApprovalEntry.SETRANGE("Approver ID", USERID);
        IF ApprovalEntry.FINDFIRST THEN
            REPEAT
                ApprovalEntry.Status := ApprovalEntry.Status::Approved;
                ApprovalEntry.MODIFY(TRUE);
                ProcAppr.RESET;
                ProcAppr.SETRANGE("Memo No.", DocNo);
                ProcAppr.SETRANGE("User ID", ApprovalEntry."Approver ID");
                IF ProcAppr.FINDFIRST THEN BEGIN//aakrista
                    ProcAppr.Approved := TRUE;
                    ProcAppr.MODIFY;
                END;
            UNTIL ApprovalEntry.NEXT = 0;
        ApprovalEntry2.RESET;
        ApprovalEntry2.SETRANGE("Document No.", ApprovalEntry."Document No.");
        ApprovalEntry2.SETFILTER("Sequence No.", '>=%1', ApprovalEntry."Sequence No.");
        ApprovalEntry2.SETRANGE(Status, ApprovalEntry2.Status::Created);
        IF NOT ApprovalEntry2.FINDFIRST THEN BEGIN
            ProcurementMemo.SETRANGE("Memo No.", DocNo);
            ProcurementMemo.MODIFYALL(Status, ProcurementMemo.Status::Released);
        END ELSE BEGIN
            ApprovalEntry2.Status := ApprovalEntry2.Status::Open;
            ApprovalEntry2.MODIFY(TRUE);
        END;
        MESSAGE('This Document Has Been Approved');
        SendApprovalWorkflowMailNotificationPM(2, DocNo);
    end;

    local procedure HavePermission(var ApprovalEntry: Record "454")
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Approval Administrator" THEN
            IF USERID <> ApprovalEntry."Approver ID" THEN
                ERROR('Not authorized to approve.');
    end;

    [Scope('Internal')]
    procedure OnRejectDoc(DocNo: Code[20])
    var
        ApprovalEntry2: Record "454";
        ServiceHeader: Record "5900";
        RecID: RecordID;
        Opportunity: Record "5092";
        ProcurementMemo: Record "130415";
        ApprovalEntry: Record "454";
    begin
        IF NOT CONFIRM('Do you want to reject the document', FALSE) THEN
            EXIT;
        ProcurementMemo.RESET;
        ProcurementMemo.SETRANGE("Memo No.", DocNo);
        IF ProcurementMemo.FINDFIRST THEN
            ProcurementMemo.TESTFIELD(Status, ProcurementMemo.Status::"Pending Approval");
        ProcurementMemo.MODIFYALL(Status, ProcurementMemo.Status::Open);
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Document No.", DocNo);
        ApprovalEntry.SETFILTER(Status, '%1', ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Approver ID", USERID);
        IF ApprovalEntry.FINDFIRST THEN
            REPEAT
                ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Rejected);
                ApprovalEntry.MODIFY(TRUE);
            UNTIL ApprovalEntry.NEXT = 0;
        MESSAGE('This Document Has Been Rejected');
        SendApprovalWorkflowMailNotificationPM(3, DocNo);
    end;

    [Scope('Internal')]
    procedure OnCancelDocForApproval(HeaderRec: Variant)
    var
        ServiceHeader: Record "5900";
        HeaderRecRef: RecordRef;
        ProcurementMemo: Record "130415";
    begin
        HeaderRecRef.GETTABLE(HeaderRec);
        CASE HeaderRecRef.NUMBER OF
            DATABASE::"Procurement Memo":
                BEGIN
                    HeaderRecRef.SETTABLE(ProcurementMemo);
                    CancelApprovalEntry(ProcurementMemo.RECORDID);
                    ProcurementMemo.VALIDATE(Status, ProcurementMemo.Status::Open);
                    ProcurementMemo.MODIFY;
                    MESSAGE('Approval request has been cancelled');
                END;
        END;
    end;

    local procedure CancelApprovalEntry(RecordID: RecordID)
    var
        ApprovalEntry: Record "454";
        ProcApproval: Record "104199";
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        ApprovalEntry.MODIFYALL(Status, ApprovalEntry.Status::Canceled, TRUE);
    end;

    [Scope('Internal')]
    procedure SendApprovalWorkflowMailNotificationPM(EventType: Option " ","Approval Request",Approved,Rejected; DocumentNo: Code[20])
    var
        SMTPMail: Codeunit "400";
        SMTPMailSetup: Record "409";
        MessageText: Text;
        ReceipientEmail: Text;
        Employee: Record "5200";
        ApprovalEntry: Record "454";
        EmpNotFind: Label 'Employee with user id %1 could not be found in employees. Please link the nav login id with employee.';
        MailSubject: Label 'Procurement Memo Approval for Document %1';
        SalutationText: Label 'Dear %1';
        Salutation: Text;
        Sir: Label 'Sir';
        Mam: Label 'Mam';
        ApprovalReqEmailMsg: Label 'Please approve the document no. %1 For Procurement Memo';
        ApprovedMailMsg: Label 'Document no. %1 has been approved for Procurement Memo';
        RejectedMailMsg: Label 'Document no. %1 has been rejected for Procurement Memo';
        Regards: Label 'Regards,';
        MailSent: Boolean;
        MailApplicable: Boolean;
        FooterName: Text;
        ThankingYou: Label 'Thanking You,';
        FooterText: Text;
        SMSApplicable: Boolean;
        BothApplicable: Boolean;
        NCHLNPISetup: Record "33019810";
        SMSWebService: Codeunit "50002";
        MobilePhoneNo: Text;
        MessageID: Text;
        BodyMessage: Label 'Approval Memo for the Document No. %1';
        NextApprovalEntries: Record "454";
        NextApprovalCC: Text;
        ProcurementHeader: Record "130415";
        Amt: Label 'For that purpose quotation from Vendor can be find below';
    begin
        CLEAR(SMTPMail);
        CLEAR(SMSApplicable);
        CLEAR(MailApplicable);
        CLEAR(BothApplicable);
        SMTPMailSetup.GET;
        CASE EventType OF
            EventType::"Approval Request":
                BEGIN
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Procurement Memo");
                    ApprovalEntry.SETRANGE("Document No.", DocumentNo);
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        Employee.RESET;
                        Employee.SETRANGE("User ID", ApprovalEntry."Approver ID");
                        IF NOT Employee.FINDFIRST THEN
                            ERROR(EmpNotFind, ApprovalEntry."Approver ID");
                        ReceipientEmail := Employee."Company E-Mail";
                        MessageText := STRSUBSTNO(ApprovalReqEmailMsg, DocumentNo);
                        Salutation := STRSUBSTNO(SalutationText, Employee."User ID");
                        FooterName := ApprovalEntry."Sender ID";
                        MailApplicable := TRUE;
                    END;
                    //END;
                END;
            EventType::Approved:
                BEGIN
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Procurement Memo");
                    ApprovalEntry.SETRANGE("Document No.", DocumentNo);
                    ApprovalEntry.SETRANGE("Approver ID", USERID);
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        /*Employee.RESET;
                        Employee.SETRANGE("User ID",ApprovalEntry."Approver ID");
                        IF NOT Employee.FINDFIRST THEN
                          ERROR(EmpNotFind,ApprovalEntry."Sender ID");*/
                        //Employee.TESTFIELD(Gender);
                        Employee.RESET;
                        Employee.SETRANGE("User ID", ApprovalEntry."Approver ID");
                        IF Employee.FINDFIRST THEN;
                        Employee.TESTFIELD("Company E-Mail");

                        Salutation := STRSUBSTNO(SalutationText, Employee.FullName);
                        ReceipientEmail := Employee."Company E-Mail";

                        MessageText := STRSUBSTNO(ApprovedMailMsg, DocumentNo);
                        FooterText := Regards;
                        FooterName := ApprovalEntry."Approver ID";
                        MailApplicable := TRUE;
                        NextApprovalEntries.RESET;
                        NextApprovalEntries.SETRANGE("Table ID", DATABASE::"Procurement Memo");
                        NextApprovalEntries.SETRANGE("Document No.", DocumentNo);
                        NextApprovalEntries.SETRANGE("Sequence No.", ApprovalEntry."Sequence No." + 1);
                        IF NextApprovalEntries.FINDFIRST THEN BEGIN
                            Employee.RESET;
                            Employee.SETRANGE("User ID", NextApprovalEntries."Approver ID");
                            IF Employee.FINDFIRST THEN BEGIN
                                ReceipientEmail := Employee."Company E-Mail";
                                Salutation := STRSUBSTNO(SalutationText, Employee."Full Name"); //new change
                            END;
                        END ELSE BEGIN
                            Employee.RESET;
                            Employee.SETRANGE("User ID", ApprovalEntry."Sender ID");
                            IF Employee.FINDFIRST THEN
                                ReceipientEmail := Employee."Company E-Mail";
                        END;
                    END;
                    //END;
                END;
            EventType::Rejected:
                BEGIN
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Table ID", DATABASE::"Procurement Memo");
                    ApprovalEntry.SETRANGE("Document No.", DocumentNo);
                    ApprovalEntry.SETRANGE("Approver ID", USERID);
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Rejected);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        Employee.RESET;
                        Employee.SETRANGE("User ID", ApprovalEntry."Sender ID");
                        IF NOT Employee.FINDFIRST THEN
                            ERROR(EmpNotFind, ApprovalEntry."Sender ID");
                        Employee.TESTFIELD(Gender);
                        Salutation := STRSUBSTNO(SalutationText, Employee.FullName);
                        ReceipientEmail := Employee."Company E-Mail";
                        MessageText := STRSUBSTNO(RejectedMailMsg, DocumentNo);
                        FooterText := Regards;
                        FooterName := ApprovalEntry."Approver ID";
                        MailApplicable := TRUE;
                    END;
                END;
        END;
        IF MailApplicable OR BothApplicable THEN BEGIN
            ProcurementHeader.GET(DocumentNo);
            ProcurementHeader.CALCFIELDS("Total Amount");
            SMTPMail.CreateMessage(ApprovalEntry."Sender ID", SMTPMailSetup."User ID", ReceipientEmail, STRSUBSTNO(MailSubject, COMPANYNAME), '', TRUE);
            SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
            SMTPMail.AppendBody(Salutation);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(STRSUBSTNO(MessageText, DocumentNo));
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody('Company Name:' + ' ' + FORMAT(COMPANYNAME));
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody('Background:' + ' ' + FORMAT(ProcurementHeader.Background + ProcurementHeader.Background1));
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody('Total Amount:' + ' ' + FORMAT(ProcurementHeader."Total Amount"));
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(Regards);
            SMTPMail.AppendBody('<br><br>');
            SMTPMail.AppendBody(FooterName);
            IF NextApprovalCC <> '' THEN
                SMTPMail.AddCC(NextApprovalCC);
            SMTPMail.Send;
        END;

    end;

    [Scope('Internal')]
    procedure ProcurementMemoApproval(ProcurementMemo: Record "130415")
    var
        Employee: Record "5200";
        PurchaseHeaderRec: Record "38";
        Amount: Decimal;
        ApprovalLines: Record "104199";
        "eason: The extension could not be deployed because it is already deployed as a global application or a per tenant application.": Integer;
        ApprovalCreated: Boolean;
        PurchaseLine: Record "39";
        ApprovalEntry: Record "454";
    begin
        ApprovalCreated := FALSE;
        Amount := 0;
        ApprovalLines.RESET;
        ApprovalLines.SETRANGE(Type, ApprovalLines.Type::Memo);
        ApprovalLines.SETRANGE("Memo No.", ProcurementMemo."Memo No.");
        IF ApprovalLines.FINDFIRST THEN
            REPEAT
                ApprovalEntry."Entry No." := 0;
                ApprovalEntry."Table ID" := DATABASE::"Procurement Memo";
                ApprovalEntry."Document No." := ProcurementMemo."Memo No.";
                ApprovalEntry."Sequence No." := ApprovalLines."Sequence No.";
                ApprovalEntry."Sender ID" := USERID;
                ApprovalEntry."Approver ID" := ApprovalLines."User ID";
                IF ApprovalEntry."Sequence No." = 1 THEN
                    ApprovalEntry.Status := ApprovalEntry.Status::Open
                ELSE
                    ApprovalEntry.Status := ApprovalEntry.Status::Created;
                ApprovalEntry."Date-Time Sent for Approval" := CREATEDATETIME(TODAY, TIME);
                ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
                ApprovalEntry."Last Modified By User ID" := USERID;
                ApprovalEntry."Record ID to Approve" := ProcurementMemo.RECORDID;
                ApprovalEntry."Custom Approval" := TRUE;
                ApprovalEntry.INSERT(TRUE);
                ApprovalCreated := TRUE;
            UNTIL ApprovalLines.NEXT = 0;
        IF NOT ApprovalCreated THEN
            ERROR('No workflow user group found.');
        SendApprovalWorkflowMailNotificationPM(1, ProcurementMemo."Memo No.");
    end;
}

