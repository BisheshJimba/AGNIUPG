page 33020403 "Emp Req Form"
{
    PageType = Card;
    SourceTable = Table33020379;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(EmpReqNo; EmpReqNo)
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                    Editable = false;
                }
                field("Position Code"; "Position Code")
                {
                }
                field("Position Name"; "Position Name")
                {
                    Editable = false;
                }
                field("Supervisor Code"; "Supervisor Code")
                {
                }
                field("Supervisor Name"; "Supervisor Name")
                {
                    Editable = false;
                }
                field(Branch; Branch)
                {
                }
                field(Segment; Segment)
                {
                    Caption = 'Job Role';
                }
                field("Date Required"; "Date Required")
                {
                }
                field("No. of Position"; "No. of Position")
                {
                }
                field("Job Description"; "Job Description")
                {
                }
                field("Reason for Requirement"; "Reason for Requirement")
                {
                }
                field("Remarks on Reason"; "Remarks on Reason")
                {
                }
                field("Posted By"; "Posted By")
                {
                    Caption = 'Posted By';
                }
                field("Posted Date"; "Posted Date")
                {
                    Visible = false;
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
            group("<Action1000000016>")
            {
                Caption = 'Posting';
                action("<Action1000000017>")
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        EmpRec: Record "5200";
                        MailTo: Text;
                        EmpName: Text;
                        Initial: Text;
                        Dear: Text;
                        Subject: Text;
                        MessageText: Text;
                        EmailBody: Text;
                        SMTPMailSetup: Record "409";
                        SMTPMail: Codeunit "400";
                    begin
                        //msg('123');
                        TESTFIELD("Fiscal Year");
                        //TESTFIELD("Position Band");
                        TESTFIELD("Department Code");
                        ConfirmPost := DIALOG.CONFIRM(text0001, TRUE);
                        IF ConfirmPost THEN BEGIN
                            //----------------------------------------------------------------
                            //sm to split fiscal year
                            /*Position := STRPOS("Fiscal Year",'/');
                            NewString := COPYSTR("Fiscal Year",Position+1,4);
                            NewString1 := COPYSTR("Fiscal Year",Position-4,4);
                            EVALUATE(VarInteger1,NewString1);
                            EVALUATE(VarInteger,NewString);
                            //MESSAGE('%1',VarInteger1);
                            //MESSAGE('%1',VarInteger);
                            //MESSAGE('%1',VarInteger1-1);
                            //MESSAGE('%1',VarInteger-1);


                            //sm to calculate current no of position
                            ManPowerBudEntry.SETRANGE(ManPowerBudEntry."Fiscal Year","Fiscal Year");
                            ManPowerBudEntry.SETRANGE(ManPowerBudEntry."Department Code","Department Code");
                            ManPowerBudEntry.SETRANGE(ManPowerBudEntry.Position,"Position Band");
                            IF ManPowerBudEntry.FINDFIRST THEN BEGIN
                                CurPosition := ManPowerBudEntry."No. of Person";
                            END;

                            //sm to calculate previous no of position
                            ManPowerBudEntry.RESET;
                            ManPowerBudEntry.SETRANGE(ManPowerBudEntry."Department Code","Department Code");
                            ManPowerBudEntry.SETRANGE(ManPowerBudEntry.Position,"Position Band");
                            ManPowerBudEntry.SETRANGE(ManPowerBudEntry.TestYear,FORMAT(VarInteger-1));
                            ManPowerBudEntry.SETRANGE(ManPowerBudEntry.TestYear1,FORMAT(VarInteger1-1));
                            IF ManPowerBudEntry.FINDFIRST THEN BEGIN
                                PrevPosition := ManPowerBudEntry."No. of Person";
                            END;

                            //MESSAGE('%1',CurPosition);
                            //MESSAGE('%1',PrevPosition);

                            TotalPosition := CurPosition - PrevPosition;

                            //MESSAGE('%1',TotalPosition);
                            //MESSAGE('%1',"No. of Position");

                            IF "No. of Position" <= TotalPosition THEN
                                   "Budget Verification" := "Budget Verification"::"Within Budget"
                            ELSE IF "No. of Position" > TotalPosition THEN
                                   "Budget Verification" := "Budget Verification"::"Exceeds Budget";

                            //---------------------------------------------------------------

                               EmpReq.SETRANGE(EmpReqNo,EmpReqNo);
                               IF EmpReq.FIND('-') THEN BEGIN
                                 "Posted Date" := TODAY;
                                 Posted := TRUE;
                                 EmpReq."No. of Position" := "No. of Position";
                                 EmpReq."Budget Verification" := "Budget Verification";
                                 MODIFY;
                                 MESSAGE(text0003);
                               END;
                               */
                            Posted := TRUE;
                            "Posted Date" := TODAY;
                            "Posted By" := USERID;
                            MODIFY;
                            MESSAGE(text0003);


                            //mail
                            EmpRec.RESET;
                            EmpRec.SETRANGE("Is Employee Req Manager", TRUE);
                            IF EmpRec.FINDFIRST THEN
                                MailTo := EmpRec."Company E-Mail";
                            EmpName := EmpRec."First Name" + ' ' + EmpRec."Middle Name" + ' ' + EmpRec."Last Name";
                            IF EmpRec.Gender = EmpRec.Gender::Male THEN
                                Initial := 'Mr. ';
                            IF EmpRec.Gender = EmpRec.Gender::Female THEN
                                Initial := 'Ms. ';

                            Dear := 'Dear ' + Initial + EmpName + ',';
                            Subject := 'Employee Requisiton';
                            MessageText := 'Employee Requisiton ' + EmpReqNo + ' for the post of ' +
                              "Position Name" + ' , Department - ' + "Department Name" + ', Branch - ' + Branch + '. Please approve Employee Requisiton.';

                            IF MailTo <> '' THEN BEGIN

                                EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#000000">';
                                EmailBody := EmailBody + Dear + '<br><br>';
                                EmailBody := EmailBody + MessageText + '<br><br> Thanking you!<br><br>' + '<br><br><hr>';


                            END ELSE
                                ERROR('No reciving mail');

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
                            //mail
                        END ELSE
                            MESSAGE(text0002, USERID);

                    end;
                }
            }
        }
    }

    var
        ConfirmPost: Boolean;
        text0001: Label 'Are you sure to post ?';
        text0002: Label 'Aborted by %1 !';
        EmpReq: Record "33020379";
        text0003: Label 'Your Employee Requisition is posted successfully.';
        ManPowerBudEntry: Record "33020378";
        Position: Integer;
        NewString: Code[10];
        NewString1: Code[10];
        CurPosition: Integer;
        PrevPosition: Integer;
        TotalPosition: Integer;
        VarInteger: Integer;
        VarInteger1: Integer;
}

