page 33020528 "Travel Order Page"
{
    PageType = Card;
    SourceTable = Table33020425;

    layout
    {
        area(content)
        {
            group("Travel Order Form")
            {
                field("Travel Order No."; "Travel Order No.")
                {
                }
                field("Travel Type"; "Travel Type")
                {
                }
                field("Depature Date (AD)"; "Depature Date (AD)")
                {
                }
                field("Depature Date (BS)"; "Depature Date (BS)")
                {
                    Editable = false;
                }
                field("Arrival Date (AD)"; "Arrival Date (AD)")
                {
                }
                field("Arrival Date (BS)"; "Arrival Date (BS)")
                {
                    Editable = false;
                }
                field("No. of Days"; "No. of Days")
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
                    Visible = false;
                }
                field(Department; Department)
                {
                }
                field(ManagerID; ManagerID)
                {
                    Editable = false;
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
                field("Mode Of Transportation"; "Mode Of Transportation")
                {
                    OptionCaption = ' ,India Tour,Local Vehicle,Agni''s Vehicle,Personal Vehicle,Others,By Air within Nepal,Agni Logistic Vehicle';

                    trigger OnValidate()
                    begin
                        /*
                        IF "Mode Of Transportation" = "Mode Of Transportation" :: Others THEN
                          EditableControl := TRUE
                          ELSE
                          EditableControl := FALSE;
                         */

                    end;
                }
                field("Approved Type"; "Approved Type")
                {
                }
                field("Local Transportation (Nrs.)"; "Local Transportation (Nrs.)")
                {
                }
                field("Transportation/Ticket (Nrs.)"; "Transportation/Ticket (Nrs.)")
                {
                    Visible = false;
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
                field("Calculate 20%"; "Calculate 20%")
                {
                }
                field(Helper; Helper)
                {
                }
                field(Driver; Driver)
                {
                }
                field("Calculate 100%"; "Calculate 100%")
                {
                }
                field("Calculate 40%"; "Calculate 40%")
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
        area(processing)
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
                    //MESSAGE('%1',"Traveler's Name");

                    ConfirmPost := DIALOG.CONFIRM(Text0001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        CheckFields;
                        TravelForm.RESET;
                        TravelForm.SETRANGE("Travel Order No.", "Travel Order No.");
                        IF TravelForm.FINDFIRST THEN BEGIN
                            Posted := TRUE;
                            "Posted By" := USERID;
                            "Posted Date" := TODAY;
                        END;
                        /*IF ManagerID = '' THEN BEGIN
                           ERROR('Manager ID No. is blank in Employee Registration! Please contact your system manager.');*/
                        //END ELSE BEGIN
                        Sendmail();
                    END;

                    //END;

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*IF "Mode Of Transportation" = "Mode Of Transportation" :: Others THEN
            EditableMode := TRUE
          ELSE
            EditableMode := FALSE;
         */

    end;

    var
        ConfirmPost: Boolean;
        Text0001: Label 'Are You Sure You Want to Post?';
        EditableControl: Boolean;
        EmpRec: Record "5200";
        TravelForm: Record "33020425";
        Text0003: Label 'Mail Sent';
        Text0004: Label 'Mail Not Sent';
        TravellerEmpRec: Record "5200";
        Appraiser1Emp: Record "5200";
        EmpRecord: Record "5200";

    [Scope('Internal')]
    procedure CheckFields()
    begin
        IF "Traveler's ID" = '' THEN
            ERROR('Traveler''s ID must be filled');

        IF "Travel Type" = "Travel Type"::" " THEN
            ERROR('Travel Type is Blank');

        IF "Travel Destination I" = '' THEN
            ERROR('Travel Destination is Blank');

        IF "Depature Date (AD)" = 0D THEN
            ERROR('Depature Date is Blank');

        IF "Arrival Date (AD)" = 0D THEN
            ERROR('Arrival Date is Blank');

        IF "Mode Of Transportation" = "Mode Of Transportation"::" " THEN
            ERROR('Mode Of Transportation is Blank');

        TESTFIELD("Travel Purpose");
    end;

    [Scope('Internal')]
    procedure Sendmail()
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
        EmpRec.SETRANGE("No.", ManagerID);
        IF EmpRec.FIND('-') THEN BEGIN
            MailTo := EmpRec."Company E-Mail";
            ManagerName := EmpRec."Full Name";
        END;
        FromDateText := FORMAT("Depature Date (AD)", 0, 4);
        ToDateText := FORMAT("Arrival Date (AD)", 0, 4);
        // FromTimeText := FORMAT("Start Time");
        // ToTimeText := FORMAT("End Time");

        Dear := 'Dear ' + ManagerName + ';';
        Subject := 'About ' + FORMAT("Travel Order No.") + ' permission.';
        MessageText := 'With due respect, I ' + "Traveler's Name" + ' would like to request for ' + FORMAT("Travel Order No.") + ' - ' +
                    FromDateText + ' ' + FromTimeText + ' to ' + ToDateText + ' - ' + ToTimeText + '.';

        IF MailTo <> '' THEN BEGIN
            /*
            IF ISCLEAR(ObjApp) THEN
                 CREATE(ObjApp,TRUE,TRUE);

            ObjMail := ObjApp.CreateItem(0);
            ObjMail."To"(MailTo);
            ObjMail.Subject(Subject);
            ObjMail.CC('cabinet@agniinc.com.np');
            */
            EmailBody := '<div style="font-family:Arial, Helvetica, sans-serif;font-size:12px;color:#0000FF">';
            EmailBody := EmailBody + Dear + '<br><br>';
            EmailBody := EmailBody + MessageText + '<br><br> Thanking you!,<br><br> Sincerely yours, <br>'
                         + "Traveler's Name" + '<br><br><hr>';

            /*
            ObjMail.HTMLBody(EmailBody);
            ObjMail.Send();
            */
            SMTPMailSetup.GET;
            SMTPMail.CreateMessage(CompanyInfo.Name, SMTPMailSetup."User ID", MailTo, Subject, EmailBody, TRUE);
            //SMTPMail.AddAttachment(FileDirectory,FileName+'.xls');For Attachment
            //SMTPMail.AddCC('cabinet@agniinc.com.np');
            TravellerEmpRec.GET("Traveler's ID");
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
                MESSAGE(Text0003)
            ELSE
                MESSAGE(Text016)

        END ELSE
            ERROR(Text0004);

    end;
}

