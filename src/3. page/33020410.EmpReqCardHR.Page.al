page 33020410 "Emp Req Card HR"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table33020379;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(EmpReqNo; EmpReqNo)
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
                field("Position Code"; "Position Code")
                {
                    Editable = false;
                }
                field("Position Name"; "Position Name")
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
                field(Branch; Branch)
                {
                    Editable = false;
                }
                field(Segment; Segment)
                {
                    Caption = 'Job Role';
                    Editable = false;
                }
                field("Date Required"; "Date Required")
                {
                    Editable = false;
                }
                field("No. of Position"; "No. of Position")
                {
                    Editable = false;
                }
                field("Reason for Requirement"; "Reason for Requirement")
                {
                    Editable = false;
                }
                field("Job Description"; "Job Description")
                {
                    Editable = false;
                }
                field("Remarks on Reason"; "Remarks on Reason")
                {
                    Editable = false;
                }
                field("Posted By"; "Posted By")
                {
                    Caption = 'Posted By';
                    Editable = false;
                }
                field("Posted Date"; "Posted Date")
                {
                    Editable = false;
                }
            }
            group("For HR")
            {
                field("Budget Verification"; "Budget Verification")
                {
                }
                field("Remark by HR"; "Remark by HR")
                {
                }
                field("Checked By"; "Checked By")
                {
                    Visible = false;
                }
                field("Checked Date"; "Checked Date")
                {
                    Visible = false;
                }
                field(Status; Status)
                {

                    trigger OnValidate()
                    begin
                        /* if status = status :: resubmit then begin
                         //currpage."Resubmit (Weeks)".(visible) := true;
                        "Resubmit (Weeks)":= currpage.VISIBLE(true);
                        end;
                         */

                    end;
                }
                field("Resubmit (Weeks)"; "Resubmit (Weeks)")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field("Minute No"; "Minute No")
                {
                }
                field("Remarks on Approval"; "Remarks on Approval")
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
        area(creation)
        {
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
        EmpRec: Record "5200";
        HRPermissionRec: Record "33020304";

    [Scope('Internal')]
    procedure SendMail()
    var
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[50];
        MessageText: Text[250];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
        Initial: Text[50];
        Gender: Option;
        SMTPMail: Codeunit "400";
        SMTPMailSetup: Record "409";
    begin


        //TESTFIELD("Resubmit (Weeks)");

        EmpRec.RESET;
        EmpRec.SETRANGE(EmpRec."User ID", "Document Created By");
        IF EmpRec.FINDFIRST THEN
            MailTo := EmpRec."Company E-Mail";
        EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
        IF EmpRec.Gender = EmpRec.Gender::Male THEN
            Initial := 'Mr. ';
        IF EmpRec.Gender = EmpRec.Gender::Female THEN
            Initial := 'Ms. ';

        Dear := 'Dear ' + Initial + EmpName + ',';
        Subject := FORMAT(Status);
        MessageText := 'Employee Requisiton ' + EmpReqNo + ' for the post of ' +
          "Position Name" + ' , Department - ' + "Department Name" + ', Branch - ' + Branch + 'has been %1';

        IF MailTo <> '' THEN BEGIN

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';

            MESSAGE(Text010);
        END ELSE
            ERROR(Text009);

        SMTPMailSetup.GET;
        //
        SMTPMail.CreateMessage('HRD', SMTPMailSetup."User ID", MailTo, STRSUBSTNO(Subject, COMPANYNAME), '', TRUE);
        SMTPMail.AppendBody('<font face="Calibri (Body)" Size="3.5" color="#000080"><br>');
        // SMTPMail.AppendBody('Dear Sir/Maam');
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody(STRSUBSTNO(EmailBody, FORMAT(Rec.Status)));
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('Company Name:' + ' ' + FORMAT(COMPANYNAME));
        SMTPMail.AppendBody('<br><br>');
        // SMTPMail.AppendBody(FooterText);
        SMTPMail.AppendBody('<br><br>');
        SMTPMail.AppendBody('With Regards.');

        SMTPMail.Send;
        //
    end;
}

