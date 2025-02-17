table 25006179 "Vehicle Tire Position"
{
    Caption = 'Vehicle Tire Position';
    LookupPageID = 25006277;

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(20; "Axle Code"; Code[10])
        {
            Caption = 'Axle Code';
            TableRelation = "Vehicle Axle".Code WHERE(Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(30; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(40; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(50; Available; Boolean)
        {
            CalcFormula = - Exist("Tire Entry" WHERE(Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                     Vehicle Axle Code=FIELD(Axle Code),
                                                     Tire Position Code=FIELD(Code),
                                                     Open=CONST(Yes)));
            Caption = 'Available';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Vehicle Serial No.","Axle Code","Code")
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
        TireEntry.SETRANGE("Vehicle Axle Code", "Axle Code");
        TireEntry.SETRANGE("Tire Position Code", Code);
        IF TireEntry.FINDFIRST THEN
          ERROR(Text001, Rec.TABLECAPTION, Code, TireEntry.TABLECAPTION);
    end;

    var
        TireEntry: Record "25006181";
        Text001: Label 'You cannot delete %1 %2 because there are one or records in %3.';
}

