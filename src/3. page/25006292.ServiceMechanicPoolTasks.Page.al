page 25006292 "Service Mechanic Pool Tasks"
{
    Caption = 'Group Tasks';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Table25006271;

    layout
    {
        area(content)
        {
            repeater("Repeat")
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
                }
                field("Resource No."; "Resource No.")
                {
                }
                field(Status; Status)
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
                field("Parent Alloc. Entry No."; "Parent Alloc. Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Start Task")
            {
                Image = "Action";
                RunPageMode = View;
                Scope = Repeater;

                trigger OnAction()
                begin
                    ResourceTimeRegMgt.StartNewTaskFromAllocation(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WORKDATE, TIME);
                    CurrPage.UPDATE;
                end;
            }
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
            action(Pause)
            {
                Image = Pause;
                Visible = false;

                trigger OnAction()
                begin
                    //ResourceTimeRegMgt.AddTimeRegEntry('OnHold',Rec);
                    //CurrPage.UPDATE;
                end;
            }
            action(Stop)
            {
                Image = Stop;
                Visible = false;

                trigger OnAction()
                begin
                    //ResourceTimeRegMgt.AddTimeRegEntry('Stop',Rec);
                    //CurrPage.UPDATE;
                end;
            }
            action(Complete)
            {
                Image = Completed;
                Visible = false;

                trigger OnAction()
                begin
                    //ResourceTimeRegMgt.AddTimeRegEntry('Complete',Rec);
                    //CurrPage.UPDATE;
                end;
            }
            separator()
            {
            }
            action("Time Reg. Entries")
            {
                Image = Entry;
                RunObject = Page 25006295;
                RunPageLink = Allocation Entry No.=FIELD(Entry No.);
                Scope = Repeater;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ButtonStartActive := (Status <> Status::"In Progress")
    end;

    trigger OnAfterGetRecord()
    begin
        RowAttention := ResourceTimeRegMgt.GetTaskColorPool(Rec);
    end;

    trigger OnOpenPage()
    begin
        //Pool allocation entries
        ResourceGroupFilter := '_$_';
        IF ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' THEN BEGIN
          ScheduleResourceLink.RESET;
          ScheduleResourceLink.SETRANGE("Resource No.",ResourceTimeRegMgt.GetCurrentUserResourceNo);
          ResourceTimeRegMgt.SetPeriodFilterResourceLink(ScheduleResourceLink);
          RESET;
          IF ScheduleResourceLink.FINDFIRST THEN BEGIN
            ResourceGroupFilter := '';
            REPEAT
              ResourceGroupFilter += ScheduleResourceLink."Group Resource No."+'|';
            UNTIL  ScheduleResourceLink.NEXT = 0;
            ResourceGroupFilter := DELCHR(ResourceGroupFilter,'>','|');
          END;

          FILTERGROUP(3);
          SETFILTER("Resource No.",ResourceGroupFilter);
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
        UserSetup: Record "91";
        Resource: Record "156";
        ScheduleResourceGroupSpec: Record "25006275";
        UserResourceSetupErr: Label 'There is no Resource No. configured in User Setup.';
        ScheduleResourceLink: Record "25006291";
        ResourceGroupFilter: Text;
        ResourceTimeRegMgt: Codeunit "25006290";
        ButtonStartActive: Boolean;
        ServiceScheduleSetup: Record "25006286";
        SingleInstanceManagement: Codeunit "25006001";
        ResourceTimeRegEntry: Record "25006290";
        TimeRegStatus: Option Pending,"In Progress",Finished,"On Hold";

    [Scope('Internal')]
    procedure GetCustomer()
    begin
    end;

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

