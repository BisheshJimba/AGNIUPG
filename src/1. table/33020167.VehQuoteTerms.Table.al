table 33020167 "Veh. Quote Terms"
{

    fields
    {
        field(1; "Model Code"; Code[20])
        {
            TableRelation = Model.Code;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Term; Text[250])
        {
        }
        field(4; Type; Option)
        {
            OptionCaption = 'Individual,Sub Dealer';
            OptionMembers = Individual,"Sub Dealer";
        }
    }

    keys
    {
        key(Key1; Type, "Model Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

