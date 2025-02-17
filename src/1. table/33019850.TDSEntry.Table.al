table 33019850 "TDS Entry"
{
    DrillDownPageID = 33020061;
    LookupPageID = 33020061;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = false;
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            Editable = true;
            TableRelation = "Gen. Business Posting Group";
        }
        field(3; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = true;
            TableRelation = "Gen. Product Posting Group";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = true;
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(6; "Document Type"; Option)
        {
            Caption = 'Document Type';
            Editable = false;
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(7; "Source Type"; Option)
        {
            Caption = 'Type';
            Editable = true;
            OptionCaption = ' ,Vendor,Customer';
            OptionMembers = " ",Vendor,Customer;
        }
        field(8; Base; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Base';
            Editable = true;
        }
        field(9; "TDS Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = true;
        }
        field(10; "Bill-to/Pay-to No."; Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';
            Editable = true;
            TableRelation = IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Customer)) Customer;

            trigger OnValidate()
            begin

                /*VALIDATE(Type);
                IF "Bill-to/Pay-to No." = '' THEN BEGIN
                  "Country/Region Code" := '';
                  "VAT Registration No." := '';
                END ELSE
                  CASE Type OF
                    Type::Purchase:
                      BEGIN
                        Vend.GET("Bill-to/Pay-to No.");
                        "Country/Region Code" := Vend."Country/Region Code";
                        "VAT Registration No." := Vend."VAT Registration No.";
                      END;
                    Type::Sale:
                      BEGIN
                        Cust.GET("Bill-to/Pay-to No.");
                        "Country/Region Code" := Cust."Country/Region Code";
                        "VAT Registration No." := Cust."VAT Registration No.";
                      END;
                  END;
                */

            end;
        }
        field(11; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
                /*
                LoginMgt.LookupUserID("User ID");
                */

            end;
        }
        field(12; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(13; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = Country/Region;

            trigger OnValidate()
            begin
                /*
                VALIDATE(Type);
                VALIDATE("VAT Registration No.");
                */

            end;
        }
        field(14;"Transaction No.";Integer)
        {
            Caption = 'Transaction No.';
            Editable = false;
        }
        field(15;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
            Editable = false;
        }
        field(16;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(17;"Document Date";Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(18;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(19;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(20;"TDS Posting Group";Code[20])
        {
            Editable = false;
        }
        field(21;"TDS%";Decimal)
        {
            Editable = false;
        }
        field(22;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(23;"Shortcut Dimension 3 Code";Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(0));
        }
        field(24;"TDS Type";Option)
        {
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(25;"Reversed Entry No.";Integer)
        {
        }
        field(26;Reversed;Boolean)
        {
        }
        field(27;"Reversed by Entry No.";Integer)
        {
        }
        field(28;Closed;Boolean)
        {
        }
        field(29;"Vendor Name";Text[50])
        {
        }
        field(30;"GL Account Name";Text[50])
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
            SumIndexFields = "TDS Amount",Base;
        }
        key(Key2;"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","TDS Posting Group","Posting Date")
        {
        }
        key(Key3;"TDS Posting Group")
        {
        }
        key(Key4;"Document No.")
        {
        }
        key(Key5;"Transaction No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        UserSetup.GET(USERID);
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID",USERID);
        IF UserSetup.FINDFIRST THEN BEGIN
          "Accountability Center" := UserSetup."Default Accountability Center";
        END;
    end;

    var
        UserSetup: Record "91";

    [Scope('Internal')]
    procedure Navigate()
    var
        NavigateForm: Page "344";
    begin
        //TDS2.00
        NavigateForm.SetDoc("Posting Date","Document No.");
        NavigateForm.RUN;
    end;
}

