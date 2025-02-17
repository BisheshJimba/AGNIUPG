table 33020080 "Hire Purchase Setup Master"
{
    DrillDownPageID = 33020120;
    LookupPageID = 33020120;

    fields
    {
        field(1; Type; Option)
        {
            OptionCaption = 'Application Status,Financing Option,Purpose,Vehicle Application';
            OptionMembers = "Application Status","Financing Option",Purpose,"Vehicle Application";
        }
        field(2; "Code"; Code[50])
        {
        }
        field(3; Sequence; Integer)
        {
        }
        field(4; "Skip Checking When Loan App."; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; Type, "Code")
        {
            Clustered = true;
        }
        key(Key2; Type, Sequence)
        {
        }
    }

    fieldgroups
    {
    }
}

