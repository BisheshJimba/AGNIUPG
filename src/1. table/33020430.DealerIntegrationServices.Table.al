table 33020430 "Dealer Integration Services"
{

    fields
    {
        field(1; "Integration Type"; Option)
        {
            OptionCaption = 'Make,Model,Model Version,Item,Item Price,Model Version Price,Vehicle,Inv. Posting Group,Gen. Prod. Posting Group,VAT Prod. Posting Group,Item Tracking Code,Unit of Measure,Customer Price Group,Chart of Accounts,Resources,Resource Price,Item Variants,Dealer Invoice Header,Dealer Invoice Lines,Dealer Cr.Memo Header,Dealer Cr.Memo Lines,Item Ledger Entry,Dealer Contact,Dealer Customer,,,,,,,,,,,,,,,,,,,,,,,,,,Sales Header,Sales Line,Item Substitution,Customer Ledger';
            OptionMembers = Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants","Dealer Invoice Header","Dealer Invoice Lines","Dealer Cr.Memo Header","Dealer Cr.Memo Lines","Item Ledger Entry","Dealer Contact","Dealer Customer",,,,,,,,,,,,,,,,,,,,,,,,,,"Sales Header","Sales Line","Item Substitution","Customer Ledger";
        }
        field(2; "Service Name"; Text[30])
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = 'Page,Query,Codeunit';
            OptionMembers = "Page","Query","Codeunit";
        }
        field(4; "Last Synchronization Date"; Date)
        {
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

