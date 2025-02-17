table 33020374 "Appraisal Type"
{

    fields
    {
        field(1; "Grade Code"; Code[10])
        {
        }
        field(2; "Appraisal Type"; Code[10])
        {
        }
        field(3; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Grade Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

