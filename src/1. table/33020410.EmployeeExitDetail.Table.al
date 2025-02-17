table 33020410 "Employee Exit Detail"
{

    fields
    {
        field(1; "Exit No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Exit No." <> xRec."Exit No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Exit No.");
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
                    Desgination := EmpRec."Job Title";
                    "Joining Date" := EmpRec."Employment Date";
                    Department := EmpRec."Department Name";
                END;

                CompInfo.RESET;
                IF CompInfo.FINDFIRST THEN BEGIN
                    Company := CompInfo.Name;
                END;
            end;
        }
        field(3; "Employee Name"; Text[90])
        {
        }
        field(4; Desgination; Text[80])
        {
        }
        field(5; "Joining Date"; Date)
        {
        }
        field(6; Department; Text[80])
        {
        }
        field(7; "Date of Leaving"; Date)
        {
        }
        field(8; Company; Text[80])
        {
        }
        field(9; "No. of years"; Text[30])
        {
        }
        field(10; "Position at time of Joining"; Text[80])
        {
        }
        field(11; "No. of Promotion Since Joining"; Integer)
        {
        }
        field(12; "Areas/Funtion worked in"; Text[200])
        {
        }
        field(13; Voluntary; Option)
        {
            OptionMembers = ,"Better Opportunity","Personal Reasons",Relocation,Retirement,"Further Education",Other;
        }
        field(14; Involuntary; Option)
        {
            OptionMembers = ,Attendance,"Violation of Company Policy","Lay Off",Reorganization,"Position Eliminated",Other;
        }
        field(15; "Voluntary Other"; Text[50])
        {
        }
        field(16; "Involuntary Other"; Text[50])
        {
        }
        field(17; "Explain Separation"; Text[100])
        {
        }
        field(18; "Supervisor Consistent"; Option)
        {
            OptionMembers = ,"Almost Always",Usually,Sometimes,Never;
        }
        field(19; "Supervisor Recognition"; Option)
        {
            OptionMembers = ,"Almost Always",Usually,Sometimes,Never;
        }
        field(20; "Supervisor Complaints"; Option)
        {
            OptionMembers = ,"Almost Always",Usually,Sometimes,Never;
        }
        field(21; "Supervisor Sensitive"; Option)
        {
            OptionMembers = ,"Almost Always",Usually,Sometimes,Never;
        }
        field(22; "Supervisor Feedback"; Option)
        {
            OptionMembers = ,"Almost Always",Usually,Sometimes,Never;
        }
        field(23; "Supervisor Receptive"; Option)
        {
            OptionMembers = ,"Almost Always",Usually,Sometimes,Never;
        }
        field(24; "Supervisor Policies"; Option)
        {
            OptionMembers = ,"Almost Always",Usually,Sometimes,Never;
        }
        field(25; "Rate Policies"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(26; "Rate System"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(27; "Rate Management"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(28; "Rate Colleages"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(29; "Rate Subordinate"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(30; "Rate Cooperation"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(31; "Rate other Dept"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(32; "Rate Training"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(33; "Rate Comp Performance"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(34; "Rate Career Development"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(35; "Rate Physical Working"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(36; "Rate Comment"; Text[100])
        {
        }
        field(37; "Emp Salary"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(38; "Emp Incentives"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(39; "Emp Paid Holidays"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(40; "Emp Medical Plan"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(41; "Emp Sick Leave"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(42; "Emp Loan Facility"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(43; "Emp Gratuity Plan"; Option)
        {
            OptionMembers = ,Excellent,Good,Fair,Poor;
        }
        field(44; "Like most Job"; Text[100])
        {
        }
        field(45; "Like least Job"; Text[100])
        {
        }
        field(46; "Expected Y/N"; Option)
        {
            OptionMembers = ,Yes,No;
        }
        field(47; "Expected Commet"; Text[80])
        {
        }
        field(48; Workload; Option)
        {
            OptionMembers = ,"Too heavy","About right","Too Light";
        }
        field(49; "Prevent from Leaving"; Text[150])
        {
        }
        field(50; "Recommend to friend"; Option)
        {
            OptionMembers = ,"Most definitely","With reservations",No;
        }
        field(51; "Recomment to friend comment"; Text[100])
        {
        }
        field(52; "Suggestion for better"; Text[150])
        {
        }
        field(53; Posted; Boolean)
        {
        }
        field(54; "Posted Date"; Date)
        {
        }
        field(55; "No. Series"; Code[20])
        {
        }
        field(56; "Posted By"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Exit No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Exit No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Exit No.");
            NoSeriesMngt.InitSeries(HRSetup."Exit No.", xRec."No. Series", 0D, "Exit No.", "No. Series");
        END;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        EmpExitRec: Record "33020410";
        EmpRec: Record "5200";
        CompInfo: Record "79";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        EmpExitRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Exit No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Exit No.", xRec."No. Series", EmpExitRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Exit No.");
            NoSeriesMngt.SetSeries(EmpExitRec."Exit No.");
            Rec := EmpExitRec;
            EXIT(TRUE);
        END;
    end;
}

