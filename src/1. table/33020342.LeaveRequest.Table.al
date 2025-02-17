table 33020342 "Leave Request"
{

    fields
    {
        field(1; "Leave Request No."; Code[20])
        {
            NotBlank = false;

            trigger OnValidate()
            begin
                IF "Leave Request No." <> xRec."Leave Request No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Leave Request No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmployeeRec.RESET;
                EmployeeRec.SETRANGE("No.", "Employee No.");
                IF EmployeeRec.FIND('-') THEN BEGIN
                    "First Name" := EmployeeRec."First Name";
                    "Middle Name" := EmployeeRec."Middle Name";
                    "Last Name" := EmployeeRec."Last Name";
                    "Full Name" := EmployeeRec."Full Name";
                    "Work Shift Code" := EmployeeRec."Work Shift Code";
                    "Job Title Code" := EmployeeRec."Job Title code";
                    "Job Title" := EmployeeRec."Job Title";
                    "Manager ID" := EmployeeRec."Manager ID";
                    "Manager Name" := "Manager Name";
                    MODIFY;
                END;

                WorkShiftRec.RESET;
                WorkShiftRec.SETRANGE(Code, "Work Shift Code");
                IF WorkShiftRec.FINDFIRST THEN BEGIN
                    "Leave Start Time" := WorkShiftRec."In Time";
                    "Leave End Time" := WorkShiftRec."Out Time";
                END;
            end;
        }
        field(3; "First Name"; Text[30])
        {
        }
        field(4; "Middle Name"; Text[30])
        {
        }
        field(5; "Last Name"; Text[30])
        {
        }
        field(6; "Leave Type Code"; Code[20])
        {
            TableRelation = "Leave Type"."Leave Type Code";

            trigger OnValidate()
            begin
                CALCFIELDS("Leave Description");
                CALCFIELDS("Pay Type");
            end;
        }
        field(7; "Leave Description"; Text[100])
        {
            CalcFormula = Lookup("Leave Type".Description WHERE(Leave Type Code=FIELD(Leave Type Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Leave Start Date";Date)
        {

            trigger OnValidate()
            begin
                 HRPermission.GET(USERID);
                 IF NOT HRPermission."Leave Date Adjust" THEN BEGIN
                  IF "Leave Start Date" < TODAY THEN
                  ERROR('You do not have permission to post Start Date in Back Date');
                  END;

                  "Leave Start Date (BS)" := STPLSysMgmt.getNepaliDate("Leave Start Date")  ;
            end;
        }
        field(9;"Leave End Date";Date)
        {

            trigger OnValidate()
            begin
                    /*    "Add. Leave End Date" := STPLSysMgmt.getNepaliDate("Leave End Date");
                         TotalReqLeave := "Leave End Date" - "Leave Start Date";
                
                         IF ("Leave End Date"<"Leave Start Date" ) THEN
                            ERROR(Text001)
                
                         ELSE BEGIN
                
                           LeaveType.RESET;
                           LeaveType.SETRANGE("Leave Type Code","Leave Type Code");
                           IF LeaveType.FIND('-') THEN BEGIN
                              Month := DATE2DMY("Leave End Date",2);
                              Year := DATE2DMY("Leave End Date",3);
                              "Earned Days" := CalcEarnDays.CalculateEarnDays(Month,Year,"Employee No.","Leave Type Code") ;
                
                              IF ("Earned Days"<TotalReqLeave) THEN
                                ERROR(Text002);
                
                              //IF (TotalReqLeave>LeaveType."Maximum Allowable Limit") THEN
                                //ERROR(Text003);
                
                            END
                          END;
                          IF (LeaveType."Leave Type Code" = 'SICK(HALF PAID)' ) THEN BEGIN
                            IF (TotalReqLeave>LeaveType."Maximum Allowable Limit") THEN
                                ERROR(Text002);
                
                          END;
                
                
                 GetFiscalYear.SETRANGE("English Date","Leave Start Date");
                 IF GetFiscalYear.FIND('-') THEN BEGIN
                     "Fiscal Year" := GetFiscalYear."Nepali Year";
                 END;
                     */
                 ///ConsumeDays := "Leave End Date" - "Leave Start Date";
                 //"No of days" := ConsumeDays ;

            end;
        }
        field(10;"Leave Start Time";Time)
        {

            trigger OnValidate()
            begin
                WorkShiftRec.RESET;
                WorkShiftRec.SETRANGE(Code,"Work Shift Code");
                IF WorkShiftRec.FINDFIRST THEN BEGIN
                  Intime := WorkShiftRec."In Time";
                  OutTime := WorkShiftRec."Out Time";
                END;

                IF Intime > "Leave Start Time" THEN
                ERROR('You cannot request leave before your Shift');
            end;
        }
        field(11;"Leave End Time";Time)
        {

            trigger OnValidate()
            begin
                WorkShiftRec.RESET;
                WorkShiftRec.SETRANGE(Code,"Work Shift Code");
                IF WorkShiftRec.FINDFIRST THEN BEGIN
                  Intime := WorkShiftRec."In Time";
                  OutTime := WorkShiftRec."Out Time";
                END;

                IF OutTime < "Leave End Time" THEN
                ERROR('You cannot request leave after your Shift');
            end;
        }
        field(12;Remarks;Text[250])
        {
        }
        field(13;"No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14;"Work Shift Code";Code[10])
        {
            TableRelation = "Work Shift Master".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Work Shift Description");
            end;
        }
        field(15;"Request Date";Date)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Requeste Date (BS)" := stpl.getNepaliDate("Request Date");
            end;
        }
        field(16;"Request Time";Time)
        {
            Editable = false;
        }
        field(17;"User ID";Text[30])
        {
        }
        field(18;"Work Shift Description";Text[100])
        {
            CalcFormula = Lookup("Work Shift Master".Description WHERE (Code=FIELD(Work Shift Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Job Title Code";Code[20])
        {
            TableRelation = "Job Title".Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Job Title");
            end;
        }
        field(20;"Job Title";Text[100])
        {
            CalcFormula = Lookup("Job Title".Description WHERE (Code=FIELD(Job Title Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"Manager ID";Code[20])
        {
        }
        field(22;"Leave Start Date (BS)";Code[20])
        {
        }
        field(23;"Leave End Date (BS)";Code[20])
        {
        }
        field(24;"Fiscal Year";Code[10])
        {
        }
        field(25;CheckList;Boolean)
        {
        }
        field(26;"No of days";Decimal)
        {
        }
        field(27;"Full Name";Text[100])
        {
        }
        field(28;"Pay Type";Option)
        {
            CalcFormula = Lookup("Leave Type"."Pay Type" WHERE (Leave Type Code=FIELD(Leave Type Code)));
            Description = ' ,Half Paid,Paid,Unpaid';
            FieldClass = FlowField;
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
        field(29;"Requeste Date (BS)";Text[30])
        {
        }
        field(30;"Enchase Days";Decimal)
        {
        }
        field(31;"Writeoff Days";Decimal)
        {
        }
        field(32;"Leave Type";Option)
        {
            OptionMembers = " ","First Half Leave","Second Half Leave","Full Day Leave";

            trigger OnValidate()
            begin
                IF "Leave Type" = "Leave Type":: "First Half Leave" THEN BEGIN
                 WorkShiftRec.RESET;
                 WorkShiftRec.SETRANGE(Code,"Work Shift Code");
                 WorkShiftRec.FINDFIRST;
                 "Leave Start Time" := WorkShiftRec."In Time";
                 "Leave End Time" := WorkShiftRec."Lunch Start";
                END;
                IF "Leave Type" = "Leave Type":: "Second Half Leave" THEN BEGIN
                 WorkShiftRec.RESET;
                 WorkShiftRec.SETRANGE(Code,"Work Shift Code");
                 WorkShiftRec.FINDFIRST;
                 "Leave Start Time" := WorkShiftRec."Lunch Start";
                 "Leave End Time" := WorkShiftRec."Out Time";
                END;
                IF "Leave Type" = "Leave Type":: "Full Day Leave" THEN BEGIN
                 WorkShiftRec.RESET;
                 WorkShiftRec.SETRANGE(Code,"Work Shift Code");
                 WorkShiftRec.FINDFIRST;
                 "Leave Start Time" := WorkShiftRec."In Time";
                 "Leave End Time" := WorkShiftRec."Out Time";
                END;
            end;
        }
        field(33;"Manager Name";Text[100])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Leave Request No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Leave Request No." = '' THEN BEGIN
          HRSetup.GET;
          HRSetup.TESTFIELD("Leave Request No.");
          NoSeriesMngt.InitSeries(HRSetup."Leave Request No.",xRec."No. Series",0D,"Leave Request No.","No. Series");
        END;

        "Request Date" := TODAY;
        "Request Time" := TIME;
        "User ID" := USERID;
        "Leave Start Date" := TODAY;
        "Leave End Date" := TODAY;
        //"Leave Start Time" := 093000T;
        //"Leave End Time" := 173000T;
        "Leave Start Date (BS)" := stpl.getNepaliDate("Leave Start Date");
        "Leave End Date (BS)" := stpl.getNepaliDate("Leave End Date");
    end;

    var
        NoSeriesMngt: Codeunit "396";
        HRSetup: Record "5218";
        LeaveRequest: Record "33020342";
        EmployeeRec: Record "5200";
        TotalReqLeave: Decimal;
        Text001: Label 'End Date can''t be less than Start Date';
        LeaveType: Record "33020345";
        Month: Integer;
        Year: Integer;
        "Earned Days": Decimal;
        Text002: Label 'Leave Requests exceed the Earned Days';
        Text003: Label 'Leave Requests exceed the Maximum Allowable Leave Days';
        STPLSysMgmt: Codeunit "50000";
        GetFiscalYear: Record "33020302";
        CalcEarnDays: Codeunit "33020301";
        ConsumeDays: Decimal;
        stpl: Codeunit "50000";
        HRPermission: Record "33020304";
        WorkShiftRec: Record "33020348";
        Intime: Time;
        OutTime: Time;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH LeaveRequest DO BEGIN
          LeaveRequest := Rec;
          HRSetup.GET;
          HRSetup.TESTFIELD("Leave Request No.");
          IF NoSeriesMngt.SelectSeries(HRSetup."Leave Request No.",xRec."No. Series","No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Leave Request No.");
            NoSeriesMngt.SetSeries("Leave Request No.");
            Rec := LeaveRequest;
            EXIT(TRUE);
          END;
        END;
    end;
}

