table 33019818 "Posted Vendor Comp. Header"
{

    fields
    {
        field(1; "Fiscal Year"; Code[10])
        {
            Description = 'Lookup from Calender table.';
            NotBlank = true;
        }
        field(2; "Item Product Group"; Code[10])
        {
            NotBlank = true;
            TableRelation = "Product Group".Code;
        }
        field(3; "Chart No."; Integer)
        {
            NotBlank = true;
        }
        field(4; "Vendor 1 Total"; Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 1" WHERE(Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Vendor 2 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 2" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Vendor 3 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 3" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Vendor 4 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 4" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Vendor 5 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 5" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Vendor 6 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 6" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Vendor 7 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 7" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Vendor 8 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 8" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Vendor 9 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 9" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                           Item Product Group=FIELD(Item Product Group),
                                                                           Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;"Vendor 10 Total";Decimal)
        {
            CalcFormula = Sum("Posted Vendor Comp. Line"."Vendor 10" WHERE (Fiscal Year=FIELD(Fiscal Year),
                                                                            Item Product Group=FIELD(Item Product Group),
                                                                            Chart No.=FIELD(Chart No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Fiscal Year","Item Product Group","Chart No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblStplSysMngt: Codeunit "50000";
}

