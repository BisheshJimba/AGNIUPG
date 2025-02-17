table 33020432 "Dealer Synchronization Data"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(20; Type; Option)
        {
            OptionCaption = 'Dealer Purchase,Dealer Sales';
            OptionMembers = "Dealer Purchase","Dealer Sales";
        }
        field(100; "Document Type"; Option)
        {
            OptionCaption = 'Sales Order';
            OptionMembers = "Sales Order";
        }
        field(101; "Document No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

