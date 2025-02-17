table 33020791 "Room - File Mgmt"
{
    Caption = 'Room - File Mgmt';

    fields
    {
        field(1; "Room Code"; Code[10])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(5; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Location Code", "Room Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

