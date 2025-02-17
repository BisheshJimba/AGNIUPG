table 33020324 Grades
{

    fields
    {
        field(1; "Grade Code"; Code[10])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Category; Code[10])
        {
            Description = 'CAT-1 for Manager and CAT-2 for Officer and CAT-3 Technician';
        }
        field(4; "Display Order"; Code[10])
        {
        }
        field(5; Blocked; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Grade Code", Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

