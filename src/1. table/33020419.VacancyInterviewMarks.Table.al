table 33020419 "Vacancy Interview Marks"
{

    fields
    {
        field(1; "Applicant No."; Code[20])
        {
            TableRelation = "Internal Vacancy Applicant"."Applicant No.";
        }
        field(2; Interviewer; Option)
        {
            Description = ' ,Interviewer 1,Interviewer 2,Interviewer 3,Interviewer 4,Interviewer 5,Interviewer 6';
            OptionCaption = ' ,Interviewer 1,Interviewer 2,Interviewer 3,Interviewer 4,Interviewer 5,Interviewer 6';
            OptionMembers = " ","Interviewer 1","Interviewer 2","Interviewer 3","Interviewer 4","Interviewer 5","Interviewer 6";
        }
        field(3; "Interviewer Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Interviewer Code");
                IF EmpRec.FINDFIRST THEN
                    "Interviewer Name" := EmpRec."Full Name";
                IF EmpRec.COUNT = 0 THEN
                    "Interviewer Code" := '';
            end;
        }
        field(4; "Interviewer Name"; Text[90])
        {
        }
        field(5; "Poise Manner"; Decimal)
        {
            CaptionClass = GblStplMngt.getVariableField(33020419, 5);

            trigger OnValidate()
            begin
                Total;
            end;
        }
        field(6; Confidence; Decimal)
        {
            CaptionClass = GblStplMngt.getVariableField(33020419, 6);

            trigger OnValidate()
            begin
                Total;
            end;
        }
        field(7; "Leadership Capabilities"; Decimal)
        {
            CaptionClass = GblStplMngt.getVariableField(33020419, 7);

            trigger OnValidate()
            begin
                Total;
            end;
        }
        field(8; "Interpersonal Skill"; Decimal)
        {
            CaptionClass = GblStplMngt.getVariableField(33020419, 8);

            trigger OnValidate()
            begin
                Total;
            end;
        }
        field(9; "Job Knowledge"; Decimal)
        {
            CaptionClass = GblStplMngt.getVariableField(33020419, 9);

            trigger OnValidate()
            begin
                Total;
            end;
        }
        field(10; "Command over Language"; Decimal)
        {
            CaptionClass = GblStplMngt.getVariableField(33020419, 10);

            trigger OnValidate()
            begin
                Total;
            end;
        }
        field(11; "Total Marks"; Decimal)
        {
            CaptionClass = GblStplMngt.getVariableField(33020419, 11);
        }
        field(12; "Grand Total"; Decimal)
        {
            CalcFormula = Sum("Vacancy Interview Marks"."Total Marks" WHERE(Applicant No.=FIELD(Applicant No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;"Vacancy Code";Code[20])
        {
        }
        field(14;"Rank Interviewer 1";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Applicant No.","Vacancy Code",Interviewer)
        {
            Clustered = true;
            SumIndexFields = "Total Marks";
        }
    }

    fieldgroups
    {
    }

    var
        EmpRec: Record "5200";
        GblStplMngt: Codeunit "50000";
        Department: Record "33020337";

    [Scope('Internal')]
    procedure Total()
    begin
        "Total Marks" := "Poise Manner" + Confidence + "Leadership Capabilities" + "Interpersonal Skill" + "Job Knowledge"
                          + "Command over Language";
    end;
}

