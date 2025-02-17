table 33020559 "Employee Code Mapping"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Employee Mapping Code"; Code[20])
        {
        }
        field(3; "Employee Name"; Text[80])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE(No.=FIELD(Employee Code)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Employee Code","Employee Mapping Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

