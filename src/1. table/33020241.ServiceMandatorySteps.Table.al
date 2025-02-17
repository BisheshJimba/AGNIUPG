table 33020241 "Service Mandatory Steps"
{

    fields
    {
        field(1; "Job Type Code"; Code[20])
        {
            TableRelation = "Job Type Master".No.;
        }
        field(2; "Bay Mandatory"; Boolean)
        {
        }
        field(3; "IC Mandatory"; Boolean)
        {
        }
        field(4; "Diagnosis Mandatory"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Job Type Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

