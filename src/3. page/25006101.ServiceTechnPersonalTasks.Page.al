page 25006101 "Service Techn. Personal Tasks"
{
    Caption = 'My Tasks';
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'aaa,bbb,ccc,ddd,Task,Card';
    SourceTable = Table25006271;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(ServiceScheduleMgt.GetAllocRecDescr(Rec);
                    ServiceScheduleMgt.GetAllocRecDescr(Rec))
                {
                    Caption = 'Cell Description';
                    StyleExpr = RowAttention;
                }
                field(TimeRegStatus; TimeRegStatus)
                {
                    Caption = 'Status';
                    Editable = false;
                }
                field("Total Time Spent"; "Total Time Spent")
                {
                    Editable = false;
                }
                field(DateTimeMgt.Datetime2Text("Start Date-Time");
                    DateTimeMgt.Datetime2Text("Start Date-Time"))
                {
                    Caption = 'Starting Date-Time';
                }
                field(DateTimeMgt.Datetime2Text("End Date-Time");
                    DateTimeMgt.Datetime2Text("End Date-Time"))
                {
                    Caption = 'Ending Date-Time';
                }
                field("Reason Code"; "Reason Code")
                {
                    Visible = false;
                }
                field("Quantity (Hours)"; "Quantity (Hours)")
                {
                    Editable = false;
                }
                field("User ID"; "User ID")
                {
                    Editable = false;
                }
                field("Entry No."; "Entry No.")
                {
                    Editable = false;
                }
                field("Resource Group Code"; "Resource Group Code")
                {
                    Editable = false;
                }
                field("Parent Alloc. Entry No."; "Parent Alloc. Entry No.")
                {
                    Editable = false;
                }
                field("Application Entry Count"; "Application Entry Count")
                {
                    Editable = false;
                }
                field("Source Type"; "Source Type")
                {
                    StyleExpr = RowAttention;
                }
                field("Source Subtype"; "Source Subtype")
                {
                    StyleExpr = RowAttention;
                }
                field("Source ID"; "Source ID")
                {
                    StyleExpr = RowAttention;
                }
                field("Resource No."; "Resource No.")
                {
                    Editable = false;
                }
                field(Travel; Travel)
                {
                }
                field("Total Time Spent Travel"; "Total Time Spent Travel")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
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

                        //CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Start', Rec, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Start', Rec, CurrentResourceNo, WORKDATE, TIME);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Start', Rec, CurrentResourceNo, WORKDATE, TIME);
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

                        //CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Stop', Rec, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Stop', Rec, CurrentResourceNo, WORKDATE, TIME);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Stop', Rec, CurrentResourceNo, WORKDATE, TIME);
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

                        //CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('OnHold', Rec, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('OnHold', Rec, CurrentResourceNo, WORKDATE, TIME);
                        ResourceTimeRegMgt.UpdateAllocationStatus('OnHold', Rec, CurrentResourceNo, WORKDATE, TIME);
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

                        //CurrPage.ServiceMechanicPersTasks.PAGE.GETRECORD(ServLaborAllocEntry);
                        ResourceTimeRegMgt.ValidateTimeRegAction('Complete', Rec, CurrentResourceNo);
                        ResourceTimeRegMgt.AddTimeRegEntries('Complete', Rec, CurrentResourceNo, WORKDATE, TIME);
                        ResourceTimeRegMgt.UpdateAllocationStatus('Complete', Rec, CurrentResourceNo, WORKDATE, TIME);
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
        area(navigation)
        {
            group(Navigation)
            {
                Caption = 'Navigation';
                action(Open)
                {
                    Caption = 'Open';
                    Image = ViewDetails;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServiceOrder: Page "25006183";
                        ServiceHeader: Record "25006145";
                        Allocation: Page "25006369";
                        ServScheduleMgt: Codeunit "25006201";
                        EasyClockingManagement: Codeunit "25006017";
                    begin
                        EasyClockingManagement.ProcessLookupAction(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        // -- do not remove (NAV bug)
    end;

    trigger OnAfterGetRecord()
    begin
        ResourceTimeRegEntry.RESET;
        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.", "Entry No.");
        ResourceTimeRegEntry.SETRANGE("Resource No.", "Resource No.");
        ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);
        IF ResourceTimeRegEntry.FINDLAST THEN
            TimeRegStatus := ResourceTimeRegEntry."Entry Type"
        ELSE
            TimeRegStatus := ResourceTimeRegEntry."Entry Type"::Pending;

        RowAttention := ResourceTimeRegMgt.GetTaskColor(TimeRegStatus, Rec);
    end;

    trigger OnOpenPage()
    var
        ServiceSetup: Record "25006120";
        StandardEvent: Record "25006272";
    begin
        ServiceSetup.GET;

        IF ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' THEN BEGIN
            RESET;
            FILTERGROUP(3);
            SETRANGE("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
            IF ServiceSetup."Default Idle Event" <> '' THEN BEGIN
                StandardEvent.GET(ServiceSetup."Default Idle Event");
                SETFILTER("Source ID", '<>%1', StandardEvent.Code);
            END;
            FILTERGROUP(0);
        END ELSE BEGIN
            ERROR(UserResourceSetupErr);
        END;

        ResourceTimeRegMgt.SetPeriodFilter(Rec);



        CurrPage.UPDATE;
    end;

    var
        ServiceScheduleMgt: Codeunit "25006201";
        DateTimeMgt: Codeunit "25006012";
        RowAttention: Text[20];
        ServLaborAllocationEntry: Record "25006271";
        UserSetup: Record "91";
        UserResourceSetupErr: Label 'There is no Resource No. configured in User Setup.';
        TimeRegisterInProgressMsg: Label 'Task status set to "In Progress"';
        TimeRegisterOnHoldMsg: Label 'Task status set to "On Hold"';
        TimeRegisterFinishedMsg: Label 'Task status set to "Finised"';
        ResourceTimeRegMgt: Codeunit "25006290";
        ServiceScheduleSetup: Record "25006286";
        TimeRegStatus: Option Pending,"In Progress",Finished,"On Hold";
        ResourceTimeRegEntry: Record "25006290";
        CustomButtonsVisible: Boolean;

    [Scope('Internal')]
    procedure PageUpdate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure CopyRecFilter(var CopyServLaborAllocEntry: Record "25006271")
    begin
        CopyServLaborAllocEntry.COPYFILTERS(Rec);
    end;
}

