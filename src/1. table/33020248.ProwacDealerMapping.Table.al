table 33020248 "Prowac Dealer Mapping"
{

    fields
    {
        field(1; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE(Use As Service Location=FILTER(Yes));
        }
        field(2;"Prowac Dealer Code";Code[30])
        {
        }
    }

    keys
    {
        key(Key1;"Location Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

