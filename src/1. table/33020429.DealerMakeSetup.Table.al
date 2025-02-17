table 33020429 "Dealer Make Setup"
{

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            TableRelation = "Dealer Information";
        }
        field(2; "Make Code"; Code[20])
        {
            TableRelation = Make;
        }
        field(3; "Model Code"; Code[20])
        {
            TableRelation = Model.Code;
        }
    }

    keys
    {
        key(Key1; "Customer No.", "Make Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

