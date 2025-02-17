table 25006178 "Vehicle Axle"
{
    Caption = 'Vehicle Axle';
    LookupPageID = 25006276;

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(40; Available; Boolean)
        {
            CalcFormula = Exist("Vehicle Tire Position" WHERE(Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                               Axle Code=FIELD(Code),
                                                               Available=CONST(Yes)));
            Caption = 'Available';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Vehicle Serial No.","Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TireEntry.RESET;
        TireEntry.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        TireEntry.SETRANGE("Vehicle Axle Code", Code);
        IF TireEntry.FINDFIRST THEN
          ERROR(Text001, Rec.TABLECAPTION, "Vehicle Serial No." + ' ' + Code, TireEntry.TABLECAPTION);
        VehicleTirePosition.RESET;
        VehicleTirePosition.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleTirePosition.SETRANGE("Axle Code", Code);
        VehicleTirePosition.DELETEALL(TRUE);
    end;

    var
        TireEntry: Record "25006181";
        Text001: Label 'You cannot delete %1 %2 because there are records in related %3.';
        VehicleTirePosition: Record "25006179";
}

