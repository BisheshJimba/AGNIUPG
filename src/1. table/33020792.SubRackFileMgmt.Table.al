table 33020792 "SubRack - File Mgmt"
{
    Caption = 'SubRack - File Mgmt';

    fields
    {
        field(2; "Room Code"; Code[10])
        {
            TableRelation = "Room - File Mgmt"."Room Code" WHERE(Location Code=FIELD(Location Code));
        }
        field(3;"Rack Code";Code[10])
        {
            TableRelation = "Rack - File Mgmt"."Rack Code" WHERE (Location Code=FIELD(Location Code),
                                                                  Room Code=FIELD(Room Code));
        }
        field(5;"Sub Rack Code";Code[10])
        {
        }
        field(6;Description;Text[100])
        {
        }
        field(9;"Location Code";Code[20])
        {
            TableRelation = Location;
        }
        field(10;Capacity;Integer)
        {
        }
        field(11;Consumed;Integer)
        {
            CalcFormula = Count("File Ledger Entry" WHERE (Sub Rack No.=FIELD(Sub Rack Code),
                                                           Rack No.=FIELD(Rack Code),
                                                           Rack Location=FIELD(Location Code)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Location Code","Room Code","Rack Code","Sub Rack Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

