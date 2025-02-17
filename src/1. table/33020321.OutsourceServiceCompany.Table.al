table 33020321 "Outsource Service-Company"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[80])
        {
        }
        field(3; Type; Option)
        {
            Description = ' ,Service,Company';
            OptionCaption = ' ,Service,Company';
            OptionMembers = " ",Service,Company;
        }
    }

    keys
    {
        key(Key1; "Code", Description)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

