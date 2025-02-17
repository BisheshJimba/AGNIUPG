table 33020037 "Gate Entry Location Setup"
{
    Caption = 'Gate Entry Location Setup';

    fields
    {
        field(1; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Inward,Outward';
            OptionMembers = Inward,Outward;
        }
        field(2; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(3; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Entry Type", "Location Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

