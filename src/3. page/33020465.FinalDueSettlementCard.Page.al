page 33020465 "Final Due Settlement Card"
{
    PageType = Card;
    SourceTable = Table33020409;

    layout
    {
        area(content)
        {
            group("Employee's Information")
            {
                field("Emp Settlement No."; "Emp Settlement No.")
                {

                    trigger OnAssistEdit()
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
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
                field("Date of Joining"; "Date of Joining")
                {
                }
                field("Date of Release"; "Date of Release")
                {
                }
                field(Address; Address)
                {
                }
            }
            group("Concerned Department Head")
            {
                field(CD_Department; CD_Department)
                {
                    Caption = 'Department';
                }
                field("CD_Department Name"; "CD_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("CD_Employee Code"; "CD_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("CD_Employee Name"; "CD_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(CD_Due; CD_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec."Concerned Department" THEN
                            ERROR('You do not have permission !');

                        IF HRPermissionRec."Concerned Department" THEN BEGIN
                            "CD_User ID" := USERID;
                            "CD_Time Stamp" := TIME;
                            CD_Date := TODAY;

                        END;
                    end;
                }
                field("CD_User ID"; "CD_User ID")
                {
                    Caption = 'User ID';
                }
                field("CD_Time Stamp"; "CD_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(CD_Date; CD_Date)
                {
                    Caption = 'Date';
                }
                field(CD_Remark; CD_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group(Store)
            {
                field("S_ Department"; "S_ Department")
                {
                    Caption = 'Department';
                }
                field("S_Department Name"; "S_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("S_Employee Code"; "S_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("S_Employee Name"; "S_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(S_Due; S_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec.Store THEN
                            ERROR('You do not have permission !');

                        IF HRPermissionRec.Store THEN BEGIN
                            "S_User ID" := USERID;
                            "S_Time Stamp" := TIME;
                            S_Date := TODAY;

                        END;
                    end;
                }
                field("S_User ID"; "S_User ID")
                {
                    Caption = 'User ID';
                }
                field("S_Time Stamp"; "S_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(S_Date; S_Date)
                {
                    Caption = 'Date';
                }
                field(S_Remark; S_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group("Service Manager: CVD")
            {
                Caption = 'Service Manager: CVD';
                field(SMC_Department; SMC_Department)
                {
                    Caption = 'Department';
                }
                field("SMC_Department Name"; "SMC_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("SMC_Employee Code"; "SMC_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("SMC_Employee Name"; "SMC_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(SMC_Due; SMC_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec."CVD-Service Manager" THEN
                            ERROR('You do not have permission !');

                        IF HRPermissionRec."CVD-Service Manager" THEN BEGIN
                            "SMC_User ID" := USERID;
                            "SMC_Time Stamp" := TIME;
                            SMC_Date := TODAY;

                        END;
                    end;
                }
                field("SMC_User ID"; "SMC_User ID")
                {
                    Caption = 'User ID';
                }
                field("SMC_Time Stamp"; "SMC_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(SMC_Date; SMC_Date)
                {
                    Caption = 'Date';
                }
                field(SMC_Remark; SMC_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group("Service Manager: PCD")
            {
                Caption = 'Service Manager: PCD';
                field(SMP_Department; SMP_Department)
                {
                    Caption = 'Department';
                }
                field("SMP_Department Name"; "SMP_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("SMP_Employee Code"; "SMP_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("SMP_Employee Name"; "SMP_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(SMP_Due; SMP_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec."PCD-Service Manager" THEN
                            ERROR('You do not have permission !');

                        IF HRPermissionRec."PCD-Service Manager" THEN BEGIN
                            "SMP_User ID" := USERID;
                            "SMP_Time Stamp" := TIME;
                            SMP_Date := TODAY;

                        END;
                    end;
                }
                field("SMP_User ID"; "SMP_User ID")
                {
                    Caption = 'User ID';
                }
                field("SMP_Time Stamp"; "SMP_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(SMP_Date; SMP_Date)
                {
                    Caption = 'Date';
                }
                field(SMP_Remark; SMP_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group("Administrative Department")
            {
                field(AD_Department; AD_Department)
                {
                    Caption = 'Department';
                }
                field("AD_Department Name"; "AD_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("AD_Employee Code"; "AD_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("AD_Employee Name"; "AD_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(AD_Due; AD_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec."Administrative Department" THEN
                            ERROR('You do not have permission !');

                        IF HRPermissionRec."Administrative Department" THEN BEGIN
                            "AD_User ID" := USERID;
                            "AD_Time Stamp" := TIME;
                            AD_Date := TODAY;

                        END;
                    end;
                }
                field("AD_User ID"; "AD_User ID")
                {
                    Caption = 'User ID';
                }
                field("AD_Time Stamp"; "AD_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(AD_Date; AD_Date)
                {
                    Caption = 'Date';
                }
                field(AD_Remark; AD_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group("IT Department")
            {
                field(IT_Department; IT_Department)
                {
                    Caption = 'Department';
                }
                field("IT_Department Name"; "IT_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("IT_Employee Code"; "IT_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("IT_Employee Name"; "IT_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(IT_Due; IT_Due)
                {
                    Caption = 'Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec."IT Department" THEN
                            ERROR('You do not have permission !');

                        IF HRPermissionRec."IT Department" THEN BEGIN
                            "IT_User ID" := USERID;
                            "IT_Time Stamp" := TIME;
                            IT_Date := TODAY;

                        END;
                    end;
                }
                field("IT_User ID"; "IT_User ID")
                {
                    Caption = 'User ID';
                }
                field("IT_Time Stamp"; "IT_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(IT_Date; IT_Date)
                {
                    Caption = 'Date';
                }
                field(IT_Remark; IT_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group(Library)
            {
                field("Manager Department"; LS_Department)
                {
                    Caption = 'Department';
                }
                field("Manager Department Name"; "LS_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("Manager Code"; "LS_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("Manager Name"; "LS_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field("LS Due / No Due"; LS_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec.Library THEN
                            ERROR('You do not have permission !');

                        IF HRPermissionRec.Library THEN BEGIN
                            "LS_User ID" := USERID;
                            "LS_Time Stamp" := TIME;
                            LS_Date := TODAY;

                        END;
                    end;
                }
                field("User ID"; "LS_User ID")
                {
                }
                field("Time Stamp"; "LS_Time Stamp")
                {
                }
                field(Date; LS_Date)
                {
                }
                field(Remark; LS_Remark)
                {
                }
            }
            group("Housing Loan")
            {
                field("Manager Department_"; HL_Department)
                {
                    Caption = 'Department';
                }
                field("Manager Department Name_"; "HL_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("Manager Code_"; "HL_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("Manager Name_"; "HL_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field("HL Due / No Due"; HL_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec."Housing Loan" THEN
                            ERROR('You do not have permission !');

                        IF HRPermissionRec."Housing Loan" THEN BEGIN
                            "HL_User ID" := USERID;
                            "HL_Time Stamp" := TIME;
                            HL_Date := TODAY;

                        END;
                    end;
                }
                field("User ID_"; "HL_User ID")
                {
                }
                field("_Time Stamp"; "HL_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(_Date; HL_Date)
                {
                    Caption = 'Date';
                }
                field(_Remark; HL_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group("Vehicle Finance")
            {
                field("_Manager Department"; VF_Department)
                {
                    Caption = 'Department';
                }
                field("_Manager Department Name"; "VF_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("_Manager Code"; "VF_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("_Manager Name"; "VF_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field("VF Due"; VF_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec."Vehicle Finance" THEN
                            ERROR('You do not have permission !');
                        IF HRPermissionRec."Vehicle Finance" THEN BEGIN
                            "VF_User ID" := USERID;
                            "VF_Time Stamp" := TIME;
                            VF_Date := TODAY;

                        END;
                    end;
                }
                field("_User ID"; "VF_User ID")
                {
                    Caption = 'User ID';
                }
                field("__Time Stamp"; "VF_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(__Date; VF_Date)
                {
                    Caption = 'Date';
                }
                field(__Remark; VF_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group(Welfare)
            {
                field("__Manager Department"; W_Department)
                {
                    Caption = 'Department';
                }
                field("__Manager Department Name"; "W_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("__Manager Code"; "W_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("__Manager Name"; "W_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field("W Due / No Due"; W_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec.Welfare THEN
                            ERROR('You do not have permission !');
                        IF HRPermissionRec.Welfare THEN BEGIN
                            "W_User ID" := USERID;
                            "W_Time Stamp" := TIME;
                            W_Date := TODAY;

                        END;
                    end;
                }
                field("__User ID"; "W_User ID")
                {
                    Caption = 'User ID';
                }
                field("___Time Stamp"; "W_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field("2Date"; W_Date)
                {
                    Caption = 'Date';
                }
                field("2Remark"; W_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group("Accounts Department")
            {
                Caption = 'Accounts Department';
                field(ACC_Department; ACC_Department)
                {
                    Caption = 'Department';
                }
                field("ACC_Department Name"; "ACC_Department Name")
                {
                    Caption = 'Department Name';
                }
                field("ACC_Employee Code"; "ACC_Employee Code")
                {
                    Caption = 'Employee Code';
                }
                field("ACC_Employee Name"; "ACC_Employee Name")
                {
                    Caption = 'Employee Name';
                }
                field(ACC_Due; ACC_Due)
                {
                    Caption = 'Due / No Due';

                    trigger OnValidate()
                    begin
                        HRPermissionRec.GET(USERID);
                        IF NOT HRPermissionRec."Account Department" THEN
                            ERROR('You do not have permission !');
                        IF HRPermissionRec."Account Department" THEN BEGIN
                            "ACC_User ID" := USERID;
                            "ACC_Time Stamp" := TIME;
                            ACC_Date := TODAY;

                        END;
                    end;
                }
                field("ACC_User ID"; "ACC_User ID")
                {
                    Caption = 'User ID';
                }
                field("ACC_Time Stamp"; "ACC_Time Stamp")
                {
                    Caption = 'Time Stamp';
                }
                field(ACC_Date; ACC_Date)
                {
                    Caption = 'Date';
                }
                field(ACC_Remark; ACC_Remark)
                {
                    Caption = 'Remark';
                }
            }
            group(Remark_)
            {
                Caption = 'Remark';
                field("Date of Final Settlement"; "Date of Final Settlement")
                {
                }
                field("Last Total Amount"; "Last Total Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1000000056>")
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD(ACC_Due);
                    ConfirmPost := DIALOG.CONFIRM(text0001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        FinalDueSettlementRec.RESET;
                        FinalDueSettlementRec.SETRANGE("Emp Settlement No.", "Emp Settlement No.");
                        IF FinalDueSettlementRec.FINDFIRST THEN BEGIN
                            Posted := TRUE;
                            "Posted Date" := TODAY;
                            "Posted By" := USERID;
                        END;
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
                    IF HRPermissionRec."Permission to Send Mail" THEN BEGIN
                        IF CD_Due = CD_Due::"No Due" = FALSE THEN
                            "SendMail-ConcernDept";
                        IF S_Due = S_Due::"No Due" = FALSE THEN
                            "SendMail-Store";
                        IF SMC_Due = SMC_Due::"No Due" = FALSE THEN
                            "SendMail-CVD";
                        IF SMP_Due = SMP_Due::"No Due" = FALSE THEN
                            "SendMail-PCD";
                        IF AD_Due = AD_Due::"No Due" = FALSE THEN
                            "SendMail-Admin";
                        IF IT_Due = IT_Due::"No Due" = FALSE THEN
                            "SendMail-IT";
                        IF LS_Due = LS_Due::"No Due" = FALSE THEN
                            "SendMail-Library";
                        IF HL_Due = HL_Due::"No Due" = FALSE THEN
                            "SendMail-HouseLoan";
                        IF VF_Due = VF_Due::"No Due" = FALSE THEN
                            "SendMail-VehicleFinance";
                        IF W_Due = W_Due::"No Due" = FALSE THEN
                            "SendMail-Welfare";
                        IF ACC_Due = W_Due::"No Due" = FALSE THEN
                            "SendMail-Account";
                        MESSAGE(Text010);
                    END ELSE BEGIN
                        MESSAGE('You do not have Authority to send Mail!');
                    END;
                end;
            }
        }
    }

    var
        ConfirmPost: Boolean;
        text0001: Label 'Do you want to post?';
        FinalDueSettlementRec: Record "33020409";
        HRPermissionRec: Record "33020304";
        EmpRec: Record "5200";
        EmailAddress: Text[100];
        CompInfo: Record "79";
        initial: Text[30];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';

    [Scope('Internal')]
    procedure "SendMail-ConcernDept"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "CD_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Concerned Department Head </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);
        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-Store"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;


        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "S_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Store </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);


        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-CVD"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Service Manager : CVD </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);


        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-PCD"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "SMP_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Service Manager : PCD </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);

        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-Admin"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "AD_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Administrative </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);

        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-IT"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "IT_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> IT Department </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);

        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-Library"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "LS_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Library Section </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);

        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-HouseLoan"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "HL_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> House Loan </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);

        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-VehicleFinance"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "VF_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Vehicle Finance </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);

        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-Welfare"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "W_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Welfare </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);

        //--------------------------------------------------------------------------------------------------------
    end;

    [Scope('Internal')]
    procedure "SendMail-Account"()
    var
        ObjApp: Automation;
        ObjMail: Automation;
        EmailBody: Text[1024];
        "Manager ID": Code[20];
        MailTo: Text[100];
        Dear: Text[30];
        MessageText: Text[800];
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        Subject: Text[250];
        CompName: Text[50];
        EmpName: Text[150];
    begin
        CLEAR(MailTo);
        CLEAR(EmpName);
        CLEAR(Dear);
        CLEAR(MessageText);
        CLEAR(initial);
        CompInfo.RESET;
        IF CompInfo.FINDFIRST THEN
            CompName := CompInfo.Name;

        //--------------------------------------------------------------------------------------------------------
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "ACC_Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FINDFIRST THEN BEGIN
            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                initial := 'Mr. ';
            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                initial := 'Ms. ';
        END;

        Dear := 'Dear Sir/ Madam,';
        Subject := 'Regarding Outstandings / Dues Against the employee' + "Full Name";
        MessageText := initial + "Full Name" + ' (' + "Employee Code" + ') of ' + Department + ' (' + Branch +
         ') has left the service from' + CompName + ' with effective from ' + FORMAT("Date of Release") +
         '. Please mention any outstandings/ dues against his/ her name. Follow the path below:,<br> ' +
         '1. Run Microsoft Dynamics NAV (ERP) <br> 2. Click <b>"Department"</b> in Navigation Panel<br>' +
         '3. Click <b>Seperation Procedure </b> under <b>Human Resources </b><br>' +
         '4. Click <b>Final Due Settlement Lists</b><br> 5. Open the card for Employee ' + "Employee Code" + '<br>' +
         ' Please kindly fill the Dues in <b> Account </b> Section. <br>';
        IF MailTo <> '' THEN BEGIN
            IF ISCLEAR(ObjApp) THEN
                CREATE(ObjApp, TRUE, TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
            EmailBody := EmailBody + Dear + '' + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                        + 'HR Department' + '<br><br><hr>';
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();

        END ELSE
            ERROR(Text009);

        //--------------------------------------------------------------------------------------------------------
    end;
}

