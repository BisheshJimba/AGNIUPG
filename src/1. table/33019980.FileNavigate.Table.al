table 33019980 "File Navigate"
{
    Caption = 'File Navigate';

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(6; "Document No."; Code[20])
        {
        }
        field(12; "File No."; Code[20])
        {
        }
        field(15; "Rack Location"; Code[20])
        {
            TableRelation = Location;
        }
        field(20; "Room No."; Code[10])
        {
            TableRelation = "Room - File Mgmt"."Room Code" WHERE(Location Code=FIELD(Rack Location));
        }
        field(21;"Rack No.";Code[10])
        {
            TableRelation = "Rack - File Mgmt"."Rack Code" WHERE (Location Code=FIELD(Rack Location),
                                                                  Room Code=FIELD(Room No.));
        }
        field(22;"Sub Rack No.";Code[10])
        {
            TableRelation = "SubRack - File Mgmt"."Sub Rack Code" WHERE (Location Code=FIELD(Rack Location),
                                                                         Room Code=FIELD(Room No.),
                                                                         Rack Code=FIELD(Rack No.));
        }
        field(25;"Table Name";Text[100])
        {
            Caption = 'Table Name';
        }
        field(30;"No. of Records";Integer)
        {
            Caption = 'No. of Records';
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

