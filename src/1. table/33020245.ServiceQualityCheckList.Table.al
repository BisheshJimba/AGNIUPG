table 33020245 "Service Quality CheckList"
{

    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; Group; Option)
        {
            OptionMembers = Engine,"Clutch & Transmission","Front & Rear Axle","Steering & Suspension",Brakes,Electricals,Tippers,"Chassis & Body",Tyres;
        }
        field(3; Description; Text[100])
        {
        }
        field(4; "Make Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; Group)
        {
        }
    }

    fieldgroups
    {
    }
}

