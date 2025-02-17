page 33020304 "Process Page-Second Appraisal"
{
    SourceTable = Table5200;

    layout
    {
        area(content)
        {
            field(StartFiscalYear; StartFiscalYear)
            {
                Caption = 'Starting Date of Fiscal Year (yyyy/mm/dd)';
            }
            field(EndFiscalYear; EndFiscalYear)
            {
                Caption = 'Ending Date of Fiscal Year(yyyy/mm/dd)';

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
                Caption = 'Do Second Annual Appraisal';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Appraisal.RESET;
                    Appraisal.SETRANGE("Employee Code", "No.");
                    Appraisal.SETRANGE(Appraisal."Fiscal Year", FiscalYear);
                    Appraisal.SETRANGE(Appraisal."Appraisal Type", Appraisal."Appraisal Type"::Annual);
                    Appraisal.SETRANGE(IsAppraised1, TRUE);
                    IF Appraisal.FIND('-') THEN BEGIN
                        //MESSAGE('Appraisal for the selected employee is already done for this Fiscal Year');
                        //Setting Apprisal Page with selected Record
                        EmpAppr1.RESET;
                        EmpAppr1.SETRANGE("Employee Code", "No.");
                        EmpAppr1.SETRANGE("Fiscal Year", FiscalYear);
                        EmpAppr1.SETRANGE(EmpAppr1."Appraisal Type", EmpAppr1."Appraisal Type"::Annual);
                        AppraisalPage.SETTABLEVIEW(EmpAppr1);
                        AppraisalPage.SETRECORD(EmpAppr1);
                        AppraisalPage.RUN;
                        CurrPage.CLOSE;
                    END
                    ELSE BEGIN
                        IF EndFiscalYear = '' THEN BEGIN
                            ERROR('EndFiscalYear empty');
                        END ELSE BEGIN
                            ERROR('Appraisal for Employee: %1 has not been posted by First Appraisal', "Full Name");
                            CurrPage.CLOSE;
                        END;
                    END;
                    EXIT;
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
        AppraisalPage: Page "33020372";
        Appraisal: Record "33020361";
        "Eng-Nep1": Record "33020302";
}

