table 33019853 "Veh. Delivery Chklist Template"
{

    fields
    {
        field(1; "S.No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Particulars; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "S.No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

