table 33020019 "LC Bank Cr. Limit Details"
{

    fields
    {
        field(1; "Bank No."; Code[20])
        {
        }
        field(2; "From Date"; Date)
        {
        }
        field(3; "To Date"; Date)
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "Utilized Amount"; Decimal)
        {
            Editable = false;
        }
        field(6; "Remaining Amount"; Decimal)
        {
        }
        field(7; "Utilized Amount Amended"; Decimal)
        {
            Editable = false;
        }
        field(8; "Date Filter"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Bank No.", "From Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

