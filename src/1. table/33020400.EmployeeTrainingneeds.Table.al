table 33020400 "Employee Training needs"
{

    fields
    {
        field(2; "Employee Code"; Code[20])
        {
        }
        field(3; "Request No."; Code[20])
        {
            TableRelation = "Training Requests Header"."Tr. Req. No.";
        }
        field(4; "Training Code"; Code[20])
        {
            TableRelation = "Training List"."Training Code";
        }
        field(5; "Training Topic"; Text[30])
        {
            TableRelation = "Training List"."Training Topic" WHERE(Training Topic=FIELD(Training Topic));

            trigger OnValidate()
            begin
                TrainingList.RESET;
                TrainingList.SETRANGE("Training Topic","Training Topic");
                IF TrainingList.FINDFIRST THEN BEGIN
                "Training Code" := TrainingList."Training Code";
                END;
            end;
        }
        field(6;"Fiscal Year";Code[9])
        {
        }
        field(7;"Request Date";Date)
        {
            CalcFormula = Lookup("Training Requests Header"."Requested Date" WHERE (Tr. Req. No.=FIELD(Request No.)));
            FieldClass = FlowField;
        }
        field(8;"Completed Date";Date)
        {
            CalcFormula = Lookup("Training Requests Header"."Completed Date" WHERE (Tr. Req. No.=FIELD(Request No.)));
            FieldClass = FlowField;
        }
        field(9;Completed;Boolean)
        {
            FieldClass = Normal;
        }
        field(10;"Duration (Months)";Decimal)
        {
        }
        field(11;"New Training";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Employee Code","Training Topic","New Training")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        TrainingList: Record "33020358";
}

