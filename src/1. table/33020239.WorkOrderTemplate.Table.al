table 33020239 "Work Order Template"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Text Position"; Option)
        {
            OptionMembers = Header,Salutation,Body,Footer;
        }
        field(3; Description; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

