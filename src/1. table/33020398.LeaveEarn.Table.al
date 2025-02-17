table 33020398 "Leave Earn"
{

    fields
    {
        field(1; "Entry No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Entry No." <> xRec."Entry No." THEN BEGIN
                    HRSetup.GET;
                    NoSeriesMgmt.TestManual(HRSetup."Leave Earn No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Entry Date"; Date)
        {

            trigger OnValidate()
            begin
                EngNepDate.SETRANGE(EngNepDate."English Date", "Entry Date");
                IF EngNepDate.FINDFIRST THEN BEGIN
                    NepaliDate := EngNepDate."Nepali Date";
                    Month := EngNepDate."Nepali Month";
                    "English Year" := EngNepDate."English Year";
                    "Nepali Year" := EngNepDate."Nepali Year";
                    MODIFY;
                END;
            end;
        }
        field(3; Month; Option)
        {
            OptionCaption = ' ,Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra';
            OptionMembers = " ",Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        }
        field(4; "Employee Code"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                Employee.SETRANGE(Employee."No.", "Employee Code");
                IF Employee.FINDFIRST THEN BEGIN
                    "Full Name" := Employee."Full Name";
                    "Emp. Designation" := Employee."Job Title";
                    Department := Employee."Department Code";
                    Branch := Employee."Branch Code";
                    Remarks := 'AUTO INSERTED';
                END;
            end;
        }
        field(5; "Full Name"; Text[90])
        {
        }
        field(6; "Emp. Designation"; Text[100])
        {
        }
        field(7; Department; Text[100])
        {
        }
        field(8; Branch; Text[50])
        {
        }
        field(9; "Leave Code"; Code[10])
        {
            TableRelation = "Leave Type"."Leave Type Code";

            trigger OnValidate()
            begin
                LeaveType.SETRANGE(LeaveType."Leave Type Code", "Leave Code");
                IF LeaveType.FINDFIRST THEN BEGIN
                    /*
                    IF LeaveType.Earnable = FALSE THEN BEGIN
                       ERROR(Text0001);
                    END;
                    */
                    "Leave Description" := LeaveType.Description;
                    "Earn Days" := LeaveType."Days Earned Per Year";
                    "Pay Type" := LeaveType."Pay Type";
                END;

            end;
        }
        field(10; "Leave Description"; Text[30])
        {
        }
        field(11; "Earn Days"; Decimal)
        {
        }
        field(12; Remarks; Text[50])
        {
            Editable = false;
        }
        field(13; "Posted Date"; Date)
        {
        }
        field(14; "Posted By"; Text[30])
        {
        }
        field(15; "No. Series"; Code[20])
        {
        }
        field(16; NepaliDate; Code[10])
        {

            trigger OnValidate()
            begin
                IF NepaliDate <> '' THEN BEGIN
                    "Entry Date" := SysMngt.getEngDate(NepaliDate);
                    MODIFY;
                END;
            end;
        }
        field(17; Posted; Boolean)
        {
        }
        field(18; "English Year"; Integer)
        {
        }
        field(19; "Nepali Year"; Integer)
        {
        }
        field(20; "Posted Time"; Time)
        {
        }
        field(21; "Work Shift Code"; Code[10])
        {
            TableRelation = "Work Shift Master".Code;
        }
        field(22; "Pay Type"; Option)
        {
            Description = ' ,Half Paid,Paid,Unpaid';
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
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
            HRSetup.TESTFIELD(HRSetup."Leave Earn No.");
            NoSeriesMgmt.InitSeries(HRSetup."Leave Earn No.", xRec."No. Series", 0D, "Entry No.", "No. Series");

            "Entry Date" := TODAY;

            EngNepDate.SETRANGE(EngNepDate."English Date", "Entry Date");
            IF EngNepDate.FINDFIRST THEN BEGIN
                NepaliDate := EngNepDate."Nepali Date";
                Month := EngNepDate."Nepali Month";
            END;

            UserSetup.GET(USERID);
            "Posted By" := UserSetup."User ID";
            "Posted Date" := TODAY;
            "Posted Time" := TIME;
        END;
    end;

    var
        HRSetup: Record "5218";
        NoSeriesMgmt: Codeunit "396";
        LeaveEarn: Record "33020398";
        Employee: Record "5200";
        LeaveType: Record "33020345";
        EngNepDate: Record "33020302";
        SysMngt: Codeunit "50000";
        UserSetup: Record "33020304";
        Text0001: Label 'Selected Leave Type is not Earnable!';
        LeaveAcc: Record "33020370";
        OnHandLeave: Decimal;
        Year: Integer;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        LeaveEarn := Rec;
        HRSetup.GET;
        HRSetup.TESTFIELD(HRSetup."Leave Earn No.");
        IF NoSeriesMgmt.SelectSeries(HRSetup."Leave Earn No.", xRec."No. Series", LeaveEarn."No. Series") THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD(HRSetup."Leave Earn No.");
            NoSeriesMgmt.SetSeries(LeaveEarn."Entry No.");
            Rec := LeaveEarn;
            EXIT(TRUE);
        END;
    end;
}

