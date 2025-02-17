table 33020379 "Emp Requisition Form"
{

    fields
    {
        field(1; EmpReqNo; Code[20])
        {

            trigger OnValidate()
            begin
                IF EmpReqNo <> xRec.EmpReqNo THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Employee Req. No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Department Code"; Code[10])
        {
            TableRelation = "Location Master".Code;

            trigger OnValidate()
            var
                Emp: Record "5200";
            begin
                Department.SETRANGE(Code, "Department Code");
                IF Department.FIND('-') THEN BEGIN
                    "Department Name" := Department.Description;
                END;

                Emp.RESET;
                Emp.SETRANGE("User ID", USERID);
                IF Emp.FINDFIRST THEN BEGIN
                    IF Emp."Department Code" <> "Department Code" THEN
                        ERROR('You can fill employee requisation for your department only.');
                END;
            end;
        }
        field(3; "Department Name"; Text[50])
        {
        }
        field(4; "Position Code"; Code[20])
        {
            TableRelation = "Job Title".Code;

            trigger OnValidate()
            begin
                Jobtitle.SETRANGE(Jobtitle.Code, "Position Code");
                IF Jobtitle.FIND('-') THEN BEGIN
                    "Position Name" := Jobtitle.Description;
                END;
            end;
        }
        field(5; "Position Name"; Text[80])
        {
        }
        field(6; "No. of Position"; Integer)
        {

            trigger OnValidate()
            begin
                /*
                //sm to split fiscal year
                Position := STRPOS("Fiscal Year",'/');
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
                ManPowerBudEntry.SETRANGE(ManPowerBudEntry.Position,"Position Grade");
                IF ManPowerBudEntry.FINDFIRST THEN BEGIN
                    CurPosition := ManPowerBudEntry."No. of Person";
                END;
                
                //sm to calculate previous no of position
                ManPowerBudEntry.RESET;
                ManPowerBudEntry.SETRANGE(ManPowerBudEntry."Department Code","Department Code");
                ManPowerBudEntry.SETRANGE(ManPowerBudEntry.Position,"Position Grade");
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
                */
                /*
                EmpReq.SETRANGE(EmpReq.EmpReqNo,EmpReqNo);
                IF EmpReq.FINDFIRST THEN BEGIN
                   EmpReq."No. of Position" := "No. of Position";
                   EmpReq."Budget Verification" := "Budget Verification";
                   EmpReq.MODIFY;
                END;
                */




                /*
                ManPowerBudEntry.SETRANGE(ManPowerBudEntry."Fiscal Year","Fiscal Year");
                ManPowerBudEntry.SETRANGE(ManPowerBudEntry."Department Code","Department Code");
                ManPowerBudEntry.SETRANGE(ManPowerBudEntry.Position,"Position Grade");
                IF ManPowerBudEntry.FINDFIRST THEN BEGIN
                   IF "No. of Position" < ManPowerBudEntry."No. of Person" THEN
                       "Budget Verification" := "Budget Verification"::"Within Budget"
                   ELSE IF "No. of Position" > ManPowerBudEntry."No. of Person" THEN
                       "Budget Verification" := "Budget Verification"::"Exceeds Budget";
                
                END;
                
                */

            end;
        }
        field(7; "Job Description"; Option)
        {
            OptionMembers = Accurate,"Not Accurate","Needs to be created";
        }
        field(8; "Reason for Requirement"; Option)
        {
            OptionMembers = Replacement,"New Position";
        }
        field(9; "Remarks on Reason"; Text[150])
        {
        }
        field(10; "Posted By"; Text[80])
        {
        }
        field(11; "Posted Date"; Date)
        {
        }
        field(12; "Budget Verification"; Option)
        {
            OptionMembers = "Within Budget","Exceeds Budget","No Budget";
        }
        field(13; "Remark by HR"; Text[150])
        {
        }
        field(14; "Checked By"; Text[80])
        {
        }
        field(15; "Checked Date"; Date)
        {
        }
        field(16; Status; Option)
        {
            OptionCaption = ' ,Approved,Not Approved,On Hold,Resubmit';
            OptionMembers = " ",Approved,"Not Approved","On Hold",Resubmit;

            trigger OnValidate()
            begin
                EmpReq.SETRANGE(EmpReq.EmpReqNo, EmpReqNo);
                IF EmpReq.FINDFIRST THEN BEGIN
                    "Checked By" := USERID;
                    "Checked Date" := TODAY;
                    Status := Status;
                    IF Status = Status::Approved THEN BEGIN
                        "Approved Date" := TODAY;
                    END ELSE BEGIN
                        "Approved Date" := 0D;
                        "Minute No" := '';
                    END;



                    MODIFY;

                END;
            end;
        }
        field(17; "Approved Date"; Date)
        {
        }
        field(18; "Minute No"; Code[20])
        {
        }
        field(19; "Remarks on Approval"; Text[150])
        {
        }
        field(20; Posted; Boolean)
        {
        }
        field(21; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(22; "Position Band"; Text[30])
        {
            TableRelation = "Variable Field Setup"."Field Name";
        }
        field(23; "Fiscal Year"; Code[10])
        {

            trigger OnLookup()
            var
                ENg: Record "50";
                AccPage: Page "100";
            begin
                ENg.RESET;
                IF PAGE.RUNMODAL(100, ENg) = ACTION::LookupOK THEN BEGIN
                    "Fiscal Year" := ENg."Nepali Fiscal Year";
                END;
            end;
        }
        field(24; "Supervisor Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Supervisor Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "Supervisor Name" := EmpRec."Full Name";
                END;
            end;
        }
        field(25; "Supervisor Name"; Text[150])
        {
        }
        field(26; Branch; Text[80])
        {
            TableRelation = Location;
        }
        field(27; Segment; Text[80])
        {
        }
        field(28; "Date Required"; Date)
        {
        }
        field(29; "Resubmit (Weeks)"; Integer)
        {
        }
        field(30; "Document Created By"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; EmpReqNo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        AccP: Record "50";
    begin
        IF EmpReqNo = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Employee Req. No.");
            NoSeriesMngt.InitSeries(HRSetup."Employee Req. No.", xRec."No. Series", 0D, EmpReqNo, "No. Series");
        END;

        //"Posted By" := USERID;
        "Document Created By" := USERID;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        EmpReq: Record "33020379";
        UserSetup: Record "91";
        Department: Record "33020337";
        Jobtitle: Record "33020325";
        ManPowerBudEntry: Record "33020378";
        Position: Integer;
        NewString: Code[10];
        NewString1: Code[10];
        CurPosition: Integer;
        PrevPosition: Integer;
        TotalPosition: Integer;
        VarInteger: Integer;
        VarInteger1: Integer;
        YInteger: Integer;
        YInteger1: Integer;
        Ecode: Code[10];
        Ecode1: Code[10];
        EmpRec: Record "5200";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        EmpReq := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Employee Req. No.");
        IF NoSeriesMngt.SelectSeries(HRSetup."Employee Req. No.", xRec."No. Series", EmpReq."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Employee Req. No.");
            NoSeriesMngt.SetSeries(EmpReq.EmpReqNo);
            Rec := EmpReq;
            EXIT(TRUE);
        END;
    end;
}

