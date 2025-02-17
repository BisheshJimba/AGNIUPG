table 60013 "VF Receipt Date Temp"
{

    fields
    {
        field(1; "Receipt No."; Code[20])
        {
        }
        field(2; Date; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Receipt No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

