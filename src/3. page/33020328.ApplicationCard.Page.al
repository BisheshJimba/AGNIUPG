page 33020328 "Application Card"
{
    PageType = Card;
    SourceTable = Table33020330;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Name; Name)
                {
                }
                field(Initials; Initials)
                {
                }
                field(Address; Address)
                {
                }
                field(City; City)
                {
                }
                field(Country; Country)
                {
                }
                field("Entry Date"; "Entry Date")
                {
                }
                field("Additional Entry Date"; "Additional Entry Date")
                {
                }
                field("Search Name"; "Search Name")
                {
                }
                field(Gender; Gender)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Mobile No."; "Mobile No.")
                {
                }
                field(Picture; Picture)
                {
                }
            }
            group(Personal)
            {
                field("Birth Date"; "Birth Date")
                {
                }
                field("Additional Birth Date"; "Additional Birth Date")
                {
                }
                field("Social Security No."; "Social Security No.")
                {
                }
                field("Family Status"; "Family Status")
                {
                }
                field(Religion; Religion)
                {
                }
                field(Nationality; Nationality)
                {
                }
                field("Driving License"; "Driving License")
                {
                }
                field("Driving License No."; "Driving License No.")
                {
                }
            }
            group(Foreign)
            {
                field("Passport No."; "Passport No.")
                {
                }
                field("Passport Issue Date"; "Passport Issue Date")
                {
                }
                field("Additional Passport Issue Date"; "Additional Passport Issue Date")
                {
                }
                field("Passport Expiry Date"; "Passport Expiry Date")
                {
                }
                field("Add. Passport Expiry Date"; "Add. Passport Expiry Date")
                {
                }
                field("Passport Issued Place"; "Passport Issued Place")
                {
                }
                field("Visa Type"; "Visa Type")
                {
                }
                field("Work Permit No."; "Work Permit No.")
                {
                }
                field("Work Permit Expiry Date"; "Work Permit Expiry Date")
                {
                }
                field("Add. Work Permist Expiry Date"; "Add. Work Permist Expiry Date")
                {
                }
                field("Residency No."; "Residency No.")
                {
                }
            }
            group(Administration)
            {
                field("Vacancy No."; "Vacancy No.")
                {

                    trigger OnValidate()
                    begin
                        /*
                        Vacancy.SETRANGE("Vacany No.","Vacancy No.");
                        IF Vacancy.FIND('-') THEN BEGIN
                          "Applied Job Title" := Vacancy."Job Title";
                          "Applied Job Title Descp." := Vacancy."Job Description";
                        END;
                        */

                    end;
                }
                field("Applied Job Title"; "Applied Job Title")
                {
                }
                field("Applied Job Title Descp."; "Applied Job Title Descp.")
                {
                }
                field(Department; Department)
                {
                }
                field("Application Date"; "Application Date")
                {
                }
                field("Additional Application Date"; "Additional Application Date")
                {
                }
                field("Applied Type"; "Applied Type")
                {
                }
                field(Status; Status)
                {
                    Editable = EmpStatus;
                }
                field(Employed; Employed)
                {
                }
                field("Employed Date"; "Employed Date")
                {
                }
                field("Add. Employed Date"; "Add. Employed Date")
                {
                }
                field("Offer Sent"; "Offer Sent")
                {
                }
                field("Offer Sent Date"; "Offer Sent Date")
                {
                }
                field("Add. Offer Sent Date"; "Add. Offer Sent Date")
                {
                }
            }
            part("Induction CheckList"; 33019861)
            {
                SubPageLink = Applicant No.=FIELD(No.);
            }
            part("HR Attachment"; 33019862)
            {
                SubPageLink = No.=FIELD(No.);
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(List)
            {
                Caption = 'List';
                RunObject = Page 33020333;
            }
            separator()
            {
            }
            action(Comments)
            {
                Caption = 'Comment(s)';
                RunObject = Page 5222;
                RunPageLink = Table Name=CONST(Application),
                              No.=FIELD(No.);
            }
            action(InterviewComments)
            {
                Caption = 'Interview Comment(s)';
                RunObject = Page 33020335;
                                RunPageLink = Application No.=FIELD(No.);
                RunPageMode = Edit;
            }
            action(PrevWorkHist)
            {
                Caption = 'Previous Work History';
                RunObject = Page 33020331;
                                RunPageLink = No.=FIELD(No.),
                              Table Name=CONST(Application);
            }
            action(EducationSkill)
            {
                Caption = 'Education and Skills';
                RunObject = Page 5206;
                                RunPageLink = No.=FIELD(No.),
                              Table Name=CONST(Application);
            }
            separator()
            {
            }
            action("Application - Delete")
            {
                Caption = 'Application - Delete';
            }
        }
        area(processing)
        {
            group("<Action1102159067>")
            {
                Caption = 'Select/Reject';
                action(select)
                {
                    Caption = 'Select';
                    Image = RegisterPick;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin



                        IF HRSetup."Apply System Restriction" THEN BEGIN
                          UserSetup.GET(USERID);
                          IF UserSetup."Application Proces. Authority" THEN BEGIN
                            ConfirmSelect := DIALOG.CONFIRM(Text009,FALSE);
                            IF NOT ConfirmSelect THEN BEGIN
                               MESSAGE(Text006,USERID);
                            END;
                          END ELSE
                            ERROR(Text007);
                        END ELSE BEGIN
                          ConfirmSelect := DIALOG.CONFIRM(Text009,FALSE);
                          IF NOT ConfirmSelect THEN BEGIN
                               MESSAGE(Text006,USERID);
                          END;
                        END;

                        IF (Select = TRUE) THEN BEGIN
                           ERROR(Text012);
                        END;
                        Select := TRUE;
                        VALIDATE("SR Date",TODAY);
                        EVALUATE(Status,'Selected');
                        MODIFY;
                    end;
                }
                action(shortlist)
                {
                    Caption = 'ShortList';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IF HRSetup."Apply System Restriction" THEN BEGIN
                          UserSetup.GET(USERID);
                          IF UserSetup."Application Proces. Authority" THEN BEGIN
                            ConfirmShortlist := DIALOG.CONFIRM(Text005,FALSE);
                            IF NOT ConfirmShortlist THEN BEGIN
                              MESSAGE(Text006,USERID);
                            END;
                          END ELSE
                            ERROR(Text007);
                        END ELSE BEGIN
                          ConfirmShortlist := DIALOG.CONFIRM(Text005,FALSE);
                          IF NOT ConfirmShortlist THEN BEGIN
                             MESSAGE(Text006,USERID);
                          END;
                        END;

                        IF (Shortlisted = TRUE) THEN BEGIN
                           ERROR(Text012);
                        END;

                        Shortlisted := TRUE;
                        VALIDATE("Shortlisted Date",TODAY);
                        EVALUATE(Status,'Shortlisted');
                        MODIFY;
                    end;
                }
                action(reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IF HRSetup."Apply System Restriction" THEN BEGIN
                          UserSetup.GET(USERID);
                          IF UserSetup."Application Proces. Authority" THEN BEGIN
                           ConfirmReject := DIALOG.CONFIRM(Text010,FALSE);
                            IF NOT ConfirmReject THEN BEGIN
                              MESSAGE(Text006,USERID);
                            END;
                          END ELSE
                            ERROR(Text007);
                        END ELSE BEGIN
                          ConfirmReject := DIALOG.CONFIRM(Text010,FALSE);
                          IF NOT ConfirmReject THEN BEGIN
                             MESSAGE(Text006,USERID);
                          END;
                        END;

                        IF (Reject = TRUE) THEN BEGIN
                           ERROR(Text012);
                        END;

                        Reject := TRUE;
                        VALIDATE("SR Date",TODAY);
                        EVALUATE(Status,'Rejected');
                        MODIFY;
                    end;
                }
            }
            group("<Action1102159072>")
            {
                Caption = 'Reject';
                action(Convert)
                {
                    Caption = 'Convert';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Qualification: Record "5203";
                        PrevHistory: Record "33020333";
                        NewEmployeeNum: Code[10];
                        NewQualification: Record "5203";
                        PrevHistoryEmpConv: Record "33020333";
                        HrInduction: Record "33020375";
                    begin
                        //sm not to again convert to employee if it is already employed

                        HrInduction.RESET;
                        HrInduction.SETRANGE("Applicant No.","No.");
                        HrInduction.SETFILTER(Checklist,'<>%1','');
                        IF HrInduction.ISEMPTY THEN
                          ERROR('HR induction must have a value.');


                        IF Employed = TRUE THEN BEGIN
                           ERROR(Text013);
                        END ELSE BEGIN
                        IF HRSetup."Apply System Restriction" THEN BEGIN
                          UserSetup.GET(USERID);
                          IF UserSetup."Application Proces. Authority" THEN BEGIN
                          ConfirmEmploy := DIALOG.CONFIRM(Text011,FALSE);
                            IF NOT ConfirmEmploy THEN BEGIN
                              MESSAGE(Text006,USERID);
                            END;
                          END ELSE
                            ERROR(Text007);
                        END ELSE BEGIN
                          ConfirmEmploy := DIALOG.CONFIRM(Text011,FALSE);
                          IF NOT ConfirmEmploy THEN BEGIN
                             MESSAGE(Text006,USERID);
                          END;
                        END;
                        //Code here to transfer records to employee card
                        Employee.INIT;
                        Employee."Full Name" := Name;
                        Employee.Initials := Initials;
                        Employee."Job Title" := "Applied Job Title Descp.";
                        Employee.Address := Address;
                        Employee.City := City;
                        Employee.County := Country;
                        Employee.Gender := Gender;
                        Employee."Phone No." := "Phone No.";
                        Employee."Mobile Phone No.1" := "Mobile No.";
                        Employee."Personal E-Mail" := Email;
                        Employee.Picture := Picture;
                        Employee.VALIDATE("Birth Date","Birth Date");
                        Employee."Social Security No." := "Social Security No.";
                        //Employee."Application No." := "No.";
                        Employee."Exam Department Code" := Department;
                        Employee."Driving License" := "Driving License";
                        Employee."Driving License No." := "Driving License No.";
                        Employee."Passport No." := "Passport No.";
                        Employee.VALIDATE("Passport Issue Date","Passport Issue Date");
                        Employee.VALIDATE("Passport Expiry Date","Passport Expiry Date");
                        Employee."Passport Issue Place" := "Passport Issued Place";
                        Employee."Visa Type" := "Visa Type";
                        Employee."Residency No." := "Residency No.";
                        Employee."Work Permit No." := "Work Permit No.";
                        Employee.VALIDATE("Work Permit Expiry Date","Work Permit Expiry Date");
                        Employee."Employment Type" := "Applied Type";
                        Employee."Applicant No." := "No.";
                        Employee.INSERT(TRUE);

                        Employed := TRUE;
                        VALIDATE("Employed Date",TODAY);
                        EVALUATE(Status,'Employed');
                        MODIFY;

                        Employee.FIND('+');
                        NewEmployeeNum := Employee."No.";




                        Qualification.RESET;
                        Qualification.SETRANGE("No.","No.");
                        IF Qualification.FIND('-') THEN BEGIN
                          REPEAT
                           CLEAR(NewQualification);
                           NewQualification.INIT;
                           NewQualification."Table Name" := NewQualification."Table Name"::Employee ;
                           NewQualification."No." := NewEmployeeNum;
                           NewQualification."Qualification Code" := Qualification."Qualification Code";
                           NewQualification.INSERT;
                          UNTIL Qualification.NEXT=0;
                        END;

                        PrevHistory.RESET;
                        PrevHistory.SETRANGE("No.","No.");
                        IF PrevHistory.FIND('-') THEN BEGIN
                          REPEAT
                            CLEAR(PrevHistoryEmpConv);
                            PrevHistoryEmpConv.INIT;
                            PrevHistoryEmpConv."Table Name" := PrevHistoryEmpConv."Table Name"::Employee ;
                            PrevHistoryEmpConv."No." := NewEmployeeNum;
                            PrevHistoryEmpConv."Company Name" := PrevHistory."Company Name";
                            PrevHistoryEmpConv."Job Description" := PrevHistory."Job Description";
                            PrevHistoryEmpConv."From Date" := PrevHistory."From Date";
                            PrevHistoryEmpConv."To Date" := PrevHistory."To Date";
                            PrevHistoryEmpConv."Years Worked" := PrevHistory."Years Worked";
                            PrevHistoryEmpConv.INSERT;
                          UNTIL PrevHistory.NEXT=0;
                        END;
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
                        IF NOT CONFIRM('Do you want to confirm sending offer?',FALSE) THEN
                          EXIT;
                        IF "Offer Sent" THEN
                          ERROR('Offer already sent.');
                        "Offer Sent" := TRUE;
                        "Offer Sent Date" := TODAY;
                        MODIFY;
                        MESSAGE('Offer Sent Sucessfully.');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF Employed = TRUE THEN
           EmpStatus := FALSE
        ELSE
           EmpStatus := TRUE
    end;

    var
        PictureExists: Boolean;
        HRSetup: Record "5218";
        HRAttachment: Record "33020334";
        EntryNo: Integer;
        AppIntRec: Record "33020329";
        IntAssReport: Report "1";
                          Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
        Text003: Label 'Are you sure - Delete?';
        Text004: Label 'Deletion aborted by user - %1!';
        Picture: Integer;
        UserSetup: Record "91";
        ConfirmShortlist: Boolean;
        Text005: Label 'Are you sure - Shortlist?';
        Text006: Label 'Aborted by user - %1!';
        Text007: Label 'You donot have permission for application processing. Please contact your system administrator.';
        Text008: Label '%1 - application(s) are shortlisted.';
        ConfirmSelect: Boolean;
        ConfirmReject: Boolean;
        Text009: Label 'Are you sure - Select?';
        Text010: Label 'Are you sure - Reject?';
        ConfirmEmploy: Boolean;
        Employee: Record "5200";
        Text011: Label 'Are you sure to Recruit?';
        Text012: Label 'Applicant already Selected.';
        Vacancy: Record "33020327";
        Text013: Label 'This Applicant is already converted to Employee.';
        [InDataSet]
        EmpStatus: Boolean;
}

