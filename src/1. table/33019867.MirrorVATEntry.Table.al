table 33019867 "Mirror VAT Entry"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            Editable = false;
            TableRelation = "Gen. Business Posting Group";
        }
        field(3; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = false;
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
        field(7; Type; Option)
        {
            Caption = 'Type';
            Editable = false;
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(8; Base; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Base';
            Editable = true;
        }
        field(9; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = true;
        }
        field(10; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(12; "Bill-to/Pay-to No."; Code[20])
        {
            Caption = 'Bill-to/Pay-to No.';
            TableRelation = IF (Type = CONST(Purchase)) Vendor
            ELSE
            IF (Type = CONST(Sale)) Customer;
        }
        field(13; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(14; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
            end;
        }
        field(15; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(16; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            Editable = false;
            TableRelation = "Reason Code";
        }
        field(17; "Closed by Entry No."; Integer)
        {
            Caption = 'Closed by Entry No.';
            Editable = false;
            TableRelation = "VAT Entry";
        }
        field(18; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(19; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = Country/Region;
        }
        field(20;"Internal Ref. No.";Text[30])
        {
            Caption = 'Internal Ref. No.';
            Editable = false;
        }
        field(21;"Transaction No.";Integer)
        {
            Caption = 'Transaction No.';
            Editable = false;
        }
        field(22;"Unrealized Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Unrealized Amount';
            Editable = false;
        }
        field(23;"Unrealized Base";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Unrealized Base';
            Editable = false;
        }
        field(24;"Remaining Unrealized Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Unrealized Amount';
            Editable = false;
        }
        field(25;"Remaining Unrealized Base";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Remaining Unrealized Base';
            Editable = false;
        }
        field(26;"External Document No.";Code[20])
        {
            Caption = 'External Document No.';
            Editable = false;
        }
        field(28;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(29;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            Editable = false;
            TableRelation = "Tax Area";
        }
        field(30;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';
            Editable = false;
        }
        field(31;"Tax Group Code";Code[10])
        {
            Caption = 'Tax Group Code';
            Editable = false;
            TableRelation = "Tax Group";
        }
        field(32;"Use Tax";Boolean)
        {
            Caption = 'Use Tax';
            Editable = false;
        }
        field(33;"Tax Jurisdiction Code";Code[10])
        {
            Caption = 'Tax Jurisdiction Code';
            Editable = false;
            TableRelation = "Tax Jurisdiction";
        }
        field(34;"Tax Group Used";Code[10])
        {
            Caption = 'Tax Group Used';
            Editable = false;
            TableRelation = "Tax Group";
        }
        field(35;"Tax Type";Option)
        {
            Caption = 'Tax Type';
            Editable = false;
            OptionCaption = 'Sales Tax,Excise Tax';
            OptionMembers = "Sales Tax","Excise Tax";
        }
        field(36;"Tax on Tax";Boolean)
        {
            Caption = 'Tax on Tax';
            Editable = false;
        }
        field(37;"Sales Tax Connection No.";Integer)
        {
            Caption = 'Sales Tax Connection No.';
            Editable = false;
        }
        field(38;"Unrealized VAT Entry No.";Integer)
        {
            Caption = 'Unrealized VAT Entry No.';
            Editable = false;
            TableRelation = "VAT Entry";
        }
        field(39;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            Editable = true;
            TableRelation = "VAT Business Posting Group";
        }
        field(40;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            Editable = false;
            TableRelation = "VAT Product Posting Group";
        }
        field(43;"Additional-Currency Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Additional-Currency Amount';
            Editable = false;
        }
        field(44;"Additional-Currency Base";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Additional-Currency Base';
            Editable = false;
        }
        field(45;"Add.-Currency Unrealized Amt.";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Currency Unrealized Amt.';
            Editable = false;
        }
        field(46;"Add.-Currency Unrealized Base";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Currency Unrealized Base';
            Editable = false;
        }
        field(48;"VAT Base Discount %";Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0:5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(49;"Add.-Curr. Rem. Unreal. Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Curr. Rem. Unreal. Amount';
            Editable = false;
        }
        field(50;"Add.-Curr. Rem. Unreal. Base";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Curr. Rem. Unreal. Base';
            Editable = false;
        }
        field(51;"VAT Difference";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(52;"Add.-Curr. VAT Difference";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Add.-Curr. VAT Difference';
            Editable = false;
        }
        field(53;"Ship-to/Order Address Code";Code[10])
        {
            Caption = 'Ship-to/Order Address Code';
            TableRelation = IF (Type=CONST(Purchase)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Type=CONST(Sale)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.));
        }
        field(54;"Document Date";Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(55;"VAT Registration No.";Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "381";
            begin
                VATRegNoFormat.Test("VAT Registration No.","Country/Region Code",'',0);
            end;
        }
        field(56;Reversed;Boolean)
        {
            Caption = 'Reversed';
        }
        field(57;"Reversed by Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Reversed by Entry No.';
            TableRelation = "VAT Entry";
        }
        field(58;"Reversed Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Reversed Entry No.';
            TableRelation = "VAT Entry";
        }
        field(50000;"Capital Expenditure";Boolean)
        {
        }
        field(50001;"Import Invoice No.";Code[20])
        {
            TableRelation = "Purch. Inv. Header".No.;
        }
        field(50500;"G/L Entry No.";Integer)
        {
            Description = 'To compare with Field no. 50501 data (for VAT report)';
            TableRelation = "G/L Entry"."Entry No.";
        }
        field(50501;"G/L Account No.";Code[20])
        {
            Description = 'For VAT report';
        }
        field(50502;"Item Ldgr No (Exempt Purchase)";Integer)
        {
            Description = 'For VAT report (basis to add Custom & Commerical Invoice of M&M Tractor)';
            FieldClass = Normal;
        }
        field(50503;"PP No. (Exempt Purchase)";Code[20])
        {
            Description = 'For VAT report (basis to add Custom & Commerical Invoice of M&M Tractor)';
            FieldClass = Normal;
        }
        field(50504;"Exempt Purchase No.";Code[20])
        {
            TableRelation = "Exempt Purchase Nos.";
        }
        field(50505;"Total Amt";Decimal)
        {
            CalcFormula = Sum("Mirror VAT Entry".Base WHERE (Exempt Purchase No.=FIELD(Exempt Purchase No.)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Exempt Purchase No.")
        {
            SumIndexFields = Base;
        }
    }

    fieldgroups
    {
    }
}

