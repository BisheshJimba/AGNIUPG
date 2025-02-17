page 25006355 "Time Registration"
{
    // 20.07.2015 EB.P7 #Schedule3.0
    //   Hidden "Hold Hours" field.

    Caption = 'Time Registration';
    PageType = Card;
    SourceTable = Table156;

    layout
    {
        area(content)
        {
            field(SourceType; SourceType)
            {
                Caption = 'Source Type';
                Editable = false;
            }
            field(SourceSubType; SourceSubType)
            {
                Caption = 'Source Subtype';
                Editable = false;
            }
            field(SourceID; SourceID)
            {
                Caption = 'Source ID';
                Editable = false;
            }
            field(ResourceNo; ResourceNo)
            {
                Caption = 'Resource No.';
                Editable = ResourceEditable;
                LookupPageID = "Resource List";
                TableRelation = Resource.No.;

                trigger OnValidate()
                begin
                    IF GET(ResourceNo) THEN
                        SETRANGE("No.", ResourceNo);
                end;
            }
            field(Name; Name)
            {
                Editable = false;
            }
            field(DateTimeMgt.Datetime2Text(CurrDateTime);
                DateTimeMgt.Datetime2Text(CurrDateTime))
            {
                Caption = 'Date-Time';
            }
            field(SchedulePassword; SchedulePassword)
            {
                Caption = 'Password';
                ExtendedDatatype = Masked;
            }
            field(Status; Status)
            {
                Caption = 'Operation';
                Editable = true;
            }
            field(ReasonCode; ReasonCode)
            {
                Caption = 'Reason';
                TableRelation = "Serv. Break Reason";
            }
            field(HoldHours; HoldHours)
            {
                Caption = 'Hold Hours';
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            StartEndWork;
        END;
    end;

    var
        LaborAllocEntryTemp: Record "25006271" temporary;
        Resource: Record "156";
        ServSchedMgt: Codeunit "25006201";
        SingleInstanceMgt: Codeunit "25006001";
        DateTimeMgt: Codeunit "25006012";
        ResourceNo: Code[20];
        SourceID: Code[20];
        ReasonCode: Code[10];
        SchedulePassword: Text[20];
        SourceType: Option ,"Service Document","Standard Event";
        SourceSubType: Option Quote,"Order";
        Status: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        OriginalStatus: Option Pending,"In Process","Finish All","Finish Part","On Hold";
        FinishStatus: Option Finished,"On Hold";
        CurrDateTime: Decimal;
        QtyToAllocate: Decimal;
        HoldHours: Decimal;
        FinishText: Label 'Finish Allocation';
        StartText: Label 'Start Allocation';
        HoldText: Label 'Hold Allocation';
        Text107: Label 'Resource %1 have to start work time first.';
        Text113: Label 'You are not allow to work now.';
        Text135: Label 'Working on simultaneous tasks is not allowed.';
        ResourceEditable: Boolean;
        ServiceSetup: Record "25006120";

    [Scope('Internal')]
    procedure SetParam(ResourceNo1: Code[20]; StartingDateTime1: Decimal; QtyToAllocate1: Decimal; SourceType1: Option ,"Service Document","Standard Event"; SourceSubType1: Option Qoute,"Order"; SourceID1: Code[20]; Status1: Option Pending,"In Process","Finish All","Finish Part","On Hold"; HoldHours1: Decimal)
    var
        ServLaborAllocationEntry: Record "25006271";
    begin
        ResourceNo := ResourceNo1;
        SETRANGE("No.", ResourceNo);
        CurrDateTime := StartingDateTime1;
        QtyToAllocate := QtyToAllocate1;
        SourceType := SourceType1;
        SourceSubType := SourceSubType1;
        SourceID := SourceID1;
        Status := Status1;
        OriginalStatus := Status1;
        HoldHours := HoldHours1;

        IF Status = Status::"On Hold" THEN
            FinishStatus := FinishStatus::"On Hold";

        //28.02.2010 EBMSM01 P2 >>
        IF ServLaborAllocationEntry.GET(SingleInstanceMgt.GetAllocationEntryNo) THEN
            ReasonCode := ServLaborAllocationEntry."Reason Code";
        //28.02.2010 EBMSM01 P2 <<


        IF Status = Status::"Finish All" THEN
            ResourceEditable := FALSE
        ELSE
            ResourceEditable := TRUE;
    end;

    [Scope('Internal')]
    procedure StartEndWork()
    var
        WorkTimeEntry: Record "25006276";
        LaborAllocEntryLoc: Record "25006271";
    begin
        ServiceSetup.GET;
        ServSchedMgt.CompareSchedulePassword(ResourceNo, SchedulePassword);
        //20.11.2013 EDMS P8 >>
        IF Status = Status::"In Process" THEN BEGIN
            WorkTimeEntry.RESET;
            WorkTimeEntry.SETCURRENTKEY("Resource No.", Closed);
            WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
            WorkTimeEntry.SETRANGE(Closed, FALSE);
            IF NOT WorkTimeEntry.FINDLAST THEN
                ERROR(STRSUBSTNO(Text107, ResourceNo));

            Resource.GET(ResourceNo);
            IF NOT Resource."Allow Simultaneous Work" THEN BEGIN
                LaborAllocEntryLoc.RESET;
                LaborAllocEntryLoc.SETCURRENTKEY("Source Type", Status, "Resource No.");
                LaborAllocEntryLoc.SETRANGE(Status, LaborAllocEntryLoc.Status::"In Progress");
                LaborAllocEntryLoc.SETRANGE("Resource No.", ResourceNo);
                IF ServiceSetup."Default Idle Event" <> '' THEN
                    LaborAllocEntryLoc.SETFILTER("Source ID", '<>%1', ServiceSetup."Default Idle Event");

                IF LaborAllocEntryLoc.FINDFIRST THEN
                    ERROR(Text135);
            END;

            /*
            //CurrDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);
            IF ServSchedMgt.IsTimeAvailable(LaborAllocEntryTemp, ResourceNo, DateTimeMgt.Datetime2Date(CurrDateTime), 0) THEN BEGIN
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

            */

        END;

        CASE Status OF
            Status::"In Process":
                ServSchedMgt.ProcessStartLabor(CurrDateTime);
            Status::"Finish All":
                ServSchedMgt.ProcessFinishLabor(CurrDateTime, Status, HoldHours, ReasonCode);
            Status::"Finish Part":
                ServSchedMgt.ProcessFinishLabor(CurrDateTime, Status, HoldHours, ReasonCode);
            Status::"On Hold":
                ServSchedMgt.ProcessHoldLabor(CurrDateTime);
        END;

        //Rise event to catch alloc start finish
        OnAllocationChangeStatus(Status, SingleInstanceMgt.GetAllocationEntryNo);

    end;

    [Scope('Internal')]
    procedure SetHeader(): Text[30]
    begin
        CASE Status OF
            Status::"Finish All":
                EXIT(FinishText);
            Status::"Finish Part":
                EXIT(FinishText);
            Status::"In Process":
                EXIT(StartText);
            Status::"On Hold":
                EXIT(HoldText);
        END;
    end;

    [BusinessEvent(false)]
    [Scope('Internal')]
    procedure OnAllocationChangeStatus(Status: Option Pending,"In Process","Finish All","Finish Part","On Hold"; AllocEntryNo: Integer)
    begin
    end;
}

