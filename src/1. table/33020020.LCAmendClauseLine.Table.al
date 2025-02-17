table 33020020 "LC Amend Clause Line"
{

    fields
    {
        field(1; "LC No."; Code[20])
        {
            TableRelation = "LC Amend. Details".No.;
        }
        field(2; "Amend No."; Code[20])
        {
            TableRelation = "LC Amend. Details"."Version No.";
        }
        field(3; "Clause No."; Code[10])
        {
            TableRelation = "LC Clause"."Clause No.";
        }
        field(4; "Clause Description"; Text[250])
        {
            CalcFormula = Lookup("LC Clause"."Clause Description" WHERE(Clause No.=FIELD(Clause No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;Remarks;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"LC No.","Amend No.","Clause No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

