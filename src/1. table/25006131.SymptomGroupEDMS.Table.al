table 25006131 "Symptom Group EDMS"
{
    Caption = 'DMS Symptom Group';
    LookupPageID = 25006170;

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Name; Text[70])
        {
            Caption = 'Name';
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

