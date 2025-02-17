table 33020174 "Vehicle Registration Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            TableRelation = "Vehicle Registration Header".No.;
        }
        field(3; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';

            trigger OnLookup()
            var
                RecVehicle: Record "25006005";
                VehicleList: Page "25006033";
            begin
                CLEAR(VehicleList);
                IF "Serial No." <> '' THEN BEGIN
                    IF RecVehicle.GET("Serial No.") THEN BEGIN
                        IF RecVehicle."Sahamati Location" = '' THEN BEGIN //**SM 15-08-2013 as registration is done more than once for the sahamati vehicles
                            VehicleList.SETRECORD(RecVehicle);
                            RecVehicle.SETRANGE(Registered, FALSE);
                            VehicleList.SETTABLEVIEW(RecVehicle);
                        END;
                    END;
                END;

                VehicleList.LOOKUPMODE(TRUE);
                IF VehicleList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    VehicleList.GETRECORD(RecVehicle);
                    VALIDATE("Serial No.", RecVehicle."Serial No.");
                    VIN := RecVehicle.VIN;
                    "Make Code" := RecVehicle."Make Code";
                    "Model Code" := RecVehicle."Model Code";
                    "Model Version No." := RecVehicle."Model Version No.";
                    "DRP No./ARE1 No." := RecVehicle."DRP No./ARE1 No.";
                    "Engine No." := RecVehicle."Engine No.";
                END;
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
                tcDMS001: Label 'You can not delete value of %1 field !';
                tcDMS002: Label 'Vehicle %1 %2 already exists!';
            begin
            end;
        }
        field(4; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
        }
        field(5; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
        }
        field(6; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
        }
        field(7; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
            end;
        }
        field(9; "DRP No./ARE1 No."; Code[20])
        {
            Editable = false;
        }
        field(10; "Engine No."; Code[20])
        {
            Editable = false;
        }
        field(50000; "Vehicle Tax"; Decimal)
        {
        }
        field(50001; "Registration No."; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE(Serial No.=FIELD(Serial No.)));
            FieldClass = FlowField;
        }
        field(50002;"Income Tax";Decimal)
        {
        }
        field(50003;"Road Maintenance Fee";Decimal)
        {
        }
        field(50004;"Registration Fee";Decimal)
        {
        }
        field(50005;"Ownership Transfer Fee";Decimal)
        {
        }
        field(50006;"Other Fee";Decimal)
        {
        }
        field(50007;"Expected Expenses";Decimal)
        {
        }
        field(50008;"Purchase Order Created";Boolean)
        {
            Editable = false;
        }
        field(50009;Skip;Boolean)
        {
        }
        field(50010;"General Journal Created";Boolean)
        {
            CalcFormula = Exist("Gen. Journal Line" WHERE (Document No.=FIELD(Document No.),
                                                           Vehicle Serial No.=FIELD(Serial No.)));
            FieldClass = FlowField;
        }
        field(50011;"GL Entry Created";Boolean)
        {
            CalcFormula = Exist("G/L Entry" WHERE (Document No.=FIELD(Document No.),
                                                   Vehicle Serial No.=FIELD(Serial No.),
                                                   Reversed=CONST(No)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Document No.","Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

