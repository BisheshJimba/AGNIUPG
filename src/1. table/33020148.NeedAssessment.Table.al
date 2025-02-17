table 33020148 "Need Assessment"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = "Sales Progress Details".Field1;
        }
        field(2; "Code"; Code[10])
        {
        }
        field(3; Description; Text[150])
        {
        }
        field(4; Answer; Text[250])
        {
        }
        field(5; "Sales Progress Code"; Code[10])
        {
            TableRelation = "Sales Progress Details".Field2;
        }
    }

    keys
    {
        key(Key1; "Prospect No.", "Sales Progress Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

