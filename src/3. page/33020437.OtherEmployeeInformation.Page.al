page 33020437 "Other Employee Information"
{
    PageType = Card;
    SourceTable = Table33020382;

    layout
    {
        area(content)
        {
            group("Employee Info")
            {
                Caption = 'Employee Info';
                field("Father Name"; "Father Name")
                {
                }
                field("GrandFather Name"; "GrandFather Name")
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
                field("Medical Certificate No."; "Medical Certificate No.")
                {
                }
            }
            group(General)
            {
                Visible = false;
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
                field("Marital Status"; "Marital Status")
                {
                }
                field(Gender; Gender)
                {
                }
                field(Nationality; Nationality)
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                Visible = false;
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
                    Caption = 'Overall Rating';
                }
                field("Interview Remarks"; "Interview Remarks")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group()
            {
                action("<Action1000000109>")
                {
                    Caption = 'Post';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //msg('123');

                        TESTFIELD("Interview Marks");
                        TESTFIELD("Father Name");
                        TESTFIELD("GrandFather Name");
                        TESTFIELD("Citizenship No.");
                        TESTFIELD("Issue Office");
                        TESTFIELD("Issue District");
                        TESTFIELD("Medical Certificate No.");


                        /*
                        AppNew.SETRANGE(AppNew."Application No.","Application No.");
                        IF AppNew.FIND('-') THEN BEGIN
                           IF AppNew."Written Exam" = TRUE THEN BEGIN
                           MESSAGE(text0002);
                           END ELSE BEGIN
                           AppNew."Written Exam" := TRUE;
                           AppNew.MODIFY;
                           MESSAGE(text0001);
                           END;
                        END;
                        */

                        //sm not to again convert to employee if it is already employed
                        IF Employed = TRUE THEN BEGIN
                            ERROR(text0003);
                        END ELSE BEGIN
                            IF HRSetup."Apply System Restriction" THEN BEGIN
                                HRPermission.GET(USERID);
                                IF HRPermission."Application Proces. Authority" THEN BEGIN
                                    ConfirmEmploy := DIALOG.CONFIRM(text0006, FALSE);
                                    IF NOT ConfirmEmploy THEN BEGIN
                                        MESSAGE(text0004, USERID);
                                    END;
                                END ELSE
                                    ERROR(text0005);
                            END ELSE BEGIN
                                ConfirmEmploy := DIALOG.CONFIRM(text0006, FALSE);
                                IF NOT ConfirmEmploy THEN BEGIN
                                    MESSAGE(text0004, USERID);
                                END ELSE BEGIN
                                    //Code here to transfer records to employee card
                                    Employee.INIT;
                                    Employee."Full Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
                                    Employee."First Name" := "First Name";
                                    Employee."Middle Name" := "Middle Name";
                                    Employee."Last Name" := "Last Name";
                                    //Employee.Initials := Initials;
                                    Employee."Job Title" := "Position Applied";
                                    Employee.Gender := Gender;
                                    Employee.Nationality := Nationality;
                                    Employee."Marital Status" := "Marital Status";
                                    Employee.P_WardNo := P_WardNo;
                                    Employee.P_VDC_NP := P_Vdc_Np;
                                    Employee.P_District := P_District;
                                    Employee.T_WardNo := T_WardNo;
                                    Employee.T_VDC_NP := T_Vdc_Np;
                                    Employee.T_District := T_District;
                                    //Employee."Phone No." := "Phone No.";
                                    Employee."Phone No." := Telephone;
                                    Employee."Mobile Phone No.1" := CellPhone;
                                    Employee."Personal E-Mail" := Email;
                                    Employee."Father Name" := "Father Name";
                                    Employee."GrandFather Name" := "GrandFather Name";
                                    Employee."Citizenship No." := "Citizenship No.";
                                    Employee."Issue Office" := "Issue Office";
                                    Employee."Issue District" := "Issue District";
                                    Employee."Medical Certificate No." := "Medical Certificate No.";

                                    //Employee.Picture := Picture;
                                    //Employee.VALIDATE("Birth Date",DOB);
                                    //Employee."Social Security No." := "Social Security No.";
                                    //Employee."Application No." := "No.";

                                    //Employee.Department := Department;
                                    /*Employee."Driving License" := "Driving License";
                                    Employee."Driving License No." := "Driving License No.";
                                    Employee."Passport No." := "Passport No.";
                                    Employee.VALIDATE("Passport Issue Date","Passport Issue Date");
                                    Employee.VALIDATE("Passport Expiry Date","Passport Expiry Date");
                                    Employee."Passport Issue Place" := "Passport Issued Place";
                                    Employee."Visa Type" := "Visa Type";
                                    Employee."Work Permit No." := "Work Permit No.";
                                    Employee.VALIDATE("Work Permit Expiry Date","Work Permit Expiry Date");
                                    Employee."Employment Type" := "Applied Type";
                                    */
                                    Employee."Applicant No." := "Application No.";
                                    Employee.INSERT(TRUE);

                                    Employed := TRUE;
                                    "Posted by- Employed" := USERID;
                                    "Posted Date- Employed" := TODAY;
                                    MODIFY;

                                    Employee.FIND('+');
                                    NewEmployeeNum := Employee."No.";
                                    MESSAGE('%1', NewEmployeeNum);

                                    //sm to enter data in education of employee table
                                    Education.INIT;
                                    Education."Employee No." := NewEmployeeNum;
                                    Education.M_Faculty := M_Faculty;
                                    Education.M_College := M_College;
                                    Education.M_University := M_University;
                                    Education.M_Percentage := M_Percentage;
                                    Education.M_PassedYear := M_PassedYear;
                                    Education.B_Faculty := B_Faculty;
                                    Education.B_College := B_College;
                                    Education.B_University := B_University;
                                    Education.B_Percentage := B_Percentage;
                                    Education.B_PassedYear := B_PassedYear;
                                    Education.I_Faculty := I_Faculty;
                                    Education.I_College := I_College;
                                    Education.I_University := I_University;
                                    Education.I_Percentage := I_Percentage;
                                    Education.I_PassedYear := I_PassedYear;
                                    Education.S_Faculty := S_Faculty;
                                    Education.S_College := S_College;
                                    Education.S_University := S_University;
                                    Education.S_Percentage := S_Percentage;
                                    Education.S_PassedYear := S_PassedYear;
                                    Education.O_Faculty := O_Faculty;
                                    Education.O_College := O_College;
                                    Education.O_University := O_University;
                                    Education.O_Percentage := O_Percentage;
                                    Education.O_PassedYear := O_PassedYear;
                                    Education.INSERT;

                                    //sm to enter data in Work Experience
                                    /* WorkExp.INIT;
                                     WorkExp."Employee No." := NewEmployeeNum;
                                     WorkExp.WE1_SN := WE1_SN;
                                     WorkExp.WE1_Orgnization := WE1_Orgnization;
                                     WorkExp.WE1_Department := WE1_Department;
                                     WorkExp.WE1_Position := WE1_Position;
                                     WorkExp.WE1_Duration := WE1_Duration;
                                     WorkExp.WE2_SN := WE2_SN;
                                     WorkExp.WE2_Orgnization := WE2_Orgnization;
                                     WorkExp.WE2_Department := WE2_Department;
                                     WorkExp.WE2_Position := WE2_Position;
                                     WorkExp.WE2_Duration := WE2_Duration;
                                     WorkExp.WE3_SN := WE3_SN;
                                     WorkExp.WE3_Orgnization := WE3_Orgnization;
                                     WorkExp.WE3_Department := WE3_Department;
                                     WorkExp.WE3_Position := WE3_Position;
                                     WorkExp.WE3_Duration := WE3_Duration;
                                     WorkExp.WE4_SN := WE4_SN;
                                     WorkExp.WE4_Orgnization := WE4_Orgnization;
                                     WorkExp.WE4_Department := WE4_Department;
                                     WorkExp.WE4_Position := WE4_Position;
                                     WorkExp.WE4_Duration := WE4_Duration;
                                     WorkExp.WE5_SN := WE5_SN;
                                     WorkExp.WE5_Orgnization := WE5_Orgnization;
                                     WorkExp.WE5_Department := WE5_Department;
                                     WorkExp.WE5_Position := WE5_Position;
                                     WorkExp.WE5_Duration := WE5_Duration;
                                     WorkExp.INSERT;    */

                                    //inserting the value to Education Line of the Employee
                                    IF M_Faculty <> '' THEN
                                        IF M_Faculty <> '-' THEN BEGIN
                                            educationLine.INIT;
                                            educationLine."Line No." := lineNo + 10000;
                                            lineNo := educationLine."Line No.";
                                            educationLine."Employee Code" := NewEmployeeNum;
                                            educationLine.Degree := educationLine.Degree::Master;
                                            educationLine.Faculty := M_Faculty;
                                            educationLine."College/ Institution" := M_College;
                                            educationLine."University/ Board" := M_University;
                                            educationLine."Percentage/ GPA" := M_Percentage;
                                            educationLine."Passed Year" := M_PassedYear;
                                            educationLine.INSERT(TRUE);
                                        END;
                                    IF B_Faculty <> '' THEN
                                        IF B_Faculty <> '-' THEN BEGIN
                                            educationLine.RESET;
                                            educationLine.INIT;
                                            educationLine."Employee Code" := NewEmployeeNum;
                                            educationLine."Line No." := lineNo + 10000;
                                            lineNo := educationLine."Line No.";
                                            educationLine.Degree := educationLine.Degree::Bachelors;
                                            educationLine.Faculty := B_Faculty;
                                            educationLine."College/ Institution" := B_College;
                                            educationLine."University/ Board" := B_University;
                                            educationLine."Percentage/ GPA" := B_Percentage;
                                            educationLine."Passed Year" := B_PassedYear;
                                            educationLine.INSERT;
                                        END;
                                    IF I_Faculty <> '' THEN
                                        IF I_Faculty <> '-' THEN BEGIN
                                            educationLine.RESET;
                                            educationLine.INIT;
                                            educationLine."Employee Code" := NewEmployeeNum;
                                            educationLine."Line No." := lineNo + 10000;
                                            lineNo := educationLine."Line No.";
                                            educationLine.Degree := educationLine.Degree::"10+2/ Intermediate";
                                            educationLine.Faculty := I_Faculty;
                                            educationLine."College/ Institution" := I_College;
                                            educationLine."University/ Board" := I_University;
                                            educationLine."Percentage/ GPA" := I_Percentage;
                                            educationLine."Passed Year" := I_PassedYear;
                                            educationLine.INSERT;
                                        END;
                                    IF S_Faculty <> '' THEN
                                        IF S_Faculty <> '-' THEN BEGIN
                                            educationLine.RESET;
                                            educationLine.INIT;
                                            educationLine."Employee Code" := NewEmployeeNum;
                                            educationLine."Line No." := lineNo + 10000;
                                            lineNo := educationLine."Line No.";
                                            educationLine.Degree := educationLine.Degree::SLC;
                                            educationLine.Faculty := S_Faculty;
                                            educationLine."College/ Institution" := S_College;
                                            educationLine."University/ Board" := S_University;
                                            educationLine."Percentage/ GPA" := S_Percentage;
                                            educationLine."Passed Year" := S_PassedYear;
                                            educationLine.INSERT;
                                        END;

                                    IF O_Faculty <> '' THEN
                                        IF O_Faculty <> '-' THEN BEGIN
                                            educationLine.RESET;
                                            educationLine.INIT;
                                            educationLine."Employee Code" := NewEmployeeNum;
                                            educationLine."Line No." := lineNo + 10000;
                                            lineNo := educationLine."Line No.";
                                            educationLine.Degree := educationLine.Degree::Others;
                                            educationLine.Faculty := O_Faculty;
                                            educationLine."College/ Institution" := O_College;
                                            educationLine."University/ Board" := O_University;
                                            educationLine."Percentage/ GPA" := O_Percentage;
                                            educationLine."Passed Year" := O_PassedYear;
                                            educationLine.INSERT;
                                        END;

                                    IF WE1_SN <> WE1_SN::"0" THEN
                                        IF WE1_SN <> WE1_SN::"-" THEN BEGIN
                                            WorkExperienceLine.RESET;
                                            WorkExperienceLine.INIT;
                                            WorkExperienceLine."Employee Code" := NewEmployeeNum;
                                            WorkExperienceLine."Line No." := LineNo1 + 10000;
                                            LineNo1 := WorkExperienceLine."Line No.";
                                            WorkExperienceLine.Organization := WE1_Orgnization;
                                            WorkExperienceLine.Department := WE1_Department;
                                            WorkExperienceLine.Position := WE1_Position;
                                            WorkExperienceLine."Duration in Months" := WE1_Duration;
                                            WorkExperienceLine.INSERT;
                                        END;
                                    IF WE2_SN <> WE2_SN::"0" THEN
                                        IF WE2_SN <> WE2_SN::"-" THEN BEGIN
                                            WorkExperienceLine.RESET;
                                            WorkExperienceLine.INIT;
                                            WorkExperienceLine."Employee Code" := NewEmployeeNum;
                                            WorkExperienceLine."Line No." := LineNo1 + 10000;
                                            LineNo1 := WorkExperienceLine."Line No.";
                                            WorkExperienceLine.Organization := WE2_Orgnization;
                                            WorkExperienceLine.Department := WE2_Department;
                                            WorkExperienceLine.Position := WE2_Position;
                                            WorkExperienceLine."Duration in Months" := WE2_Duration;
                                            WorkExperienceLine.INSERT;
                                        END;
                                    IF WE3_SN <> WE3_SN::"0" THEN
                                        IF WE3_SN <> WE3_SN::"-" THEN BEGIN
                                            WorkExperienceLine.RESET;
                                            WorkExperienceLine.INIT;
                                            WorkExperienceLine."Employee Code" := NewEmployeeNum;
                                            WorkExperienceLine."Line No." := LineNo1 + 10000;
                                            LineNo1 := WorkExperienceLine."Line No.";
                                            WorkExperienceLine.Organization := WE3_Orgnization;
                                            WorkExperienceLine.Department := WE3_Department;
                                            WorkExperienceLine.Position := WE3_Position;
                                            WorkExperienceLine."Duration in Months" := WE3_Duration;
                                            WorkExperienceLine.INSERT;
                                        END;
                                    IF WE4_SN <> WE4_SN::"0" THEN
                                        IF WE4_SN <> WE4_SN::"-" THEN BEGIN
                                            WorkExperienceLine.RESET;
                                            WorkExperienceLine.INIT;
                                            WorkExperienceLine."Employee Code" := NewEmployeeNum;
                                            WorkExperienceLine."Line No." := LineNo1 + 10000;
                                            LineNo1 := WorkExperienceLine."Line No.";
                                            WorkExperienceLine.Organization := WE4_Orgnization;
                                            WorkExperienceLine.Department := WE4_Department;
                                            WorkExperienceLine.Position := WE4_Position;
                                            WorkExperienceLine."Duration in Months" := WE4_Duration;
                                            WorkExperienceLine.INSERT;
                                        END;
                                    IF WE5_SN <> WE5_SN::"0" THEN
                                        IF WE5_SN <> WE5_SN::"-" THEN BEGIN
                                            WorkExperienceLine.RESET;
                                            WorkExperienceLine.INIT;
                                            WorkExperienceLine."Employee Code" := NewEmployeeNum;
                                            WorkExperienceLine."Line No." := LineNo1 + 10000;
                                            LineNo1 := WorkExperienceLine."Line No.";
                                            WorkExperienceLine.Organization := WE5_Orgnization;
                                            WorkExperienceLine.Department := WE5_Department;
                                            WorkExperienceLine.Position := WE5_Position;
                                            WorkExperienceLine."Duration in Months" := WE5_Duration;
                                            WorkExperienceLine.INSERT;
                                        END;

                                    MESSAGE(text0007);


                                END;
                            END;
                        END;

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
        HRPermission: Record "33020304";
        educationLine: Record "33020420";
        lineNo: Integer;
        WorkExperienceLine: Record "33020421";
        LineNo1: Integer;
}

