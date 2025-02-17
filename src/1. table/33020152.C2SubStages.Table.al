table 33020152 "C2 SubStages"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = Contact;
        }
        field(2; "Code"; Code[10])
        {
        }
        field(3; Description; Text[150])
        {
        }
        field(4; Color; Code[10])
        {
        }
        field(5; Done; Boolean)
        {
        }
        field(10; "Prospect Line No."; Integer)
        {
        }
        field(25; "Division Type"; Option)
        {
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;
        }
        field(30; Active; Boolean)
        {
            Description = 'CNY.CRM';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Prospect No.", "Prospect Line No.", "Code", "Division Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

