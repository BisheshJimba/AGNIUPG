table 14125603 Status
{

    fields
    {
        field(1; "Status Code"; Code[20])
        {
        }
        field(2; "Status Description"; Text[30])
        {
        }
        field(3; "Status Description 2"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Status Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

