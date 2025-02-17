table 33020365 "Employee Requisition"
{

    fields
    {
        field(1; "Entry No."; Code[10])
        {

            trigger OnValidate()
            begin
                IF "Entry No." <> xRec."Entry No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Employee Req. No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Entry Date"; Date)
        {
        }
        field(3; Department; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department));
        }
        field(4; Designation; Code[10])
        {
        }
        field(5; "New Position"; Boolean)
        {
        }
        field(6; "Replaced Person Name"; Text[30])
        {
        }
        field(7; Reason; Text[100])
        {
        }
        field(8; "Reporting Status"; Text[100])
        {
        }
        field(9; "Job Description"; Text[250])
        {
        }
        field(10; "Experience Reqd."; Integer)
        {
        }
        field(11; "Ideal Age"; Integer)
        {
        }
        field(12; "Recruitment Date"; Date)
        {
        }
        field(13; "No. Series"; Code[20])
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
            HRSetup.TESTFIELD("Employee Req. No.");
            NoSeriesMngt.InitSeries(HRSetup."Employee Req. No.", xRec."No. Series", 0D, "Entry No.", "No. Series");
        END;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        EmpReq: Record "33020365";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        EmpReq := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD("Employee Req. No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Employee Req. No.", xRec."No. Series", EmpReq."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Employee Req. No.");
            NoSeriesMngt.SetSeries(EmpReq."Entry No.");
            Rec := EmpReq;
            EXIT(TRUE);
        END;
    end;
}

