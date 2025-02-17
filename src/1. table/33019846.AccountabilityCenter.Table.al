table 33019846 "Accountability Center"
{
    Caption = 'Accountability Center';
    DrillDownPageID = 33020051;
    LookupPageID = 33020051;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(4; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(5; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(6; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code");
            end;
        }
        field(7; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = Country/Region;
        }
        field(8;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(9;"Fax No.";Text[30])
        {
            Caption = 'Fax No.';
        }
        field(10;"Name 2";Text[50])
        {
            Caption = 'Name 2';
        }
        field(11;Contact;Text[50])
        {
            Caption = 'Contact';
        }
        field(12;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(13;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(14;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(15;County;Text[30])
        {
            Caption = 'County';
        }
        field(102;"E-Mail";Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103;"Home Page";Text[90])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(5900;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5901;"Contract Gain/Loss Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Contract Gain/Loss Entry".Amount WHERE (Responsibility Center=FIELD(Code),
                                                                       Change Date=FIELD(Date Filter)));
            Caption = 'Contract Gain/Loss Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000;"Post Box No.";Code[20])
        {
        }
        field(50001;"Payment Method Code";Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(50002;"Default Debit Note for Sales";Boolean)
        {
        }
        field(50003;"Skip Credit Limit Check";Boolean)
        {
            Description = '//Specially for Vehicle Finance';
        }
        field(33019810;"Advance Booking Batch";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Advance Booking Template));
        }
        field(33019811;"Advance Booking Template";Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(33019832;"Sales Quote Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019833;"Sales Blanket Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019834;"Sales Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019835;"Sales Return Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019836;"Sales Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019837;"Sales Posted Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019838;"Sales Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019839;"Sales Posted Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019840;"Sales Posted Shipment Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019841;"Purch. Quote Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019842;"Purch. Blanket Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019843;"Purch. Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019844;"Purch. Return Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019845;"Purch. Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019846;"Purch. Posted Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019847;"Purch. Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019848;"Purch. Posted Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019849;"Purch. Posted Receipt Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019850;"Serv. Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019851;"Serv. Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019852;"Serv. Posted Invoice Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019853;"Serv. Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019854;"Serv. Posted Credit Memo Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019855;"Trans. Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019856;"Posted Transfer Shpt. Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019857;"Posted Transfer Rcpt. Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019858;"Purch. Posted Prept. Inv. Nos.";Code[10])
        {
            Caption = 'Purch. Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(33019859;"Purch. Ptd. Prept. Cr. M. Nos.";Code[10])
        {
            Caption = 'Purch. Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(33019860;"Purch. Ptd. Return Shpt. Nos.";Code[10])
        {
            Caption = 'Purch. Posted Return Shpt. Nos.';
            TableRelation = "No. Series";
        }
        field(33019861;"Sales Posted Prepmt. Inv. Nos.";Code[10])
        {
            Caption = 'Sales Posted Prepmt. Inv. Nos.';
            TableRelation = "No. Series";
        }
        field(33019862;"Sales Ptd. Prept. Cr. M. Nos.";Code[10])
        {
            Caption = 'Sales Posted Prepmt. Cr. Memo Nos.';
            TableRelation = "No. Series";
        }
        field(33019863;"Sales Ptd. Return Receipt Nos.";Code[10])
        {
            Caption = 'Sales Posted Return Receipt Nos.';
            TableRelation = "No. Series";
        }
        field(33019864;"Serv. Booking Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019865;"Serv. Posted Order Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019867;"Sales Posted Debit Note Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019868;"Serv. Quote Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019869;"Customer Complain Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019870;"Membership Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019871;"Debit Note Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019872;"Credit Note Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019873;"Import Purch. Order Nos.";Code[10])
        {
            Description = 'Orders';
            TableRelation = "No. Series";
        }
        field(33019874;"Import Purch. Invoice Nos.";Code[10])
        {
            Description = 'Invoice';
            TableRelation = "No. Series";
        }
        field(33019875;"Import Purch. Credit Memo Nos.";Code[10])
        {
            Description = 'Credit Memos';
            TableRelation = "No. Series";
        }
        field(33019876;"Import Purch. Posted Inv Nos.";Code[10])
        {
            Description = 'Posted Purchase Invoice';
            TableRelation = "No. Series";
        }
        field(33019877;"Import Purch. Posted Rcpt Nos.";Code[10])
        {
            Description = 'Posted Purchase Receipts';
            TableRelation = "No. Series";
        }
        field(33019878;"Import Purch. Posted Cr.Nos.";Code[10])
        {
            Description = 'Posted Purchase Credit Memo';
            TableRelation = "No. Series";
        }
        field(33019879;"Import Purch. Ret. Order Nos.";Code[10])
        {
            Description = 'Purchase Return Order';
            TableRelation = "No. Series";
        }
        field(33019880;"Import Posted Purch. Ret. Nos.";Code[10])
        {
            Description = 'Posted Purch. Return Order';
            TableRelation = "No. Series";
        }
        field(33019882;"CDIF Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(33019883;Block;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DimMgt.DeleteDefaultDim(DATABASE::"Accountability Center",Code);
    end;

    var
        PostCode: Record "225";
        DimMgt: Codeunit "408";

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Accountability Center",Code,FieldNumber,ShortcutDimCode); //Agni
        MODIFY;
    end;
}

