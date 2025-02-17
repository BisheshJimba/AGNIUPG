page 25006299 "Schedule Resource Auth."
{
    SourceTable = Table156;

    layout
    {
        area(content)
        {
            group()
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Name; Name)
                {
                    Editable = false;
                }
                field(Password; SchedulePassword)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        SchedulePassword: Text[20];
        ServSchedMgt: Codeunit "25006201";

    [Scope('Internal')]
    procedure SetParam(ResourceNo1: Code[20])
    begin
        SETRANGE("No.", ResourceNo1);
    end;

    [Scope('Internal')]
    procedure GetSchedulePassword(): Text[20]
    begin
        EXIT(SchedulePassword);
    end;
}

