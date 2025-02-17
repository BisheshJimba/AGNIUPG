table 33020198 "Prospect Pipeline History"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
        }
        field(2; "New Pipeline Code"; Code[10])
        {
        }
        field(3; "New Date"; Date)
        {
        }
        field(4; "Old Date"; Date)
        {
        }
        field(5; "Old Pipeline Code"; Code[10])
        {
        }
        field(7; Remarks; Text[250])
        {
        }
        field(8; "SalesPerson Code"; Code[10])
        {
            TableRelation = Salesperson/Purchaser;
        }
        field(9;"Prospect Line No";Integer)
        {
        }
        field(17;KIN;Code[20])
        {
            TableRelation = "Salesperson KAP Details".KIN WHERE (Salesperson Code=FIELD(SalesPerson Code));
        }
        field(47;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(48;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(49;"Model Version No.";Code[20])
        {
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));
        }
    }

    keys
    {
        key(Key1;"Prospect No.","Prospect Line No","New Pipeline Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

