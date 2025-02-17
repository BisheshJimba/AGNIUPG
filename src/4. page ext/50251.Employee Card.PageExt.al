pageextension 50251 pageextension50251 extends "Employee Card"
{
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 26".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 93".


        //Unsupported feature: Property Modification (SourceExpr) on ""Phone No.2"(Control 74)".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 28".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 52".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 66".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 26".


        //Unsupported feature: Property Deletion (Importance) on "Control 26".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 93".


        //Unsupported feature: Property Deletion (Name) on ""Phone No.2"(Control 74)".


        //Unsupported feature: Property Deletion (ToolTipML) on ""Phone No.2"(Control 74)".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 28".


        //Unsupported feature: Property Deletion (Importance) on "Control 28".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 66".


        //Unsupported feature: Property Deletion (Importance) on "Control 66".

        addafter("Control 10")
        {
            field("Full Name"; "Full Name")
            {
            }
            field("Father Name"; "Father Name")
            {
            }
            field("GrandFather Name"; "GrandFather Name")
            {
            }
            field("Birth Date"; Rec."Birth Date")
            {
            }
            field(Nationality; Nationality)
            {
            }
            field("Citizenship No."; "Citizenship No.")
            {
            }
            field("Issue Office"; "Issue Office")
            {
            }
            field("Issue District"; "Issue District")
            {
            }
            field("Passport No."; "Passport No.")
            {
                Visible = false;
            }
            field("Passport Issue Date"; "Passport Issue Date")
            {
                Visible = false;
            }
            field("Passport Expiry Date"; "Passport Expiry Date")
            {
                Visible = false;
            }
            field("Passport Issue Place"; "Passport Issue Place")
            {
                Visible = false;
            }
        }
        addafter("Control 11")
        {
            field("Marital Status"; "Marital Status")
            {
            }
            field("Location Code"; "Location Code")
            {
            }
            field("Computer User"; "Computer User")
            {
            }
            field("Blood Group"; "Blood Group")
            {
            }
            field(Picture; Rec.Picture)
            {
            }
            field(Level; Level)
            {
            }
            field(Grade; Grade)
            {
            }
            field("Tax Code"; "Tax Code")
            {
            }
            field("Premium of Life Insurance"; "Premium of Life Insurance")
            {
            }
            field("Donation Amount"; "Donation Amount")
            {
                Visible = false;
            }
        }
        addafter("Control 38")
        {
            field("Minimum Education"; "Minimum Education")
            {
            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
            }
            field("Attendance Emp Code"; "Attendance Emp Code")
            {
            }
        }
        addafter("Control 28")
        {
            field(Saved; Saved)
            {
                Editable = false;
            }
            field(Cheque; Cheque)
            {
            }
        }
        addafter("Control 26")
        {
            field("Is Traning Manager"; "Is Traning Manager")
            {
            }
            field("Is Employee Req Manager"; "Is Employee Req Manager")
            {
            }
            field("Applicant From Interview"; "Applicant From Interview")
            {
            }
            field("Premium of Health Insurance"; "Premium of Health Insurance")
            {
            }
            field("Premium of Building Insurance"; "Premium of Building Insurance")
            {
            }
            field("Amount of Medical Tax"; "Amount of Medical Tax")
            {
                Caption = '<Amount of Medical Expenses>';
            }
        }
        addfirst("Control 1900121501")
        {
            field("Restrict Leave Earn"; "Restrict Leave Earn")
            {
            }
            field(Company; Company)
            {
                Visible = false;
            }
        }
        addafter("Control 52")
        {
            field("Re-Appointment Date"; "Re-Appointment Date")
            {
            }
        }
        addafter("Control 56")
        {
            field("Job Title code"; "Job Title code")
            {
            }
            field("Grade Code"; "Grade Code")
            {
            }
            field("Department Code"; "Department Code")
            {
            }
            field("Department Name"; "Department Name")
            {
            }
            field("Branch Code"; "Branch Code")
            {
            }
            field("Branch Name"; "Branch Name")
            {
                Visible = false;
            }
            field("First Appraisal ID"; "First Appraisal ID")
            {
                Visible = true;
            }
            field("First Appraiser"; "First Appraiser")
            {
                Visible = true;
            }
            field("Second Appraisal ID"; "Second Appraisal ID")
            {
                Visible = true;
            }
            field("Second Appraiser"; "Second Appraiser")
            {
                Visible = true;
            }
            field("Exam Level"; "Exam Level")
            {
            }
            field("Exam Department Code"; "Exam Department Code")
            {
            }
            field("Exam Department"; "Exam Department")
            {
                Editable = false;
            }
            field("User ID"; "User ID")
            {
                DrillDown = true;
                Lookup = true;
                LookupPageID = "User Setup";
            }
            field("Worked Years In Company"; years)
            {
                Editable = false;
            }
            field("Worked Months in Company"; Months)
            {
                Editable = false;
            }
            field("Worked Days in Company"; dayste)
            {
                Editable = false;
            }
        }
        addafter("Control 58")
        {
            field("Teacher's class"; "Teacher's class")
            {
            }
        }
        addafter("Control 77")
        {
            field("Certificate of origin"; "Certificate of origin")
            {
            }
            field("Resignation Date"; "Resignation Date")
            {
            }
            field("Resignation Status"; "Resignation Status")
            {
            }
            field("Clearancee Date"; "Clearancee Date")
            {
            }
            field("Last Working Day"; "Last Working Day")
            {
            }
            group(Salary)
            {
                Caption = 'Salary';
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
                field(Total; Total)
                {
                }
            }
            group("Permanent Address")
            {
                Caption = 'Permanent Address';
                field("Ward No."; P_WardNo)
                {
                }
                field("VDC/Municipality"; P_VDC_NP)
                {
                }
                field(Distrrict; P_District)
                {
                }
            }
            group("Temporary Address")
            {
                Caption = 'Temporary Address';
                field("Temp. Ward No."; T_WardNo)
                {
                }
                field("Temp. VDC/Municipality"; T_VDC_NP)
                {
                }
                field("Temp. District"; T_District)
                {
                }
            }
            group("Reporting Manager")
            {
                Caption = 'Reporting Manager';
                field("Manager Department Code"; "Manager Department Code")
                {
                }
                field("Manager's Designation"; "Manager's Designation")
                {
                }
                field("Manager ID"; "Manager ID")
                {
                }
                field(Manager; Manager)
                {
                    Editable = false;
                }
            }
        }
        addafter("Control 68")
        {
            field("Driving License No."; "Driving License No.")
            {
            }
            field("PAN No."; "PAN No.")
            {
            }
            field("CIT No."; "CIT No.")
            {
            }
            field("Gratuity No."; "Gratuity No.")
            {
            }
            field("PF No."; "PF No.")
            {
            }
        }
        addafter("Control 91")
        {
            field("Repair & Maintenance Amt"; "Repair & Maintenance Amt")
            {
            }
            field("Monthly Fuel (Ltr)"; "Monthly Fuel (Ltr)")
            {
            }
            field("Work Shift Code"; "Work Shift Code")
            {
            }
            field(Signature; Signature)
            {
            }
            field("Mobile Phone No.1"; "Mobile Phone No.1")
            {
                Caption = '<Mobile Phone No. 1>';
            }
            field("Mobile Phone No.2"; "Mobile Phone No.2")
            {
            }
            field(Pager; Rec.Pager)
            {
                Visible = false;
            }
            field("Residence No."; Rec."Phone No.")
            {
            }
            field("Personal E-Mail"; "Personal E-Mail")
            {
            }
            group("NCHL-NPI Integration")
            {
                field("Bank ID"; "Bank ID")
                {
                }
            }
        }
        addafter("Control 66")
        {
            field("Bank Account No."; Rec."Bank Account No.")
            {
            }
            part(; 33020540)
            {
                SubPageLink = Employee No.=FIELD(No.);
            }
        }
        moveafter("Control 38"; "Control 28")
        moveafter("Control 28"; "Control 26")
        moveafter("Control 72"; "Control 48")
        moveafter("Control 1901160401"; "Control 68")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 81".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 184".

        modify(AlternativeAddresses)
        {
            Visible = false;
        }

        //Unsupported feature: Property Modification (RunPageLink) on "Action 41".


        //Unsupported feature: Property Modification (Level) on "Action 23".


        //Unsupported feature: Property Modification (Level) on "Action 95".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 95".


        //Unsupported feature: Property Modification (Level) on "Action 70".


        //Unsupported feature: Property Modification (Level) on "Action 71".


        //Unsupported feature: Property Modification (Level) on "Action 61".


        //Unsupported feature: Property Modification (Level) on "Action 62".

        addfirst("Action 19")
        {
            action("Attendence Log")
            {
                RunObject = Page 33020558;
                RunPageLink = Employee ID=FIELD(No.);
            }
        }
        addafter("Action 76")
        {
            action(Educations)
            {
                RunObject = Page 33020491;
                                RunPageLink = Employee Code=FIELD(No.);
            }
            action(WorkExperience)
            {
                Caption = '<Work Experience>';
                RunObject = Page 33020492;
                                RunPageLink = Employee Code=FIELD(No.);
            }
        }
        addafter("Action 41")
        {
            action("Previous Work History")
            {
                RunObject = Page 33020331;
                                RunPageLink = No.=FIELD(No.),
                              Table Name=CONST(Employee);
                Visible = false;
            }
        }
        addafter("Action 87")
        {
            action("ODD/ Training/ Gate Pass")
            {
                RunObject = Page 33020395;
                                RunPageLink = Entry No.=FIELD(No.);
            }
            action("Promotion History")
            {
                RunObject = Page 33020390;
                                RunPageLink = Employee Code=FIELD(No.);
                Visible = false;
            }
            action("Employee Activity")
            {
                RunObject = Page 33020443;
                                RunPageLink = Employee Code=FIELD(No.);
            }
            action("Work Shift Detail")
            {
                RunObject = Page 33020305;
                                RunPageLink = Employee Code=FIELD(No.);
            }
            action("Training History")
            {
                RunObject = Page 33020380;
                                RunPageLink = Employee Code=FIELD(No.);
            }
            action("Final Settlement Form")
            {
                RunObject = Page 33020472;
                                RunPageLink = Employee Code=FIELD(No.);
            }
            action("Exit Form")
            {
                RunObject = Page 33020473;
                                RunPageLink = Employee Code=FIELD(No.);
            }
            action("Family Details")
            {
                RunObject = Page 33020475;
                                RunPageLink = Employee Code=FIELD(No.);
            }
            action(Save)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to save the customer card?') THEN BEGIN //MIN 4/30/2019
                     Saved := TRUE;
                     MODIFY;
                    END;
                    TESTFIELD("No.");
                    TESTFIELD("Job Title");
                    TESTFIELD("First Name");
                    TESTFIELD("Last Name");
                    TESTFIELD("Father Name");
                    TESTFIELD("GrandFather Name");
                    TESTFIELD("Citizenship No.");
                    TESTFIELD("Issue Office");
                    TESTFIELD("Issue District");
                    TESTFIELD(Gender);
                    TESTFIELD("Marital Status");
                    //TESTFIELD("Location Code");
                    TESTFIELD(Level);
                    TESTFIELD(Status);
                    TESTFIELD("Department Name");
                    TESTFIELD("Global Dimension 1 Code");
                    TESTFIELD(P_District);
                    TESTFIELD(P_VDC_NP);
                    TESTFIELD(P_WardNo);
                    TESTFIELD(T_District);
                    TESTFIELD(T_VDC_NP);
                    TESTFIELD(T_WardNo);
                    TESTFIELD(Grade);
                    TESTFIELD("Tax Code");
                    TESTFIELD("Job Title code");
                    TESTFIELD("Grade Code");
                    TESTFIELD("Department Code");
                    TESTFIELD("Attendance Emp Code");
                    TESTFIELD("Employment Date");
                    TESTFIELD("Manager ID");
                    TESTFIELD("Work Shift Code");
                    TESTFIELD("Mobile Phone No.1");
                    TESTFIELD("Personal E-Mail");
                    TESTFIELD(Manager);
                end;
            }
            separator()
            {
            }
            action("Test Bank Account Validation")
            {
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = TestAccVisible;

                trigger OnAction()
                var
                    CIPSWebServiceMgt: Codeunit "33019811";
                    ResponseMessage: Text;
                    AccMatchPercent: Code[10];
                    ResponseCode: Code[10];
                begin
                    IF CIPSWebServiceMgt.CheckBankAccountValidation("Bank ID","Bank Account No.",FullName) THEN BEGIN
                      CIPSWebServiceMgt.GetBankAccountValidationResponse(ResponseCode,ResponseMessage,AccMatchPercent);
                      MESSAGE('Account is applicable for IPS.\Account Match Percentage : %1\Response Message : %2',
                               AccMatchPercent,ResponseMessage);
                    END ELSE BEGIN
                      CIPSWebServiceMgt.GetBankAccountValidationResponse(ResponseCode,ResponseMessage,AccMatchPercent);
                      MESSAGE('Account is not valid. Response code does not indicate success.\Account Match Percentage : %1\Response Message : %2',
                              AccMatchPercent,ResponseMessage);
                    END;
                end;
            }
            group("Financial Info")
            {
                Caption = 'Financial Info';
                action("Payroll Components")
                {
                    Image = Components;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    RunObject = Page 33020522;
                                    RunPageLink = Employee No.=FIELD(No.);
                    RunPageView = SORTING(Employee No.,Column No.);
                }
                action("Salary Logs")
                {
                    Image = CashReceiptJournal;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Page 33020525;
                                    RunPageLink = Employee No.=FIELD(No.);
                }
                action("Salary Ledger Entries")
                {
                    Image = ItemLedger;
                    RunObject = Page 33020527;
                                    RunPageLink = Employee Code=FIELD(No.);
                }
            }
            area(creation)
            {
            }
            action("Leave Earned")
            {

                trigger OnAction()
                begin
                    //AGNI2017CU8 >>
                    LeaveEarn.RESET;
                    LeaveEarn.SETRANGE(LeaveEarn."Employee Code","No.");
                    IF LeaveEarn.FINDFIRST THEN
                      REPORT.RUNMODAL(33020325,TRUE,FALSE,LeaveEarn);
                    //AGNI2017CU8 <<
                end;
            }
            action("Leave Consumed")
            {

                trigger OnAction()
                begin
                    //AGNI2017CU8 >>
                    PostLeaveRequest.RESET;
                    PostLeaveRequest.SETRANGE(PostLeaveRequest."Employee No.","No.");
                    IF PostLeaveRequest.FINDFIRST THEN
                      REPORT.RUNMODAL(33020326,TRUE,FALSE,PostLeaveRequest);
                    //AGNI2017CU8 <<
                end;
            }
        }
        addafter("Action 19")
        {
            separator()
            {
            }
            group(Reports)
            {
                Caption = 'Reports';
                action("Salary Slip")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PostSalaryLine.RESET;
                        PostSalaryLine.SETRANGE("Employee No.","No.");
                        IF PostSalaryLine.FINDFIRST THEN
                            REPORT.RUNMODAL(33020502,TRUE,FALSE,PostSalaryLine);
                    end;
                }
                action("Daily Attendance Report")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AttLog.RESET;
                        AttLog.SETRANGE("Employee ID","No.");
                        IF AttLog.FINDFIRST THEN
                          REPORT.RUNMODAL(33020360,TRUE,TRUE,AttLog);
                    end;
                }
                action("Bank Account")
                {
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        EmployeeBankAccount: Record "14125604";
                    begin
                        EmployeeBankAccount.RESET;
                        EmployeeBankAccount.SETRANGE(EmployeeBankAccount."Employee No.","No.");
                        PAGE.RUN(14125501,EmployeeBankAccount);
                    end;
                }
            }
        }
    }

    var
        MapPointVisible: Boolean;
        LeaveEarn: Record "33020398";
        PostLeaveRequest: Record "33020344";
        WorkYears: Decimal;
        WorkMonths: Decimal;
        WorkDays: Decimal;
        Days: Decimal;
        years: Text[30];
        Months: Text[30];
        dayste: Text[30];
        HRPermission: Record "33020304";
        Text0001: Label 'You Do Not Have Permission To View Employee Card!''';
        UserSetup: Record "91";
        Employee: Record "5200";
        PostSalaryHeader: Record "33020512";
        PostSalaryLine: Record "33020513";
        AttLog: Record "33020550";
        SaveEmployeePageConf: Label 'You must first save the employee card page before close it.';
        NoEditPermissionErr: Label 'You do not have permission to edit employee card.';
        "--NCHL-NPI_1.00--": Integer;
        CompanyInfo: Record "79";
        TestAccVisible: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
        /*
        SetControlAppearance; //NCHL-NPI_1.00
        */
    //end;


    //Unsupported feature: Code Insertion on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //begin
        /*
        MapPointVisible := TRUE;  //AGNI2017CU8
        */
    //end;


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //var
        //MapMgt: Codeunit "802";
    //begin
        /*
        //AGNI2017CU8 >>
        Employee.RESET;
        Employee.SETRANGE("User ID",USERID);
        IF NOT Employee.FINDFIRST THEN BEGIN
          HRPermission.RESET;
          HRPermission.SETRANGE("User ID",USERID);
          IF HRPermission.FINDFIRST THEN
              IF (HRPermission."HR Admin" = FALSE) THEN
                  ERROR(Text0001);
        END;
        IF NOT MapMgt.TestSetup THEN
          MapPointVisible := FALSE;

        CLEAR(Days);
        IF NOT ("Employment Date" = 0D) THEN BEGIN
          IF "Termination Date" = 0D THEN BEGIN
            Days := TODAY - "Employment Date";
            IF Days >= 365 THEN BEGIN
            WorkYears := Days/365;
            Days := WorkYears- ROUND(WorkYears,1,'<');
            Days := Days *365;
            WorkMonths := Days/30;
            Days := WorkMonths -ROUND(WorkMonths,1,'<');
            Days := Days *30;
            years := FORMAT(ROUND(WorkYears,1,'<'));
            Months := FORMAT(ROUND(WorkMonths,1,'<'));
            dayste := FORMAT(ROUND(Days,1,'<'));
          END ELSE IF Days < 365 THEN BEGIN
            WorkMonths := Days/30;
            Days := WorkMonths -ROUND(WorkMonths,1,'<');
            Days := Days *30;
            Months := FORMAT(ROUND(WorkMonths,1,'<'));
            dayste := FORMAT(ROUND(Days,1,'<'));
          END;
        END ELSE  BEGIN
          Days := "Termination Date" - "Employment Date";
          IF Days >= 365 THEN BEGIN
            WorkYears := Days/365;
            Days := WorkYears- ROUND(WorkYears,1,'<');
            Days := Days *365;
            WorkMonths := Days/30;
            Days := WorkMonths -ROUND(WorkMonths,1,'<');
            Days := Days *30;
            years := FORMAT(ROUND(WorkYears,1,'<'));
            Months := FORMAT(ROUND(WorkMonths,1,'<'));
            dayste := FORMAT(ROUND(Days,1,'<'));
          END ELSE IF Days < 365 THEN BEGIN
            WorkMonths := Days/30;
            Days := WorkMonths -ROUND(WorkMonths,1,'<');
            Days := Days *30;
            Months := FORMAT(ROUND(WorkMonths,1,'<'));
            dayste := FORMAT(ROUND(Days,1,'<'));
          END;
        END;
        END;
        //AGNi2017CU8 <<
        UserSetup.GET(USERID); //MIN 1/9/2020
        IF NOT UserSetup."Can Edit Employee Card" THEN
          ERROR(NoEditPermissionErr);
        */
    //end;


    //Unsupported feature: Code Insertion on "OnQueryClosePage".

    //trigger OnQueryClosePage(CloseAction: Action): Boolean
    //begin
        /*
        IF NOT Saved THEN //MIN 5/2/2019
          ERROR(SaveEmployeePageConf);
        */
    //end;

    local procedure SetControlAppearance()
    begin
        CompanyInfo.GET;
        TestAccVisible := CompanyInfo."Enable NCHL-NPI Integration";
    end;
}

