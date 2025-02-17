table 33019979 "Pending Documents"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Pending Transfers"; Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE(Picker ID=FIELD(User Filter)));
            FieldClass = FlowField;
        }
        field(3;"Pending Sales";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Picker ID=FIELD(User Filter)));
            FieldClass = FlowField;
        }
        field(4;"User Filter";Code[50])
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

