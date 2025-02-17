table 33020557 "Attendance Register"
{

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            TableRelation = "Attendance Journal Template";
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            TableRelation = "Attendance Journal Batch";
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(11; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(20; "Attendance From"; Date)
        {
            Editable = false;
        }
        field(21; "Attendance To"; Date)
        {
            Editable = false;
        }
        field(51; "Present Days"; Integer)
        {
            Editable = false;
        }
        field(52; "Absent Days"; Integer)
        {
            Editable = true;
        }
        field(53; "Paid Days"; Decimal)
        {
        }
        field(3000; "Attendance Month"; Option)
        {
            CalcFormula = Lookup("Eng-Nep Date"."Nepali Month" WHERE(English Date=FIELD(Attendance From)));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = ' ,Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra';
            OptionMembers = " ",Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        }
        field(3001;"Attendance Year";Integer)
        {
            CalcFormula = Lookup("Eng-Nep Date"."Nepali Year" WHERE (English Date=FIELD(Attendance From)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(3002;"Leave Earn";Boolean)
        {
        }
        field(3003;"Leave Earn Date";Date)
        {
        }
        field(5000;"Posting Date";Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(5001;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(5002;"Posting No. Series";Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(5003;"Source No.";Code[20])
        {
        }
        field(5004;"Total Holidays";Integer)
        {
            CalcFormula = Count("Attendance Ledger Entry" WHERE (Journal Template Name=FIELD(Journal Template Name),
                                                                 Journal Batch Name=FIELD(Journal Batch Name),
                                                                 No.=FIELD(No.),
                                                                 Journal Line No.=FIELD(Line No.),
                                                                 Employee No.=FIELD(Employee No.),
                                                                 Day Type=FILTER(Holiday)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.","Employee No.","Attendance From","Attendance To")
        {
            Clustered = true;
        }
        key(Key2;"Employee No.","Attendance From","Attendance To")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        AttLedgEntry.RESET;
        AttLedgEntry.SETRANGE("No.","No.");
        AttLedgEntry.SETRANGE("Journal Template Name","Journal Template Name");
        AttLedgEntry.SETRANGE("Journal Batch Name","Journal Batch Name");
        AttLedgEntry.SETRANGE("Journal Line No.","Line No.");
        AttLedgEntry.SETRANGE("Employee No.","Employee No.");
        IF AttLedgEntry.FINDSET THEN
          AttLedgEntry.DELETEALL;
    end;

    var
        AttLedgEntry: Record "33020556";
}

