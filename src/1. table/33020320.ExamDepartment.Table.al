table 33020320 "Exam Department"
{

    fields
    {
        field(1; "Exam Department Code"; Code[20])
        {
        }
        field(2; "Exam Department Descrition"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Exam Department Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

