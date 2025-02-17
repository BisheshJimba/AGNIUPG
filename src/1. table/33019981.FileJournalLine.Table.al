table 33019981 "File Journal Line"
{
    Caption = 'File Journal Line';

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
            OptionCaption = ' ,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Service Invoice,Service Credit Memo,Gen Jnl,Cash Rcpt Jnl,Payment Jnl,Recurring Gnl Jnl,LC Jnl,Others';
            OptionMembers = " ","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Service Invoice","Service Credit Memo","Gen Jnl","Cash Rcpt Jnl","Payment Jnl","Recurring Gnl Jnl","LC Jnl",Others;

            trigger OnValidate()
            begin
                "File No." := '';
                "Document No." := '';
            end;
        }
        field(6; "File No."; Code[20])
        {
            TableRelation = "QR Specification".Field12 WHERE(Line No.=FIELD(Document Type));

            trigger OnValidate()
            begin
                // CNY.CRM >>
                /*FileDetails_G.RESET;
                FileDetails_G.SETRANGE("Line No.","Document Type");
                FileDetails_G.SETRANGE("File No.","File No.");
                IF FileDetails_G.FINDFIRST THEN
                  "Resp Center / Jou Temp" := FileDetails_G."Resp Center / Jou Temp";
                // CNY.CRM <<
                */

            end;
        }
        field(7;"Document No.";Code[20])
        {
        }
        field(8;"Location Code";Code[20])
        {
            TableRelation = Location;
        }
        field(9;"Resp Center / Jou Temp";Code[10])
        {
        }
        field(15;"Rack Location";Code[20])
        {
            TableRelation = Location;
        }
        field(20;"Room No.";Code[10])
        {
            TableRelation = "Mobile App Integration Service"."Integration Type" WHERE (Field5=FIELD(Rack Location));
        }
        field(21;"Rack No.";Code[10])
        {
            TableRelation = "QR Details"."Line No." WHERE (Field8=FIELD(Rack Location),
                                                           Type=FIELD(Room No.));
        }
        field(22;"Sub Rack No.";Code[10])
        {
            TableRelation = "Pending Documents".Field5 WHERE (Field9=FIELD(Rack Location),
                                                              Pending Transfers=FIELD(Room No.),
                                                              Pending Sales=FIELD(Rack No.));
        }
        field(23;"User ID";Code[50])
        {
        }
        field(24;"Entry Type";Option)
        {
            OptionCaption = 'Initial,Transfer,Manually Moved';
            OptionMembers = Initial,Transfer,"Manually Moved";
        }
        field(29;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(30;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
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
    }

    fieldgroups
    {
    }

    var
        FileDetails_G: Record "33019974";
}

