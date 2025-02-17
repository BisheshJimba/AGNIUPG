table 33020796 "File transfer"
{
    Caption = 'File transfer';

    fields
    {
        field(5; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Sales Invoice,Sales Return Receipt,Sales Credit Memo,Purchase Invoice,Purchase Return Shipment,Purchase Credit Memo,Service Invoice,Service Credit Memo,Gen Jnl,Cash Rcpt Jnl,Payment Jnl,Recurring Gnl Jnl,LC Jnl,Others,Loan';
            OptionMembers = " ","Sales Invoice","Sales Return Receipt","Sales Credit Memo","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo","Service Invoice","Service Credit Memo","Gen Jnl","Cash Rcpt Jnl","Payment Jnl","Recurring Gnl Jnl","LC Jnl",Others,Loan;
        }
        field(6; "File No."; Code[20])
        {
            TableRelation = IF (Document Type=FILTER(<>Loan)) "File Detail"."File No." WHERE (Document Type=FIELD(Document Type))
                            ELSE IF (Document Type=FILTER(Loan)) "File Detail"."File No." WHERE (Loan No.=FILTER(<>''));

            trigger OnValidate()
            begin
                FileDetail.RESET();
                FileDetail.SETRANGE("File No.",Rec."File No.");
                IF FileDetail.FINDFIRST() THEN
                  Rec."Loan No.":=FileDetail."Loan No.";
            end;
        }
        field(10;"Rack Location";Code[20])
        {
            TableRelation = Location;
        }
        field(20;"Room No.";Code[10])
        {
            TableRelation = "Room - File Mgmt"."Room Code" WHERE (Location Code=FIELD(Rack Location));
        }
        field(21;"Rack No.";Code[10])
        {
            TableRelation = "Rack - File Mgmt"."Rack Code" WHERE (Location Code=FIELD(Rack Location),
                                                                  Room Code=FIELD(Room No.));
        }
        field(22;"Sub Rack No.";Code[10])
        {
            TableRelation = "SubRack - File Mgmt"."Sub Rack Code" WHERE (Location Code=FIELD(Rack Location),
                                                                         Room Code=FIELD(Room No.),
                                                                         Rack Code=FIELD(Rack No.));
        }
        field(23;"User ID";Code[50])
        {
            Editable = false;
        }
        field(24;"Entry Type";Option)
        {
            OptionCaption = 'Initial,Transfer';
            OptionMembers = Initial,Transfer;
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
        field(31;"Loan No.";Code[20])
        {
        }
        field(32;"Issued Date";Date)
        {
        }
        field(33;"Expected Received Date";Date)
        {
        }
        field(34;Reason;Text[250])
        {
        }
        field(35;"Received Date";Date)
        {
        }
        field(36;"Responsible Person";Code[50])
        {
            TableRelation = Employee;
        }
        field(37;"External Transfer";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"File No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := USERID;
    end;

    var
        FileDetail: Record "33020798";
}

