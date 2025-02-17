page 25006359 "Resource Work Time Entries"
{
    Caption = 'Resource Work Time Entries';
    PageType = List;
    SourceTable = Table25006276;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                }
                field("Resource No."; "Resource No.")
                {
                }
                field("Resource Name"; "Resource Name")
                {
                }
                field("Worktime Begin"; "Worktime Begin")
                {
                }
                field(TimeBegin; TimeBegin)
                {
                    Caption = 'Worktime Begin Std.';
                }
                field("Worktime End"; "Worktime End")
                {
                }
                field(TimeEnd; TimeEnd)
                {
                    Caption = 'Worktime End Std.';
                }
                field("Worked Hours"; "Worked Hours")
                {
                    BlankZero = true;
                }
                field(Closed; Closed)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF Rec."Worktime Begin" <> 0 THEN
            TimeBegin := CREATEDATETIME(DateTimeMgt.Datetime2Date("Worktime Begin"), DateTimeMgt.Datetime2Time("Worktime Begin"))
        ELSE
            TimeBegin := 0DT;

        IF "Worktime End" <> 0 THEN
            TimeEnd := CREATEDATETIME(DateTimeMgt.Datetime2Date("Worktime End"), DateTimeMgt.Datetime2Time("Worktime End"))
        ELSE
            TimeEnd := 0DT;
    end;

    var
        TimeBegin: DateTime;
        TimeEnd: DateTime;
        DateTimeMgt: Codeunit "25006012";
}

