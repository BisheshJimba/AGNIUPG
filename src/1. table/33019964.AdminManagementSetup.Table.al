table 33019964 "Admin. Management Setup"
{
    Caption = 'Admin. Management Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Coupon No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3; "Cash No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Stock No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Transfer No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Transfer Receipt No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Transfer Shipment No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Return Shipment No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; "Return No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Add. Fuel Limit %"; Decimal)
        {
        }
        field(14; "Add. Fuel Limit"; Decimal)
        {
        }
        field(15; "Gatepass Vehicle Trade No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(16; "Gatepass Vehicle Service No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(17; "Gatepass Spares No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(18; "Gatepass Admin Trade No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(19; "Coupon Mst. No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50000; "Vehicle GatePass"; Code[10])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

