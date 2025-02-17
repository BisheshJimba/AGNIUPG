table 33019968 "Lost Coupon"
{
    Caption = 'Lost Coupan';

    fields
    {
        field(1; "Code"; Code[10])
        {
            TableRelation = Coupon.Code;
        }
        field(2; "Coupon No."; Code[20])
        {
        }
        field(3; Remarks; Text[120])
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Coupon No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

