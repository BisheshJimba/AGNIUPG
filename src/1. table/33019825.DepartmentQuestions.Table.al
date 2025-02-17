table 33019825 "Department Questions"
{

    fields
    {
        field(1; "Department Code"; Code[20])
        {
            TableRelation = "Location Master".Code;
        }
        field(2; "Question Code"; Code[20])
        {
        }
        field(3; Questions; Text[250])
        {
        }
        field(4; "Total Marks"; Decimal)
        {
        }
        field(6; "Apprisal Type"; Option)
        {
            OptionMembers = " ",Self,Manager,"Manager 360";
        }
    }

    keys
    {
        key(Key1; "Department Code", "Question Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

