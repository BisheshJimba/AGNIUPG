table 33020392 "Attendence Register1"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; Employee; Code[10])
        {
            TableRelation = Employee;
        }
        field(3; "Sign-in Date"; Date)
        {
        }
        field(4; "Sign-in Time"; Time)
        {
        }
        field(5; "Sign-Out Date"; Date)
        {
        }
        field(6; "Sign-Out Time"; Time)
        {
        }
        field(7; "Hours Worked"; Decimal)
        {
        }
        field(8; "Default Working Hour"; Decimal)
        {
        }
        field(9; "Employee Name"; Text[30])
        {
        }
        field(10; "Machine No"; Code[10])
        {
        }
        field(11; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1),
                                                          Dimension Value Type=FILTER(Standard));
        }
        field(12;Status;Option)
        {
            OptionMembers = Present,Absent,Leave,"Half Leave";
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
            Clustered = true;
        }
        key(Key2;Employee)
        {
        }
    }

    fieldgroups
    {
    }
}

