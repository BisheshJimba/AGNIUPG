table 33020325 "Job Title"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Minimum Education"; Text[100])
        {
        }
        field(4; "Minimun Experience"; Text[100])
        {
        }
        field(5; Blocked; Boolean)
        {
        }
        field(6; Category; Code[100])
        {
        }
    }

    keys
    {
        key(Key1; "Code", Description)
        {
            Clustered = true;
        }
        key(Key2; Description, "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

