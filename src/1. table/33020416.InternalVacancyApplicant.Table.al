table 33020416 "Internal Vacancy Applicant"
{

    fields
    {
        field(1; "Applicant No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Applicant No." <> xRec."Applicant No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Internal Applicant No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Vacancy Code"; Code[20])
        {
            TableRelation = "Internal Vacancy"."Vacancy Code";

            trigger OnValidate()
            begin
                IntVacancyRec.RESET;
                IntVacancyRec.SETRANGE("Vacancy Code", "Vacancy Code");
                IF IntVacancyRec.FINDFIRST THEN
                    "Post Applied For" := IntVacancyRec."For Job Title";
            end;
        }
        field(3; "Post Applied For"; Text[80])
        {
        }
        field(4; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "First Name" := EmpRec."First Name";
                    "Middle Name" := EmpRec."Middle Name";
                    "Last Name" := EmpRec."Last Name";
                    "Date of Birth" := EmpRec."Birth Date";
                    "Marital Status" := EmpRec."Marital Status";
                    Gender := EmpRec.Gender;
                    Nationality := EmpRec.Nationality;
                    "Citizenship No." := EmpRec."Citizenship No.";
                    P_WardNo := EmpRec.P_WardNo;
                    P_VDC_NP := EmpRec.P_VDC_NP;
                    P_District := EmpRec.P_District;
                    T_WardNo := EmpRec.T_WardNo;
                    T_VDC_NP := EmpRec.T_VDC_NP;
                    T_District := EmpRec.T_District;
                    "Company E-mail" := EmpRec."Company E-Mail";
                    "Phone No." := EmpRec."Phone No.";
                    "Mobile Phone No." := EmpRec."Mobile Phone No.1";
                END;

                EducationRec.RESET;
                EducationRec.SETRANGE("Employee Code", "Employee Code");
                IF EducationRec.FINDFIRST THEN BEGIN
                    REPEAT
                        VacancyEduRec.RESET;
                        VacancyEduRec.INIT;
                        VacancyEduRec."Line No." := EducationRec."Line No.";
                        VacancyEduRec."Applicant No." := "Applicant No.";
                        VacancyEduRec."Employee Code" := "Employee Code";
                        VacancyEduRec.Degree := EducationRec.Degree;
                        VacancyEduRec.Faculty := EducationRec.Faculty;
                        VacancyEduRec."College/ Institution" := EducationRec."College/ Institution";
                        VacancyEduRec.University := EducationRec."University/ Board";
                        VacancyEduRec."Percentage/ GPA" := EducationRec."Percentage/ GPA";
                        VacancyEduRec."Passed Year" := EducationRec."Passed Year";
                        VacancyEduRec.INSERT;
                    UNTIL EducationRec.NEXT = 0;
                END;

                WorkExpRec.RESET;
                WorkExpRec.SETRANGE("Employee Code", "Employee Code");
                IF WorkExpRec.FINDFIRST THEN BEGIN
                    REPEAT
                        VacancyWorkRec.RESET;
                        VacancyWorkRec.INIT;
                        VacancyWorkRec."Line No." := WorkExpRec."Line No.";
                        VacancyWorkRec."Applicant No." := "Applicant No.";
                        VacancyWorkRec."Employee Code" := "Employee Code";
                        VacancyWorkRec.Organization := WorkExpRec.Organization;
                        VacancyWorkRec.Department := WorkExpRec.Department;
                        VacancyWorkRec.Position := WorkExpRec.Position;
                        VacancyWorkRec.Duration := WorkExpRec."Duration in Months";
                        VacancyWorkRec.INSERT;
                    UNTIL WorkExpRec.NEXT = 0;
                END;
            end;
        }
        field(5; "First Name"; Text[30])
        {
        }
        field(6; "Middle Name"; Text[30])
        {
        }
        field(7; "Last Name"; Text[30])
        {
        }
        field(8; "Date of Birth"; Date)
        {
        }
        field(9; "Marital Status"; Option)
        {
            OptionCaption = ' ,Single,Married ';
            OptionMembers = " ",Single,"Married ";
        }
        field(10; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(11; Nationality; Option)
        {
            OptionMembers = " ",Nepalese,Indian;
        }
        field(12; "Citizenship No."; Text[15])
        {
        }
        field(13; P_WardNo; Code[5])
        {
        }
        field(14; P_VDC_NP; Text[30])
        {
        }
        field(15; P_District; Text[30])
        {
        }
        field(16; T_WardNo; Code[5])
        {
        }
        field(17; T_VDC_NP; Text[30])
        {
        }
        field(18; T_District; Text[30])
        {
        }
        field(19; "Company E-mail"; Text[30])
        {
        }
        field(20; "Phone No."; Text[20])
        {
        }
        field(21; "Mobile Phone No."; Text[22])
        {
        }
        field(71; Language; Text[30])
        {
        }
        field(72; "Computer Knowledge"; Text[80])
        {
        }
        field(73; "Driving License"; Option)
        {
            OptionMembers = " ",Yes,No;
        }
        field(74; Vehicle; Option)
        {
            OptionMembers = " ",Yes,No;
        }
        field(75; "Select for Written Exam"; Boolean)
        {
        }
        field(76; "WE- Posted by"; Code[20])
        {
        }
        field(77; "WE- Posted Date"; Date)
        {
        }
        field(78; "Written Marks"; Decimal)
        {
        }
        field(79; "Select for Interview"; Boolean)
        {
        }
        field(80; "I- Posted by"; Code[20])
        {
        }
        field(81; "I- Posted Date"; Date)
        {
        }
        field(90; "No. Series"; Code[20])
        {
        }
        field(91; "B_Passed Year"; Text[30])
        {
        }
        field(92; "User ID"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Applicant No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Applicant No." = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Internal Applicant No.");
            NoSeriesMngt.InitSeries(HRSetup."Internal Applicant No.", xRec."No. Series", 0D, "Applicant No.", "No. Series");
        END;
    end;

    var
        IntVacancyRec: Record "33020415";
        IntAppRec: Record "33020416";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        EmpRec: Record "5200";
        EducationRec: Record "33020420";
        WorkExpRec: Record "33020421";
        VacancyEduRec: Record "33020417";
        VacancyWorkRec: Record "33020418";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        IntAppRec := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Internal Applicant No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Internal Applicant No.", xRec."No. Series", IntAppRec."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Internal Applicant No.");
            NoSeriesMngt.SetSeries(IntAppRec."Applicant No.");
            Rec := IntAppRec;
            EXIT(TRUE);
        END;
    end;
}

