table 33020391 "Attendence Log From Machine"
{

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; Date; Date)
        {
        }
        field(3; "Punch Time"; Time)
        {
        }
        field(4; Employee; Code[10])
        {
            TableRelation = Employee;
        }
        field(5; "Machine No"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

