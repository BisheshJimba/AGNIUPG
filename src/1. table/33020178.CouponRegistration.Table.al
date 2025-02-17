table 33020178 "Coupon Registration"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Registration Date"; Date)
        {
            Editable = false;
        }
        field(3; "Petrol Pump Code"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(4; "Petrol Pump Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "From Coupon No."; Code[20])
        {
            Editable = false;
        }
        field(6; "To Coupon No."; Code[20])
        {
            Editable = false;
        }
        field(7; "Total Coupons"; Integer)
        {
            CalcFormula = Count("Generated Coupon" WHERE(Entry No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Remaining Coupons";Integer)
        {
            CalcFormula = Count("Generated Coupon" WHERE (Entry No.=FIELD(No.),
                                                          Issued=CONST(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"No. Series";Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PurchaseSetup.GET;
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMngt.InitSeries(GetNoSeries,xRec."No. Series",0D,"No.","No. Series");
        END;
    end;

    var
        NoSeriesMngt: Codeunit "396";
        PurchaseSetup: Record "312";

    [Scope('Internal')]
    procedure AssistEdit(xCouponReg: Record "33020178"): Boolean
    begin
        PurchaseSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries,xCouponReg."No. Series","No. Series") THEN BEGIN
          PurchaseSetup.GET;
          TestNoSeries;
          NoSeriesMngt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        PurchaseSetup.TESTFIELD("Coupon Reg. No. Series");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(PurchaseSetup."Coupon Reg. No. Series");
    end;
}

