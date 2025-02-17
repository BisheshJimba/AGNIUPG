page 33020350 "Leave Request Card"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table33020342;

    layout
    {
        area(content)
        {
            group("Leave Request")
            {
                field("Leave Request No."; "Leave Request No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee No."; "Employee No.")
                {

                    trigger OnValidate()
                    begin
                        /*
                         EmpRec.SETRANGE("No.","Employee No.");
                        IF EmpRec.FIND('-') THEN BEGIN
                           "First Name" := EmpRec."First Name";
                           "Middle Name" := EmpRec."Middle Name";
                           "Last Name" := EmpRec."Last Name";
                           "Manager ID" := EmpRec."Manager ID";
                           "Job Title Code" := EmpRec."Job Title Code";
                           "Job Description" := EmpRec."Job Title";
                           "Work Shift Code" := EmpRec."Work Shift Code";
                           "Work Shift Description" := EmpRec."Work Shift Description";
                        END;
                        */
                        LeaveAcc.RESET;
                        LeaveAcc.SETRANGE(LeaveAcc."Employee Code", "Employee No.");
                        LeaveAcc.SETRANGE(LeaveAcc."Leave Type", "Leave Type Code");
                        IF LeaveAcc.FINDFIRST THEN BEGIN
                            OnHandLeave := LeaveAcc."Balance Days";
                        END ELSE BEGIN
                            OnHandLeave := 0.0;
                        END;
                        CurrPage.SAVERECORD;
                        CurrPage.UPDATE(TRUE);

                    end;
                }
                field("First Name"; "First Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Full Name"; "Full Name")
                {
                    Editable = false;
                }
                field("Middle Name"; "Middle Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Last Name"; "Last Name")
                {
                    Visible = false;
                }
                field("Manager ID"; "Manager ID")
                {
                    Editable = false;
                }
                field("Job Title Code"; "Job Title Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Job Title"; "Job Title")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Work Shift Code"; "Work Shift Code")
                {
                    Editable = false;
                }
                field("Work Shift Description"; "Work Shift Description")
                {
                    Editable = false;
                }
                field("Leave Type Code"; "Leave Type Code")
                {

                    trigger OnValidate()
                    begin
                        LeaveAcc.RESET;
                        LeaveAcc.SETRANGE(LeaveAcc."Employee Code", "Employee No.");
                        LeaveAcc.SETRANGE(LeaveAcc."Leave Type", "Leave Type Code");
                        IF LeaveAcc.FINDFIRST THEN BEGIN
                            OnHandLeave := LeaveAcc."Balance Days";
                        END ELSE BEGIN
                            OnHandLeave := 0.0;
                        END;
                    end;
                }
                field("Leave Description"; "Leave Description")
                {
                }
                field("Leave Type"; "Leave Type")
                {

                    trigger OnValidate()
                    begin
                        CalculateNoOfDays();
                    end;
                }
                field("Leave Start Date"; "Leave Start Date")
                {

                    trigger OnValidate()
                    begin
                        CalculateNoOfDays();
                    end;
                }
                field("Leave Start Date (BS)"; "Leave Start Date (BS)")
                {
                    Editable = false;
                }
                field("Leave Start Time"; "Leave Start Time")
                {
                    Editable = false;
                }
                field("Leave End Date"; "Leave End Date")
                {

                    trigger OnValidate()
                    begin
                        CalculateNoOfDays();
                        "Leave End Date (BS)" := STPLSysMgmt.getNepaliDate("Leave End Date");
                        /*
                        TotalReqLeave := "Leave End Date" - "Leave Start Date";
                        "No of days" := TotalReqLeave;
                        
                        //---------------------------------------------------
                        LeaveAcc.SETRANGE(LeaveAcc."Employee Code","Employee No.");
                        LeaveAcc.SETRANGE(LeaveAcc."Leave Type","Leave Type Code");
                        IF LeaveAcc.FINDFIRST THEN BEGIN
                           IF LeaveAcc.NetEarnDays < TotalReqLeave THEN BEGIN
                              ERROR(text0005);
                           END;
                        END;
                        //---------------------------------------------------------
                         */
                        /*
                        IF ("Leave End Date"<"Leave Start Date" ) THEN
                           ERROR(Text011)
                        ELSE BEGIN
                           Month := DATE2DMY("Leave End Date",2);
                           Year := DATE2DMY("Leave End Date",3);
                           LeaveType.SETRANGE("Leave Type Code","Leave Type Code");
                           IF LeaveType.FIND('-') THEN BEGIN
                               IF (LeaveType.Earnable = TRUE) THEN BEGIN
                                  "Earned Days" := CalcEarnDays.CalculateEarnDays(Month,Year,"Employee No.","Leave Type Code") ;
                                   IF ("Earned Days"<TotalReqLeave) THEN
                                    ERROR(Text012);
                               END
                               ELSE IF ((LeaveType.Earnable = FALSE) AND (LeaveType.OnlyForFemale = TRUE)) THEN BEGIN      //Maternity Leave
                                       EmpRec.RESET;
                                       EmpRec.SETRANGE(EmpRec."No.","Employee No.");
                                       IF EmpRec.FIND('-') THEN BEGIN
                                           IF(EmpRec.Gender = EmpRec.Gender :: "2") THEN   // Only For Female
                                           ERROR(Text015)
                                           ELSE BEGIN
                                               NoOfTimes := CalcEarnDays.NonEarnableLeaveCalculation("Employee No.","Leave Type Code");

                                               IF (NoOfTimes>=LeaveType."Times Per Service Period") THEN
                                               ERROR(Text014);
                                           END
                                       END
                               END
                               ELSE IF ((LeaveType.Earnable = FALSE) AND (LeaveType.OnlyForFemale = FALSE)) THEN BEGIN     //Mourning Leave
                                    NoOfTimes := CalcEarnDays.NonEarnableLeaveCalculation("Employee No.","Leave Type Code");
                                    IF (NoOfTimes>=LeaveType."Times Per Service Period") THEN
                                    ERROR(Text014);
                               END
                           END
                        END;
                        */
                        GetFiscalYear.SETRANGE("English Date", "Leave Start Date");
                        IF GetFiscalYear.FIND('-') THEN BEGIN
                            "Fiscal Year" := GetFiscalYear."Fiscal Year";
                        END;

                    end;
                }
                field("Leave End Date (BS)"; "Leave End Date (BS)")
                {
                    Editable = false;
                }
                field("Leave End Time"; "Leave End Time")
                {
                    Editable = false;
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Request Time"; "Request Time")
                {
                }
                field(CheckList; CheckList)
                {
                    Visible = false;
                }
                field(OnHandLeave; OnHandLeave)
                {
                    Caption = 'On Hand Leave';
                    Editable = false;
                }
                field("No of days"; "No of days")
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
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ConfirmPost := DIALOG.CONFIRM(Text0002,TRUE);
                    IF ConfirmPost THEN BEGIN
                    CheckFields;
                    
                    //Check duplication for same employee
                    PostLeaveReq.RESET;
                    PostLeaveReq.SETRANGE("Employee No.","Employee No.");
                    PostLeaveReq.SETRANGE("Leave Start Date","Leave Start Date");
                    PostLeaveReq.SETRANGE("Leave End Date","Leave End Date");
                    IF PostLeaveReq.FINDFIRST THEN
                      ERROR('Leave has been already posted for this employee %1 on start date %2 and end date %3!!!',"Employee No.","Leave Start Date",
                      "Leave End Date");
                    
                    //to calculate no of leave
                    CLEAR(Difference);
                    NoOfDays := "Leave End Date" - "Leave Start Date";
                    
                    /*
                    Difference :=  "Leave End Time" - "Leave Start Time";
                    IF (Difference = 28800000.0) OR ( Difference > 14400000.0) THEN BEGIN
                        TimeNo := 1;
                    END;
                    IF (Difference = 14400000.0) OR (Difference < 14400000.0 ) THEN BEGIN
                       TimeNo := 0.5;
                    END;
                    IF (Difference = 0.0)  THEN BEGIN
                      TimeNo:= 0;
                    END;
                    TotalDays := NoOfDays + TimeNo;
                    */
                    
                    IF "Leave Type" = "Leave Type" :: "Full Day Leave" THEN
                    Difference := 1
                    ELSE Difference := 0.5;
                     TotalDays := NoOfDays + Difference;
                    "No of days" := TotalDays;
                    
                    "No of days" := TotalDays;
                    LeaveRequest.RESET;
                    LeaveRequest.SETRANGE(LeaveRequest."Leave Request No.","Leave Request No.");
                    IF LeaveRequest.FINDFIRST THEN BEGIN
                       LeaveRequest."No of days" := TotalDays;
                       LeaveRequest.MODIFY;
                    END;
                    
                    //to check min leave per day
                    LeaveType.RESET;
                    LeaveType.SETRANGE(LeaveType."Leave Type Code","Leave Type Code");
                    IF LeaveType.FINDFIRST THEN BEGIN
                      IF LeaveType."Min. Leave Per Day" <> 0.0 THEN
                       IF LeaveType."Min. Leave Per Day" < "No of days" THEN
                          ERROR(text0006,LeaveType."Min. Leave Per Day","No of days");
                    END;
                    //---------------------------------------------------
                    //Checking the Remaining Days or Balance Days from Leave Account
                    
                    LeaveAcc.RESET;
                    LeaveAcc.SETRANGE(LeaveAcc."Employee Code","Employee No.");
                    LeaveAcc.SETRANGE(LeaveAcc."Leave Type","Leave Type Code");
                    IF LeaveAcc.FINDFIRST THEN BEGIN
                       IF LeaveAcc."Balance Days" < TotalDays THEN BEGIN
                          ERROR(text0005,TotalDays,LeaveAcc."Balance Days");
                       END;
                    END ELSE BEGIN
                        ERROR(text0007,"Full Name","Leave Description");
                    END;
                    //---------------------------------------------------------
                    
                    //------------------------------------------------
                    EmpRec.RESET;
                    EmpRec.SETRANGE("No.","Employee No.");
                    IF EmpRec.FIND('-') THEN BEGIN
                      // EmpRec.CALCFIELDS("Manager ID");
                      IF EmpRec."Manager ID" <> '' THEN BEGIN
                         // MESSAGE("Manager ID");
                         PostLeaveRec.INIT;
                         PostLeaveRec."Manager ID" := "Manager ID";
                         PostLeaveRec.VALIDATE("Employee No.","Employee No.");
                         PostLeaveRec."Leave Type Code" := "Leave Type Code";
                         PostLeaveRec."Leave Start Date" := "Leave Start Date";
                         PostLeaveRec."Leave End Date" := "Leave End Date";
                         PostLeaveRec."Leave Start Time" := "Leave Start Time";
                         PostLeaveRec."Leave End Time" := "Leave End Time";
                         PostLeaveRec."Requested Date" := "Request Date";
                         PostLeaveRec."Request Time" := "Request Time";
                         PostLeaveRec.Remarks := Remarks;
                         PostLeaveRec."Work Shift Code" := "Work Shift Code";
                         PostLeaveRec."Job Title Code" := "Job Title Code";
                         PostLeaveRec."Leave Request No." := "Leave Request No.";
                         PostLeaveRec."Fiscal Year" := "Fiscal Year";
                         PostLeaveRec.Posted := TRUE;
                         PostLeaveRec."Posted Date" := TODAY;
                         PostLeaveRec."No. of Days" := "No of days";
                         PostLeaveRec.Remarks := Remarks;
                         PostLeaveRec."Pay Type" := "Pay Type";
                         PostLeaveRec."Full Name" := "Full Name";
                         PostLeaveRec."Requeste Date (BS)" := "Requeste Date (BS)";
                         PostLeaveRec."Job Title Code" := "Job Title Code";
                         PostLeaveRec."Job Description" := "Job Title";
                         PostLeaveRec.INSERT;
                         MESSAGE(Text000);
                    
                    //sm to delete record after posting
                         LeaveRequest.SETRANGE("Leave Request No.",PostLeaveRec."Leave Request No.");
                         IF LeaveRequest.FIND('-') THEN
                            LeaveRequest.DELETE;
                    
                      END ELSE
                        ERROR(Text008);
                    END;
                    
                    //Calling SendMail function to send mail for leave request.
                    SendMail();
                    
                    
                    END ELSE
                      MESSAGE(Text0001,USERID);

                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        /*LeaveAcc.RESET;
        LeaveAcc.SETRANGE(LeaveAcc."Employee Code","Employee No.");
        LeaveAcc.SETRANGE(LeaveAcc."Leave Type","Leave Type Code");
        IF LeaveAcc.FINDFIRST THEN BEGIN
           OnHandLeave := LeaveAcc."Balance Days";
        END ELSE BEGIN
           OnHandLeave := 0.0;
        END;
        CurrPage.UPDATE(TRUE);*/

    end;

    trigger OnAfterGetRecord()
    begin
        
        /*LeaveAcc.RESET;
        LeaveAcc.SETRANGE(LeaveAcc."Employee Code","Employee No.");
        LeaveAcc.SETRANGE(LeaveAcc."Leave Type","Leave Type Code");
        IF LeaveAcc.FINDFIRST THEN BEGIN
           OnHandLeave := LeaveAcc."Balance Days";
        END ELSE BEGIN
           OnHandLeave := 0.0;
        END;
        CurrPage.UPDATE(TRUE);*/

    end;

    trigger OnOpenPage()
    begin
        
        /*LeaveAcc.RESET;
        LeaveAcc.SETRANGE(LeaveAcc."Employee Code","Employee No.");
        LeaveAcc.SETRANGE(LeaveAcc."Leave Type","Leave Type Code");
        IF LeaveAcc.FINDFIRST THEN BEGIN
           OnHandLeave := LeaveAcc."Balance Days";
        END ELSE BEGIN
           OnHandLeave := 0.0;
        END;
        CurrPage.SAVERECORD;
        CurrPage.UPDATE(TRUE);*/

    end;

    var
        EmpRec: Record "5200";
        PostLeaveRec: Record "33020344";
        EntryNo: Integer;
        Dear: Text[250];
        MailTo: Text[250];
        Subject: Text[100];
        MessageText: Text[250];
        FromDateText: Text[60];
        ToDateText: Text[60];
        EmpName: Text[250];
        Text000: Label 'Your leave request has been posted to your manager. Please check later for approval!';
        Text001: Label 'Employee No. cannot be blank! Please provide your Employee No.';
        Text002: Label 'Leave Type Code cannot be blank! Please provide Leave Type Code.';
        Text003: Label 'Leave Start Date cannot be blank! Please provide Leave Start Date.';
        Text004: Label 'Leave End Date cannot be blank! Please provide Leave End Date.';
        Text005: Label 'Leave Start Time cannot be blank! Please provide Leave Start Time.';
        Text006: Label 'Leave End Time cannot be blank! Please provide Leave End Time.';
        Text007: Label 'Work Shift Code cannot be blank! Please provide Work Shift Code.';
        Text008: Label 'Manager ID No. is blank in Employee Registration! Please contact your system manager.';
        Text009: Label 'There is no Manager e- mail address! Please contact your system administrator.';
        Text010: Label 'Sent successcully! Please check Sent Items of your Outlook.';
        LeaveRequest: Record "33020342";
        TotalReqLeave: Decimal;
        LeaveType: Record "33020345";
        Month: Integer;
        Year: Integer;
        "Earned Days": Decimal;
        STPLSysMgmt: Codeunit "50000";
        GetFiscalYear: Record "33020302";
        CalcEarnDays: Codeunit "33020301";
        Text011: Label 'End Date can''t be less than Start Date';
        Text012: Label 'Leave Requests exceed the Earned Days';
        Text013: Label 'Check List must be completed before Leave Request';
        NoOfTimes: Integer;
        Text014: Label 'Leave Request exceed the maximum number of times';
        Text015: Label 'Leave allowed only for Female Employees';
        Text0001: Label 'Aborted By User - %1 !';
        Text0002: Label 'Are you sure to Post ?';
        ConfirmPost: Boolean;
        LeaveAcc: Record "33020370";
        text0005: Label 'You have requested leave of %1 days which exceeds your Leave Balance of %2 days!';
        NoOfDays: Decimal;
        Difference: Decimal;
        TotalDays: Decimal;
        TimeNo: Decimal;
        text0006: Label 'Minimum Leave Per Day is  %1 days! Leave Request %2 days can''t be less than Min. Leave Per Day!!';
        text0007: Label 'Leave Earn is not carried out for this employee %1 with Leave type %2 in Leave Account Table. Contact Administration for Leave Request.';
        LeaveRegister: Record "33020343";
        OnHandLeave: Decimal;
        PostLeaveReq: Record "33020344";
        EmployeeRec: Record "5200";
        Text016: Label 'Mail Could Not be Send.';
        TravellerEmpRec: Record "5200";
        Appraiser1Emp: Record "5200";

    [Scope('Internal')]
    procedure CheckFields()
    begin
        IF "Employee No." = '' THEN
          ERROR(Text001);
        
        IF "Leave Type Code" = '' THEN
          ERROR(Text002);
        
        IF "Leave Start Date" = 0D THEN
          ERROR(Text003);
        
        IF "Leave End Date" = 0D THEN
          ERROR(Text004);
        
        IF "Leave Start Time" = 0T THEN
          ERROR(Text005);
        
        IF "Leave End Time" = 0T THEN
          ERROR(Text006);
        
        IF "Work Shift Code" = '' THEN
          ERROR(Text007);
        
        IF "No of days" < 0 THEN
            ERROR('Negative Days cannot be posted');
        
        /*LeaveType.RESET;
        LeaveType.SETRANGE("Leave Type Code","Leave Type Code");
        IF LeaveType.FIND('-') THEN BEGIN
            IF (TotalReqLeave>LeaveType."Maximum Allowable Limit") THEN BEGIN
               IF (LeaveType."CheckList Reqd." = TRUE)  THEN BEGIN
                  IF(CheckList = FALSE) THEN
                     ERROR(Text013);
        
               END
            END
        EN*/

    end;

    [Scope('Internal')]
    procedure SendMail()
    var
        EmailBody: Text[1024];
        "--AGNIUPG2009--": InStream;
        FileName: Text;
        FileDirectory: Text;
        FileManagement: Codeunit "419";
        SMTPMail: Codeunit "400";
        CompanyInfo: Record "79";
        SMTPMailSetup: Record "409";
        Sent: Boolean;
        MailSender: Record "5200";
        SenderMail: Text[250];
    begin
        
        EmpRec.RESET;
        EmpRec.SETRANGE("No.","Manager ID");
        IF EmpRec.FIND('-') THEN BEGIN
          MailTo := EmpRec."Company E-Mail";
          EmployeeRec.RESET;
          EmployeeRec.SETFILTER("Department Name",'Human Resource Department');
          IF EmployeeRec.FINDFIRST THEN REPEAT
            IF EmployeeRec."Company E-Mail" <> '' THEN  //Agni UPG 2009
              MailTo += ';'+EmployeeRec."Company E-Mail";
          UNTIL EmployeeRec.NEXT =0;
        
          EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
        END;
          FromDateText := FORMAT("Leave Start Date",0,4);
          ToDateText := FORMAT("Leave End Date",0,4);
        
          Dear := 'Dear Sir/Madam,';
          Subject := 'About leave permission.';
          MessageText := 'With due respect, I ' + "First Name" + ' ' + "Last Name" + ' would like to request for leave starting from (' + FORMAT("Leave Type") +')' +
                      FromDateText + ' to ' + ToDateText + '.';
        
        IF MailTo <> '' THEN BEGIN
          EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
          EmailBody := EmailBody +  Dear + '<br><br>';
          EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                       + "First Name" + ' ' + "Last Name" + '<br><br><hr>';
        
           /*For Attachment
          FileName := CompanyInfo.Name +' - '+ "Leave Request No.";
          FileDirectory := FileManagement.ServerTempFileName('xls');
          REPORT.SAVEASEXCEL(50014,FileDirectory,Rec);
          */
          SMTPMailSetup.GET;
          SMTPMail.CreateMessage(CompanyInfo.Name,SMTPMailSetup."User ID",MailTo,Subject,EmailBody,TRUE);
          //SMTPMail.AddAttachment(FileDirectory,FileName+'.xls');For Attachment
          TravellerEmpRec.GET("Employee No.");
          IF TravellerEmpRec."First Appraisal ID" <> '' THEN BEGIN
            IF Appraiser1Emp.GET(TravellerEmpRec."First Appraisal ID") THEN BEGIN
              Appraiser1Emp.TESTFIELD("Company E-Mail");
              SMTPMail.AddCC(Appraiser1Emp."Company E-Mail");
            END;
          END;
          IF TravellerEmpRec."Second Appraisal ID" <> '' THEN BEGIN
            IF Appraiser1Emp.GET(TravellerEmpRec."Second Appraisal ID") THEN BEGIN
              Appraiser1Emp.TESTFIELD("Company E-Mail");
              SMTPMail.AddCC(Appraiser1Emp."Company E-Mail");
            END;
          END;
          Sent := SMTPMail.TrySend;
          IF Sent THEN
            MESSAGE(Text010)
          ELSE
            MESSAGE(Text016)
        END ELSE
          ERROR(Text009);

    end;

    [Scope('Internal')]
    procedure CalculateNoOfDays()
    begin
        CLEAR(Difference);
        NoOfDays := "Leave End Date" - "Leave Start Date";
        /*Difference :=  "Leave End Time" - "Leave Start Time";
        IF (Difference = 28800000.0) OR ( Difference > 14400000.0) THEN BEGIN
            TimeNo := 1;
        END;
        IF (Difference = 14400000.0) OR (Difference < 14400000.0 ) THEN BEGIN
           TimeNo := 0.5;
        END;
        IF (Difference = 0.0)  THEN BEGIN
          TimeNo:= 0;
        END;
        TotalDays := NoOfDays + TimeNo;
        */
        
        IF "Leave Type" = "Leave Type" :: "Full Day Leave" THEN
        Difference := 1
        ELSE Difference := 0.5;
         TotalDays := NoOfDays + Difference;
        "No of days" := TotalDays;

    end;
}

