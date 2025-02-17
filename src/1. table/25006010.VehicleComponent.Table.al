table 25006010 "Vehicle Component"
{
    Caption = 'Vehicle Component';
    DrillDownPageID = 25006030;
    LookupPageID = 25006030;

    fields
    {
        field(10; "Parent Vehicle Serial No."; Code[20])
        {
            Caption = 'Parent Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(15; "Line No."; Integer)
        {
            Caption = 'Line No.';

            trigger OnValidate()
            begin
                IF "Line No." = 0 THEN BEGIN
                    VehicleComponent.RESET;
                    VehicleComponent.SETRANGE("Parent Vehicle Serial No.", "Parent Vehicle Serial No.");
                    IF VehicleComponent.FINDLAST THEN
                        "Line No." := VehicleComponent."Line No.";
                    "Line No." += 10000;
                END;
            end;
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            begin
                IF "No." <> '' THEN BEGIN
                    IF Description = '' THEN BEGIN
                        Vehicle.GET("No.");
                        Description := Vehicle."Make Code" + ' ' + Vehicle."Model Code";
                    END;
                    IF "Date Installed" = 0D THEN
                        "Date Installed" := TODAY;
                END;
                IF "No." = "Parent Vehicle Serial No." THEN
                    ERROR(Text001);
            end;
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(40; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(50; "Date Installed"; Date)
        {
            Caption = 'Date Installed';
        }
        field(60; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
        }
    }

    keys
    {
        key(Key1; "Parent Vehicle Serial No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        VALIDATE(Active, TRUE);
        VALIDATE("Line No.");
        TESTFIELD("Parent Vehicle Serial No.");
    end;

    trigger OnModify()
    begin
        VALIDATE("Last Date Modified", TODAY);
    end;

    var
        Vehicle: Record Vehicle;
        VehicleComponent: Record "Vehicle Component";
        Text001: Label 'Parent and component the same is unpossible.';
}

