page 33020495 "HR Requisition Card"
{
    PageType = Card;
    SourceTable = Table33020422;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Requisition No."; "Requisition No.")
                {
                    Editable = false;
                }
                field("Department Code"; "Department Code")
                {
                    Editable = false;
                }
                field("Department Name"; "Department Name")
                {
                    Editable = false;
                }
                field("Job Title Code"; "Job Title Code")
                {
                    Editable = false;
                }
                field("Job Title"; "Job Title")
                {
                    Editable = false;
                }
                field("Branch Code"; "Branch Code")
                {
                    Editable = false;
                }
                field("Branch Name"; "Branch Name")
                {
                    Editable = false;
                }
                field("Supervisor Code"; "Supervisor Code")
                {
                    Editable = false;
                }
                field("Supervisor Name"; "Supervisor Name")
                {
                    Editable = false;
                }
                field(Segment; Segment)
                {
                    Editable = false;
                }
                field("Date Required"; "Date Required")
                {
                    Editable = false;
                }
                field("Nature of Manpower"; "Nature of Manpower")
                {
                    Editable = false;
                }
                field("No. of Staff Required"; "No. of Staff Required")
                {
                    Editable = false;
                }
                field("Duration (in months)"; "Duration (in months)")
                {
                    Editable = false;
                }
                field("Brief Description of Duties"; "Brief Description of Duties")
                {
                    Editable = false;
                }
                field(Qualifications; Qualifications)
                {
                    Editable = false;
                }
                field(Experiences; Experiences)
                {
                    Editable = false;
                }
                field("Skills and Qualities"; "Skills and Qualities")
                {
                    Editable = false;
                }
                field(Requirement; Requirement)
                {
                    Editable = false;
                }
                field("Staff Replaced"; "Staff Replaced")
                {
                    Editable = false;
                }
                field("Staff Replaced Name"; "Staff Replaced Name")
                {
                    Editable = false;
                }
                field("Reason for replacement"; "Reason for replacement")
                {
                    Editable = false;
                }
                field("HOD Posted By"; "HOD Posted By")
                {
                    Editable = false;
                }
            }
            group("To be filled by HR")
            {
                Caption = 'To be filled by HR';
                field("Remark by HR"; "Remark by HR")
                {
                }
                field("Date of submission in HRC"; "Date of submission in HRC")
                {
                }
                field(Status; Status)
                {
                }
                field("Remarks on Approval"; "Remarks on Approval")
                {
                }
                field("Resubmit (in Weeks)"; "Resubmit (in Weeks)")
                {
                }
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
        area(processing)
        {
            action("<Action1000000035>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ConfirmPost := DIALOG.CONFIRM(text0001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        "HR Posted By" := USERID;
                        "HR Posted" := TRUE;
                        "HR Posted Date" := TODAY;
                        MESSAGE(text0002);
                    END;
                end;
            }
            action("Send Mail")
            {
                Caption = 'Send Mail';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    HRPermissionRec.GET(USERID);
                    IF NOT HRPermissionRec."Permission to Send Mail" THEN
                        ERROR('You do not have permission !');

                    IF HRPermissionRec."Permission to Send Mail" THEN
                        SendMail();
                end;
            }
        }
    }

    var
        ConfirmPost: Boolean;
        text0001: Label 'Do You want to Post?';
        text0002: Label 'Posted Successfully';
        EmpRec: Record "5200";
        HRPermissionRec: Record "33020304";

    [Scope('Internal')]
    procedure SendMail()
    var
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[250];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
        Initial: Text[30];
        Gender: Option;
    begin


        //TESTFIELD("Resubmit (in Weeks)");

        /*IF Status = Status :: Resubmit THEN BEGIN
          EmpRec.RESET;
          EmpRec.SETRANGE(EmpRec."User ID","HOD Posted By");
          IF EmpRec.FINDFIRST THEN
            MailTo := EmpRec."Company E-Mail";
            EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
            IF EmpRec.Gender = EmpRec.Gender ::Male THEN
            Initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender ::Female THEN
            Initial := 'Ms. ';
        
            Dear := 'Dear ' + Initial + EmpName + ',';
            Subject := 'Resubmit the Employee Requisition ';
            MessageText := 'You are requested to resubmit the Employee Requisiton ' + "Requisition No." + ' for the post of ' +
              "Job Title" +' , Department - '+ "Department Name" + ', Branch - '+ "Branch Name" +  ' after '
              + FORMAT("Resubmit (in Weeks)") + ' weeks.';
        
          IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                 CREATE(ObjApp,TRUE,TRUE);
        
            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);
        
            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear +'<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();
            MESSAGE(Text010);
          END ELSE
            ERROR(Text009);
        
        END ELSE BEGIN
        MESSAGE('Sending E-mail is only for Resubmission case');
        
        END;
        */

    end;
}

