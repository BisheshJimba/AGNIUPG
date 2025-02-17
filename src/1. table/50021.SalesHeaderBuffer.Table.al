table 50021 "Sales Header Buffer"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Customer No."; Code[20])
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Sales Order Created"; Boolean)
        {
        }
        field(5; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
        }
        field(6; "Last Synchronization Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;
}

