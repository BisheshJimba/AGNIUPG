table 25006129 "Service Hour EDMS"
{
    Caption = 'Service Hour';
    LookupPageID = 5916;

    fields
    {
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(20; Day; Option)
        {
            Caption = 'Day';
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(30; "Starting Time"; Time)
        {
            Caption = 'Starting Time';

            trigger OnValidate()
            begin
                IF "Ending Time" <> 0T THEN
                    IF "Starting Time" >= "Ending Time" THEN
                        ERROR(Text001, FIELDCAPTION("Starting Time"), FIELDCAPTION("Ending Time"));
            end;
        }
        field(40; "Ending Time"; Time)
        {
            Caption = 'Ending Time';

            trigger OnValidate()
            begin
                IF "Ending Time" <> 0T THEN
                    IF "Ending Time" <= "Starting Time" THEN
                        ERROR(Text000, FIELDCAPTION("Ending Time"), FIELDCAPTION("Starting Time"));
            end;
        }
        field(50; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(60; "Service Work Group Code"; Code[20])
        {
            Caption = 'Service Work Group Code';
            TableRelation = "Service Work Group";
        }
    }

    keys
    {
        key(Key1; "Service Work Group Code", "Starting Date", Day, "Starting Time")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        CheckTime;
    end;

    trigger OnModify()
    begin
        CheckTime;
    end;

    var
        Text000: Label '%1 must be later than %2.';
        Text001: Label '%1 must be earlier than %2.';
        Text002: Label 'You must specify %1.';

    [Scope('Internal')]
    procedure CheckTime()
    begin
        IF "Starting Time" = 0T THEN
            ERROR(Text002, FIELDCAPTION("Starting Time"));
        IF "Ending Time" = 0T THEN
            ERROR(Text002, FIELDCAPTION("Ending Time"));
    end;
}

