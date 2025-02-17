table 33020204 "Contact Occupation"
{
    DrillDownPageID = 33020210;
    LookupPageID = 33020210;

    fields
    {
        field(1; Occupation; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; Occupation)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

