table 33020301 "English Year"
{
    DrillDownPageID = 33020302;
    LookupPageID = 33020302;

    fields
    {
        field(1; "Code"; Integer)
        {
        }
        field(2; Description; Text[80])
        {
        }
        field(3; "Leap Year"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

