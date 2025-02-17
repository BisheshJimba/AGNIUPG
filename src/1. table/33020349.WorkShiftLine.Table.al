table 33020349 "Work Shift Line"
{

    fields
    {
        field(1; "Entry No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Entry No." <> xRec."Entry No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."WorkShift No.");
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
        field(3; "Employee Name"; Text[90])
        {
        }
        field(4; "Changed Date"; Date)
        {
        }
        field(5; "Shift Code"; Code[10])
        {
            TableRelation = "Work Shift Master".Code;

            trigger OnValidate()
            begin
                WorkShiftRec.RESET;
                WorkShiftRec.SETRANGE(Code, "Shift Code");
                IF WorkShiftRec.FINDFIRST THEN BEGIN
                    Shift := WorkShiftRec.Description;
                    "In Time" := WorkShiftRec."In Time";
                    "Out Time" := WorkShiftRec."Out Time";
                    "Work Hours" := WorkShiftRec."Work Hours";
                    "Lunch Start" := WorkShiftRec."Lunch Start";
                    "Lunch End" := WorkShiftRec."Lunch End";
                    "Lunch Minutes" := WorkShiftRec."Lunch Minute";
                END;
            end;
        }
        field(6; Shift; Text[100])
        {
        }
        field(7; "In Time"; Time)
        {
        }
        field(8; "Out Time"; Time)
        {
        }
        field(9; "Lunch Start"; Time)
        {
        }
        field(10; "Lunch End"; Time)
        {
        }
        field(11; Remarks; Text[100])
        {
        }
        field(12; "Work Hours"; Decimal)
        {
        }
        field(13; "Lunch Minutes"; Decimal)
        {
        }
        field(14; Post; Boolean)
        {
        }
        field(15; "Posted By"; Code[20])
        {
        }
        field(16; "Posted Date"; Date)
        {
        }
        field(17; "No. Series"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Entry No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."WorkShift No.");
            NoSeriesMngt.InitSeries(HRSetup."WorkShift No.", xRec."No. Series", 0D, "Entry No.", "No. Series");
        END;
    end;

    var
        WorkShiftRec: Record "33020348";
        EmpRec: Record "5200";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        WorkShiftLineRec: Record "33020349";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WorkShiftLineRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."WorkShift No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."WorkShift No.", xRec."No. Series", WorkShiftLineRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."WorkShift No.");
            NoSeriesMngt.SetSeries(WorkShiftLineRec."Entry No.");
            Rec := WorkShiftLineRec;
            EXIT(TRUE);
        END;
    end;
}

