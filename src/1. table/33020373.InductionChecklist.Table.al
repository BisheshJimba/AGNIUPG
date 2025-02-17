table 33020373 "Induction Checklist"
{

    fields
    {
        field(1; "CheckList Code"; Code[15])
        {
        }
        field(2; "CheckList Description"; Text[50])
        {
        }
        field(3; Submitted; Boolean)
        {

            trigger OnValidate()
            begin
                "Submitted By" := USERID;
                "Submitted Datetime" := CURRENTDATETIME;
            end;
        }
        field(4; "Submitted By"; Code[100])
        {
        }
        field(5; "Submitted Datetime"; DateTime)
        {
        }
    }

    keys
    {
        key(Key1; "CheckList Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

