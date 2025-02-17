table 33019842 "Temp. Table"
{

    fields
    {
        field(1; "New Value"; Code[20])
        {
        }
        field(2; "Old Value"; Code[20])
        {
        }
        field(3; "No."; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

