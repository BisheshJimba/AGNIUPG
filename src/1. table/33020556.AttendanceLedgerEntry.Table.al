table 33020556 "Attendance Ledger Entry"
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
        field(3; "Journal Line No."; Integer)
        {
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
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
        field(11; "Attendance Date"; Date)
        {
            Editable = false;
        }
        field(20; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(30; "Day Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Working,Holiday';
            OptionMembers = " ",Working,Holiday;
        }
        field(40; "Entry Type"; Option)
        {
            OptionCaption = ' ,Present,Absent,Outdoor Duty,Training,Compensated Holiday';
            OptionMembers = " ",Present,Absent,"Outdoor Duty",Training,"Compensated Holiday";
        }
        field(50; "Entry Subtype"; Option)
        {
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
        field(51; Days; Decimal)
        {
            Description = '+ve means Present Qty. & -ve means Absent Qty.';
            Editable = false;
        }
        field(52; "Login frequency"; Integer)
        {
        }
        field(53; "Logout frequency"; Integer)
        {
        }
        field(54; "Presence Minutes"; Decimal)
        {
        }
        field(55; "Absense Minutes"; Decimal)
        {
        }
        field(56; "Adjustment Type"; Option)
        {
            OptionCaption = ' ,Manual,System';
            OptionMembers = " ",Manual,System;
        }
        field(57; "Adjustment Minutes"; Decimal)
        {
        }
        field(60; "Conflict Exists"; Boolean)
        {
            Editable = true;
        }
        field(70; "Conflict Description"; Text[250])
        {
            Editable = false;
        }
        field(500; Correction; Boolean)
        {
        }
        field(501; "Corrected By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(502; "Correction Reason"; Text[200])
        {
        }
        field(5000; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ClosingDates = true;
        }
        field(5004; "System Remarks"; Text[250])
        {
        }
        field(5005; "Source No."; Code[100])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Employee No.", "Attendance Date")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Attendance Date")
        {
        }
    }

    fieldgroups
    {
    }
}

