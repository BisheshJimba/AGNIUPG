page 33020394 "PostODD/Training/Gatepass card"
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
                }
                field("Employee Code"; "Employee Code")
                {
                    Editable = false;
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
                    Editable = false;
                }
                field("Request Date (BS)"; "Request Date (BS)")
                {
                    Editable = false;
                }
                field(Type; Type)
                {
                    Editable = false;
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
                field("Pay Type"; "Pay Type")
                {
                }
                field("Manager Name"; "Manager Name")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ApproveAuthority;

                    TESTFIELD("Pay Type");
                    ConfirmApprove := DIALOG.CONFIRM(Text002, TRUE);
                    IF ConfirmApprove THEN BEGIN
                        //updating Approve in ODD/ Training/ Gate Pass Table
                        ODDRec.RESET;
                        ODDRec.SETRANGE("Entry No.", "Entry No.");
                        ODDRec.SETRANGE("Employee Code", "Employee Code");
                        IF ODDRec.FINDFIRST THEN BEGIN
                            ODDRec.Approve := TRUE;
                            ODDRec."Approved By" := USERID;
                            ODDRec."Approved Date" := TODAY;
                            ODDRec.MODIFY;
                        END;

                        //Creatinge lines in Leave Register Table
                        LeaveRegister.INIT;
                        LeaveRegister."Employee No." := ODDRec."Employee Code";
                        LeaveRegister."External No" := ODDRec."Entry No.";
                        EmpRec.RESET;
                        EmpRec.SETRANGE("No.", "Employee Code");
                        IF EmpRec.FINDFIRST THEN BEGIN
                            LeaveRegister."First Name" := EmpRec."First Name";
                            LeaveRegister."Middle Name" := EmpRec."Middle Name";
                            LeaveRegister."Last Name" := EmpRec."Last Name";
                            LeaveRegister."Full Name" := EmpRec."Full Name";
                            LeaveRegister."Manager ID" := EmpRec."Manager ID";
                            LeaveRegister.Branch := EmpRec."Branch Code";
                            LeaveRegister.Department := EmpRec."Department Code";
                            LeaveRegister."Work Shift Code" := EmpRec."Work Shift Code";
                        END;
                        LeaveRegister."Leave Start Date" := ODDRec."Start Date";
                        LeaveRegister."Leave End Date" := ODDRec."End Date";
                        LeaveRegister."Leave Start Time" := ODDRec."Start Time";
                        LeaveRegister."Leave End Time" := ODDRec."End Time";
                        LeaveRegister.Remarks := ODDRec.Purpose;
                        LeaveRegister.Approved := TRUE;
                        LeaveRegister."Approved By" := USERID;
                        LeaveRegister."Approved Date" := TODAY;
                        LeaveRegister."Request Date" := ODDRec."Request Date (AD)";
                        LeaveRegister."Request Time" := ODDRec."Request Time";
                        IF ODDRec.Type = 1 THEN
                            LeaveRegister.Type := 2;

                        IF ODDRec.Type = 2 THEN
                            LeaveRegister.Type := 3;

                        IF ODDRec.Type = 3 THEN
                            LeaveRegister.Type := 5;

                        LeaveRegister."Pay Type" := ODDRec."Pay Type";
                        LeaveRegister.INSERT(TRUE);
                        LeaveRegister.FINDLAST;
                        EntryNo := LeaveRegister."Entry No.";
                        MESSAGE('The record has been successfully Approved.');
                    END;

                    //Send Mail
                    //SendMail1();   <not to send mail>
                end;
            }
            action(Disapprove)
            {
                Caption = 'Disapprove';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    HRPermissionRec.GET(USERID);
                    IF NOT HRPermissionRec."HR Admin" THEN
                        ERROR('You do not have permission !');

                    ConfirmDisapprove := DIALOG.CONFIRM(Text003, TRUE);
                    IF ConfirmApprove THEN BEGIN
                        //updating Approve in ODD/ Training/ Gate Pass Table
                        ODDRec.RESET;
                        ODDRec.SETRANGE("Entry No.", "Entry No.");
                        ODDRec.SETRANGE("Employee Code", "Employee Code");
                        IF ODDRec.FINDFIRST THEN BEGIN
                            ODDRec.Disapprove := TRUE;
                            ODDRec."Rejected By" := USERID;
                            ODDRec."Rejected Date" := TODAY;
                            ODDRec.MODIFY;
                        END;
                        MESSAGE('The record has been Disapproved');
                    END;
                    //Send Mail
                    SendMail2();
                end;
            }
        }
    }

    var
        text001: Label 'The record has already been already Approved or Disapproved.';
        ODDRec: Record "33020423";
        ConfirmApprove: Boolean;
        ConfirmDisapprove: Boolean;
        Text002: Label 'Do you want to Approve?';
        LeaveRegister: Record "33020343";
        EntryNo: Code[20];
        EmpRec: Record "5200";
        Text003: Label 'Do you want to Disapprove?';
        Text0003: Label 'Email has been successfully sent. Please check your Outlook';
        Text0004: Label 'There is no email address of your Manager. Please contact your administrator';
        HRPermissionRec: Record "33020304";

    [Scope('Internal')]
    procedure SendMail1()
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
    begin
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FIND('-') THEN
            MailTo := EmpRec."Company E-Mail";
        //ManagerName := EmpRec."Full Name";

        FromDateText := FORMAT("Start Date", 0, 4);
        ToDateText := FORMAT("End Date", 0, 4);
        FromTimeText := FORMAT("Start Time");
        ToTimeText := FORMAT("End Time");

        Dear := 'Dear ' + "Full Name" + ';';
        Subject := 'About ' + FORMAT(Type) + ' Approval.';
        MessageText := 'Your request has been approved, for ' + FORMAT(Type) + ' starting from ' + FromDateText + ' ' + FromTimeText +
                 ' to ' + ToDateText + ' ' + ToTimeText;

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
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br> Manager <br><br><hr>';
            /*
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();
            */

            SMTPMail.CreateMessage(MailTo, SenderAddress, MailTo, Subject, EmailBody, TRUE);       //Employee's Email address
            SMTPMail.AddCC(MailTo);
            SMTPMail.Send();
            MESSAGE(Text0003);
        END ELSE
            ERROR(Text0004);

    end;

    [Scope('Internal')]
    procedure SendMail2()
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
    begin
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FIND('-') THEN
            MailTo := EmpRec."Company E-Mail";
        //ManagerName := EmpRec."Full Name";

        FromDateText := FORMAT("Start Date", 0, 4);
        ToDateText := FORMAT("End Date", 0, 4);
        FromTimeText := FORMAT("Start Time");
        ToTimeText := FORMAT("End Time");

        Dear := 'Dear ' + "Full Name" + ';';
        Subject := 'About ' + FORMAT(Type) + ' Disapproval.';
        MessageText := 'Your request has been disapprove, for ' + FORMAT(Type) + ' starting from ' + FromDateText + ' ' + FromTimeText +
                 ' to ' + ToDateText + ' ' + ToTimeText;

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
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br> Manager <br><br><hr>';
            /*
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();
            */
            SMTPMail.CreateMessage(MailTo, SenderAddress, MailTo, Subject, EmailBody, TRUE);       //Employee's Email address
            SMTPMail.AddCC(MailTo);
            SMTPMail.Send();
            MESSAGE(Text0003);
        END ELSE
            ERROR(Text0004);

    end;

    [Scope('Internal')]
    procedure ApproveAuthority()
    var
        DeptCode: Code[20];
        Text001: Label 'You do not have permission to change for other Departmant %1!';
        Approve1: Code[50];
        Approve2: Code[50];
        Emp1: Record "5200";
        Emp2: Record "5200";
        HRPermission: Record "33020304";
        HRUP: Record "33020304";
    begin
        HRUP.GET(USERID);
        IF NOT ((HRUP."Admin Permission") OR (HRUP."Branch Admin")) THEN BEGIN
            Emp1.RESET;
            Emp1.SETRANGE("No.", ManagerID);
            IF Emp1.FINDFIRST THEN
                IF (Emp1."User ID" <> '') THEN
                    Approve1 := Emp1."User ID";
            Emp2.RESET;
            Emp2.SETRANGE("No.", Emp1."Manager ID");
            IF Emp2.FINDFIRST THEN
                IF (Emp2."User ID" <> '') THEN
                    Approve2 := Emp2."User ID";
            //message(Approve1);
            IF ((Approve1 <> '') OR (Approve2 <> '')) THEN BEGIN
                IF NOT (UPPERCASE(USERID) = Approve1) THEN BEGIN
                    IF NOT (UPPERCASE(USERID) = Approve2) THEN
                        ERROR('You do not have permission to Process this %1', Type);
                END;
            END
            ELSE
                ERROR('USERID is Missing in Managers employee card');
        END;
    end;
}

