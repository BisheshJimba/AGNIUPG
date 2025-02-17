page 25006369 Allocation
{
    // 22.04.2014 Elva Baltic P1 #RX MMG7.00
    //  * Field "SourceID" set EDITABLE=FALSE
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added Code to
    //     SourceID - OnValidate()
    //     SetParam()
    //   Added field "CrUserID"
    // 
    // 28.03.2014 Elva Baltic P18 MMG7.00
    //   Fixed error for field "Description"
    // 
    // 26.03.2014 Elva Baltic P18 #RX026
    //   Added Code to
    //     Trigger : OnQueryClosePage()
    //     Procedure : SetParam()
    // 
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //   * Added LVI captions
    // 
    // 17.03.2014 Elva Baltic P8 #E0003 MMG7.00
    //   * Fix of standard text use
    // 
    // // it supposed to be used/runed by use temp record ONLY !!!
    // 06.12.2013 EDMS P8
    //   * SMALL fix due to multi-language
    // 
    // 24.01.2012 EDMS P8
    //   * unvisible SplitTracking

    Caption = 'Allocation';
    DeleteAllowed = false;
    SourceTable = Table25006277;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Source)
            {
                Caption = 'Source';
                field(LaborAllocEntryTmp."Source Type";
                    LaborAllocEntryTmp."Source Type")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        SourceType := LaborAllocEntryTmp."Source Type";
                        RefreshVisibles;
                        CurrPage.UPDATE;
                    end;
                }
                field(LaborAllocEntryTmp."Source Subtype";
                    LaborAllocEntryTmp."Source Subtype")
                {
                    Visible = SourceSubTypeVisible;

                    trigger OnValidate()
                    begin
                        SourceSubType := LaborAllocEntryTmp."Source Subtype";  //06.12.2013 EDMS P8
                    end;
                }
                field(SourceID; SourceID)
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
                        IF SourceID <> '' THEN
                            IF LaborAllocEntryTmp."Source Type" = LaborAllocEntryTmp."Source Type"::"Standard Event" THEN
                                IF NOT StandardEvent.GET(SourceID) THEN
                                    ERROR(ERR001);
                        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
                    end;
                }
            }
            group(Allocation)
            {
                Caption = 'Allocation';
                Visible = isAllocationShown;
                field(StartDate; StartDate)
                {
                    Caption = 'Start Date';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
                        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, CurrQtyToAllocate);
                        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
                        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);
                    end;
                }
                field(StartTime; StartTime)
                {
                    Caption = 'Start Time';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
                        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, CurrQtyToAllocate);
                        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
                        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);
                    end;
                }
                field(EndDate; EndDate)
                {
                    Caption = 'End Date';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        EndDateTime := DateTimeMgt.Datetime(EndDate, EndTime);
                        CurrQtyToAllocate := ServScheduleMgt.CalcWorkHourDifference(ResourceNo, StartDateTime, EndDateTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
                    end;
                }
                field(EndTime; EndTime)
                {
                    Caption = 'End Time';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        EndDateTime := DateTimeMgt.Datetime(EndDate, EndTime);
                        CurrQtyToAllocate := ServScheduleMgt.CalcWorkHourDifference(ResourceNo, StartDateTime, EndDateTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
                    end;
                }
                field(DurationGlob; DurationGlob)
                {
                    Caption = 'Duration';

                    trigger OnValidate()
                    begin
                        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
                        CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
                        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, CurrQtyToAllocate);
                        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
                        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);
                    end;
                }
                field(DetailsText; DetailsText)
                {
                    Caption = 'Description';
                }
                field(CreatedByUserID; CrUserID)
                {
                    Caption = 'User ID';
                    Editable = false;
                }
            }
            group(Resource)
            {
                Caption = 'Resource';
                Editable = isResourceEditable;
                Visible = NOT isResourcesShown;
                field(ResourceNo; ResourceNo)
                {
                    Caption = 'Resource No.';
                    TableRelation = Resource.No.;
                }
            }
            group(Resources)
            {
                Caption = 'Resources';
                Editable = isResourceEditable;
                Visible = isResourcesShown;
                repeater()
                {
                    field("Resource No."; "Resource No.")
                    {
                    }
                }
            }
            group(Options)
            {
                Caption = 'Options';
                Visible = isOptionsShown;
                field(SplitTracking; SplitTracking)
                {
                    Caption = 'Handle Linked Entries';
                    Visible = false;
                }
                field(DivideIntoLines; DivideIntoLines)
                {
                    Caption = 'Divide into Serv. Lines';
                }
            }
            group("Break Options")
            {
                Caption = 'Break Options';
                Visible = isBreakShown;
                field(DateTimeMgt.Datetime2Text(StartDateTime);
                    DateTimeMgt.Datetime2Text(StartDateTime))
                {
                    Caption = 'Date Time';
                    Editable = false;
                }
                field(SchedulePassword; SchedulePassword)
                {
                    Caption = 'Password';
                    ExtendedDatatype = Masked;
                }
                field(ReasonCode; ReasonCode)
                {
                    Caption = 'Reason';
                    TableRelation = "Serv. Break Reason";
                }
                field(StandardCode; StandardCode)
                {
                    Caption = 'Standard Code';
                    TableRelation = "Serv. Standard Event";
                }
                field("<Control1101914027>"; DurationGlob)
                {
                    Caption = 'Duration';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1101904013>")
            {
                Caption = 'F&unctions';
                action("<Action1101904014>")
                {
                    Caption = 'Add Resource';
                    Enabled = NOT isResourcesShown;
                    Image = Resource;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //AddResources(ResourceNo);  // P8
                        isResourcesShown := TRUE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DetailsTextChanged := FALSE;
        DetEntryNo := LaborAllocEntry."Detail Entry No.";  //17.03.2014 Elva Baltic P8 #E0003 MMG7.00
        //DetEntryNo := 0;
        IF LaborAllocEntry.GET(EntryNo) THEN
            IF ServLaborAllocationDetail.GET(LaborAllocEntry."Detail Entry No.") THEN BEGIN
                DetEntryNo := LaborAllocEntry."Detail Entry No.";  //17.03.2014 Elva Baltic P8 #E0003 MMG7.00
                DetailsText := ServLaborAllocationDetail.Description;
            END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Allocation Entry No." := GetNextNewAllocEntryNo;
        "Document Type" := SourceSubType;
        "Document No." := SourceID;
        "Document Line No." := LineNo;
        DetailsTextChanged := FALSE;
        DetEntryNo := 0;
    end;

    trigger OnOpenPage()
    var
        ServScheduleMgt: Codeunit "25006201";
    begin
        ServScheduleSetup.GET;

        CurrQtyToAllocate := QtyToAllocate;
        DivideIntoLines := FALSE;

        StandardCode := ServScheduleSetup."Break Standard Code";
        ReasonCode := ServScheduleSetup."Break Reason Code";

        CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);

        StartDate := DateTimeMgt.Datetime2Date(StartDateTime);
        StartTime := DateTimeMgt.Datetime2Time(StartDateTime);

        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, CurrQtyToAllocate);
        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);
        ServScheduleMgt.FillRelatedApplicOfEntry(Rec, EntryNo, LineNo, SourceSubType, SourceID, ResourceNo, GetNextNewAllocEntryNo);
        RefreshVisibles;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            Allocate;
        END;
    end;

    var
        ServLaborAllocationDetail: Record "25006268";
        SourceID: Code[20];
        SourceType: Option ,"Service Document","Standard Event";
        SourceSubType: Option Quote,"Order";
        ResourceNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        StartTime: Time;
        EndTime: Time;
        StartDateTime: Decimal;
        EndDateTime: Decimal;
        DurationGlob: Duration;
        QtyToAllocate: Decimal;
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        ServiceLine: Record "25006146" temporary;
        DateTimeMgt: Codeunit "25006012";
        CurrQtyToAllocate: Decimal;
        Text001: Label 'Duration cannot be negative';
        DivideIntoLines: Boolean;
        ServScheduleSetup: Record "25006286";
        ServScheduleMgt: Codeunit "25006201";
        SplitTracking: Boolean;
        EntryNo: Integer;
        LaborAllocEntry: Record "25006271";
        LaborAllocEntryTmp: Record "25006271" temporary;
        LaborAllocApplication: Record "25006277";
        ResourceTmp: Record "156" temporary;
        [InDataSet]
        isResourcesShown: Boolean;
        [InDataSet]
        isOptionsShown: Boolean;
        [InDataSet]
        isBreakShown: Boolean;
        [InDataSet]
        isAllocationShown: Boolean;
        [InDataSet]
        isResourceEditable: Boolean;
        LineNo: Integer;
        NewEntryNoTmp: Integer;
        SchedulePassword: Text[20];
        ReasonCode: Code[10];
        StandardCode: Code[20];
        SourceSubTypeVisible: Boolean;
        DetailsText: Text[250];
        DetailsTextNew: Text[250];
        DetailsTextChanged: Boolean;
        DetEntryNo: Integer;
        IsNewAllocation: Boolean;
        ServHeadEDMS: Record "25006145";
        StandardEvent: Record "25006272";
        ERR001: Label 'Standard Event Code Not Found';
        CrUserID: Code[50];
        ForceStatus: Option Pending,"In Progress",Finished,"On Hold",Cancelled;
        Travel: Boolean;

    [Scope('Internal')]
    procedure SetParam(EntryNo1: Integer; ResourceNo1: Code[20]; StartingDateTime1: Decimal; QtyToAllocate1: Decimal; SourceType1: Option ,"Service Document","Standard Event"; SourceSubType1: Option Qoute,"Order"; SourceID1: Code[20]; Mode1: Option "New Allocation","Move Existing","Split Existing","Break"; var ServiceLine1: Record "25006146"; ForceStatus1: Option Pending,"In Progress",Finished,"On Hold",Cancelled)
    var
        ServiceLineLoc: Record "25006146";
        IsServiceHeader: Boolean;
    begin
        EntryNo := EntryNo1;
        ResourceNo := ResourceNo1;
        StartDateTime := StartingDateTime1;
        QtyToAllocate := QtyToAllocate1;
        SourceType := SourceType1;
        SourceSubType := SourceSubType1;
        SourceID := SourceID1;
        Mode := Mode1;
        LineNo := 0;
        NewEntryNoTmp := 0;
        LaborAllocEntryTmp."Source Type" := SourceType;
        LaborAllocEntryTmp."Source Subtype" := SourceSubType;
        ForceStatus := ForceStatus1;

        // 26.03.2014 Elva Baltic P18 #RX026 >>
        IsNewAllocation := FALSE;
        IF (Mode = Mode::"New Allocation") AND (SourceSubType = SourceSubType::Order) AND (SourceID <> '') THEN
            IsNewAllocation := TRUE;
        // 26.03.2014 Elva Baltic P18 #RX026 <<

        ServScheduleMgt.AllocationSetParam(SourceType, QtyToAllocate, ServiceLine1, ServiceLine, LineNo, Mode, SourceSubType, SourceID);
        IF LaborAllocEntry.GET(EntryNo) THEN BEGIN
            IF ServLaborAllocationDetail.GET(LaborAllocEntry."Detail Entry No.") THEN
                DetailsText := ServLaborAllocationDetail.Description;
            // 31.03.2014 Elva Baltic P18 MMG7.00 >>
            CrUserID := LaborAllocEntry."User ID";
        END ELSE
            CrUserID := USERID;
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
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
    procedure Allocate(): Integer
    var
        ServScheduleMgt: Codeunit "25006201";
        SplitTracking1: Integer;
        CurrEntryNo: Integer;
    begin
        StartDateTime := DateTimeMgt.Datetime(StartDate, StartTime);
        CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
        IF CurrQtyToAllocate < 0 THEN
            ERROR(Text001);
        CLEAR(ServScheduleMgt);
        IF Rec.COUNT > 1 THEN BEGIN
            FillResourcesTmpFromApplic(Rec, ResourceTmp);
        END;
        CASE Mode OF
            Mode::"New Allocation":
                BEGIN
                    IF ResourceTmp.FINDFIRST THEN BEGIN
                        ServScheduleMgt.ProcessAllocationResources(ResourceTmp, StartDateTime, CurrQtyToAllocate, SourceType, SourceSubType,
                            SourceID, ServiceLine, DivideIntoLines, ForceStatus, Travel);
                    END ELSE BEGIN
                        ServScheduleMgt.ProcessAllocation(ResourceNo, StartDateTime, CurrQtyToAllocate, SourceType, SourceSubType, SourceID, ServiceLine,
                            DivideIntoLines, ForceStatus, Travel);
                    END;
                    // find parent
                    CurrEntryNo := ServScheduleMgt.FindFirstAppliedEntryNo;  //17.03.2014 Elva Baltic P8 #E0003 MMG7.00
                    ServScheduleMgt.UpdateAllocDetailsText(CurrEntryNo, DetailsText, DetEntryNo);  //24.10.2013 EDMS P8
                    IF ForceStatus = ForceStatus::"In Progress" THEN
                        ServScheduleMgt.FinishOtherTasks(ResourceNo, CurrEntryNo, StartDateTime);
                END;
            Mode::"Move Existing":
                BEGIN
                    SplitTracking1 := 0;
                    IF SplitTracking THEN
                        SplitTracking1 := 1;
                    IF ResourceTmp.FINDFIRST THEN BEGIN
                        ServScheduleMgt.ProcessMovementApp(Rec, EntryNo,
                                                   ResourceNo, StartDateTime, CurrQtyToAllocate, SplitTracking1);
                    END ELSE BEGIN
                        IF LaborAllocEntry.GET(EntryNo) THEN;

                        ServScheduleMgt.ProcessMovement(EntryNo,
                                                   ResourceNo, StartDateTime, CurrQtyToAllocate, SplitTracking1, LaborAllocEntry.Status, 300, LaborAllocEntry.Travel);
                    END;
                    ServScheduleMgt.UpdateAllocDetailsText(EntryNo, DetailsText, DetEntryNo);  //24.10.2013 EDMS P8
                END;
            Mode::"Break":
                BEGIN
                    ServScheduleMgt.CompareSchedulePassword(ResourceNo, SchedulePassword);
                    ServScheduleMgt.ProcessBreak(StandardCode, ReasonCode, CurrQtyToAllocate);
                END;
        //Mode::"Split Existing":
        // ServSchedMgt.ProcessSpliting(ResourceNo,StartingDateTime, CurrQtyToAllocate, SplitTracking);
        END;
        EXIT(CurrEntryNo);
    end;

    [Scope('Internal')]
    procedure AddResourceToAllocEntry(ServLaborAllocationEntry: Record "25006271")
    var
        TextNoGenRec: Label 'There should be allocation already defined before, so to add to existing entry.';
        Resource: Record "156";
    begin
        IF NOT ServLaborAllocationEntry.FINDSET THEN
            ERROR(TextNoGenRec);

        Resource.GET(ServLaborAllocationEntry."Resource No.");
        IF PAGE.RUNMODAL(PAGE::"Resource List", Resource) = ACTION::LookupOK THEN;
    end;

    [Scope('Internal')]
    procedure AddResources(ResourceNo1: Code[20])
    var
        Resource: Record "156";
        ResourceList: Page "77";
    begin
        Resource.GET(ResourceNo1);
        ResourceTmp.RESET;
        ResourceTmp.DELETEALL;
        ResourceTmp := Resource;
        ResourceTmp.INSERT;
        ResourceList.SETTABLEVIEW(Resource);
        ResourceList.SETRECORD(Resource);
        ResourceList.LOOKUPMODE(TRUE);
        IF ResourceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ResourceList.SetSelectionFilter1(Resource);
            IF Resource.FINDFIRST THEN BEGIN
                //    ResourceTmp.DELETEALL;
                REPEAT
                    IF NOT ResourceTmp.GET(Resource."No.") THEN BEGIN
                        ResourceTmp := Resource;
                        ResourceTmp.INSERT;
                    END;
                UNTIL Resource.NEXT = 0;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure FillResourcesTmpFromApplic(var ServAllocApplic: Record "25006277"; var ResourceTmpPar: Record "156" temporary)
    var
        Resource: Record "156";
    begin
        ServAllocApplic.FINDFIRST;
        ResourceTmpPar.RESET;
        ResourceTmpPar.DELETEALL;
        REPEAT
            IF Resource.GET(ServAllocApplic."Resource No.") THEN BEGIN
                IF NOT ResourceTmpPar.GET(Resource."No.") THEN BEGIN
                    ResourceTmpPar := Resource;
                    ResourceTmpPar.INSERT;
                END;
            END;
        UNTIL ServAllocApplic.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetNextNewAllocEntryNo(): Integer
    var
        ServLaborAllocationEntryL: Record "25006271";
    begin
        IF NewEntryNoTmp = 0 THEN BEGIN
            IF ServLaborAllocationEntryL.FINDLAST THEN
                NewEntryNoTmp := ServLaborAllocationEntryL."Entry No.";
        END;
        NewEntryNoTmp += 1;
        EXIT(NewEntryNoTmp);
    end;

    [Scope('Internal')]
    procedure RefreshVisibles()
    begin
        SourceSubTypeVisible := (SourceType = SourceType::"Service Document");
        isResourcesShown := (Rec.COUNT > 1);
        IF Mode = Mode::"Break" THEN BEGIN
            isOptionsShown := FALSE;
            isBreakShown := TRUE;
            isAllocationShown := FALSE;
            isResourceEditable := FALSE;
        END ELSE BEGIN
            isOptionsShown := TRUE;
            isBreakShown := FALSE;
            isAllocationShown := TRUE;
            isResourceEditable := TRUE;
        END;
    end;

    [Scope('Internal')]
    procedure SetInvisibles(ForceQtyToAllocate: Decimal)
    var
        SingleInstanceManagment: Codeunit "25006001";
        AskForTimeQty: Page "25006296";
    begin
        IF (ForceQtyToAllocate <> 0) THEN
            QtyToAllocate := ForceQtyToAllocate;

        StartDate := DateTimeMgt.Datetime2Date(StartDateTime);
        StartTime := DateTimeMgt.Datetime2Time(StartDateTime);

        //CalculateDuration(DurationGlob, CurrQtyToAllocate, 1);
        EndDateTime := ServScheduleMgt.CalculateNewStartDateTime(ResourceNo, StartDateTime, QtyToAllocate);
        EndDate := DateTimeMgt.Datetime2Date(EndDateTime);
        EndTime := DateTimeMgt.Datetime2Time(EndDateTime);

        IF QtyToAllocate = 0 THEN BEGIN
            IF AskForTimeQty.RUNMODAL = ACTION::OK THEN BEGIN
                QtyToAllocate := AskForTimeQty.GetTimeQty;
                CurrQtyToAllocate := QtyToAllocate;
                CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
            END;
        END ELSE BEGIN
            CurrQtyToAllocate := QtyToAllocate;
            CalculateDuration(DurationGlob, CurrQtyToAllocate, 0);
        END;

        CrUserID := SingleInstanceManagment.GetCurrentUserId;
    end;

    [Scope('Internal')]
    procedure SetDescription(DescriptionToSet: Text)
    begin
        DetailsText := DescriptionToSet;
    end;

    [Scope('Internal')]
    procedure SetIsTravel(IsTravel: Boolean)
    begin
        Travel := IsTravel;
    end;
}

