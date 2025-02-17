table 33019887 "Battery Warranty"
{

    fields
    {
        field(1; "Battery Type"; Code[10])
        {
            TableRelation = "Product Subgroup".Code WHERE(Item Category Code=CONST(BATTERY));
        }
        field(2; "Vehicle Type"; Option)
        {
            OptionMembers = " ",BUS,CAR,TRACTOR,MOTORCYCLE,GENERATOR,UPS,INVERTER,JEEP,TAXI,PICKUP,TRUCK,"EARTH EQUIP",UNSOLD,INDUSTRIAL,"COMMERCIAL VEHICLES",OTHERS;
        }
        field(3; "Month From"; Decimal)
        {
        }
        field(4; "Month To"; Decimal)
        {
        }
        field(5; Warranty; Decimal)
        {
            Description = 'Warranty Percentage';
        }
    }

    keys
    {
        key(Key1; "Battery Type", "Vehicle Type", "Month From")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

