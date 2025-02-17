table 33020518 "Salary Post. Buffer"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*


    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(2; "Account Code"; Code[20])
        {
            Caption = 'G/L Account';
            TableRelation = IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Bank Account)) "Bank Account";
        }
        field(3; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(4; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(5; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
        }
        field(6; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(7; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(8; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(9; "Employee Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(10; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Salary Post. Buffer".Amount WHERE(Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                  Employee Code=FIELD(Employee Filter),
                                                                  Balancing Line=CONST(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Balancing Line";Boolean)
        {
        }
        field(12;"Document No.";Code[20])
        {
        }
        field(13;"TDS Group";Code[20])
        {
            TableRelation = "TDS Posting Group".Code;
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
        key(Key1;"Document No.",Type,"Account Code","Global Dimension 1 Code","Global Dimension 2 Code","Employee Code")
        {
            Clustered = true;
        }
        key(Key2;"Global Dimension 1 Code","Global Dimension 2 Code","Balancing Line")
        {
            SumIndexFields = Amount;
        }
        key(Key3;"Employee Code","Balancing Line")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }
}

