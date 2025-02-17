page 25006097 "Easy Clocking"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = Table25006177;

    layout
    {
        area(content)
        {
            group()
            {
                usercontrol(Navigation; "EB.Navigation.Web")
                {

                    trigger ControlAddInReady()
                    var
                        AddInData: BigText;
                    begin
                        ServiceNavigationMgt.FillAddInData(AddInData);
                        CurrPage.Navigation.RecieveInitNavigationData(AddInData);
                    end;
                }
            }
        }
    }

    actions
    {
        action("test 1")
        {
            InFooterBar = true;

            trigger OnAction()
            begin
                MESSAGE('action 1');
            end;
        }
        action("test 2")
        {

            trigger OnAction()
            begin
                MESSAGE('action 2');
            end;
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        AddInData: BigText;
    begin
        ServiceNavigationMgt.FillAddInData(AddInData);
        CurrPage.Navigation.RecieveInitNavigationData(AddInData);
    end;

    trigger OnInit()
    begin
        SingleInstanceManagement.SetCurrentPeriod(1); //Period Day
        SingleInstanceManagement.SetCurrentDate(WORKDATE);
        CurrentDate := WORKDATE;
        CurrentTime := TIME;
    end;

    var
        ServiceNavigationMgt: Codeunit "25006017";
        CurrentResourceNo: Code[20];
        ResourceTimeRegMgt: Codeunit "25006290";
        SingleInstanceManagement: Codeunit "25006001";
        CurrentDate: Date;
        CurrentTime: Time;

    [Scope('Internal')]
    procedure "Navigation::RequestNavigationData"()
    var
        AddInData: BigText;
    begin
        ServiceNavigationMgt.FillAddInData(AddInData);
        CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
    end;

    [Scope('Internal')]
    procedure "Navigation::ProcessControlCommand"(ControlNo: Integer)
    var
        AddInData: BigText;
        CustomCurrDate: Date;
        CustomCurrTime: Time;
    begin
        ManageCurrentTime(CurrentDate, CurrentTime);
        ServiceNavigationMgt.ProcessNavigationControl(ControlNo, ResourceTimeRegMgt.GetCurrentUserResourceNo, CurrentDate, CurrentTime);
        ServiceNavigationMgt.GetCustomCurrDateTime(CustomCurrDate, CustomCurrTime);
        ManageCurrentTime(CurrentDate, CurrentTime);
        SingleInstanceManagement.SetCurrentDate(CurrentDate);

        ServiceNavigationMgt.FillAddInData(AddInData);
        CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
    end;

    [Scope('Internal')]
    procedure "Navigation::ProcessTaskCompleteCommand"(EntryNo: Integer)
    var
        AddInData: BigText;
        ServLaborAllocationEntry: Record "25006271";
        ResourceNo: Code[20];
    begin
        ManageCurrentTime(CurrentDate, CurrentTime);
        IF ServLaborAllocationEntry.GET(EntryNo) THEN BEGIN
            CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
            ResourceTimeRegMgt.ValidateTimeRegAction('Complete', ServLaborAllocationEntry, CurrentResourceNo);
            ResourceTimeRegMgt.AddTimeRegEntries('Complete', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
            ResourceTimeRegMgt.UpdateAllocationStatus('Complete', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
        END;
        ServiceNavigationMgt.FillAddInData(AddInData);
        CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
    end;

    [Scope('Internal')]
    procedure "Navigation::ProcessTaskPauseCommand"(EntryNo: Integer)
    var
        AddInData: BigText;
        ServLaborAllocationEntry: Record "25006271";
    begin
        ManageCurrentTime(CurrentDate, CurrentTime);
        IF ServLaborAllocationEntry.GET(EntryNo) THEN BEGIN
            CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
            ResourceTimeRegMgt.ValidateTimeRegAction('OnHold', ServLaborAllocationEntry, CurrentResourceNo);
            ResourceTimeRegMgt.AddTimeRegEntries('OnHold', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
            ResourceTimeRegMgt.UpdateAllocationStatus('OnHold', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
        END;
        ServiceNavigationMgt.FillAddInData(AddInData);
        CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
    end;

    [Scope('Internal')]
    procedure "Navigation::ProcessTaskStartCommand"(EntryNo: Integer)
    var
        AddInData: BigText;
        ServLaborAllocationEntry: Record "25006271";
    begin
        ManageCurrentTime(CurrentDate, CurrentTime);
        IF ServLaborAllocationEntry.GET(EntryNo) THEN BEGIN
            CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();
            ResourceTimeRegMgt.StartWorktimeSilent(CurrentResourceNo, CurrentDate, CurrentTime);
            ResourceTimeRegMgt.ValidateTimeRegAction('Start', ServLaborAllocationEntry, CurrentResourceNo);
            ResourceTimeRegMgt.UpdateAllocationStatus('Start', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
            ResourceTimeRegMgt.AddTimeRegEntries('Start', ServLaborAllocationEntry, CurrentResourceNo, CurrentDate, CurrentTime);
        END;
        ServiceNavigationMgt.FillAddInData(AddInData);
        CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
    end;

    [Scope('Internal')]
    procedure "Navigation::ProcessWorktimeCommand"()
    var
        AddInData: BigText;
        ServLaborAllocationEntry: Record "25006271";
    begin
        ManageCurrentTime(CurrentDate, CurrentTime);
        ResourceTimeRegMgt.ToggleWorktime(ResourceTimeRegMgt.GetCurrentUserResourceNo, CurrentDate, CurrentTime);
        ServiceNavigationMgt.FillAddInData(AddInData);
        CurrPage.Navigation.RecieveRefreshNavigationData(AddInData);
    end;

    [Scope('Internal')]
    procedure "Navigation::ProcessLookupCommand"(EntryNo: Integer)
    var
        AddInData: BigText;
        ServLaborAllocationEntry: Record "25006271";
    begin
        IF ServLaborAllocationEntry.GET(EntryNo) THEN BEGIN
            ServiceNavigationMgt.ProcessLookupAction(ServLaborAllocationEntry);
        END;
    end;

    local procedure ManageCurrentTime(var CrDate: Date; var CrTime: Time)
    var
        CustomCurrDate: Date;
        CustomCurrTime: Time;
    begin
        ServiceNavigationMgt.GetCustomCurrDateTime(CustomCurrDate, CustomCurrTime);
        IF (CustomCurrDate <> 0D) AND (CustomCurrTime <> 0T) THEN BEGIN
            CrDate := CustomCurrDate;
            CrTime := CustomCurrTime;
        END ELSE BEGIN
            CrDate := WORKDATE;
            CrTime := TIME;
        END;
    end;
}

