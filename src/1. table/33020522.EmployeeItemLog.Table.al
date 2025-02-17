table 33020522 "Employee Item Log"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(3; Description; Text[30])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;Quantity;Decimal)
        {
        }
        field(5;Remarks;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

