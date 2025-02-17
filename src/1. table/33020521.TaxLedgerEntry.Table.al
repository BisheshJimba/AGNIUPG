table 33020521 "Tax Ledger Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Tax Start Amount"; Decimal)
        {
        }
        field(4; "Tax End Amount"; Decimal)
        {
        }
        field(5; "Tax Rate"; Decimal)
        {
        }
        field(6; Difference; Decimal)
        {
        }
        field(7; "Sum of Tax"; Decimal)
        {
        }
        field(8; "Created Date"; Date)
        {
        }
        field(9; "Document No."; Code[20])
        {
        }
        field(10; "Percent Calculation"; Decimal)
        {
        }
        field(11; "Total Tax Sum"; Decimal)
        {
            CalcFormula = Sum("Tax Ledger Entry"."Percent Calculation" WHERE(Employee No.=FIELD(Employee No.),
                                                                              Document No.=FIELD(Document No.)));
            FieldClass = FlowField;
        }
        field(12;"Monthly Tax";Decimal)
        {
        }
        field(13;"Tax Split";Decimal)
        {
        }
        field(50000;"Tax Setup End Amt";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Document No.","Employee No.")
        {
            SumIndexFields = "Percent Calculation";
        }
    }

    fieldgroups
    {
    }
}

