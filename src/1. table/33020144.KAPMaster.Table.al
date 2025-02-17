table 33020144 "KAP Master"
{
    Caption = 'KAP Master';

    fields
    {
        field(1; "PipeLine Code"; Code[10])
        {
            TableRelation = "Pipeline Steps";
        }
        field(2; Activity; Code[10])
        {
        }
        field(3; Description; Text[150])
        {
        }
    }

    keys
    {
        key(Key1; "PipeLine Code", Activity)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

