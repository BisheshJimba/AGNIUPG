table 33019861 "Max Veh. Discount Limit Line"
{

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "Model Version Filter"; Code[180])
        {
        }
        field(3; "Max. Discount Amount"; Decimal)
        {
        }
        field(4; "Starting Date"; Date)
        {
        }
        field(5; "Ending Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "User ID", "Model Version Filter", "Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

