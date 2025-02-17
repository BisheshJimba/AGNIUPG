table 33020431 "Dealer Integration Log"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Dealer Code"; Code[20])
        {
        }
        field(3; "Tenant ID"; Text[30])
        {
        }
        field(4; Message; Text[250])
        {
        }
        field(5; Date; Date)
        {
        }
        field(6; Time; Time)
        {
        }
        field(7; "Integration Type"; Option)
        {
            OptionCaption = 'Make,Model,Model Version,Item,Item Price,Model Version Price,Vehicle,Inv. Posting Group,Gen. Prod. Posting Group,VAT Prod. Posting Group,Item Tracking Code,Unit of Measure,Customer Price Group,Chart of Accounts,Resources,Resource Price,Item Variants,Dealer Invoice Header,Dealer Invoice Lines,Dealer Cr.Memo Header,Dealer Cr.Memo Lines,Item Ledger Entry,Dealer Contact,Dealer Customer,,,,,,,,,,,,,,,,,,,,,,,,,,Sales Header,Sales Line,Item Substitution,Customer Ledger';
            OptionMembers = Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants","Dealer Invoice Header","Dealer Invoice Lines","Dealer Cr.Memo Header","Dealer Cr.Memo Lines","Item Ledger Entry","Dealer Contact","Dealer Customer",,,,,,,,,,,,,,,,,,,,,,,,,,"Sales Header","Sales Line","Item Substitution","Customer Ledger";
        }
        field(8; "Table ID"; Integer)
        {
        }
        field(9; "Primay Key 1 Code"; Code[50])
        {
        }
        field(10; "Primay Key 2 Code"; Code[50])
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

