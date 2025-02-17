table 33020251 "Free Service & PDI Rate"
{

    fields
    {
        field(1; "Model Code"; Code[20])
        {
            TableRelation = Model.Code;
        }
        field(2; "Job Type"; Code[20])
        {
            TableRelation = "Job Type Master".No. WHERE(Type = FILTER(Service));
        }
        field(3; "Service Rate"; Decimal)
        {
        }
        field(4; "Service Type"; Option)
        {
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service",Other;
        }
    }

    keys
    {
        key(Key1; "Model Code", "Job Type", "Service Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

