table 33020350 "HR User Permission"
{

    fields
    {
        field(1; "User ID"; Code[20])
        {
            TableRelation = Table2000000002;
        }
        field(2; "View Field/Button"; Boolean)
        {
        }
        field(3; "Approve/Disapprove"; Boolean)
        {
        }
        field(4; "Reports Filter"; Boolean)
        {
        }
        field(5; "Employee Filter"; Code[20])
        {
            TableRelation = Employee.No.;
        }
        field(6; "Super Permission"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

