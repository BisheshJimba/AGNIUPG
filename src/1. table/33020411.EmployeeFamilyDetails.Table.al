table 33020411 "Employee Family Details"
{

    fields
    {
        field(1; "Emp Family No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Emp Family No." <> xRec."Emp Family No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Emp Family No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "Employee Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(3; "Employee Name"; Text[150])
        {
        }
        field(4; Name; Text[30])
        {
        }
        field(5; Address; Text[30])
        {
        }
        field(6; District; Text[30])
        {
        }
        field(7; Gender; Text[150])
        {
        }
        field(8; "Date of Birth"; Date)
        {
        }
        field(9; "Email Address"; Text[150])
        {
        }
        field(10; "Phone No."; Text[150])
        {
        }
        field(11; Relation; Option)
        {
            OptionCaption = ',Wife,Husband,Daughter,Son,Mother,Father,Grand Mother,Grand Father,Grand Daughter,Grand Son,Mother-in-Law,Father-in-Law';
            OptionMembers = ,Wife,Husband,Daughter,Son,Mother,Father,"Grand Mother","Grand Father","Grand Daughter","Grand Son","Mother-in-Law","Father-in-Law";
        }
        field(12; Married; Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(13; "Married Date"; Date)
        {
        }
        field(14; Employed; Option)
        {
            OptionCaption = ',Yes,No';
            OptionMembers = ,Yes,No;
        }
        field(15; Designation; Text[100])
        {
        }
        field(16; Office; Text[100])
        {
        }
        field(17; "Joined On"; Date)
        {
        }
        field(18; "Work Details"; Text[250])
        {
        }
        field(19; "No. Series"; Code[20])
        {
        }
        field(20; Posted; Boolean)
        {
        }
        field(21; "Posted Date"; Date)
        {
        }
        field(22; "Posted By"; Code[50])
        {
        }
        field(23; "Date of Demise"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Employee Code", "Emp Family No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Emp Family No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Emp Family No.");
            NoSeriesMngt.InitSeries(HRSetup."Emp Family No.", xRec."No. Series", 0D, "Emp Family No.", "No. Series");
        END;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        EmpFamilyRec: Record "33020411";
        EmpRec: Record "5200";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        EmpFamilyRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Emp Family No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Emp Family No.", xRec."No. Series", EmpFamilyRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Emp Family No.");
            NoSeriesMngt.SetSeries(EmpFamilyRec."Emp Family No.");
            Rec := EmpFamilyRec;
            EXIT(TRUE);
        END;
    end;
}

