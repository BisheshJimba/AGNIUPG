page 33020351 "Posted Leave Request Card"
{
    // Mailing Function is Disabled

    PageType = Card;
    SourceTable = Table33020344;
    SourceTableView = SORTING(Employee No., Leave Start Date)
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            group("Posted Leave Request")
            {
                Caption = 'Posted Leave Requests by :';
                field("Employee No."; "Employee No.")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field("Requested Date"; "Requested Date")
                {
                }
                field("Work Shift Code"; "Work Shift Code")
                {
                }
                field("Work Shift Description"; "Work Shift Description")
                {
                }
                field("Leave Type Code"; "Leave Type Code")
                {
                }
                field("Leave Description"; "Leave Description")
                {
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                }
                field("Leave End Date"; "Leave End Date")
                {
                }
                field("Leave Start Time"; "Leave Start Time")
                {
                }
                field("Leave End Time"; "Leave End Time")
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Pay Type"; "Pay Type")
                {
                }
                field("No. of Days"; "No. of Days")
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            part(; 33020392)
            {
                SubPageLink = Employee Code=FIELD(Employee No.),
                              Leave Type=FIELD(Leave Type Code);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(List)
            {
                Caption = 'List';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020367;
                                RunPageMode = View;
            }
            group("Function(s)")
            {
                Caption = 'Function(s)';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        CalcEarnLeaveDays: Codeunit "33020301";
                    begin
                        HRUP.GET(USERID);
                        //Can not Approve your own Leave
                        EmployeeRec.RESET;
                        EmployeeRec.SETRANGE("No.","Employee No.");
                        EmployeeRec.SETRANGE("User ID",USERID);
                        IF EmployeeRec.FINDFIRST THEN
                        ERROR('You cannot Approve your own leave');

                        ApproveAuthority;

                        IF (NOT PostLeaveReqRec.Approved) OR (NOT PostLeaveReqRec.Rejected) THEN
                          Approve
                        ELSE
                          ERROR(Text007);
                          //CalcEarnLeaveDays.EarnLeaveAtYearEnd("Employee No.","Fiscal Year","Leave Type Code");
                    end;
                }
                action(Disapprove)
                {
                    Caption = 'Disapprove';
                    Enabled = false;
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        HRUP.GET(USERID);
                        //Can not Disapprove your own Leave
                        EmployeeRec.RESET;
                        EmployeeRec.SETRANGE("No.","Employee No.");
                        EmployeeRec.SETRANGE("User ID",USERID);
                        IF EmployeeRec.FINDFIRST THEN
                        ERROR('You cannot Disapprove your own leave');
                        //ApproveAuthority;

                        IF HRUP."HR Admin" <> TRUE THEN BEGIN
                          EmpRec.RESET;
                          EmpRec.SETRANGE("No.","Employee No.");
                          IF EmpRec.FINDFIRST THEN BEGIN
                              IF (EmpRec."Manager ID" <> "Manager ID" ) THEN
                              ERROR('You Are not Allowed to Approve!');
                          END
                        END;


                        IF (NOT PostLeaveReqRec.Approved) OR (NOT PostLeaveReqRec.Rejected) THEN
                          Disapprove
                        ELSE
                          ERROR(Text008);
                    end;
                }
                separator()
                {
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Applying URC.
        /*HRUP.GET(USERID);
        IF HRUP."Employee Filter" <> '' THEN BEGIN
          IF NOT HRUP."Super Permission" THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Employee No.",HRUP."Employee Filter");
            FILTERGROUP(0);
          END;
        END;
         */
        
        HRUP.GET(USERID);
        IF NOT HRUP."Aproval/Disaproval Auth. Leave" THEN
          ERROR(Text005);

    end;

    trigger OnOpenPage()
    begin
        //Applying URC.
        HRUP.GET(USERID);
        IF NOT HRUP."Aproval/Disaproval Auth. Leave" THEN
          ERROR(Text005);
    end;

    var
        LeaveRegRec: Record "33020343";
        EmpID: Code[20];
        PostLeaveReqRec: Record "33020344";
        ConfirmRejection: Boolean;
        ConfirmApprove: Boolean;
        ConfirmPartialApp: Boolean;
        LeaveReqAppDisappRec: Record "33020346";
        HRSetup: Record "5218";
        ConfirmPartialApprove: Boolean;
        MailTo: Text[100];
        Subject: Text[100];
        MessageText: Text[250];
        EmailBody: Text[1024];
        Dear: Text[100];
        FromDateText: Text[60];
        ToDateText: Text[60];
        EmpRec: Record "5200";
        Window: Dialog;
        GrantStartDate: Date;
        GrandEndDate: Date;
        CommentText: Text[250];
        StartingDate: Date;
        EndingDate: Date;
        CYear: Integer;
        EmpName: Text[250];
        Text000: Label 'Leave Request for Emp No. - %1, has been granted successfully!';
        Text001: Label 'Are you sure you want to reject this Leave Request?';
        Text002: Label 'Please provide Granted Leave Start Date and End Date!';
        Text003: Label 'Exit successfully!';
        Text004: Label 'Are you sure you want to approve this Leave Request?';
        Text005: Label 'Sorry, you donot have permission to use this Page! Please contact your system administrator.';
        Text006: Label 'Partial Approval is for deducting the leave date requested by the Employee(s). Are you sure you want to approve this Leave Request?';
        Text007: Label 'You cannot Approve already approved or disapproved request!';
        Text008: Label 'You cannot Disapprove already approved or disapproved request!';
        Text009: Label 'You cannot Partial Approve already approved or disapproved request!';
        Text010: Label 'Sent successfully! Please check your sent item in Outlook.';
        Text011: Label 'There is no employee e- mail address! Please contact your system administrator.';
        HRUP: Record "33020304";
        LeaveAccount: Record "33020370";
        LeaveType: Record "33020345";
        LeaveRegisterNo: Code[20];
        BalanceDays: Decimal;
        LeaveRegRec1: Record "33020343";
        PostLeaveReqRec1: Record "33020344";
        LeaveAccount1: Record "33020370";
        EmployeeRec: Record "5200";
        UserSetup: Record "91";
        Approve1: Code[20];
        Approve2: Code[20];
        Emp1: Record "5200";
        Emp2: Record "5200";
        HRPermission: Record "33020304";
        DeptCode: Code[20];
        SMTPMail: Codeunit "400";
        SenderName: Text[100];
        SenderAddress: Text[80];
        SMTP: Record "409";

    [Scope('Internal')]
    procedure Approve()
    begin
        IF "Pay Type" = 0 THEN
          ERROR('Please enter Pay Type');
        EmpID := "Employee No.";
        
        ConfirmApprove := DIALOG.CONFIRM(Text004,TRUE);
        IF ConfirmApprove THEN BEGIN
          PostLeaveReqRec.RESET;
          PostLeaveReqRec.SETRANGE("Entry No.","Entry No.");
          PostLeaveReqRec.SETRANGE("Employee No.",EmpID);
         // PostLeaveReqRec.SETFILTER("Requested Date",'%1..%2',0D,TODAY);
          PostLeaveReqRec.SETRANGE(Approved,FALSE);
          PostLeaveReqRec.SETRANGE(Rejected,FALSE);
          IF PostLeaveReqRec.FIND('+') THEN BEGIN
            PostLeaveReqRec.Approved := TRUE;
            PostLeaveReqRec."Approval Date" := TODAY;
            PostLeaveReqRec.MODIFY;
        
            //Finding Remaining Balance Days from Leave Account table
            CLEAR(BalanceDays);
            LeaveAccount.RESET;
            LeaveAccount.SETRANGE("Employee Code","Employee No.");
            LeaveAccount.SETRANGE("Leave Type","Leave Type Code");
            IF LeaveAccount.FINDFIRST THEN BEGIN
              BalanceDays := LeaveAccount."Balance Days";
            END;
        
        
            //Updating Leave Account
          UpdateInLeaveAccount();
        
           //Check if the Leave type is without Pay or Absent
          //CheckForAbsentLeave();
        
            CLEAR(LeaveRegRec);
            LeaveRegRec.INIT;
            LeaveRegRec.VALIDATE("Employee No.",EmpID);
            LeaveRegRec."Work Shift Code" := PostLeaveReqRec."Work Shift Code";
            LeaveRegRec."Leave Type Code" := PostLeaveReqRec."Leave Type Code";
            LeaveRegRec."Leave Start Date" := PostLeaveReqRec."Leave Start Date";
            LeaveRegRec."Leave End Date" := PostLeaveReqRec."Leave End Date";
            LeaveRegRec."Leave Start Time" := PostLeaveReqRec."Leave Start Time";
            LeaveRegRec."Leave End Time" := PostLeaveReqRec."Leave End Time";
            LeaveRegRec."Fiscal Year" := PostLeaveReqRec."Fiscal Year";    //Add Fiscal Year later
            LeaveRegRec.Approved := TRUE;
            LeaveRegRec."Approved By" := USERID;
            LeaveRegRec."Approved Date" := TODAY;
            MESSAGE('%1 will have an approve for leave',EmpID);
           // LeaveRegRec."Approval Comment" := CommentText;
            LeaveRegRec."Used Days" := PostLeaveReqRec."No. of Days";
            LeaveRegRec."Balance Days" := BalanceDays - PostLeaveReqRec."No. of Days";
            LeaveRegRec."Manager ID" := PostLeaveReqRec."Manager ID";
            LeaveRegRec."Request Date" := PostLeaveReqRec."Requested Date";
            LeaveRegRec."Request Time" := PostLeaveReqRec."Request Time";
            LeaveRegRec.Remarks := PostLeaveReqRec.Remarks;
            LeaveRegRec."Pay Type" := "Pay Type";
            LeaveRegRec."Full Name" := "Full Name";
            LeaveRegRec."Requeste Date (BS)" := "Requeste Date (BS)";
            LeaveRegRec."Job Title Code" := PostLeaveReqRec."Job Title Code";
            LeaveRegRec."Job Title" := PostLeaveReqRec."Job Description";
            LeaveRegRec.Type := 1;
            LeaveRegRec.INSERT(TRUE);
            LeaveRegRec.FINDLAST;
            LeaveRegisterNo := LeaveRegRec."Entry No.";
           // MESSAGE(FORMAT(LeaveRegisterNo));
            LeaveRegRec.MODIFY;
        
            //Updating Leave Approve/Disapprove Table
            CLEAR(LeaveReqAppDisappRec);
            LeaveReqAppDisappRec.INIT;
            //LeaveReqAppDisappRec."Employee No." := PostLeaveReqRec."Employee No.";
            LeaveReqAppDisappRec.VALIDATE("Employee No." , PostLeaveReqRec."Employee No.");
            LeaveReqAppDisappRec."Full Name" := "Full Name";
            LeaveReqAppDisappRec."Requested Leave Start Date" := PostLeaveReqRec."Leave Start Date";
            LeaveReqAppDisappRec."Requested Leave End Date" := PostLeaveReqRec."Leave End Date";
            LeaveReqAppDisappRec."Leave Type Code" := PostLeaveReqRec."Leave Type Code";
            LeaveReqAppDisappRec."Granted Leave Start Date" := PostLeaveReqRec."Leave Start Date";
            LeaveReqAppDisappRec."Granted Leave End Date" := PostLeaveReqRec."Leave End Date";
            LeaveReqAppDisappRec."Fiscal Year" := PostLeaveReqRec."Fiscal Year";
            LeaveReqAppDisappRec.Approved := TRUE;
            LeaveReqAppDisappRec."Approved By" := USERID;
            LeaveReqAppDisappRec."Approved Date" := TODAY;
            LeaveReqAppDisappRec."Approval Remarks" := CommentText;
            // LeaveReqAppDisappRec."User ID" := "User ID";
            LeaveReqAppDisappRec.INSERT;
        
        
         //Updating record in Leave Account
         END;
        
          COMMIT;
          MESSAGE(Text000,EmpID);
        //Sending mail.
        SendMail1();
        
        END ELSE
          MESSAGE(Text003);
        
        
        //to print leave form
        
        /*PostLeaveReqRec.RESET;
        PostLeaveReqRec.SETRANGE(PostLeaveReqRec."Entry No.","Entry No.");
        IF PostLeaveReqRec.FINDFIRST THEN BEGIN
           REPORT.RUNMODAL(33020324,TRUE,FALSE,PostLeaveReqRec);
        END; */

    end;

    [Scope('Internal')]
    procedure Disapprove()
    begin
        //CurrPage.SETSELECTIONFILTER(Rec);
        EmpID := "Employee No.";
        
        ConfirmRejection := DIALOG.CONFIRM(Text001,FALSE);
        IF ConfirmRejection THEN BEGIN
         /*
          Window.OPEN('Please enter disapproval comment - ##1################################################################',CommentText);
          Window.INPUT(1,CommentText);
          Window.CLOSE;
          */
          PostLeaveReqRec.RESET;
          PostLeaveReqRec.SETRANGE("Employee No.",EmpID);
          PostLeaveReqRec.SETFILTER("Requested Date",'%1..%2',0D,TODAY);
          IF PostLeaveReqRec.FIND('+') THEN BEGIN
            PostLeaveReqRec.Rejected := TRUE;
            PostLeaveReqRec."Reject Date" := TODAY;
            PostLeaveReqRec."Rejection Remarks" := CommentText;
            PostLeaveReqRec.MODIFY;
        
            LeaveReqAppDisappRec.INIT;
           // LeaveReqAppDisappRec."Employee No." := PostLeaveReqRec."Employee No.";
            LeaveReqAppDisappRec.VALIDATE("Employee No." , PostLeaveReqRec."Employee No.");
            LeaveReqAppDisappRec."Full Name" := "Full Name";
            LeaveReqAppDisappRec."Leave Type Code" := PostLeaveReqRec."Leave Type Code";
            LeaveReqAppDisappRec."Requested Leave Start Date" := PostLeaveReqRec."Leave Start Date";
            LeaveReqAppDisappRec."Requested Leave End Date" := PostLeaveReqRec."Leave End Date";
            LeaveReqAppDisappRec."Fiscal Year" := PostLeaveReqRec."Fiscal Year";
            LeaveReqAppDisappRec.Disapproved := TRUE;
            LeaveReqAppDisappRec."Rejected By" := USERID;
            LeaveReqAppDisappRec."Reject Date" := TODAY;
            LeaveReqAppDisappRec."Rejection Remarks" := CommentText;
           // LeaveReqAppDisappRec."User ID" := "User ID";
            LeaveReqAppDisappRec.INSERT;
        
        // delete record in Posted Leave Table
            PostLeaveReqRec1.RESET;
            PostLeaveReqRec1.SETRANGE("Entry No.","Entry No.");
            PostLeaveReqRec1.SETRANGE("Employee No.","Employee No.");
            PostLeaveReqRec.SETRANGE("Manager ID","Manager ID");
            IF PostLeaveReqRec1.FINDFIRST THEN BEGIN
              PostLeaveReqRec.DELETE;
            END;
                MESSAGE('%1',EmpID);
          END;
        END ELSE
          MESSAGE(Text003);
        
        //Sending Mail.
        SendMail2();

    end;

    [Scope('Internal')]
    procedure SendMail1()
    begin
        EmpRec.RESET;
        EmpRec.SETRANGE("No.","Employee No.");
        IF EmpRec.FIND('-') THEN BEGIN
          MailTo := EmpRec."Company E-Mail";
          EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
        END;

        SMTP.GET;
        SenderAddress := SMTP."User ID";

        PostLeaveReqRec.RESET;
        PostLeaveReqRec.SETRANGE("Employee No.","Employee No.");
        PostLeaveReqRec.SETRANGE("Entry No.","Entry No.");    //ankur(12/16/2021)
        IF PostLeaveReqRec.FIND('+') THEN BEGIN
          FromDateText := FORMAT(PostLeaveReqRec."Leave Start Date",0,4);
          ToDateText := FORMAT(PostLeaveReqRec."Leave End Date",0,4);
        END;

        Dear := 'Dear ' + EmpName + ',';
        Subject := 'Approval of your leave request.';
        MessageText := 'Your leave request has been approved, starting from ' + FromDateText + ' to ' + ToDateText ;



        IF MailTo <> '' THEN BEGIN
          EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
          EmailBody := EmailBody +  Dear + '<br><br>';
          EmailBody := EmailBody + MessageText + '<br><br><br>' + 'Manager' + '<br><br><hr>';

          SMTPMail.CreateMessage(MailTo,SenderAddress,MailTo,Subject,EmailBody,TRUE);       //Employee's Email address
          SMTPMail.AddCC(MailTo);
          SMTPMail.Send();
          MESSAGE(Text010);
        END ELSE
          ERROR(Text011);
    end;

    [Scope('Internal')]
    procedure SendMail2()
    begin
        EmpRec.RESET;
        EmpRec.SETRANGE("No.","Employee No.");
        IF EmpRec.FIND('-') THEN BEGIN
          MailTo := EmpRec."Company E-Mail";
          EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
        END;

        SMTP.GET;
        SenderAddress := SMTP."User ID";
        Dear := 'Dear ' + EmpName + ',';
        Subject := 'Disapproval of your leave request.';
        MessageText := 'Your leave request has been disapproved';

        IF MailTo <> '' THEN BEGIN


          EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
          EmailBody := EmailBody +  Dear + '<br><br>';
          EmailBody := EmailBody + MessageText + '<br><br><br>' + 'Manager' + '<br><br><hr>';

          SMTPMail.CreateMessage(MailTo,SenderAddress,MailTo,Subject,EmailBody,TRUE);       //Employee's Email address
          SMTPMail.AddCC(MailTo);
          SMTPMail.Send;
          MESSAGE(Text010);
        END ELSE
          ERROR(Text011);
    end;

    [Scope('Internal')]
    procedure UpdateInLeaveAccount()
    begin
        LeaveAccount1.RESET;
        LeaveAccount1.SETRANGE("Employee Code","Employee No.");
        LeaveAccount1.SETRANGE("Leave Type","Leave Type Code");
        IF LeaveAccount1.FINDFIRST THEN BEGIN
         LeaveAccount1."Used Days" += "No. of Days";
         LeaveAccount1."Balance Days" -= "No. of Days";
         LeaveAccount1.LastCalculatedDate := TODAY;
         LeaveAccount1.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure CheckForAbsentLeave()
    begin
        IF ("Leave Type Code" = 'LW') OR  ("Leave Type Code" = 'SW') OR ("Leave Type Code" = 'AB') THEN BEGIN
          EmpRec.RESET;
          EmpRec.SETRANGE("No.","Employee No.");
          IF EmpRec.FINDFIRST THEN BEGIN
            EmpRec."Restrict Leave Earn" := TRUE;
            EmpRec."Leave Restrited Date" := TODAY;
            EmpRec.MODIFY;
          END;
        END;
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
    begin
        HRUP.GET(USERID);
        IF NOT HRUP."Super Permission" THEN BEGIN
          IF NOT ((HRUP."Admin Permission") OR (HRUP."Branch Admin"))THEN BEGIN
            Emp1.RESET;
            Emp1.SETRANGE("No.","Manager ID");
            IF Emp1.FINDFIRST THEN
              IF (Emp1."User ID" <> '') THEN
                Approve1 := Emp1."User ID";
                Emp2.RESET;
                Emp2.SETRANGE("No.",Emp1."Manager ID");
                IF Emp2.FINDFIRST THEN
                  IF (Emp2."User ID" <> '') THEN
                    Approve2 := Emp2."User ID";
                    //message(Approve1);
                     IF ((Approve1 <> '') OR (Approve2 <>'')) THEN BEGIN
                      IF NOT (UPPERCASE(USERID) = Approve1) THEN BEGIN
                        IF NOT (UPPERCASE(USERID) = Approve2) THEN
                          ERROR('You do not have permission to Process this Leave1');
                      END;
                     END
          ELSE
            ERROR('USERID is Missing in Managers employee card');
          END;
        END;
    end;
}

