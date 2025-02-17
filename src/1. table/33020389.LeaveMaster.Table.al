table 33020389 "Leave Master"
{

    fields
    {
        field(1; "Leave Code"; Code[10])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Leave Earn Per Month"; Decimal)
        {
        }
        field(4; "Max Leave Per Year"; Decimal)
        {
        }
        field(5; "Leave Type"; Option)
        {
            OptionMembers = Full,Half,NA;
        }
        field(6; Encashable; Boolean)
        {
        }
        field(7; "Encash Max Days of work"; Decimal)
        {
        }
        field(8; "Leave Applicable"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Leave Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

