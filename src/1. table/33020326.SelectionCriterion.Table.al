table 33020326 "Selection Criterion"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
        }
        field(3; Type; Option)
        {
            OptionMembers = " ",Technical,"Non-Technical";
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

