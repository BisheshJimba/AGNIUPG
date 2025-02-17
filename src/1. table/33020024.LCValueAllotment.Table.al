table 33020024 "LC Value Allotment"
{

    fields
    {
        field(1; "LC Code"; Code[20])
        {
        }
        field(2; "PI Code"; Code[20])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = ' ,Insurance,Letter of Credit';
            OptionMembers = " ",Insurance,"Letter of Credit";
        }
        field(4; "Value (LCY)"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "LC Code", "PI Code")
        {
            Clustered = true;
        }
        key(Key2; "LC Code", Type)
        {
            SumIndexFields = "Value (LCY)";
        }
    }

    fieldgroups
    {
    }
}

