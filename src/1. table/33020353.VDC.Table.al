table 33020353 VDC
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            SQLDataType = Integer;
        }
        field(2; Name; Text[100])
        {
        }
        field(3; "District Code"; Code[10])
        {
            SQLDataType = Integer;
            TableRelation = District.Code;
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

