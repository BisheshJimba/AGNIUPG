table 33020405 "Disciplinary Issue Record"
{

    fields
    {
        field(1; "Discipline No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Discipline No." <> xRec."Discipline No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Discipline No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee Code"; Code[30])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE(EmpRec."No.", "Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    Name := EmpRec."Full Name";
                    Designation := EmpRec."Job Title";
                    Grade := EmpRec."Grade Code";
                    Department := EmpRec."Exam Department Code";
                    Branch := EmpRec."Branch Name";
                END;
            end;
        }
        field(3; Name; Text[150])
        {
        }
        field(4; Designation; Text[50])
        {
        }
        field(5; Grade; Code[10])
        {
        }
        field(6; Department; Text[50])
        {
        }
        field(7; Branch; Text[70])
        {
        }
        field(8; "Issue Reported Date (AD)"; Date)
        {
        }
        field(9; Issue; Text[150])
        {
        }
        field(10; Status; Option)
        {
            OptionCaption = 'New,In-Progress,Done,Closed,On-Hold';
            OptionMembers = New,"In-Progress",Done,Closed,"On-Hold";
        }
        field(11; "Spastikaran Date (AD)"; Date)
        {
        }
        field(12; "Spastikaran Received Date (AD)"; Date)
        {
        }
        field(13; "Spastikaran Jawaf Date(AD)"; Date)
        {
        }
        field(14; "Spastikaran Jawaf Received(AD)"; Date)
        {
        }
        field(15; "Action"; Text[30])
        {
        }
        field(16; "Action Date"; Date)
        {
        }
        field(17; "Action WEF"; Text[30])
        {
        }
        field(18; Remarks; Text[250])
        {
        }
        field(19; Posted; Boolean)
        {
        }
        field(20; "Posted Date"; Date)
        {
        }
        field(21; "No. Series"; Code[20])
        {
        }
        field(22; "Issue Reported Date (BS)"; Text[30])
        {
        }
        field(23; "Posted By"; Code[30])
        {
        }
        field(24; "Spastikaran Date(BS)"; Text[30])
        {
        }
        field(25; "Spastikaran Received Date(BS)"; Text[30])
        {
        }
        field(26; "Spastikaran Jawaf Date(BS)"; Text[30])
        {
        }
        field(27; "Spastikaran Jawaf Received(BS)"; Text[30])
        {
        }
        field(28; "Fiscal Year"; Code[10])
        {
        }
        field(29; test; Code[10])
        {
            TableRelation = "Job Title".Code;
        }
    }

    keys
    {
        key(Key1; "Discipline No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Discipline No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Discipline No.");
            NoSeriesMngt.InitSeries(HRSetup."Discipline No.", xRec."No. Series", 0D, "Discipline No.", "No. Series");
        END;
    end;

    var
        EmpRec: Record "5200";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        DisciplineRec: Record "33020405";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        DisciplineRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Discipline No.", DisciplineRec."Discipline No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Discipline No.", xRec."No. Series", DisciplineRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Discipline No.");
            NoSeriesMngt.SetSeries(DisciplineRec."Discipline No.");
            Rec := DisciplineRec;
            EXIT(TRUE);
        END;
    end;
}

