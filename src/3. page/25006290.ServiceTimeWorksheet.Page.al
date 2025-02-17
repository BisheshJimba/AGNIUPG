page 25006290 "Service Time Worksheet"
{
    Caption = 'Service Time Worksheet';
    DataCaptionExpression = DashboardTitle;
    PageType = Card;
    PromotedActionCategories = 'User,Work Time,Task,Period,Actions';

    layout
    {
        area(content)
        {
            part(ServiceMechanicPersTasks; 25006291)
            {
            }
            part(ServiceMechanicPoolTasks; 25006292)
            {
            }
            part(ServiceMechanicHeaderTasks; 25006293)
            {
                UpdatePropagation = Both;
            }
            part(ServiceMechanicLineTasks; 25006294)
            {
                Provider = ServiceMechanicHeaderTasks;
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(No.);
                SubPageView = WHERE(Type=FILTER(Labor));
                UpdatePropagation = Both;
            }
            usercontrol(PingPong;"Microsoft.Dynamics.Nav.Client.PingPong")
            {

                trigger AddInReady()
                begin
                    RefreshInMinutes := ResourceTimeRegMgt.GetDashboardRefreshInMinutes;
                    CurrPage.PingPong.Ping(60000*RefreshInMinutes); //5min
                end;

                trigger Pong()
                begin
                    RefreshInMinutes := ResourceTimeRegMgt.GetDashboardRefreshInMinutes;
                    CurrPage.UPDATE(FALSE);
                    CurrPage.PingPong.Ping(60000*RefreshInMinutes); //5min
                end;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(User)
            {
                Caption = 'User';
                action("Switch User")
                {
                    Image = ChangeCustomer;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServiceLineEDMS: Record "25006146";
                        ScheduleResourceLink: Record "25006291";
                    begin
                        User.RESET;
                        User.SETCURRENTKEY("User Name");
                        IF PAGE.RUNMODAL(PAGE::Users,User) = ACTION::LookupOK THEN BEGIN
                          //Check Password
                          CLEAR(ScheduleResourceAuth);
                          ScheduleResourceAuth.SetParam(ResourceTimeRegMgt.GetResourceNoByUserId(User."User Name"));
                          ScheduleResourceAuth.LOOKUPMODE(TRUE);
                          IF ScheduleResourceAuth.RUNMODAL = ACTION::LookupOK THEN
                            ServiceScheduleMgt.CompareSchedulePassword(ResourceTimeRegMgt.GetResourceNoByUserId(User."User Name"),ScheduleResourceAuth.GetSchedulePassword)
                          ELSE
                            ERROR(UserSwitchIgnoreErr);

                          SingleInstanceManagement.SetCurrentUserId(User."User Name");
                          DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                          IF ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' THEN BEGIN
                            //Personal tasks
                            ServLaborAllocEntry.RESET;
                            ServLaborAllocEntry.FILTERGROUP(3);
                            ServLaborAllocEntry.SETRANGE("Resource No.",ResourceTimeRegMgt.GetCurrentUserResourceNo);
                            ServLaborAllocEntry.FILTERGROUP(0);
                            ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                            //Pool taks
                            ScheduleResourceLink.RESET;
                            ScheduleResourceLink.SETRANGE("Resource No.",ResourceTimeRegMgt.GetCurrentUserResourceNo);
                            ResourceTimeRegMgt.SetPeriodFilterResourceLink(ScheduleResourceLink);
                            ServLaborAllocEntryPool.RESET;
                            ResourceGroupFilter := '';

                            IF ScheduleResourceLink.FINDFIRST THEN BEGIN
                              REPEAT
                                ResourceGroupFilter += ScheduleResourceLink."Group Resource No."+'|';
                              UNTIL  ScheduleResourceLink.NEXT = 0;
                              ResourceGroupFilter := DELCHR(ResourceGroupFilter,'>','|');
                            END;
                            ServLaborAllocEntryPool.FILTERGROUP(3);
                            ServLaborAllocEntryPool.SETRANGE("Resource No.",ResourceGroupFilter);
                            ServLaborAllocEntryPool.FILTERGROUP(0);
                            ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntryPool);

                            CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntryPool);
                            CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;

                          END ELSE BEGIN
                            ERROR(UserResourceSetupErr);
                          END;
                        END;

                        ButtonStartWorkingState := NOT ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                        ButtonEndWorkingState := ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
            }
            group("Work Time")
            {
                Caption = 'Work Time';
                action("Start Working")
                {
                    Caption = 'Start';
                    Enabled = ButtonStartWorkingState;
                    Image = Default;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.StartWorktime(ResourceTimeRegMgt.GetCurrentUserResourceNo,WORKDATE,TIME);
                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);

                        ButtonStartWorkingState := NOT ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                        ButtonEndWorkingState := ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action("Finish Working")
                {
                    Caption = 'Finish';
                    Enabled = ButtonEndWorkingState;
                    Image = Error;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.EndWorktime(ResourceTimeRegMgt.GetCurrentUserResourceNo,WORKDATE,TIME);
                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);

                        ButtonStartWorkingState := NOT ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                        ButtonEndWorkingState := ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
            }
            group(Task)
            {
                Caption = 'Task';
                action("Start Standard Event")
                {
                    Image = NewToDo;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.StartNewTaskFromStandard(ResourceTimeRegMgt.GetCurrentUserResourceNo,WORKDATE,TIME);
                    end;
                }
                action(Undo)
                {
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.UndoLastAction(ServLaborAllocEntry."Entry No.",ResourceTimeRegMgt.GetCurrentUserResourceNo,WORKDATE,TIME);
                        CurrPage.UPDATE;
                    end;
                }
            }
            group(Period)
            {
                Caption = 'Period';
                action(Day)
                {
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DTDayStart: Decimal;
                        DTDayEnd: Decimal;
                    begin
                        SingleInstanceManagement.SetCurrentPeriod(1);
                        CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                        CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;
                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action(Week)
                {
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DTDayStart: Decimal;
                        DTDayEnd: Decimal;
                    begin
                        SingleInstanceManagement.SetCurrentPeriod(2);
                        CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                        CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;
                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action(Previous)
                {
                    Image = PreviousSet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.MovePeriodFilter(-1);

                        CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                        CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;

                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action(Next)
                {
                    Image = NextSet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.MovePeriodFilter(1);

                        CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                        CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;

                        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);
                    end;
                }
                action("All Time")
                {
                    Caption = 'All';
                    Image = "Table";
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ServLaborAllocEntry.RESET;
                        CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ServLaborAllocEntry.SETRANGE("Start Date-Time");
                        ServLaborAllocEntry.SETRANGE("End Date-Time");
                        CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                        ServLaborAllocEntry.RESET;
                        CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                        ServLaborAllocEntry.SETRANGE("Start Date-Time");
                        ServLaborAllocEntry.SETRANGE("End Date-Time");
                        CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                        CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;
                    end;
                }
            }
            group("Filter")
            {
                group(Filter)
                {
                    Caption = 'Filter';
                    Image = FilterLines;
                    action(Pending)
                    {

                        trigger OnAction()
                        begin
                            ServLaborAllocEntry.RESET;
                            CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SETRANGE(Status,ServLaborAllocEntry.Status::Pending);
                            CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                            ServLaborAllocEntry.RESET;
                            CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SETRANGE(Status,ServLaborAllocEntry.Status::Pending);
                            CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;
                        end;
                    }
                    action("In Process")
                    {

                        trigger OnAction()
                        begin
                            ServLaborAllocEntry.RESET;
                            CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SETRANGE(Status,ServLaborAllocEntry.Status::"In Progress");
                            CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                            ServLaborAllocEntry.RESET;
                            CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SETRANGE(Status,ServLaborAllocEntry.Status::"In Progress");
                            CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;
                        end;
                    }
                    action(Finished)
                    {

                        trigger OnAction()
                        begin
                            ServLaborAllocEntry.RESET;
                            CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SETRANGE(Status,ServLaborAllocEntry.Status::Finished);
                            CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                            ServLaborAllocEntry.RESET;
                            CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SETRANGE(Status,ServLaborAllocEntry.Status::Finished);
                            CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;
                        end;
                    }
                    action("All Statuses")
                    {
                        Caption = 'All';

                        trigger OnAction()
                        begin
                            ServLaborAllocEntry.RESET;
                            CurrPage.ServiceMechanicPersTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SETRANGE(Status);
                            CurrPage.ServiceMechanicPersTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPersTasks.PAGE.PageUpdate;

                            ServLaborAllocEntry.RESET;
                            CurrPage.ServiceMechanicPoolTasks.PAGE.CopyRecFilter(ServLaborAllocEntry);
                            ServLaborAllocEntry.SETRANGE(Status);
                            CurrPage.ServiceMechanicPoolTasks.PAGE.SETTABLEVIEW(ServLaborAllocEntry);
                            CurrPage.ServiceMechanicPoolTasks.PAGE.PageUpdate;
                        end;
                    }
                }
            }
            group("Actions")
            {
                Caption = 'Actions';
                action(Start)
                {
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunPageMode = View;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start',ServLaborAllocEntry,CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Start',ServLaborAllocEntry,CurrentResourceNo,WORKDATE,TIME);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start',ServLaborAllocEntry,CurrentResourceNo,WORKDATE,TIME);
                        CurrPage.UPDATE;
                    end;
                }
                action(Stop)
                {
                    Image = Stop;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Stop',ServLaborAllocEntry,CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Stop',ServLaborAllocEntry,CurrentResourceNo,WORKDATE,TIME);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Stop',ServLaborAllocEntry,CurrentResourceNo,WORKDATE,TIME);
                        CurrPage.UPDATE;
                    end;
                }
                action(Hold)
                {
                    Image = Pause;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('OnHold',ServLaborAllocEntry,CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('OnHold',ServLaborAllocEntry,CurrentResourceNo,WORKDATE,TIME);
                        ResourceTimeRegMgt.UpdateAllocationStatus('OnHold',ServLaborAllocEntry,CurrentResourceNo,WORKDATE,TIME);
                        CurrPage.UPDATE;
                    end;
                }
                action(Complete)
                {
                    Image = Completed;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CurrentResourceNo: Code[20];
                    begin
                        CurrentResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo();

                        CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Complete',ServLaborAllocEntry,CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Complete',ServLaborAllocEntry,CurrentResourceNo,WORKDATE,TIME);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Complete',ServLaborAllocEntry,CurrentResourceNo,WORKDATE,TIME);
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        DashboardTitle := ResourceTimeRegMgt.GetDashboardCaption(ResourceTimeRegMgt.GetCurrentUserResourceNo);

        ButtonStartWorkingState := NOT ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
        ButtonEndWorkingState := ResourceTimeRegMgt.IsResourceWorking(ResourceTimeRegMgt.GetCurrentUserResourceNo);
    end;

    var
        UserProfileManagement: Codeunit "25006002";
        DashboardTitle: Text[200];
        DashboardTitleTxt: Label 'Dashboard';
        UserManagement: Codeunit "418";
        User: Record "2000000120";
        UserSetup: Record "91";
        UserName: Text[100];
        ServLaborAllocEntry: Record "25006271";
        UserResourceSetupErr: Label 'There is no Resource No. configured in User Setup.';
        ServLaborAllocEntryPool: Record "25006271";
        ServLaborAllocEntryFilter: Record "25006271";
        Resource: Record "156";
        ScheduleResourceGroupSpec: Record "25006275";
        ResourceGroupFilter: Text;
        ServiceScheduleMgt: Codeunit "25006201";
        ResourceTimeRegMgt: Codeunit "25006290";
        SingleInstanceManagement: Codeunit "25006001";
        DateTimeMgt: Codeunit "25006012";
        RefreshInMinutes: Integer;
        ServiceScheduleSetup: Record "25006286";
        ButtonStartWorkingState: Boolean;
        ButtonEndWorkingState: Boolean;
        ScheduleResourceAuth: Page "25006299";
                                  UserSwitchIgnoreErr: Label 'User switch cancelled.';
}

