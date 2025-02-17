table 33019862 "Service Scheme Line"
{
    Caption = 'Service Scheme Line';

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[80])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(4; "Discount %"; Decimal)
        {
        }
        field(5; "General Product Posting Group"; Code[20])
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

