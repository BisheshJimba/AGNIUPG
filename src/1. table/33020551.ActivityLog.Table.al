table 33020551 "Activity Log"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(20; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(21; "Employee Name"; Text[50])
        {
        }
        field(30; "Start Date"; Date)
        {
        }
        field(40; "Start Time"; Time)
        {
        }
        field(50; "End Date"; Date)
        {
        }
        field(60; "End Time"; Time)
        {
        }
        field(90; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(100; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(200; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(300; Type; Option)
        {
            Description = ' ,Leave,Outdoor Duty,Training,Compensated Holiday,Gatepass,Travel';
            OptionCaption = ' ,Leave,Outdoor Duty,Training,Compensated Holiday,Gatepass,Travel';
            OptionMembers = " ",Leave,"Outdoor Duty",Training,"Compensated Holiday",Gatepass,Travel;
        }
        field(301; Subtype; Option)
        {
            Description = ' ,Half Paid,Paid,Unpaid';
            OptionCaption = ' ,Half Paid,Paid,Unpaid';
            OptionMembers = " ","Half Paid",Paid,Unpaid;
        }
        field(302; "Consumed Days"; Decimal)
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(500; Correction; Boolean)
        {
        }
        field(501; "Corrected By"; Code[50])
        {
            TableRelation = Employee;
        }
        field(502; "Correction Reason"; Text[200])
        {
        }
        field(503; Processed; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Start Date", Type, "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Start Date", "End Date", Type)
        {
        }
    }

    fieldgroups
    {
    }
}

