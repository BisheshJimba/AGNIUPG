table 33019971 "Cheque Entry"
{
    // Name        Version         Date        Description
    // ***********************************************************
    //             CTS6.1.2        24-09-12    Table Courier Tracking Header
    // Ravi        CNY1.0          24-09-12    Previous table "Courier Tracking Header" has been changed to "Check Entry"

    Caption = 'Cheque Entry';
    Permissions = TableData 33019971 = rimd;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(5; "Cheque No."; Code[30])
        {
            Editable = false;
        }
        field(6; "Cheque Date"; Date)
        {
        }
        field(9; "Bank No."; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(10; "Bank Name"; Text[50])
        {
        }
        field(11; "Document No."; Code[20])
        {
        }
        field(12; "Created Date"; Date)
        {
        }
        field(14; "Document Class"; Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";
        }
        field(15; "Payee Name"; Code[50])
        {
            Editable = false;
        }
        field(16; "Cheque Type"; Option)
        {
            OptionCaption = ' ,A/C Payee,& Co.,Bearer ';
            OptionMembers = " ","A/C Payee","& Co.","Bearer ";
        }
        field(17; "Cheque Amount"; Decimal)
        {
        }
        field(18; "Signatory (Group A)"; Text[30])
        {
        }
        field(19; "Signatory (Group B)"; Text[30])
        {
        }
        field(25; Assigned; Boolean)
        {
            CalcFormula = Exist("Gen. Journal Line" WHERE(Account Type=CONST(Bank Account),
                                                           Account No.=FIELD(Bank No.),
                                                           Cheque No.=FIELD(Cheque No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26;Posted;Boolean)
        {
            Editable = true;
        }
        field(27;Void;Boolean)
        {
            Editable = false;
        }
        field(28;"Void Description";Text[50])
        {
        }
        field(30;"Bundle No.";Code[20])
        {
        }
        field(33;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(34;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Cheque No.")
        {
        }
        key(Key3;"Bank No.",Posted,Void)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Text33019961: Label 'You cannot delete released document. Please contact your system administrator or change status to open.';
    begin
    end;

    trigger OnModify()
    var
        Text33019962: Label 'You cannot modify released document. Please contact your system administrator or change status to open.';
    begin
    end;

    trigger OnRename()
    var
        Text33019963: Label 'You cannot modify released document. Please contact your system administrator or change status to open.';
    begin
    end;
}

