table 33019961 Distance
{
    Caption = 'Distance';

    fields
    {
        field(1; "From City Code"; Code[10])
        {
            NotBlank = true;
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("From City Name");
            end;
        }
        field(2; "From City Name"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(From City Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "To City Code"; Code[10])
        {
            NotBlank = true;
            TableRelation = "Post Code".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("To City Name");
            end;
        }
        field(4; "To City Name"; Text[30])
        {
            CalcFormula = Lookup("Post Code".City WHERE(Code = FIELD(To City Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Total Km"; Decimal)
        {
        }
        field(6; Remarks; Text[120])
        {
        }
    }

    keys
    {
        key(Key1; "From City Code", "To City Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

