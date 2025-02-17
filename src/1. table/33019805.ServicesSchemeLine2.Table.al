table 33019805 "Services Scheme Line 2"
{
    Caption = 'Service Scheme Line 2';

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(3; "General Product Posting Group"; Code[20])
        {
            TableRelation = "Gen. Product Posting Group".Code;
        }
    }

    keys
    {
        key(Key1; "Code", Type, "General Product Posting Group")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

