table 33020300 "HR - Fuel Rules"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = ' ,Vehicle,Motorcycle';
            OptionMembers = " ",Vehicle,Motorcycle;
        }
        field(4; "Fuel (Litre)"; Decimal)
        {
        }
        field(5; "No. Limit"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

