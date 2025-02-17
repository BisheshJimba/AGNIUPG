table 33020177 "Generated Coupon"
{
    DrillDownPageID = 33020074;

    fields
    {
        field(1; "Entry No."; Code[20])
        {
            TableRelation = "Coupon Registration".No.;
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Coupon Code"; Code[20])
        {
            Editable = false;
        }
        field(4; Issued; Boolean)
        {
            Editable = false;
        }
        field(5; "Issued Date"; Date)
        {
            Editable = false;
        }
        field(6; "Issue No."; Code[20])
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Line"."Document No" WHERE(Petrol Pump Code=FIELD(Petrol Pump Code),
                                                                               Coupon Code=FIELD(Coupon Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Petrol Pump Code";Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(8;"Registration Date";Date)
        {
            CalcFormula = Lookup("Coupon Registration"."Registration Date" WHERE (No.=FIELD(Entry No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;Selected;Boolean)
        {
            Description = '//Selection of Coupon on Memo';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Entry No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Petrol Pump Code","Coupon Code",Issued)
        {
        }
    }

    fieldgroups
    {
    }
}

