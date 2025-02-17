table 25006182 "Tire Management Setup"
{
    Caption = 'Tire Management Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Check Tire Unique"; Boolean)
        {
            Caption = 'Check Tire Unique in Tire Entries';
        }
        field(20; "Tire Management Active"; Boolean)
        {
            Caption = 'Tire Management Active';
        }
        field(30; "Default Platform Template"; Code[10])
        {
            Caption = 'Default Platform Template';
            TableRelation = "Platform Template".Code;
        }
        field(40; "Set First Values"; Boolean)
        {
            Caption = 'Set First Values';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

