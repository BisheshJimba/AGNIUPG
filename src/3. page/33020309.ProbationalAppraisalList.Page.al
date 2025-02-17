page 33020309 "Probational Appraisal List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table5200;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field("Grade Code"; "Grade Code")
                {
                }
                field("Branch Code"; "Branch Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000009>")
            {
                Caption = 'Enter the Confirmation Date';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    HRPermission.GET(USERID);
                    IF HRPermission."HR Admin" THEN BEGIN
                        ProbationFiscalPage.SETTABLEVIEW(Rec);
                        ProbationFiscalPage.SETRECORD(Rec);
                        ProbationFiscalPage.RUN;
                    END ELSE BEGIN
                        ERROR('You do not have the Permission to open this page. Please contact HR department for HR Admin authority');
                    END;
                end;
            }
            action("<Action1000000010>")
            {
                Caption = 'Do Confirmation Appraisal';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Appraisal.RESET;
                    Appraisal.SETRANGE("Employee Code", "No.");
                    //Appraisal.SETRANGE(Appraisal."Fiscal Year",FiscalYear);
                    Appraisal.SETRANGE(Appraisal."Appraisal Type", Appraisal."Appraisal Type"::Probational);
                    IF Appraisal.FIND('-') THEN BEGIN
                        // MESSAGE('Appraisal for the selected employee is already done for this Fiscal Year');
                        //Setting Apprisal Page with selected Record
                        // EmpAppr1.RESET;
                        // EmpAppr1.SETRANGE("Employee Code","No.");
                        // EmpAppr1.SETRANGE("Fiscal Year",FiscalYear);
                        // EmpAppr1.SETRANGE(EmpAppr1."Appraisal Type",EmpAppr1."Appraisal Type"::"Half-Annual");
                        AppraisalPage.SETTABLEVIEW(Appraisal);
                        AppraisalPage.SETRECORD(Appraisal);
                        AppraisalPage.RUN;
                    END ELSE BEGIN
                        MESSAGE('The Confirmation Date has not been entered by the HR Department!');
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        HRPermission.GET(USERID);
        IF NOT HRPermission."HR Admin" THEN BEGIN
            EmployeeRec.RESET;
            EmployeeRec.SETCURRENTKEY("User ID");
            EmployeeRec.SETRANGE("User ID", USERID);
            IF EmployeeRec.FINDFIRST THEN BEGIN
                SETRANGE(Status, Status::Probation);
                SETRANGE("First Appraisal ID", EmployeeRec."No.");
            END;
        END;
    end;

    var
        HRPermission: Record "33020304";
        EmployeeRec: Record "5200";
        ProbationFiscalPage: Page "33020310";
        Appraisal: Record "33020361";
        AppraisalPage: Page "33020444";
}

