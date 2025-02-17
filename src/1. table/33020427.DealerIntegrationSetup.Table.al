table 33020427 "Dealer Integration Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(20; "Base URL"; Text[100])
        {
        }
        field(21; Port; Integer)
        {
        }
        field(22; "Service Instance"; Text[30])
        {
        }
        field(23; Domain; Text[30])
        {
        }
        field(24; Username; Text[30])
        {
        }
        field(25; Password; Text[30])
        {
            ExtendedDatatype = Masked;
        }
        field(26; "Sync Sales Data To Dealer"; Boolean)
        {

            trigger OnValidate()
            begin
                "Elevated Privileges" := '';
            end;
        }
        field(27; "Elevated Privileges"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                TESTFIELD("Sync Sales Data To Dealer");
            end;
        }
        field(1000; "Last Synchronization Date"; Date)
        {
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

