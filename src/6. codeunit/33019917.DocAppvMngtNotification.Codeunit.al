codeunit 33019917 "Doc. Appv. Mngt - Notification"
{

    trigger OnRun()
    begin
    end;

    var
        GblUserSetup: Record "91";
        GblSMTPMail: Codeunit "400";

    [Scope('Internal')]
    procedure sendInsMemoAppNot(PrmSenderID: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Please check the approval entry list for pending approvals.';
        Subject := 'Request for approval - insurance.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendInsMemoCnclNot(PrmSenderID: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Insurance memo approval sent to you have been canceled.';
        Subject := 'Information of cancelation - insurance request.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendCCMemoAppNot(PrmSenderID: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Please check the approval entry list for pending approvals.';
        Subject := 'Request for approval - Custom Clearance.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendCCMemoCnclNot(PrmSenderID: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Custom Clearance memo approval sent to you have been canceled.';
        Subject := 'Information of cancelation - Custom Clearance request.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendNotToInsDept()
    begin
    end;

    [Scope('Internal')]
    procedure sendNotToCCDept()
    begin
    end;

    [Scope('Internal')]
    procedure sendFuelIssueAppNot(PrmSenderID: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Please check the approval entry list for pending approvals.';
        Subject := 'Request for approval - Fuel Issue.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendFuelIssueCnclNot(PrmSenderID: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Fuel Issue memo approval sent to you have been canceled.';
        Subject := 'Information of cancelation - Fuel Issue request.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendFuelIssueApvdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'I/We have approved your request.';
        Subject := 'Approved - Fuel Issue.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendFuelIssueRejdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your Fuel Issue approval request has been rejected.';
        Subject := 'Rejected - Fuel Issue.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendFuelIssueDelgtNot(PrmSenderID: Code[20]; PrmReceiverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        SenderEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmReceiverID);
        ReceiverEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your request for approval of Fuel Issue has been delegated.';
        Subject := 'Approval - Fuel Issue.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendVehCCApvdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'I/We have approved your request.';
        Subject := 'Approved - Custom Clearance.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendVehCCRejdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your Fuel Issue approval request has been rejected.';
        Subject := 'Rejected - Custom Clearance.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendVehCCDelgtNot(PrmSenderID: Code[20]; PrmReceiverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        SenderEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmReceiverID);
        ReceiverEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your request for approval of Custom Clearance has been delegated.';
        Subject := 'Approval - Custom Clearance.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendVehInsApvdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'I/We have approved your request for Insurance Memo.';
        Subject := 'Approved - Insurance Memo.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendVehInsDelgtNot(PrmSenderID: Code[20]; PrmReceiverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        SenderEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmReceiverID);
        ReceiverEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your request for approval of Insurance has been delegated.';
        Subject := 'Approval - Insurance.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendVehInsRejdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your Insurance Memo approval request has been rejected.';
        Subject := 'Rejected - Insurance.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendGenStrReqAppNot(PrmSenderID: Code[20]; PrmDocNo: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Please check the approval entry list for pending approvals of Document No. -.' + PrmDocNo;
        Subject := 'Request for approval - Store Requisition.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendGenStrReqCncllNot(PrmSenderID: Code[20]; PrmDocNo: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Approval request sent to you for General Procurement have been canceled. Document No. - ' + PrmDocNo;
        Subject := 'Information of cancelation - Store Requision.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendGenStrReqApvdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'I/We have approved your request.';
        Subject := 'Approved - Store Requisition.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendGenStrReqRejdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your Store Requisition approval request has been rejected.';
        Subject := 'Rejected - Store Requisition.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendGenStrReqDelgtNot(PrmSenderID: Code[20]; PrmReceiverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        SenderEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmReceiverID);
        ReceiverEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your request for approval of Store Requisition has been delegated.';
        Subject := 'Approval - Store Requisition.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure SendTrainingRequestMailtoReportingManager(TrainingReqHdr: Record "33020359")
    var
        UserSetup: Record "91";
        SMTPMail: Record "409";
        SMTPMailMgt: Codeunit "400";
        LclApproverID: Code[50];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
        Employee: Record "5200";
        ReportingManager: Record "5200";
        MailSent: Boolean;
        Text33019920: Label 'Trainingr equest for - %1 has been sent to your reporting manager - %2.';
    begin
        IF TrainingReqHdr.Approved THEN
            EXIT;
        CLEAR(SMTPMailMgt);
        CLEAR(Body);

        //for getting employee's reporting manager
        ReportingManager.RESET;
        ReportingManager.SETRANGE("User ID", TrainingReqHdr."Requested By");
        IF ReportingManager.FINDFIRST THEN BEGIN
            ReportingManager.TESTFIELD("User ID");
            ReportingManager.TESTFIELD("Company E-Mail");
            LclApproverID := ReportingManager."User ID";
            SendEmail := ReportingManager."Company E-Mail";
        END;

        //for getting reporting manager info
        ReportingManager.RESET;
        ReportingManager.SETRANGE("User ID", LclApproverID);
        IF ReportingManager.FINDFIRST THEN BEGIN
            ReportingManager.TESTFIELD("Company E-Mail");
            AppvEmail := ReportingManager."Company E-Mail";
        END;

        Employee.RESET;
        Employee.SETRANGE("User ID", TrainingReqHdr."Requested By");
        Employee.FINDFIRST;

        SendName := USERID;
        Body := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
        IF ReportingManager.Gender = ReportingManager.Gender::Male THEN
            Body := Body + 'Dear ' + 'Sir' + '<br><br>'
        ELSE
            Body := Body + 'Dear ' + 'Mam' + '<br><br>';
        Body := Body + STRSUBSTNO('Your Training Request %1 for %2 has been sent.', TrainingReqHdr."Tr. Req. No.", TrainingReqHdr."Training Topic") + '<br><br><br>' + '<br><br><hr>';
        Subject := STRSUBSTNO('Training Request on %1, Request No. %2', TrainingReqHdr."Training Topic", TrainingReqHdr."Tr. Req. No.");

        Body += '<br><br><hr>' + '<br><br><hr>' + 'With Regards.' + '<br><br><hr>';

        SMTPMailMgt.CreateMessage(SendName, AppvEmail, SendEmail, Subject, Body, TRUE);
        MailSent := SMTPMailMgt.TrySend;
        IF MailSent THEN BEGIN
            MESSAGE(Text33019920, TrainingReqHdr."Training Topic", ReportingManager."Full Name");
            TrainingReqHdr."Sent for Approval" := TRUE;
            TrainingReqHdr.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure SendTrainingCancelNotificationtoReportingManager(TrainingReqHdr: Record "33020359")
    var
        LclApproverID: Code[50];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
        ReportingManager: Record "5200";
        MailSent: Boolean;
    begin
        IF TrainingReqHdr.Canceled THEN EXIT;

        //for getting employee manager's information
        ReportingManager.RESET;
        ReportingManager.SETRANGE("User ID", TrainingReqHdr."Requested By");
        IF ReportingManager.FINDFIRST THEN BEGIN
            ReportingManager.TESTFIELD("User ID");
            ReportingManager.TESTFIELD("Company E-Mail");
            LclApproverID := ReportingManager."User ID";
            SendEmail := ReportingManager."Company E-Mail";
        END;

        //for getting reporting manager info
        ReportingManager.RESET;
        ReportingManager.SETRANGE("User ID", LclApproverID);
        IF ReportingManager.FINDFIRST THEN BEGIN
            ReportingManager.TESTFIELD("Company E-Mail");
            AppvEmail := ReportingManager."Company E-Mail";
        END;

        SendName := USERID;
        Body := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
        IF ReportingManager.Gender = ReportingManager.Gender::Male THEN
            Body := Body + 'Dear ' + 'Sir' + '<br><br>'
        ELSE
            Body := Body + 'Dear ' + 'Mam' + '<br><br>';

        Body := Body + STRSUBSTNO('Training Request approval for %1 sent to you have been canceled.', TrainingReqHdr."Training Topic");

        Body += '<br><br><hr>' + '<br><br><hr>' + 'With Regards.' + '<br><br><hr>';

        Subject := STRSUBSTNO('Information of approval cancellation - Training request %1', TrainingReqHdr."Tr. Req. No.");
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        MailSent := GblSMTPMail.TrySend;
        IF MailSent THEN BEGIN
            MESSAGE('Cancellation of Training Request notification for %1 has been sent to your reporting manager', TrainingReqHdr."Tr. Req. No.");
            TrainingReqHdr.Canceled := TRUE;
            TrainingReqHdr."Sent for Approval" := FALSE;
            TrainingReqHdr.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure SendTrainingApprovedMailtoEmployee(TrainingReqHdr: Record "33020359")
    var
        UserSetup: Record "91";
        SMTPMail: Record "409";
        SMTPMailMgt: Codeunit "400";
        LclApproverID: Code[50];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
        Employee: Record "5200";
        MailSent: Boolean;
        SMTP: Record "409";
        TrainingLine: Record "33020360";
    begin
        IF NOT TrainingReqHdr.Approved THEN
            EXIT;
        SMTP.GET;
        CLEAR(SMTPMailMgt);
        CLEAR(Body);
        /*UserSetup.GET("Requested By");
        LclApproverID := UserSetup."Approver ID";
        SendEmail := UserSetup."E-Mail";
        UserSetup.GET(LclApproverID);
        AppvEmail := UserSetup."E-Mail";*/
        AppvEmail := SMTP."User ID";

        //getting training participants email
        TrainingLine.RESET;
        TrainingLine.SETRANGE("Tr. Req. No.", TrainingReqHdr."Tr. Req. No.");
        IF TrainingLine.FINDFIRST THEN
            REPEAT
                Employee.GET(TrainingLine."Part. Employee");
                Employee.TESTFIELD("Company E-Mail");
                IF SendEmail = '' THEN
                    SendEmail += ';' + Employee."Company E-Mail"
                ELSE
                    SendEmail := Employee."Company E-Mail";
            UNTIL TrainingLine.NEXT = 0;

        Employee.RESET;
        Employee.SETRANGE("User ID", TrainingReqHdr."Requested By");
        Employee.FINDFIRST;

        //SendName := USERID;
        SendName := SMTP."User ID";
        Body := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
        Body := Body + 'Dear ' + Employee."Full Name" + '<br><br>';
        Body := Body + STRSUBSTNO('Your Training Request %1 for %2 has been approved.', TrainingReqHdr."Tr. Req. No.", TrainingReqHdr."Training Topic") + '<br><br><br>' + '<br><br><hr>' + '<br><br><hr>' + 'With Regards.' + '<br><br><hr>';
        Subject := STRSUBSTNO('Information of Approved - Training on %1, Request No. %2', TrainingReqHdr."Training Topic", TrainingReqHdr."Tr. Req. No.");

        SMTPMailMgt.CreateMessage(SendName, AppvEmail, SendEmail, Subject, Body, TRUE);
        MailSent := SMTPMailMgt.TrySend;
        IF MailSent THEN BEGIN
            MESSAGE('Training Approval Mail of %1 has been sent.', TrainingReqHdr."Training Topic");
        END;

    end;

    [Scope('Internal')]
    procedure SendTrainingDisapprovedMailtoEmployee(TrainingReqHdr: Record "33020359")
    var
        UserSetup: Record "91";
        SMTPMail: Record "409";
        SMTPMailMgt: Codeunit "400";
        LclApproverID: Code[50];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
        Employee: Record "5200";
        MailSent: Boolean;
    begin
        IF NOT TrainingReqHdr.Rejected THEN
            EXIT;
        CLEAR(SMTPMailMgt);
        UserSetup.GET(TrainingReqHdr."Requested By");
        LclApproverID := UserSetup."Approver ID";
        SendEmail := UserSetup."E-Mail";
        UserSetup.GET(LclApproverID);
        AppvEmail := UserSetup."E-Mail";
        SendName := USERID;

        Employee.RESET;
        Employee.SETRANGE("User ID", TrainingReqHdr."Requested By");
        Employee.FINDFIRST;

        Body := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
        Body := Body + 'Dear ' + Employee."Full Name" + '<br><br>';
        Body := Body + STRSUBSTNO('Your Training Request %1 for %2 has been rejeted.', TrainingReqHdr."Tr. Req. No.", TrainingReqHdr."Training Topic") + '<br><br><br>' + '<br><br><hr>' + 'With Regards.' + '<br><br><hr>';
        Subject := STRSUBSTNO('Information of Disapprove - Training on %1, Request No. %2', TrainingReqHdr."Training Topic", TrainingReqHdr."Tr. Req. No.");
        ;
        SMTPMailMgt.CreateMessage(SendName, AppvEmail, SendEmail, Subject, Body, TRUE);
        MailSent := SMTPMailMgt.TrySend;
        IF MailSent THEN
            MESSAGE('Training disapprove mail of %1 to %2 has been sent', TrainingReqHdr."Training Topic", Employee."Full Name");
    end;

    [Scope('Internal')]
    procedure sendLCAppNot(PrmSenderID: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Please check the approval entry list for pending approvals.';
        Subject := 'Request for approval - Vehicle Purchase.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendLCCnclNot(PrmSenderID: Code[20])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Insurance memo approval sent to you have been canceled.';
        Subject := 'Information of cancelation - Vehicle Purchase.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendLCApvdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'I/We have approved your request.';
        Subject := 'Approved - Vehicle Purchase.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendLCCRejdNot(PrmSenderID: Code[20]; PrmApproverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        ReceiverEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmApproverID);
        SenderEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your Fuel Issue approval request has been rejected.';
        Subject := 'Rejected - Vehicle Purchase.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure sendLCDelgtNot(PrmSenderID: Code[20]; PrmReceiverID: Code[20])
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        SenderEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(PrmReceiverID);
        ReceiverEmail := GblUserSetup."E-Mail";

        SendName := 'Sangam Shrestha';
        Body := 'Your request for approval of Vehicle Purchase has been delegated.';
        Subject := 'Approval - Vehicle Purchase.';
        GblSMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure SendEmpVacAppNot(PrmSenderID: Code[10])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'To HR Department';
        Body := 'Please check the approval entry list for pending approvals.';
        Subject := 'Request for approval - Employee Requisition';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure SendEmpVacCnclNot(PrmSenderID: Code[10])
    var
        LclApproverID: Code[20];
        AppvEmail: Text[100];
        SendEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
    begin
        GblUserSetup.GET(PrmSenderID);
        LclApproverID := GblUserSetup."Approver ID";
        SendEmail := GblUserSetup."E-Mail";

        GblUserSetup.GET(LclApproverID);
        AppvEmail := GblUserSetup."E-Mail";

        SendName := 'TO HR Department';
        Body := 'Employee Requisition Request approval sent to you have been canceled.';
        Subject := 'Information of cancelation - Employee Requisition request.';
        GblSMTPMail.CreateMessage(SendName, SendEmail, AppvEmail, Subject, Body, TRUE);
        //GblSMTPMail.AppendBody();
        GblSMTPMail.Send;
    end;

    [Scope('Internal')]
    procedure verifyApprover(TrainingH: Record "33020359"): Code[50]
    var
        ApprovalEntry: Record "33019915";
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Document No.", TrainingH."Tr. Req. No.");
        ApprovalEntry.FINDFIRST;
        EXIT(ApprovalEntry."Approver ID");
    end;
}

