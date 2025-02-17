table 33020242 "Customer Complain Master"
{

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Make Code"; Code[20])
        {
            TableRelation = Make.Code;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
    }
}

