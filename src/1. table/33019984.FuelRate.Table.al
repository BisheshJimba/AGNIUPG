table 33019984 "Fuel Rate"
{

    fields
    {
        field(1; Date; Date)
        {
        }
        field(2; Type; Option)
        {
            OptionCaption = ' ,Diesel,Petrol,Kerosene,Mobile,Engine Oil,Others';
            OptionMembers = " ",Diesel,Petrol,Kerosene,Mobile,"Engine Oil",Others;
        }
        field(3; Rate; Decimal)
        {
        }
        field(4; Location; Code[10])
        {
            TableRelation = "Location - Admin".Code;
        }
    }

    keys
    {
        key(Key1; Date, Location, Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

