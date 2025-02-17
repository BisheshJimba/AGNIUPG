page 33020310 "Process Page-Probn Appraisal"
{
    SourceTable = Table5200;

    layout
    {
        area(content)
        {
            field(StartFiscalYear; StartFiscalYear)
            {
                Caption = 'Starting Date of Fiscal Year (dd/mm/yyyy)';
            }
            field(EndFiscalYear; EndFiscalYear)
            {
                Caption = 'Ending Date of Fiscal Year(dd/mm/yyyy)';

                trigger OnValidate()
                begin
                    "Eng-Nep".RESET;
                    "Eng-Nep".SETRANGE("Nepali Date", EndFiscalYear);
                    IF "Eng-Nep".FINDFIRST THEN BEGIN
                        FiscalYear := "Eng-Nep"."Fiscal Year";
                    END ELSE
                        ERROR('Please Enter the Date in correct format!');
                end;
            }
            field(FiscalYear; FiscalYear)
            {
                Caption = 'Fiscal Year';
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000004>")
            {
                Caption = 'Do Probational Appraisal';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Appraisal.RESET;
                    Appraisal.SETRANGE("Employee Code", "No.");
                    Appraisal.SETRANGE(Appraisal."Fiscal Year", FiscalYear);
                    Appraisal.SETRANGE(Appraisal."Appraisal Type", Appraisal."Appraisal Type"::Probational);
                    IF Appraisal.FIND('-') THEN BEGIN
                        // MESSAGE('Appraisal for the selected employee is already done for this Fiscal Year');
                        //Setting Apprisal Page with selected Record
                        EmpAppr1.RESET;
                        EmpAppr1.SETRANGE("Employee Code", "No.");
                        EmpAppr1.SETRANGE("Fiscal Year", FiscalYear);
                        EmpAppr1.SETRANGE(EmpAppr1."Appraisal Type", EmpAppr1."Appraisal Type"::Probational);
                        AppraisalPage.SETTABLEVIEW(EmpAppr1);
                        AppraisalPage.SETRECORD(EmpAppr1);
                        AppraisalPage.RUN;
                        CurrPage.CLOSE;
                    END
                    ELSE BEGIN
                        IF EndFiscalYear = '' THEN BEGIN
                            ERROR('EndFiscalYear empty');
                        END ELSE BEGIN
                            EmpAppr1.INIT;
                            EmpAppr1."Employee Code" := "No.";
                            EmpAppr1.Name := "Full Name";
                            EmpAppr1.Designation := "Job Title";
                            EmpAppr1.Department := "Department Code";
                            EmpAppr1.Branch := "Branch Code";
                            EmpAppr1."Appraiser 1" := "First Appraisal ID";
                            EmpRec.RESET;
                            EmpRec.SETRANGE("No.", "First Appraisal ID");
                            IF EmpRec.FINDFIRST THEN BEGIN
                                EmpAppr1."Appraiser 1 Name" := EmpRec."Full Name";
                                EmpAppr1."Appraiser 1 Designation" := EmpRec."Job Title";
                            END;
                            EmpAppr1."Join Date" := "Employment Date";
                            EmpAppr1."Level/Grade" := "Grade Code";
                            EmpAppr1."Appraisal Type" := EmpAppr1."Appraisal Type"::Probational;
                            EmpAppr1."Fiscal Year" := FiscalYear;
                            EmpAppr1.StartFiscalYear := StartFiscalYear;
                            EmpAppr1.EndFiscalYear := EndFiscalYear;
                            EmpAppr1.ADEndFiscal := STPL.getEngDate(EndFiscalYear);
                            CalculateLastPromotionDays();
                            CalculateNoOfServicePeriod();
                            CalculateTotalExperienceOutsid();
                            InsertQualification();
                            EmpAppr1.INSERT(TRUE);

                            EmpAppr1.RESET;
                            //EmpAppr1.SETRANGE("Entry No.","Entry No.");
                            EmpAppr1.SETRANGE("Employee Code", "No.");
                            EmpAppr1.SETRANGE("Fiscal Year", FiscalYear);
                            EmpAppr1.SETRANGE(EmpAppr1."Appraisal Type", EmpAppr1."Appraisal Type"::Probational);
                            AppraisalPage.SETTABLEVIEW(EmpAppr1);
                            AppraisalPage.SETRECORD(EmpAppr1);
                            AppraisalPage.RUN;
                            CurrPage.CLOSE;
                        END;
                    END;
                end;
            }
        }
    }

    trigger OnInit()
    begin
        "Eng-Nep".RESET;
        "Eng-Nep".SETRANGE("Open Date for Appraisal", TRUE);
        IF "Eng-Nep".FINDLAST THEN BEGIN
            StartFiscalYear := "Eng-Nep"."Nepali Date";
        END;

        "Eng-Nep1".RESET;
        "Eng-Nep1".SETRANGE("Close Date for Appraisal", TRUE);
        IF "Eng-Nep1".FINDLAST THEN BEGIN
            EndFiscalYear := "Eng-Nep1"."Nepali Date";
            FiscalYear := "Eng-Nep1"."Fiscal Year";
        END;
    end;

    var
        FiscalYear: Text[30];
        "Eng-Nep": Record "33020302";
        StartFiscalYear: Text[30];
        EndFiscalYear: Text[30];
        EmpAppr1: Record "33020361";
        AppraisalPage: Page "33020444";
        Appraisal: Record "33020361";
        EmpRec: Record "5200";
        STPL: Codeunit "50000";
        "Eng-Nep1": Record "33020302";

    [Scope('Internal')]
    procedure CalculateLastPromotionDays()
    var
        EmployeeActivity: Record "33020401";
        LastPromotionDate: Date;
        WorkYears: Decimal;
        WorkMonths: Decimal;
        WorkDays: Decimal;
        Days: Decimal;
        STPL: Codeunit "50000";
        ADEndFiscal: Date;
        WorkedYears: Decimal;
        WorkedMonths: Decimal;
        WorkedDays: Decimal;
    begin
        ADEndFiscal := STPL.getEngDate(EndFiscalYear);


        CLEAR(Days);
        EmployeeActivity.RESET;
        EmployeeActivity.SETRANGE("Employee Code", "No.");
        EmployeeActivity.SETFILTER(Activity, 'Promotion');
        IF EmployeeActivity.FINDLAST THEN BEGIN
            LastPromotionDate := EmployeeActivity."Effective Date";

            Days := ADEndFiscal - LastPromotionDate;
            IF Days >= 365 THEN BEGIN
                WorkYears := Days / 365;
                Days := WorkYears - ROUND(WorkYears, 1, '<');
                Days := Days * 365;
                WorkMonths := Days / 30;
                Days := WorkMonths - ROUND(WorkMonths, 1, '<');
                Days := Days * 30;
                EmpAppr1."LastPromotion Years 1" := FORMAT(ROUND(WorkYears, 1, '<')) + ' Years, ' + FORMAT(ROUND(WorkMonths, 1, '<')) + ' Months,' +
                           FORMAT(ROUND(Days, 1, '<')) + ' Days';
            END ELSE
                IF Days < 365 THEN BEGIN
                    WorkMonths := Days / 30;
                    Days := WorkMonths - ROUND(WorkMonths, 1, '<');
                    Days := Days * 30;
                    EmpAppr1."LastPromotion Years 1" := FORMAT(ROUND(WorkMonths, 1, '<')) + ' Months,' + FORMAT(ROUND(Days, 1, '<')) + ' Days';
                    EmpAppr1."Last Promotion Date" := LastPromotionDate;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure CalculateNoOfServicePeriod()
    var
        WorkYears: Decimal;
        WorkMonths: Decimal;
        WorkDays: Decimal;
        Days: Decimal;
        WorkedYears: Decimal;
        WorkedMonths: Decimal;
        WorkedDays: Decimal;
        ADEndFiscal: Date;
    begin
        ADEndFiscal := STPL.getEngDate(EndFiscalYear);

        Days := ADEndFiscal - "Employment Date";
        IF Days >= 365 THEN BEGIN
            WorkYears := Days / 365;
            Days := WorkYears - ROUND(WorkYears, 1, '<');
            Days := Days * 365;
            WorkMonths := Days / 30;
            Days := WorkMonths - ROUND(WorkMonths, 1, '<');
            Days := Days * 30;
            EmpAppr1."No. of years in Service Period" := FORMAT(ROUND(WorkYears, 1, '<')) + ' Years, ' +
                       FORMAT(ROUND(WorkMonths, 1, '<')) + ' Months,' + FORMAT(ROUND(Days, 1, '<')) + ' Days';
        END ELSE
            IF Days < 365 THEN BEGIN
                WorkMonths := Days / 30;
                Days := WorkMonths - ROUND(WorkMonths, 1, '<');
                Days := Days * 30;
                EmpAppr1."No. of years in Service Period" := FORMAT(ROUND(WorkMonths, 1, '<')) + ' Months,' + FORMAT(ROUND(Days, 1, '<')) + ' Days';
            END;
    end;

    [Scope('Internal')]
    procedure CalculateTotalExperienceOutsid()
    var
        ExperienceRec: Record "33020421";
        TotalExperience: Decimal;
    begin
        CLEAR(TotalExperience);

        ExperienceRec.RESET;
        ExperienceRec.SETRANGE("Employee Code", "No.");
        IF ExperienceRec.FINDFIRST THEN BEGIN
            REPEAT
                TotalExperience += ExperienceRec."Duration in Months";
            UNTIL ExperienceRec.NEXT = 0;
        END;
        EmpAppr1."Total Experience outside" := TotalExperience;
    end;

    [Scope('Internal')]
    procedure InsertQualification()
    var
        EducationRec: Record "33020420";
    begin
        EducationRec.RESET;
        EducationRec.SETRANGE("Employee Code", "No.");
        IF EducationRec.FINDLAST THEN BEGIN
            IF EducationRec.Degree = EducationRec.Degree::Others THEN
                EmpAppr1.Qualification := EducationRec.Faculty;
            IF EducationRec.Degree = EducationRec.Degree::SLC THEN
                EmpAppr1.Qualification := EducationRec.Faculty;
            IF EducationRec.Degree = EducationRec.Degree::"10+2/ Intermediate" THEN
                EmpAppr1.Qualification := EducationRec.Faculty;
            IF EducationRec.Degree = EducationRec.Degree::Bachelors THEN
                EmpAppr1.Qualification := EducationRec.Faculty;
            IF EducationRec.Degree = EducationRec.Degree::Professional THEN
                EmpAppr1.Qualification := EducationRec.Faculty;
            IF EducationRec.Degree = EducationRec.Degree::Master THEN
                EmpAppr1.Qualification := EducationRec.Faculty;
        END;
    end;
}

