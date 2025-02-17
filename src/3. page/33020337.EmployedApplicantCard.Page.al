page 33020337 "Employed Applicant Card"
{
    PageType = Card;
    SourceTable = Table33020330;
    SourceTableView = SORTING(No.)
                      ORDER(Ascending)
                      WHERE(Status = CONST(Employed),
                            Employed = CONST(Yes));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
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
                }
                field("Applied Job Title"; "Applied Job Title")
                {
                }
                field("Applied Job Title Descp."; "Applied Job Title Descp.")
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
            part("Requirement(s)"; 33020329)
            {
                Caption = 'Requirement(s)';
                SubPageLink = Code = FIELD(No.);
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
                RunPageLink = No.=FIELD(No.),
                              Status=CONST(Employed);
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

                trigger OnAction()
                begin
                    HRCommentRec.RESET;
                    HRCommentRec.SETRANGE("No.","No.");
                    HRCommentRec.SETFILTER("Table Name",'Application');
                    HRCommentPage.SETTABLEVIEW(HRCommentRec);
                    HRCommentPage.RUN;
                    RESET;
                end;
            }
            action(InterviewComments)
            {
                Caption = 'Interview Comment(s)';
                RunObject = Page 33020335;
                                RunPageLink = Application No.=FIELD(No.);

                trigger OnAction()
                begin
                    AppIntRec.RESET;
                    AppIntRec.SETRANGE("Application No.","No.");
                    AppIntPage.SETTABLEVIEW(AppIntRec);
                    AppIntPage.EDITABLE(FALSE);
                    AppIntPage.RUN;
                end;
            }
            action(PrevWorkHist)
            {
                Caption = 'Previous Work History';
                RunObject = Page 33020331;
                                RunPageLink = No.=FIELD(No.),
                              Table Name=CONST(Application);

                trigger OnAction()
                begin
                    PWHRec.RESET;
                    PWHRec.SETRANGE("No.","No.");
                    PWHRec.SETFILTER("Table Name",'Application');
                    PWHPage.SETTABLEVIEW(PWHRec);
                    PWHPage.EDITABLE(FALSE);
                    PWHPage.RUN;
                    RESET;
                end;
            }
            action(EducationSkill)
            {
                Caption = 'Education and Skills';
                RunObject = Page 33020336;
                                RunPageLink = No.=FIELD(No.);

                trigger OnAction()
                begin
                    EduSkillRec.RESET;
                    EduSkillRec.SETRANGE("Application No.","No.");
                    EduSkillPage.SETTABLEVIEW(EduSkillRec);
                    EduSkillPage.EDITABLE(FALSE);
                    EduSkillPage.RUN;
                    RESET;
                end;
            }
            separator()
            {
            }
            group("<Action1102159072>")
            {
                Caption = 'Attachment(s)';
                action(AttImport)
                {
                    Caption = 'Import';

                    trigger OnAction()
                    var
                        RBAutoMngt: Codeunit "419";
                        FileName: Text[250];
                        BLOBRef: Record "99008535";
                        ImportFromFile: Text[250];
                        AttachmentMngt: Codeunit "5052";
                    begin
                        //Code open an browser and takes the input file and saves in the database.
                        //CurrForm.SETSELECTIONFILTER(Rec);

                        FileName := RBAutoMngt.BLOBImport(BLOBRef,ImportFromFile);//,ImportFromFile = '' );
                        IF FileName <> '' THEN BEGIN
                          HRAttachment.RESET;
                          IF HRAttachment.FIND('+') THEN BEGIN
                            EntryNo := HRAttachment."Entry No.";
                            EntryNo := EntryNo + 1;
                          END;
                          HRAttachment.INIT;
                          HRAttachment."Entry No." := EntryNo;
                          HRAttachment."Table Name" := HRAttachment."Table Name"::Application;
                          HRAttachment.Attachment := BLOBRef.Blob;
                          HRAttachment."File Extension" := UPPERCASE(FileMgmt.GetExtension(FileName));// AttachmentMngt.FileExtension(FileName));
                          HRAttachment.Code := "No.";
                          HRAttachment.INSERT;
                        END;
                    end;
                }
                action(AttOpen)
                {
                    Caption = 'Open';

                    trigger OnAction()
                    var
                        HRAttForm: Page "33020332";
                    begin
                        //Code to filter the HR Attachment record and get the attachment.
                        //CurrForm.SETSELECTIONFILTER(Rec);

                        HRAttachment.FILTERGROUP(2);
                        HRAttachment.SETFILTER("Table Name",'Application');
                        HRAttachment.SETRANGE(Code,"No.");
                        HRAttachment.FILTERGROUP(0);
                        HRAttForm.SETTABLEVIEW(HRAttachment);
                        HRAttForm.RUN();
                    end;
                }
                action(AttDelete)
                {
                    Caption = 'Delete';

                    trigger OnAction()
                    var
                        ConfirmDelete: Boolean;
                    begin
                        //Code to delete the attachment.

                        ConfirmDelete := DIALOG.CONFIRM(Text003,FALSE);
                        IF ConfirmDelete THEN BEGIN
                          HRAttachment.FILTERGROUP(2);
                          HRAttachment.SETFILTER("Table Name",'Application');
                          HRAttachment.SETRANGE(Code,"No.");
                          HRAttachment.FILTERGROUP(0);
                          IF HRAttachment.FIND('-') THEN
                            HRAttachment.DELETEALL;
                        END ELSE
                          MESSAGE(Text004,USERID);
                    end;
                }
            }
            separator()
            {
            }
            group("<Action1102159077>")
            {
                Caption = 'Interview Assessment Form';
                action("<Action1102159078>")
                {
                    Caption = 'Application - Delete';
                }
            }
        }
    }

    var
        PictureExists: Boolean;
        HRSetup: Record "5218";
        HRAttachment: Record "33020334";
        EntryNo: Integer;
        AppIntRec: Record "33020329";
        IntAssReport: Report "1";
                          PWHRec: Record "33020333";
                          PWHPage: Page "33020331";
                          AppIntPage: Page "33020335";
                          EduSkillPage: Page "33020336";
                          EduSkillRec: Record "33020341";
                          HRCommentRec: Record "5208";
                          Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
        Text003: Label 'Are you sure - Delete?';
        Text004: Label 'Deletion aborted by user - %1!';
        HRCommentPage: Page "5222";
                           FileMgmt: Codeunit "419";
}

