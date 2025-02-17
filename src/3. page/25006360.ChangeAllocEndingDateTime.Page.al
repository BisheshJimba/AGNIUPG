page 25006360 "Change Alloc.Ending Date/Time"
{
    Caption = 'Change Alloc.Ending Date/Time';
    PageType = Card;
    SourceTable = Table156;

    layout
    {
        area(content)
        {
            field(ServLaborAllocation."Source ID";
                ServLaborAllocation."Source ID")
            {
                Caption = 'Source ID';
                Editable = false;
            }
            field("No."; "No.")
            {
                Caption = 'Resource No.';
                Editable = false;
            }
            field(Name; Name)
            {
                Editable = false;
            }
            field(DateTimeMgt.Datetime2Text(ServLaborAllocation."Start Date-Time");
                DateTimeMgt.Datetime2Text(ServLaborAllocation."Start Date-Time"))
            {
                Caption = 'Start Date-Time';
            }
            field(DateTimeMgt.Datetime2Text(ServLaborAllocation."End Date-Time");
                DateTimeMgt.Datetime2Text(ServLaborAllocation."End Date-Time"))
            {
                Caption = 'End Date-Time';
            }
            field(EndDate; EndDate)
            {
                Caption = 'New End Date';
            }
            field(EndTime; EndTime)
            {
                Caption = 'New End Time';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        EndDate := DateTimeMgt.Datetime2Date(ServLaborAllocation."End Date-Time");
        EndTime := DateTimeMgt.Datetime2Time(ServLaborAllocation."End Date-Time");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        AllocApplication: Record "25006277";
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            ServLaborAllocation2.GET(ServLaborAllocation."Entry No.");
            ServLaborAllocation2."End Date-Time" := DateTimeMgt.Datetime(EndDate, EndTime);
            ServLaborAllocation2."Quantity (Hours)" := ServiceScheduleMgt.CalcHourDifference(ServLaborAllocation2."Start Date-Time",
                                                      ServLaborAllocation2."End Date-Time");
            ServLaborAllocation2.MODIFY;

            AllocApplication.RESET;
            AllocApplication.SETRANGE("Allocation Entry No.", ServLaborAllocation2."Entry No.");
            AllocApplication.SETRANGE("Time Line", TRUE);
            IF AllocApplication.FINDFIRST THEN BEGIN
                AllocApplication."Finished Quantity (Hours)" := ServLaborAllocation2."Quantity (Hours)";
                AllocApplication.MODIFY;
            END;
        END;
    end;

    var
        ServLaborAllocation: Record "25006271";
        ServLaborAllocation2: Record "25006271";
        DateTimeMgt: Codeunit "25006012";
        ServiceScheduleMgt: Codeunit "25006201";
        EndDate: Date;
        EndTime: Time;

    [Scope('Internal')]
    procedure GetServLaborAllocation(ServLaborAllocation1: Record "25006271")
    begin
        ServLaborAllocation := ServLaborAllocation1;
    end;
}

