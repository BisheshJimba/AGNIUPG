table 66000 "FA Dates - TEMP"
{

    fields
    {
        field(1; "FA No."; Code[20])
        {
        }
        field(2; "Acquisition Date"; Date)
        {
        }
        field(3; "Depreciation Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "FA No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

