table 33020390 "Attdence Machine"
{

    fields
    {
        field(1; "Mchine No"; Integer)
        {
        }
        field(2; "Machine Name"; Text[30])
        {
        }
        field(3; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1),
                                                          Dimension Value Type=FILTER(Standard));
        }
        field(4;IP;Code[20])
        {
        }
        field(5;Active;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Mchine No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

