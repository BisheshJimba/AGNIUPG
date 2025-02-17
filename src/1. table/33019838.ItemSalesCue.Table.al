table 33019838 "Item Sales Cue"
{

    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(2; "Location Code"; Code[20])
        {
            Editable = false;
            TableRelation = Location;
        }
        field(3; "Total Sales Quantity"; Decimal)
        {
            CalcFormula = - Sum("Value Entry"."Invoiced Quantity" WHERE(Item No.=FIELD(Item No.),
                                                                        Item Ledger Entry Type=FILTER(Sale),
                                                                        Location Code=FIELD(Location Code),
                                                                        Posting Date=FIELD(Date Filter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Total Sales Amount";Decimal)
        {
            CalcFormula = Sum("Value Entry"."Sales Amount (Actual)" WHERE (Item No.=FIELD(Item No.),
                                                                           Item Ledger Entry Type=FILTER(Sale),
                                                                           Location Code=FIELD(Location Code),
                                                                           Posting Date=FIELD(Date Filter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(30;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(31;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            FieldClass = FlowFilter;
            TableRelation = "Item Category";
        }
        field(32;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            FieldClass = FlowFilter;
            TableRelation = "Gen. Product Posting Group";
        }
        field(33;"Posting Date From";Date)
        {
        }
        field(34;"Posting Date To";Date)
        {
        }
        field(35;"Reorder Point";Decimal)
        {
            CalcFormula = Lookup("Stockkeeping Unit"."Reorder Point" WHERE (Item No.=FIELD(Item No.),
                                                                            Location Code=FIELD(Location Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(36;"Reorder Quantity";Decimal)
        {
            CalcFormula = Lookup("Stockkeeping Unit"."Reorder Quantity" WHERE (Item No.=FIELD(Item No.),
                                                                               Location Code=FIELD(Location Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(37;"Max Order Quantity";Decimal)
        {
            CalcFormula = Lookup("Stockkeeping Unit"."Maximum Order Quantity" WHERE (Item No.=FIELD(Item No.),
                                                                                     Location Code=FIELD(Location Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(Item No.),
                                                                  Location Code=FIELD(Location Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39;"Item Description";Text[30])
        {
            CalcFormula = Lookup(Item.Description WHERE (No.=FIELD(Item No.)));
            FieldClass = FlowField;
        }
        field(40;"Average Issue";Decimal)
        {
            CalcFormula = Lookup("Stockkeeping Unit"."Average Issue Per Month" WHERE (Item No.=FIELD(Item No.),
                                                                                      Location Code=FIELD(Location Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41;"Issue Qty From Opening";Decimal)
        {
            CalcFormula = Lookup("Item Issue Opening"."Issue Qty." WHERE (Location Code=FIELD(Location Code),
                                                                          Item No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42;"Opening Data Valid From";Date)
        {
            CalcFormula = Lookup("Item Issue Opening"."Valid From" WHERE (Location Code=FIELD(Location Code),
                                                                          Item No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(43;"Opening Data Valid To";Date)
        {
            CalcFormula = Lookup("Item Issue Opening"."Valid To" WHERE (Location Code=FIELD(Location Code),
                                                                        Item No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Item No.","Location Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

