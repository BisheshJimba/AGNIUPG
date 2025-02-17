table 33020525 "Vehicle Order Detail & Stock"
{

    fields
    {
        field(1; "Model Version No."; Code[20])
        {
            TableRelation = Item.No. WHERE(Item Type=CONST(Model Version));
        }
        field(3; "LC Opening of Current Month"; Integer)
        {
        }
        field(4; "Intransit To Nepal"; Integer)
        {
        }
        field(7; "Total LC Price"; Decimal)
        {
        }
        field(50; "Make Code"; Code[20])
        {
            TableRelation = Make;
        }
        field(51; "Model Code"; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(100;"Location Code";Code[10])
        {
            TableRelation = Location;
        }
        field(101;"Location Type";Option)
        {
            OptionCaption = ' ,Vehicle Store (Inside Valley),Vehicle Store (Outside Valley),Showroom';
            OptionMembers = " ","Vehicle Store (Inside Valley)","Vehicle Store (Outside Valley)",Showroom;
        }
        field(500;"Real Stock";Integer)
        {
        }
        field(501;"Total Stock Value";Decimal)
        {
        }
        field(502;"Total Inventory Value";Decimal)
        {
        }
        field(503;"Total Vehicle";Integer)
        {
        }
        field(504;"Total TO";Integer)
        {
        }
        field(505;"Sales Order";Integer)
        {
        }
        field(506;"Safety Stock";Integer)
        {
        }
        field(507;"Transfer Order";Integer)
        {
        }
        field(508;Tender;Integer)
        {
        }
        field(509;"Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency code";
            AutoFormatType = 2;
        }
        field(510;"Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency code";
            AutoFormatType = 2;
        }
        field(511;"Currency code";Code[10])
        {
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1;"Model Version No.","Location Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

