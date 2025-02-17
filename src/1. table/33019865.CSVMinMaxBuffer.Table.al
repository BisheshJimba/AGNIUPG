table 33019865 "CSV MinMax Buffer"
{

    fields
    {
        field(1; "Location Code"; Code[10])
        {
        }
        field(2; "Item No."; Code[20])
        {
        }
        field(3; "Variant Code"; Code[20])
        {
        }
        field(4; Description; Text[30])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Item No.)));
            FieldClass = FlowField;
        }
        field(5;"Reorder Point";Decimal)
        {
        }
        field(6;"Maximum Inventory";Decimal)
        {
        }
        field(7;"Replenishment System";Option)
        {
            OptionCaption = 'Purchase,Prod. Order,Transfer';
            OptionMembers = Purchase,"Prod. Order",Transfer;
        }
        field(8;"Reordering Policy";Option)
        {
            OptionMembers = "Reordering Policy";
        }
        field(9;"Safety Stock Quantity";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Location Code","Item No.","Variant Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

