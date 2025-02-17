page 33020536 "Travel Order Approved I Card"
{
    PageType = Card;
    SourceTable = Table33020425;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Travel Order No."; "Travel Order No.")
                {
                }
                field("Travel Type"; "Travel Type")
                {
                }
                field("Traveler's ID"; "Traveler's ID")
                {
                }
                field("Traveler's Name"; "Traveler's Name")
                {
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field("Travel Destination I"; "Travel Destination I")
                {
                }
                field("Travel Destination II"; "Travel Destination II")
                {
                }
                field("Travel Destination III"; "Travel Destination III")
                {
                }
                field("Depature Date (AD)"; "Depature Date (AD)")
                {
                }
                field("Depature Date (BS)"; "Depature Date (BS)")
                {
                }
                field("Arrival Date (AD)"; "Arrival Date (AD)")
                {
                }
                field("Arrival Date (BS)"; "Arrival Date (BS)")
                {
                }
                field("No. of Days"; "No. of Days")
                {
                }
                field("Mode Of Transportation"; "Mode Of Transportation")
                {
                }
                field("Bus Transportation"; "Bus Transportation")
                {
                }
                field("Approved Type"; "Approved Type")
                {
                }
                field("Transportation/Ticket (Nrs.)"; "Transportation/Ticket (Nrs.)")
                {
                    Visible = false;
                }
                field("Local Transportation (Nrs.)"; "Local Transportation (Nrs.)")
                {
                }
                field("TADA (Nrs.)"; "TADA (Nrs.)")
                {
                }
                field("Fuel (Nrs.)"; "Fuel (Nrs.)")
                {
                }
                field("Total (Nrs.)"; "Total (Nrs.)")
                {
                }
                field(ManagerID; ManagerID)
                {
                }
                field("Manager's Name"; "Manager's Name")
                {
                }
                field("Travel Purpose"; "Travel Purpose")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Can not Approve your own Leave
                    EmployeeRec.RESET;
                    EmployeeRec.SETRANGE("No.", "Traveler's ID");
                    EmployeeRec.SETRANGE("User ID", USERID);
                    IF EmployeeRec.FINDFIRST THEN
                        ERROR('You cannot Approve your own document!');


                    HRUP.GET(USERID);
                    //IF NOT HRUP."Super Permission" THEN BEGIN
                    ApproveAuthority;
                    ConfirmApprove := DIALOG.CONFIRM(Text001, TRUE);
                    IF ConfirmApprove THEN BEGIN
                        Employee.RESET;
                        Employee.SETRANGE("No.", "Traveler's ID");
                        IF Employee.FINDFIRST THEN BEGIN
                            IF (Employee."Manager ID" = ManagerID) THEN BEGIN
                                TravelForm.RESET;
                                TravelForm.SETRANGE("Travel Order No.", "Travel Order No.");
                                IF TravelForm.FINDFIRST THEN BEGIN
                                    "Approved II" := TRUE;
                                    "Approved II By" := USERID;
                                    "Approved II Date" := TODAY;
                                    InserttoLeaveRegister;
                                    MESSAGE(Text002);
                                END
                            END ELSE
                                ERROR('You Are Not The Manager');
                        END;
                    END;
                    //END;
                    //SendMail1;
                    SendmailToChequePerson;  //<<MIN 7/11/2019
                end;
            }
        }
    }

    var
        TravelForm: Record "33020425";
        Employee: Record "5200";
        LeaveRegister: Record "33020343";
        EmployeeRec: Record "5200";
        HRUP: Record "33020304";
        Approve1: Code[20];
        Approve2: Code[20];
        Emp1: Record "5200";
        Emp2: Record "5200";
        HRPermission: Record "33020304";
        DeptCode: Code[20];
        ConfirmApprove: Boolean;
        Text001: Label 'Do you want to Approve?';
        Text002: Label 'The Travel have been Approved.';
        EmpRec: Record "5200";
        MailTo: Text[100];
        EmpName: Text[100];
        TravelOrderForm: Record "33020425";
        FromDateText: Text[50];
        ToDateText: Text[50];
        Dear: Text[100];
        Subject: Text[100];
        MessageText: Text[250];
        EmailBody: Text[250];
        Text010: Label 'Sent successfully! Please check your sent item in Outlook.';
        Text011: Label 'There is no employee e- mail address! Please contact your system administrator.';
        ChequePersonEmail: Text[100];
        ChequePersonName: Text[100];
        Text0003: Label 'Mail Sent';
        Text0004: Label 'Mail Not Sent';

    [Scope('Internal')]
    procedure InserttoLeaveRegister()
    var
        EmpRec: Record "5200";
    begin
        LeaveRegister.INIT;
        LeaveRegister."External No" := TravelForm."Travel Order No.";
        LeaveRegister."Employee No." := TravelForm."Traveler's ID";
        EmpRec.RESET;
        EmpRec.SETRANGE("No.", TravelForm."Traveler's ID");
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
        LeaveRegister."Leave Start Date" := TravelForm."Depature Date (AD)";
        LeaveRegister."Leave End Date" := TravelForm."Arrival Date (AD)";
        LeaveRegister.Approved := TRUE;
        LeaveRegister."Approved By" := USERID;
        LeaveRegister."Approved Date" := TODAY;
        LeaveRegister.Type := 6;

        LeaveRegister."Pay Type" := LeaveRegister."Pay Type"::Paid;
        LeaveRegister.INSERT(TRUE);
        //LeaveRegister.FINDLAST;
    end;

    [Scope('Internal')]
    procedure ApproveAuthority()
    var
        DeptCode: Code[20];
        Text001: Label 'You do not have permission to change for other Departmant %1!';
    begin
        IF NOT HRUP."Super Permission" THEN BEGIN
            IF NOT HRUP."HR Admin" THEN BEGIN
                IF NOT (USERID <> 'CABINET') THEN
                    ERROR('You do not have permission to Process this document.');
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SendMail1()
    begin
        /*EmpRec.RESET;
        EmpRec.SETRANGE("No.","Traveler's ID");
        IF EmpRec.FIND('-') THEN
          MailTo := EmpRec."Company E-Mail";
          EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
        
        TravelOrderForm.RESET;
        TravelOrderForm.SETRANGE("Traveler's ID","Traveler's ID");
        IF TravelOrderForm.FIND('+') THEN BEGIN
          FromDateText := FORMAT(TravelForm."Depature Date (AD)",0,4);
          ToDateText := FORMAT(TravelForm."Arrival Date (AD)",0,4);
        END;
        
        Dear := 'Dear ' + EmpName + ',';
        Subject := 'Approval of your travel request.';
        MessageText := 'Your travel request has been approved, starting from ' + FromDateText + ' to ' + ToDateText ;
        
        
        
        IF MailTo <> '' THEN BEGIN
          IF ISCLEAR(ObjApp) THEN
            CREATE(ObjApp,TRUE,TRUE);
        
          ObjMail := ObjApp.CreateItem(0);
          ObjMail."To"(MailTo);
          ObjMail.Subject(Subject);
        
          EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
          EmailBody := EmailBody +  Dear + '<br><br>';
          EmailBody := EmailBody + MessageText + '<br><br><br>' + 'Manager' + '<br><br><hr>';
          ObjMail.HTMLBody(EmailBody);
          ObjMail.Send();
          MESSAGE(Text010);
        END ELSE
          ERROR(Text011);
        */

    end;

    [Scope('Internal')]
    procedure SendmailToChequePerson()
    var
        MailTo: Text[80];
        FromDateText: Text[30];
        ToDateText: Text[30];
        Dear: Text[100];
        Subject: Text[100];
        MessageText: Text[250];
        ManagerName: Text[90];
        FromTimeText: Text[30];
        ToTimeText: Text[30];
        EmailBody: Text;
        "--AGNIUPG2009--": InStream;
        SMTPMail: Codeunit "400";
        CompanyInfo: Record "79";
        SMTPMailSetup: Record "409";
        Sent: Boolean;
        MailSender: Record "5200";
        SenderMail: Text[250];
        Text016: Label 'Mail Could Not be Send.';
    begin

        EmpRec.RESET;
        EmpRec.SETRANGE("No.", "Traveler's ID");
        IF EmpRec.FIND('-') THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
            EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
        END;

        EmpRec.RESET;
        EmpRec.SETRANGE(Cheque, TRUE);
        IF EmpRec.FIND('-') THEN BEGIN
            ChequePersonEmail := EmpRec."Company E-Mail";
            ChequePersonName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
        END;

        TravelOrderForm.RESET;
        TravelOrderForm.SETRANGE("Traveler's ID", "Traveler's ID");
        IF TravelOrderForm.FIND('+') THEN BEGIN
            FromDateText := FORMAT(TravelOrderForm."Depature Date (AD)", 0, 4);
            ToDateText := FORMAT(TravelOrderForm."Arrival Date (AD)", 0, 4);
        END;


        Dear := 'Dear ' + 'Sir/Mam' + ',';
        Subject := 'Approval of ' + EmpName + ' travel request.';
        MessageText := EmpName + ' travel request has been approved, starting from ' + FromDateText + ' to ' + ToDateText;

        IF (MailTo <> '') AND (ChequePersonEmail <> '') THEN BEGIN

            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
            EmailBody := EmailBody + Dear + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br><br>' + 'Manager' + '<br><br><hr>';


            SMTPMailSetup.GET;
            SMTPMail.CreateMessage(CompanyInfo.Name, SMTPMailSetup."User ID", MailTo, Subject, EmailBody, TRUE);
            //SMTPMail.AddAttachment(FileDirectory,FileName+'.xls');For Attachment
            SMTPMail.AddCC(ChequePersonEmail);
            Sent := SMTPMail.TrySend;
            IF Sent THEN
                MESSAGE(Text0003)
            ELSE
                MESSAGE(Text016)

        END ELSE
            ERROR(Text0004);
    end;
}

