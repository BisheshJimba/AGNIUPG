table 33020338 "Employee Payroll Information"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            Description = 'To be filled from payroll fields.';
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Housing Allowance"; Decimal)
        {
        }
        field(4; "House Rent"; Decimal)
        {
        }
        field(5; "Cost of Car"; Decimal)
        {
        }
        field(6; "Transport Allowances"; Decimal)
        {
        }
        field(7; "Special Allowances"; Decimal)
        {
        }
        field(8; "Eligible for Overtime"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

