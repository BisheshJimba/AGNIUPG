table 33020415 "Internal Vacancy"
{

    fields
    {
        field(1; "Vacancy Code"; Code[20])
        {
        }
        field(2; "For Job Title Code"; Code[20])
        {
            TableRelation = "Job Title".Code;
        }
        field(3; "For Job Title"; Text[50])
        {
            CalcFormula = Lookup("Job Title".Description WHERE(Code = FIELD(For Job Title Code)));
            FieldClass = FlowField;
        }
        field(4; Posted; Boolean)
        {
        }
        field(5; "Posted By"; Code[20])
        {
        }
        field(6; "Posted Date"; Date)
        {
        }
        field(7; Closed; Boolean)
        {
            FieldClass = Normal;
        }
        field(8; "Closed Date"; Date)
        {

            trigger OnLookup()
            begin
                IF "Closed Date" = (TODAY + 1) THEN
                    Closed := TRUE;
            end;
        }
        field(9; "Closed By"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Vacancy Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

