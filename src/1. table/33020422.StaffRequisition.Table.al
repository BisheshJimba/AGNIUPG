table 33020422 "Staff Requisition"
{

    fields
    {
        field(1; "Requisition No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Requisition No." <> xRec."Requisition No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Staff Requisition No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Department Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department),
                                                          Blocked = CONST(No));

            trigger OnValidate()
            begin
                LocationRec.RESET;
                LocationRec.SETRANGE(Code, "Department Code");
                IF LocationRec.FINDFIRST THEN BEGIN
                    "Department Name" := LocationRec.Description;
                END;
            end;
        }
        field(3; "Department Name"; Text[80])
        {
        }
        field(4; "Job Title Code"; Code[10])
        {
            TableRelation = "Job Title".Code WHERE(Minimum Education=CONST(No));

            trigger OnValidate()
            begin
                JobTitleRec.RESET;
                JobTitleRec.SETRANGE(Code, "Job Title Code");
                IF JobTitleRec.FINDFIRST THEN BEGIN
                    "Job Title" := JobTitleRec.Description;
                END;
            end;
        }
        field(5; "Job Title"; Text[80])
        {
        }
        field(6; "Branch Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Branch),
                                                          Blocked = CONST(No));

            trigger OnValidate()
            begin
                LocationRec.RESET;
                LocationRec.SETRANGE(Code, "Branch Code");
                IF LocationRec.FINDFIRST THEN BEGIN
                    "Branch Name" := LocationRec.Description;
                END;
            end;
        }
        field(7; "Supervisor Code"; Code[20])
        {
            TableRelation = Employee.No. WHERE(Status = CONST(Confirmed));

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Supervisor Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "Supervisor Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(8; Segment; Text[50])
        {
        }
        field(9; "Date Required"; Date)
        {
        }
        field(10; "Nature of Manpower"; Option)
        {
            Description = ' ,Intern,Trainee,Outsource Staff,Casual Staff,OJT,Attachments';
            OptionCaption = ' ,Intern,Trainee,Outsource Staff,Casual Staff,OJT,Attachments';
            OptionMembers = " ",Intern,Trainee,"Outsource Staff","Casual Staff",OJT,Attachments;
        }
        field(11; "No. of Staff Required"; Integer)
        {
        }
        field(12; "Duration (in months)"; Decimal)
        {
        }
        field(13; "Brief Description of Duties"; Text[80])
        {
        }
        field(14; Qualifications; Text[30])
        {
        }
        field(15; Experiences; Text[30])
        {
        }
        field(16; "Skills and Qualities"; Text[30])
        {
        }
        field(17; Requirement; Option)
        {
            Description = ' ,Replacement,New Positions';
            OptionCaption = ' ,Replacement,New Positions';
            OptionMembers = " ",Replacement,"New Positions";
        }
        field(18; "Staff Replaced"; Code[20])
        {
            TableRelation = Employee.No.;
        }
        field(19; "Staff Replaced Name"; Text[90])
        {
        }
        field(20; "Reason for replacement"; Text[60])
        {
        }
        field(21; "HOD Posted"; Boolean)
        {
        }
        field(22; "HOD Posted By"; Code[20])
        {
        }
        field(23; "HOD Posted Date"; Date)
        {
        }
        field(24; "Remark by HR"; Text[60])
        {
        }
        field(25; "Date of submission in HRC"; Date)
        {
        }
        field(26; Status; Option)
        {
            Description = ' ,Approved,Not Approved,On Hold,Resubmit';
            OptionCaption = ' ,Approved,Not Approved,On Hold,Resubmit';
            OptionMembers = " ",Approved,"Not Approved","On Hold",Resubmit;
        }
        field(27; "Resubmit (in Weeks)"; Integer)
        {
        }
        field(28; "No. Series"; Code[20])
        {
        }
        field(29; "Branch Name"; Text[80])
        {
        }
        field(30; "Supervisor Name"; Text[90])
        {
        }
        field(31; "HR Posted By"; Code[20])
        {
        }
        field(32; "HR Posted"; Boolean)
        {
        }
        field(33; "HR Posted Date"; Date)
        {
        }
        field(34; Replacement; Boolean)
        {
        }
        field(35; "Remarks on Approval"; Text[60])
        {
        }
    }

    keys
    {
        key(Key1; "Requisition No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Requisition No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Staff Requisition No.");
            NoSeriesMngt.InitSeries(HRSetup."Staff Requisition No.", xRec."No. Series", 0D, "Requisition No.", "No. Series");
        END;
    end;

    var
        StaffReqRec: Record "33020422";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        JobTitleRec: Record "33020325";
        LocationRec: Record "33020337";
        EmpRec: Record "5200";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        StaffReqRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Staff Requisition No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Staff Requisition No.", xRec."No. Series", StaffReqRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Staff Requisition No.");
            NoSeriesMngt.SetSeries(StaffReqRec."Requisition No.");
            Rec := StaffReqRec;
            EXIT(TRUE);
        END;
    end;
}

