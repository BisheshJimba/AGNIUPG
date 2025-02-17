table 33019806 "PSF Master"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            Description = 'Sheet Code';
        }
        field(2; Type; Option)
        {
            OptionMembers = " ",CC,DC,Revisit,"Repeat";
        }
        field(3; "Sub Code"; Code[10])
        {
        }
        field(4; Description; Text[100])
        {
        }
        field(5; "Is Code"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code", Type, "Sub Code")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Sub Code", Description)
        {
        }
        fieldgroup(Brick; "Code", "Sub Code", Description)
        {
        }
    }
}

