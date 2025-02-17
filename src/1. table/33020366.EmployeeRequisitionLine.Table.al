table 33020366 "Employee Requisition Line"
{

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; "Code"; Code[10])
        {
            TableRelation = "Selection Criterion".Code;
        }
        field(3; Descripton; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

