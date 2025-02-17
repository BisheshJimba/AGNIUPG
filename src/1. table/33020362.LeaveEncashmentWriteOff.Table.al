table 33020362 "Leave Encashment/ WriteOff"
{

    fields
    {
        field(1; "Entry No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Entry No." <> xRec."Entry No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Leave Encash/ WriteOff No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Requested Date (AD)"; Date)
        {

            trigger OnValidate()
            begin
                "Requested Date (BS)" := STPL.getNepaliDate("Requested Date (AD)");
            end;
        }
        field(3; "Requested Date (BS)"; Text[15])
        {
        }
        field(4; Type; Option)
        {
            Description = ' ,Encash,WriteOff';
            OptionCaption = ' ,Encash,WriteOff';
            OptionMembers = " ",Encash,WriteOff;
        }
        field(5; "Requested Time"; Time)
        {
        }
        field(6; "Requested UserID"; Code[20])
        {
        }
        field(10; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                Emprec.SETRANGE(Emprec."No.", "Employee Code");
                IF (Emprec.FIND('-')) THEN BEGIN
                    "Employee Name" := Emprec."Full Name";
                    Designation := Emprec."Job Title";
                    Department := Emprec."Department Name";
                    Branch := Emprec."Branch Code";

                END;
            end;
        }
        field(11; "Employee Name"; Text[90])
        {
            TableRelation = Employee."Full Name" WHERE(No.=FIELD(Employee Code));
        }
        field(12;Designation;Text[100])
        {
        }
        field(13;Department;Text[100])
        {
            TableRelation = Employee."Exam Department Code" WHERE (No.=FIELD(Employee Code));
        }
        field(14;Branch;Code[100])
        {
            TableRelation = Employee."Branch Code" WHERE (No.=FIELD(Employee Code));
        }
        field(15;"Leave Type";Code[20])
        {
            TableRelation = "Leave Type"."Leave Type Code";
        }
        field(16;Remarks;Text[250])
        {
        }
        field(17;"Leave Description";Text[100])
        {
            CalcFormula = Lookup("Leave Type".Description WHERE (Leave Type Code=FIELD(Leave Type)));
            FieldClass = FlowField;
        }
        field(35;"On Hand Days";Decimal)
        {
        }
        field(40;"Consumed Days";Decimal)
        {
        }
        field(73;"No. Series";Code[20])
        {
        }
        field(74;Posted;Boolean)
        {
        }
        field(75;"Posted Date";Date)
        {
        }
        field(76;"Posted By";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"Employee Code","Leave Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        HRSetup.GET;
        IF "Entry No." = '' THEN BEGIN
          HRSetup.TESTFIELD(HRSetup."Leave Encash/ WriteOff No.");
          NoSeriesMngt.InitSeries(HRSetup."Leave Encash/ WriteOff No.",xRec."No. Series",0D,"Entry No.","No. Series");
        END;
        "Requested Date (AD)" := TODAY;
        "Requested Time" := TIME;
        "Requested Date (BS)" := STPL.getNepaliDate("Requested Date (AD)");
        "Requested UserID" := USERID;
    end;

    var
        Emprec: Record "5200";
        LeaveEncashRec: Record "33020362";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        STPL: Codeunit "50000";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH LeaveEncashRec DO BEGIN
          LeaveEncashRec := Rec;
          HRSetup.GET;
          HRSetup.TESTFIELD(HRSetup."Leave Encash/ WriteOff No.");
          IF NoSeriesMngt.SelectSeries(HRSetup."Leave Encash/ WriteOff No.",xRec."No. Series","No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Leave Encash/ WriteOff No.");
            NoSeriesMngt.SetSeries("Entry No.");
            Rec := LeaveEncashRec;
            EXIT(TRUE);
          END;
        END;
    end;
}

