codeunit 25006017 "Easy Clocking Management"
{
    // 07.06.2016 EB.RC POD.Base P439.CU7bug
    //   Bugfix.


    trigger OnRun()
    begin
    end;

    var
        ObjectTypeErr: Label 'Object Type not supported';
        UnknownActionErr: Label 'Unknown Action Id';
        CustomCurrentDate: Date;
        CustomCurrentTime: Time;
        Text000: Label 'Start Travel on:';
        Text001: Label 'My Task,Group Task,Order Document,Order Line';

    [Scope('Internal')]
    procedure FillAddInData(var AddInDataToFill: BigText)
    var
        OutStreamData: OutStream;
        InStreamData: InStream;
        ExportXmlPort: XMLport "25006201";
        TempBlob: Record "99008535" temporary;
        StreamReader: DotNet StreamReader;
    begin
        CLEAR(AddInDataToFill);
        TempBlob.INIT;
        TempBlob.INSERT;
        TempBlob.Blob.CREATEOUTSTREAM(OutStreamData);
        ExportXmlPort.SetCustomCurrentDateTime(CustomCurrentDate, CustomCurrentTime);
        ExportXmlPort.SETDESTINATION(OutStreamData);
        IF ExportXmlPort.EXPORT THEN BEGIN
            TempBlob.CALCFIELDS(Blob);
            TempBlob.Blob.CREATEINSTREAM(InStreamData);
            StreamReader := StreamReader.StreamReader(InStreamData, TRUE);
            AddInDataToFill.ADDTEXT(StreamReader.ReadToEnd());
        END;
    end;

    [Scope('Internal')]
    procedure ProcessNavigationControl(ControlNo: Integer; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ServiceNavigationControl: Record "25006062";
        ResourceTimeRegMgt: Codeunit "25006290";
    begin
        IF ServiceNavigationControl.GET(ControlNo) THEN BEGIN
            IF ServiceNavigationControl."Run Action" <> ServiceNavigationControl."Run Action"::" " THEN BEGIN
                ProcessNavigationAction(ServiceNavigationControl, ResourceNo, OnDate, OnTime);
            END;
            IF ServiceNavigationControl."Run Object ID" <> 0 THEN BEGIN
                CASE ServiceNavigationControl."Run Object Type" OF
                    ServiceNavigationControl."Run Object Type"::Codeunit:
                        BEGIN
                            CODEUNIT.RUN(ServiceNavigationControl."Run Object ID");
                        END;
                    ServiceNavigationControl."Run Object Type"::Page:
                        BEGIN
                            PAGE.RUN(ServiceNavigationControl."Run Object ID");
                        END;
                    ServiceNavigationControl."Run Object Type"::Report:
                        BEGIN
                            REPORT.RUN(ServiceNavigationControl."Run Object ID");
                        END;
                    ServiceNavigationControl."Run Object Type"::XMLPort:
                        BEGIN
                            XMLPORT.RUN(ServiceNavigationControl."Run Object ID");
                        END;
                    ELSE
                        MESSAGE(ObjectTypeErr);
                END;
            END;
        END;
    end;

    local procedure ProcessNavigationAction(EasyTimeMenuItem: Record "25006062"; ResourceNo: Code[20]; OnDate: Date; OnTime: Time)
    var
        ResourceTimeRegMgt: Codeunit "25006290";
        ServLaborAllocationEntry: Record "25006271";
        ServiceHeaderEDMS: Record "25006145";
        ServiceLineEDMS: Record "25006146";
        ServScheduleMgt: Codeunit "25006201";
        StartDateTime: Decimal;
        DivideIntoLines: Boolean;
        SourceType: Option ,"Service Document","Standard Event";
        SourceSubType: Option Qoute,"Order";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        DateTimeMgt: Codeunit "25006012";
        ServiceLine: Record "25006146" temporary;
        ForceStatus: Option Pending,"In Progress",Finished,"On Hold",Cancelled;
        SourceID: Code[20];
        AllocatedEntryNo: Integer;
        MeetingDescription: Text;
        EasyTimeMeetingDialog: Page "25006099";
        EasyTimeCustomDateTimeDialog: Page "25006208";
        EasyTimeWkshPersTasks: Page "25006169";
        EasyTimeWkshPoolTasks: Page "25006170";
        SelectedTravelSource: Integer;
    begin
        CASE EasyTimeMenuItem."Run Action" OF
            EasyTimeMenuItem."Run Action"::"Start Worktime":
                BEGIN
                    ResourceTimeRegMgt.StartWorktime(ResourceNo, OnDate, OnTime);
                END;
            EasyTimeMenuItem."Run Action"::"End Worktime":
                BEGIN
                    ResourceTimeRegMgt.EndWorktime(ResourceNo, OnDate, OnTime);
                END;
            EasyTimeMenuItem."Run Action"::"Start My Task":
                BEGIN
                    IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Pers. Tasks", ServLaborAllocationEntry) = ACTION::LookupOK THEN BEGIN
                        ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocationEntry, ResourceNo);
                        //ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                    END;

                END;
            EasyTimeMenuItem."Run Action"::"Start Group Task":
                BEGIN
                    IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Pool Tasks", ServLaborAllocationEntry) = ACTION::LookupOK THEN BEGIN
                        ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocationEntry, ResourceNo);
                        //ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                    END;
                END;
            EasyTimeMenuItem."Run Action"::"Start Standard Task":
                BEGIN
                    ResourceTimeRegMgt.StartNewTaskFromStandard(ResourceNo, OnDate, OnTime);
                END;
            EasyTimeMenuItem."Run Action"::"Start Break":
                BEGIN
                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                    //ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo;
                    StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
                    DivideIntoLines := FALSE;
                    SourceType := ServLaborAllocationEntry."Source Type"::"Standard Event";
                    Mode := Mode::"New Allocation";
                    SourceID := 'BREAK';
                    ServScheduleMgt.ProcessAllocation(ResourceNo, StartDateTime, 1, SourceType, SourceSubType, SourceID, ServiceLine,
                      DivideIntoLines, ForceStatus::"In Progress", FALSE);
                    AllocatedEntryNo := ServScheduleMgt.FindFirstAppliedEntryNo;
                    IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN BEGIN
                        ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                    END;
                END;
            EasyTimeMenuItem."Run Action"::"Start Meeting":
                BEGIN
                    MeetingDescription := '';
                    EasyTimeMeetingDialog.RUNMODAL;
                    MeetingDescription := EasyTimeMeetingDialog.GetMeetingDescription;
                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                    //ResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo;
                    StartDateTime := DateTimeMgt.Datetime(OnDate, OnTime);
                    DivideIntoLines := FALSE;
                    SourceType := ServLaborAllocationEntry."Source Type"::"Standard Event";
                    Mode := Mode::"New Allocation";
                    SourceID := 'MEETING';
                    ServScheduleMgt.ProcessAllocation(ResourceNo, StartDateTime, 1, SourceType, SourceSubType, SourceID, ServiceLine,
                      DivideIntoLines, ForceStatus::"In Progress", FALSE);
                    AllocatedEntryNo := ServScheduleMgt.FindFirstAppliedEntryNo;
                    IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN BEGIN
                        ServScheduleMgt.UpdateAllocDetailsText(AllocatedEntryNo, MeetingDescription, ServLaborAllocationEntry."Detail Entry No.");
                        ResourceTimeRegMgt.FinishDefaultIdleTask(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                    END;
                END;
            EasyTimeMenuItem."Run Action"::"Start Task From Order":
                BEGIN
                    IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Doc. Tasks", ServiceHeaderEDMS) = ACTION::LookupOK THEN BEGIN
                        ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                        ResourceTimeRegMgt.StartNewTaskFromHeader(ServiceHeaderEDMS, ResourceNo, OnDate, OnTime, FALSE);
                    END;
                END;
            EasyTimeMenuItem."Run Action"::"Start Task From Line":
                BEGIN
                    IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Doc. Tasks", ServiceHeaderEDMS) = ACTION::LookupOK THEN BEGIN
                        ServiceLineEDMS.SETRANGE("Document No.", ServiceHeaderEDMS."No.");
                        ServiceLineEDMS.SETRANGE("Document Type", ServiceHeaderEDMS."Document Type");
                        IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Line Tasks", ServiceLineEDMS) = ACTION::LookupOK THEN BEGIN
                            ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                            ResourceTimeRegMgt.StartNewTaskFromLine(ServiceLineEDMS, ResourceNo, OnDate, OnTime, FALSE);
                        END;
                    END;
                END;
            EasyTimeMenuItem."Run Action"::"Set Current Time":
                BEGIN
                    EasyTimeCustomDateTimeDialog.SetCustomDateTime(CustomCurrentDate, CustomCurrentTime);
                    IF EasyTimeCustomDateTimeDialog.RUNMODAL = ACTION::OK THEN BEGIN
                        EasyTimeCustomDateTimeDialog.GetCustomDateTime(CustomCurrentDate, CustomCurrentTime);
                    END;
                END;
            EasyTimeMenuItem."Run Action"::"Start Travel Task":
                BEGIN
                    SelectedTravelSource := DIALOG.STRMENU(Text001, 0, Text000);
                    CASE SelectedTravelSource OF
                        1:
                            BEGIN
                                IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Pers. Tasks", ServLaborAllocationEntry) = ACTION::LookupOK THEN BEGIN
                                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                                    //ResourceTimeRegMgt.ValidateTimeRegAction('Start',ServLaborAllocationEntry,ResourceNo);
                                    //ResourceTimeRegMgt.AddTimeRegEntries('Start',ServLaborAllocationEntry,ResourceNo,OnDate,OnTime);
                                    ResourceTimeRegMgt.StartNewTravelTaskFromAllocation(ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                                END;
                            END;
                        2:
                            BEGIN
                                IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Pool Tasks", ServLaborAllocationEntry) = ACTION::LookupOK THEN BEGIN
                                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                                    //ResourceTimeRegMgt.ValidateTimeRegAction('Start',ServLaborAllocationEntry,ResourceNo);
                                    //ResourceTimeRegMgt.AddTimeRegEntries('Start',ServLaborAllocationEntry,ResourceNo,OnDate,OnTime);
                                    ResourceTimeRegMgt.StartNewTravelTaskFromAllocation(ServLaborAllocationEntry, ResourceNo, OnDate, OnTime);
                                END;
                            END;
                        3:
                            BEGIN
                                IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Doc. Tasks", ServiceHeaderEDMS) = ACTION::LookupOK THEN BEGIN
                                    ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                                    ResourceTimeRegMgt.StartNewTaskFromHeader(ServiceHeaderEDMS, ResourceNo, OnDate, OnTime, TRUE);
                                END;
                            END;
                        4:
                            BEGIN
                                IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Doc. Tasks", ServiceHeaderEDMS) = ACTION::LookupOK THEN BEGIN
                                    ServiceLineEDMS.SETRANGE("Document No.", ServiceHeaderEDMS."No.");
                                    ServiceLineEDMS.SETRANGE("Document Type", ServiceHeaderEDMS."Document Type");
                                    IF PAGE.RUNMODAL(PAGE::"Easy Time Wksh. Line Tasks", ServiceLineEDMS) = ACTION::LookupOK THEN BEGIN
                                        ResourceTimeRegMgt.StartWorktimeSilent(ResourceNo, OnDate, OnTime);
                                        ResourceTimeRegMgt.StartNewTaskFromLine(ServiceLineEDMS, ResourceNo, OnDate, OnTime, TRUE);
                                    END;
                                END;
                            END;
                    END;
                END;
            ELSE
                MESSAGE(UnknownActionErr);
        END;
    end;

    [Scope('Internal')]
    procedure ProcessLookupAction(var ServLaborAllocEntry: Record "25006271")
    var
        ServiceOrder: Page "25006183";
        ServiceHeader: Record "25006145";
        Allocation: Page "25006369";
        ServScheduleMgt: Codeunit "25006201";
    begin
        IF ServLaborAllocEntry."Source Type" = ServLaborAllocEntry."Source Type"::"Service Document" THEN BEGIN
            ServiceHeader.SETRANGE("Document Type", ServLaborAllocEntry."Source Subtype");
            ServiceHeader.SETRANGE("No.", ServLaborAllocEntry."Source ID");
            ServiceOrder.SETTABLEVIEW(ServiceHeader);
            ServiceOrder.RUN;
        END ELSE BEGIN
            ServScheduleMgt.MoveAllocation(ServLaborAllocEntry."Entry No.", ServLaborAllocEntry."Resource No.", ServLaborAllocEntry."Start Date-Time");
        END;
    end;

    [Scope('Internal')]
    procedure GetCustomCurrDateTime(var CurrDate: Date; var CurrTime: Time)
    begin
        CurrDate := CustomCurrentDate;
        CurrTime := CustomCurrentTime;
    end;
}

