table 33020423 "ODD/ Training/ Gatepass List"
{

    fields
    {
        field(1; "Entry No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Entry No." <> xRec."Entry No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."ODD/Training/Gatepass No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmpRec.RESET;
                EmpRec.SETRANGE("No.", "Employee Code");
                IF EmpRec.FINDFIRST THEN BEGIN
                    "Full Name" := EmpRec."Full Name";
                    "Job Title Code" := EmpRec."Job Title code";
                    "Job Title" := EmpRec."Job Title";
                    "Department Code" := EmpRec."Department Code";
                    Department := EmpRec."Department Name";
                    "Branch Code" := EmpRec."Branch Code";
                    Branch := EmpRec."Branch Name";
                    ManagerID := EmpRec."Manager ID";
                    "Work Shift Code" := EmpRec."Work Shift Code";
                END;

                WorkShiftRec.RESET;
                WorkShiftRec.SETRANGE(Code, "Work Shift Code");
                IF WorkShiftRec.FINDFIRST THEN BEGIN
                    "Start Time" := WorkShiftRec."In Time";
                    "End Time" := WorkShiftRec."Out Time";
                END;
            end;
        }
        field(3; "Full Name"; Text[90])
        {
        }
        field(4; "Job Title Code"; Code[20])
        {
        }
        field(5; "Job Title"; Text[80])
        {
        }
        field(6; "Department Code"; Code[50])
        {
        }
        field(7; Department; Text[80])
        {
        }
        field(8; "Branch Code"; Code[20])
        {
        }
        field(9; Branch; Text[80])
        {
        }
        field(10; "Request Date (AD)"; Date)
        {

            trigger OnValidate()
            begin
                "Request Date (BS)" := STPLSysMgmt.getNepaliDate("Request Date (AD)");
            end;
        }
        field(11; "Request Date (BS)"; Text[30])
        {
        }
        field(12; Type; Option)
        {
            Description = ' ,ODD,Training,Gatepass';
            OptionCaption = ' ,ODD,Training,Gatepass';
            OptionMembers = " ",ODD,Training,Gatepass;
        }
        field(13; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                "Time Required" := TotalDay();

                HRPermission.GET(USERID);
                IF NOT HRPermission."Admin Permission" THEN BEGIN
                    IF "Start Date" < TODAY THEN
                        ERROR('You do not have permission to post Start Date in Back Date');
                END;
            end;
        }
        field(14; "Start Time"; Time)
        {

            trigger OnValidate()
            begin
                WorkShiftRec.RESET;
                WorkShiftRec.SETRANGE(Code, "Work Shift Code");
                IF WorkShiftRec.FINDFIRST THEN BEGIN
                    InTime := WorkShiftRec."In Time";
                    OutTime := WorkShiftRec."Out Time";
                END;

                IF InTime > "Start Time" THEN
                    ERROR('You cannot request leave before your Shift');


                "Time Required" := TotalDay();
            end;
        }
        field(15; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                "Time Required" := TotalDay();
            end;
        }
        field(16; "End Time"; Time)
        {

            trigger OnValidate()
            begin
                WorkShiftRec.RESET;
                WorkShiftRec.SETRANGE(Code, "Work Shift Code");
                IF WorkShiftRec.FINDFIRST THEN BEGIN
                    InTime := WorkShiftRec."In Time";
                    OutTime := WorkShiftRec."Out Time";
                END;

                IF OutTime < "End Time" THEN
                    ERROR('You cannot request leave before your Shift');


                "Time Required" := TotalDay();
            end;
        }
        field(17; "Plan of Travel"; Text[50])
        {
        }
        field(18; Place; Text[30])
        {
        }
        field(19; "Time Required"; Decimal)
        {
        }
        field(20; Purpose; Text[50])
        {
        }
        field(21; "Mode of Travel"; Text[50])
        {
        }
        field(22; "Advance Amount"; Decimal)
        {
        }
        field(23; Posted; Boolean)
        {
        }
        field(24; "Posted By"; Code[50])
        {
            TableRelation = Table2000000002;
        }
        field(25; "Posted Date"; Date)
        {
        }
        field(26; Approve; Boolean)
        {
        }
        field(27; "Approved By"; Code[50])
        {
            TableRelation = Table2000000002;
        }
        field(28; "Approved Date"; Date)
        {
        }
        field(29; Disapprove; Boolean)
        {
        }
        field(30; "Rejected By"; Code[50])
        {
            TableRelation = Table2000000002;
        }
        field(31; "Rejected Date"; Date)
        {
        }
        field(32; "Pay Type"; Option)
        {
            Description = ' ,Half Paid,Paid,Unpaid';
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
        field(33; "No. Series"; Code[20])
        {
        }
        field(34; "Request UserID"; Code[50])
        {
        }
        field(35; "Request Time"; Time)
        {
        }
        field(36; ManagerID; Code[50])
        {
            TableRelation = Employee.No.;
        }
        field(37; Remarks; Text[80])
        {
        }
        field(38; "Gate Pass Reasons"; Option)
        {
            Description = ' ,Lunch,Marketing,Official,Personal';
            OptionCaption = ' ,Lunch,Marketing,Official,Personal,Others';
            OptionMembers = " ",Lunch,Marketing,Official,Personal,Others;

            trigger OnValidate()
            begin
                IF Type <> Type::Gatepass THEN
                    ERROR('This option is only for Gate Pass reasons');
            end;
        }
        field(39; "Work Shift Code"; Code[10])
        {
            TableRelation = "Work Shift Master".Code;
        }
        field(40; "Manager Name"; Text[30])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE(No.=FIELD(ManagerID)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Entry No." = '' THEN BEGIN
          HRSetup.GET;
          HRSetup.TESTFIELD("ODD/Training/Gatepass No.");
          NoSeriesMngt.InitSeries(HRSetup."ODD/Training/Gatepass No.",xRec."No. Series",0D,"Entry No.","No. Series");
        END;

        "Request Date (AD)" := TODAY;
        "Request Time" := TIME;
        "Request UserID" := USERID;
        "Start Date" := TODAY;
        "End Date" := TODAY;
        "Request Date (BS)" := STPLSysMgmt.getNepaliDate("Request Date (AD)");
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        OTGRec: Record "33020423";
        EmpRec: Record "5200";
        STPLSysMgmt: Codeunit "50000";
        HRPermission: Record "33020304";
        WorkShiftRec: Record "33020348";
        InTime: Time;
        OutTime: Time;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH OTGRec DO BEGIN
          OTGRec := Rec;
          HRSetup.GET;
          HRSetup.TESTFIELD(HRSetup."ODD/Training/Gatepass No.");
          IF NoSeriesMngt.SelectSeries(HRSetup."ODD/Training/Gatepass No.",xRec."No. Series","No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."ODD/Training/Gatepass No.");
            NoSeriesMngt.SetSeries("Entry No.");
            Rec := OTGRec;
            EXIT(TRUE);
          END;
        END;
    end;

    [Scope('Internal')]
    procedure TotalDay(): Decimal
    var
        Difference: Decimal;
        NoOfDays: Decimal;
        TimeNo: Decimal;
        TotalDays: Decimal;
    begin
        CLEAR(Difference);
        NoOfDays := "End Date" - "Start Date";
        Difference :=  "End Time" - "Start Time";
        IF (Difference = 28800000.0) OR ( Difference > 12600000.0) THEN BEGIN
            TimeNo := 1;
        END;
        IF (Difference = 12600000.0) OR (Difference < 12600000.0 ) THEN BEGIN
           TimeNo := 0.5;
        END;
        IF (Difference = 0.0)  THEN BEGIN
          TimeNo:= 0;
        END;
        EXIT(NoOfDays + TimeNo);
    end;
}

