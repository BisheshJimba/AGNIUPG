table 33020358 "Training List"
{
    DrillDownPageID = 33020359;
    LookupPageID = 33020359;

    fields
    {
        field(10; "Training Code"; Code[20])
        {
        }
        field(20; "Training Topic"; Text[80])
        {
        }
        field(30; Description; Text[30])
        {
        }
        field(40; Type; Option)
        {
            OptionMembers = " ",Technical,"Non-Technical";
        }
        field(50; "Internal/External"; Option)
        {
            OptionMembers = " ",Internal,External;
        }
        field(51; "Duration in Months"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Training Code", "Training Topic")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

