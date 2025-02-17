table 33020068 "Loan Approval Check List Setup"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Description 2"; Text[100])
        {
        }
        field(4; Mandatory; Boolean)
        {
        }
        field(50030; "Application Status"; Code[50])
        {
            TableRelation = "Hire Purchase Setup Master".Code WHERE(Type = CONST(Application Status));
        }
        field(50031; Blocked; Boolean)
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

