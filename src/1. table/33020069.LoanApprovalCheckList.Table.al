table 33020069 "Loan Approval Check List"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Vehicle Finance Header"."Loan No.";
        }
        field(2; "Check List Code"; Code[20])
        {
            TableRelation = "Loan Approval Check List Setup".Code;
        }
        field(3; Description; Text[100])
        {
            CalcFormula = Lookup("Loan Approval Check List Setup".Description WHERE(Code = FIELD(Check List Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Description 2"; Text[100])
        {
            CalcFormula = Lookup("Loan Approval Check List Setup"."Description 2" WHERE(Code = FIELD(Check List Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Is Mandatory?"; Boolean)
        {
            CalcFormula = Lookup("Loan Approval Check List Setup".Mandatory WHERE(Code = FIELD(Check List Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Is Accomplished?"; Boolean)
        {

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                IF "Is Accomplished?" THEN
                    "Bypassed By User" := USERID
                ELSE
                    "Bypassed By User" := '';
            end;
        }
        field(7; Remarks; Text[100])
        {
        }
        field(8; Exceptional; Boolean)
        {

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                IF NOT UserSetup."Can Approve Vehicle Loan" THEN
                    ERROR(Text50000);
                IF Exceptional THEN
                    "Bypassed By User" := USERID
                ELSE
                    "Bypassed By User" := '';
            end;
        }
        field(9; "Bypassed By User"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(10; "Document Type"; Option)
        {
            OptionCaption = 'Application,Loan';
            OptionMembers = Application,Loan;
        }
        field(50030; "Application Status"; Code[50])
        {
            CalcFormula = Lookup("Loan Approval Check List Setup"."Application Status" WHERE(Code = FIELD(Check List Code)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Check List Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        UserSetup: Record "91";
        Text50000: Label 'You do not have permission to mark exceptional case.';
}

