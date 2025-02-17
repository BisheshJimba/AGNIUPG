page 25006291 "Service Mechanic Pers. Tasks"
{
    Caption = 'My Tasks';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Table25006271;

    layout
    {
        area(content)
        {
            repeater()
            {
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
                field(ServiceScheduleMgt.GetAllocRecDescr(Rec);
                    ServiceScheduleMgt.GetAllocRecDescr(Rec))
                {
                    Caption = 'Cell Description';
                    StyleExpr = RowAttention;
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
                field("Resource No."; "Resource No.")
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
                field(TimeRegStatus; TimeRegStatus)
                {
                    Caption = 'Status';
                    Editable = false;
                }
                field(Status; Status)
                {
                    Caption = 'Entry Status';
                    Visible = false;
                }
                field("Total Time Spent"; "Total Time Spent")
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
            action("Start Travel Task")
            {
                Image = "Action";
                RunPageMode = View;
                Scope = Repeater;

                trigger OnAction()
                begin
                    ResourceTimeRegMgt.StartNewTravelTaskFromAllocation(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WORKDATE, TIME);
                    CurrPage.UPDATE;
                end;
            }
            action("Time Reg. Entries")
            {
                Image = Entry;
                RunObject = Page 25006295;
                RunPageLink = Allocation Entry No.=FIELD(Entry No.),
                              Resource No.=FIELD(Resource No.);
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
        ResourceTimeRegEntry.SETRANGE("Allocation Entry No.","Entry No.");
        ResourceTimeRegEntry.SETRANGE("Resource No.","Resource No.");
        ResourceTimeRegEntry.SETRANGE(Canceled,FALSE);
        IF ResourceTimeRegEntry.FINDLAST THEN
          TimeRegStatus := ResourceTimeRegEntry."Entry Type"
        ELSE
          TimeRegStatus := ResourceTimeRegEntry."Entry Type"::Pending;

        RowAttention := ResourceTimeRegMgt.GetTaskColor(TimeRegStatus,Rec);
    end;

    trigger OnOpenPage()
    begin
        IF ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' THEN BEGIN
          RESET;
          FILTERGROUP(3);
          SETRANGE("Resource No.",ResourceTimeRegMgt.GetCurrentUserResourceNo);
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
        SingleInstanceManagement: Codeunit "25006001";
        TimeRegStatus: Option Pending,"In Progress",Finished,"On Hold";
        ResourceTimeRegEntry: Record "25006290";

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

