table 25006379 "Vehicle Cost Posting Setup"
{
    Caption = 'Vehicle Cost Posting Setup';
    LookupPageID = 25006454;

    fields
    {
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = '';
        }
        field(20; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(30; "Bal. G/L Account No."; Code[20])
        {
            Caption = 'Bal. G/L Account No.';
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; Type, "G/L Account No.", "Bal. G/L Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

