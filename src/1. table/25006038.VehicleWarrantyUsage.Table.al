table 25006038 "Vehicle Warranty Usage"
{
    Caption = 'Vehicle Warranty Usage';

    fields
    {
        field(2; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(4; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(6;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                Item: Record "27";
            begin
                Item.RESET;
                IF LookUpMgt.LookUpModelVersion(Item,"Model Version No.","Make Code","Model Code") THEN
                  VALIDATE("Model Version No.",Item."No.");
            end;
        }
        field(8;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status";
        }
        field(20;"Warranty Type Code";Code[20])
        {
            Caption = 'Warranty Type Code';
            TableRelation = "Vehicle Warranty Type";

            trigger OnValidate()
            var
                VehicleWarrantyType: Record "25006035";
            begin
                IF VehicleWarrantyType.GET("Warranty Type Code") THEN BEGIN
                  "Term Date Formula" := VehicleWarrantyType."Term Date Formula";
                  "Kilometrage Limit" := VehicleWarrantyType."Variable Field Run 1";
                  "Variable Field Run 2" := VehicleWarrantyType."Variable Field Run 2";
                  "Variable Field Run 3" := VehicleWarrantyType."Variable Field Run 3";
                END;
            end;
        }
        field(30;"Term Date Formula";DateFormula)
        {
            Caption = 'Term Date Formula';
        }
        field(40;"Kilometrage Limit";Integer)
        {
        }
        field(41;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006038,41';
        }
        field(42;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006038,42';
        }
        field(33020235;"Spare Warranty";Boolean)
        {
        }
        field(33020236;Item;Code[20])
        {
            TableRelation = IF (Spare Warranty=CONST(Yes)) Item WHERE (Item Type=CONST(Item));
        }
        field(33020237;Description;Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Make Code","Model Code","Model Version No.","Vehicle Status Code","Warranty Type Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        LookUpMgt: Codeunit "25006003";
        VFMgt: Codeunit "25006004";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Vehicle Warranty Usage",intFieldNo));
    end;
}

