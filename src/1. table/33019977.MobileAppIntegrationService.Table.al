table 33019977 "Mobile App Integration Service"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Integration Type"; Option)
        {
            OptionCaption = ' ,Sales Pick,Sales Details,Transfer Pick,Transfer Details,Scanned QRs,Substitute Items,Bin Content,Item Journal Template,Item Journal Batch,Physical Inventory,Pending Orders';
            OptionMembers = " ","Sales Pick","Sales Details","Transfer Pick","Transfer Details","Scanned QRs","Substitute Items","Bin Content","Item Journal Template","Item Journal Batch","Physical Inventory","Pending Orders";
        }
        field(2; "Service Name"; Text[30])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = 'Page,Query,Codeunit';
            OptionMembers = "Page","Query","Codeunit";
        }
        field(4; "Company Name"; Text[30])
        {
            TableRelation = Company;
        }
    }

    keys
    {
        key(Key1; "Integration Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

