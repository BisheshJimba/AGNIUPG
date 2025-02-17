table 33020082 "Loan Risk Assesment"
{

    fields
    {
        field(10; "Loan No."; Code[20])
        {
        }
        field(20; "Code"; Code[10])
        {
            Editable = false;
        }
        field(30; Description; Text[250])
        {
            Editable = false;
        }
        field(40; "Weightage (A)"; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CalcTotalScore;
                CalcWeightedScore;
            end;
        }
        field(50; "Score (B)"; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CalcTotalScore;
            end;
        }
        field(60; "Customer Score (C)"; Integer)
        {

            trigger OnValidate()
            begin
                CalcWeightedScore;
            end;
        }
        field(61; "Weighted Score (A*C)"; Integer)
        {
            Editable = false;
        }
        field(62; "Total Score (A*B)"; Integer)
        {
            Editable = false;
        }
        field(50000; Remarks; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure CalcTotalScore()
    begin
        "Total Score (A*B)" := "Weightage (A)" * "Score (B)";
    end;

    [Scope('Internal')]
    procedure CalcWeightedScore()
    begin
        "Weighted Score (A*C)" := "Weightage (A)" * "Customer Score (C)";
    end;
}

