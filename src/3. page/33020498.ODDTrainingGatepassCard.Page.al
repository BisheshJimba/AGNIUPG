page 33020498 "ODD/ Training/ Gatepass Card"
{
    PageType = Card;
    SourceTable = Table33020423;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; "Entry No.")
                {

                    trigger OnValidate()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Full Name"; "Full Name")
                {
                    Editable = false;
                }
                field("Job Title"; "Job Title")
                {
                    Editable = false;
                }
                field(Department; Department)
                {
                    Editable = false;
                }
                field(Branch; Branch)
                {
                    Editable = false;
                }
                field("Request Date (AD)"; "Request Date (AD)")
                {
                }
                field("Request Date (BS)"; "Request Date (BS)")
                {
                    Editable = false;
                }
                field(Type; Type)
                {
                }
                field("Gate Pass Reasons"; "Gate Pass Reasons")
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("Start Time"; "Start Time")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("End Time"; "End Time")
                {
                }
                field("Plan of Travel"; "Plan of Travel")
                {
                }
                field(Place; Place)
                {
                }
                field("Time Required"; "Time Required")
                {
                    Editable = false;
                }
                field(Purpose; Purpose)
                {
                }
                field("Mode of Travel"; "Mode of Travel")
                {
                }
                field("Advance Amount"; "Advance Amount")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field(ManagerID; ManagerID)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD(Type);
                    TESTFIELD("Time Required");
                    TESTFIELD(ManagerID);

                    ConfirmPost := DIALOG.CONFIRM(Text0001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        OTGRec.RESET;
                        OTGRec.SETRANGE("Entry No.", "Entry No.");
                        IF OTGRec.FINDFIRST THEN BEGIN
                            Posted := TRUE;
                            "Posted By" := USERID;
                            "Posted Date" := TODAY;
                        END;

                        IF ManagerID = '' THEN BEGIN
                            ERROR(Text0002);
                        END ELSE BEGIN
                            SendMail();
                        END;
                    END;
                end;
            }
        }
    }

    var
        ConfirmPost: Boolean;
        Text0001: Label 'Do you want to Post?';
        OTGRec: Record "33020423";
        Text0002: Label 'Manager ID No. is blank in Employee Registration! Please contact your system manager.';
        EmpRec: Record "5200";
        Text0003: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Text0004: Label 'There is no Manager e- mail address! Please contact your system administrator.';

    [Scope('Internal')]
    procedure SendMail()
    var
        EmailBody: Text[1024];
        MailTo: Text[80];
        FromDateText: Text[30];
        ToDateText: Text[30];
        Dear: Text[100];
        Subject: Text[100];
        MessageText: Text[250];
        ManagerName: Text[90];
        FromTimeText: Text[30];
        ToTimeText: Text[30];
        SMTPMail: Codeunit "400";
        SenderName: Text[100];
        SenderAddress: Text[80];
        SMTP: Record "409";
        EmpRecord: Record "5200";
        CompanyInfo: Record "79";
    begin
        CompanyInfo.GET;
        SMTP.GET;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", ManagerID);
        IF EmpRec.FIND('-') THEN
            MailTo := EmpRec."Company E-Mail";
        ManagerName := EmpRec."Full Name";

        FromDateText := FORMAT("Start Date", 0, 4);
        ToDateText := FORMAT("End Date", 0, 4);
        FromTimeText := FORMAT("Start Time");
        ToTimeText := FORMAT("End Time");

        Dear := 'Dear ' + ManagerName + ';';
        Subject := 'About ' + FORMAT(Type) + ' permission.';
        MessageText := 'With due respect, I ' + "Full Name" + ' would like to request for ' + FORMAT(Type) + ' - ' +
                    FromDateText + ' ' + FromTimeText + ' to ' + ToDateText + ' - ' + ToTimeText + '.';

        IF MailTo <> '' THEN BEGIN
            /*
            IF ISCLEAR(ObjApp) THEN
                 CREATE(ObjApp,TRUE,TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);
            */
            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
            EmailBody := EmailBody + Dear + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                         + "Full Name" + '<br><br><hr>';
            /*
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();
            */

            EmpRecord.RESET;
            EmpRecord.SETRANGE("No.", "Employee Code");
            EmpRecord.FINDFIRST;

            SMTPMail.CreateMessage(MailTo, SMTP."User ID", MailTo, Subject, EmailBody, TRUE);
            //SMTPMail.CreateMessage(CompanyInfo.Name,SMTP."User ID",MailTo,Subject,EmailBody,TRUE);
            SMTPMail.AddCC(MailTo);
            SMTPMail.Send();

            MESSAGE(Text0003);
        END ELSE
            ERROR(Text0004);

    end;
}

