table 33020369 "Employee Training History"
{

    fields
    {
        field(2; "Employee Code"; Code[20])
        {
        }
        field(3; "Request No."; Code[20])
        {

            trigger OnValidate()
            begin
                TrainingHeader.RESET;
                TrainingHeader.SETRANGE("Tr. Req. No.", "Request No.");
                IF TrainingHeader.FINDFIRST THEN BEGIN
                    "From Date" := TrainingHeader."From Date";
                    "To Date" := TrainingHeader."To Date";
                END;
            end;
        }
        field(4; "Training Code"; Code[20])
        {
            TableRelation = "Training List"."Training Code";
        }
        field(5; "Training Topic"; Text[30])
        {
        }
        field(6; "Fiscal Year"; Code[9])
        {
        }
        field(7; "Request Date"; Date)
        {
            CalcFormula = Lookup("Training Requests Header"."Requested Date" WHERE(Tr. Req. No.=FIELD(Request No.)));
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
        field(10;"From Date";Date)
        {
            FieldClass = Normal;
        }
        field(11;"To Date";Date)
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1;"Employee Code","Training Code","Request No.","From Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        TrainingHeader: Record "33020359";
}

