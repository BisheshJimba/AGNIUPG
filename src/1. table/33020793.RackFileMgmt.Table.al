table 33020793 "Rack - File Mgmt"
{
    Caption = 'Rack - File Mgmt';

    fields
    {
        field(1; "Room Code"; Code[10])
        {
            TableRelation = "Room - File Mgmt"."Room Code" WHERE(Location Code=FIELD(Location Code));
        }
        field(3;"Rack Code";Code[10])
        {
        }
        field(5;Description;Text[100])
        {
        }
        field(8;"Location Code";Code[20])
        {
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1;"Location Code","Room Code","Rack Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

