table 33020396 "Emp. Sal. Compoents with Value"
{

    fields
    {
        field(1; "Employee ID"; Code[10])
        {
        }
        field(2; "Salary Components code"; Code[10])
        {
            TableRelation = "Salary Components";

            trigger OnValidate()
            begin
                IF recSalaryComponents.GET("Salary Components code") THEN
                    Type := recSalaryComponents.Type;
            end;
        }
        field(3; "Salary Components Description"; Text[30])
        {
            CalcFormula = Lookup("Salary Components".Description WHERE(Code = FIELD(Salary Components code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Amount(Yearly)"; Decimal)
        {
        }
        field(5; "Amount(Monthly)"; Decimal)
        {
        }
        field(6; Type; Option)
        {
            OptionMembers = Salary,"Employee Contribution","Employer Contribution";
        }
    }

    keys
    {
        key(Key1; "Employee ID", "Salary Components code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recSalaryComponents: Record "33020395";
}

