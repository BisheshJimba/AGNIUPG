table 33020797 "File Ledger Entry"
{
    Caption = 'File Ledger Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Service Invoice,Service Credit Memo,Gen Jnl,Cash Rcpt Jnl,Payment Jnl,Recurring Gnl Jnl,LC Jnl,Others,Loan';
            OptionMembers = " ","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Service Invoice","Service Credit Memo","Gen Jnl","Cash Rcpt Jnl","Payment Jnl","Recurring Gnl Jnl","LC Jnl",Others,Loan;
        }
        field(6; "Document No."; Code[20])
        {
        }
        field(7; "Resp Center / Jou Temp"; Code[10])
        {
        }
        field(8; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(12; "File No."; Code[20])
        {
            TableRelation = "File Detail"."File No.";
        }
        field(15; "Rack Location"; Code[20])
        {
            TableRelation = Location;
        }
        field(20; "Room No."; Code[10])
        {
            TableRelation = "Room - File Mgmt";
        }
        field(21; "Rack No."; Code[10])
        {
            TableRelation = "Rack - File Mgmt"."Rack Code";
        }
        field(22; "Sub Rack No."; Code[10])
        {
            TableRelation = "SubRack - File Mgmt"."Sub Rack Code";
        }
        field(23; "User ID"; Code[50])
        {
        }
        field(24; "Entry Type"; Option)
        {
            OptionCaption = 'Initial,Transfer,Manually Moved';
            OptionMembers = Initial,Transfer,"Manually Moved";
        }
        field(25; Open; Boolean)
        {
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(31; "G/L Posting Date"; Date)
        {
        }
        field(32; "Loan No."; Code[20])
        {
        }
        field(33; "Issued Date"; Date)
        {
        }
        field(34; "Expected Received Date"; Date)
        {
        }
        field(35; Reason; Text[250])
        {
        }
        field(36; "Received Date"; Date)
        {
        }
        field(37; "Responsible Person"; Code[50])
        {
            TableRelation = Employee;
        }
        field(38; "External Transfer"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "File No.", Open)
        {
        }
        key(Key3; "Rack Location", "Room No.", "Rack No.", "Sub Rack No.")
        {
        }
        key(Key4; "File No.", "Rack Location", "Room No.", "Rack No.", "Sub Rack No.")
        {
        }
        key(Key5; "Document Type", "File No.", "Document No.", Open)
        {
        }
        key(Key6; "Document Type", "Resp Center / Jou Temp", "File No.", "Document No.", Open)
        {
        }
    }

    fieldgroups
    {
    }
}

