table 25006700 "Special Inventory Equipment"
{
    Caption = 'Special Inventory Equipment';
    LookupPageID = 25006750;

    fields
    {
        field(10; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(30; Vendor; Text[100])
        {
            Caption = 'Vendor';
        }
        field(40; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(50; "Control Unit"; Integer)
        {
            Caption = 'Control Unit';
            TableRelation = Object.ID WHERE(Type = CONST(Codeunit));

            trigger OnValidate()
            var
                obj: Record "2000000001";
            begin
                obj.GET(obj.Type::Codeunit, '', "Control Unit");
                "Control Unit Name" := obj.Name
            end;
        }
        field(55; "Control Unit Name"; Text[30])
        {
            Caption = 'Control Unit Name';
            Editable = false;
        }
        field(60; "DSN Name"; Text[20])
        {
            Caption = 'DSN Name';
        }
        field(70; "Last Tran Date"; Date)
        {
            Caption = 'Last Tran Date';
        }
        field(80; "Last Tran Time"; Time)
        {
            Caption = 'Last Tran Time';
        }
        field(90; "Posting Unit"; Integer)
        {
            Caption = 'Posting Unit';
            TableRelation = Object.ID WHERE(Type = CONST(Codeunit));
        }
        field(100; "Mand.1 Field"; Integer)
        {
            Caption = 'Mandatory Field 1';
        }
        field(110; "Mand.2 Field"; Integer)
        {
            Caption = 'Mandatory Field 2';
        }
        field(120; "Mand.3 Field"; Integer)
        {
            Caption = 'Mandatory Field 3';
        }
        field(130; "Mand.4 Field"; Integer)
        {
            Caption = 'Mandatory Field 4';
        }
        field(140; "Mand.5 Field"; Integer)
        {
            Caption = 'Mandatory Field 5';
        }
        field(150; SystemCode; Option)
        {
            Caption = 'System Code';
            OptionCaption = ' ,SAMOA';
            OptionMembers = " ",SAMOA;
        }
        field(160; "Check 1"; Boolean)
        {
            Caption = 'Check 1';

            trigger OnValidate()
            var
                UserSetup: Record "91";
            begin
                IF "Check 1" <> xRec."Check 1" THEN BEGIN
                    UserSetup.GET(USERID);
                    IF NOT UserSetup."SIE management" THEN
                        ERROR(Text001)
                END
            end;
        }
        field(170; "Check 1 Show Reminder"; Option)
        {
            Caption = 'Show Reminder';
            OptionCaption = 'Never,Checked,Unchecked';
            OptionMembers = Never,Checked,Unchecked;
        }
        field(180; "Check 1 Reminder Msg"; Text[150])
        {
            Caption = 'Check 1 Reminder Message';
        }
        field(300; "Auto Asignment Unit"; Integer)
        {
            Caption = 'Auto Asignment Unit';
            TableRelation = Object.ID WHERE(Type = CONST(Codeunit));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'You have no rights to change this field.';
}

