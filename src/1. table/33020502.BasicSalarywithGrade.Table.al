table 33020502 "Basic Salary with Grade"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*


    fields
    {
        field(1; Level; Code[20])
        {
            TableRelation = "Salary Level";
        }
        field(2; Grade; Code[10])
        {
            TableRelation = "Salary Grade";
        }
        field(3; "Basic Salary"; Decimal)
        {
        }
        field(4; "Additional Value"; Decimal)
        {
        }
        field(5; "Dearness Allowance"; Decimal)
        {
        }
        field(6; "Transportation Allowance"; Decimal)
        {
        }
        field(7; "Mobile Allowance"; Decimal)
        {
        }
        field(10; "TADA(per Day Nrs)"; Decimal)
        {
        }
        field(11; "TADA(Per Day Irs.)"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; Level, Grade)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

