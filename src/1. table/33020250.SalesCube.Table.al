table 33020250 "Sales Cube"
{

    fields
    {
        field(1; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(2; "Cost Revenue Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(3; Year; Integer)
        {
        }
        field(4; Month; Integer)
        {
        }
        field(5; Amount; Decimal)
        {
        }
        field(6; "Amount Including VAT"; Decimal)
        {
        }
        field(7; "VAT Amount"; Decimal)
        {
        }
        field(8; "Branch Name"; Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE(Code = FIELD(Branch Code),
                                                               Global Dimension No.=FILTER(1)));
            FieldClass = FlowField;
        }
        field(9;"Cost Revenue Name";Text[50])
        {
            CalcFormula = Lookup("Dimension Value".Name WHERE (Code=FIELD(Branch Code),
                                                               Global Dimension No.=FILTER(2)));
            FieldClass = FlowField;
        }
        field(10;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(50000;"System Created Entry";Boolean)
        {
        }
        field(50001;"Data Fetching Date";Date)
        {
        }
        field(50002;"Created By";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Branch Code","Cost Revenue Code",Year,Month,"Gen. Prod. Posting Group")
        {
            Clustered = true;
            SumIndexFields = Amount,"Amount Including VAT","VAT Amount";
        }
    }

    fieldgroups
    {
    }
}

