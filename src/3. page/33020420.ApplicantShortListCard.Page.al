page 33020420 "Applicant ShortList Card"
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
                    Caption = 'Select For Written Exam';
                    Image = Start;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //msg('123');
                        AppNew.SETRANGE(AppNew."Application No.", "Application No.");
                        IF AppNew.FIND('-') THEN BEGIN
                            IF AppNew."Written Exam" = TRUE THEN BEGIN
                                MESSAGE(text0002);
                            END ELSE BEGIN
                                AppNew.ShortList := TRUE;
                                AppNew."Written Exam" := TRUE;
                                AppNew."Posted by- Written Exam" := USERID;
                                AppNew."Posted Date- Written Exam" := TODAY;
                                AppNew.MODIFY;
                                MESSAGE(text0001);
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
}

