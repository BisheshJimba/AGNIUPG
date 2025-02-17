table 33020554 "Attendance Journal Detail"
{
    DrillDownPageID = 33020557;

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
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
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

            trigger OnValidate()
            begin
                TESTFIELD("Entry Type");
                CASE "Entry Subtype" OF
                    "Entry Subtype"::"Half Paid":
                        VALIDATE(Days, 0.5);
                    "Entry Subtype"::Paid:
                        VALIDATE(Days, 1);
                    ELSE
                        VALIDATE(Days, 0);
                END;
            end;
        }
        field(51; Days; Decimal)
        {
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

            trigger OnValidate()
            begin
                IF "Adjustment Type" = "Adjustment Type"::Manual THEN BEGIN
                    TESTFIELD("Entry Type", "Entry Type"::Present);
                    PGSetup.GET;
                    IF PGSetup."MPPD (Minutes)" - "Presence Minutes" > 0 THEN
                        "Adjustment Minutes" := PGSetup."MPPD (Minutes)" - "Presence Minutes";
                END
                ELSE
                    IF "Adjustment Type" = "Adjustment Type"::System THEN
                        ERROR(Text000)
                    ELSE
                        "Adjustment Minutes" := 0;
                CheckModification;
            end;
        }
        field(57; "Adjustment Minutes"; Decimal)
        {
        }
        field(60; "Conflict Exists"; Boolean)
        {
        }
        field(70; "Conflict Description"; Text[250])
        {
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
        field(5005; "Employee Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Document No.", "Journal Line No.", "Attendance Date")
        {
            Clustered = true;
        }
        key(Key2; "Journal Template Name", "Journal Batch Name", "Document No.", "Journal Line No.", "Employee No.")
        {
            SumIndexFields = Days;
        }
    }

    fieldgroups
    {
    }

    var
        PGSetup: Record "33020507";
        Text000: Label 'You can enter Adjustment of type System.';

    [Scope('Internal')]
    procedure CheckModification()
    begin
        IF Rec."Adjustment Type" <> xRec."Adjustment Type" THEN BEGIN
            Correction := TRUE;
            "Corrected By" := USERID;
            "Conflict Exists" := FALSE;
        END;
    end;
}

