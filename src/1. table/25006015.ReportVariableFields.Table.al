table 25006015 "Report Variable Fields"
{
    Caption = 'Report Variable Fields';

    fields
    {
        field(10; "Report ID"; Integer)
        {
            Caption = 'Report ID';
            TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(14; "Field Position ID"; Integer)
        {
            Caption = 'Field Position ID';
        }
        field(20; "Variable Field Code"; Code[20])
        {
            Caption = 'Variable Field Code';
            TableRelation = "Variable Field";
        }
    }

    keys
    {
        key(Key1; "Report ID", "Field Position ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

