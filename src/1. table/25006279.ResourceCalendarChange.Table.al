table 25006279 "Resource Calendar Change"
{
    // 04.01.2008. EDMS P2
    //   * Added fields "Starting Time"
    //                  "Ending Time"

    Caption = 'Resource Calendar Change';

    fields
    {
        field(10; "Resource Code"; Code[20])
        {
            Caption = 'Resource Code';
            TableRelation = Resource;
        }
        field(20; Date; Date)
        {
            Caption = 'Date';
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(40; "Change Type"; Option)
        {
            Caption = 'Nonworking';
            OptionCaption = 'Work Time Change,Nonworking';
            OptionMembers = "Work Time Change",Nonworking;
        }
        field(50; "Starting Time"; Time)
        {
            Caption = 'Starting Time';

            trigger OnValidate()
            begin
                IF "Ending Time" <> 0T THEN
                    IF "Starting Time" >= "Ending Time" THEN
                        ERROR(Text001, FIELDCAPTION("Starting Time"), FIELDCAPTION("Ending Time"));
            end;
        }
        field(60; "Ending Time"; Time)
        {
            Caption = 'Ending Time';

            trigger OnValidate()
            begin
                IF "Ending Time" <> 0T THEN
                    IF "Ending Time" <= "Starting Time" THEN
                        ERROR(Text000, FIELDCAPTION("Ending Time"), FIELDCAPTION("Starting Time"));
            end;
        }
    }

    keys
    {
        key(Key1; "Resource Code", Date)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label '%1 must be later than %2.';
        Text001: Label '%1 must be earlier than %2.';
}

