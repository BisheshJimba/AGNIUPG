table 33020421 "Work Experience Line"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Organization; Text[100])
        {
        }
        field(4; Department; Text[100])
        {
        }
        field(5; Position; Text[100])
        {
        }
        field(6; "Duration in Months"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

