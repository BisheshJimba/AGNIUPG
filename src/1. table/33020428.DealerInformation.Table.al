table 33020428 "Dealer Information"
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(2; "Tenant ID"; Text[30])
        {
        }
        field(3; Active; Boolean)
        {

            trigger OnValidate()
            begin
                IF Active THEN
                    "Activation Date" := TODAY
                ELSE
                    "Activation Date" := 0D;

                TESTFIELD("Tenant ID");
                TESTFIELD("Company Name");
            end;
        }
        field(4; "Activation Date"; Date)
        {
        }
        field(5; "Company Name"; Text[30])
        {
        }
        field(50; "Integration Type"; Option)
        {
            OptionCaption = 'Make,Model,Model Version,Item,Item Price,Model Version Price,Vehicle,Inv. Posting Group,Gen. Prod. Posting Group,VAT Prod. Posting Group,Item Tracking Code,Unit of Measure,Customer Price Group,Chart of Accounts,Resources,Resource Price,Item Variants,Dealer Invoice Header,Dealer Invoice Lines,Dealer Cr.Memo Header,Dealer Cr.Memo Lines,Item Ledger Entry,Dealer Contact,Dealer Customer,,,,,,,,,,,,,,,,,,,,,,,,,,Sales Header,Sales Line,Item Substitution,Customer Ledger';
            OptionMembers = Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants","Dealer Invoice Header","Dealer Invoice Lines","Dealer Cr.Memo Header","Dealer Cr.Memo Lines","Item Ledger Entry","Dealer Contact","Dealer Customer",,,,,,,,,,,,,,,,,,,,,,,,,,"Sales Header","Sales Line","Item Substitution","Customer Ledger";
        }
        field(100; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE(No.=FIELD(Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Synchronize Master Data";Boolean)
        {
        }
        field(102;"Last Synchronization Date";Date)
        {
        }
        field(103;"Regional Manager Email";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Customer No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

