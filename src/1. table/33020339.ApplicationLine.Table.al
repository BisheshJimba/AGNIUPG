table 33020339 "Application Line"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation = Application.No.;
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
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

