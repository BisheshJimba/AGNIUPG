table 33019848 "Customer Complain Line"
{

    fields
    {
        field(1; "Complain No."; Code[20])
        {
        }
        field(3; "Remarks/Complain/Suggestions"; Text[230])
        {

            trigger OnValidate()
            begin
                CustComp.RESET;
                CustComp.SETRANGE("No.", "Complain No.");
                IF CustComp.FINDFIRST THEN BEGIN
                    VIN := CustComp.VIN;
                END;
            end;
        }
        field(4; "User ID"; Code[50])
        {
        }
        field(5; "Date of Entry"; Date)
        {
            Editable = false;
        }
        field(6; "Line No."; Integer)
        {
        }
        field(7; "Job Card No."; Code[20])
        {
            TableRelation = "Service Header EDMS".No. WHERE(VIN = FIELD(VIN));
        }
        field(8; VIN; Code[20])
        {
        }
        field(9; "Posted Job Card No."; Code[20])
        {
            CalcFormula = Lookup("Posted Serv. Order Header".No. WHERE(Order No.=FIELD(Job Card No.)));
                Editable = false;
                FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Complain No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        "User ID" := USERID;

        "Date of Entry" := TODAY;
    end;

    var
        UserSetup: Record "91";
        CustComp: Record "33019847";
}

