table 33019973 Supplier
{
    Caption = 'Supplier';
    DrillDownPageID = 50000;
    LookupPageID = 50000;

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Purchase Reference No. Series"; Code[10])
        {
            TableRelation = "No. Series";
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

