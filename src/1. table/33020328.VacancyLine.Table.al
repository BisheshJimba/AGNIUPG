table 33020328 "Vacancy Line"
{

    fields
    {
        field(1; "Vacancy No."; Code[20])
        {
            TableRelation = "Vacancy Header"."Vacany No.";
        }
        field(2; "Req. Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Selection Criterion".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Req. Description");
            end;
        }
        field(3; "Req. Description"; Text[250])
        {
            CalcFormula = Lookup("Selection Criterion".Description WHERE(Code = FIELD(Req. Code)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Vacancy No.", "Req. Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

