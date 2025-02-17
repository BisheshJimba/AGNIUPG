table 25006052 "Vehicle Interior"
{
    Caption = 'Vehicle Interior';
    DrillDownPageID = 25006044;
    LookupPageID = 25006044;

    fields
    {
        field(4; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make.Code;
        }
        field(30; Description; Text[30])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code", "Make Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

