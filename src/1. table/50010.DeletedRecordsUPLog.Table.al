table 50010 "Deleted Records UP Log"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "User ID"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

