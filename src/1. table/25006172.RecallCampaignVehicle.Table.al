table 25006172 "Recall Campaign Vehicle"
{
    Caption = 'Recall Campaign Vehicle';

    fields
    {
        field(10; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = "Recall Campaign";
        }
        field(20; VIN; Code[20])
        {
            Caption = 'VIN';

            trigger OnLookup()
            begin
                Vehicle.RESET;
                Vehicle.SETCURRENTKEY(VIN);
                Vehicle.SETRANGE(VIN);
                IF Vehicle.FINDFIRST THEN;
                IF LookUpMgt.LookUpVehicleAMT(Vehicle, Vehicle."Serial No.") THEN
                    VALIDATE(VIN, Vehicle.VIN);
            end;
        }
        field(40; Exists; Boolean)
        {
            CalcFormula = Exist(Vehicle WHERE(VIN = FIELD(VIN)));
            Caption = 'Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; Serviced; Boolean)
        {
            Caption = 'Serviced';
        }
        field(60; "Active Campaign"; Boolean)
        {
            CalcFormula = Lookup("Recall Campaign".Active WHERE(No.=FIELD(Campaign No.)));
            Caption = 'Active Campaign';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Campaign No.",VIN)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        LookUpMgt: Codeunit "25006003";
        Vehicle: Record "25006005";
}

