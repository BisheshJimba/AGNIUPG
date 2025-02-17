table 50015 "Sales Price For Scrap"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; Title; Code[30])
        {
        }
        field(3; Amount; Decimal)
        {
        }
        field(4; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

