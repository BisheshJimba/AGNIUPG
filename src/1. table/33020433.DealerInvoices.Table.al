table 33020433 "Dealer Invoices"
{
    DrillDownPageID = 50038;
    LookupPageID = 50038;

    fields
    {
        field(1; "Row Type"; Option)
        {
            OptionCaption = 'Document Header,Document Lines';
            OptionMembers = "Document Header","Document Lines";
        }
        field(2; "Dealer Code"; Code[20])
        {
        }
        field(3; "Document Type"; Option)
        {
            OptionCaption = 'Sales Invoice,Sales Credit Memo';
            OptionMembers = "Sales Invoice","Sales Credit Memo";
        }
        field(4; "Document No."; Code[20])
        {
        }
        field(5; "Line No."; Integer)
        {
        }
        field(30; "Sell-to Customer Code"; Code[20])
        {
        }
        field(40; "Sell-To Customer Name"; Text[50])
        {
        }
        field(50; "Bill-to Customer Code"; Code[20])
        {
        }
        field(60; "Bill-to Customer Name"; Text[50])
        {
        }
        field(70; "Posting Date"; Date)
        {
        }
        field(71; "Dealer Name"; Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE(No.=FIELD(Dealer Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(72;"Total Amount";Decimal)
        {
            CalcFormula = Sum("Dealer Invoices".Amount WHERE (Row Type=CONST(Document Lines),
                                                              Dealer Code=FIELD(Dealer Code),
                                                              Document Type=FIELD(Document Type),
                                                              Document No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(73;"Total Amount Incl. VAT";Decimal)
        {
            CalcFormula = Sum("Dealer Invoices"."Amount Including VAT" WHERE (Row Type=CONST(Document Lines),
                                                                              Dealer Code=FIELD(Dealer Code),
                                                                              Document Type=FIELD(Document Type),
                                                                              Document No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(74;"Invoice Discount Amount";Decimal)
        {
            CalcFormula = Sum("Dealer Invoices"."Inv. Discount Amount" WHERE (Row Type=CONST(Document Lines),
                                                                              Dealer Code=FIELD(Dealer Code),
                                                                              Document Type=FIELD(Document Type),
                                                                              Document No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(75;"Document Profile";Option)
        {
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(76;"Customer Address";Text[50])
        {
        }
        field(77;"Customer Phone No.";Text[30])
        {
        }
        field(78;"HMI Coupon No.";Code[20])
        {
        }
        field(79;"STC Coupon No.";Code[20])
        {
        }
        field(80;"Scratch Coupon No.";Code[50])
        {
        }
        field(81;"Scratch Coupon Disc. Amount";Decimal)
        {
        }
        field(1001;Type;Option)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";
        }
        field(1002;"No.";Code[20])
        {
        }
        field(1003;"Location Code";Code[10])
        {
        }
        field(1004;"Location Name";Text[50])
        {
        }
        field(1005;"Line Description";Text[50])
        {
        }
        field(1006;Quantity;Decimal)
        {
        }
        field(1007;"Unit Price";Decimal)
        {
        }
        field(1008;"Line Discount Amount";Decimal)
        {
        }
        field(1009;Amount;Decimal)
        {
        }
        field(1010;"Amount Including VAT";Decimal)
        {
        }
        field(1011;"Inv. Discount Amount";Decimal)
        {
        }
        field(1012;"Unit of Measure Code";Code[10])
        {
        }
        field(1013;"Item Category Code";Code[20])
        {
        }
        field(1014;"Make Code";Code[20])
        {
        }
        field(1015;"Model Code";Code[20])
        {
        }
        field(1016;"Model Version No.";Code[20])
        {
        }
        field(1017;"Vehicle Serial No.";Code[20])
        {
        }
        field(1018;"Variant Code";Code[20])
        {
        }
        field(1019;"Registration No.";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Row Type","Dealer Code","Document Type","Document No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

