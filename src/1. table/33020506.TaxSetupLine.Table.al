table 33020506 "Tax Setup Line"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = "Tax Setup Header";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Start Amount"; Decimal)
        {
        }
        field(4; "End Amount"; Decimal)
        {
        }
        field(5; "Tax Rate"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Tax Rate")
        {
        }
    }

    fieldgroups
    {
    }
}

