table 33020558 "Attendance Machine Mapping"
{

    fields
    {
        field(1; "Machine Code"; Code[10])
        {
        }
        field(2; "Machine Name"; Text[30])
        {
        }
        field(90; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(100; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(200; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(250; "IP Address"; Code[20])
        {
        }
        field(251; Active; Boolean)
        {
            Description = 'Do not import attendance data if active is false';
        }
    }

    keys
    {
        key(Key1; "Machine Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

