table 33020203 "Contact Stages"
{

    fields
    {
        field(1; "Stage Code"; Code[10])
        {
        }
        field(2; "Stage Description"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Stage Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

