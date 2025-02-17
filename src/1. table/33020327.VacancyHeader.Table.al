table 33020327 "Vacancy Header"
{

    fields
    {
        field(1; "Job Title"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Job Title".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Job Description");
            end;
        }
        field(2; "Job Description"; Text[120])
        {
            CalcFormula = Lookup("Job Title".Description WHERE(Code = FIELD(Job Title)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Opening Date"; Date)
        {
            Description = 'Caption is changed to show date filter in reports request form.';
            Editable = false;

            trigger OnValidate()
            begin
                "Additional Opening Date" := STPLSysMngt.getNepaliDate("Opening Date");
            end;
        }
        field(4; "Closing Date"; Date)
        {

            trigger OnValidate()
            begin
                "Additional Closing Date" := STPLSysMngt.getNepaliDate("Closing Date");
            end;
        }
        field(5; Closed; Boolean)
        {
            Editable = false;
        }
        field(6; Approved; Boolean)
        {
        }
        field(7; Disapproved; Boolean)
        {
        }
        field(8; "Reopened Date"; Date)
        {

            trigger OnValidate()
            begin
                "Additional Reopen Date" := STPLSysMngt.getNepaliDate("Reopened Date");
            end;
        }
        field(9; "Additional Opening Date"; Code[20])
        {
            CaptionClass = STPLSysMngt.getVariableField(33020327, 9);
            Editable = false;
        }
        field(10; "Additional Closing Date"; Code[20])
        {
            CaptionClass = STPLSysMngt.getVariableField(33020327, 10);
            Editable = false;
        }
        field(11; Remarks; Text[250])
        {
        }
        field(12; "Approved Date"; Date)
        {

            trigger OnValidate()
            begin
                "Additional Approved Date" := STPLSysMngt.getNepaliDate("Approved Date");
            end;
        }
        field(13; "Disapproved Date"; Date)
        {

            trigger OnValidate()
            begin
                "Additional Disapproved Date" := STPLSysMngt.getNepaliDate("Disapproved Date");
            end;
        }
        field(14; "Approved By"; Code[50])
        {
        }
        field(15; "Disapproved By"; Code[50])
        {
        }
        field(16; "Closed By"; Code[50])
        {
        }
        field(17; "Additional Approved Date"; Code[20])
        {
            CaptionClass = STPLSysMngt.getVariableField(33020327, 17);
            Editable = false;
        }
        field(18; "Additional Disapproved Date"; Code[20])
        {
            CaptionClass = STPLSysMngt.getVariableField(33020327, 18);
            Editable = false;
        }
        field(19; "Additional Reopen Date"; Code[20])
        {
            CaptionClass = STPLSysMngt.getVariableField(33020327, 19);
            Editable = false;
        }
        field(20; Department; Code[20])
        {
            TableRelation = "Location Master".Code;
        }
        field(21; "Vacancy Type"; Option)
        {
            OptionMembers = " ","Full Time","Part Time",Contractual;
        }
        field(22; "Vacany No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Vacany No." <> xRec."Vacany No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Vacancy Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(23; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(24; "Provident Fund"; Boolean)
        {
        }
        field(25; "Citizenship Investment Trust"; Boolean)
        {
        }
        field(26; "Travel Allowances"; Boolean)
        {
        }
        field(27; "Daily Allowances"; Boolean)
        {
        }
        field(28; "Paid Training Facility"; Boolean)
        {
        }
        field(29; Overtime; Boolean)
        {
        }
        field(30; "Medical Insurance"; Boolean)
        {
        }
        field(31; "Life Insurance"; Boolean)
        {
        }
        field(32; "Profit Bonus"; Boolean)
        {
        }
        field(33; "Leave Encashment"; Boolean)
        {
        }
        field(34; Loan; Boolean)
        {
        }
        field(35; "Dashain Bonus"; Boolean)
        {
        }
        field(36; "Disability Insurance"; Boolean)
        {
        }
        field(37; "Pregnency Leave"; Boolean)
        {
        }
        field(38; Partner; Code[20])
        {
            TableRelation = "Recruitment Partner".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Partner Name");
            end;
        }
        field(39; "Partner Name"; Text[100])
        {
            CalcFormula = Lookup("Recruitment Partner".Name WHERE(Code = FIELD(Partner)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Job Assigned Date"; Date)
        {

            trigger OnValidate()
            begin
                "Add. Job Assigned Date" := STPLSysMngt.getNepaliDate("Job Assigned Date");
            end;
        }
        field(41; "Add. Job Assigned Date"; Code[20])
        {
            CaptionClass = STPLSysMngt.getVariableField(33020327, 41);

            trigger OnValidate()
            begin
                "Job Assigned Date" := STPLSysMngt.getEngDate("Add. Job Assigned Date");
            end;
        }
        field(42; "No. of Openings"; Integer)
        {
        }
        field(43; "Paid Vacation"; Boolean)
        {
        }
        field(44; "Paid Sick Leave"; Boolean)
        {
        }
        field(45; "Job Locaiton"; Text[30])
        {
        }
        field(46; "Experience Reqd."; Text[5])
        {
        }
        field(47; "Ideal Age"; Integer)
        {
        }
        field(48; "New Position"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Vacany No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        AddJobLine.RESET;
        AddJobLine.SETRANGE("Vacancy No.", "Vacany No.");
        IF AddJobLine.FIND('-') THEN
            AddJobLine.DELETEALL;
    end;

    trigger OnInsert()
    begin
        IF "Vacany No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Vacancy Nos.");
            NoSeriesMngt.InitSeries(HRSetup."Vacancy Nos.", xRec."No. Series", 0D, "Vacany No.", "No. Series");
        END;

        VALIDATE("Opening Date", TODAY);
    end;

    var
        STPLSysMngt: Codeunit "50000";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        AddJob: Record "33020327";
        AddJobLine: Record "33020328";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        AddJob := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD("Vacancy Nos.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Vacancy Nos.", xRec."No. Series", AddJob."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Vacancy Nos.");
            NoSeriesMngt.SetSeries(AddJob."Vacany No.");
            Rec := AddJob;
            EXIT(TRUE);
        END;
    end;
}

