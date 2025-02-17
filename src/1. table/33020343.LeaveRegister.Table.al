table 33020343 "Leave Register"
{

    fields
    {
        field(1; "Entry No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Entry No." <> xRec."Entry No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMngt.TestManual(HRSetup."Leave Register");
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
                    Branch := EmployeeRec."Branch Code";
                    Department := EmployeeRec."Department Code";
                    "Full Name" := EmployeeRec."Full Name";
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
        field(6; "Work Shift Code"; Code[10])
        {
            TableRelation = "Work Shift Master".Code;
        }
        field(7; "Leave Type Code"; Code[20])
        {
            TableRelation = "Leave Type"."Leave Type Code";

            trigger OnValidate()
            begin
                CALCFIELDS("Leave Description");
            end;
        }
        field(8; "Leave Start Date"; Date)
        {
        }
        field(9; "Leave End Date"; Date)
        {
        }
        field(10; "Posting Date"; Date)
        {
        }
        field(11; "Posting Time"; Time)
        {
        }
        field(12; "Employee Location Code"; Code[20])
        {
            Enabled = false;
        }
        field(13; "Leave Start Time"; Time)
        {
        }
        field(14; "Leave End Time"; Time)
        {
        }
        field(16; "Leave Description"; Text[200])
        {
            CalcFormula = Lookup("Leave Type".Description WHERE(Leave Type Code=FIELD(Leave Type Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;Remarks;Text[250])
        {
        }
        field(18;Approved;Boolean)
        {
        }
        field(19;"Approved By";Text[50])
        {
        }
        field(20;"Approved Date";Date)
        {
        }
        field(21;"Approval Comment";Text[250])
        {
        }
        field(22;"Used Days";Decimal)
        {

            trigger OnValidate()
            begin
                /*"Used Days" := "Leave End Date" - "Leave Start Date";*/

            end;
        }
        field(23;"Manager ID";Code[50])
        {
        }
        field(24;Reject;Boolean)
        {
        }
        field(25;"Rejected By";Text[50])
        {
        }
        field(26;"Reject Date";Date)
        {
        }
        field(27;"Rejection Comment";Text[250])
        {
        }
        field(28;Disapproved;Boolean)
        {
        }
        field(29;"Fiscal Year";Code[10])
        {
        }
        field(30;Branch;Code[20])
        {
        }
        field(31;Department;Code[20])
        {
            TableRelation = "Location Master".Code WHERE (Type=CONST(Department));
        }
        field(32;"Balance Days";Decimal)
        {
        }
        field(33;"Earn Days";Decimal)
        {
        }
        field(34;"Request Date";Date)
        {
        }
        field(35;"Request Time";Time)
        {
        }
        field(36;"No. Series";Code[20])
        {
        }
        field(37;Type;Option)
        {
            Description = ' ,Leave,Outdoor Duty,Training,Compensated Holiday,Gatepass,Travel';
            OptionCaption = ' ,Leave,Outdoor Duty,Training,Compensated Holiday,Gatepass,Travel';
            OptionMembers = " ",Leave,"Outdoor Duty",Training,"Compensated Holiday",Gatepass,Travel;
        }
        field(38;"Pay Type";Option)
        {
            Description = ' ,Half Paid,Paid,Unpaid';
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
        field(39;"Full Name";Text[90])
        {
        }
        field(40;"Requeste Date (BS)";Text[30])
        {
        }
        field(41;"Job Title Code";Code[20])
        {
        }
        field(42;"Job Title";Text[80])
        {
        }
        field(44;"Enchase Days";Decimal)
        {
        }
        field(45;"Write-off Days";Decimal)
        {
        }
        field(46;"Nepali Year";Integer)
        {
        }
        field(47;"Nepali Month";Option)
        {
            Description = ' ,Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra';
            OptionCaption = ' ,Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra';
            OptionMembers = " ",Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        }
        field(48;"External No";Code[20])
        {
            Description = 'ODD, Gatepass, Travel entry no.';
        }
        field(49;"Total Writeoff Days (New)";Decimal)
        {
            Description = 'Added for new scheme of leave';
        }
        field(33020550;DateFilter;Date)
        {
            FieldClass = FlowFilter;
        }
        field(33020551;"Activity Processed";Boolean)
        {
        }
        field(33020552;"Global Dimension 1 Filter";Code[100])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(33020553;"Global Dimension 2 Filter";Code[100])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(33020554;"Temp. Earn Days";Decimal)
        {
            Description = 'temporaary to be deleted afterwards';
        }
        field(33020555;"Temp. Earn Days 2";Decimal)
        {
            Description = 'temporaary to be deleted afterwards';
        }
    }

    keys
    {
        key(Key1;"Entry No.","Employee No.","Leave Type Code")
        {
            Clustered = true;
        }
        key(Key2;"Employee No.")
        {
        }
        key(Key3;"Employee No.","Leave Type Code","Leave Start Date")
        {
            SumIndexFields = "Used Days";
        }
        key(Key4;"Employee No.","Fiscal Year","Leave Type Code")
        {
            SumIndexFields = "Used Days";
        }
        key(Key5;"Leave Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Entry No." = '' THEN BEGIN
          HRSetup.GET;
          HRSetup.TESTFIELD("Leave Register");
          NoSeriesMngt.InitSeries(HRSetup."Leave Register",xRec."No. Series",0D,"Entry No.","No. Series");
        END;
    end;

    var
        EmployeeRec: Record "5200";
        LeaveRegister: Record "33020343";
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        WITH LeaveRegister DO BEGIN
          LeaveRegister := Rec;
          HRSetup.GET;
          HRSetup.TESTFIELD("Leave Request No.");
          IF NoSeriesMngt.SelectSeries(HRSetup."Leave Request No.",xRec."No. Series","No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Leave Request No.");
            NoSeriesMngt.SetSeries("Entry No.");
            Rec := LeaveRegister;
            EXIT(TRUE);
          END;
        END;
    end;
}

