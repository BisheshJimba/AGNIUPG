table 25006763 "Ordering Price Type"
{
    Caption = 'Ordering Price Type';
    LookupPageID = 25006854;

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Inbound Time"; DateFormula)
        {
            Caption = 'Inbound Time';
        }
        field(40; "Outbound Time"; DateFormula)
        {
            Caption = 'Outbound Time';
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

