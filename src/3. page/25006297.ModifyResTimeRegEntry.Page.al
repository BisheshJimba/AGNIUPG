page 25006297 "Modify Res. Time Reg. Entry"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = Table25006290;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group()
            {
                field(Date; Date)
                {
                }
                field(Time; Time)
                {
                }
                field("Time Spent"; "Time Spent")
                {
                }
            }
        }
    }

    actions
    {
    }

    [Scope('Internal')]
    procedure SetEntry(ResourceTimeRegEntry: Record "25006290")
    begin
        Rec := ResourceTimeRegEntry;
        Rec.INSERT;
    end;
}

