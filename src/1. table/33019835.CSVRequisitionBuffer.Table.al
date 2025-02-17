table 33019835 "CSV Requisition Buffer"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = false;
        }
        field(2; "Item No."; Code[20])
        {
            TableRelation = Item.No.;
        }
        field(3; "Order Quantity"; Decimal)
        {
        }
        field(4; "Item Description"; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;Vendor;Code[20])
        {
            TableRelation = Vendor.No.;
        }
    }

    keys
    {
        key(Key1;"Item No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

