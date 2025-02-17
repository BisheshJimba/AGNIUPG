table 33019876 "Companywise Make Filter Setup"
{

    fields
    {
        field(1; "Company Name"; Text[30])
        {
            TableRelation = Company;
        }
        field(2; "Make Code Filter"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

