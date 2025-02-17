table 25006066 "ASRA/EPC VIN Change"
{
    Caption = 'ASRA/EPC VIN Change';

    fields
    {
        field(10; "From VIN Part"; Code[20])
        {
            Caption = 'From VIN Part';
        }
        field(20; "To VIN Part"; Code[20])
        {
            Caption = 'To VIN Part';
        }
    }

    keys
    {
        key(Key1; "From VIN Part")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

