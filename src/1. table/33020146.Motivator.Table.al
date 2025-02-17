table 33020146 Motivator
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            Description = 'Contact No.';
            TableRelation = Contact;
        }
        field(2; "Code"; Code[10])
        {
        }
        field(3; Description; Text[150])
        {
        }
        field(4; Selected; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Prospect No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

