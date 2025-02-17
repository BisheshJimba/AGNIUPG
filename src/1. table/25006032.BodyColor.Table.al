table 25006032 "Body Color"
{
    Caption = 'Body Color';
    DrillDownPageID = 25006018;
    LookupPageID = 25006018;

    fields
    {
        field(4; "Code"; Code[20])
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

