table 33020197 Reprospected
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = Contact;
        }
        field(2; "Version No."; Integer)
        {
        }
        field(4; Date; Date)
        {
        }
        field(5; Remarks; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Prospect No.", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

