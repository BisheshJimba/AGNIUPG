table 33019976 "Mobile App Integration Setup"
{
    DataPerCompany = false;

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

