table 25006882 "User Statistics KPI"
{
    Caption = 'User Statistics KPI';

    fields
    {
        field(10; Date; Date)
        {
        }
        field(20; "Statistics KPI Code"; Code[50])
        {
        }
        field(30; Description; Text[50])
        {
        }
        field(40; "KPI Value"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; Date, "Statistics KPI Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

