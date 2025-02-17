table 33019866 "Scheme Details"
{

    fields
    {
        field(1; "Membership Card No."; Code[20])
        {
        }
        field(2; "Scheme Type"; Code[20])
        {
            TableRelation = "Service Scheme Line";
        }
        field(3; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";
        }
        field(4; "Discount %"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Membership Card No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        MembershipDetails: Record "33019864";
        ServiceScheme: Record "33019862";
}

