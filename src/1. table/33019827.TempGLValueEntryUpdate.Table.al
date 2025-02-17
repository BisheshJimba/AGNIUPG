table 33019827 "Temp GL Value Entry Update"
{

    fields
    {
        field(1; "Table No."; Integer)
        {
        }
        field(2; "Entry No."; Integer)
        {
        }
        field(3; Amount; Decimal)
        {
        }
        field(4; "Debit Amount"; Decimal)
        {
        }
        field(5; "Credit Amount"; Decimal)
        {
        }
        field(6; "Cost Amount Act"; Decimal)
        {
        }
        field(7; "Cost Post GL"; Decimal)
        {
        }
        field(8; "Posting date"; Date)
        {
        }
        field(9; Modified; Boolean)
        {
        }
        field(10; "Cost Per Unit"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Table No.", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

