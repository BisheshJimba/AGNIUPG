page 33020440 "Employee Activity Card"
{
    Caption = 'Employee Activity Card';
    PageType = Card;
    SourceTable = Table33020401;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Activity No."; "Activity No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                }
                field("From Branch Code"; "From Branch Code")
                {
                    Editable = false;
                }
                field("From Branch"; "From Branch")
                {
                    Editable = false;
                }
                field("From Department Code"; "From Department Code")
                {
                    Editable = false;
                }
                field("From Department"; "From Department")
                {
                    Editable = false;
                }
                field("From Job Title Code"; "From Job Title Code")
                {
                    Editable = false;
                }
                field("From Job Title"; "From Job Title")
                {
                    Editable = false;
                }
                field("From Grade"; "From Grade")
                {
                    Editable = false;
                }
                field("From Manager ID"; "From Manager ID")
                {
                    Editable = false;
                }
                field("From Manager Name"; "From Manager Name")
                {
                    Editable = false;
                }
                field(Activity; Activity)
                {
                }
                field("Effective Date"; "Effective Date")
                {

                    trigger OnValidate()
                    begin
                        EmpActivityRec.RESET;
                        EmpActivityRec.SETRANGE("Employee Code", "Employee Code");
                        //EmpActivityRec.SETRANGE(Activity,Activity);
                        EmpActivityRec.SETRANGE("Effective Date", "Effective Date");
                        IF EmpActivityRec.FINDFIRST THEN BEGIN
                            ERROR("Employee Code" + ' already has the activity for effective date: ' + FORMAT("Effective Date"));
                        END;
                    end;
                }
                field(Total; Total)
                {
                }
                field(Remark; Remark)
                {
                }
                field("To Branch Code"; "To Branch Code")
                {
                }
                field("To Branch"; "To Branch")
                {
                    Editable = false;
                }
                field("To Department Code"; "To Department Code")
                {
                }
                field("To Department"; "To Department")
                {
                    Editable = false;
                }
                field("To Job Title Code"; "To Job Title Code")
                {
                }
                field("To Job Title"; "To Job Title")
                {
                }
                field("To Grade"; "To Grade")
                {
                }
                field("To Manager ID"; "To Manager ID")
                {
                }
                field("To Manager Name"; "To Manager Name")
                {
                }
            }
            group("Payroll Information")
            {
                Caption = 'Payroll Information';
                Visible = false;
                field("Basic Pay"; "Basic Pay")
                {
                }
                field("Dearness Allowance"; "Dearness Allowance")
                {
                }
                field("Other Allowance"; "Other Allowance")
                {
                }
                label()
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000011>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD(Activity);
                    TESTFIELD("Effective Date");
                    TESTFIELD("To Branch Code");
                    TESTFIELD("To Job Title Code");
                    TESTFIELD("To Department Code");
                    TESTFIELD(Total);
                    ConfirmPost := DIALOG.CONFIRM(text0001, TRUE);
                    IF ConfirmPost THEN BEGIN

                        //start of Probation code
                        IF Activity = Activity::Probation THEN BEGIN
                            TESTFIELD("Basic Pay");
                            Emp1Rec.RESET;
                            Emp1Rec.SETRANGE(Emp1Rec."No.", "Employee Code");
                            IF Emp1Rec.FINDFIRST THEN BEGIN
                                Emp1Rec.Status := Emp1Rec.Status::Probation;
                                Emp1Rec."Employment Date" := "Effective Date";
                                Emp1Rec.MODIFY;
                            END;
                        END;

                        //Transfer to Sister Concern
                        IF Activity = Activity::"Trf Sister Concern" THEN BEGIN
                            TESTFIELD("Basic Pay");
                            Emp1Rec.RESET;
                            Emp1Rec.SETRANGE(Emp1Rec."No.", "Employee Code");
                            IF Emp1Rec.FINDFIRST THEN BEGIN
                                Emp1Rec.Status := Emp1Rec.Status::"Trf Sister Concern";
                                Emp1Rec."Termination Date" := "Effective Date";
                                Emp1Rec.MODIFY;
                            END;
                        END;



                        //start of Confirmed
                        IF Activity = Activity::Confirmed THEN BEGIN
                            Emp1Rec.RESET;
                            Emp1Rec.SETRANGE("No.", "Employee Code");
                            IF Emp1Rec.FINDFIRST THEN BEGIN
                                Emp1Rec.Status := Emp1Rec.Status::Confirmed;
                                Emp1Rec."Confirmation Date" := "Effective Date";
                                Emp1Rec.MODIFY;
                            END;
                            //UpdateSalaryLog; // ****yuran@agile 4/23/2013 ****
                        END;

                        //Contract
                        IF Activity = Activity::Contract THEN BEGIN
                            Emp1Rec.RESET;
                            Emp1Rec.SETRANGE("No.", "Employee Code");
                            IF Emp1Rec.FINDFIRST THEN BEGIN
                                Emp1Rec.Status := Emp1Rec.Status::Contract;
                                Emp1Rec."Employment Date" := "Effective Date";
                                Emp1Rec.MODIFY;
                            END;
                        END;


                        //Temporary Transfer
                        IF Activity = Activity::"Temporary Transfer" THEN BEGIN
                            IF (("From Branch Code" = "To Branch Code")) THEN
                                IF (("From Department Code" = "To Department Code")) THEN BEGIN
                                    ERROR('Branch Code and Department Code must be different for Temporary Transfer!');
                                END;
                        END;

                        //Permanent Transfer
                        IF Activity = Activity::"Permanent Transfer" THEN BEGIN
                            IF ("From Branch Code" = "To Branch Code") THEN
                                IF ("From Department Code" = "To Department Code") THEN BEGIN
                                    ERROR('Branch Code OR Department Code must be different for Permanent Transfer!');
                                END;
                        END;

                        //Reporting Authority Change
                        /*IF Activity = Activity::"Reporting Authority Change" THEN BEGIN
                          IF ("From Reporting Department" = "To Reporting Department") THEN
                           IF   ("From Reporting Designation"="To Reporting Designation") THEN BEGIN
                              ERROR('Reporting Department OR Reporting Designation must be different for Reportig Authority Change');
                            END;
                        END;*/

                        //Redesignation
                        /*IF Activity = Activity::Left THEN BEGIN
                          IF ("From Job Title" = "To Job Title") THEN BEGIN
                          ERROR('The Job Title must be different for Redesignation');  END;
                        END;*/

                        //Upgradation
                        IF Activity = Activity::"15" THEN BEGIN
                            IF ("From Grade" = "To Grade") = TRUE THEN BEGIN
                                ERROR('The Grade Code must be different for Upgradation');
                            END;
                        END;

                        //Promotion
                        IF Activity = Activity::Promotion THEN BEGIN
                            IF ("From Job Title Code" = "To Job Title Code") = TRUE THEN BEGIN
                                ERROR('The Grade Code must be different for Promotion');
                            END;
                        END;

                        //Suspension
                        IF Activity = Activity::Suspension THEN BEGIN
                            Emp1Rec.RESET;
                            Emp1Rec.SETRANGE(Emp1Rec."No.", "Employee Code");
                            IF Emp1Rec.FINDFIRST THEN BEGIN
                                Emp1Rec.Status := Emp1Rec.Status::Suspension;
                                Emp1Rec.MODIFY;
                            END;
                        END;

                        //Left
                        IF Activity = Activity::Left THEN BEGIN
                            Emp1Rec.RESET;
                            Emp1Rec.SETRANGE(Emp1Rec."No.", "Employee Code");
                            IF Emp1Rec.FINDFIRST THEN BEGIN
                                Emp1Rec.Status := Emp1Rec.Status::Left;
                                Emp1Rec."Termination Date" := "Effective Date";
                                Emp1Rec.MODIFY;
                            END;
                        END;

                        //Retired
                        IF Activity = Activity::Retired THEN BEGIN
                            Emp1Rec.RESET;
                            Emp1Rec.SETRANGE(Emp1Rec."No.", "Employee Code");
                            IF Emp1Rec.FINDFIRST THEN BEGIN
                                Emp1Rec.Status := Emp1Rec.Status::Retired;
                                Emp1Rec."Termination Date" := "Effective Date";
                                Emp1Rec.MODIFY;
                            END;
                        END;

                        //Terminted
                        IF Activity = Activity::Terminated THEN BEGIN
                            Emp1Rec.RESET;
                            Emp1Rec.SETRANGE(Emp1Rec."No.", "Employee Code");
                            IF Emp1Rec.FINDFIRST THEN BEGIN
                                Emp1Rec.Status := Emp1Rec.Status::Terminated;
                                Emp1Rec."Termination Date" := "Effective Date";
                                Emp1Rec.MODIFY;
                            END;
                        END;

                        EmpActivityRec.RESET;
                        EmpActivityRec.SETRANGE(EmpActivityRec."Activity No.", "Activity No.");
                        EmpActivityRec.SETRANGE("Line No.", "Line No.");
                        IF EmpActivityRec.FINDFIRST THEN BEGIN
                            EmpActivityRec.Posted := TRUE;
                            EmpActivityRec."Posted Date" := TODAY;
                            EmpActivityRec."Posted By" := USERID;
                            EmpActivityRec.MODIFY;
                        END;


                        EmpRec.RESET;
                        EmpRec.SETRANGE(EmpRec."No.", "Employee Code");
                        IF EmpRec.FINDFIRST THEN BEGIN
                            EmpRec.VALIDATE("Branch Code", "To Branch Code");
                            EmpRec."Job Title code" := "To Job Title Code";
                            EmpRec."Job Title" := "To Job Title";
                            EmpRec.VALIDATE("Department Code", "To Department Code");
                            EmpRec."Grade Code" := "To Grade";
                            EmpRec."Manager ID" := "To Manager ID";
                            EmpRec.Manager := "To Manager Name";
                            EmpRec."First Appraisal ID" := "To Manager ID";
                            EmpRec."First Appraiser" := "To Manager Name";
                            EmpRec."Basic Pay" := "Basic Pay";
                            EmpRec."Dearness Allowance" := "Dearness Allowance";
                            EmpRec."Other Allowance" := "Other Allowance";
                            EmpRec.Total := Total;
                            EmpRec.VALIDATE(Level, "To Job Title Code");
                            EmpRec.VALIDATE(Grade, "To Grade");
                            EmpRec.MODIFY;
                        END;

                        MESSAGE(text0002);

                    END;

                end;
            }
        }
    }

    var
        EmpActivityRec: Record "33020401";
        text0001: Label 'Do you want to Post?';
        EmpRec: Record "5200";
        Emp1Rec: Record "5200";
        MasterOfManagerRec: Record "33020407";
        ConfirmPost: Boolean;
        text0002: Label 'The activity has been successfully posted';
        Emp2Rec: Record "5200";

    [Scope('Internal')]
    procedure UpdateSalaryLog()
    var
        SalaryLog: Record "33020519";
        PayrollCompUsage: Record "33020504";
        PRSetup: Record "33020507";
    begin
        PRSetup.GET;
        IF Activity = Activity::Probation THEN BEGIN
            PayrollCompUsage.RESET;
            PayrollCompUsage.SETRANGE("Employee No.", "Employee Code");
            PayrollCompUsage.SETRANGE("Payroll Component Code", PRSetup."PF Contribution Component");
            IF NOT PayrollCompUsage.FINDFIRST THEN BEGIN
                CLEAR(PayrollCompUsage);
                PayrollCompUsage.INIT;
                PayrollCompUsage."Employee No." := "Employee Code";
                PayrollCompUsage.VALIDATE("Payroll Component Code", PRSetup."PF Contribution Component");
                PayrollCompUsage."Applicable from" := "Effective Date";
                PayrollCompUsage.INSERT;
            END;
            PayrollCompUsage.RESET;
            PayrollCompUsage.SETRANGE("Employee No.", "Employee Code");
            PayrollCompUsage.SETRANGE("Payroll Component Code", PRSetup."PF Deduction Component");
            IF NOT PayrollCompUsage.FINDFIRST THEN BEGIN
                CLEAR(PayrollCompUsage);
                PayrollCompUsage.INIT;
                PayrollCompUsage."Employee No." := "Employee Code";
                PayrollCompUsage.VALIDATE("Payroll Component Code", PRSetup."PF Deduction Component");
                PayrollCompUsage."Applicable from" := "Effective Date";
                PayrollCompUsage.INSERT;
            END;
        END;
        IF ("Basic Pay" <> 0) THEN BEGIN
            SalaryLog.RESET;
            SalaryLog.SETRANGE("Employee No.", "Employee Code");
            SalaryLog.SETRANGE("Effective Date", "Effective Date");
            IF SalaryLog.FINDFIRST THEN BEGIN
                SalaryLog."Basic with Grade" := "Basic Pay";
                SalaryLog.MODIFY;
            END
            ELSE BEGIN
                CLEAR(SalaryLog);
                SalaryLog.INIT;
                SalaryLog."Employee No." := "Employee Code";
                SalaryLog."Effective Date" := "Effective Date";
                SalaryLog."Basic with Grade" := "Basic Pay";
                SalaryLog.INSERT;
            END;
        END;
        IF ("Dearness Allowance" <> 0) THEN BEGIN
            PayrollCompUsage.RESET;
            PayrollCompUsage.SETRANGE("Employee No.", "Employee Code");
            PayrollCompUsage.SETRANGE("Payroll Component Code", PRSetup."Dearness Allowance Component");
            IF PayrollCompUsage.FINDFIRST THEN BEGIN
                PayrollCompUsage.Amount := "Dearness Allowance";
                PayrollCompUsage.MODIFY;
            END
            ELSE BEGIN
                CLEAR(PayrollCompUsage);
                PayrollCompUsage.INIT;
                PayrollCompUsage."Employee No." := "Employee Code";
                PayrollCompUsage.VALIDATE("Payroll Component Code", PRSetup."Dearness Allowance Component");
                PayrollCompUsage."Applicable from" := "Effective Date";
                PayrollCompUsage.Amount := "Dearness Allowance";
                PayrollCompUsage.INSERT;
            END;
        END;
        IF ("Other Allowance" <> 0) THEN BEGIN
            PayrollCompUsage.RESET;
            PayrollCompUsage.SETRANGE("Employee No.", "Employee Code");
            PayrollCompUsage.SETRANGE("Payroll Component Code", PRSetup."Other Allowance Component");
            IF PayrollCompUsage.FINDFIRST THEN BEGIN
                PayrollCompUsage.Amount := "Other Allowance";
                PayrollCompUsage.MODIFY;
            END
            ELSE BEGIN
                CLEAR(PayrollCompUsage);
                PayrollCompUsage.INIT;
                PayrollCompUsage."Employee No." := "Employee Code";
                PayrollCompUsage.VALIDATE("Payroll Component Code", PRSetup."Other Allowance Component");
                PayrollCompUsage."Applicable from" := "Effective Date";
                PayrollCompUsage.Amount := "Other Allowance";
                PayrollCompUsage.INSERT;
            END;
        END;
    end;
}

