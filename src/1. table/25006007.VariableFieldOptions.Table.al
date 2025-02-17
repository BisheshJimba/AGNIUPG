table 25006007 "Variable Field Options"
{
    Caption = 'Variable Field Options';
    LookupPageID = 25006007;

    fields
    {
        field(5; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(10; "Variable Field Code"; Code[10])
        {
            Caption = 'Variable Field Code';
        }
        field(20; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Variable Field Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

