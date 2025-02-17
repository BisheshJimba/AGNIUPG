table 33020388 "Employee Salary Profile"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.SETRANGE("No.", "Employee Code");
                IF EmpRec.FIND('-') THEN
                    "Grade Code" := EmpRec."Grade Code";
            end;
        }
        field(2; "Grade Code"; Code[10])
        {
        }
        field(3; "Basic Salary"; Decimal)
        {
        }
        field(4; "Dearness Allowance"; Decimal)
        {
        }
        field(5; "Other Allowance"; Decimal)
        {
        }
        field(6; PF; Boolean)
        {
        }
        field(7; CIT; Boolean)
        {
        }
        field(8; "CIT Percentage"; Decimal)
        {
        }
        field(9; Insurance; Decimal)
        {
        }
        field(10; "Last Modified Date"; Date)
        {
        }
        field(11; "Modified By"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Employee Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        EmpRec: Record "5200";
}

