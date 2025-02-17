table 33020081 "Risk Assessment Setup"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[250])
        {
        }
        field(3; "Weightage (A)"; Integer)
        {
        }
        field(4; "Score (B)"; Integer)
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

