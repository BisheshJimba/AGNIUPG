table 33020360 "Training Requests Line"
{

    fields
    {
        field(10; "Tr. Req. No."; Code[20])
        {
        }
        field(20; "Line No."; Integer)
        {
        }
        field(30; "Tr. No."; Code[20])
        {
            TableRelation = "Training List"."Training Code";
        }
        field(40; "Training Topic"; Text[80])
        {
            TableRelation = "Training List"."Training Topic";
        }
        field(50; "Part. Employee"; Code[20])
        {
            TableRelation = Employee.No.;
        }
        field(60; "Part. Employee Name"; Text[30])
        {
        }
        field(63; "Participant from Organization"; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Tr. Req. No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TrainingRequestsHeaderRec.RESET;
        TrainingRequestsHeaderRec.SETRANGE("Tr. Req. No.", "Tr. Req. No.");
        IF TrainingRequestsHeaderRec.FINDFIRST THEN BEGIN
            "Tr. No." := TrainingRequestsHeaderRec."Training Code";
            "Training Topic" := TrainingRequestsHeaderRec."Training Topic";
            //"Completed Date" := TrainingRequestsHeaderRec."Completed Date";
        END;
    end;

    var
        TrainingRequestsHeaderRec: Record "33020359";
}

