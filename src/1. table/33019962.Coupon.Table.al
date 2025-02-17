table 33019962 Coupon
{
    Caption = 'Coupan';

    fields
    {
        field(1; "Code"; Code[20])
        {

            trigger OnValidate()
            begin
                IF Code <> xRec.Code THEN BEGIN
                    GblAdminSetup.GET;
                    GblNoSeriesMngt.TestManual(GblAdminSetup."Coupon Mst. No.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Petrol Pump Code"; Code[20])
        {
            TableRelation = Vendor.No. WHERE(Blocked = FILTER(<> All));

            trigger OnValidate()
            begin
                CALCFIELDS("Petrol Pump Name");
            end;
        }
        field(3; "Petrol Pump Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE(No.=FIELD(Petrol Pump Code)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(4; "Range From"; Code[10])
        {
        }
        field(5; "Range To"; Code[10])
        {
        }
        field(6; "Last Issued No."; Code[10])
        {
            Editable = false;
        }
        field(7; Open; Boolean)
        {
        }
        field(8; Location; Code[10])
        {
            TableRelation = "Location - Admin".Code;
        }
        field(9; "Starting Date"; Date)
        {
        }
        field(10; "Last Issued Date"; Date)
        {
        }
        field(11; "Responsibility Center"; Code[10])
        {
        }
        field(12; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF Code = '' THEN BEGIN
            GblAdminSetup.GET;
            GblAdminSetup.TESTFIELD("Coupon Mst. No.");
            GblNoSeriesMngt.InitSeries(GblAdminSetup."Coupon Mst. No.", xRec."No. Series", 0D, Code, "No. Series");
        END;

        GblUserSetup.GET(USERID);
        "Responsibility Center" := GblUserSetup."Default Responsibility Center";
        "Accountability Center" := GblUserSetup."Default Accountability Center";
    end;

    var
        GblUserSetup: Record "91";
        GblAdminSetup: Record "33019964";
        GblNoSeriesMngt: Codeunit "396";
        GblCoupon: Record "33019962";

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        GblCoupon := Rec;
        GblAdminSetup.GET;
        GblAdminSetup.TESTFIELD("Coupon Mst. No.");
        IF GblNoSeriesMngt.SelectSeries(GblAdminSetup."Coupon Mst. No.", xRec."No. Series", GblCoupon."No. Series") THEN BEGIN
            GblAdminSetup.GET;
            GblAdminSetup.TESTFIELD("Coupon Mst. No.");
            GblNoSeriesMngt.SetSeries(GblCoupon.Code);
            Rec := GblCoupon;
            EXIT(TRUE);
        END;
    end;
}

