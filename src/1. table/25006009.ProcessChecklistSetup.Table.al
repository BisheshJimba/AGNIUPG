table 25006009 "Process Checklist Setup"
{
    Caption = 'Process Checklist Setup';
    DrillDownPageID = 70000;

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(100; "Process Checklist Nos."; Code[10])
        {
            Caption = 'Process Checklist Nos.';
            TableRelation = "No. Series";
        }
        field(33020235; "Default Template"; Code[10])
        {
            TableRelation = "Process Checklist Template";
        }
        field(33020236; "PDI Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33020237; "Veh. Delivery Chklist Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

