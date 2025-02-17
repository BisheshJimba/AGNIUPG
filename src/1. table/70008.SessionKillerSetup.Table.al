table 70008 "Session Killer Setup"
{
    // //> SESSIONKILLER001
    //   -this is the setup table for the session killer

    Caption = 'Session Killer Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(100; "Def. Max. Sessions Per User"; Integer)
        {
            Caption = 'Default Maximum Sessions Per User';
            MinValue = 0;
        }
        field(110; "No. Of Licensed User Sessions"; Integer)
        {
            Caption = 'No. Of Licensed User Sessions';
            MinValue = 0;
        }
        field(120; "License Per Database"; Boolean)
        {
            Caption = 'License Per Database';
        }
        field(130; "Optional Kill Session (Min.)"; Integer)
        {
            Caption = 'Optional Kill Session After N Minutes Idle';
            MinValue = 0;
        }
        field(140; "Check Every N Seconds"; Integer)
        {
            Caption = 'Check Every N Seconds';
            MinValue = 0;
        }
        field(150; "Always Kill Session (Min.)"; Integer)
        {
            Caption = 'Always Kill Session After N Minutes Idle';
            MinValue = 0;
        }
        field(160; "Last Check"; DateTime)
        {
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

