page 33020423 "Applicant Interview Card"
{
    PageType = Card;
    SourceTable = Table33020382;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Application No."; "Application No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Vacancy No."; "Vacancy No.")
                {
                }
                field("Vacancy Code"; "Vacancy Code")
                {
                }
                field("Position Applied"; "Position Applied")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(DOB; DOB)
                {
                }
                field(Nationality; Nationality)
                {
                }
                field("Marital Status"; "Marital Status")
                {
                }
                field(Gender; Gender)
                {
                }
                field(Email; Email)
                {
                }
                field(Telephone; Telephone)
                {
                }
                field(CellPhone; CellPhone)
                {
                }
            }
            group("Permanent Address")
            {
                field(P_WardNo; P_WardNo)
                {
                    Caption = 'Ward No.';
                }
                field(P_Vdc_Np; P_Vdc_Np)
                {
                    Caption = 'VDC/Municipality';
                }
                field(P_District; P_District)
                {
                    Caption = 'District';
                }
            }
            group("Temporary Address")
            {
                field(T_WardNo; T_WardNo)
                {
                    Caption = 'Ward No.';
                }
                field(T_Vdc_Np; T_Vdc_Np)
                {
                    Caption = 'VDC/Municipality';
                }
                field(T_District; T_District)
                {
                    Caption = 'District';
                }
            }
            group("Master Education")
            {
                field(M_Faculty; M_Faculty)
                {
                    Caption = 'Faculty';
                }
                field(M_College; M_College)
                {
                    Caption = 'College';
                }
                field(M_University; M_University)
                {
                    Caption = 'University';
                }
                field(M_Percentage; M_Percentage)
                {
                    Caption = 'Percentage/CGPA';
                }
                field(M_PassedYear; M_PassedYear)
                {
                    Caption = 'Passed Year';
                }
            }
            group("Bachelor Education")
            {
                field(B_Faculty; B_Faculty)
                {
                    Caption = 'Faculty';
                }
                field(B_College; B_College)
                {
                    Caption = 'College';
                }
                field(B_University; B_University)
                {
                    Caption = 'University';
                }
                field(B_Percentage; B_Percentage)
                {
                    Caption = 'Percentage/CGPA';
                }
                field(B_PassedYear; B_PassedYear)
                {
                    Caption = 'PassedYear';
                }
            }
            group("Intermediate Education")
            {
                field(I_Faculty; I_Faculty)
                {
                    Caption = 'Faculty';
                }
                field(I_College; I_College)
                {
                    Caption = 'College';
                }
                field(I_University; I_University)
                {
                    Caption = 'University';
                }
                field(I_Percentage; I_Percentage)
                {
                    Caption = 'Percentage/CGPA';
                }
                field(I_PassedYear; I_PassedYear)
                {
                    Caption = 'Passed Year';
                }
            }
            group(SLC)
            {
                field(S_Faculty; S_Faculty)
                {
                    Caption = 'Faculty';
                }
                field(S_College; S_College)
                {
                    Caption = 'School';
                }
                field(S_University; S_University)
                {
                    Caption = 'Affiliation';
                }
                field(S_Percentage; S_Percentage)
                {
                    Caption = 'Percentage/CGPA';
                }
                field(S_PassedYear; S_PassedYear)
                {
                    Caption = 'Passed Year';
                }
            }
            group("Other Education")
            {
                field(O_Faculty; O_Faculty)
                {
                    Caption = 'Faculty';
                }
                field(O_College; O_College)
                {
                    Caption = 'College';
                }
                field(O_University; O_University)
                {
                    Caption = 'University';
                }
                field(O_Percentage; O_Percentage)
                {
                    Caption = 'Percentage/CGPA';
                }
                field(O_PassedYear; O_PassedYear)
                {
                    Caption = 'Passed year';
                }
            }
            group("Work Experience1")
            {
                field(WE1_SN; WE1_SN)
                {
                    Caption = 'SN';
                }
                field(WE1_Orgnization; WE1_Orgnization)
                {
                    Caption = 'Organization';
                }
                field(WE1_Department; WE1_Department)
                {
                    Caption = 'Department';
                }
                field(WE1_Position; WE1_Position)
                {
                    Caption = 'Position';
                }
                field(WE1_Duration; WE1_Duration)
                {
                    Caption = 'Duration(Months)';
                }
            }
            group("Work Experience2")
            {
                field(WE2_SN; WE2_SN)
                {
                    Caption = 'SN';
                }
                field(WE2_Orgnization; WE2_Orgnization)
                {
                    Caption = 'Organization';
                }
                field(WE2_Department; WE2_Department)
                {
                    Caption = 'Department';
                }
                field(WE2_Position; WE2_Position)
                {
                    Caption = 'Position';
                }
                field(WE2_Duration; WE2_Duration)
                {
                    Caption = 'Duration(Months)';
                }
            }
            group("Work Experience3")
            {
                field(WE3_SN; WE3_SN)
                {
                    Caption = 'SN';
                }
                field(WE3_Orgnization; WE3_Orgnization)
                {
                    Caption = 'Organization';
                }
                field(WE3_Department; WE3_Department)
                {
                    Caption = 'Department';
                }
                field(WE3_Position; WE3_Position)
                {
                    Caption = 'Position';
                }
                field(WE3_Duration; WE3_Duration)
                {
                    Caption = 'Duration(Months)';
                }
            }
            group("Work Experience4")
            {
                field(WE4_SN; WE4_SN)
                {
                    Caption = 'SN';
                }
                field(WE4_Orgnization; WE4_Orgnization)
                {
                    Caption = 'Organization';
                }
                field(WE4_Department; WE4_Department)
                {
                    Caption = 'Department';
                }
                field(WE4_Position; WE4_Position)
                {
                    Caption = 'Position';
                }
                field(WE4_Duration; WE4_Duration)
                {
                    Caption = 'Duration(Months)';
                }
            }
            group("Work Experience5")
            {
                field(WE5_SN; WE5_SN)
                {
                    Caption = 'SN';
                }
                field(WE5_Orgnization; WE5_Orgnization)
                {
                    Caption = 'Organization';
                }
                field(WE5_Department; WE5_Department)
                {
                    Caption = 'Department';
                }
                field(WE5_Position; WE5_Position)
                {
                    Caption = 'Position';
                }
                field(WE5_Duration; WE5_Duration)
                {
                    Caption = 'Duration(Months)';
                }
            }
            group("Reference 1")
            {
                field(Ref1_SN; Ref1_SN)
                {
                    Caption = 'SN';
                }
                field(Ref1_FullName; Ref1_FullName)
                {
                    Caption = 'FullName';
                }
                field(Ref1_Relationship; Ref1_Relationship)
                {
                    Caption = 'Relationship';
                }
                field(Ref1_Company; Ref1_Company)
                {
                    Caption = 'Company';
                }
                field(Ref1_Phone; Ref1_Phone)
                {
                    Caption = 'Phone';
                }
                field(Ref1_Address; Ref1_Address)
                {
                    Caption = 'Address';
                }
            }
            group("Reference 2")
            {
                field(Ref2_SN; Ref2_SN)
                {
                    Caption = 'SN';
                }
                field(Ref2_FullName; Ref2_FullName)
                {
                    Caption = 'FullName';
                }
                field(Ref2_Relationship; Ref2_Relationship)
                {
                    Caption = 'Relationship';
                }
                field(Ref2_Company; Ref2_Company)
                {
                    Caption = 'Company';
                }
                field(Ref2_Phone; Ref2_Phone)
                {
                    Caption = 'Phone';
                }
                field(Ref2_Address; Ref2_Address)
                {
                    Caption = 'Address';
                }
            }
            group("Other Information")
            {
                field(Language; Language)
                {
                }
                field("Computer Knowledge"; "Computer Knowledge")
                {
                }
                field("Driving License"; "Driving License")
                {
                }
                field(Vehicle; Vehicle)
                {
                }
                field(Awards; Awards)
                {
                }
                field("Expected Salary"; "Expected Salary")
                {
                }
            }
            group("For Interview")
            {
                Caption = 'For Interview';
                Visible = false;
                field("Interview Marks"; "Interview Marks")
                {
                    Caption = 'Interview Marks';
                }
                field("Interview Remarks"; "Interview Remarks")
                {
                }
            }
            part("Induction CheckList"; 33019861)
            {
                SubPageLink = Applicant No.=FIELD(Application No.);
            }
            part("HR Attachment"; 33019862)
            {
                SubPageLink = No.=FIELD(Application No.);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group()
            {
                action("Convert To Interviewed")
                {
                    Image = Insurance;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        Application: Record "33020330";
                    begin
                        IF NOT CONFIRM('Do you want to convert this Application to Interviewed?', FALSE) THEN
                            EXIT;

                        Rec.TESTFIELD("Interview Marks");

                        Application.INIT;
                        Application.Name := Rec."First Name" + ' ' + Rec."Last Name";
                        Application.Interviewed := TRUE;
                        Application."Vacancy No." := Rec."Vacancy No.";
                        Application."Interviewed Date" := TODAY;
                        Application."Application No." := Rec."Application No.";
                        Application.INSERT(TRUE);

                        Rec.Status := Rec.Status::Interview;
                        Rec.MODIFY;

                        PAGE.RUN(PAGE::"Application Card", Application);
                        CurrPage.CLOSE;
                    end;
                }
                action(Reject)
                {
                    Image = Campaign;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM('Do you want to convert this Application to Interviewed?', FALSE) THEN
                            EXIT;

                        Rec.Status := Rec.Status::Reject;
                        Rec.MODIFY;

                        MESSAGE('Application has been rejected.');
                        CurrPage.CLOSE;
                    end;
                }
                action("Convert To Employee")
                {
                    Image = BOMLevel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        Emp: Record "5200";
                        EmpAc: Record "33020401";
                    begin
                        IF NOT CONFIRM('Do you want to convert this Application to Employee Activity?', FALSE) THEN
                            EXIT;

                        Emp.INIT;
                        Emp."First Name" := Rec."First Name";
                        Emp."Middle Name" := Rec."Middle Name";
                        Emp."Last Name" := Rec."Last Name";
                        Emp.Address := Rec.P_District;
                        Emp."Mobile Phone No.1" := Rec.Telephone;
                        Emp.Gender := Rec.Gender;
                        Emp."Birth Date" := Rec.DOB;
                        Emp."Marital Status" := Rec."Marital Status";
                        Emp."Applicant From Interview" := TRUE;
                        Emp.INSERT(TRUE);
                        PAGE.RUN(PAGE::"Employee Card", Emp);



                        EmpAc.INIT;
                        EmpAc."Line No." := 10000;
                        EmpAc."Effective Date" := TODAY;
                        EmpAc."Employee Code" := Emp."No.";
                        EmpAc."Employee Name" := Rec."First Name" + ' ' + Rec."Last Name";
                        EmpAc.Designation := Emp.Designation;
                        EmpAc.Level := Emp.Level;
                        EmpAc.INSERT(TRUE);
                        //wait for this

                        Rec.Status := Rec.Status::Converted;
                        Rec.Employed := TRUE;
                        Rec."Employed Date" := TODAY;
                        Rec."Employee No." := Emp."No.";
                        Rec.MODIFY;
                        CurrPage.CLOSE;
                    end;
                }
                action(InterviewComments)
                {
                    Caption = 'Interview Comment(s)';
                    RunPageMode = Edit;

                    trigger OnAction()
                    var
                        ApplicationInterviewCard: Page "33020335";
                        Interview: Record "33020329";
                    begin
                        Interview.RESET;
                        Interview.SETRANGE("Application No.", "Application No.");
                        IF Interview.FINDFIRST THEN
                            PAGE.RUN(PAGE::"Application Interview Card", Interview)
                        ELSE BEGIN
                            Interview.INIT;
                            Interview."Application No." := Rec."Application No.";
                            Interview.INSERT;
                            PAGE.RUN(PAGE::"Application Interview Card", Interview);
                        END;
                    end;
                }
                action(Offer)
                {
                    Image = VoucherGroup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM('Do you want to confirm sending offer?', FALSE) THEN
                            EXIT;
                        IF "Offer Sent Date" <> 0D THEN
                            ERROR('Offer already sent.');

                        "Offer Sent Date" := TODAY;
                        MODIFY;
                        MESSAGE('Offer Sent Sucessfully.');
                    end;
                }
            }
        }
    }

    var
        AppNew: Record "33020382";
        text0001: Label 'This Applicant is selected for Written Exam.';
        text0002: Label 'Already Selected for Written Exam.';
        text0003: Label 'Already Selected as Employee.!';
        HRSetup: Record "5218";
        UserSetup: Record "91";
        text0004: Label 'Aborted By User - %1 !';
        text0005: Label 'You donot have permission for application processing. Please contact your system administrator.';
        ConfirmEmploy: Boolean;
        text0006: Label 'Are you sure to Recruit?';
        Employee: Record "5200";
        NewEmployeeNum: Code[20];
        Education: Record "33020383";
        WorkExp: Record "33020384";
        text0007: Label 'This Applicant is successfully converted to Employee.';
        educationLine: Record "33020420";
        LineNo: Integer;
        HRPermission: Record "33020304";
}

