page 25006100 "Service Technician Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = Table25006177;

    layout
    {
        area(content)
        {
            cuegroup(Tasks)
            {
                Caption = 'Tasks';
                field("My Tasks EC"; "My Tasks EC")
                {
                    Caption = 'My Tasks';
                    DrillDownPageID = "Service Techn. Personal Tasks";
                }
                field("My Group Tasks EC"; "My Group Tasks EC")
                {
                    Caption = 'My Group Tasks';
                    DrillDownPageID = "Service Techn. Group Tasks";
                }
                field("My Orders EC"; "My Orders EC")
                {
                    DrillDownPageID = "Service Techn. Orders";
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnAfterGetRecord()
    var
        ResourceTimeRegMgt: Codeunit "25006290";
        ServLaborAllocationEntry: Record "25006271";
        ServiceSetup: Record "25006120";
        StandardEvent: Record "25006272";
        ResourceGroupFilter: Text;
        ScheduleResourceLink: Record "25006291";
    begin
        ServiceSetup.GET;
        IF ResourceTimeRegMgt.GetCurrentUserResourceNo <> '' THEN BEGIN
            ServLaborAllocationEntry.RESET;
            ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocationEntry);
            ServLaborAllocationEntry.SETRANGE("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
            IF ServiceSetup."Default Idle Event" <> '' THEN BEGIN
                StandardEvent.GET(ServiceSetup."Default Idle Event");
                ServLaborAllocationEntry.SETFILTER("Source ID", '<>%1', StandardEvent.Code);
            END;
            "My Tasks EC" := ServLaborAllocationEntry.COUNT;

            ServLaborAllocationEntry.RESET;
            ResourceGroupFilter := '_$_';
            ScheduleResourceLink.RESET;
            ScheduleResourceLink.SETRANGE("Resource No.", ResourceTimeRegMgt.GetCurrentUserResourceNo);
            ResourceTimeRegMgt.SetPeriodFilterResourceLink(ScheduleResourceLink);
            IF ScheduleResourceLink.FINDFIRST THEN BEGIN
                ResourceGroupFilter := '';
                REPEAT
                    ResourceGroupFilter += ScheduleResourceLink."Group Resource No." + '|';
                UNTIL ScheduleResourceLink.NEXT = 0;
                ResourceGroupFilter := DELCHR(ResourceGroupFilter, '>', '|');
            END;
            ServLaborAllocationEntry.SETFILTER("Resource No.", ResourceGroupFilter);
            IF ServiceSetup."Default Idle Event" <> '' THEN BEGIN
                StandardEvent.GET(ServiceSetup."Default Idle Event");
                ServLaborAllocationEntry.SETFILTER("Source ID", '<>%1', StandardEvent.Code);
            END;
            ResourceTimeRegMgt.SetPeriodFilter(ServLaborAllocationEntry);
            "My Group Tasks EC" := ServLaborAllocationEntry.COUNT;
        END;
    end;

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;

        SETRANGE("Date Filter", 0D, WORKDATE);
    end;
}

